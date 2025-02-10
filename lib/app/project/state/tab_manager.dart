import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/project.dart';
import '../../model/tab_manager.dart';
import '../model/working_project.dart';

final $tabManager = NotifierProvider.family.autoDispose<TabManagerNotifier, TabManager, Project>(
  TabManagerNotifier.new,
);

class TabManagerNotifier extends AutoDisposeFamilyNotifier<TabManager, Project> {
  @override
  TabManager build(Project arg) {
    return TabManager(
      project: arg,
    );
  }

  void openTab(L10nFile file) {
    final state = this.state;
    final existing = state.openTabs.firstWhereOrNull((it) => it.file.isTheSameLocale(file));
    if (existing != null) {
      if (state.selectedTab != existing) {
        this.state = state.copyWith(selectedTab: existing);
      }
      return;
    }
    final newTab = L10nFileTab(manager: state, file: file);
    this.state = state.copyWith(
      openTabs: [...state.openTabs, newTab],
      selectedTab: newTab,
    );
  }

  void closeTab(L10nFile file) {
    final state = this.state;
    final existing = state.openTabs.firstWhereOrNull((it) => it.file.isTheSameLocale(file));
    if (existing == null) return;
    final newOpenedTabs = [...state.openTabs.where((it) => !it.file.isTheSameLocale(file))];
    this.state = state.copyWith(
      openTabs: newOpenedTabs,
      selectedTab: file.isTheSameLocale(state.selectedTab?.file) ? newOpenedTabs.firstOrNull : state.selectedTab,
    );
  }

  void selectTab(L10nFile file) {
    final state = this.state;
    if (file.isTheSameLocale(state.selectedTab?.file)) return;
    this.state = state.copyWith(
      selectedTab: state.openTabs.firstWhereOrNull((it) => it.file.isTheSameLocale(file)),
    );
  }

  void recordTab(int oldIndex, int newIndex) {
    // TODO: buggy
    final state = this.state;
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
    this.state = state.copyWith(
      openTabs: newTabs,
      selectedTab: newTabs[currentIndex],
    );
  }
}
