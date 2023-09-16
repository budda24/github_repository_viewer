// ignore_for_file: require_trailing_commas, prefer_const_constructors

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:repository_search/core/routes/app_routes.dart';
import 'package:repository_search/repository_search/domain/entities/github_repo.dart';

class RepoTile extends StatelessWidget {
  final GithubRepo repo;

  const RepoTile({
    required this.repo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // ignore: flutter_style_todos,
      onTap: () {
        context.router.push(DetailRoute(githubRepo: repo));
      },
      title: Text(
        repo.name,
      ),
      subtitle: Text(
        repo.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(repo.owner.avatarUrlSmall),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
