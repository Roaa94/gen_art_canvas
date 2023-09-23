import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CuboidsCanvasSettings extends Equatable {
  const CuboidsCanvasSettings({
    this.cuboidsTotalCount = 100,
    this.maxRandomYOffset = 170,
    this.defaultPrimaryColor = Colors.grey,
  });

  final int cuboidsTotalCount;
  final double maxRandomYOffset;
  final MaterialColor defaultPrimaryColor;

  @override
  List<Object?> get props => [
        cuboidsTotalCount,
        maxRandomYOffset,
        defaultPrimaryColor,
      ];
}
