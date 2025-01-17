import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/project.dart';

final _projects = [
  Project(
    uuid: "221E8EF8-93DD-4E8F-86BB-CD09DF43DC5B",
    name: "i18n_tool",
    shortName: "IT",
    color: Colors.green,
    rootPath: "/User/liplum/i18n_tool",
  ),
  Project(
    uuid: "2482F6C6-840C-4A70-A880-9F4EE8DF9021",
    name: "TestProject",
    shortName: "TP",
    color: Colors.blue,
    rootPath: "/User/liplum/Projects/TestProject",
  ),
];

final $projects = NotifierProvider<ProjectListNotifier, List<Project>>(
  ProjectListNotifier.new,
);

// We use an AsyncNotifier because our logic is asynchronous.
// More specifically, we'll need AutoDisposeAsyncNotifier because
// of the "autoDispose" modifier.
class ProjectListNotifier extends Notifier<List<Project>> {
  @override
  List<Project> build() {
    // The logic we previously had in our FutureProvider is now in the build method.
    return _projects;
  }

  void addProject(Project project) {
    state = [...state, project];
  }

  void removeProject(String uuid) {
    state = state.where((it) => it.uuid != uuid).toList(growable: false);
  }
}
