import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_face.dart';

class CuboidFormData extends Equatable {
  const CuboidFormData({
    this.topFace,
    this.leftFace,
    this.rightFace,
  });

  final CuboidFaceFormData? topFace;
  final CuboidFaceFormData? leftFace;
  final CuboidFaceFormData? rightFace;

  bool get isValid =>
      topFace != null &&
      topFace!.isValid &&
      leftFace != null &&
      leftFace!.isValid &&
      rightFace != null &&
      rightFace!.isValid;

  @override
  List<Object?> get props => throw UnimplementedError();
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
