import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';

class IndexIndexPage extends ConsumerStatefulWidget {
  final Widget child;

  const IndexIndexPage({
    super.key,
    required this.child,
  });

  @override
  ConsumerState createState() => _StartIndexPageState();
}

class _StartIndexPageState extends ConsumerState<IndexIndexPage> {
  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        leading: Icon(FluentIcons.home),
        title: "Welcome to i18n Tool".text(),
      ),
      pane: NavigationPane(
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.project_collection),
            title: const Text('Projects'),
            body: const SizedBox.shrink(),
          ),
        ],
        footerItems: [
          PaneItemAction(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Settings'),
            onTap: () {
              context.push("/settings");
            },
          ),
        ],
      ),
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
