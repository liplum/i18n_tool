import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import "package:path/path.dart" as p;

import '../model/project.dart';
import '../state/project.dart';

class ProjectPage extends ConsumerStatefulWidget {
  final String uuid;

  const ProjectPage({
    super.key,
    required this.uuid,
  });

  @override
  ConsumerState createState() => _ProjectPageState();
}

class _ProjectPageState extends ConsumerState<ProjectPage> {
  late var project = ref.read($projects).firstWhere((it) => it.uuid == widget.uuid);
  var loading = false;
  List<File>? files;

  @override
  void initState() {
    super.initState();
    loadingFiles();
  }

  Future<void> loadingFiles() async {
    final files = await _loadingFiles(project);
    setState(() {
      this.files = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    final files = this.files;
    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Edit'),
      ),
      content: files == null
          ? ProgressRing().center()
          : ListView.builder(
              itemCount: files.length,
              itemBuilder: (ctx, i) => ListTile(
                title: "${p.basename(files[i].path)}".text(),
              ),
            ),
    );
  }
}

Future<List<File>> _loadingFiles(Project project) async {
  final rootDir = Directory(project.rootPath);
  final subFiles = await rootDir.list().toList();
  final files = subFiles.whereType<File>().toList();
  return files;
}
