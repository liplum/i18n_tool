import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_tool/app/model/project.dart';
import 'package:i18n_tool/app/project/state/file.dart';
import 'package:i18n_tool/app/utils/project.dart';
import 'package:i18n_tool/serialization/data.dart';

import '../model/editing.dart';
import '../model/file.dart';
import '../model/working_project.dart';

typedef L10nFileWithProject = ({Project project, L10nFile file});

final $l10nData = AsyncNotifierProvider.family.autoDispose<L10nDataNotifier, L10nData, L10nFileWithProject>(
  L10nDataNotifier.new,
);

class L10nDataNotifier extends AutoDisposeFamilyAsyncNotifier<L10nData, L10nFileWithProject> {
  @override
  Future<L10nData> build(L10nFileWithProject arg) async {
    final fileContent = await ref.watch($fileContent(arg.file.path).future);
    final project = arg.project;
    final data = project.createSerializer().deserialize(
          fileContent.content,
          project.settings.toSerializationSettings(),
        );
    return data;
  }
}

typedef L10nFileTabArg = ({Project project, L10nFile current, L10nFile? template});

final $l10nFileTab = AsyncNotifierProvider.family.autoDispose<L10nFileTabNotifier, L10nFileTabState, L10nFileTabArg>(
  L10nFileTabNotifier.new,
);

class L10nFileTabNotifier extends AutoDisposeFamilyAsyncNotifier<L10nFileTabState, L10nFileTabArg> {
  @override
  Future<L10nFileTabState> build(L10nFileTabArg arg) async {
    final project = arg.project;
    final current = arg.current;
    final currentContent = await ref.watch($fileContent(arg.current.path).future);
    final currentData = loadData(project, currentContent);
    final templateFile = arg.template;
    if (templateFile != null) {
      final templateContent = await ref.watch($fileContent(templateFile.path).future);
      final templateData = loadData(project, templateContent);
      return L10nFileTabState(
        current: L10nFileAndData(file: current, data: currentData),
        template: L10nFileAndData(file: templateFile, data: templateData),
      );
    } else {
      return L10nFileTabState(
        current: L10nFileAndData(file: current, data: currentData),
        template: null,
      );
    }
  }

  L10nData loadData(Project project, FileContent fileContent) {
    final data = project.createSerializer().deserialize(
          fileContent.content,
          project.settings.toSerializationSettings(),
        );
    return data;
  }
}
