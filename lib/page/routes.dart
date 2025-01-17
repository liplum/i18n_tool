import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:i18n_tool/page/project/%5Bproject%5D.dart';
import 'package:i18n_tool/page/project/index.dart';

import 'index/index.dart';
import 'index/projects.dart';
import 'settings/general.dart';
import 'settings/index.dart';

final _$start = GlobalKey<NavigatorState>();
final _$project = GlobalKey<NavigatorState>();
final _$settings = GlobalKey<NavigatorState>();

RoutingConfig buildRoutingConfig() {
  return RoutingConfig(
    routes: [
      GoRoute(
        path: "/",
        redirect: (ctx, state) => "/index",
      ),
      ShellRoute(
        navigatorKey: _$start,
        builder: (ctx, state, child) {
          return IndexIndexPage(child: child);
        },
        routes: [
          GoRoute(
            path: "/index",
            redirect: (ctx, state) => "/index/projects",
            routes: [
              GoRoute(
                path: "/projects",
                builder: (ctx, state) => const IndexProjectsPage(),
              ),
            ],
          ),
        ],
      ),
      ShellRoute(
        navigatorKey: _$project,
        builder: (ctx, state, child) {
          return ProjectIndexPage(child: child);
        },
        routes: [
          GoRoute(
            path: "/project/:project",
            builder: (ctx, state) => const ProjectPage(),
          ),
        ],
      ),
      ShellRoute(
        navigatorKey: _$settings,
        builder: (ctx, state, child) {
          return SettingsIndexPage(child: child);
        },
        routes: [
          GoRoute(
            path: "/settings",
            redirect: (ctx, state) => "/settings/general",
            routes: [
              GoRoute(
                path: "/general",
                builder: (ctx, state) => const GeneralSettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
