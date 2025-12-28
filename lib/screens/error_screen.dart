import 'package:flutter/material.dart';

class CustomErrorScreen extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const CustomErrorScreen({super.key, required this.errorDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
              const SizedBox(height: 24),
              const Text(
                "Oops! Something went wrong.",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "We encountered an unexpected error. Please restart the app or contact support if the issue persists.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
              const SizedBox(height: 32),
              // In a catastrophic error state, navigation might be broken,
              // but we can offer a button that might do nothing or just show a nice UI.
              // Since we can't easily "Restart" the whole app cleanly from here without external packages,
              // we just provide a static view.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                     // Try to pop?
                     // In release mode this often just replaces the whole red screen.
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("App Encountered Error"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
