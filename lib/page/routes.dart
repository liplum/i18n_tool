import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'start/index.dart';
import 'start/projects.dart';

final _shellKey = GlobalKey<NavigatorState>();

RoutingConfig buildRoutingConfig() {
  return RoutingConfig(
    routes: [
      GoRoute(
        path: "/",
        redirect: (ctx, state) => "/start/projects",
      ),
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (ctx, state, child) {
          return StartPage(child: child);
        },
        routes: [
          GoRoute(
            path: "/start/projects",
            builder: (ctx, state) => const StartProjectsPage(),
          ),
        ],
      ),
    ],
  );
}
