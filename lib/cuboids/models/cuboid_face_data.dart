import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CuboidFaceData extends Equatable {
  const CuboidFaceData({
    required this.id,
    required this.cuboidId,
    required this.fillType,
    this.fillColor,
  }) : assert(fillType == CuboidFaceFillType.fill ? fillColor != null : true);

  final String id;
  final String cuboidId;
  final CuboidFaceFillType fillType;
  final Color? fillColor;

  @override
  List<Object?> get props => [
        id,
        cuboidId,
        fillType,
        fillColor,
      ];
}

enum CuboidFaceFillType {
  fill,
}
