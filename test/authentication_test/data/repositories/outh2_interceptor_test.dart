import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:repository_search/authentication/data/repositories/oauth2_interceptor.dart';
import 'package:repository_search/authentication/presentation/manager/authentication/authentication_cubit.dart';

import '../../../mocks.dart';
import '../../../mocks.mocks.dart';

void main() {
  late OAuth2Interceptor oAuth2Interceptor;
  late MockGithubAuthenticationRepository mockGithubAuthenticationRepository;
  late AuthenticationCubit authenticationCubit;
  late MockCredentialsStorage mockCredentialsStorage;
  late Dio dio;
  setUp(() {
    dio = Dio();
    mockCredentialsStorage = MockCredentialsStorage();

    authenticationCubit = MockAuthenticationCubit();
    mockGithubAuthenticationRepository = MockGithubAuthenticationRepository();
    oAuth2Interceptor = OAuth2Interceptor(mockGithubAuthenticationRepository, authenticationCubit, dio);
  });

  test('on request should call credential storage read', () {
    //arrange
    when(mockGithubAuthenticationRepository.credentialsStorage).thenReturn(mockCredentialsStorage);

    //act
    oAuth2Interceptor.onRequest(RequestOptions(), RequestInterceptorHandler());

    //assert
    verify(mockCredentialsStorage.read());
  });
}
