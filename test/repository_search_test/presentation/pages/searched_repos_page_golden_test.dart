import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:repository_search/authentication/presentation/pages/sign_in_page.dart';
import 'package:repository_search/repository_search/domain/entities/fresh.dart';
import 'package:repository_search/repository_search/presentation/manager/search/search_cubit.dart';
import 'package:repository_search/repository_search/presentation/manager/search/search_state.dart';
import 'package:repository_search/repository_search/presentation/pages/searched_repos_page.dart';

void main() {
  late MockSearchCubit mockSearchCubit;

  setUp(() {
    mockSearchCubit = MockSearchCubit();
  });
  testGoldens('it should render $SignInScreen noting found yet', (widgetTester) async {
    await loadAppFonts();
    whenListen(
      mockSearchCubit,
      Stream.fromIterable([
        const SearchState.loadingInProgress(Fresh(entity: []), 1),
        const SearchState.loadSuccess(
          Fresh(entity: []),
          isNextPageAvailable: true,
        ),
      ]),
      initialState: const SearchState.initial(Fresh(entity: [])),
    );
    final builder = DeviceBuilder()
      ..addScenario(
        widget: ScreenUtilInit(
          minTextAdapt: true,
          splitScreenMode: true,
          child: MaterialApp(
            home: SearchedReposScreen(searchCubit: mockSearchCubit),
          ),
        ),
      );

    await widgetTester.pumpDeviceBuilder(builder);

    await screenMatchesGolden(widgetTester, 'search_repository_page');
  });
}

class MockSearchCubit extends MockCubit<SearchState> implements SearchCubit {
  @override
  TextEditingController get searchController => TextEditingController();

  @override
  Future<void> getNextPage() async {}
}
