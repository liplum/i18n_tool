import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:i18n_tool/app/routes.dart';
import 'package:i18n_tool/lifecycle.dart';
import 'package:i18n_tool/r.dart';

import 'app/error.dart';

class I18nToolApp extends StatefulWidget {
  const I18nToolApp({super.key});

  @override
  State<I18nToolApp> createState() => _I18nToolAppState();
}

class _I18nToolAppState extends State<I18nToolApp> {
  final $routingConfig = ValueNotifier(buildRoutingConfig());
  late final router = _buildRouter($routingConfig);

  @override
  Widget build(BuildContext context) {
    return FluentApp.router(
      title: R.appName,
      routerConfig: router,
      themeMode: ThemeMode.system,
      theme: FluentThemeData.light(),
      darkTheme: FluentThemeData.dark(),
      builder: (ctx, child) => Flyout(builder: (context) {
        return child ?? const SizedBox();
      }),
    );
  }

  GoRouter _buildRouter(ValueNotifier<RoutingConfig> $routingConfig) {
    return GoRouter.routingConfig(
      routingConfig: $routingConfig,
      navigatorKey: $key,
      initialLocation: "/",
      debugLogDiagnostics: kDebugMode,
      errorBuilder: (ctx, state) => ErrorPage(message: state.error.toString()),
    );
  }
}
