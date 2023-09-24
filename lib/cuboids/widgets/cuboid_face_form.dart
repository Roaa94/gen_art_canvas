import 'package:flutter/material.dart';
import 'package:gen_art_canvas/auth/widgets/color_picker.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_face.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_form_data.dart';
import 'package:gen_art_canvas/cuboids/widgets/fill_type_picker.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text('Fill Type'),
        ),
        FillTypePicker(
          fillTypes: fillTypes,
          selectedFillType: formData.fillType,
          onChanged: (CuboidFaceFillType fillType) =>
              onChanged?.call(formData.copyWith(fillType: fillType)),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text('Fill Color'),
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
}
