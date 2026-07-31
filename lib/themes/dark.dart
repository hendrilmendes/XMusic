import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'transitions.dart';

final defaultFontStyle = GoogleFonts.inter();

ColorScheme darkScheme = ColorScheme.dark(
  primary: kAccent,
  secondary: kAccentDeep,
  surface: kBgLayer,
  onSurface: kOnGlass,
  onPrimary: Colors.white,
);

ThemeData darkTheme({required ColorScheme colorScheme}) {
  return ThemeData.dark().copyWith(
    colorScheme: colorScheme,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadePageTransitionsBuilder(),
        TargetPlatform.iOS: FadePageTransitionsBuilder(),
        TargetPlatform.windows: FadePageTransitionsBuilder(),
        TargetPlatform.linux: FadePageTransitionsBuilder(),
        TargetPlatform.macOS: FadePageTransitionsBuilder(),
      },
    ),
    scaffoldBackgroundColor:
        Platform.isWindows ? Colors.transparent : kBgDeep,
    primaryColor: colorScheme.primary,
    splashColor: kAccent.withOpacity(0.08),
    highlightColor: kAccent.withOpacity(0.05),
    dividerColor: kBgLayer,
    cardColor: kBgLayer,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: defaultFontStyle.copyWith(
        color: kOnGlass,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: isSelected ? colorScheme.primary : kOnGlassSecondary,
          size: 26,
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: states.contains(WidgetState.selected)
              ? colorScheme.primary
              : kOnGlassSecondary,
        ),
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: Colors.transparent,
      selectedIconTheme: IconThemeData(color: colorScheme.primary),
      unselectedIconTheme: IconThemeData(color: kOnGlassSecondary),
      selectedLabelTextStyle: GoogleFonts.inter(
        color: colorScheme.primary,
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
      unselectedLabelTextStyle: GoogleFonts.inter(
        color: kOnGlassSecondary,
        fontSize: 12,
      ),
      indicatorColor: Colors.transparent,
    ),
    iconTheme: const IconThemeData(color: kOnGlass),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kBgLayer,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: kOnGlassMuted),
    ),
    textTheme: TextTheme(
      headlineLarge: defaultFontStyle.copyWith(color: kOnGlass, fontWeight: FontWeight.w800, fontSize: 34, letterSpacing: -1),
      headlineMedium: defaultFontStyle.copyWith(color: kOnGlass, fontWeight: FontWeight.w700, fontSize: 28, letterSpacing: -0.5),
      headlineSmall: defaultFontStyle.copyWith(color: kOnGlass, fontWeight: FontWeight.w700, fontSize: 22),
      bodyLarge: defaultFontStyle.copyWith(color: kOnGlass, fontSize: 17, fontWeight: FontWeight.w500),
      bodyMedium: defaultFontStyle.copyWith(color: kOnGlass, fontSize: 15),
      bodySmall: defaultFontStyle.copyWith(color: kOnGlassSecondary, fontSize: 13),
      displayLarge: defaultFontStyle.copyWith(color: kOnGlass, fontWeight: FontWeight.w800),
      displayMedium: defaultFontStyle.copyWith(color: kOnGlass),
      displaySmall: defaultFontStyle.copyWith(color: kOnGlass),
      titleLarge: defaultFontStyle.copyWith(color: kOnGlass, fontWeight: FontWeight.w700, fontSize: 20),
      titleMedium: defaultFontStyle.copyWith(color: kOnGlass, fontWeight: FontWeight.w600, fontSize: 17),
      titleSmall: defaultFontStyle.copyWith(color: kOnGlassSecondary, fontWeight: FontWeight.w500),
      labelLarge: defaultFontStyle.copyWith(color: kOnGlass, fontWeight: FontWeight.w600),
      labelMedium: defaultFontStyle.copyWith(color: kOnGlassSecondary),
      labelSmall: defaultFontStyle.copyWith(color: kOnGlassMuted, fontSize: 11),
    ),
  );
}
