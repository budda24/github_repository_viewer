import 'package:repository_search/authentication/data/models/remote_response.dart';
import 'package:repository_search/core/models/github_repo_dto.dart';
import 'package:repository_search/repository_search/data/models/pagination_config.dart';
import 'package:repository_search/repository_search/domain/repositories/repo_remote_repository.dart';

class SearchRepositoryRemoteService extends RepositoryRemoteService {
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

      // ignore: avoid_dynamic_calls
      jsonDataSelector: (json) => json['items'] as List<dynamic>,
    );
  }
}
