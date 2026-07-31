import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;

class Adaptivecard extends StatelessWidget {
  const Adaptivecard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderRadius,
    this.margin,
    this.padding,
    this.elevation,
  });

  final Widget child;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      return fluent_ui.Card(
        padding: padding ?? const EdgeInsets.all(12.0),
        backgroundColor: backgroundColor,
        margin: margin,
        borderRadius:
            borderRadius ?? const BorderRadius.all(Radius.circular(12.0)),
        child: child,
      );
    }

    // Android — Apple Music style flat surface, no borders, simple color.
    return Container(
      margin: margin ?? const EdgeInsets.all(2),
      padding: padding ?? const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).cardColor,
        borderRadius:
            borderRadius ?? const BorderRadius.all(Radius.circular(12)),
      ),
      child: child,
    );
  }
}
