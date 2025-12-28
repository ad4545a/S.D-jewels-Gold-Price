import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'about_screen.dart';
import 'bank_screen.dart';
import 'contact_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  
  // Data Placeholders
  String _status = "Connecting...";
  bool _isConnected = true;
  Map<String, dynamic> _goldData = {};
  Map<String, dynamic> _silverData = {};
  Map<String, dynamic> _usdData = {};
  
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }
  
  @override
  void _activateListeners() {
    // Monitor Connection State
    _database.child('.info/connected').onValue.listen((event) {
      final connected = event.snapshot.value as bool? ?? false;
      if (mounted) {
        setState(() {
          _isConnected = connected;
        });
      }
    });

    _database.child('live_rates').onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          _status = data['status'] ?? "Live";
          _goldData = Map<String, dynamic>.from(data['gold'] ?? {});
          _silverData = Map<String, dynamic>.from(data['silver'] ?? {});
          _usdData = Map<String, dynamic>.from(data['usdinr'] ?? {});
        });
      }
    });
  }

  String _fmt(dynamic price) {
    if (price == null) return "---";
    if (price is String) return price; // Safety check
    final format = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    return format.format(price);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Prevent default Left-Side Menu
        title: Row(
          children: [
            Icon(Icons.diamond_outlined, color: Colors.amber[700]), 
            const SizedBox(width: 8),
            Text("S.D. JEWELS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.amber[700],
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.diamond_outlined, size: 50, color: Colors.white),
                    const SizedBox(height: 10),
                    const Text("S.D. JEWELS", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const Text("Agra's Trusted Bullion Dealer", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text("Live Rate"),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About Us"),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text("Bank Details"),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_support),
              title: const Text("Contact Us"),
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title: const Text("Rate Us"),
              onTap: () async {
                Navigator.pop(context);
                final Uri url = Uri.parse("https://play.google.com/store/apps/details?id=com.sdjewels.sd_jewels_app");
                 try {
                   await launchUrl(url, mode: LaunchMode.externalApplication);
                 } catch (e) {
                   debugPrint("Rate URL failed: $e");
                 }
              },
            ),
          ],
        ),
      ),
      // Switch Body based on Index
      body: _selectedIndex == 0 ? _buildLiveRates() : 
            _selectedIndex == 1 ? const AboutScreen() :
            _selectedIndex == 2 ? const BankScreen() :
            ContactScreen(),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed, // Fix for >3 items
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Live Rate"),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: "About Us"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: "Bank Details"),
          BottomNavigationBarItem(icon: Icon(Icons.contact_support), label: "Contact Us"),
        ],
      ),
    );
  }

  Widget _buildLiveRates() {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // No Internet Banner
            if (!_isConnected)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Icon(Icons.wifi_off, color: Colors.white, size: 20),
                     SizedBox(width: 8),
                     Text("No Internet Connection", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

            // Top Cards (INR/USD, Gold, Silver)
            Row(
              children: [
                Expanded(child: _buildTopCard("INR VS USD", "${_usdData['price']?.toStringAsFixed(2) ?? '83.50'}", "MCX", Colors.amber)),
                const SizedBox(width: 8),
                Expanded(child: _buildTopCard("GOLD", _fmt(_goldData['mcx_price']), "MCX", Colors.amber)),
                const SizedBox(width: 8),
                Expanded(child: _buildTopCard("SILVER", _fmt(_silverData['mcx_price']), "MCX", Colors.grey)),
              ],
            ),
            const SizedBox(height: 20),
            
            // Section Header
            _buildSectionHeader("Live Rates Table", isLive: true),
            const SizedBox(height: 10),
            
            // Rates Table
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.amber.shade200),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _buildTableHeader(),
                  _buildRateRow("Gold 99.50", _goldData['mcx_price'], _goldData['rate_9950'], _goldData['high'], _goldData['low']),
                  _buildRateRow("Silver 99.99", _silverData['mcx_price'], _silverData['rate_9999'], _silverData['high'], _silverData['low']),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Agra Local Rates
            _buildSectionHeader("Agra Local Rates"),
            const SizedBox(height: 10),
            _buildRateCard("RTGS Rates", "Gold RTGS", _fmt(_goldData['rate_999']), "Silver RTGS", _fmt(_silverData['rate_9999']), const Color(0xFFFFF8E1), Colors.amber[800]!),
            const SizedBox(height: 10),
            _buildRateCard("Cash Book", "Gold Cash", _fmt(_goldData['rate_9950']), "Silver Cash", _fmt(_silverData['rate_bars']), Colors.white, Colors.grey[700]!, isCash: true),
            
            const SizedBox(height: 20),
            _buildSectionHeader("Rajkot RTGS Prices"),
            const SizedBox(height: 10),
            _buildRateCard("RTGS Rates", "Gold RTGS", "63,200", "Silver RTGS", "73,150", const Color(0xFFFFF8E1), Colors.amber[800]!),
          ],
        ),
      );
  }

  Widget _buildTopCard(String title, String value, String change, Color color) {
    return Container(
      padding: const EdgeInsets.all(10), // Reduced padding for 3 cards
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          // const SizedBox(height: 2), // Compact
          // Text(change, style: const TextStyle(fontSize: 10, color: Colors.green)), 
          // Keeping it simple for small space
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool isLive = false}) {
    return Row(
      children: [
        Container(width: 4, height: 20, color: Colors.amber[700]),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        if (isLive) ...[
          const Spacer(),
          Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(_status, style: const TextStyle(color: Colors.grey)),
        ]
      ],
    );
  }
  
  Widget _buildTableHeader() {
      return Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          color: const Color(0xFFFFF8E1),
          child: Row(
              children: const [
                  Expanded(flex: 3, child: Text("PRODUCT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
                  Expanded(flex: 2, child: Text("M.PRICE", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
                  Expanded(flex: 2, child: Text("PREMIUM", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
                  Expanded(flex: 2, child: Text("PRICE", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
              ],
          ),
      );
  }

  Widget _buildRateRow(String product, dynamic mcx, dynamic price, dynamic high, dynamic low) {
      // Calculate Premium safely
      String premium = "0";
      try {
        if (mcx != null && price != null && mcx is num && price is num) {
           premium = (price - mcx).toStringAsFixed(0);
        }
      } catch (e) { premium = "-"; }

      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
              children: [
                  Expanded(
                    flex: 3, 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        Text("H:${_fmt(high)} L:${_fmt(low)}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    )
                  ),
                  Expanded(flex: 2, child: Text(_fmt(mcx), textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black54))),
                   Expanded(flex: 2, child: Text(premium, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87))),
                  Expanded(flex: 2, child: Text(_fmt(price), textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.amber[800]))),
              ],
          ),
      );
  }

  Widget _buildRateCard(String title, String l1, String v1, String l2, String v2, Color bg, Color iconColor, {bool isCash = false}) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: Colors.amber.shade100),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
           if(!isCash) BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset:const Offset(0, 2))
        ]
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Icon(isCash? Icons.money : Icons.account_balance, color: iconColor),
              const SizedBox(width: 10),
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: iconColor)),
              const Spacer(),
               if(!isCash) Container(
                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                   decoration: BoxDecoration(border: Border.all(color: Colors.amber), borderRadius: BorderRadius.circular(4)),
                   child: const Text("Bank Transfer", style: TextStyle(fontSize: 10, color: Colors.amber)),
               )
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l1, style: const TextStyle(color: Colors.grey)),
                  Text(v1, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(l2, style: const TextStyle(color: Colors.grey)),
                  Text(v2, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
