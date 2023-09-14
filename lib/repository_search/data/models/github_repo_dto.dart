// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:repository_search/repository_search/data/models/user_dto.dart';
import 'package:repository_search/repository_search/domain/entities/github_repo.dart';

part 'github_repo_dto.freezed.dart';
part 'github_repo_dto.g.dart';

String _preventNull(Object? json) {
  return (json as String?) ?? '';
}

@freezed
class GithubRepoDTO with _$GithubRepoDTO {
  const factory GithubRepoDTO({
    required UserDTO owner,
    required String name,
    @JsonKey(fromJson: _preventNull) required String description,
    @JsonKey(name: 'stargazers_count') required int stargazersCount,
  }) = _GithubRepoDTO;
  const GithubRepoDTO._();

  factory GithubRepoDTO.fromJson(Map<String, dynamic> json) => _$GithubRepoDTOFromJson(json);

  factory GithubRepoDTO.fromDomain(
    GithubRepo _,
  ) {
    return GithubRepoDTO(
      owner: UserDTO.fromDomain(_.owner),
      name: _.name,
      description: _.description,
      stargazersCount: _.stargazersCount,
    );
  }

  GithubRepo toDomain() {
    return GithubRepo(
      owner: owner.toDomain(),
      name: name,
      stargazersCount: stargazersCount,
      description: description,
    );
  }
}
