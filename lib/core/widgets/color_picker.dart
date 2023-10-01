import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    super.key,
    this.colors = const [],
    this.selectedColor,
    this.onChanged,
    this.padding,
  });

  final List<Color> colors;
  final Color? selectedColor;
  final ValueChanged<Color>? onChanged;
  final EdgeInsetsGeometry? padding;

  static const double height = 40;

  @override
  Widget build(BuildContext context) {
    final activeColorIndex =
        colors.indexWhere((color) => color == selectedColor);

    return SizedBox(
      height: height,
      child: ListView(
        padding: padding,
        scrollDirection: Axis.horizontal,
        children: List.generate(
          colors.length,
          (index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: InkWell(
                  onTap: () => onChanged?.call(colors[index]),
                  child: Container(
                    height: height,
                    width: height,
                    decoration: BoxDecoration(
                      color: colors[index],
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                        color: Colors.white.withOpacity(
                          activeColorIndex == index ? 1 : 0.4,
                        ),
                        width: activeColorIndex == index ? 3 : 1,
                      ),
                    ),
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
