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
        title: "App Settings".text(),
      ),
      pane: NavigationPane(items: [
        PaneItemAction(
          icon: Icon(FluentIcons.settings),
          title: "General".text(),
          body: const SizedBox.shrink(),
          onTap: () {
            context.push("/settings/general");
          },
        ),
        PaneItemAction(
          icon: Icon(FluentIcons.new_team_project),
          title: "For New Projects".text(),
          body: const SizedBox.shrink(),
          onTap: () {
            context.push("/settings/for-new-projects");
          },
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
