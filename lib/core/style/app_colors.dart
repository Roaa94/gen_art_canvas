import 'package:flutter/material.dart';

class AppColors {
  static const Color firebaseYellow = Color(0xFFFFCA28);
  static const Color firebaseAmber = Color(0xFFFFA000);
  static const Color primary = firebaseAmber;
  static const Color firebaseOrange = Color(0xFFF57C00);
  static const Color firebaseNavy = Color(0xFF1B3A57);
  static const Color firebaseCoral = Color(0xFFFF8A65);
  static const Color firebaseDarkGrey = Color(0xFF454545);
  static const Color firebaseGrey = Color(0xFFE5EAF0);
  static const Color googleBlue600 = Color(0xFF1A73E8);
  static const Color googleBlue700 = Color(0xFF1967D2);

  static Color? fromHex(String? hex) {
    if (hex == null || hex.isEmpty || (hex.length != 6 && hex.length != 8)) {
      return null;
    }
    if (hex.length == 6) {
      return Color(int.parse('0xFF$hex'));
    }
    if (hex.length == 8) {
      return Color(int.parse('0x$hex'));
    }
    return null;
  }
}

extension ColorExtension on Color {
  Color getShade({bool darker = false, double value = .1}) {
    assert(value >= 0 && value <= 1, 'Value should be between 0 and 1');

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness(
      (darker ? (hsl.lightness - value) : (hsl.lightness + value))
          .clamp(0.0, 1.0),
    );

    return hslDark.toColor();
  }

  MaterialColor toMaterial() {
    final colorShades = <int, Color>{
      50: getShade(value: 0.5),
      100: getShade(value: 0.4),
      200: getShade(value: 0.3),
      300: getShade(value: 0.2),
      400: getShade(),
      500: this, //Primary value
      600: getShade(darker: true),
      700: getShade(value: 0.15, darker: true),
      800: getShade(value: 0.2, darker: true),
      900: getShade(value: 0.25, darker: true),
    };
    return MaterialColor(value, colorShades);
  }

  String toHex({bool leadingHashSign = false, bool withAlpha = false}) {
    var hex = '';
    if (leadingHashSign) hex += '#';
    if (withAlpha) hex += alpha.toRadixString(16).padLeft(2, '0');
    hex += red.toRadixString(16).padLeft(2, '0');
    hex += green.toRadixString(16).padLeft(2, '0');
    hex += blue.toRadixString(16).padLeft(2, '0');
    return hex;
  }
}
