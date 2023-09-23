import 'dart:math';

import 'package:flutter/material.dart';

class CuboidsGenArtCanvas extends StatefulWidget {
  CuboidsGenArtCanvas({
    super.key,
    this.cuboidsTotalCount = 100,
    this.maxRandomYOffset = 170,
    this.initialGap = 40,
    this.direction = Axis.vertical,
  }) : assert(cuboidsTotalCount.isEven);

  final Axis direction;
  final int cuboidsTotalCount;
  final double maxRandomYOffset;
  final double initialGap;

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

  void _animationControllerListener() {
    if (animationController.status != animationStatus) {
      if (animationController.status == AnimationStatus.forward &&
          animationStatus == AnimationStatus.reverse) {
        setState(() {
          randomYOffsets = List.generate(
            widget.cuboidsTotalCount,
            (index) => random.nextDoubleRange(widget.maxRandomYOffset),
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
    animationController.repeat(reverse: true);
    animationController.addListener(_animationControllerListener);
    randomYOffsets = List.generate(
      widget.cuboidsTotalCount,
      (index) => random.nextDoubleRange(widget.maxRandomYOffset),
    );
  }

  @override
  void didUpdateWidget(covariant CuboidsGenArtCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cuboidsTotalCount != widget.cuboidsTotalCount) {
      setState(() {
        randomYOffsets = List.generate(
          widget.cuboidsTotalCount,
          (index) => random.nextDoubleRange(widget.maxRandomYOffset),
        );
      });
    }
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
        maxRandomYOffset: widget.maxRandomYOffset,
        cuboidsTotalCount: widget.cuboidsTotalCount,
        initialGap: widget.initialGap,
        animationController: animationController,
      ),
    );
  }
}

class GenArtCanvasPainter extends CustomPainter {
  GenArtCanvasPainter({
    this.cuboidsTotalCount = 0,
    this.initialGap = 10,
    this.yScale = 0.5,
    this.maxRandomYOffset = 50,
    required this.randomYOffsets,
    required AnimationController animationController,
  })  : assert(randomYOffsets.length == cuboidsTotalCount),
        animation = CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
        cuboidsCrossAxisCount = sqrt(cuboidsTotalCount / 2).toInt(),
        cuboidsMainAxisCount = (2 * cuboidsTotalCount).toInt(),
        super(repaint: animationController);

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
  final double initialGap;
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

  @override
  void paint(Canvas canvas, Size size) {
    final gap = initialGap;
    final diagonal = (size.width - (gap * (cuboidsCrossAxisCount - 1 + 0.5))) /
        (cuboidsCrossAxisCount + 0.5);

    for (int index = 0; index < cuboidsTotalCount; index++) {
      int j = index ~/ cuboidsCrossAxisCount;
      int i = index % cuboidsCrossAxisCount;

      final xOffset =
          (diagonal * i) + (j.isOdd ? diagonal / 2 + gap / 2 : 0) + gap * i;
      final yOffset = (diagonal * yScale * 0.5) * j + gap * yScale * j;
      final beginOffset = Offset(xOffset, yOffset);
      final endOffset =
          Offset(beginOffset.dx, beginOffset.dy + randomYOffsets[index]);
      final animatedYOffset =
          Offset.lerp(beginOffset, endOffset, animation.value) ?? beginOffset;
      canvas.save();
      // Move the canvas to offset of next cuboid
      canvas.translate(animatedYOffset.dx, animatedYOffset.dy);
      _paintCuboid(canvas, size, diagonal);
      canvas.restore();
    }
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
