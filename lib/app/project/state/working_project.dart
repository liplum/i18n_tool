import 'dart:io';

import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_tool/app/project/utils/project.dart';
import 'package:i18n_tool/app/utils/project.dart';

import '../../model/project.dart';
import '../model/working_project.dart';

final $workingProject = AsyncNotifierProvider.family.autoDispose<WorkingProjectNotifier, WorkingProject, Project>(
  WorkingProjectNotifier.new,
);

class WorkingProjectNotifier extends AutoDisposeFamilyAsyncNotifier<WorkingProject, Project> {
  @override
  Future<WorkingProject> build(Project arg) async {
    // The logic we previously had in our FutureProvider is now in the build method.
    final initialState = await _rebuild();
    final stream = Directory(arg.rootPath).watch().listen((event) async {
      if (event is FileSystemModifyEvent) {
        state = AsyncValue.loading();
        final newState = await _rebuild(state.value);
        state = AsyncValue.data(newState);
      }
    });
    ref.onDispose(() {
      debugPrint("Watcher [${arg.rootPath}] disposed");
      stream.cancel();
    });
    return initialState;
  }

  Future<WorkingProject> _rebuild([WorkingProject? prev]) async {
    final l10nFiles = await arg.loadL10nFiles();
    final templateLocale = arg.settings.templateLocale ??
        (l10nFiles.firstWhereOrNull((it) => it.locale.languageCode == "en") ?? l10nFiles.firstOrNull)?.locale;
    return prev?.copyWith(
          project: arg,
          templateLocale: templateLocale,
          l10nFiles: l10nFiles,
        ) ??
        WorkingProject(
          project: arg,
          templateLocale: templateLocale,
          l10nFiles: l10nFiles,
        );
  }
}
