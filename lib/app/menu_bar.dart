import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:i18n_tool/r.dart';
import 'package:i18n_tool/widget/app_menu.dart';

AppMenuController buildAppMenuController(BuildContext context) {
  return AppMenuController(
    applicationName: R.appName,
    topLevel: [
      AppMenuItem(
        label: "Settings",
        onPressed: () {
          context.push("/settings");
        },
      ),
    ],
  );
}
