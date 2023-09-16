// ignore_for_file: require_trailing_commas

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repository_search/core/models/data/github_repo_dto.dart';
import 'package:repository_search/core/widgets/loading_indicator.dart';
import 'package:repository_search/repository_issues/presentation/manager/issues_cubit.dart';
import 'package:repository_search/repository_issues/presentation/manager/issues_state.dart';
import 'package:repository_search/repository_issues/presentation/widgets/issue_list_view.dart';

@RoutePage()
class IssuesScreen extends StatefulWidget {
  final GithubRepoDTO githubRepoDTO;

  const IssuesScreen({required this.githubRepoDTO});

  @override
  State<IssuesScreen> createState() => _IssuesScreenState();
}

class _IssuesScreenState extends State<IssuesScreen> {
  Widget _body = const CustomLoadingIndicator();

  @override
  void initState() {
    context.read<IssuesCubit>().getIssues(widget.githubRepoDTO);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 30.h),
          height: 0.8.sh,
          child: BlocListener<IssuesCubit, IssuesState>(
            listener: (context, state) => state.map(
              initial: (_) {
                setState(() {
                  _body = const CustomLoadingIndicator();
                });
                return null;
              },
              loading: (_) {
                setState(() {
                  _body = const CustomLoadingIndicator();
                });
                return null;
              },
              error: (text) {
                setState(() {
                  _body = Center(
                    child: Text(
                      text.message,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  );
                });
                return null;
              },
              succes: (success) {
                setState(() {
                  _body = Container(color: Colors.white, height: 0.8.sh, child: IssueListView(success.issues));
                });
                return null;
              },
            ),
            child: _body,
          ),
        ),
      ),
    );
  }
}
