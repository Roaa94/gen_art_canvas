import 'package:flutter/material.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';
import 'package:gen_art_canvas/cuboids/domain/cuboid_face.dart';

class FillTypePicker extends StatelessWidget {
  const FillTypePicker({
    required this.fillTypes,
    super.key,
    this.onChanged,
    this.selectedFillType,
  });

  final List<CuboidFaceFillType> fillTypes;
  final ValueChanged<CuboidFaceFillType>? onChanged;
  final CuboidFaceFillType? selectedFillType;

  static const double height = 70;

  @override
  Widget build(BuildContext context) {
    final activeFillTypeIndex =
        fillTypes.indexWhere((fillType) => fillType == selectedFillType);
    final labelTextStyle = Theme.of(context).textTheme.labelSmall!;
    const spacing = 5.0;

    return SizedBox(
      height: height + spacing + (labelTextStyle.fontSize ?? 0),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        children: List.generate(
          fillTypes.length,
          (index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () => onChanged?.call(fillTypes[index]),
                  child: Container(
                    height: height,
                    width: height,
                    decoration: BoxDecoration(
                      color: AppColors.firebaseDarkGrey,
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                        color: Colors.white.withOpacity(
                          activeFillTypeIndex == index ? 1 : 0.4,
                        ),
                        width: activeFillTypeIndex == index ? 3 : 1,
                      ),
                    ),
                    child: fillTypes[index] == CuboidFaceFillType.lines
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(
                              10,
                              (index) => Container(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: spacing),
              Text(
                fillTypes[index].label,
                style: labelTextStyle.copyWith(height: 1),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
