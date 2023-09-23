import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';

class CuboidFace extends Equatable {
  const CuboidFace({
    required this.fillType,
    this.fillColor,
  });

  final CuboidFaceFillType fillType;
  final Color? fillColor;

  bool get isValid {
    if (fillType == CuboidFaceFillType.fill) {
      return fillColor != null;
    }
    return false;
  }

  factory CuboidFace.fromMap(Map<String, dynamic> data) {
    final CuboidFaceFillType? fillType = data['fillType'] == null
        ? CuboidFaceFillType.fill
        : CuboidFaceFillType.values.firstWhereOrNull(
            (element) => element.name == (data['fillType']) as String,
          );
    final fillColorHex = data['fillColor'] as String?;

    return CuboidFace(
      fillType: fillType ?? CuboidFaceFillType.fill,
      fillColor: AppColors.fromHex(fillColorHex),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fillType': fillType.name,
      'fillColor': fillColor,
    };
  }

  @override
  List<Object?> get props => [
        fillType,
        fillColor,
      ];
}

enum CuboidFaceFillType {
  fill;

  String get label {
    switch (this) {
      case fill:
        return 'Fill';
    }
  }
}
