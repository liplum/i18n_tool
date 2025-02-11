import 'package:fluent_ui/fluent_ui.dart';
import 'package:rettulf/rettulf.dart';

class AppMenuHost extends StatefulWidget {
  final List<MenuBarItem> defaultItems;
  final Widget child;

  const AppMenuHost({
    super.key,
    required this.defaultItems,
    required this.child,
  });

  @override
  State<AppMenuHost> createState() => AppMenuHostState();
}

class AppMenuHostState extends State<AppMenuHost> {
  static AppMenuHostState? maybeOf(BuildContext context) => context.findAncestorStateOfType<AppMenuHostState>();

  static AppMenuHostState of(BuildContext context) => maybeOf(context)!;

  var _items = <MenuBarItem>[];

  void updateMenuItems(List<MenuBarItem> items) {
    setState(() {
      _items = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Mica(
      child: [
        MenuBar(
            items: _items.isEmpty
                ? widget.defaultItems
                : _items),
        widget.child.expanded(),
      ].column(),
    );
  }
}

class AppMenu extends StatefulWidget {
  final List<MenuBarItem> items;
  final Widget child;

  const AppMenu({
    super.key,
    required this.items,
    required this.child,
  });

  @override
  State<AppMenu> createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppMenuHostState.of(context).updateMenuItems(widget.items);
  }

  @override
  void didUpdateWidget(covariant AppMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      AppMenuHostState.of(context).updateMenuItems(widget.items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
