import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repository_search/core/models/data/user_dto.dart';
import 'package:repository_search/repository_issues/data/models/issue_dto.dart';

part 'issue.freezed.dart';

@freezed
class Issue with _$Issue {
  const factory Issue({
    required String body,
    required UserDTO user,
    required String htmlUrl,
  }) = _Issue;

  factory Issue.fromDomain(IssueDTO issueDTO) => Issue(
        body: issueDTO.title,
        user: issueDTO.user,
        htmlUrl: issueDTO.htmlUrl,
      );
}
