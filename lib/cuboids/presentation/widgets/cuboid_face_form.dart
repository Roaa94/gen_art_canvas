import 'package:flutter/material.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';
import 'package:gen_art_canvas/core/widgets/color_picker.dart';
import 'package:gen_art_canvas/cuboids/domain/cuboid_face.dart';
import 'package:gen_art_canvas/cuboids/presentation/cuboid_form_data.dart';
import 'package:gen_art_canvas/cuboids/presentation/widgets/fill_type_picker.dart';

class CuboidFaceForm extends StatelessWidget {
  const CuboidFaceForm({
    required this.fillTypes,
    required this.colors,
    required this.formData,
    required this.face,
    super.key,
    this.onChanged,
  });

  final List<CuboidFaceFillType> fillTypes;
  final List<Color> colors;
  final CuboidFaceFormData formData;
  final ValueChanged<CuboidFaceFormData>? onChanged;
  final CuboidFaceDirection face;

  @override
  Widget build(BuildContext context) {
    final pickerColors = face == CuboidFaceDirection.left
        ? colors.map((e) => e.toMaterial().shade800).toList()
        : face == CuboidFaceDirection.right
            ? colors.map((e) => e.toMaterial().shade600).toList()
            : colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          context,
          title: 'Fill Type',
          subtitle: 'How would you like the ${face.name} face of '
              'your cuboid to be filled?',
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
          colors: pickerColors,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          selectedColor: formData.fillColor,
          onChanged: (Color color) =>
              onChanged?.call(formData.copyWith(fillColor: color)),
        ),
        if (formData.hasStrokePickers)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildSectionTitle(
                context,
                title: 'Stroke Color',
                subtitle: 'Pick the stroke color of the lines',
              ),
              ColorPicker(
                colors: pickerColors,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                selectedColor: formData.strokeColor,
                onChanged: (Color color) =>
                    onChanged?.call(formData.copyWith(strokeColor: color)),
              ),
              const SizedBox(height: 10),
              _buildSectionTitle(
                context,
                title: 'Stroke Width',
                subtitle: 'Pick the stroke width of the lines',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Slider(
                  value: formData.strokeWidth,
                  onChanged: (value) => onChanged?.call(
                    formData.copyWith(strokeWidth: value),
                  ),
                  min: 1,
                  max: 10,
                  divisions: 9,
                ),
              ),
            ],
          ),
        if (formData.hasIntensitySlider)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildSectionTitle(
                context,
                title: 'Intensity',
                subtitle: 'Adjust the intensity of the lines',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Slider(
                  value: formData.intensity.toDouble(),
                  onChanged: (value) => onChanged?.call(
                    formData.copyWith(intensity: value.toInt()),
                  ),
                  min: 1,
                  max: 20,
                  divisions: 19,
                ),
              ),
            ],
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
