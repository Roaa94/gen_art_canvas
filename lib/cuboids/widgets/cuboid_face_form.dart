import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gen_art_canvas/auth/widgets/color_picker.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_face.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_form_data.dart';

class CuboidFaceForm extends StatelessWidget {
  const CuboidFaceForm({
    super.key,
    required this.fillTypes,
    required this.colors,
    required this.formData,
    this.onChanged,
  });

  final List<CuboidFaceFillType> fillTypes;
  final List<Color> colors;
  final CuboidFaceFormData formData;
  final ValueChanged<CuboidFaceFormData>? onChanged;

  static const double pickerSectionHeight = 80;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text('Fill Type'),
        ),
        SizedBox(
          height: pickerSectionHeight,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            children: List.generate(
              fillTypes.length,
              (index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: pickerSectionHeight,
                    width: pickerSectionHeight,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Center(
                      child: Text(fillTypes[index].label),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text('Fill Color'),
        ),
        ColorPicker(
          colors: colors,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          activeColorIndex: colors.indexWhere((color) => color == formData.fillColor),
          onColorSelected: (Color color) =>
              onChanged?.call(formData.copyWith(fillColor: color)),
        ),
      ],
    );
  }
}
