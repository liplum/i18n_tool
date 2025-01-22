import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'index/index.dart';
import 'index/projects.dart';
import 'project/index.dart';
import 'settings/for_new_projects.dart';
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
            redirect: (ctx, state) => state.fullPath == "/index" ? "/index/projects" : null,
            routes: [
              GoRoute(
                path: "/projects",
                builder: (ctx, state) => const IndexProjectsPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: "/project/:uuid",
        builder: (ctx, state) {
          final uuid = state.pathParameters["uuid"];
          return ProjectIndexPage(uuid: uuid ?? "");
        },
      ),
      ShellRoute(
        navigatorKey: _$settings,
        builder: (ctx, state, child) {
          return SettingsIndexPage(child: child);
        },
        routes: [
          GoRoute(
            path: "/settings",
            redirect: (ctx, state) => state.fullPath == "/settings" ? "/settings/general" : null,
            routes: [
              GoRoute(
                path: "/general",
                builder: (ctx, state) => const GeneralSettingsPage(),
              ),
              GoRoute(
                path: "/for-new-projects",
                builder: (ctx, state) => const ForNewProjectsSettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
