import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repository_search/repository_issues/domain/entities/issue.dart';
import 'package:repository_search/repository_issues/domain/repositories/isssue_repository.dart';
import '../../../fixtures/fixture_reader.dart';
import '../../../mocks.mocks.dart';

void main() {
  late IssueRepository issueRepository;
  late MockGithubHeadersCache mockGithubHeadersCache;
  late Dio dio;
  setUp(() {
    dio = Dio();
    mockGithubHeadersCache = MockGithubHeadersCache();
    issueRepository = IssueRepository(dio, mockGithubHeadersCache);
  });
  test('dataConverter method should convert json to ${List<Issue>}', () async {
    //arrange
    final json = fixture('github_issues.json');
    //act
    final issues = issueRepository.dataConverter(jsonDecode(json));
    //assert
    expect(issues.length, 15);
  });
}
