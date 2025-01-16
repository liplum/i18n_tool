import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';

class StartPage extends ConsumerStatefulWidget {
  final Widget child;

  const StartPage({
    super.key,
    required this.child,
  });

  @override
  ConsumerState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends ConsumerState<StartPage> {
  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(items: [
        PaneItem(
          icon: const Icon(FluentIcons.project_collection),
          title: const Text('Projects'),
          body: const SizedBox.shrink(),
        ),
      ]),
      paneBodyBuilder: (item, child) {
        final name = item?.key is ValueKey ? (item!.key as ValueKey).value : null;
        return FocusTraversalGroup(
          key: ValueKey('body$name'),
          child: widget.child,
        );
      },
    );
  }
}
