import 'dart:math';
import 'dart:ui';

import 'package:gen_art_canvas/cuboids/domain/cuboid_face.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings.dart';

class CuboidsUtils {
  static const double yScale = 0.5;
  static final skewedScaleX = 0.5 * sqrt(2);

  static void paintLines(
    Canvas canvas, {
    required CuboidsCanvasSettings settings,
    required Size size,
    required CuboidFace cuboidFace,
  }) {
    if (cuboidFace.strokeColor != null) {
      final linesPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = cuboidFace.strokeWidth
        ..color = cuboidFace.strokeColor!;
      final linesPoints = <Offset>[];
      final step = size.width / cuboidFace.intensity;
      for (int i = 0; i <= cuboidFace.intensity; i++) {
        linesPoints.add(Offset(i * step, 0));
        linesPoints.add(Offset(i * step, size.height));
      }
      canvas.drawPoints(
        PointMode.lines,
        linesPoints,
        linesPaint,
      );
    }
  }

  static void paintCuboid(
    Canvas canvas, {
    required Size size,
    required double diagonal,
    required CuboidFace? topFace,
    required CuboidFace? leftFace,
    required CuboidFace? rightFace,
    required CuboidsCanvasSettings settings,
  }) {
    final side = diagonal / sqrt(2);
    final topFacePath = Path()..addRect(Rect.fromLTWH(0, 0, side, side));
    final topFaceFillColor =
        topFace?.fillColor ?? settings.defaultPrimaryColor.shade600;
    final topFacePaint = Paint()..color = topFaceFillColor;

    // Paint top face
    canvas.save();
    canvas.translate(diagonal / 2, 0.0);
    canvas.scale(1.0, yScale);
    canvas.rotate(45 * pi / 180);
    canvas.drawPath(topFacePath, topFacePaint);
    if (topFace != null && topFace.fillType == CuboidFaceFillType.lines) {
      paintLines(
        canvas,
        settings: settings,
        size: Size(side, side),
        cuboidFace: topFace,
      );
    }
    canvas.restore();

    // Paint left face
    final leftFacePath = Path()
      ..addRect(Rect.fromLTWH(0, 0, side, size.height));
    final leftFaceFillColor =
        leftFace?.fillColor ?? settings.defaultPrimaryColor.shade900;
    final leftFacePaint = Paint()..color = leftFaceFillColor;
    canvas.save();
    canvas.translate(0, diagonal / 2 * yScale);
    canvas.skew(0.0, yScale);
    canvas.scale(skewedScaleX, 1.0);
    canvas.drawPath(leftFacePath, leftFacePaint);
    if (leftFace != null && leftFace.fillType == CuboidFaceFillType.lines) {
      paintLines(
        canvas,
        settings: settings,
        size: Size(side, size.height),
        cuboidFace: leftFace,
      );
    }
    canvas.restore();

    // Paint right face
    final rightFacePath = Path()
      ..addRect(Rect.fromLTWH(0, 0, side, size.height));
    final rightFaceFillColor =
        rightFace?.fillColor ?? settings.defaultPrimaryColor.shade800;
    final rightFacePaint = Paint()..color = rightFaceFillColor;
    canvas.save();
    canvas.translate(diagonal / 2, diagonal * yScale);
    canvas.skew(0.0, -yScale);
    canvas.scale(skewedScaleX, 1.0);
    canvas.drawPath(rightFacePath, rightFacePaint);
    if (rightFace != null && rightFace.fillType == CuboidFaceFillType.lines) {
      paintLines(
        canvas,
        settings: settings,
        size: Size(side, size.height),
        cuboidFace: rightFace,
      );
    }
    canvas.restore();
  }
}
