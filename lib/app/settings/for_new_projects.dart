import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';

class ForNewProjectsSettingsPage extends ConsumerStatefulWidget {
  const ForNewProjectsSettingsPage({super.key});

  @override
  ConsumerState createState() => _ForNewProjectsSettingsPageState();
}

class _ForNewProjectsSettingsPageState extends ConsumerState<ForNewProjectsSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: "For New Projects".text(),
      ),
    );
  }
}
