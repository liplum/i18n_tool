import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'edit/[project].dart';
import 'edit/index.dart';
import 'start/index.dart';
import 'start/projects.dart';

final _$start = GlobalKey<NavigatorState>();
final _$edit = GlobalKey<NavigatorState>();

RoutingConfig buildRoutingConfig() {
  return RoutingConfig(
    routes: [
      GoRoute(
        path: "/",
        redirect: (ctx, state) => "/start",
      ),
      ShellRoute(
        navigatorKey: _$start,
        builder: (ctx, state, child) {
          return StartIndexPage(child: child);
        },
        routes: [
          GoRoute(
            path: "/start",
            redirect: (ctx, state) => "/start/projects",
            routes: [
              GoRoute(
                path: "/projects",
                builder: (ctx, state) => const StartProjectsPage(),
              ),
            ],
          ),
        ],
      ),
      ShellRoute(
        navigatorKey: _$edit,
        builder: (ctx, state, child) {
          return EditIndexPage(child: child);
        },
        routes: [
          GoRoute(
            path: "/edit/:project",
            builder: (ctx, state) => const EditProjectPage(),
          ),
        ],
      ),
    ],
  );
}
