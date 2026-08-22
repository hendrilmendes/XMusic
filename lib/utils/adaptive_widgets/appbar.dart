import 'dart:io';
import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'buttons.dart';

class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdaptiveAppBar({
    super.key,
    this.leading,
    this.title,
    this.centerTitle,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.actions,
  });

  final Widget? leading;
  final Widget? title;
  final bool? centerTitle;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      return fluent_ui.Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: fluent_ui.Column(
          children: [
            fluent_ui.PageHeader(
              leading:
                  leading ??
                  (automaticallyImplyLeading && context.canPop()
                      ? const AdaptiveBackButton()
                      : null),
              title: fluent_ui.Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: title,
              ),
              commandBar: actions != null || actions?.isNotEmpty == false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: actions ?? [],
                    )
                  : null,
            ),
            ?bottom,
          ],
        ),
      );
    }

    // Android — Apple Music style clean AppBar. No borders, pure black blend.
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.85),
          child: AppBar(
            leading: leading,
            title: title,
            centerTitle: centerTitle ?? false,
            automaticallyImplyLeading: automaticallyImplyLeading,
            bottom: bottom,
            actions: actions,
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    if (Platform.isWindows) {
      return Size.fromHeight(50.0 + (bottom == null ? 0 : kTextTabBarHeight));
    } else {
      return Size.fromHeight(
        kToolbarHeight + (bottom == null ? 0 : kTextTabBarHeight),
      );
    }
  }
}
