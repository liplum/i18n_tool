import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i18n_tool/model/project.dart';
import 'package:rettulf/rettulf.dart';

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
        ].row().padSymmetric(h: 16, v: 4),
        ($search >>
            (ctx, search) {
              final projects = this.projects.where((it) => it.match($search.text)).toList(growable: false);
              return ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return buildProjectTile(
                    project: project,
                  );
                },
              ).expanded();
            }),
      ].column(),
    );
  }

  Widget buildProjectTile({
    required Project project,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: project.color,
        child: project.shortName.text(),
      ),
      title: project.name.text(),
      subtitle: project.rootPath.text(),
      onPressed: () {
        context.push("/project/:project");
      },
    );
  }
}
