import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:repository_search/authentication/presentation/manager/authentication/authentication_cubit.dart';
import 'package:repository_search/authentication/presentation/manager/authentication/authentication_state.dart';
import 'package:repository_search/authentication/presentation/pages/sign_in_page.dart';

void main() {
  late MockAuthenticationCubit mockAuthenticationCubit;

  setUp(() {
    mockAuthenticationCubit = MockAuthenticationCubit();
  });
  testGoldens('it should render $SignInScreen', (widgetTester) async {
    await loadAppFonts();
    whenListen(
      mockAuthenticationCubit,
      Stream.fromIterable([const AuthenticationState.unauthenticated()]),
      initialState: const AuthenticationState.initial(),
    );
    final builder = DeviceBuilder()
      ..addScenario(
        widget: SignInScreen(authenticationCubit: mockAuthenticationCubit),
      );

    await widgetTester.pumpDeviceBuilder(builder);

    await screenMatchesGolden(widgetTester, 'sing_in_screen');
  });
}

class MockAuthenticationCubit extends MockCubit<AuthenticationState> implements AuthenticationCubit {
  @override
  Future<void> checkAndUpdateAuthStatus() async {}
}
