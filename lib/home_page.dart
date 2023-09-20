import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  static final random = Random();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    // animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        child: SizedBox.expand(
          child: LayoutBuilder(builder: (context, constraints) {
            final size = constraints.biggest;
            return CustomPaint(
              painter: GenArtCanvasPainter(
                animationController: animationController,
                size: size,
                random: random,
              ),
            );
          }),
        ),
      ),
    );
  }
}

class GenArtCanvasPainter extends CustomPainter {
  GenArtCanvasPainter({
    this.initialGap = 40,
    this.isDebug = false,
    required this.random,
    this.xCount = 8,
    this.yScale = 0.5,
    this.maxRandomYOffset = 50,
    required this.size,
    required AnimationController animationController,
  }) : super(repaint: animationController) {
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
    diagonal = (size.width - (initialGap * (xCount - 1))) / (xCount);
    yCount = ((size.height * 0.5) / ((diagonal * yScale) / 2)).floor();
    totalCount = xCount * yCount;

    offsets = List.generate(
      totalCount,
      (index) {
        int i = index % xCount;
        int j = index ~/ xCount;
        final dx = (diagonal * i) +
            (j.isOdd ? diagonal / 2 + initialGap / 2 : 0) +
            initialGap * i;
        final dy = (diagonal * yScale * 0.5) * j + initialGap * yScale * j;
        final randomYOffset = random.nextDoubleRange(maxRandomYOffset);
        return Offset(dx - (diagonal * 0.3), dy + randomYOffset);
      },
    );
  }

  final double initialGap;
  final bool isDebug;
  final Random random;
  final int xCount;
  final double yScale;
  final double maxRandomYOffset;
  late final Animation<double> animation;
  late final List<Offset> offsets;
  final Size size;

  late final double diagonal;
  late final int yCount;
  late final int totalCount;

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final fillPaint = Paint()..color = isDebug ? Colors.red : Colors.white;

    final side = diagonal / sqrt(2);
    final skewedScaleX = 0.5 * sqrt(2);
    const skewedScaleY = 0.85;
    final xOffsetToTopCenter = diagonal / 2;
    final newHeight = diagonal * yScale + side * skewedScaleY;

    final initialRect = Path()..addRect(Rect.fromLTWH(0, 0, side, side));
    final newRect = Path()..addRect(Rect.fromLTWH(0, 0, diagonal, newHeight));

    for (final offset in offsets) {
      canvas.save();
      // Move the canvas to offset of next cuboid
      canvas.translate(offset.dx, offset.dy);

      // Paint top face
      canvas.save();
      canvas.translate(xOffsetToTopCenter, 0.0);
      canvas.scale(1.0, yScale);
      canvas.rotate(45 * pi / 180);
      canvas.drawPath(initialRect, strokePaint);
      canvas.drawPath(initialRect, fillPaint);
      canvas.restore();

      // Paint left face
      final leftPath = Path()..addRect(Rect.fromLTWH(0, 0, side, size.height));
      canvas.save();
      canvas.translate(0, diagonal / 2 * yScale);
      canvas.skew(0.0, yScale);
      canvas.scale(skewedScaleX, skewedScaleY);
      canvas.drawPath(leftPath, strokePaint);
      canvas.drawPath(leftPath, fillPaint);
      canvas.restore();

      // Paint right face
      final rightPath = Path()..addRect(Rect.fromLTWH(0, 0, side, size.height));
      canvas.save();
      canvas.translate(xOffsetToTopCenter, diagonal * yScale);
      canvas.skew(0.0, -yScale);
      canvas.scale(skewedScaleX, skewedScaleY);
      canvas.drawPath(rightPath, strokePaint);
      canvas.drawPath(rightPath, fillPaint);
      canvas.restore();

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

extension on Random {
  double nextDoubleRange(double x) {
    final random = Random();
    return (2 * x * random.nextDouble()) - x;
  }
}
