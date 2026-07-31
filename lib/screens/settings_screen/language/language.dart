import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:orbit_music/generated/l10n.dart';
import 'package:orbit_music/services/settings_manager.dart';
import 'package:orbit_music/themes/text_styles.dart';
import 'package:orbit_music/utils/adaptive_widgets/adaptive_widgets.dart';

import '../settings_group.dart';
import '../../../widgets/screen_header.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final settingsManager = context.watch<SettingsManager>();

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
                  title: s.Language,
                  showBackButton: true,
                ),
                SettingsGroup(
                  children: S.delegate.supportedLocales.map((locale) {
                    final code = locale.languageCode.toLowerCase();

                    return AdaptiveListTile(
                      margin: EdgeInsets.zero,
                      leading: const Icon(Icons.language, size: 30),
                      title: Text(
                        _getLocalizedLanguageName(code, context),
                        style: textStyle(context, bold: false).copyWith(fontSize: 16),
                      ),
                      trailing: settingsManager.language['value'] == code
                          ? Icon(Icons.check, size: 24, color: Theme.of(context).textTheme.bodySmall?.color)
                          : null,
                      onTap: () {
                        context.read<SettingsManager>().language = {
                          'name': _getLocalizedLanguageName(code, context),
                          'value': code,
                        };
                      },
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

  String _getLocalizedLanguageName(String code, BuildContext context) {
    final s = S.of(context);
    switch (code) {
      case 'en':
        return s.English;
      case 'pt':
        return s.Portuguese;
      case 'es':
        return s.Spanish;
      default:
        return s.Portuguese;
    }
  }
}
