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
    animationController.repeat(reverse: true);
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
                maxRandomYOffset: size.height * 0.1,
                diagonal: size.width * 0.1,
                initialGap: 30,
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
    this.initialGap = 20,
    this.isDebug = false,
    required this.random,
    this.diagonal = 100,
    this.yScale = 0.5,
    this.maxRandomYOffset = 50,
    required this.size,
    required AnimationController animationController,
  }) : super(repaint: animationController) {
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
    xCount = (size.width / (diagonal + initialGap * 0.5)).ceil() - 1;
    yCount = ((size.height * 0.6) / ((diagonal * yScale) / 2)).floor();
    totalCount = xCount * yCount;

    randomYOffsets = List.generate(
      totalCount,
      (index) => random.nextDoubleRange(maxRandomYOffset),
    );
    initialOffsets = List.generate(
      totalCount,
      (index) {
        int i = index % xCount;
        int j = index ~/ xCount;
        final dx = (diagonal * i) +
            (j.isOdd ? diagonal / 2 + initialGap / 2 : 0) +
            initialGap * i;
        final dy = (diagonal * yScale * 0.5) * j + initialGap * yScale * j;
        return Offset(dx - (diagonal * 0.3), dy);
      },
    );

    offsetAnimations = List.generate(
      totalCount,
      (index) {
        return Tween<Offset>(
          begin: initialOffsets[index],
          end: initialOffsets[index] + Offset(0, randomYOffsets[index]),
        ).animate(animation);
      },
    );
  }

  final double initialGap;
  final bool isDebug;
  final Random random;
  final double yScale;
  final double maxRandomYOffset;
  late final Animation<double> animation;
  late final List<Animation<Offset>> offsetAnimations;
  late final List<Offset> initialOffsets;
  late final List<double> randomYOffsets;
  final Size size;

  late final double diagonal;
  late final int xCount;
  late final int yCount;
  late final int totalCount;

  final strokePaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;
  final fillPaint = Paint()..color = Colors.white;

  final skewedScaleX = 0.5 * sqrt(2);

  double get newHeight => diagonal * yScale + side;

  double get side => diagonal / sqrt(2);

  Path get initialRect => Path()..addRect(Rect.fromLTWH(0, 0, side, side));

  Path get newRect => Path()..addRect(Rect.fromLTWH(0, 0, diagonal, newHeight));

  @override
  void paint(Canvas canvas, Size size) {
    for (final offsetAnimation in offsetAnimations) {
      canvas.save();
      // Move the canvas to offset of next cuboid
      canvas.translate(offsetAnimation.value.dx, offsetAnimation.value.dy);
      _paintCuboid(canvas);
      canvas.restore();
    }
  }

  _paintCuboid(Canvas canvas) {
    // Paint top face
    canvas.save();
    canvas.translate(diagonal / 2, 0.0);
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
    canvas.scale(skewedScaleX, 1.0);
    canvas.drawPath(leftPath, strokePaint);
    canvas.drawPath(leftPath, fillPaint);
    canvas.restore();

    // Paint right face
    final rightPath = Path()..addRect(Rect.fromLTWH(0, 0, side, size.height));
    canvas.save();
    canvas.translate(diagonal / 2, diagonal * yScale);
    canvas.skew(0.0, -yScale);
    canvas.scale(skewedScaleX, 1.0);
    canvas.drawPath(rightPath, strokePaint);
    canvas.drawPath(rightPath, fillPaint);
    canvas.restore();
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
