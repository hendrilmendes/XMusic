import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xmusic/generated/l10n.dart';
import 'package:xmusic/services/settings_manager.dart';
import 'package:xmusic/themes/text_styles.dart';
import 'package:xmusic/utils/adaptive_widgets/adaptive_widgets.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final settingsManager = context.watch<SettingsManager>();

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: Text(s.Language, style: mediumTextStyle(context)),
        leading: const AdaptiveBackButton(),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            children:
                S.delegate.supportedLocales.map((locale) {
                  final code = locale.languageCode.toLowerCase();

                  return AdaptiveListTile(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    leading: const Icon(Icons.language, size: 30),
                    title: Text(
                      _getLocalizedLanguageName(code, context),
                      style: textStyle(
                        context,
                        bold: false,
                      ).copyWith(fontSize: 16),
                    ),
                    trailing:
                        settingsManager.language['value'] == code
                            ? const Icon(Icons.check, size: 30)
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
