import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n_tool/widget/app_menu.dart';
import 'package:rettulf/rettulf.dart';

import '../menu_bar.dart';

class IndexIndexPage extends ConsumerStatefulWidget {
  final Widget child;

  const IndexIndexPage({
    super.key,
    required this.child,
  });

  @override
  ConsumerState createState() => _IndexIndexPageState();
}

class _IndexIndexPageState extends ConsumerState<IndexIndexPage> {
  late final appMenuController = buildAppMenuController(context);

  @override
  Widget build(BuildContext context) {
    return AppMenu(
      controller: appMenuController,
      child: NavigationView(
        appBar: NavigationAppBar(
          leading: Icon(FluentIcons.home_solid),
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
        ),
        paneBodyBuilder: (item, child) {
          final name = item?.key ?? item.runtimeType;
          return FocusTraversalGroup(
            key: ValueKey('body$name'),
            child: widget.child,
          );
        },
      ),
    );
  }
}
