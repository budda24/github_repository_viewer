// ignore_for_file: unused_element, implementation_imports, depend_on_referenced_packages
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository_search/authentication/data/repositories/credential_storage_repository/credentials_storage.dart';
import 'package:repository_search/authentication/domain/repositories/github_authentication_repository.dart';
import 'package:repository_search/authentication/presentation/manager/authentication/authentication_cubit.dart';
import 'package:repository_search/authentication/presentation/manager/authentication/authentication_state.dart';

@GenerateNiceMocks(
  [
    MockSpec<GithubAuthenticationRepository>(),
    MockSpec<CredentialsStorage>(),
  ],
)
class _Mocks {}

class MockAuthenticationCubit extends MockCubit<AuthenticationState> implements AuthenticationCubit {}

class MockAuthenticationState extends Fake implements AuthenticationState {}
