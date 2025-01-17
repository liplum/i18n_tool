import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';

class EditIndexPage extends ConsumerStatefulWidget {
  final Widget child;

  const EditIndexPage({
    super.key,
    required this.child,
  });

  @override
  ConsumerState createState() => _EditIndexPageState();
}

class _EditIndexPageState extends ConsumerState<EditIndexPage> {
  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(items: [
        PaneItemAction(
          icon: const Icon(FluentIcons.home),
          title: const Text('Home'),
          onTap: () {
            context.go("/start");
          },
        ),
        PaneItemSeparator(),
        PaneItem(
          icon: Icon(FluentIcons.file_code),
          title: "English".text(),
          body: const SizedBox.shrink(),
        ),
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
