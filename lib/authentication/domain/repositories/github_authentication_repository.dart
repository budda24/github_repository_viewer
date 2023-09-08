import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart';
import 'package:repository_search/authentication/data/repositories/credential_storage_repository/credentials_storage.dart';
import 'package:repository_search/authentication/domain/entities/auth_failure.dart';
import 'package:repository_search/authentication/domain/utils/dio_extensions.dart';

class GithubOAuthHttpClient extends http.BaseClient {
  final httpClient = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';

    return httpClient.send(request);
  }
}

class GithubAuthenticationRepository {
  final CredentialsStorage credentialsStorage;
  final Dio _dio;

  GithubAuthenticationRepository(this.credentialsStorage, this._dio);

  static const clientId = '48fce3b303fb5b4c3b96';
  static const clientSecret = '6b574df6553f0e656291465e14430322840989f1';
  static const scopes = ['read:user', 'repo'];
  static final authorizationEndpoint = Uri.parse('https://github.com/login/oauth/authorize');
  static final tokenEndpoint = Uri.parse('https://github.com/login/oauth/access_token');
  static final redirectUrl = Uri.parse('http://localhost:3000/callback');
  static final revokedEndpoint = Uri.parse('https://api.github.com/applications/$clientId/token');

  Future<bool> isSignIn() => credentialsStorage.read().then((credentials) => credentials != null);

  AuthorizationCodeGrant createGrant() {
    return AuthorizationCodeGrant(
      clientId,
      authorizationEndpoint,
      tokenEndpoint,
      secret: clientSecret,
      httpClient: GithubOAuthHttpClient(),
    );
  }

  Uri getAuthorizationUrl(AuthorizationCodeGrant grant) {
    return grant.getAuthorizationUrl(redirectUrl, scopes: scopes);
  }

  Future<Either<AuthFailure, Unit>> handleAuthorization(
    AuthorizationCodeGrant grant,
    Map<String, String> queryParams,
  ) async {
    try {
      final httpClient = await grant.handleAuthorizationResponse(queryParams);

      await credentialsStorage.save(httpClient.credentials);

      return right(unit);
    } on FormatException {
      return left(const AuthFailure.server());
    } on AuthorizationException catch (e) {
      return left(AuthFailure.server('${e.error} : ${e.description}'));
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }

  Future<Either<AuthFailure, Unit>> signOut() async {
    try {
      final accessToken = await credentialsStorage.read().then((credentials) => credentials?.accessToken);

      final clientIdAndSecret = utf8.fuse(base64).encode('$clientId:$clientSecret');

      try {
        // ignore: inference_failure_on_function_invocation
        await _dio.deleteUri(
          revokedEndpoint,
          data: {'access_token': accessToken},
          options: Options(
            headers: {'Authorization': 'basic $clientIdAndSecret'},
          ),
        );
      } on DioException catch (e) {
        if (e.isNoInternetConnection) {
          //ignoring
        } else {
          rethrow;
        }
      }

      return await clearCredentialsStorage();
    } on PlatformException {
      return left(
        const AuthFailure.storage(),
      );
    }
  }

  Future<Either<AuthFailure, Unit>> clearCredentialsStorage() async {
    try {
      await credentialsStorage.clear();
      return right(unit);
    } on FormatException {
      return left(
        const AuthFailure.storage(),
      );
    }
  }
}
