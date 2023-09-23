import 'dart:math';

import 'package:flutter/material.dart';

class CuboidsGenArtCanvas extends StatefulWidget {
  const CuboidsGenArtCanvas({
    super.key,
    this.cuboidsCrossAxisCount = 10,
    this.cuboidsMainAxisCount = 20,
    this.direction = Axis.vertical,
  }) : cuboidsTotalCount = cuboidsMainAxisCount * cuboidsCrossAxisCount;

  final Axis direction;

  /// If [direction] is [Axis.vertical], this will be the number
  /// of cuboids on the vertical axis
  /// If [direction] is [Axis.horizontal], this will be the number
  /// of cuboids on the horizontal axis
  final int cuboidsMainAxisCount;

  /// If [direction] is [Axis.vertical], this will be the number
  /// of cuboids on the horizontal axis
  /// If [direction] is [Axis.horizontal], this will be the number
  /// of cuboids on the vertical axis
  final int cuboidsCrossAxisCount;

  final int cuboidsTotalCount;

  @override
  State<CuboidsGenArtCanvas> createState() => _CuboidsGenArtCanvasState();
}

class _CuboidsGenArtCanvasState extends State<CuboidsGenArtCanvas>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  static final random = Random();
  static const animationDuration = Duration(milliseconds: 2000);
  AnimationStatus animationStatus = AnimationStatus.forward;
  late List<double> randomYOffsets;

  double get maxRandomYOffset => 100;

  void _animationControllerListener() {
    if (animationController.status != animationStatus) {
      if (animationController.status == AnimationStatus.forward &&
          animationStatus == AnimationStatus.reverse) {
        setState(() {
          randomYOffsets = List.generate(
            widget.cuboidsTotalCount,
            (index) => random.nextDoubleRange(maxRandomYOffset),
          );
        });
      }
      animationStatus = animationController.status;
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
    // animationController.repeat(reverse: true);
    animationController.addListener(_animationControllerListener);
    randomYOffsets = List.generate(
      widget.cuboidsTotalCount,
      (index) => random.nextDoubleRange(maxRandomYOffset),
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.removeListener(_animationControllerListener);
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GenArtCanvasPainter(
        randomYOffsets: randomYOffsets,
        cuboidsMainAxisCount: widget.cuboidsMainAxisCount,
        cuboidsCrossAxisCount: widget.cuboidsCrossAxisCount,
        maxRandomYOffset: maxRandomYOffset,
        initialGap: 30,
        animationController: animationController,
        random: random,
      ),
    );
  }
}

class GenArtCanvasPainter extends CustomPainter {
  GenArtCanvasPainter({
    this.cuboidsMainAxisCount = 0,
    this.cuboidsCrossAxisCount = 0,
    this.initialGap = 20,
    required this.random,
    this.yScale = 0.5,
    this.maxRandomYOffset = 50,
    required this.randomYOffsets,
    required AnimationController animationController,
  })  : animation = CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
        cuboidsTotalCount = cuboidsCrossAxisCount * cuboidsMainAxisCount,
        super(repaint: animationController);

  // {
  // xCount = (size.width / (diagonal + initialGap * 0.5)).ceil() - 2;
  // yCount = ((size.height * 0.6) / ((diagonal * yScale) / 2)).floor();
  // totalCount = xCount * yCount;
  //
  // initialOffsets = List.generate(
  //   totalCount,
  //   (index) {
  //     int i = index % xCount;
  //     int j = index ~/ xCount;
  //     final dx = (diagonal * i) +
  //         (j.isOdd ? diagonal / 2 + initialGap / 2 : 0) +
  //         initialGap * i;
  //     final dy = (diagonal * yScale * 0.5) * j + initialGap * yScale * j;
  //     return Offset(dx, dy);
  //   },
  // );
  //
  // offsetAnimations = List.generate(
  //   totalCount,
  //   (index) {
  //     return Tween<Offset>(
  //       begin: initialOffsets[index],
  //       end: initialOffsets[index] + Offset(0, randomYOffsets[index]),
  //     ).animate(animation);
  //   },
  // );
  // }

  final int cuboidsMainAxisCount;
  final int cuboidsCrossAxisCount;
  final int cuboidsTotalCount;
  final double initialGap;
  final Random random;
  final double yScale;
  final double maxRandomYOffset;
  late final Animation<double> animation;
  final List<double> randomYOffsets;

  final strokePaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;
  final fillPaint = Paint()..color = Colors.white;

  final skewedScaleX = 0.5 * sqrt(2);

  // double get newHeight => diagonal * yScale + side;

  // Path get newRect => Path()
  //   ..addRect(
  //     Rect.fromLTWH(0, 0, diagonal + initialGap,
  //         ((diagonal * yScale) / 2) + initialGap * yScale),
  //   );

  @override
  void paint(Canvas canvas, Size size) {
    final gap = initialGap;
    final diagonal = (size.width - (gap * (cuboidsCrossAxisCount - 1 + 0.5))) /
        (cuboidsCrossAxisCount + 0.5);

    for (int index = 0; index < cuboidsTotalCount; index++) {
      int j = index ~/ cuboidsCrossAxisCount;
      int i = index % cuboidsCrossAxisCount;

      double xOffset =
          (diagonal * i) + (j.isOdd ? diagonal / 2 + gap / 2 : 0) + gap * i;
      double yOffset = (diagonal * yScale * 0.5) * j + gap * yScale * j;
      // yOffset += randomYOffsets[index];
      canvas.save();
      // Move the canvas to offset of next cuboid
      canvas.translate(xOffset, yOffset);
      _paintCuboid(canvas, size, diagonal);
      // canvas.drawPath(initialRect, strokePaint);
      // canvas.drawPath(newRect, strokePaint);
      canvas.restore();
    }
    // for (final offsetAnimation in offsetAnimations) {
    //   canvas.save();
    //   // Move the canvas to offset of next cuboid
    //   canvas.translate(offsetAnimation.value.dx, offsetAnimation.value.dy);
    //   _paintCuboid(canvas, side);
    //   // canvas.drawPath(initialRect, strokePaint);
    //   canvas.drawPath(newRect, strokePaint);
    //   canvas.restore();
    // }
  }

  _paintCuboid(Canvas canvas, Size size, double diagonal) {
    final side = diagonal / sqrt(2);
    final initialRect = Path()..addRect(Rect.fromLTWH(0, 0, side, side));
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
