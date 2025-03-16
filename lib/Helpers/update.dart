import 'package:logging/logging.dart';

bool compareVersion(String latestVersion, String currentVersion) {
  bool update = false;
  final List latestList = latestVersion.split('.');
  final List currentList = currentVersion.split('.');

  for (int i = 0; i < latestList.length; i++) {
    try {
      if (int.parse(latestList[i] as String) >
          int.parse(currentList[i] as String)) {
        update = true;
        break;
      }
    } catch (e) {
      Logger.root.severe('Error while comparing versions: $e');
      break;
    }
  }
  return update;
}
