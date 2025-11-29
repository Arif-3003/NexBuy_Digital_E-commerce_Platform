import 'package:flutter/material.dart';

class LoginBackgroundWrapper extends StatelessWidget {
  final Widget child;

  const LoginBackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage("assets/images/bg_soft_dots.png"),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: child,
    );
  }
}
