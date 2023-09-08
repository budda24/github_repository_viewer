import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:repository_search/authentication/data/repositories/credential_storage_repository/secure_credentials_storage.dart';
import 'package:repository_search/authentication/data/repositories/credential_storage_repository/sembast_database.dart';
import 'package:repository_search/authentication/data/repositories/oauth2_interceptor.dart';
import 'package:repository_search/authentication/domain/repositories/github_authentication_repository.dart';
import 'package:repository_search/authentication/presentation/manager/authentication/authentication_cubit.dart';
import 'package:repository_search/core/routes/app_routes.dart';

void main() {
  final appRouter = AppRouter();
  return runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FlutterSecureStorage>(
          create: (context) => const FlutterSecureStorage(),
        ),
        RepositoryProvider<SecureCredentialsStorage>(
          create: (context) => SecureCredentialsStorage(context.read<FlutterSecureStorage>()),
        ),
        RepositoryProvider<Dio>(create: (context) => Dio()),
        RepositoryProvider<GithubAuthenticationRepository>(
          create: (context) => GithubAuthenticationRepository(
            context.read<SecureCredentialsStorage>(),
            context.read<Dio>(),
          ),
        ),
        RepositoryProvider(create: (context) => SembastDatabase()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationCubit(
              context.read<GithubAuthenticationRepository>(),
            ),
            lazy: false,
          ),
          RepositoryProvider(
            create: (context) => OAuth2Interceptor(
              context.read<GithubAuthenticationRepository>(),
              context.read<AuthenticationCubit>(),
              context.read<Dio>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          title: 'Repo Viewer',
          routerDelegate: appRouter.delegate(),
          routeInformationParser: appRouter.defaultRouteParser(),
        ),
      ),
    ),
  );
}
