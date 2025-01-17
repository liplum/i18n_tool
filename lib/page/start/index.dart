import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';

class StartIndexPage extends ConsumerStatefulWidget {
  final Widget child;

  const StartIndexPage({
    super.key,
    required this.child,
  });

  @override
  ConsumerState createState() => _StartIndexPageState();
}

class _StartIndexPageState extends ConsumerState<StartIndexPage> {
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
        final name = item?.key ?? item.runtimeType;
        return FocusTraversalGroup(
          key: ValueKey('body$name'),
          child: widget.child,
        );
      },
    );
  }
}
