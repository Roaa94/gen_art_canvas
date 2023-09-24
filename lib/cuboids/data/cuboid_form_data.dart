import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_face.dart';

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
    this.fillType,
    this.fillColor,
  });

  bool get isValid {
    if (fillType == null) {
      return false;
    }
    if (fillType == CuboidFaceFillType.fill) {
      return fillColor != null;
    }
    return false;
  }

  bool get isEmpty => fillType == null && fillColor == null;

  bool get formHasFillTypePicked => true;

  bool get formHasFillColorPicker => true;

  bool get formHasStrokeColorPicker => fillType == CuboidFaceFillType.fill;

  final CuboidFaceFillType? fillType;
  final Color? fillColor;

  CuboidFaceFormData copyWith({
    CuboidFaceFillType? fillType,
    Color? fillColor,
  }) {
    return CuboidFaceFormData(
      fillColor: fillColor ?? this.fillColor,
      fillType: fillType ?? this.fillType,
    );
  }

  @override
  List<Object?> get props => [
        fillType,
        fillColor,
      ];
}
