import 'package:flutter/material.dart';
import 'package:gen_art_canvas/auth/widgets/color_picker.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';
import 'package:gen_art_canvas/cuboids/domain/cuboid_face.dart';
import 'package:gen_art_canvas/cuboids/application/cuboid_form_data.dart';
import 'package:gen_art_canvas/cuboids/widgets/fill_type_picker.dart';

class CuboidFaceForm extends StatelessWidget {
  const CuboidFaceForm({
    super.key,
    required this.fillTypes,
    required this.colors,
    required this.formData,
    this.onChanged,
    required this.face,
  });

  final List<CuboidFaceFillType> fillTypes;
  final List<Color> colors;
  final CuboidFaceFormData formData;
  final ValueChanged<CuboidFaceFormData>? onChanged;
  final CuboidFaceDirection face;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          context,
          title: 'Fill Type',
          subtitle:
              'How would you like the ${face.name} face of your cuboid to be filled?',
        ),
        FillTypePicker(
          fillTypes: fillTypes,
          selectedFillType: formData.fillType,
          onChanged: (CuboidFaceFillType fillType) =>
              onChanged?.call(formData.copyWith(fillType: fillType)),
        ),
        const SizedBox(height: 10),
        _buildSectionTitle(
          context,
          title: 'Fill Color',
          subtitle: 'Pick the fill color of your picked fill type',
        ),
        ColorPicker(
          colors: colors,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          selectedColor: formData.fillColor,
          onChanged: (Color color) =>
              onChanged?.call(formData.copyWith(fillColor: color)),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(
    BuildContext context, {
    required String title,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: AppColors.primary),
          ),
          if (subtitle != null)
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }
}
