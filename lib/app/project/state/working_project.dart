import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_tool/app/project/utils/project.dart';

import '../../model/project.dart';
import '../model/working_project.dart';

final $workingProject = NotifierProvider.family<WorkingProjectNotifier, WorkingProject, Project>(
  WorkingProjectNotifier.new,
);

class WorkingProjectNotifier extends FamilyNotifier<WorkingProject, Project> {
  @override
  WorkingProject build(Project arg) {
    // The logic we previously had in our FutureProvider is now in the build method.
    return WorkingProject(
      project: arg,
      l10nFiles: [],
      openTabs: [],
    );
  }

  Future<void> loadProject() async {
    final l10nFiles = await state.project.loadL10nFiles();
    state = state.copyWith(l10nFiles: l10nFiles);
  }

  void openTab(L10nFile file) {
    if (state.openTabs.any((it) => it.file.locale == file.locale)) return;
    state = state.copyWith(openTabs: [
      ...state.openTabs,
      L10nFileTab(project: state, file: file),
    ]);
  }

  void closeTab(L10nFile file) {
    if (!state.openTabs.any((it) => it.file.locale == file.locale)) return;
    state = state.copyWith(
      openTabs: [...state.openTabs.where((it) => it.file.locale != file.locale)],
    );
  }
}
