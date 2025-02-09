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
    final templateLocale = arg.settings.templateLocale ?? (l10nFiles.firstWhereOrNull((it) => it.locale.languageCode == "en") ?? l10nFiles.firstOrNull)?.locale;
    return prev?.copyWith(
          project: arg,
          templateLocale: templateLocale,
          l10nFiles: l10nFiles,
        ) ??
        WorkingProject(
          project: arg,
          serializer: arg.createParser(),
          templateLocale: templateLocale,
          l10nFiles: l10nFiles,
        );
  }

  void openTab(L10nFile file) {
    final state = this.state.value;
    if (state == null) return;
    final existing = state.openTabs.firstWhereOrNull((it) => it.file.isTheSameLocale(file));
    if (existing != null) {
      if (state.selectedTab != existing) {
        this.state = AsyncValue.data(state.copyWith(selectedTab: existing));
      }
      return;
    }
    final newTab = L10nFileTab(project: state, file: file);
    this.state = AsyncValue.data(state.copyWith(
      openTabs: [...state.openTabs, newTab],
      selectedTab: newTab,
    ));
  }

  void closeTab(L10nFile file) {
    final state = this.state.value;
    if (state == null) return;
    final existing = state.openTabs.firstWhereOrNull((it) => it.file.isTheSameLocale(file));
    if (existing == null) return;
    final newOpenedTabs = [...state.openTabs.where((it) => !it.file.isTheSameLocale(file))];
    this.state = AsyncValue.data(state.copyWith(
      openTabs: newOpenedTabs,
      selectedTab: file.isTheSameLocale(state.selectedTab?.file) ? newOpenedTabs.firstOrNull : state.selectedTab,
    ));
  }

  void selectTab(L10nFile file) {
    final state = this.state.value;
    if (state == null) return;
    if (file.isTheSameLocale(state.selectedTab?.file)) return;
    this.state = AsyncValue.data(state.copyWith(
      selectedTab: state.openTabs.firstWhereOrNull((it) => it.file.isTheSameLocale(file)),
    ));
  }

  void recordTab(int oldIndex, int newIndex) {
    // TODO: buggy
    final state = this.state.value;
    if (state == null) return;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final newTabs = [...state.openTabs];
    var currentIndex = newTabs.indexWhere((it) => it.file.locale == state.selectedTab?.file.locale);
    final item = newTabs.removeAt(oldIndex);
    newTabs.insert(newIndex, item);

    if (currentIndex == newIndex) {
      currentIndex = oldIndex;
    } else if (currentIndex == oldIndex) {
      currentIndex = newIndex;
    }
    this.state = AsyncValue.data(state.copyWith(
      openTabs: newTabs,
      selectedTab: newTabs[currentIndex],
    ));
  }
}
