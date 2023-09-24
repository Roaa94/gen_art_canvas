import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gen_art_canvas/core/style/app_colors.dart';
import 'package:gen_art_canvas/cuboids/data/cuboid_form_data.dart';

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

  factory CuboidFace.fromFormData(CuboidFaceFormData formData) {
    if (!formData.isValid) {
      throw Exception('Form data is invalid!');
    }
    return CuboidFace(
      fillType: formData.fillType!,
      fillColor: formData.fillColor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fillType': fillType.name,
      'fillColor': fillColor?.toHex(),
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
        return 'Solid Fill';
    }
  }
}
