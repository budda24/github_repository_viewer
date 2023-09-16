import 'package:bloc/bloc.dart';
import 'package:repository_search/core/models/data/github_repo_dto.dart';
import 'package:repository_search/repository_issues/domain/repositories/isssue_repository.dart';
import 'package:repository_search/repository_issues/presentation/manager/issues_state.dart';

class IssuesCubit extends Cubit<IssuesState> {
  IssuesCubit(this._issueRepository) : super(const IssuesState.initial());
  final IssueRepository _issueRepository;

  Future<void> getIssues(GithubRepoDTO githubRepoDTO) async {
    emit(const IssuesState.loading());
    final response = await _issueRepository.getIssues(githubRepoDTO);

    response.maybeWhen(
      orElse: () {
        return emit(const IssuesState.initial());
      },
      noConnection: () {
        return emit(const IssuesState.error('no internet'));
      },
      witchNewData: (data, _) {
        return emit(IssuesState.succes(data));
      },
    );
  }
}
