import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gen_art_canvas/cuboids/domain/cuboid_face.dart';

enum CuboidFaceDirection {
  top,
  left,
  right;

  String get title =>
      '${name[0].toUpperCase()}${name.substring(1).toLowerCase()} Face';
}

typedef CuboidFormData = Map<CuboidFaceDirection, CuboidFaceFormData>;

class CuboidFaceFormData extends Equatable {
  const CuboidFaceFormData({
    this.fillType = CuboidFaceFillType.fill,
    this.fillColor,
    this.strokeColor,
    this.strokeWidth = 1,
    this.intensity = 10,
  });

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

  bool get hasStrokePickers {
    return fillType == CuboidFaceFillType.lines;
  }

  bool get hasIntensitySlider {
    return fillType == CuboidFaceFillType.lines;
  }

  bool get isEmpty => fillColor == null;

  bool get formHasFillTypePicked => true;

  bool get formHasFillColorPicker => true;

  bool get formHasStrokeColorPicker => fillType == CuboidFaceFillType.fill;

  CuboidFaceFormData copyWith({
    CuboidFaceFillType? fillType,
    Color? fillColor,
    Color? strokeColor,
    double? strokeWidth,
    int? intensity,
  }) {
    return CuboidFaceFormData(
      fillColor: fillColor ?? this.fillColor,
      fillType: fillType ?? this.fillType,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      intensity: intensity ?? this.intensity,
    );
  }

  @override
  List<Object?> get props => [
        fillType,
        fillColor,
        strokeColor,
        strokeWidth,
        intensity,
      ];
}
