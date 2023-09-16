import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:repository_search/core/models/data/github_repo_dto.dart';
import 'package:repository_search/core/models/domain/user.dart';

part 'github_repo.freezed.dart';

@freezed
class GithubRepo with _$GithubRepo {
  const factory GithubRepo({
    required User owner,
    required String name,
    required int stargazersCount,
    required String description,
    required String language,
    required String url,
    required int watchersCount,
  }) = _StarredRepo;

  const GithubRepo._();

  GithubRepoDTO toDomain() => GithubRepoDTO(
        owner: owner.toDomain(),
        name: name,
        language: language,
        url: url,
        description: description,
        stargazersCount: stargazersCount,
        watchersCount: watchersCount,
      );

  String get fullName => '${owner.name}/$name';

  int get descriptionLength => description.length;
}
