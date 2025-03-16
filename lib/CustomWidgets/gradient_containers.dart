import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:xmusic/Helpers/config.dart';

class GradientContainer extends StatefulWidget {
  final Widget? child;
  final bool? opacity;
  final bool? borderRadius;
  const GradientContainer({
    required this.child,
    this.opacity,
    this.borderRadius,
  });
  @override
  _GradientContainerState createState() => _GradientContainerState();
}

class _GradientContainerState extends State<GradientContainer> {
  MyTheme currentTheme = GetIt.I<MyTheme>();
  @override
  Widget build(BuildContext context) {
    // ignore: use_decorated_box
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              Theme.of(context).brightness == Brightness.dark
                  ? ((widget.opacity == true)
                      ? currentTheme.getTransBackGradient()
                      : currentTheme.getBackGradient())
                  : [const Color(0xfff5f9ff), Colors.white],
        ),
        borderRadius:
            widget.borderRadius ?? false
                ? const BorderRadius.all(Radius.circular(15))
                : null,
      ),
      margin:
          widget.borderRadius ?? false
              ? const EdgeInsets.symmetric(horizontal: 2.0)
              : null,
      child: widget.child,
    );
  }
}

class BottomGradientContainer extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  const BottomGradientContainer({
    required this.child,
    this.margin,
    this.padding,
    this.borderRadius,
  });
  @override
  _BottomGradientContainerState createState() =>
      _BottomGradientContainerState();
}

class _BottomGradientContainerState extends State<BottomGradientContainer> {
  MyTheme currentTheme = GetIt.I<MyTheme>();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.fromLTRB(25, 0, 25, 25),
      padding: widget.padding ?? const EdgeInsets.fromLTRB(10, 15, 10, 15),
      decoration: BoxDecoration(
        borderRadius:
            widget.borderRadius ??
            const BorderRadius.all(Radius.circular(15.0)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              Theme.of(context).brightness == Brightness.dark
                  ? currentTheme.getBottomGradient()
                  : [Colors.white, Theme.of(context).canvasColor],
        ),
      ),
      child: widget.child,
    );
  }
}

class GradientCard extends StatefulWidget {
  final Widget child;
  final BorderRadius? radius;
  final double? elevation;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final List<Color>? gradientColors;
  final AlignmentGeometry? gradientBegin;
  final AlignmentGeometry? gradientEnd;
  const GradientCard({
    required this.child,
    this.radius,
    this.elevation,
    this.margin,
    this.padding,
    this.gradientColors,
    this.gradientBegin,
    this.gradientEnd,
  });
  @override
  _GradientCardState createState() => _GradientCardState();
}

class _GradientCardState extends State<GradientCard> {
  MyTheme currentTheme = GetIt.I<MyTheme>();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.elevation ?? 3,
      shape: RoundedRectangleBorder(
        borderRadius: widget.radius ?? BorderRadius.circular(10.0),
      ),
      clipBehavior: Clip.antiAlias,
      margin: widget.margin ?? EdgeInsets.zero,
      color: Colors.transparent,
      child:
          widget.elevation == 0
              ? widget.child
              : DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: widget.gradientBegin ?? Alignment.topLeft,
                    end: widget.gradientEnd ?? Alignment.bottomRight,
                    colors:
                        widget.gradientColors ??
                        (Theme.of(context).brightness == Brightness.dark
                            ? currentTheme.getCardGradient()
                            : [Colors.white, Theme.of(context).canvasColor]),
                  ),
                ),
                child: Padding(
                  padding: widget.padding ?? EdgeInsets.zero,
                  child: widget.child,
                ),
              ),
    );
  }
}
