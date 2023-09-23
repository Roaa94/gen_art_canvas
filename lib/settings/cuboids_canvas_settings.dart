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

  factory CuboidsCanvasSettings.fromMap(Map<String, dynamic> data) {
    final cuboidsTotalCount = data['cuboidsTotalCount'] as int;
    final maxRandomYOffset = data['maxRandomYOffset'] as double;

    return CuboidsCanvasSettings(
      cuboidsTotalCount: cuboidsTotalCount,
      maxRandomYOffset: maxRandomYOffset,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cuboidsTotalCount': cuboidsTotalCount,
      'maxRandomYOffset': maxRandomYOffset,
    };
  }

  @override
  List<Object?> get props => [
        cuboidsTotalCount,
        maxRandomYOffset,
        defaultPrimaryColor,
      ];
}
