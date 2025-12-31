import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'about_screen.dart';
import 'bank_screen.dart';
import 'contact_screen.dart';
import 'contact_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'marquee_widget.dart';
import 'dart:async';

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

  Map<String, Color> _priceColors = {}; // Store colors for price changes
  final Map<String, Timer> _colorTimers = {}; // timers for resetting colors
  String _tickerText = "Welcome to S.D. Jewels"; // Default Text
  
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }
  
  @override
  void dispose() {
    for (var timer in _colorTimers.values) {
      timer.cancel();
    }
    super.dispose();
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
        final newGold = Map<String, dynamic>.from(data['gold'] ?? {});
        final newSilver = Map<String, dynamic>.from(data['silver'] ?? {});
        final newUsd = Map<String, dynamic>.from(data['usdinr'] ?? {});
        
        setState(() {
          _status = data['status'] ?? "Live";
          


          // Let's do it simpler without inline function to avoid closure confusion with map keys
          // Gold Checks
          _checkColor('gold_mcx_price', newGold['mcx_price'], _goldData['mcx_price']);
          _checkColor('gold_spot_price', newGold['spot_price'], _goldData['spot_price']);
          _checkColor('gold_rate_999', newGold['rate_999'], _goldData['rate_999']);
          _checkColor('gold_rate_9950', newGold['rate_9950'], _goldData['rate_9950']);
          
          // Silver Checks
          _checkColor('silver_spot_price', newSilver['spot_price'], _silverData['spot_price']);
          _checkColor('silver_mcx_price', newSilver['mcx_price'], _silverData['mcx_price']);
          _checkColor('silver_rate_9999', newSilver['rate_9999'], _silverData['rate_9999']);
          _checkColor('silver_rate_bars', newSilver['rate_bars'], _silverData['rate_bars']);
          
          // USD
          _checkColor('usd_price', newUsd['price'], _usdData['price']);

          _goldData = newGold;
          _silverData = newSilver;
          _usdData = newUsd;
        });
      }
    });

    // Monitor Ticker Text
    _database.child('admin_settings/ticker_text').onValue.listen((event) {
      final text = event.snapshot.value as String?;
      if (mounted) {
        setState(() {
          if (text == null || text.trim().isEmpty) {
            _tickerText = "Welcome to S.D. JEWELS - Agra's Trusted Bullion Dealer";
          } else {
            _tickerText = text;
          }
        });
      }
    });

  }

  void _checkColor(String key, dynamic newVal, dynamic oldVal) {
      if (newVal == null || oldVal == null) return;
      num n = newVal is num ? newVal : num.tryParse(newVal.toString()) ?? 0;
      num o = oldVal is num ? oldVal : num.tryParse(oldVal.toString()) ?? 0;
      
      if (o == 0) return; // Ignore initial 0 state
      
      if (n == o) return; // No change

      // Cancel existing timer
      _colorTimers[key]?.cancel();

      if (n > o) {
         _priceColors[key] = Colors.green;
      } else if (n < o) {
         _priceColors[key] = Colors.red;
      }
      
      // Set Timer to revert
      _colorTimers[key] = Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _priceColors.remove(key); // Remove color to revert to default
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB8860B), Color(0xFFFFD700), Color(0xFFB8860B)], // Gold Gradient
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB8860B), Color(0xFFFFD700), Color(0xFFB8860B)], // Gold Gradient
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.diamond_outlined, size: 50, color: Colors.white),
                    const SizedBox(height: 10),
                    const Text("S.D. JEWELS", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const Text("Agra's Trusted  Dealer", style: TextStyle(color: Colors.white70)),
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
              
            // Ticker Line
            Container(
              width: double.infinity,
              height: 30,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                border: Border.all(color: Colors.amber.shade200),
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.centerLeft,
              child: MarqueeWidget(
                text: _tickerText,
                style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
              ),
            ),

            // Top Cards (INR/USD, Gold, Silver)

            // Top Cards (INR/USD, Gold, Silver)
            Row(
              children: [
                Expanded(child: _buildTopCard("INR VS USD", "${_usdData['price']?.toStringAsFixed(2) ?? '83.50'}", "MCX", _priceColors['usd_price'] ?? Colors.amber)),
                const SizedBox(width: 8),
                Expanded(child: _buildTopCard("GOLD SPOT", "\$ ${_goldData['spot_price'] ?? '---'}", "INTL", _priceColors['gold_spot_price'] ?? Colors.black)),
                const SizedBox(width: 8),
                Expanded(child: _buildTopCard("SILVER SPOT", "\$ ${_silverData['spot_price'] ?? '---'}", "INTL", _priceColors['silver_spot_price'] ?? Colors.black)),
              ],
            ),
            const SizedBox(height: 20),
            
            // Live Rates Header
            _buildSectionHeader("Live Rates", isLive: true),
            const SizedBox(height: 10),
            
            // Gold Live
            _buildSingleRateCard(
              "Gold 99.50", 
              mcx: _fmt(_goldData['mcx_price']), 
              value: _fmt(_goldData['rate_9950']), 
              bg: const Color(0xFFFFECB3), iconColor: Colors.black,
              icon: Icons.bar_chart,
              prem: (_goldData['rate_9950'] ?? 0) - (_goldData['mcx_price'] ?? 0),
              high: _fmt(_goldData['high']), low: _fmt(_goldData['low']),
              valueColor: _priceColors['gold_rate_9950']
            ),
            const SizedBox(height: 10),
            
            // Silver Live
            _buildSingleRateCard(
              "Silver 99.99", 
              mcx: _fmt(_silverData['mcx_price']), 
              value: _fmt(_silverData['rate_9999']), 
              bg: const Color(0xFFFFECB3), iconColor: Colors.black,
              icon: Icons.bar_chart,
               prem: (_silverData['rate_9999'] ?? 0) - (_silverData['mcx_price'] ?? 0),
                high: _fmt(_silverData['high']), low: _fmt(_silverData['low']),
               valueColor: _priceColors['silver_rate_9999']
            ),
            const SizedBox(height: 10),
            
            // Gold 999 (RTGS)
            _buildSingleRateCard(
              "Gold 999 (RTGS)", 
              mcx: _fmt(_goldData['mcx_price']), 
              value: _fmt(_goldData['rate_999']), 
              bg: const Color(0xFFFFECB3), iconColor: Colors.black,
              icon: Icons.bar_chart,
              prem: (_goldData['rate_999'] ?? 0) - (_goldData['mcx_price'] ?? 0),
              high: _fmt(_goldData['high']), low: _fmt(_goldData['low']),
              valueColor: _priceColors['gold_rate_999']
            ),
            const SizedBox(height: 10),
            
            // Silver Bars
            _buildSingleRateCard(
              "Silver Bars", 
              mcx: _fmt(_silverData['mcx_price']), 
              value: _fmt(_silverData['rate_bars']), 
              bg: const Color(0xFFFFECB3), iconColor: Colors.black,
              icon: Icons.bar_chart,
              prem: (_silverData['rate_bars'] ?? 0) - (_silverData['mcx_price'] ?? 0),
              high: _fmt(_silverData['high']), low: _fmt(_silverData['low']),
              valueColor: _priceColors['silver_rate_bars']
            ),
            const SizedBox(height: 20),

            // Agra Local Rates
            _buildSectionHeader("Agra Local Rates"),
            const SizedBox(height: 10),
            
            // RTGS Rates (Combined)
            _buildRateCard(
              "RTGS Rates", 
              "Gold RTGS", 
              mcx1: _fmt(_goldData['mcx_price']),
              val1: _fmt(_goldData['rate_999']), 
              l2: "Silver RTGS", 
              mcx2: _fmt(_silverData['mcx_price']),
              val2: _fmt(_silverData['rate_9999']), 
              bg: Colors.white, iconColor: Colors.black,
              goldPrem: (_goldData['rate_999'] ?? 0) - (_goldData['mcx_price'] ?? 0),
              silverPrem: (_silverData['rate_9999'] ?? 0) - (_silverData['mcx_price'] ?? 0),
              goldColor: _priceColors['gold_rate_999'],
              silverColor: _priceColors['silver_rate_9999'],
            ),

          ],
        ),
      );
  }

  // Helper for Top Cards remains same...
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
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color == Colors.amber ? Colors.black : color)), // Exception for USD label color
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
          Container(
            width: 8, 
            height: 8, 
            decoration: BoxDecoration(
              color: _status.toLowerCase().contains("close") ? Colors.red : Colors.green, 
              shape: BoxShape.circle
            ),
          ),
          const SizedBox(width: 4),
          Text(_status, style: const TextStyle(color: Colors.grey)),
        ]
      ],
    );
  }
  
  // Single Card (For Live Rates)
  Widget _buildSingleRateCard(String title, {String? mcx, required String value, required Color bg, required Color iconColor, required IconData icon, 
    num? prem, String? high, String? low, bool isCash = false, Color? valueColor
  }) {
    String premText = "-";
    Color premColor = Colors.grey;
    if (prem != null) {
      String sign = prem >= 0 ? "+" : "";
      premText = "$sign$prem";
      premColor = prem >= 0 ? Colors.green : Colors.red;
    }

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: Colors.amber.shade100),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
           if(!isCash) BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset:const Offset(0, 2))
        ]
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: iconColor)),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   if(mcx != null) Text("MCX: $mcx", style: const TextStyle(fontSize: 12, color: Colors.black)),
                   if(high != null && low != null) 
                     Padding(
                       padding: const EdgeInsets.only(top: 4),
                       child: Text("H:$high L:$low", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                     ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Prem: $premText", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: premColor)),
                  const SizedBox(height: 2),
                  Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: valueColor ?? iconColor)),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  // Combined Card (For Agra Local Rates) using the new Detailed Layout
  Widget _buildRateCard(String title, String l1, {String? mcx1, required String val1, String? l2, String? mcx2, required String val2, required Color bg, required Color iconColor, 
    bool isCash = false, 
    num? goldPrem, num? silverPrem,
    String? goldHigh, String? goldLow,
    String? silverHigh, String? silverLow,
    Color? goldColor, Color? silverColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: Colors.amber.shade100),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
           if(!isCash) BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset:const Offset(0, 2))
        ]
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB8860B), Color(0xFFFFD700), Color(0xFFB8860B)], // Gold Gradient
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              children: [
                Icon(isCash ? Icons.menu_book : Icons.account_balance, size: 16, color: iconColor),
                const SizedBox(width: 8),
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: iconColor)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(child: _buildDetailedItem(l1, mcx1, val1, iconColor, prem: goldPrem, high: goldHigh, low: goldLow, valueColor: goldColor)),
                Container(width: 1, height: 80, color: Colors.amber.shade100),
                Expanded(child: _buildDetailedItem(l2 ?? "", mcx2, val2, iconColor, prem: silverPrem, high: silverHigh, low: silverLow, valueColor: silverColor)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDetailedItem(String label, String? mcx, String value, Color color, {num? prem, String? high, String? low, Color? valueColor}) {
    String premText = "-";
    Color premColor = Colors.grey;
    
    if (prem != null) {
      String sign = prem >= 0 ? "+" : "";
      premText = "$sign$prem";
      premColor = prem >= 0 ? Colors.green : Colors.red;
    }

    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        if (mcx != null)
        Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             const Text("MCX: ", style: TextStyle(fontSize: 10, color: Colors.grey)),
             Text(mcx, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
           ],
        ),
        Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             const Text("Prem: ", style: TextStyle(fontSize: 10, color: Colors.grey)),
             Text(premText, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: premColor)),
           ],
        ),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: valueColor ?? color)),
        if (high != null && low != null)
           Padding(
             padding: const EdgeInsets.only(top: 4.0),
             child: Text("H:$high L:$low", style: const TextStyle(fontSize: 10, color: Colors.grey)),
           ),
      ],
    );
  }
}
