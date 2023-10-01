import 'package:flutter/material.dart';
import 'package:gen_art_canvas/cuboids/domain/cuboid_face.dart';
import 'package:gen_art_canvas/cuboids/presentation/cuboid_form_data.dart';
import 'package:gen_art_canvas/cuboids/utils.dart';
import 'package:gen_art_canvas/settings/cuboids_canvas_settings.dart';

class FormPreviewCuboid extends StatelessWidget {
  const FormPreviewCuboid({
    required this.formData,
    required this.settings,
    super.key,
  });

  final CuboidFormData formData;
  final CuboidsCanvasSettings settings;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: SizedBox.fromSize(
            size: const Size.fromWidth(200),
            child: CustomPaint(
              painter: FormPreviewCuboidPainter(
                formData: formData,
                settings: settings,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FormPreviewCuboidPainter extends CustomPainter {
  FormPreviewCuboidPainter({
    required this.formData,
    required this.settings,
  });

  final CuboidFormData formData;
  final CuboidsCanvasSettings settings;

  @override
  void paint(Canvas canvas, Size size) {
    final topFace = formData[CuboidFaceDirection.top] == null
        ? null
        : CuboidFace.fromFormData(formData[CuboidFaceDirection.top]!);
    final rightFace = formData[CuboidFaceDirection.right] == null
        ? null
        : CuboidFace.fromFormData(formData[CuboidFaceDirection.right]!);
    final leftFace = formData[CuboidFaceDirection.left] == null
        ? null
        : CuboidFace.fromFormData(formData[CuboidFaceDirection.left]!);

    final diagonal = size.width;
    CuboidsUtils.paintCuboid(
      canvas,
      size: size,
      diagonal: diagonal,
      topFace: topFace,
      rightFace: rightFace,
      leftFace: leftFace,
      settings: settings,
    );
  }

  @override
  bool shouldRepaint(covariant FormPreviewCuboidPainter oldDelegate) {
    return oldDelegate.formData != formData;
  }
}
