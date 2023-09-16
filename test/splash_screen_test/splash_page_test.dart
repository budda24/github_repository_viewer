import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:repository_search/authentication/presentation/pages/sign_in_page.dart';
import 'package:repository_search/splash_screen/presentation/splash_page.dart';

void main() {
  testGoldens('it should render $SignInScreen', (widgetTester) async {
    await loadAppFonts();
    final builder = DeviceBuilder()
      ..addScenario(
        widget: const SplashScreen(),
      );

    await widgetTester.pumpDeviceBuilder(builder);

    await screenMatchesGolden(
      widgetTester,
      'detail_screen',
      customPump: (wigetTester) {
        return widgetTester.pump(const Duration(seconds: 3));
      },
    );
  });
}

/*
@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      context.router.popAndPush(
        const HomeRoute(),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 34),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cable,
              size: 150,
            ),
            SizedBox(
              height: 15,
            ),
            LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
*/
