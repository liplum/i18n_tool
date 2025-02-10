import 'dart:io';
import 'dart:ui';
import "package:path/path.dart" as p;

import '../../model/project.dart';
import '../model/working_project.dart';

import 'package:intl/locale.dart' as intl;

Locale? tryParseLocale(final String rawLocale) {
  final intlLocale = intl.Locale.tryParse(rawLocale);
  if (intlLocale != null) {
    return Locale.fromSubtags(
      languageCode: intlLocale.languageCode,
      countryCode: intlLocale.countryCode,
      scriptCode: intlLocale.scriptCode,
    );
  }
  return null;
}

extension ProjectEx on Project {
  Future<List<L10nFile>> loadL10nFiles() async {
    return loadL10nFilesAtRootPath(
      rootPath: rootPath,
      templateLocale: settings.templateLocale,
      fileNameMatcher: type.fileNameMatcher,
    );
  }
}

Future<List<L10nFile>> loadL10nFilesAtRootPath({
  required String rootPath,
  String fileNameMatcher = "",
  Locale? templateLocale,
}) async {
  final rootDir = Directory(rootPath);
  final subFiles = await rootDir.list().toList();
  final files = subFiles.whereType<File>().toList();
  final l10nFiles = <L10nFile>[];
  for (final file in files) {
    var fileName = p.basenameWithoutExtension(file.path);
    final fileNameRegex = fileNameMatcher.isEmpty ? null : _tryCreateRegExp(fileNameMatcher);
    if (fileNameRegex != null) {
      final match = fileNameRegex.firstMatch(fileName);
      if (match != null && match.groupCount > 0) {
        final group = match.group(1);
        if (group != null) {
          fileName = group;
        }
      }
    }
    // fileName = fileName.replaceAll("_", "-");
    if (templateLocale != null && fileName.isEmpty) {
      l10nFiles.add(L10nFile(
        path: file.absolute.path,
        locale: templateLocale,
      ));
    } else {
      final locale = tryParseLocale(fileName);
      if (locale == null) continue;
      l10nFiles.add(L10nFile(
        path: file.absolute.path,
        locale: locale,
      ));
    }
  }
  return l10nFiles;
}

RegExp? _tryCreateRegExp(String pattern) {
  try {
    return RegExp(pattern);
  } catch (e) {
    // Handle the exception, e.g., log an error or return null
    return null;
  }
}
