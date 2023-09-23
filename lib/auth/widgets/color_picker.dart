import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    super.key,
    this.colors = const [],
    this.activeColorIndex,
    this.onColorSelected,
    this.padding,
  });

  final List<Color> colors;
  final int? activeColorIndex;
  final ValueChanged<Color>? onColorSelected;
  final EdgeInsetsGeometry? padding;

  static const double height = 40;

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () => onColorSelected?.call(colors[index]),
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
