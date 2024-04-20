import 'package:flutter/material.dart';

class FlameText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [Colors.green, Colors.yellow, Colors.green],
          stops: [0.0, 0.5, 1.0],
        ).createShader(bounds);
      },
      child: RichText(
        text: const TextSpan(
          text: 'Cats Gallery', // Ваш текст
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'jersey25',
          ),
        ),
      ),
    );
  }
}
