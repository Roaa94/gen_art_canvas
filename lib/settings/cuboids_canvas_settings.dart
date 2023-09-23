import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';

class CuboidsCanvasSettings extends Equatable {
  const CuboidsCanvasSettings({
    this.cuboidsTotalCount = 100,
    this.maxRandomYOffset = 170,
    this.defaultPrimaryColor = Colors.grey,
  });

  final int cuboidsTotalCount;
  final double maxRandomYOffset;
  final MaterialColor defaultPrimaryColor;

  factory CuboidsCanvasSettings.fromMap(Map<String, dynamic> data) {
    final cuboidsTotalCount = data['cuboidsTotalCount'] as int;
    final maxRandomYOffset = data['maxRandomYOffset'].toDouble();
    final defaultPrimaryColorHex = data['defaultPrimaryColorHex'] as String?;
    final defaultPrimaryColor = defaultPrimaryColorHex != null
        ? Color(int.parse('0xFF$defaultPrimaryColorHex'))
        : null;

    return CuboidsCanvasSettings(
      cuboidsTotalCount: cuboidsTotalCount,
      maxRandomYOffset: maxRandomYOffset,
      defaultPrimaryColor: defaultPrimaryColor != null
          ? AppColors.getMaterialColorFromColor(defaultPrimaryColor)
          : Colors.grey,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cuboidsTotalCount': cuboidsTotalCount,
      'maxRandomYOffset': maxRandomYOffset,
    };
  }

  @override
  List<Object?> get props => [
        cuboidsTotalCount,
        maxRandomYOffset,
        defaultPrimaryColor,
      ];
}
