import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';

class ProjectIndexPage extends ConsumerStatefulWidget {
  final Widget child;

  const ProjectIndexPage({
    super.key,
    required this.child,
  });

  @override
  ConsumerState createState() => _ProjectIndexPageState();
}

class _ProjectIndexPageState extends ConsumerState<ProjectIndexPage> {
  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        title: "Edit the project".text(),
      ),
      pane: NavigationPane(items: [
        PaneItem(
          icon: Icon(FluentIcons.file_code),
          title: "English".text(),
          body: const SizedBox.shrink(),
        ),
        PaneItemSeparator(),
        PaneItemAction(
          icon: const Icon(FluentIcons.add),
          title: const Text('Add new language'),
          onTap: () {},
        ),
      ]),
      paneBodyBuilder: (item, child) {
        final name = item?.key ?? item.runtimeType;
        return FocusTraversalGroup(
          key: ValueKey('body$name'),
          child: widget.child,
        );
      },
    );
  }
}
