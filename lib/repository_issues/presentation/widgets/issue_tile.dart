import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repository_search/repository_issues/domain/entities/issue.dart';

class IssueTile extends StatelessWidget {
  final Issue issue;

  const IssueTile(this.issue);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedNetworkImage(
        height: 30.h,
        width: 30.w,
        imageUrl: issue.user.toDomain().avatarUrlSmall,
      ),
      title: Text(issue.body.isEmpty ? 'no description' : issue.body),
      trailing: const Icon(Icons.request_page),
    );
  }
}
