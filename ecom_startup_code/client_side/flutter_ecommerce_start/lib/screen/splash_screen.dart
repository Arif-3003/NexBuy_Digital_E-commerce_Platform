import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController fadeController;
  late Animation<double> fadeAnim;

  @override
  void initState() {
    super.initState();

    // text fade animation
    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    fadeAnim = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeIn,
    );

    fadeController.forward();

    // navigate after 4 sec
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, "/login");
    });
  }

  @override
  void dispose() {
    fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F), // Navy Blue

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // NexBuy logo with glowing animation
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.7, end: 1.0),
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Text(
                    "NexBuy",
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontStyle: FontStyle.italic,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      color: Colors.white.withOpacity(0.95),
                      shadows: [
                        Shadow(
                          blurRadius: 25,
                          color: Colors.lightBlueAccent.withOpacity(0.8),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            FadeTransition(
              opacity: fadeAnim,
              child: const Text(
                "Smart E-Commerce Solution",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(height: 40),

            const CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
