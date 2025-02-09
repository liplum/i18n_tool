import 'dart:io';

import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i18n_tool/app/project/utils/project.dart';
import 'package:locale_names/locale_names.dart';
import 'package:rettulf/rettulf.dart';
import "package:file_picker/file_picker.dart";
import "package:path/path.dart" as p;

import '../model/project.dart';
import '../project/model/working_project.dart';
import '../state/project.dart';

class IndexProjectsPage extends ConsumerStatefulWidget {
  const IndexProjectsPage({super.key});

  @override
  ConsumerState createState() => _StartProjectsPageState();
}

class _StartProjectsPageState extends ConsumerState<IndexProjectsPage> {
  final $search = TextEditingController();

  @override
  void dispose() {
    $search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch($projects);
    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Projects'),
      ),
      content: [
        [
          TextBox(
            controller: $search,
            prefix: const Icon(FluentIcons.search).padAll(8),
            suffix: IconButton(
              icon: Icon(FluentIcons.clear),
              onPressed: () {
                $search.clear();
              },
            ),
            suffixMode: OverlayVisibilityMode.editing,
            placeholder: 'Search',
          ).expanded(),
          buildOpenButton(),
        ].row(spacing: 8).padSymmetric(h: 16, v: 4),
        $search >>
            (ctx, search) => buildProjectList(
                  projects.where((it) => it.match($search.text)).toList(growable: false),
                ).expanded(),
      ].column(),
    );
  }

  Widget buildProjectList(List<Project> projects) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return ProjectTile(
          project: project,
        );
      },
    );
  }

  Widget buildOpenButton() {
    return Button(
      onPressed: createProject,
      child: "Create".text(),
    );
  }

  Future<void> createProject() async {
    final createdProject = await showDialog<Project>(
      context: context,
      builder: (ctx) => CreateProjectForm(),
      useRootNavigator: true,
    );
    if (createdProject == null) return;
    if (!mounted) return;
    context.push("/project/${createdProject.uuid}");
  }
}

class ProjectTile extends ConsumerStatefulWidget {
  final Project project;

  const ProjectTile({
    super.key,
    required this.project,
  });

  @override
  ConsumerState createState() => _ProjectTileState();
}

class _ProjectTileState extends ConsumerState<ProjectTile> {
  final $actions = FlyoutController();
  var existing = false;

  @override
  void initState() {
    super.initState();
    checkProjectExisting();
  }

  @override
  void dispose() {
    $actions.dispose();
    super.dispose();
  }

  Future<void> checkProjectExisting() async {
    final file = Directory(widget.project.rootPath);
    final existing = await file.exists();
    if (!mounted) return;
    setState(() {
      this.existing = existing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final style = existing
        ? null
        : TextStyle(
            decoration: TextDecoration.lineThrough,
            color: FluentTheme.of(context).inactiveColor,
          );
    final project = widget.project;
    return ListTile(
      leading: Opacity(
        opacity: existing ? 1 : 0.5,
        child: CircleAvatar(
          backgroundColor: project.color.withValues(alpha: 0.8),
          child: project.shortName.text(),
        ),
      ),
      title: Opacity(opacity: existing ? 1 : 0.8, child: project.name.text(style: style)),
      subtitle: Opacity(opacity: existing ? 1 : 0.8, child: project.rootPath.text(style: style)),
      trailing: buildActions(),
      onPressed: existing
          ? () {
              context.push("/project/${project.uuid}");
            }
          : null,
    );
  }

  Widget buildActions() {
    return FlyoutTarget(
      controller: $actions,
      child: IconButton(
        icon: Icon(FluentIcons.more_vertical),
        onPressed: () {
          $actions.showFlyout(
            builder: (ctx) {
              return MenuFlyout(items: [
                MenuFlyoutItem(
                  leading: const Icon(FluentIcons.delete),
                  text: const Text('Delete'),
                  onPressed: () {
                    ref.read($projects.notifier).removeProject(widget.project.uuid);
                  },
                ),
              ]);
            },
          );
        },
      ),
    );
  }
}

class CreateProjectForm extends ConsumerStatefulWidget {
  const CreateProjectForm({super.key});

  @override
  ConsumerState createState() => _CreateProjectFormState();
}

class _CreateProjectFormState extends ConsumerState<CreateProjectForm> {
  final $rootPath = TextEditingController();
  final $projectName = TextEditingController();
  var defaultLocale = Locale("en");
  var l10nFiles = <L10nFile>[];
  ProjectFileType? fileType;

  @override
  void dispose() {
    $rootPath.dispose();
    $projectName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileType = this.fileType;
    return Container(
      color: FluentTheme.of(context).micaBackgroundColor,
      child: ScaffoldPage(
        header: PageHeader(
          title: "Create a project".text(),
        ),
        bottomBar: [
          $rootPath >>
              (ctx, rootPath) => FilledButton(
                    onPressed: rootPath.text.isNotEmpty && fileType != null
                        ? () {
                            createProject(
                              rootPath: rootPath.text,
                              projectName: $projectName.text,
                              fileType: fileType,
                            );
                          }
                        : null,
                    child: "Create Project".text(),
                  ),
        ].row(maa: MainAxisAlignment.end).padAll(8),
        content: buildBody().padSymmetric(h: 32),
      ),
    );
  }

  Widget buildBody() {
    return [
      buildRootPath(),
      buildProjectName(),
      buildFileType(),
      buildDefaultLocale(),
      buildFilePreview(),
    ].column(spacing: 8);
  }

  Widget buildRootPath() {
    return [
      "Project Root Path".text(),
      [
        TextBox(
          controller: $rootPath,
        ).expanded(),
        buildOpenButton()
      ].row(spacing: 8).expanded(),
    ].row(spacing: 8);
  }

  Widget buildProjectName() {
    return [
      "Project Name".text(),
      TextBox(
        controller: $projectName,
      ).expanded(),
    ].row(spacing: 8);
  }

  Widget buildFileType() {
    return [
      "File Type".text(),
      ComboBox<ProjectFileType>(
        value: fileType,
        items: [
          ...ProjectFileType.values.map((it) {
            return ComboBoxItem(
              value: it,
              child: Text(it.name),
            );
          })
        ],
        onChanged: (newValue) {
          setState(() {
            fileType = newValue;
          });
        },
      ),
    ].row(spacing: 8);
  }

  Widget buildDefaultLocale() {
    final locales = l10nFiles.map((it) => it.locale).toList();
    return [
      "Default Locale".text(),
      ComboBox<Locale>(
        value: defaultLocale,
        items: [
          ...[
            if (locales.isNotEmpty) ...locales else defaultLocale,
          ].map((it) {
            return ComboBoxItem(
              value: it,
              child: it.defaultDisplayLanguageScript.text(),
            );
          })
        ],
        onChanged: (newValue) {
          setState(() {
            defaultLocale = newValue!;
          });
        },
      ),
    ].row(spacing: 8);
  }

  Future<void> pickAndOpenFolder() async {
    final result = await FilePicker.platform.getDirectoryPath(
      lockParentWindow: true,
    );
    if (result == null) return;
    $rootPath.text = result;
    $projectName.text = p.basenameWithoutExtension(result);
    final l10nFiles = await loadL10nFilesAtRootPath(result);
    final estimated = await estimateFileType(l10nFiles);
    if (estimated == null) return;
    if (!mounted) return;
    setState(() {
      this.l10nFiles = l10nFiles;
      fileType = estimated;
    });
  }

  Future<ProjectFileType?> estimateFileType(List<L10nFile> l10nFiles) async {
    final ext2Count = l10nFiles.groupFoldBy<String, int>((it) => p.extension(it.path), (pre, next) => (pre ?? 0) + 1);
    final ascendingByCount = ext2Count.entries.sortedBy<num>((it) => it.value);
    final mostCommonExt = ascendingByCount.lastOrNull;
    if (mostCommonExt == null) return null;
    return ProjectFileType.tryParseExtension(mostCommonExt.key);
  }

  Widget buildFilePreview() {
    return Card(
      child: [
        ListView.builder(
          itemCount: l10nFiles.length,
          itemBuilder: (ctx, i) {
            final file = l10nFiles[i];
            return ListTile(
              title: file.locale.defaultDisplayLanguageScript.text(),
            );
          },
        ).expanded(),
      ].column(mas: MainAxisSize.min).sized(h: 240),
    );
  }

  Widget buildOpenButton() {
    return Button(
      onPressed: pickAndOpenFolder,
      child: Text('Open folder'),
    );
  }

  Future<void> createProject({
    required String rootPath,
    required String projectName,
    required ProjectFileType fileType,
  }) async {
    final project = Project.create(
      rootPath: rootPath,
      name: projectName,
      type: ProjectType(
        fileType: fileType,
      ),
    );
    ref.read($projects.notifier).addProject(project);
    context.pop(project);
  }
}
