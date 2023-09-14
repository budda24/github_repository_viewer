import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repository_search/authentication/data/data_sources/sembast_database.dart';
import 'package:repository_search/authentication/data/repositories/oauth2_interceptor.dart';
import 'package:repository_search/authentication/presentation/manager/authentication/authentication_cubit.dart';
import 'package:repository_search/authentication/presentation/manager/authentication/authentication_state.dart';
import 'package:repository_search/authentication/presentation/pages/sign_in_page.dart';
import 'package:repository_search/core/routes/app_routes.dart';
import 'package:repository_search/core/utilities/build_context_ext.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.scheduleFrameCallback((timeStamp) {
      context.read<SembastDatabase>().initialize();
    });

    context.read<Dio>()
      ..options = BaseOptions(
        headers: {'Accept': 'application/vnd.github.html+json'},
        validateStatus: (status) => status != null && status >= 200 && status < 400,
      )
      ..interceptors.add(
        context.read<OAuth2Interceptor>(),
      );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      child: BlocListener<AuthenticationCubit, AuthenticationState>(
        bloc: context.read<AuthenticationCubit>(),
        listener: (listenerContext, state) => state.maybeMap(
          orElse: () => null,
          authenticated: (_) {
            return context.routing.push(
              SearchedReposRoute(searchedRepoName: 'online_tribes_app'),
              /*predicate: (route) => false,*/
            );
          },
          unauthenticated: (_) {
            return context.routing.push(
              const SignInRoute(),
              /*predicate: (route) => false,*/
            );
          },
        ),
        child: const SignInScreen(),
      ),
    );
  }
}
