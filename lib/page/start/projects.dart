import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_tool/model/project.dart';
import 'package:rettulf/rettulf.dart';

class StartProjectsPage extends ConsumerStatefulWidget {
  const StartProjectsPage({super.key});

  @override
  ConsumerState createState() => _StartProjectsPageState();
}

final _projects = [
  Project(
    name: "i18n_tool",
    shortName: "IT",
    rootPath: "/User/liplum/i18n_tool",
  ),
];

class _StartProjectsPageState extends ConsumerState<StartProjectsPage> {
  List<Project> projects = _projects;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Projects'),
      ),
      content: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return buildProjectTile(
            project: project,
          );
        },
      ),
    );
  }

  Widget buildProjectTile({
    required Project project,
  }) {
    return ListTile(
      leading: CircleAvatar(
        child: project.shortName.text(),
      ),
      title: project.name.text(),
      subtitle: project.rootPath.text(),
      onPressed: () {},
    );
  }
}
