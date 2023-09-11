import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:oauth2/oauth2.dart';
import 'package:repository_search/authentication/domain/repositories/github_authentication_repository.dart';

import '../../../mocks.mocks.dart';

void main() {
  late GithubAuthenticationRepository githubAuthenticationRepository;
  late MockCredentialsStorage mockCredentialsStorage;
  late Dio dio;
  setUp(() {
    dio = Dio();
    mockCredentialsStorage = MockCredentialsStorage();
    githubAuthenticationRepository = GithubAuthenticationRepository(mockCredentialsStorage, dio);
  });
  test('isSignIn method should call credentialsStorage.read()', () async {
    //arrange
    when(mockCredentialsStorage.read()).thenAnswer((realInvocation) async => Credentials('accessToken'));
    //act
    final result = await githubAuthenticationRepository.isSignIn();

    //assert
    verify(mockCredentialsStorage.read());
    expect(result, true);
  });
}
