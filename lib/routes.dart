import 'package:go_router/go_router.dart';
import 'package:i18n_tool/page/index.dart';

RoutingConfig buildRoutingConfig() {
  return RoutingConfig(
    routes: [
      GoRoute(
        path: "/",
        builder: (ctx, state) => const IndexPage(),
      ),
    ],
  );
}
