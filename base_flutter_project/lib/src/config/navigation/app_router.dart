import 'package:auto_route/auto_route.dart';

import 'package:injectable/injectable.dart';

part 'app_router.gr.dart';

@singleton
@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => <AutoRoute>[
      ];
}
