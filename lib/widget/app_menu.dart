import 'package:fluent_ui/fluent_ui.dart';
import 'package:rettulf/rettulf.dart';

class AppMenuCategory {
  final String label;
  final List<AppMenuItemBase> items;

  const AppMenuCategory({
    required this.label,
    required this.items,
  });

  MenuBarItem _buildFluentUIItem() {
    return MenuBarItem(
      title: label,
      items: items.map((it) => it._buildFluentUIItem()).toList(),
    );
  }
}

abstract class AppMenuItemBase {
  MenuFlyoutItemBase _buildFluentUIItem();
}

class AppMenuItem implements AppMenuItemBase {
  final String label;
  final VoidCallback? onPressed;

  const AppMenuItem({
    required this.label,
    required this.onPressed,
  });

  @override
  MenuFlyoutItemBase _buildFluentUIItem() {
    return MenuFlyoutItem(
      text: label.text(),
      onPressed: onPressed,
    );
  }
}

class AppMenuItemClick {}

class AppMenu extends StatefulWidget {
  final List<AppMenuCategory> items;
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

  var _items = <AppMenuCategory>[];

  void updateMenuItems(List<AppMenuCategory> items) {
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
    final items = _items.isEmpty ? widget.items : _items;
    return [
      MenuBar(items: items.map((it) => it._buildFluentUIItem()).toList(growable: false)),
      widget.child.expanded(),
    ].column();
  }
}
