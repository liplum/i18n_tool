import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';

class SettingsIndexPage extends ConsumerStatefulWidget {
  final Widget child;

  const SettingsIndexPage({
    super.key,
    required this.child,
  });

  @override
  ConsumerState createState() => _SettingsIndexPageState();
}

class _SettingsIndexPageState extends ConsumerState<SettingsIndexPage> {
  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        title: "App settings".text(),
      ),
      pane: NavigationPane(items: [
        PaneItem(
          icon: Icon(FluentIcons.settings),
          title: "General".text(),
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
