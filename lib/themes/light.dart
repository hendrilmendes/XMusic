import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'transitions.dart';

final defaultFontStyle = GoogleFonts.inter();

ColorScheme lightScheme = ColorScheme.light(
  primary: kAccent,
  secondary: kAccentDeep,
  surface: const Color(0xFFF2F2F7), // Apple iOS secondary light background
  onSurface: Colors.black,
  onPrimary: Colors.white,
);

ThemeData lightTheme({required ColorScheme colorScheme}) {
  return ThemeData.light().copyWith(
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
        Platform.isWindows ? Colors.transparent : Colors.white,
    primaryColor: colorScheme.primary,
    splashColor: kAccent.withOpacity(0.08),
    highlightColor: kAccent.withOpacity(0.05),
    dividerColor: const Color(0xFFE5E5EA),
    cardColor: const Color(0xFFF2F2F7), // Apple Music light mode cards
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: defaultFontStyle.copyWith(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: isSelected ? colorScheme.primary : Colors.black54,
          size: 26,
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: states.contains(WidgetState.selected)
              ? colorScheme.primary
              : Colors.black54,
        ),
      ),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: Colors.transparent,
      selectedIconTheme: IconThemeData(color: colorScheme.primary),
      unselectedIconTheme: const IconThemeData(color: Colors.black54),
      selectedLabelTextStyle: GoogleFonts.inter(
        color: colorScheme.primary,
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
      unselectedLabelTextStyle: GoogleFonts.inter(
        color: Colors.black54,
        fontSize: 12,
      ),
      indicatorColor: Colors.transparent,
    ),
    iconTheme: const IconThemeData(color: Colors.black87),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF2F2F7),
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
      hintStyle: const TextStyle(color: Colors.black38),
    ),
    textTheme: TextTheme(
      headlineLarge: defaultFontStyle.copyWith(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 34, letterSpacing: -1),
      headlineMedium: defaultFontStyle.copyWith(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 28, letterSpacing: -0.5),
      headlineSmall: defaultFontStyle.copyWith(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 22),
      bodyLarge: defaultFontStyle.copyWith(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
      bodyMedium: defaultFontStyle.copyWith(color: Colors.black87, fontSize: 15),
      bodySmall: defaultFontStyle.copyWith(color: Colors.black54, fontSize: 13),
      displayLarge: defaultFontStyle.copyWith(color: Colors.black, fontWeight: FontWeight.w800),
      displayMedium: defaultFontStyle.copyWith(color: Colors.black),
      displaySmall: defaultFontStyle.copyWith(color: Colors.black),
      titleLarge: defaultFontStyle.copyWith(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 20),
      titleMedium: defaultFontStyle.copyWith(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 17),
      titleSmall: defaultFontStyle.copyWith(color: Colors.black54, fontWeight: FontWeight.w500),
      labelLarge: defaultFontStyle.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
      labelMedium: defaultFontStyle.copyWith(color: Colors.black54),
      labelSmall: defaultFontStyle.copyWith(color: Colors.black38, fontSize: 11),
    ),
  );
}
