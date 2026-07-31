import 'dart:ui';
import 'package:flutter/material.dart';
import '../themes/colors.dart';

/// A reusable pure blur container for Apple Music style overlays.
/// Renders a frosted surface with heavy blur and no borders.
///
/// Use this ONLY for fixed overlays (TabBar, MiniPlayer).
class GlassBox extends StatelessWidget {
  const GlassBox({
    super.key,
    required this.child,
    this.blur = true,
    this.blurSigma = 30.0,
    this.surfaceOpacity = 0.5,
    this.borderRadius = BorderRadius.zero,
    this.padding,
    this.margin,
    this.border = false,
    this.width,
    this.height,
    this.onTap,
  });

  final Widget child;
  final bool blur;
  final double blurSigma;
  final double surfaceOpacity;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool border;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget box = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: kBgDeep.withOpacity(surfaceOpacity),
        border: border
            ? Border(top: BorderSide(color: kGlassBorderStrong, width: 0.3))
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );

    if (blur) {
      box = ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: box,
        ),
      );
    }

    if (margin != null || onTap != null) {
      box = Container(
        margin: margin,
        child: onTap != null
            ? InkWell(
                onTap: onTap,
                borderRadius: borderRadius,
                child: box,
              )
            : box,
      );
    }

    return box;
  }
}
