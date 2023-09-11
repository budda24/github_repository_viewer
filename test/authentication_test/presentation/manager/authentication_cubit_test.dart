import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:oauth2/oauth2.dart';
import 'package:repository_search/authentication/domain/entities/auth_failure.dart';
import 'package:repository_search/authentication/presentation/manager/authentication/authentication_cubit.dart';
import 'package:repository_search/authentication/presentation/manager/authentication/authentication_state.dart';

import '../../../mocks.mocks.dart';

void main() {
  late final AuthenticationCubit authenticationCubit;
  late MockGithubAuthenticationRepository mockGithubAuthenticationRepository;

  setUpAll(() {
    mockGithubAuthenticationRepository = MockGithubAuthenticationRepository();
    authenticationCubit = AuthenticationCubit(mockGithubAuthenticationRepository);
  });
  test('it should be initialize with AuthenticationState.authenticated state ', () {
    expect(authenticationCubit.state, const AuthenticationState.initial());
  });
  test('signIn method should emit AuthenticationState.authenticated', () async {
    //arrange
    when(mockGithubAuthenticationRepository.getAuthorizationUrl(any)).thenAnswer((realInvocation) => Uri());
    when(mockGithubAuthenticationRepository.createGrant()).thenAnswer(
      (realInvocation) => AuthorizationCodeGrant('', Uri.parse(''), Uri.parse('')),
    );
    when(
      mockGithubAuthenticationRepository.handleAuthorization(any, any),
    ).thenAnswer((realInvocation) async => right(unit));

    //act
    await authenticationCubit.signIn((authorizationUri) async {
      return Uri();
    });

    //assert
    expect(authenticationCubit.state, const AuthenticationState.authenticated());
  });

  test('signIn method should emit AuthenticationState.failure', () async {
    //arrange
    when(mockGithubAuthenticationRepository.getAuthorizationUrl(any)).thenAnswer((realInvocation) => Uri());
    when(mockGithubAuthenticationRepository.createGrant()).thenAnswer(
      (realInvocation) => AuthorizationCodeGrant('', Uri.parse(''), Uri.parse('')),
    );
    when(
      mockGithubAuthenticationRepository.handleAuthorization(any, any),
    ).thenAnswer((realInvocation) async => left(const AuthFailure.storage()));

    //act
    await authenticationCubit.signIn((authorizationUri) async {
      return Uri();
    });

    //assert
    expect(authenticationCubit.state, const AuthenticationState.failure(AuthFailure.storage()));
  });
  test('signOut method should emit AuthenticationState.failure', () async {
    //arrange
    when(mockGithubAuthenticationRepository.signOut())
        .thenAnswer((realInvocation) async => left(const AuthFailure.storage()));

    //act
    await authenticationCubit.signOut();

    //assert
    expect(
      authenticationCubit.state,
      const AuthenticationState.failure(AuthFailure.storage()),
    );
  });
  test('signOut method should emit AuthenticationState.unauthenticated', () async {
    //arrange
    when(mockGithubAuthenticationRepository.signOut()).thenAnswer(
      (realInvocation) async => right(unit),
    );

    //act
    await authenticationCubit.signOut();

    //assert
    expect(
      authenticationCubit.state,
      const AuthenticationState.unauthenticated(),
    );
  });
}
