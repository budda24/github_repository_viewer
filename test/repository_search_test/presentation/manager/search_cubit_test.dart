import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:repository_search/repository_search/domain/entities/fresh.dart';
import 'package:repository_search/repository_search/domain/entities/github_failures.dart';
import 'package:repository_search/repository_search/domain/entities/github_repo.dart';
import 'package:repository_search/repository_search/presentation/manager/search/search_cubit.dart';
import 'package:repository_search/repository_search/presentation/manager/search/search_state.dart';
import 'package:test/test.dart';

import '../../../mocks.mocks.dart';

void main() {
  late SearchCubit searchCubit;
  late MockSearchedRepoRepository mockSearchedRepoRepository;
  setUp(() {
    mockSearchedRepoRepository = MockSearchedRepoRepository();
    searchCubit = SearchCubit(mockSearchedRepoRepository);
  });
  tearDown(() {
    searchCubit.close();
  });

  test('clear function should emit SearchState.initial(Fresh.yes([]) ', () {
    //arrange

    //act
    searchCubit.clearState();
    //assert
    expect(searchCubit.state, SearchState.initial(Fresh.yes([])));
  });

  group('search method', () {
    test('search function with empty text should emit SearchState.initial(Fresh.yes([]) ', () {
      //arrange

      //act
      searchCubit.search();
      //assert
      expect(searchCubit.state, SearchState.initial(Fresh.yes([])));
    });

    blocTest<SearchCubit, SearchState>(
      'state should be as follows when getSearchedRepoPage() is called and returns GithubFailures ',
      setUp: () => when(mockSearchedRepoRepository.getSearchedRepoPage(1, 'test'))
          .thenAnswer((_) async => left(const GithubFailures.api(401))),
      build: () => SearchCubit(mockSearchedRepoRepository),
      act: (cubit) async {
        cubit.searchController.text = 'test';
        await cubit.search();
      },
      expect: () => <SearchState>[
        const SearchState.initial(
          Fresh<List<GithubRepo>>(
            entity: [],
          ),
        ),
        const SearchState.loadingInProgress(
          Fresh(
            entity: [],
          ),
          0,
        ),
        const SearchState.loadFailure(
          Fresh(
            entity: [],
          ),
          GithubFailures.api(401),
        ),
      ],
      verify: (_) async {
        verify(mockSearchedRepoRepository.getSearchedRepoPage(any, any));
      },
    );
    blocTest<SearchCubit, SearchState>(
      'state should be as follows when getSearchedRepoPage() is called and returns Fresh<List<GithubRepo>>> ',
      setUp: () => when(mockSearchedRepoRepository.getSearchedRepoPage(1, 'test')).thenAnswer(
        (_) async => right(const Fresh(entity: [], isNextPageAvailable: false)),
      ),
      build: () => SearchCubit(mockSearchedRepoRepository),
      act: (cubit) async {
        cubit.searchController.text = 'test';
        await cubit.search();
      },
      expect: () => <SearchState>[
        const SearchState.initial(
          Fresh<List<GithubRepo>>(
            entity: [],
          ),
        ),
        const SearchState.loadingInProgress(
          Fresh(
            entity: [],
          ),
          0,
        ),
        const SearchState.loadSuccess(
          Fresh(entity: [], isNextPageAvailable: false),
          isNextPageAvailable: false,
        ),
      ],
      verify: (_) async {
        verify(mockSearchedRepoRepository.getSearchedRepoPage(any, any));
      },
    );
  });
  group('getNextPage', () {
    test('calling next page should increment page', () async {
      //arrange
      when(mockSearchedRepoRepository.getSearchedRepoPage(any, any)).thenAnswer(
        (realInvocation) async => right(const Fresh(entity: [], isNextPageAvailable: false)),
      );

      //act
      await searchCubit.getNextPage();
      //assert
      expect(searchCubit.page, 2);
    });
  });
}
