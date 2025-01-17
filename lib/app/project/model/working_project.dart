import 'dart:ui';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../model/project.dart';

part "working_project.g.dart";

@CopyWith(skipFields: true)
@JsonSerializable()
class WorkingProject {
  final Project project;
  final List<L10nFile> l10nFiles;

  const WorkingProject({
    required this.project,
    required this.l10nFiles,
  });

  factory WorkingProject.fromJson(Map<String, dynamic> json) => _$WorkingProjectFromJson(json);

  Map<String, dynamic> toJson() => _$WorkingProjectToJson(this);
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
}
