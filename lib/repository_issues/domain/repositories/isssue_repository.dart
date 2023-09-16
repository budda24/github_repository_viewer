// ignore_for_file: inference_failure_on_untyped_parameter

import 'package:flutter/cupertino.dart';
import 'package:repository_search/authentication/data/models/remote_response.dart';
import 'package:repository_search/core/models/data/github_repo_dto.dart';
import 'package:repository_search/core/repositories/repo_remote_repository.dart';
import 'package:repository_search/repository_issues/data/models/issue_dto.dart';

import 'package:repository_search/repository_issues/domain/entities/issue.dart';

class IssueRepository extends RepositoryRemoteService<Issue> {
  IssueRepository(super.dio, super.headersCache);

  @visibleForTesting
  // ignore: type_annotate_public_apis
  List<Issue> dataConverter(json) {
    return (json as List<dynamic>)
        .map(
          (e) => Issue.fromDomain(IssueDTO.fromJson(e as Map<String, dynamic>)),
        )
        .toList();
  }

  Future<RemoteResponse<List<Issue>>> getIssues(
    GithubRepoDTO githubRepoDTO,
  ) async {
    final requestUrl = Uri.parse(
      'https://api.github.com/repos/${githubRepoDTO.owner.name}/${githubRepoDTO.name}/issues',
    );

    return getPage(requestUrl: requestUrl, dataConverter: dataConverter);
  }
}
