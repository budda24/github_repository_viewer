import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repository_search/repository_search/domain/entities/user.dart';

part 'github_repo.freezed.dart';

@freezed
class GithubRepo with _$GithubRepo {
  const factory GithubRepo({
    required User owner,
    required String name,
    required int stargazersCount,
    required String description,
  }) = _StarredRepo;
  const GithubRepo._();

  String get fullName => '${owner.name}/$name';

  int get descriptionLength => description.length;
}
