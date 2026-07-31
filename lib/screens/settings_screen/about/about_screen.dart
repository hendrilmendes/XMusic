import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:orbit_music/main.dart';

import '../../../generated/l10n.dart';
import '../../../themes/colors.dart';
import '../../../themes/text_styles.dart';
import '../../../utils/adaptive_widgets/adaptive_widgets.dart';
import '../color_icon.dart';

import '../settings_group.dart';
import '../../../utils/bottom_modals.dart';
import '../../../utils/check_update.dart';
import '../../../widgets/screen_header.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: null,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      ScreenHeader(
                        title: S.of(context).About,
                        showBackButton: true,
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/icon.png',
                            height: 100,
                            width: 100,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: darkGreyColor.withAlpha(50),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SettingsGroup(
                        children: [
                          AdaptiveListTile(
                            margin: EdgeInsets.zero,
                            leading: const ColorIcon(
                              color: null,
                              icon: Icons.new_releases,
                            ),
                            title: Text(
                              S.of(context).Version,
                              style: textStyle(
                                context,
                                bold: false,
                              ).copyWith(fontSize: 16),
                            ),
                            trailing: Text(
                              appConfig.codeName,
                              style: smallTextStyle(context),
                            ),
                          ),
                          AdaptiveListTile(
                            margin: EdgeInsets.zero,
                            leading: const ColorIcon(
                              color: null,
                              icon: Icons.update_outlined,
                            ),
                            title: Text(
                              S.of(context).Check_For_Update,
                              style: textStyle(
                                context,
                                bold: false,
                              ).copyWith(fontSize: 16),
                            ),
                            trailing: Icon(
                              AdaptiveIcons.chevron_right,
                              size: 20,
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color,
                            ),
                            onTap: () async {
                              Modals.showCenterLoadingModal(context);
                              checkUpdate().then((updateInfo) {
                                Navigator.pop(context);
                                Modals.showUpdateDialog(context, updateInfo);
                              });
                            },
                          ),
                          AdaptiveListTile(
                            margin: EdgeInsets.zero,
                            leading: const ColorIcon(
                              color: null,
                              icon: CupertinoIcons.person,
                            ),
                            title: Text(
                              S.of(context).Developer,
                              style: textStyle(
                                context,
                                bold: false,
                              ).copyWith(fontSize: 16),
                            ),
                            trailing: Wrap(
                              alignment: WrapAlignment.center,
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  S.of(context).Hendril_Mendes,
                                  style: smallTextStyle(context),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  AdaptiveIcons.chevron_right,
                                  size: 20,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.color,
                                ),
                              ],
                            ),
                            onTap: () => launchUrl(
                              Uri.parse('https://github.com/hendrilmendes'),
                              mode: LaunchMode.externalApplication,
                            ),
                          ),
                          AdaptiveListTile(
                            margin: EdgeInsets.zero,
                            leading: const ColorIcon(
                              color: null,
                              icon: Icons.link,
                            ),
                            title: Text(
                              "Website",
                              style: textStyle(
                                context,
                                bold: false,
                              ).copyWith(fontSize: 16),
                            ),
                            trailing: Icon(
                              AdaptiveIcons.chevron_right,
                              size: 20,
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color,
                            ),
                            onTap: () => launchUrl(
                              Uri.parse('https://hendevs.com'),
                              mode: LaunchMode.externalApplication,
                            ),
                          ),
                          AdaptiveListTile(
                            margin: EdgeInsets.zero,
                            leading: const ColorIcon(
                              color: null,
                              icon: Icons.code,
                            ),
                            title: Text(
                              S.of(context).Source_Code,
                              style: textStyle(
                                context,
                                bold: false,
                              ).copyWith(fontSize: 16),
                            ),
                            trailing: Icon(
                              AdaptiveIcons.chevron_right,
                              size: 20,
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color,
                            ),
                            onTap: () => launchUrl(
                              Uri.parse(
                                'https://github.com/hendrilmendes/Orbit-Music',
                              ),
                              mode: LaunchMode.externalApplication,
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(S.of(context).Made_In_Brazil),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
