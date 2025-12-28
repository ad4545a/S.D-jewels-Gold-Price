import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Icon(Icons.diamond_outlined, size: 80, color: Colors.amber[700]),
          const SizedBox(height: 20),
          const Text(
            "S.D. JEWELS",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.shade200)
            ),
            child: Text(
              "Trusted Since 1995",
              style: TextStyle(color: Colors.amber[900], fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 40),
          
          _buildInfoCard(
            title: "About Us",
            content: "S.D. Jewels is a premier destination for high-quality Gold and Silver bullion. We are committed to providing the most competitive rates in the market with guaranteed purity and transparent dealings.",
          ),
          const SizedBox(height: 20),
           _buildInfoCard(
            title: "Our Vision",
            content: "To be the most trusted and respected bullion dealer in Agra, known for our integrity, customer service, and technological innovation.",
          ),
          const SizedBox(height: 40),

        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
        ],
        border: Border.all(color: Colors.grey.shade100)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber[800])),
          const SizedBox(height: 10),
          Text(content, style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87)),
        ],
      ),
    );
  }
}
