import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:i18n_tool/app/utils/locale.dart';
import 'package:i18n_tool/app/utils/project.dart';
import 'package:i18n_tool/serialization/serializer.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../../model/project.dart';

part "working_project.g.dart";

@immutable
@CopyWith(skipFields: true)
class WorkingProject {
  final Project project;
  final Locale? templateLocale;
  final List<L10nFile> l10nFiles;

  const WorkingProject({
    required this.project,
    this.templateLocale,
    this.l10nFiles = const [],
  });

  L10nFile? get templateL10nFile {
    final templateLocale = this.templateLocale;
    if (templateLocale == null) return null;
    return l10nFiles.firstWhereOrNull((it) => it.locale == templateLocale);
  }
}

extension WorkingProjectEx on WorkingProject {
  bool isTemplate(L10nFile file) => file.locale == templateLocale;
}

@JsonSerializable()
@CopyWith(skipFields: true)
class L10nFile {
  final String path;
  @localeJsonKey
  final Locale locale;

  const L10nFile({
    required this.path,
    required this.locale,
  });

  factory L10nFile.fromJson(Map<String, dynamic> json) => _$L10nFileFromJson(json);

  Map<String, dynamic> toJson() => _$L10nFileToJson(this);

  String title() {
    return locale.l10n();
  }
}

extension L10nFileEx on L10nFile {
  bool isTheSameLocale(L10nFile? file) => locale == file?.locale;
}
