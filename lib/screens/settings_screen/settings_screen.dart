import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../generated/l10n.dart';
import '../../themes/colors.dart';
import '../../themes/text_styles.dart';
import '../../utils/adaptive_widgets/adaptive_widgets.dart';
import 'color_icon.dart';
import 'setting_screen_data.dart';
import '../../widgets/screen_header.dart';
import 'setting_item.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController searchController = TextEditingController();
  bool? isBatteryOptimisationDisabled;

  String searchText = "";

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      checkBatteryOptimisation();
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  Future<void> checkBatteryOptimisation() async {
    isBatteryOptimisationDisabled =
        await Permission.ignoreBatteryOptimizations.isGranted;
    setState(() {});
  }

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
                ScreenHeader(title: S.of(context).Settings),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: AdaptiveTextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    textInputAction: TextInputAction.search,
                    fillColor: Platform.isWindows
                        ? null
                        : darkGreyColor.withAlpha(100),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 8,
                    ),
                    borderRadius: BorderRadius.circular(
                      Platform.isWindows ? 4.0 : 35,
                    ),
                    hintText: S.of(context).Search_Settings,
                    prefix: const Icon(Icons.search),
                    suffix: searchController.text.trim().isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              searchController.text = "";
                              searchText = "";
                              setState(() {});
                            },
                            child: const Icon(CupertinoIcons.clear),
                          )
                        : null,
                  ),
                ),
                if (searchText == "" &&
                    isBatteryOptimisationDisabled != true &&
                    Platform.isAndroid)
                  AdaptiveListTile(
                    backgroundColor: Colors.red.withOpacity(0.3),
                    leading: const ColorIcon(
                      icon: Icons.battery_alert,
                      color: Colors.red,
                    ),
                    title: Text(S.of(context).Battery_Optimisation_title),
                    subtitle: Text(
                      S.of(context).Battery_Optimisation_message,
                      style: tinyTextStyle(context),
                    ),
                    onTap: () async {
                      await Permission.ignoreBatteryOptimizations.request();
                      await checkBatteryOptimisation();
                    },
                  ),
                if (searchText != "")
                  if (allSettingsData(context)
                      .where(
                        (element) => element.title.toLowerCase().contains(
                          searchText.toLowerCase(),
                        ),
                      )
                      .isNotEmpty)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Material(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: allSettingsData(context)
                              .where(
                                (element) => element.title
                                    .toLowerCase()
                                    .contains(searchText.toLowerCase()),
                              )
                              .toList()
                              .asMap()
                              .entries
                              .map((entry) {
                                int index = entry.key;
                                var e = entry.value;
                                return _buildSettingTile(
                                  context,
                                  e,
                                  index,
                                  allSettingsData(context)
                                      .where(
                                        (element) => element.title
                                            .toLowerCase()
                                            .contains(searchText.toLowerCase()),
                                      )
                                      .length,
                                );
                              })
                              .toList(),
                        ),
                      ),
                    ),
                if (searchText == "")
                  ...settingScreenData(context).map((group) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              bottom: 8,
                              top: 8,
                            ),
                            child: Text(
                              group.title.toUpperCase(),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.color,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          Material(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: group.items.asMap().entries.map((
                                entry,
                              ) {
                                return _buildSettingTile(
                                  context,
                                  entry.value,
                                  entry.key,
                                  group.items.length,
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    SettingItem e,
    int index,
    int totalLength,
  ) {
    return Column(
      children: [
        AdaptiveListTile(
          margin: EdgeInsets.zero,
          title: Text(
            e.title,
            style: textStyle(context, bold: false).copyWith(fontSize: 16),
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
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      )
                    : null),
          onTap: () {
            if (e.hasNavigation && e.location != null) {
              context.go(e.location!);
            } else if (e.onTap != null) {
              e.onTap!(context);
            }
          },
          subtitle: e.subtitle != null ? e.subtitle!(context) : null,
        ),
        if (index < totalLength - 1)
          Divider(
            height: 1,
            indent: 56,
            color: Theme.of(context).dividerColor.withOpacity(0.5),
          ),
      ],
    );
  }
}
