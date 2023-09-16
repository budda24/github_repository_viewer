import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repository_search/repository_issues/domain/entities/issue.dart';
import 'package:repository_search/repository_issues/presentation/widgets/issue_tile.dart';

class IssueListView extends StatelessWidget {
  final List<Issue> _issues;

  const IssueListView(this._issues);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _issues.length,
      itemBuilder: (context, index) => Column(
        children: [
          IssueTile(_issues[index]),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: Divider(
              height: 2.h,
              color: Colors.deepOrangeAccent,
            ),
          ),
        ],
      ),
    );
  }
}
