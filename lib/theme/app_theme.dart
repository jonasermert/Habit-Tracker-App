import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const backgroundLight = Color(0xFFF5F5F5);
  static const backgroundDark = Color(0xFF171717);
  static const surfaceLight = Color(0xFFFAFAFA);
  static const surfaceDark = Color(0xFF262626);
  static const foregroundLight = Color(0xFF0A0A0A);
  static const foregroundDark = Color(0xFFFAFAFA);
  static const accentLight = Color(0xFF15803D);
  static const accentDark = Color(0xFF4ADE80);

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final background = dark ? backgroundDark : backgroundLight;
    final surface = dark ? surfaceDark : surfaceLight;
    final foreground = dark ? foregroundDark : foregroundLight;
    final accent = dark ? accentDark : accentLight;
    final border = dark ? const Color(0xFF404040) : const Color(0xFFE5E5E5);
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(20));

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: foreground,
        onPrimary: background,
        secondary: accent,
        onSecondary: dark ? foregroundLight : foregroundDark,
        error: const Color(0xFFEF4444),
        onError: Colors.white,
        surface: surface,
        onSurface: foreground,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: foreground,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: shape.copyWith(side: BorderSide(color: border)),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: DividerThemeData(color: border),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: accent, width: 2),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? accent : null,
        ),
        checkColor: WidgetStatePropertyAll(dark ? foregroundLight : foregroundDark),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          backgroundColor: surface,
          foregroundColor: foreground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: foreground,
        foregroundColor: background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
