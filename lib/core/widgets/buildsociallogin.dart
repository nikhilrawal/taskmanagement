import 'package:flutter/material.dart';
import 'package:taskmanager/core/widgets/social_login_button.dart';

class Buildsociallogin extends StatelessWidget {
  const Buildsociallogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialLoginButton(
          iconPath: 'assets/icons/facebook-13.png',
          onPressed: () {}, // Add social login logic
        ),
        const SizedBox(width: 20),
        SocialLoginButton(
          iconPath: 'assets/icons/google-37.png',
          onPressed: () {}, // Add social login logic
        ),
        const SizedBox(width: 20),
        SocialLoginButton(
          iconPath: 'assets/icons/apple-4.png',
          onPressed: () {}, // Add social login logic
        ),
      ],
    );
  }
}
