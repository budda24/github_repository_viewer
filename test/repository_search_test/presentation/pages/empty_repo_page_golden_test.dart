import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:repository_search/repository_search/presentation/pages/empty_repo_page.dart';

void main() {
  testGoldens('it should render $EmptyRepoPage', (widgetTester) async {
    await loadAppFonts();

    final builder = DeviceBuilder()
      ..addScenario(
        widget: const EmptyRepoPage(message: 'test'),
      );

    await widgetTester.pumpDeviceBuilder(builder);

    await screenMatchesGolden(widgetTester, 'empty_repo_page');
  });
}
