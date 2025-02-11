import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:rettulf/rettulf.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AppMenuCategory {
  final String label;
  final List<AppMenuItemBase> items;

  const AppMenuCategory({
    required this.label,
    required this.items,
  });

  const AppMenuCategory.topLevel({
    required this.items,
  }) : label = "";

  MenuBarItem _buildFluentUIItem() {
    return MenuBarItem(
      title: label,
      items: items.map((it) => it._buildFluentUIItem()).toList(),
    );
  }

  PlatformMenu _buildPlatformMenu() {
    return PlatformMenu(
      label: label,
      menus: items.map((it) => it._buildPlatformMenu()).toList(),
    );
  }
}

abstract class AppMenuItemBase {
  MenuFlyoutItemBase _buildFluentUIItem();

  PlatformMenuItem _buildPlatformMenu();
}

class AppMenuItem implements AppMenuItemBase {
  final String label;
  final MenuSerializableShortcut? shortcut;
  final VoidCallback? onPressed;

  const AppMenuItem({
    required this.label,
    required this.onPressed,
    this.shortcut,
  });

  @override
  MenuFlyoutItemBase _buildFluentUIItem() {
    return MenuFlyoutItem(
      text: label.text(),
      onPressed: onPressed,
    );
  }

  @override
  PlatformMenuItem _buildPlatformMenu() {
    return PlatformMenuItem(
      label: label,
      shortcut: shortcut,
      onSelected: onPressed,
    );
  }
}

class AppMenuItemClick {}

class AppMenuController {
  final String applicationName;
  List<AppMenuItemBase>? topLevel;
  _AppMenuState? _state;

  AppMenuController({
    required this.applicationName,
    this.topLevel,
  });

  static AppMenuController? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<_AppMenuState>()?.controller;

  static AppMenuController of(BuildContext context) => maybeOf(context)!;

  void updateMenus(List<AppMenuCategory> items) {
    if (Platform.isMacOS) {
      final topLevel = this.topLevel;
      WidgetsBinding.instance.platformMenuDelegate.setMenus([
        PlatformMenu(
          label: "",
          menus: topLevel != null
              ? topLevel.map((it) => it._buildPlatformMenu()).toList(growable: false)
              : [PlatformProvidedMenuItem(type: PlatformProvidedMenuItemType.about)],
        ),
        ...items.map((it) => it._buildPlatformMenu()),
      ]);
    }
    _state!.updateMenuItems(_buildFullAppMenu(items));
  }

  List<AppMenuCategory> _buildFullAppMenu(List<AppMenuCategory> items) {
    final topLevel = this.topLevel;
    return [
      if (topLevel != null)
        AppMenuCategory(
          label: applicationName,
          items: topLevel,
        ),
      ...items,
    ];
  }

  void _attach(_AppMenuState state) {
    assert(_state == null, "The $AppMenuController was already attached.");
    _state = state;
  }

  void _detach([_AppMenuState? state]) {
    if (_state != null && _state == state) {
      _state = null;
    }
  }

  void dispose() {
    _detach();
  }
}

class AppMenu extends StatefulWidget {
  final AppMenuController controller;
  final Widget child;

  const AppMenu({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  State<AppMenu> createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  late var controller = widget.controller;
  late var _items = controller._buildFullAppMenu([]);

  @override
  void initState() {
    super.initState();
    controller._attach(this);
  }

  @override
  void dispose() {
    controller._detach(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      controller = widget.controller;
      oldWidget.controller._detach(this);
      controller._attach(this);
    }
  }

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
  Widget build(BuildContext context) {
    // macOS has native MenuBar support
    if (Platform.isMacOS) return widget.child;
    return [
      MenuBar(
        items: _items.map((it) => it._buildFluentUIItem()).toList(growable: false),
      ),
      widget.child.expanded(),
    ].column();
  }
}

class AppMenuPage extends StatelessWidget {
  final VoidCallback onRebuild;
  final Widget child;

  const AppMenuPage({
    required Key super.key,
    required this.onRebuild,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: key!,
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.8) onRebuild();
      },
      child: child,
    );
  }
}
