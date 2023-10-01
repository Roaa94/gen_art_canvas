import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';
import 'package:gen_art_canvas/cuboids/presentation/cuboid_form_data.dart';

class CuboidFace extends Equatable {
  const CuboidFace({
    required this.fillType,
    this.fillColor,
    this.strokeColor,
    this.strokeWidth = 1,
    this.intensity = 1,
  });

  factory CuboidFace.fromMap(Map<String, dynamic> data) {
    final fillType = data['fillType'] == null
        ? CuboidFaceFillType.fill
        : CuboidFaceFillType.values.firstWhereOrNull(
            (element) => element.name == (data['fillType']) as String,
          );
    final fillColorHex = data['fillColor'] as String?;
    final strokeColorHex = data['strokeColor'] as String?;

    return CuboidFace(
      fillType: fillType ?? CuboidFaceFillType.fill,
      fillColor: AppColors.fromHex(fillColorHex),
      strokeColor: AppColors.fromHex(strokeColorHex),
      strokeWidth: (data['strokeWidth'] as num?)?.toDouble() ?? 1,
      intensity: data['intensity'] as int? ?? 1,
    );
  }

  factory CuboidFace.fromValidFormData(CuboidFaceFormData formData) {
    if (!formData.isValid) {
      throw Exception('Form data is invalid!');
    }
    return CuboidFace(
      fillType: formData.fillType,
      fillColor: formData.fillColor,
      strokeColor: formData.strokeColor,
      strokeWidth: formData.strokeWidth,
      intensity: formData.intensity,
    );
  }

  factory CuboidFace.fromFormData(CuboidFaceFormData formData) {
    return CuboidFace(
      fillType: formData.fillType,
      fillColor: formData.fillColor,
      strokeColor: formData.strokeColor,
      strokeWidth: formData.strokeWidth,
      intensity: formData.intensity,
    );
  }

  final CuboidFaceFillType fillType;
  final Color? fillColor;
  final Color? strokeColor;
  final double strokeWidth;
  final int intensity;

  bool get isValid {
    if (fillType == CuboidFaceFillType.fill) {
      return fillColor != null;
    }
    if (fillType == CuboidFaceFillType.lines) {
      return fillColor != null && strokeColor != null;
    }
    return false;
  }

  Map<String, dynamic> toMap() {
    return {
      'fillType': fillType.name,
      'fillColor': fillColor?.toHex(),
      'strokeColor': strokeColor?.toHex(),
      'strokeWidth': strokeWidth,
      'intensity': intensity,
    };
  }

  @override
  List<Object?> get props => [
        fillType,
        fillColor,
      ];
}

enum CuboidFaceFillType {
  fill,
  lines;

  String get label {
    switch (this) {
      case fill:
        return 'Solid Fill';
      case lines:
        return 'Lines';
    }
  }
}
