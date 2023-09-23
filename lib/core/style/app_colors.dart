import 'package:flutter/material.dart';

class AppColors {
  static const Color firebaseYellow = Color(0xFFFFCA28);
  static const Color firebaseAmber = Color(0xFFFFA000);
  static const Color firebaseOrange = Color(0xFFF57C00);
  static const Color firebaseNavy = Color(0xFF1B3A57);
  static const Color firebaseCoral = Color(0xFFFF8A65);
  static const Color firebaseDarkGrey = Color(0xFF454545);
  static const Color firebaseGrey = Color(0xFFE5EAF0);
  static const Color googleBlue600 = Color(0xFF1A73E8);
  static const Color googleBlue700 = Color(0xFF1967D2);

  static Color getShade(Color color, {bool darker = false, double value = .1}) {
    assert(value >= 0 && value <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness(
        (darker ? (hsl.lightness - value) : (hsl.lightness + value))
            .clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static MaterialColor getMaterialColorFromColor(Color color) {
    Map<int, Color> _colorShades = {
      50: getShade(color, value: 0.5),
      100: getShade(color, value: 0.4),
      200: getShade(color, value: 0.3),
      300: getShade(color, value: 0.2),
      400: getShade(color, value: 0.1),
      500: color, //Primary value
      600: getShade(color, value: 0.1, darker: true),
      700: getShade(color, value: 0.15, darker: true),
      800: getShade(color, value: 0.2, darker: true),
      900: getShade(color, value: 0.25, darker: true),
    };
    return MaterialColor(color.value, _colorShades);
  }
}
