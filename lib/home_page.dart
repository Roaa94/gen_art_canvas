import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double gap = 0;
  bool isDebug = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(0),
            decoration: BoxDecoration(border: Border.all(color: Colors.red)),
            child: SizedBox.expand(
              child: CustomPaint(
                painter: GenArtCanvasPainter(
                  isDebug: isDebug,
                  gap: gap,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text('Gap'),
                      Slider(
                        value: gap,
                        onChanged: (value) => setState(() => gap = value),
                        min: 0,
                        max: 100,
                        divisions: 100,
                      ),
                    ],
                  ),
                  SwitchListTile(
                    title: Text('Is Debug'),
                    value: isDebug,
                    onChanged: (value) => setState(() => isDebug = value),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GenArtCanvasPainter extends CustomPainter {
  const GenArtCanvasPainter({
    this.gap = 0,
    this.isDebug = false,
  });

  final double gap;
  final bool isDebug;
  static const crossAxisCount = 15;
  static const yScale = 0.5;

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final fillPaint = Paint()..color = isDebug ? Colors.red : Colors.white;
    final debugPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final diagonal = size.width / (crossAxisCount - 1);

    final side = diagonal / sqrt(2);
    final skewedScaleX = 0.5 * sqrt(2);
    const skewedScaleY = 0.85;
    final xOffsetToTopCenter = diagonal / 2;
    final newWidth = diagonal;
    final newHeight = diagonal * yScale + side * skewedScaleY;

    final mainAxisCount =
        (size.height / (newHeight - (diagonal * yScale) / 2)).floor();
    final totalCount = crossAxisCount * mainAxisCount;

    for (int index = 0; index < totalCount; index++) {
      int j = index ~/ crossAxisCount;
      int i = index % crossAxisCount;

      double xOffset =
          (newWidth * i) - (j.isOdd ? newWidth / 2 + gap / 2 : 0) + gap * i;
      double yOffset =
          (side * skewedScaleY + diagonal * yScale * 0.5) * j + gap * j;
      final initialRect = Path()..addRect(Rect.fromLTWH(0, 0, side, side));
      final newRect = Path()..addRect(Rect.fromLTWH(0, 0, newWidth, newHeight));

      canvas.save();
      canvas.translate(xOffset, yOffset);

      canvas.save();
      canvas.translate(xOffsetToTopCenter, 0.0);
      canvas.scale(1.0, yScale);
      canvas.rotate(45 * pi / 180);
      canvas.drawPath(initialRect, strokePaint);
      canvas.drawPath(initialRect, fillPaint);
      canvas.restore();

      final leftPath = Path()..addRect(Rect.fromLTWH(0, 0, side, size.height));
      canvas.save();
      canvas.translate(0, diagonal / 2 * yScale);
      canvas.skew(0.0, 0.5);
      canvas.scale(skewedScaleX, skewedScaleY);
      canvas.drawPath(leftPath, strokePaint);
      canvas.drawPath(leftPath, fillPaint);
      canvas.restore();

      final rightPath = Path()..addRect(Rect.fromLTWH(0, 0, side, size.height));
      canvas.save();
      canvas.translate(xOffsetToTopCenter, diagonal * yScale);
      canvas.skew(0.0, -0.5);
      canvas.scale(skewedScaleX, skewedScaleY);
      canvas.drawPath(rightPath, strokePaint);
      canvas.drawPath(rightPath, fillPaint);
      canvas.restore();

      canvas.restore();
      if (isDebug) {
        canvas.drawPath(initialRect, debugPaint);
        canvas.drawPath(newRect, debugPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
