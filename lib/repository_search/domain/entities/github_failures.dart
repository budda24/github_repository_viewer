import 'package:freezed_annotation/freezed_annotation.dart';

part 'github_failures.freezed.dart';

@freezed
class GithubFailures with _$GithubFailures {
  const GithubFailures._();
  const factory GithubFailures.api(int? errorCode) = _Api;
}
