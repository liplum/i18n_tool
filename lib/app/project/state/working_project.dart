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
    return WorkingProject(project: arg, l10nFiles: []);
  }

  Future<void> loadL10nFiles() async {
    final l10nFiles = await state.project.loadL10nFiles();
    state = state.copyWith(l10nFiles: l10nFiles);
  }
}
