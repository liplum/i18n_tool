import 'package:collection/collection.dart';
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
    );
  }

  Future<void> loadProject() async {
    final l10nFiles = await state.project.loadL10nFiles();
    state = state.copyWith(l10nFiles: l10nFiles);
    resolveTemplateLocale();
  }

  void resolveTemplateLocale() {
    final templateLocale =
        state.l10nFiles.firstWhereOrNull((it) => it.locale.languageCode == "en") ?? state.l10nFiles.firstOrNull;
    state = state.copyWith(
      templateLocale: templateLocale?.locale,
    );
  }

  void openTab(L10nFile file) {
    final existing = state.openTabs.firstWhereOrNull((it) => it.file.isTheSameLocale(file));
    if (existing != null) {
      if (state.selectedTab != existing) {
        state = state.copyWith(selectedTab: existing);
      }
      return;
    }
    final newTab = L10nFileTab(project: state, file: file);
    state = state.copyWith(
      openTabs: [...state.openTabs, newTab],
      selectedTab: newTab,
    );
  }

  void closeTab(L10nFile file) {
    final existing = state.openTabs.firstWhereOrNull((it) => it.file.isTheSameLocale(file));
    if (existing == null) return;
    final newOpenedTabs = [...state.openTabs.where((it) => !it.file.isTheSameLocale(file))];
    state = state.copyWith(
      openTabs: newOpenedTabs,
      selectedTab: file.isTheSameLocale(state.selectedTab?.file) ? newOpenedTabs.firstOrNull : state.selectedTab,
    );
  }

  void selectTab(L10nFile file) {
    if (file.isTheSameLocale(state.selectedTab?.file)) return;
    state = state.copyWith(
      selectedTab: state.openTabs.firstWhereOrNull((it) => it.file.isTheSameLocale(file)),
    );
  }
}
