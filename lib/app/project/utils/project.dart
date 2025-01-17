import 'dart:io';
import 'dart:ui';
import "package:path/path.dart" as p;

import '../../model/project.dart';
import '../model/working_project.dart';

extension ProjectEx on Project {
  Future<List<L10nFile>> loadL10nFiles() async {
    final rootDir = Directory(rootPath);
    final subFiles = await rootDir.list().toList();
    final files = subFiles.whereType<File>().toList();
    final l10nFiles = <L10nFile>[];
    for (final file in files) {
      final locale = _parseLocale(p.basenameWithoutExtension(file.path));
      if (locale == null) continue;
      final fileType = _getFileType(file.path);
      l10nFiles.add(L10nFile(
        fileType: fileType,
        path: file.absolute.path,
        locale: locale,
      ));
    }
    return l10nFiles;
  }
}

Locale? _parseLocale(String fileName) {
  final localeParts = fileName.split('-');
  if (localeParts.length == 1) {
    return Locale(localeParts[0]);
  } else if (localeParts.length == 2) {
    return Locale(localeParts[0], localeParts[1]);
  } else if (localeParts.length == 3) {
    return Locale.fromSubtags(
      languageCode: localeParts[0],
      scriptCode: localeParts[1],
      countryCode: localeParts[2],
    );
  } else {
    // ignore unsupported locale format
    return null;
  }
}

L10nFileType _getFileType(String filePath) {
  final fileExtension = p.extension(filePath);
  if (fileExtension == '.json') {
    return L10nFileType.json;
  } else if (fileExtension == '.yaml') {
    return L10nFileType.yaml;
  } else {
    // Defaults to JSON if extension is not recognized
    return L10nFileType.json;
  }
}
