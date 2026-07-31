import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../generated/l10n.dart';
import '../../../themes/text_styles.dart';
import '../../../utils/adaptive_widgets/adaptive_widgets.dart';
import '../color_icon.dart';
import 'content_screen_data.dart';

import '../settings_group.dart';
import '../../../widgets/screen_header.dart';

class ContentScreen extends StatelessWidget {
  const ContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: null,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ScreenHeader(
                  title: S.of(context).Content,
                  showBackButton: true,
                ),
                SettingsGroup(
                  children: contentScreenData(context).map((e) {
                    return AdaptiveListTile(
                      margin: EdgeInsets.zero,
                      title: Text(
                        e.title,
                        style: textStyle(
                          context,
                          bold: false,
                        ).copyWith(fontSize: 16),
                      ),
                      leading: (e.icon != null)
                          ? ColorIcon(color: e.color, icon: e.icon!)
                          : null,
                      trailing: e.trailing != null
                          ? e.trailing!(context)
                          : (e.hasNavigation
                                ? Icon(
                                    AdaptiveIcons.chevron_right,
                                    size: 20,
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.color,
                                  )
                                : null),
                      onTap:
                          (e.hasNavigation && e.location != null) ||
                              e.onTap != null
                          ? () {
                              if (e.hasNavigation && e.location != null) {
                                context.go(e.location!);
                              } else if (e.onTap != null) {
                                e.onTap!(context);
                              }
                            }
                          : null,
                      subtitle: e.subtitle != null
                          ? e.subtitle!(context)
                          : null,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
