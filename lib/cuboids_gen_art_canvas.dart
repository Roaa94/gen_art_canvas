import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings.dart';

class CuboidsGenArtCanvas extends StatefulWidget {
  const CuboidsGenArtCanvas({
    super.key,
    this.initialGap = 40,
    this.direction = Axis.vertical,
    required this.settings,
  });

  final Axis direction;
  final double initialGap;
  final CuboidsCanvasSettings settings;

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
            widget.settings.cuboidsTotalCount,
            (index) => random.nextDoubleRange(widget.settings.maxRandomYOffset),
          );
        });
      }
      animationStatus = animationController.status;
    }
  }

  List<double> _generateRandomYOffsets() {
    return List.generate(
      widget.settings.cuboidsTotalCount,
      (index) => random.nextDoubleRange(widget.settings.maxRandomYOffset),
    );
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
    randomYOffsets = _generateRandomYOffsets();
  }

  @override
  void didUpdateWidget(covariant CuboidsGenArtCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings != widget.settings) {
      setState(() {
        randomYOffsets = _generateRandomYOffsets();
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
    const ratio = 1080 / 1920;

    return ColoredBox(
      color: widget.settings.defaultPrimaryColor,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FittedBox(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * ratio,
            child: CustomPaint(
              painter: GenArtCanvasPainter(
                randomYOffsets: randomYOffsets,
                settings: widget.settings,
                initialGap: widget.initialGap,
                animationController: animationController,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GenArtCanvasPainter extends CustomPainter {
  GenArtCanvasPainter({
    required this.settings,
    this.initialGap = 10,
    this.yScale = 0.5,
    required this.randomYOffsets,
    required AnimationController animationController,
  })  : assert(randomYOffsets.length == settings.cuboidsTotalCount),
        animation = CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
        cuboidsCrossAxisCount = sqrt(settings.cuboidsTotalCount / 2).toInt(),
        cuboidsMainAxisCount = (2 * settings.cuboidsTotalCount).toInt(),
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

  final CuboidsCanvasSettings settings;
  final double initialGap;
  final double yScale;
  late final Animation<double> animation;
  final List<double> randomYOffsets;

  final skewedScaleX = 0.5 * sqrt(2);

  @override
  void paint(Canvas canvas, Size size) {
    final gap = initialGap;
    final diagonal = (size.width - (gap * (cuboidsCrossAxisCount - 1 + 0.5))) /
        (cuboidsCrossAxisCount + 0.5);

    for (int index = 0; index < settings.cuboidsTotalCount; index++) {
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
    final topFacePath = Path()..addRect(Rect.fromLTWH(0, 0, side, side));
    final topFacePaint = Paint()..color = settings.defaultPrimaryColor.shade600;
    // Paint top face
    canvas.save();
    canvas.translate(diagonal / 2, 0.0);
    canvas.scale(1.0, yScale);
    canvas.rotate(45 * pi / 180);
    canvas.drawPath(topFacePath, topFacePaint);
    canvas.restore();

    // Paint left face
    final leftFacePath = Path()
      ..addRect(Rect.fromLTWH(0, 0, side, size.height));
    final leftFacePaint = Paint()
      ..color = settings.defaultPrimaryColor.shade900;
    canvas.save();
    canvas.translate(0, diagonal / 2 * yScale);
    canvas.skew(0.0, yScale);
    canvas.scale(skewedScaleX, 1.0);
    canvas.drawPath(leftFacePath, leftFacePaint);
    canvas.restore();

    // Paint right face
    final rightFacePath = Path()
      ..addRect(Rect.fromLTWH(0, 0, side, size.height));
    final rightFacePaint = Paint()
      ..color = settings.defaultPrimaryColor.shade800;
    canvas.save();
    canvas.translate(diagonal / 2, diagonal * yScale);
    canvas.skew(0.0, -yScale);
    canvas.scale(skewedScaleX, 1.0);
    canvas.drawPath(rightFacePath, rightFacePaint);
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
