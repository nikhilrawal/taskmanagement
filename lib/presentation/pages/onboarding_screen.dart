import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:taskmanager/core/widgets/image_widget.dart';

import 'package:taskmanager/presentation/pages/login_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ImageWidget(size: 310),
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text(
                    "Get things done.",
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 40, right: 100),
                  child: Text(
                    "Just a click away from planning your tasks.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 10, color: Colors.grey),
                      SizedBox(width: 6),
                      Icon(Icons.circle, size: 10, color: Colors.grey),
                      SizedBox(width: 6),
                      Icon(Icons.circle, size: 10, color: Color(0xff57018a)),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 180,
                      width: 180,
                      decoration: const BoxDecoration(
                        color: Color(0xff57018a),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(180),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xff57018a),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
