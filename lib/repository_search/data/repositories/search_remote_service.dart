// ignore_for_file: avoid_dynamic_calls

import 'package:repository_search/authentication/data/models/remote_response.dart';
import 'package:repository_search/core/models/data/github_repo_dto.dart';
import 'package:repository_search/core/repositories/repo_remote_repository.dart';
import 'package:repository_search/repository_search/data/models/pagination_config.dart';

class SearchRepositoryRemoteService extends RepositoryRemoteService<GithubRepoDTO> {
  SearchRepositoryRemoteService(
    super.dio,
    super.headersCache,
  );

  Future<RemoteResponse<List<GithubRepoDTO>>> getSearchedRepoPage(
    int page,
    String query,
  ) async {
    return super.getPage(
      requestUrl: Uri.https(
        'api.github.com',
        '/search/repositories',
        {
          'q': query,
          'page': page.toString(),
          'per_page': PaginationConfig.itemsPerPage.toString(),
        },
      ),
      dataConverter: (json) =>
          (json['items'] as List<dynamic>).map((e) => GithubRepoDTO.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
