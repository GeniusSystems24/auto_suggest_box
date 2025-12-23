import 'package:fluent_ui/fluent_ui.dart';

extension AccentColorExtension on AccentColor {
  WidgetStateProperty<Color> backgroundButton(Brightness brightness) {
    return WidgetStateProperty.resolveWith((states) {
      final isLight = brightness.isLight;
      if (states.contains(WidgetState.disabled)) {
        return isLight ? Colors.grey[100] : Colors.grey[140];
      }
      if (states.contains(WidgetState.pressed)) {
        return isLight ? lightest : darkest;
      }
      if (states.contains(WidgetState.hovered)) {
        return isLight ? lighter : darker;
      }
      return this;
    });
  }
}
