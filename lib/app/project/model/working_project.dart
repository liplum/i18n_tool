import 'dart:ui';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:locale_names/locale_names.dart';

import '../../model/project.dart';

part "working_project.g.dart";

@CopyWith(skipFields: true)
class WorkingProject {
  final Project project;
  final Locale? templateLocale;
  final List<L10nFile> l10nFiles;
  final List<L10nFileTab> openTabs;
  final L10nFileTab? selectedTab;

  const WorkingProject({
    required this.project,
    this.templateLocale,
    this.l10nFiles = const [],
    this.openTabs = const [],
    this.selectedTab,
  });
}

extension WorkingProjectEx on WorkingProject {
  bool isTemplate(L10nFile file) => file.locale == templateLocale;
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

@JsonSerializable()
@CopyWith(skipFields: true)
class L10nFile {
  final L10nFileType fileType;
  final String path;
  @localeJsonKey
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

extension L10nFileEx on L10nFile {
  bool isTheSameLocale(L10nFile? file) => locale == file?.locale;
}
