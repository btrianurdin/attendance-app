import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class PictureView extends StatelessWidget {
  const PictureView({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Transform(
        transform: Matrix4.rotationY(math.pi),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.cover,
          child: Image.file(File(image)),
        ),
      ),
    );
  }
}