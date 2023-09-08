import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repository_search/authentication/domain/entities/auth_failure.dart';

part 'authentication_state.freezed.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.initial() = _Initial;

  const factory AuthenticationState.unauthenticated() = _Unauthenticated;

  const factory AuthenticationState.authenticated() = _Authenticated;

  const factory AuthenticationState.failure(AuthFailure failure) = _Failure;
}
