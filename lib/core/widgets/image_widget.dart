import 'dart:ui';

import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final double? size;
  const ImageWidget({
    Key? key,
    required this.size,
  }) : super(key: key);
  @override
  Widget build(Object context) {
    return Stack(
      children: [
        Positioned(
          left: 10,
          right: 0,
          child: Container(
            width: double.infinity,
            height: size,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/output.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.white.withValues(alpha: 0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/output.jpg',
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
