import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:repository_search/authentication/data/data_sources/sembast_database.dart';
import 'package:repository_search/authentication/data/repositories/credential_storage_repository/secure_credentials_storage.dart';
import 'package:repository_search/authentication/data/repositories/oauth2_interceptor.dart';
import 'package:repository_search/authentication/domain/repositories/github_authentication_repository.dart';
import 'package:repository_search/authentication/presentation/manager/authentication/authentication_cubit.dart';
import 'package:repository_search/core/routes/app_routes.dart';
import 'package:repository_search/repository_issues/domain/repositories/isssue_repository.dart';
import 'package:repository_search/repository_issues/presentation/manager/issues_cubit.dart';
import 'package:repository_search/repository_search/data/repositories/github_headers_cache.dart';
import 'package:repository_search/repository_search/domain/repositories/search_repository.dart';
import 'package:repository_search/repository_search/presentation/manager/search/search_cubit.dart';

import 'repository_search/data/repositories/search_remote_service.dart';

void main() {
  final appRouter = AppRouter();
  return runApp(
    MultiBlocProvider(
      providers: [
        RepositoryProvider<Dio>(create: (context) => Dio()),
        RepositoryProvider<SembastDatabase>(
          create: (context) => SembastDatabase(),
        ),
        RepositoryProvider<GithubAuthenticationRepository>(
          create: (context) => GithubAuthenticationRepository(
            SecureCredentialsStorage(const FlutterSecureStorage()),
            context.read<Dio>(),
          ),
        ),
        RepositoryProvider<IssueRepository>(
          create: (context) => IssueRepository(
            context.read<Dio>(),
            GithubHeadersCache(context.read<SembastDatabase>()),
          ),
        ),
        BlocProvider(
          create: (context) => AuthenticationCubit(
            context.read<GithubAuthenticationRepository>(),
          ),
          lazy: false,
        ),
        RepositoryProvider<OAuth2Interceptor>(
          create: (context) => OAuth2Interceptor(
            context.read<GithubAuthenticationRepository>(),
            context.read<AuthenticationCubit>(),
          ),
        ),
        BlocProvider(
          create: (context) => SearchCubit(
            SearchedRepoRepository(
              SearchRepositoryRemoteService(
                context.read<Dio>(),
                GithubHeadersCache(context.read<SembastDatabase>()),
              ),
            ),
          ),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => IssuesCubit(context.read<IssueRepository>()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Repo Viewer',
        routerDelegate: appRouter.delegate(),
        routeInformationParser: appRouter.defaultRouteParser(),
      ),
    ),
  );
}
