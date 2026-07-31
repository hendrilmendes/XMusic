import 'package:flutter/material.dart';

// ─── Apple Music Style Tokens ───────────────────────────────────────────────
const Color kBgDeep = Color(0xFF000000); // Pure Black (AMOLED)
const Color kBgLayer = Color(0xFF1C1C1E); // Elevated surfaces (dark gray)

// ─── Glass surface (pure blur, minimal color) ──────────────────────────────
const Color kGlassSurface = Color(0x331C1C1E);
const Color kGlassBorder = Colors.transparent;
const Color kGlassBorderStrong = Color(0x1AFFFFFF);

// ─── Accent (Vibrant Pink/Red) ────────────────────────────────────────────────
const Color kAccent = Color(0xFFFA243C);
const Color kAccentDeep = Color(0xFFE0182C);
const Color kAccentGlow = Colors.transparent; // No glow in Apple Music

// ─── Text on dark ────────────────────────────────────────────────────────────
const Color kOnGlass = Color(0xFFFFFFFF);            // Pure white
const Color kOnGlassSecondary = Color(0xFF8E8E93);   // Gray for subtitles
const Color kOnGlassMuted = Color(0xFF636366);       // Deeper gray

// ─── Legacy compat ───────────────────────────────────────────────────────────
Color greyColor = Colors.grey.withAlpha(100);
Color darkGreyColor = Colors.grey.withAlpha(70);

const MaterialColor primaryBlack = MaterialColor(
  0xFF000000,
  <int, Color>{
    50: Color.fromRGBO(0, 0, 0, .1),
    100: Color.fromRGBO(0, 0, 0, .2),
    200: Color.fromRGBO(0, 0, 0, .3),
    300: Color.fromRGBO(0, 0, 0, .4),
    400: Color.fromRGBO(0, 0, 0, .5),
    500: Color.fromRGBO(0, 0, 0, .6),
    600: Color.fromRGBO(0, 0, 0, .7),
    700: Color.fromRGBO(0, 0, 0, .8),
    800: Color.fromRGBO(0, 0, 0, .9),
    900: Color.fromRGBO(0, 0, 0, 1),
  },
);

const MaterialColor primaryWhite = MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Color.fromRGBO(255, 255, 255, .1),
    100: Color.fromRGBO(255, 255, 255, .2),
    200: Color.fromRGBO(255, 255, 255, .3),
    300: Color.fromRGBO(255, 255, 255, .4),
    400: Color.fromRGBO(255, 255, 255, .5),
    500: Color.fromRGBO(255, 255, 255, .6),
    600: Color.fromRGBO(255, 255, 255, .7),
    700: Color.fromRGBO(255, 255, 255, .8),
    800: Color.fromRGBO(255, 255, 255, .9),
    900: Color.fromRGBO(255, 255, 255, 1),
  },
);
