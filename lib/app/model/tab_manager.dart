import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:meta/meta.dart';

import '../project/model/working_project.dart';
import 'project.dart';

part "tab_manager.g.dart";

@immutable
@CopyWith(skipFields: true)
class TabManager {
  final Project project;
  final List<L10nFileTab> openTabs;
  final L10nFileTab? selectedTab;

  const TabManager({
    required this.project,
    this.openTabs = const [],
    this.selectedTab,
  });
}

@immutable
@CopyWith(skipFields: true)
class L10nFileTab {
  final TabManager manager;
  final L10nFile file;

  const L10nFileTab({
    required this.manager,
    required this.file,
  });
}
