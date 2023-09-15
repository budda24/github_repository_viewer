import 'package:repository_search/core/models/github_repo_dto.dart';
import 'package:repository_search/repository_search/domain/entities/github_repo.dart';

extension DTOListToDomainList on List<GithubRepoDTO> {
  List<GithubRepo> toDomain() {
    return map((e) => e.toDomain()).toList();
  }
}
