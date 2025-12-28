import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    // Hide status bar for full splash effect
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // Navigate to Home after 3.5 seconds
    Future.delayed(const Duration(milliseconds: 3500), () {
        // Restore Overlay
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Or a deep branding color
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Dynamic Logo
                    Image.asset(
                      'assets/images/logo.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "S.D. JEWELS",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: Colors.amber[900],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Agra's Trusted Bullion Dealer",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
