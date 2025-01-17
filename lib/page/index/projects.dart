import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i18n_tool/lifecycle.dart';
import 'package:i18n_tool/model/project.dart';
import 'package:rettulf/rettulf.dart';
import "package:file_picker/file_picker.dart";

class IndexProjectsPage extends ConsumerStatefulWidget {
  const IndexProjectsPage({super.key});

  @override
  ConsumerState createState() => _StartProjectsPageState();
}

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

class _StartProjectsPageState extends ConsumerState<IndexProjectsPage> {
  List<Project> projects = _projects;
  final $search = TextEditingController();

  @override
  void dispose() {
    $search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        ($search >>
            (ctx, search) {
              final projects = this.projects.where((it) => it.match($search.text)).toList(growable: false);
              return ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return ProjectTile(
                    project: project,
                  );
                },
              ).expanded();
            }),
      ].column(),
    );
  }

  Widget buildOpenButton() {
    return DropDownButton(
      title: Text('Open').padAll(4),
      items: [
        MenuFlyoutItem(
          text: const Text('Folder'),
          onPressed: pickAndOpenFolder,
        ),
      ],
    );
  }

  Future<void> pickAndOpenFolder() async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result == null) return;
    final project = Project.create(rootPath: result);
    setState(() {
      projects = [...projects, project];
    });
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

  @override
  void dispose() {
    $actions.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: project.color,
        child: project.shortName.text(),
      ),
      title: project.name.text(),
      subtitle: project.rootPath.text(),
      trailing: buildActions(),
      onPressed: () {
        context.push("/project/:project");
      },
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
                    print("deleted");
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
