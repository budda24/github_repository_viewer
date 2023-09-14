import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repository_search/repository_search/domain/entities/fresh.dart';
import 'package:repository_search/repository_search/domain/entities/github_failures.dart';
import 'package:repository_search/repository_search/domain/entities/github_repo.dart';
part 'search_state.freezed.dart';

typedef PageGetter = Future<Either<GithubFailures, Fresh<List<GithubRepo>>>> Function(int page);

@freezed
class SearchState with _$SearchState {
  const factory SearchState.initial(
    Fresh<List<GithubRepo>> repos,
  ) = _Initial;

  const factory SearchState.loadingInProgress(
    Fresh<List<GithubRepo>> repos,
    int itemsPerPage,
  ) = _LoadingInProgress;

  const factory SearchState.loadSuccess(
    Fresh<List<GithubRepo>> repos, {
    required bool isNextPageAvailable,
  }) = _LoadSuccess;

  const factory SearchState.loadFailure(
    Fresh<List<GithubRepo>> repos,
    GithubFailures failures,
  ) = _LoadFailure;
}
