import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';
import 'package:gen_art_canvas/cuboids/domain/cuboid.dart';
import 'package:gen_art_canvas/cuboids/utils.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings.dart';

class CuboidsCanvas extends StatefulWidget {
  const CuboidsCanvas({
    required this.settings,
    super.key,
    this.initialGap = 40,
    this.direction = Axis.vertical,
    this.cuboids = const [],
    this.animationEnabled = true,
    this.bgColor,
  });

  final Axis direction;
  final double initialGap;
  final CuboidsCanvasSettings settings;
  final List<Cuboid> cuboids;
  final bool animationEnabled;
  final Color? bgColor;

  @override
  State<CuboidsCanvas> createState() => _CuboidsCanvasState();
}

class _CuboidsCanvasState extends State<CuboidsCanvas>
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
          randomYOffsets = _generateRandomYOffsets();
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
    if (widget.animationEnabled) {
      animationController.repeat(reverse: true);
    }
    animationController.addListener(_animationControllerListener);
    randomYOffsets = _generateRandomYOffsets();
  }

  @override
  void didUpdateWidget(covariant CuboidsCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings != widget.settings) {
      setState(() {
        randomYOffsets = _generateRandomYOffsets();
      });
    }
    if (oldWidget.animationEnabled != widget.animationEnabled) {
      if (!widget.animationEnabled) {
        // stop running animation
        animationController.stop();
      } else {
        // Start the animation
        animationController.repeat(reverse: true);
      }
    }
  }

  @override
  void dispose() {
    animationController
      ..removeListener(_animationControllerListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return ColoredBox(
      color: widget.bgColor ??
          (widget.cuboids.isNotEmpty
              ? AppColors.firebaseNavy.toMaterial().shade600
              : widget.settings.defaultPrimaryColor),
      child: SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: Padding(
          padding: EdgeInsets.only(top: widget.settings.maxRandomYOffset),
          child: CustomPaint(
            painter: CuboidsCanvasPainter(
              randomYOffsets: randomYOffsets,
              settings: widget.settings,
              initialGap: widget.initialGap,
              animationController: animationController,
              cuboids: widget.cuboids,
            ),
          ),
        ),
      ),
    );
  }
}

class CuboidsCanvasPainter extends CustomPainter {
  CuboidsCanvasPainter({
    required this.settings,
    required this.randomYOffsets,
    required AnimationController animationController,
    this.initialGap = 10,
    this.yScale = 0.5,
    this.cuboids = const [],
  })  : assert(
          randomYOffsets.length == settings.cuboidsTotalCount,
          'Random offsets count should be the same as cuboids count',
        ),
        animation = CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
        cuboidsCrossAxisCount = sqrt(settings.cuboidsTotalCount / 2).toInt(),
        cuboidsMainAxisCount = 2 * settings.cuboidsTotalCount,
        super(repaint: animationController);

  final int cuboidsMainAxisCount;
  final int cuboidsCrossAxisCount;
  final CuboidsCanvasSettings settings;
  final double initialGap;
  final double yScale;
  late final Animation<double> animation;
  final List<double> randomYOffsets;
  final List<Cuboid> cuboids;

  @override
  void paint(Canvas canvas, Size size) {
    final gap = initialGap;
    final diagonal = (size.width - (gap * (cuboidsCrossAxisCount - 1 + 0.5))) /
        (cuboidsCrossAxisCount + 0.5);

    for (var index = 0; index < settings.cuboidsTotalCount; index++) {
      final j = index ~/ cuboidsCrossAxisCount;
      final i = index % cuboidsCrossAxisCount;

      final cuboidData = cuboids.length - 1 >= index ? cuboids[index] : null;
      final xOffset =
          (diagonal * i) + (j.isOdd ? diagonal / 2 + gap / 2 : 0) + gap * i;
      final yOffset = (diagonal * yScale * 0.5) * j + gap * yScale * j;
      final beginOffset = Offset(xOffset, yOffset);
      final endOffset =
          Offset(beginOffset.dx, beginOffset.dy + randomYOffsets[index]);
      final animatedYOffset =
          Offset.lerp(beginOffset, endOffset, animation.value) ?? beginOffset;

      canvas
        ..save()
        // Move the canvas to offset of next cuboid
        ..translate(animatedYOffset.dx, animatedYOffset.dy);
      CuboidsUtils.paintCuboid(
        canvas,
        size: size,
        diagonal: diagonal,
        leftFace: cuboidData?.leftFace,
        rightFace: cuboidData?.rightFace,
        topFace: cuboidData?.topFace,
        settings: settings,
      );
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
