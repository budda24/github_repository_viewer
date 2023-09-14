// ignore_for_file: require_trailing_commas

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:repository_search/repository_search/domain/entities/fresh.dart';
import 'package:repository_search/repository_search/domain/repositories/search_repository.dart';
import 'package:repository_search/repository_search/presentation/manager/search/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchedRepoRepository _searchedRepoRepository;

  SearchCubit(this._searchedRepoRepository)
      : super(
          SearchState.initial(Fresh.yes([])),
        );

  @override
  void onChange(Change<SearchState> change) {
    super.onChange(change);
  }

  @visibleForTesting
  int page = 1;
  TextEditingController searchController = TextEditingController();

  @visibleForTesting
  void clearState() {
    page = 1;
    emit(SearchState.initial(Fresh.yes([])));
  }

  Future<void> search() async {
    if (searchController.value.text.isNotEmpty) {
      clearState();
      await _getRepos(searchController.value.text, false);
    }
  }

  Future<void> getNextPage() async {
    await _getRepos(searchController.text, true);
  }

  Future<void> _getRepos(String term, bool getNextPage) async {
    if (!getNextPage) {
      emit(
        const SearchState.loadingInProgress(Fresh(entity: []), 0),
      );
    }

    final result = await _searchedRepoRepository.getSearchedRepoPage(page, term);

    emit(
      result.fold(
        (left) => SearchState.loadFailure(
          state.repos,
          left,
        ),
        (right) {
          if (getNextPage) {
            page++;
          }
          return SearchState.loadSuccess(
            right.copyWith(
              entity: [
                ...right.entity,
                ...state.repos.entity,
              ],
            ),
            isNextPageAvailable: right.isNextPageAvailable ?? false,
          );
        },
      ),
    );
  }
}
