import 'package:dio/dio.dart';
import 'package:repository_search/authentication/domain/repositories/github_authentication_repository.dart';
import 'package:repository_search/authentication/presentation/manager/authentication/authentication_cubit.dart';

class OAuth2Interceptor extends Interceptor {
  final GithubAuthenticationRepository _authenticator;
  final AuthenticationCubit _authCubit;
  final Dio _dio;

  OAuth2Interceptor(this._authenticator, this._authCubit, this._dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final credentials = await _authenticator.credentialsStorage.read();

    final modifiedOptions = options
      ..headers.addAll(
        credentials == null ? {} : {'Authorization': 'bearer ${credentials.accessToken}'},
      );

    handler.next(modifiedOptions);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final errorResponse = err.response;

    if (errorResponse != null && errorResponse.statusCode == 401) {
      await _authenticator.clearCredentialsStorage();
      await _authCubit.checkAndUpdateAuthStatus();

      final storedCredentials = await _authenticator.credentialsStorage.read();

      if (storedCredentials != null) {
        handler.resolve(
          await _dio.fetch(
            errorResponse.requestOptions..headers['Authorization'] = 'bearer ${storedCredentials.accessToken}',
          ),
        );
      }
    } else {
      handler.next(err);
    }
  }
}
