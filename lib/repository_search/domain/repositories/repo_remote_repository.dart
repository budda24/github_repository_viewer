import 'package:dio/dio.dart';
import 'package:repository_search/authentication/data/models/network_exceptions.dart';
import 'package:repository_search/authentication/data/models/remote_response.dart';
import 'package:repository_search/authentication/domain/utils/dio_extensions.dart';
import 'package:repository_search/repository_search/data/models/github_headers.dart';
import 'package:repository_search/repository_search/data/models/github_repo_dto.dart';
import 'package:repository_search/repository_search/data/repositories/github_headers_cache.dart';

abstract class RepositoryRemoteService {
  final Dio _dio;
  final GithubHeadersCache _headersCache;

  RepositoryRemoteService(
    this._dio,
    this._headersCache,
  );

  Future<RemoteResponse<List<GithubRepoDTO>>> getPage({
    required Uri requestUrl,
    required List<dynamic> Function(dynamic json) jsonDataSelector,
  }) async {
    final previousHeaders = await _headersCache.read(requestUrl);
    try {
      // ignore: inference_failure_on_function_invocation
      final response = await _dio.getUri(
        requestUrl,
        options: Options(),
      );

      if (response.statusCode == 304) {
        return RemoteResponse.noChanges(
          maxPage: previousHeaders?.link?.maxPage ?? 0,
        );
      } else if (response.statusCode == 200) {
        final headers = GithubHeaders.parse(response);

        await _headersCache.save(
          requestUrl,
          headers,
        );

        final convertedData =
            jsonDataSelector(response.data).map((e) => GithubRepoDTO.fromJson(e as Map<String, dynamic>)).toList();

        return RemoteResponse.witchNewData(
          convertedData,
          maxPage: headers.link?.maxPage ?? 1,
        );
      } else {
        throw RestApiException(response.statusCode);
      }
    } on DioException catch (e) {
      if (e.isNoInternetConnection) {
        return const RemoteResponse.noConnection();
      } else if (e.response != null) {
        throw RestApiException(e.response?.statusCode);
      } else {
        rethrow;
      }
    }
  }
}
