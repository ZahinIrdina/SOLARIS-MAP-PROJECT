import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Colours sampled from the wireframes.
class AppColors {
  static const maroon = Color(0xFF960000);
  static const charcoal = Color(0xFF404040);
  static const placeholder = Color(0xFFEDEDED);
  static const placeholderAccent = Color(0xFFFF9999);
  static const labelGrey = Color(0xFF8C8C8C);
  static const divider = Color(0xFFE2E2E2);
  static const onMaroonSoft = Color(0xFFEDEDED);
}

/// Headings / values use Libre Baskerville, small captions and buttons use
/// Source Sans — the two faces used in the design.
class AppFonts {
  static TextStyle serif({
    double size = 16,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.maroon,
    double? height,
  }) =>
      GoogleFonts.libreBaskerville(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
      );

  static TextStyle sans({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = Colors.black87,
    double? height,
  }) =>
      GoogleFonts.sourceSans3(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
      );
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.maroon,
    primary: AppColors.maroon,
    brightness: Brightness.light,
  );

  OutlineInputBorder border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: width),
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.sourceSans3TextTheme(),
    inputDecorationTheme: InputDecorationTheme(
      border: border(AppColors.divider),
      enabledBorder: border(AppColors.divider),
      focusedBorder: border(AppColors.maroon, 1.6),
      errorBorder: border(Colors.red.shade700),
      focusedErrorBorder: border(Colors.red.shade700, 1.6),
      labelStyle: AppFonts.sans(color: AppColors.labelGrey, size: 16),
      floatingLabelStyle: AppFonts.sans(color: AppColors.maroon, size: 16),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.maroon,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        textStyle: AppFonts.sans(size: 17, weight: FontWeight.w700),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.maroon),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
