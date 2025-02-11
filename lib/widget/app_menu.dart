import 'package:fluent_ui/fluent_ui.dart';
import 'package:rettulf/rettulf.dart';

class AppMenu extends StatefulWidget {
  final List<MenuBarItem> items;
  final Widget child;

  const AppMenu({
    super.key,
    required this.items,
    required this.child,
  });

  @override
  State<AppMenu> createState() => AppMenuState();
}

class AppMenuState extends State<AppMenu> {
  static AppMenuState? maybeOf(BuildContext context) => context.findAncestorStateOfType<AppMenuState>();

  static AppMenuState of(BuildContext context) => maybeOf(context)!;

  var _items = <MenuBarItem>[];

  void updateMenuItems(List<MenuBarItem> items) {
    if (_items != items) {
      Future.delayed(Duration.zero).then((_) {
        setState(() {
          _items = items;
        });
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppMenuState.maybeOf(context)?.updateMenuItems(widget.items);
  }

  @override
  void didUpdateWidget(covariant AppMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      AppMenuState.maybeOf(context)?.updateMenuItems(widget.items);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasParentAppMenu = AppMenuState.maybeOf(context) != null;
    if (hasParentAppMenu) {
      return widget.child;
    }
    return [
      MenuBar(items: _items.isEmpty ? widget.items : _items),
      widget.child.expanded(),
    ].column();
  }
}
