import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repository_search/repository_search/data/models/github_headers.dart';
import 'package:repository_search/repository_search/data/repositories/search_remote_service.dart';

import '../../../mocks.mocks.dart';

void main() {
  late Dio dio;
  late MockGithubHeadersCache mockGithubHeadersCache;
  late SearchRepositoryRemoteService searchRepositoryRemoteService;
  setUpAll(() {
    dio = Dio();
    mockGithubHeadersCache = MockGithubHeadersCache();
    searchRepositoryRemoteService = SearchRepositoryRemoteService(dio, mockGithubHeadersCache);
  });
  test('calling getSearchedRepoPage should call headersCache.read  ', () async {
    //arrange
    when(mockGithubHeadersCache.read(any)).thenAnswer((realInvocation) async => const GithubHeaders());

    //act
    try {
      await searchRepositoryRemoteService.getSearchedRepoPage(1, 'flutter');
    } catch (_) {}

    //assert
    verify(mockGithubHeadersCache.read(any));
  });
}
