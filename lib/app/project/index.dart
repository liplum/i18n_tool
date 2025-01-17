import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_tool/app/project/model/working_project.dart';
import 'package:i18n_tool/app/project/state/file.dart';
import 'package:i18n_tool/app/project/state/working_project.dart';
import 'package:i18n_tool/widget/loading.dart';
import 'package:rettulf/rettulf.dart';

import '../state/project.dart';

class ProjectIndexPage extends ConsumerStatefulWidget {
  final String uuid;

  const ProjectIndexPage({
    super.key,
    required this.uuid,
  });

  @override
  ConsumerState createState() => _ProjectIndexPageState();
}

class _ProjectIndexPageState extends ConsumerState<ProjectIndexPage> {
  late var project = ref.read($projects).firstWhere((it) => it.uuid == widget.uuid);

  @override
  Widget build(BuildContext context) {
    final workingProjectAsync = ref.watch($workingProject(project));
    final workingProject = workingProjectAsync.value;
    return OnLoading(
      loading: workingProjectAsync.isLoading,
      child: NavigationView(
        appBar: NavigationAppBar(
          title: ListTile(
            leading: CircleAvatar(
              backgroundColor: project.color.withValues(alpha: 0.8),
              child: project.shortName.text(),
            ),
            title: project.name.text(),
            subtitle: project.rootPath.text(),
          ),
        ),
        pane: NavigationPane(
          items: workingProject == null
              ? []
              : [
                  ...workingProject.l10nFiles.map((file) {
                    return PaneItemAction(
                      icon: Icon(workingProject.isTemplate(file) ? FluentIcons.file_template : FluentIcons.file_code),
                      title: file.title().text(),
                      onTap: () {
                        ref.read($workingProject(project).notifier).openTab(file);
                      },
                    );
                  }),
                  PaneItemSeparator(),
                  PaneItemAction(
                    icon: const Icon(FluentIcons.add),
                    title: const Text('Add new language'),
                    onTap: () {},
                  ),
                ],
        ),
        paneBodyBuilder: (item, child) {
          return buildEditingPanel(workingProject);
        },
      ),
    );
  }

  Widget buildEditingPanel(WorkingProject? workingProject) {
    return TabView(
      currentIndex: workingProject == null
          ? 0
          : workingProject.openTabs.indexWhere((it) => it.file.isTheSameLocale(workingProject.selectedTab?.file)),
      onChanged: workingProject == null
          ? null
          : (index) {
              ref.read($workingProject(project).notifier).selectTab(workingProject.openTabs[index].file);
            },
      tabWidthBehavior: TabWidthBehavior.sizeToContent,
      closeButtonVisibility: CloseButtonVisibilityMode.always,
      showScrollButtons: true,
      shortcutsEnabled: true,
      tabs: [
        if (workingProject != null)
          ...workingProject.openTabs.map(
            (it) => Tab(
              icon: Icon(workingProject.isTemplate(it.file) ? FluentIcons.file_template : FluentIcons.file_code),
              text: it.file.title().text(),
              body: L10nFileEditorTab(tab: it),
              onClosed: () {
                ref.read($workingProject(workingProject.project).notifier).closeTab(it.file);
              },
            ),
          ),
      ],
    );
  }
}

class L10nFileEditorTab extends ConsumerStatefulWidget {
  final L10nFileTab tab;

  const L10nFileEditorTab({
    super.key,
    required this.tab,
  });

  @override
  ConsumerState createState() => _L10nFileEditorTabState();
}

class _L10nFileEditorTabState extends ConsumerState<L10nFileEditorTab> {
  @override
  Widget build(BuildContext context) {
    final content = ref.watch($fileContent(widget.tab.file.path));
    return Card(
      child: switch (content) {
        AsyncData(:final value) => value.content.text().scrolled(),
        AsyncError(:final error) => Text('Error: $error'),
        _ => const Center(child: ProgressRing()),
      },
    );
  }
}
