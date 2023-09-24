import 'package:flutter/material.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_face.dart';

class FillTypePicker extends StatelessWidget {
  const FillTypePicker({
    super.key,
    required this.fillTypes,
    this.onChanged,
    this.selectedFillType,
  });

  final List<CuboidFaceFillType> fillTypes;
  final ValueChanged<CuboidFaceFillType>? onChanged;
  final CuboidFaceFillType? selectedFillType;

  static const double height = 80;

  @override
  Widget build(BuildContext context) {
    final activeFillTypeIndex = fillTypes.indexWhere((fillType) => fillType == selectedFillType);

    return SizedBox(
      height: height,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        children: List.generate(
          fillTypes.length,
          (index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => onChanged?.call(fillTypes[index]),
                child: Container(
                  height: height,
                  width: height,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: Colors.white.withOpacity(
                        activeFillTypeIndex == index ? 1 : 0.4,
                      ),
                      width: activeFillTypeIndex == index ? 3 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(fillTypes[index].label),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
