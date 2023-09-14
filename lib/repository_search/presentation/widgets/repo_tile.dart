import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
      //TODO go to details screen
      onTap: () {},
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
