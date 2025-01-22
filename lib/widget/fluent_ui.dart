import 'package:fluent_ui/fluent_ui.dart';

extension type const CommandBarItemWithTooltip._(CommandBarBuilderItem item) implements CommandBarItem {
  factory CommandBarItemWithTooltip({
    required String tooltip,
    required Widget icon,
    VoidCallback? onPressed,
  }) {
    return CommandBarItemWithTooltip._(CommandBarBuilderItem(
      builder: (context, displayMode, child) => Tooltip(message: tooltip, child: child),
      wrappedItem: CommandBarButton(
        icon: icon,
        onPressed: onPressed,
      ),
    ));
  }
}
