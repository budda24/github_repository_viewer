import 'package:bloc/bloc.dart';

import 'package:repository_search/authentication/domain/repositories/github_authentication_repository.dart';
import 'package:repository_search/authentication/presentation/manager/authentication/authentication_state.dart';

typedef AuthUriCallback = Future<Uri> Function(Uri authorizationUri);

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit(this._authenticator) : super(const AuthenticationState.initial());

  final GithubAuthenticationRepository _authenticator;

  Future<void> checkAndUpdateAuthStatus() async {
    emit(
      await _authenticator.isSignIn()
          ? const AuthenticationState.authenticated()
          : const AuthenticationState.unauthenticated(),
    );
  }

  @override
  void onChange(Change<AuthenticationState> change) {
    super.onChange(change);
  }

  Future<void> signIn(AuthUriCallback authorizationCallback) async {
    final grant = _authenticator.createGrant();
    final responseUri = await authorizationCallback(_authenticator.getAuthorizationUrl(grant));
    final failureOrSuccess = await _authenticator.handleAuthorization(
      grant,
      responseUri.queryParameters,
    );

    emit(
      failureOrSuccess.fold(
        AuthenticationState.failure,
        (r) => const AuthenticationState.authenticated(),
      ),
    );

    grant.close();
  }

  Future<void> signOut() async {
    final failureOrSuccess = await _authenticator.signOut();

    emit(
      failureOrSuccess.fold(
        AuthenticationState.failure,
        (r) => const AuthenticationState.unauthenticated(),
      ),
    );
  }
}
