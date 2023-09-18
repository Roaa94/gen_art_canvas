import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(50),
        decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        child: SizedBox.expand(
          child: CustomPaint(
            painter: GenArtCanvasPainter(),
          ),
        ),
      ),
    );
  }
}

class GenArtCanvasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final debugPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    const side = 100.0;
    final diagonal = side * sqrt(2);
    const yScale = 0.5;
    final skewedScale = 0.5 * sqrt(2);

    path.addRect(const Rect.fromLTWH(0, 0, side, side));
    canvas.drawPath(path, debugPaint);

    canvas.save();
    canvas.translate(diagonal / 2, 0.0);
    canvas.scale(1.0, yScale);
    canvas.rotate(45 * pi / 180);
    canvas.drawPath(path, paint);
    canvas.restore();

    canvas.save();
    canvas.translate(0, diagonal / 2 * yScale);
    canvas.skew(0.0, 0.5);
    canvas.scale(skewedScale, skewedScale);
    canvas.drawPath(path, paint);
    canvas.restore();

    canvas.save();
    canvas.translate(diagonal / 2, diagonal * yScale);
    canvas.skew(0.0, -0.5);
    canvas.scale(skewedScale, skewedScale);
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
