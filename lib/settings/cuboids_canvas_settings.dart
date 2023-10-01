import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';
import 'package:gen_art_canvas/cuboids/domain/cuboid_face.dart';

const defaultColors = [
  AppColors.firebaseOrange,
  AppColors.firebaseYellow,
  AppColors.firebaseGrey,
  AppColors.googleBlue600,
  AppColors.firebaseNavy,
  AppColors.firebaseDarkGrey,
];

class CuboidsCanvasSettings extends Equatable {
  const CuboidsCanvasSettings({
    this.cuboidsTotalCount = 100,
    this.maxRandomYOffset = 170,
    this.defaultPrimaryColor = Colors.grey,
    this.colors = defaultColors,
    this.fillTypes = const [],
  });

  factory CuboidsCanvasSettings.fromMap(Map<String, dynamic> data) {
    final cuboidsTotalCount = data['cuboidsTotalCount'] as int;
    final maxRandomYOffset = (data['maxRandomYOffset'] as num).toDouble();
    final defaultPrimaryColorHex = data['defaultPrimaryColorHex'] as String?;
    final colorHexValues = data['colors'] as List? ?? [];
    final parsedColors = <Color>[];
    for (final colorHex in colorHexValues) {
      final color = AppColors.fromHex(colorHex as String?);
      if (color != null) {
        parsedColors.add(color);
      }
    }
    final fillTypesValues = data['fillTypes'] as List? ?? [];
    final parsedFillTypes = <CuboidFaceFillType>[];
    for (final fillTypeString in fillTypesValues) {
      final fillType = CuboidFaceFillType.values
          .firstWhereOrNull((value) => value.name == fillTypeString);
      if (fillType != null) {
        parsedFillTypes.add(fillType);
      }
    }

    return CuboidsCanvasSettings(
      cuboidsTotalCount: cuboidsTotalCount,
      maxRandomYOffset: maxRandomYOffset,
      defaultPrimaryColor:
          AppColors.fromHex(defaultPrimaryColorHex)?.toMaterial() ??
              Colors.grey,
      colors: parsedColors.isEmpty ? defaultColors : parsedColors,
      fillTypes: parsedFillTypes,
    );
  }

  final int cuboidsTotalCount;
  final double maxRandomYOffset;
  final MaterialColor defaultPrimaryColor;
  final List<Color> colors;
  final List<CuboidFaceFillType> fillTypes;

  Map<String, dynamic> toMap() {
    return {
      'cuboidsTotalCount': cuboidsTotalCount,
      'maxRandomYOffset': maxRandomYOffset,
      'defaultPrimaryColorHex': defaultPrimaryColor.toHex(),
    };
  }

  @override
  List<Object?> get props => [
        cuboidsTotalCount,
        maxRandomYOffset,
        defaultPrimaryColor,
      ];
}
