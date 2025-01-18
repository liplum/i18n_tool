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
        languageCode: intlLocale.languageCode, countryCode: intlLocale.countryCode, scriptCode: intlLocale.scriptCode);
  }
  return null;
}

extension ProjectEx on Project {
  Future<List<L10nFile>> loadL10nFiles() async {
    final rootDir = Directory(rootPath);
    final subFiles = await rootDir.list().toList();
    final files = subFiles.whereType<File>().toList();
    final l10nFiles = <L10nFile>[];
    for (final file in files) {
      final locale = tryParseLocale(p.basenameWithoutExtension(file.path));
      if (locale == null) continue;
      l10nFiles.add(L10nFile(
        path: file.absolute.path,
        locale: locale,
      ));
    }
    return l10nFiles;
  }
}
