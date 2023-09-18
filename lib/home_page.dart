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
  static const crossAxisCount = 10;

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

    final diagonal = size.width / crossAxisCount;
    final side = diagonal / sqrt(2);
    const yScale = 0.5;
    final skewedScaleX = 0.5 * sqrt(2);
    const skewedScaleY = 0.85;
    final xOffsetToTopCenter = diagonal / 2;
    final newWidth = diagonal;
    final newHeight = diagonal * yScale + side * skewedScaleY;

    final initialRect = Path()..addRect(Rect.fromLTWH(0, 0, side, side));
    canvas.drawPath(initialRect, debugPaint);

    final newRect = Path()..addRect(Rect.fromLTWH(0, 0, newWidth, newHeight));
    canvas.drawPath(newRect, debugPaint);

    for (int index = 0; index < crossAxisCount; index++) {
      canvas.save();
      canvas.translate(xOffsetToTopCenter * 2 * index, 0.0);

      canvas.save();
      canvas.translate(xOffsetToTopCenter, 0.0);
      canvas.scale(1.0, yScale);
      canvas.rotate(45 * pi / 180);
      canvas.drawPath(initialRect, paint);
      canvas.restore();

      final leftPath = Path()..addRect(Rect.fromLTWH(0, 0, side, side));
      canvas.save();
      canvas.translate(0, diagonal / 2 * yScale);
      canvas.skew(0.0, 0.5);
      canvas.scale(skewedScaleX, skewedScaleY);
      canvas.drawPath(leftPath, paint);
      canvas.restore();

      final rightPath = Path()..addRect(Rect.fromLTWH(0, 0, side, side));
      canvas.save();
      canvas.translate(xOffsetToTopCenter, diagonal * yScale);
      canvas.skew(0.0, -0.5);
      canvas.scale(skewedScaleX, skewedScaleY);
      canvas.drawPath(rightPath, paint);
      canvas.restore();

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
