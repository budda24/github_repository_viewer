import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:repository_search/authentication/presentation/pages/sign_in_page.dart';
import 'package:repository_search/core/models/domain/user.dart';
import 'package:repository_search/repository_detail/presentation/pages/detail_screen.dart';
import 'package:repository_search/repository_search/domain/entities/github_repo.dart';

void main() {
  testGoldens('it should render $SignInScreen', (widgetTester) async {
    await loadAppFonts();
    final builder = DeviceBuilder()
      ..addScenario(
        widget: const ScreenUtilInit(
          minTextAdapt: true,
          splitScreenMode: true,
          child: DetailScreen(
            githubRepo: GithubRepo(
              name: 'test',
              owner: User(
                name: 'Dhruvch1244',
                avatarUrl: 'https://avatars.githubusercontent.com/u/90834396?v=4',
              ),
              stargazersCount: 1,
              description: "something I'm going to test",
              language: 'dart',
              url: 'https://api.github.com/repos/samarthagarwal/FlutterScreens/issues/55',
              watchersCount: 1,
            ),
          ),
        ),
      );

    await widgetTester.pumpDeviceBuilder(builder);

    await screenMatchesGolden(
      widgetTester,
      'detail_screen',
    );
  });
}
