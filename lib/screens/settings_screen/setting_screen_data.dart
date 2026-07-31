import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import 'appearence/appearence_screen_data.dart';
import 'content/content_screen_data.dart';
import 'playback/audio_and_playback_screen_data.dart';
import 'setting_item.dart';

List<SettingGroup> settingScreenData(BuildContext context) => [
  SettingGroup(
    title: S.of(context).Appearence,
    items: [
      SettingItem(
        title: S.of(context).Appearence,
        icon: Icons.looks,
        color: Colors.accents[0],
        hasNavigation: true,
        location: '/settings/appearence',
      ),
      SettingItem(
        title: S.of(context).Language,
        icon: Icons.language,
        color: Colors.accents[12],
        hasNavigation: true,
        location: '/settings/language',
      ),
    ],
  ),
  SettingGroup(
    title: S.of(context).Audio_And_Playback,
    items: [
      SettingItem(
        title: S.of(context).Content,
        icon: CupertinoIcons.music_note_list,
        color: Colors.accents[1],
        hasNavigation: true,
        location: '/settings/content',
      ),
      SettingItem(
        title: S.of(context).Audio_And_Playback,
        icon: CupertinoIcons.music_note,
        color: Colors.accents[2],
        hasNavigation: true,
        location: '/settings/playback',
      ),
    ],
  ),
  SettingGroup(
    title: S.of(context).About,
    items: [
      SettingItem(
        title: S.of(context).Backup_And_Restore,
        icon: Icons.settings_backup_restore_outlined,
        color: Colors.accents[3],
        hasNavigation: true,
        location: '/settings/backup_restore',
      ),
      SettingItem(
        title: S.of(context).About,
        icon: Icons.info_rounded,
        color: Colors.accents[4],
        hasNavigation: true,
        location: '/settings/about',
      ),
    ],
  ),
];
List<SettingItem> allSettingsData(BuildContext context) => [
  ...settingScreenData(context).expand((group) => group.items),
  ...appearenceScreenData(context),
  ...contentScreenData(context),
  ...audioandplaybackScreenData(context),
];
