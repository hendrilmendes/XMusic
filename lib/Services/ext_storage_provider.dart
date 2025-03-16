import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: avoid_classes_with_only_static_members
class ExtStorageProvider {
  // asking for permission
  static Future<bool> requestPermission(Permission permission) async {
    final PermissionStatus status = await permission.status;
    if (kDebugMode) {
      print('Permission status for $permission: $status');
    }
    if (status.isGranted) {
      return true;
    } else {
      final PermissionStatus result = await permission.request();
      if (kDebugMode) {
        print('Permission request result for $permission: $result');
      }
      return result.isGranted;
    }
  }

  static Future<bool> requestManageExternalStoragePermission() async {
    if (Platform.isAndroid &&
        int.tryParse(Platform.version.split('.')[0])! >= 30) {
      // Android 11 or higher, use MANAGE_EXTERNAL_STORAGE permission
      return requestPermission(Permission.manageExternalStorage);
    } else {
      // Android 10 or lower, use WRITE_EXTERNAL_STORAGE permission
      return requestPermission(Permission.storage);
    }
  }

  static Future<String?> getExtStorage({
    required String dirName,
    required bool writeAccess,
  }) async {
    Directory? directory;

    try {
      // checking platform
      if (Platform.isAndroid) {
        // Request storage permission
        final bool storagePermissionGranted =
            await requestManageExternalStoragePermission();
        if (kDebugMode) {
          print('Storage permission granted: $storagePermissionGranted');
        }

        if (storagePermissionGranted) {
          directory = await getExternalStorageDirectory();

          if (directory == null) {
            throw 'External storage not available';
          }

          final String newPath = directory.path.replaceFirst(
            'Android/data/com.github.hendrilmendes.music/files',
            dirName,
          );

          directory = Directory(newPath);

          // checking if directory exist or not
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }

          if (await directory.exists()) {
            return newPath;
          } else {
            throw 'Directory could not be created';
          }
        } else {
          throw 'Storage permission denied';
        }
      } else if (Platform.isIOS || Platform.isMacOS) {
        directory = await getApplicationDocumentsDirectory();
        final finalDirName = dirName.replaceAll('XMusic/', '');
        return '${directory.path}/$finalDirName';
      } else {
        directory = await getDownloadsDirectory();
        return '${directory!.path}/$dirName';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      rethrow;
    }
  }
}
