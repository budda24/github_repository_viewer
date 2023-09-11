import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:repository_search/authentication/presentation/pages/authorization_page.dart';
import 'package:repository_search/authentication/presentation/pages/sign_in_page.dart';
import 'package:repository_search/home_screen.dart';
import 'package:repository_search/repository_search/presentation/pages/searched_repos_page.dart';
import 'package:repository_search/splash_screen/splash_page.dart';

part 'app_routes.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: SignInRoute.page),
        AutoRoute(page: AuthorizationRoute.page),
        AutoRoute(page: SearchedReposRoute.page),
      ];
}
