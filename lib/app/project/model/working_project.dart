import 'dart:ui';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:locale_names/locale_names.dart';

import '../../model/project.dart';

part "working_project.g.dart";

@CopyWith(skipFields: true)
class WorkingProject {
  final Project project;
  final List<L10nFile> l10nFiles;
  final List<L10nFileTab> openTabs;
  final L10nFileTab? selectedTab;

  const WorkingProject({
    required this.project,
    this.l10nFiles = const [],
    this.openTabs = const [],
    this.selectedTab,
  });
}

@CopyWith(skipFields: true)
class L10nFileTab {
  final WorkingProject project;
  final L10nFile file;

  const L10nFileTab({
    required this.project,
    required this.file,
  });
}

@JsonEnum(alwaysCreate: true)
enum L10nFileType {
  json,
  yaml,
}

Map<String, dynamic> localeToJson(Locale locale) => {
      "languageCode": locale.languageCode,
      "countryCode": locale.countryCode,
      "scriptCode": locale.scriptCode,
    };

Locale localeFromJson(Map<String, dynamic> json) => Locale.fromSubtags(
      languageCode: json["languageCode"],
      countryCode: json["countryCode"],
      scriptCode: json["scriptCode"],
    );

@JsonSerializable()
@CopyWith(skipFields: true)
class L10nFile {
  final L10nFileType fileType;
  final String path;
  @JsonKey(toJson: localeToJson, fromJson: localeFromJson)
  final Locale locale;

  const L10nFile({
    required this.fileType,
    required this.path,
    required this.locale,
  });

  factory L10nFile.fromJson(Map<String, dynamic> json) => _$L10nFileFromJson(json);

  Map<String, dynamic> toJson() => _$L10nFileToJson(this);

  String title() {
    return locale.defaultDisplayLanguageScript;
  }
}
