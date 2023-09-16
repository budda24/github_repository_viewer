import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repository_search/repository_issues/domain/entities/issue.dart';
part 'issues_state.freezed.dart';

@freezed
class IssuesState with _$IssuesState {
  const factory IssuesState.initial() = _Initial;

  const factory IssuesState.loading() = _Loading;

  const factory IssuesState.error(String message) = _Error;

  const factory IssuesState.succes(List<Issue> issues) = _Succes;
}
