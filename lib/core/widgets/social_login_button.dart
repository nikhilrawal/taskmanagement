import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey),
        ),
        child: Center(
          child: Image.asset(iconPath, width: 24, height: 24),
        ),
      ),
    );
  }
}
