
import 'package:flutter/material.dart';

class BankScreen extends StatelessWidget {
  const BankScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF5E6C4), // Creamy/Gold background from image
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))
          ],
        ),
        child: Column(
          children: [
            const Text(
              "-: Bank details by SD jewels :-",
              style: TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.bold, 
                color: Color(0xFFB71C1C) // Deep Red
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            
            _buildDetailRow("Acc name :-", "S.D. JEWELS"),
            _buildDetailRow("Acc no :-", "922020052922964"),
            _buildDetailRow("IFSC code :-", "UTIB0003333"),
            _buildDetailRow("Bank name :-", "Axis Bank,t.y.c.agra"),

            const SizedBox(height: 20),
            const Text(
              "UP ID :- 9412530552@axisbank",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 20),
            
            // QR Code Placeholder
            Container(
              height: 150,
              width: 150,
              color: Colors.white,
              child: const Center(child: Icon(Icons.qr_code_2, size: 100)),
            ),
            const SizedBox(height: 10),
            const Text("s.d.jewels", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label, 
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)
            ),
          ),
          Expanded(
            child: Text(
              value, 
              style: TextStyle(
                fontSize: 18, 
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal, 
                color: Colors.black
              ),
            ),
          ),
        ],
      ),
    );
  }
}
