import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  Future<void> _launchDialer(String number) async {
    final Uri launchUri = Uri(scheme: 'tel', path: number.replaceAll(' ', ''));
    try {
      await launchUrl(launchUri);
    } catch (e) {
      debugPrint("Could not launch dialer: $e");
    }
  }

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Could not launch url: $e");
    }
  }

  Future<void> _launchWhatsApp(String number) async {
     // WhatsApp Short Link
     String url = "https://wa.link/uw0l5o";
     _launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader("Contact Persons"),
          _buildContactRow("Deepak Verma", "9412530552", Icons.person, onTap: () => _launchDialer("9412530552")),
          _buildContactRow("Aditya Verma", "8445496717", Icons.person_outline, onTap: () => _launchDialer("8445496717")),
          
          const SizedBox(height: 20),
          _buildHeader("Social Media"),
          _buildSocialRow("Instagram", "sd_jewels_agra", "https://www.instagram.com/sd_jewels_agra/", Icons.camera_alt, Colors.pink),
          _buildSocialRow("Facebook", "Coming Soon", "", Icons.facebook, Colors.blue),
           _buildSocialRow("Email", "Coming Soon", "", Icons.email, Colors.redAccent),


          const SizedBox(height: 30),
          InkWell(
            onTap: () => _launchWhatsApp("9259820632"),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366).withOpacity(0.1), // WhatsApp Green Tint
                border: Border.all(color: const Color(0xFF25D366)),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(Icons.call, color: Color(0xFF25D366), size: 40), 
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("WhatsApp Us", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF25D366))),
                      Text("92598 20632", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber[800]),
      ),
    );
  }

  Widget _buildContactRow(String name, String number, IconData icon, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))
          ],
          border: Border.all(color: Colors.grey.shade200)
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.amber[50], shape: BoxShape.circle),
              child: Icon(icon, color: Colors.amber[800]),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                Text(number, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            Icon(Icons.call, color: Colors.green[600]), // Added call icon for clarity
          ],
        ),
      ),
    );
  }

  Widget _buildSocialRow(String platform, String handle, String link, IconData icon, Color color) {
    return InkWell(
      onTap: () => _launchUrl(link),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(platform, style: const TextStyle(fontWeight: FontWeight.bold)),
                if(handle.isNotEmpty) Text(handle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const Spacer(),
            if(link.isNotEmpty) 
              const Icon(Icons.open_in_new, size: 20, color: Colors.grey)
          ],
        ),
      ),
    );
  }
}
