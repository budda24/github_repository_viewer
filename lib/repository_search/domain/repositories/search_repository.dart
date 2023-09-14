import 'package:dartz/dartz.dart';
import 'package:repository_search/authentication/data/models/network_exceptions.dart';
import 'package:repository_search/repository_search/data/models/dto_repository_list_extention.dart';
import 'package:repository_search/repository_search/data/repositories/search_remote_service.dart';
import 'package:repository_search/repository_search/domain/entities/fresh.dart';
import 'package:repository_search/repository_search/domain/entities/github_failures.dart';
import 'package:repository_search/repository_search/domain/entities/github_repo.dart';

class SearchedRepoRepository {
  final SearchRepositoryRemoteService _remoteService;

  SearchedRepoRepository(this._remoteService);

  Future<Either<GithubFailures, Fresh<List<GithubRepo>>>> getSearchedRepoPage(
    int page,
    String query,
  ) async {
    try {
      final remotePageItem = await _remoteService.getSearchedRepoPage(page, query);

      return right(
        remotePageItem.maybeWhen(
          orElse: () => Fresh.no([], isNextPageAvailable: false),
          noConnection: () => Fresh.no([], isNextPageAvailable: false),
          witchNewData: (data, maxPage) {
            return Fresh.yes(
              data.toDomain(),
              isNextPageAvailable: maxPage > page,
            );
          },
        ),
      );
    } on RestApiException catch (e) {
      return left(GithubFailures.api(e.errorCode));
    }
  }
}
