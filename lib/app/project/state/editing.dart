import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_tool/app/project/state/file.dart';
import 'package:i18n_tool/serialization/data.dart';

import '../model/editing.dart';
import '../model/working_project.dart';

typedef L10nFileWithProject = ({WorkingProject project, L10nFile file});

final $l10nData = AsyncNotifierProvider.family.autoDispose<L10nDataNotifier, L10nData, L10nFileWithProject>(
  L10nDataNotifier.new,
);

class L10nDataNotifier extends AutoDisposeFamilyAsyncNotifier<L10nData, L10nFileWithProject> {
  @override
  Future<L10nData> build(L10nFileWithProject arg) async {
    final fileContent = await ref.watch($fileContent(arg.file.path).future);
    final data = arg.project.serializer.deserialize(fileContent.content);
    return data;
  }
}

final $l10nEditing = AsyncNotifierProvider.family.autoDispose<L10nEditingNotifier, L10nEditing, L10nFileTab>(
  L10nEditingNotifier.new,
);

class L10nEditingNotifier extends AutoDisposeFamilyAsyncNotifier<L10nEditing, L10nFileTab> {
  @override
  Future<L10nEditing> build(L10nFileTab arg) async {
    final data = await ref.watch($l10nData((project: arg.project, file: arg.file)).future);
    final templateFile = arg.project.templateL10nFile;
    if (templateFile != null && templateFile.locale != arg.file.locale) {
      final templateData = await ref.watch($l10nData((project: arg.project, file: templateFile)).future);
      return L10nEditing(
        locale: arg.file.locale,
        data: data,
        template: (
          locale: templateFile.locale,
          data: templateData,
        ),
      );
    } else {
      return L10nEditing(
        locale: arg.file.locale,
        data: data,
        template: null,
      );
    }
  }
}
