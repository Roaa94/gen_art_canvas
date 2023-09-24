import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_face.dart';

enum CuboidFace {
  top,
  left,
  right;

  String get title =>
      '${name[0].toUpperCase()}${name.substring(1).toLowerCase()} Face';
}

class CuboidFormData extends Equatable {
  const CuboidFormData({
    this.faces = const {},
  });

  final Map<CuboidFace, CuboidFaceFormData> faces;

  @override
  List<Object?> get props => [faces];
}

class CuboidFaceFormData extends Equatable {
  const CuboidFaceFormData({
    this.fillType,
    this.fillColor,
  });

  bool get isValid {
    if (fillType == CuboidFaceFillType.fill) {
      return fillColor != null;
    }
    return false;
  }

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
