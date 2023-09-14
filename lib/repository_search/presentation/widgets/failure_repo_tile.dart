import 'package:flutter/material.dart';
import 'package:repository_search/repository_search/domain/entities/github_failures.dart';

class FailureRepoTile extends StatelessWidget {
  final GithubFailures failures;

  const FailureRepoTile({
    required this.failures,
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return ListTileTheme(
      iconColor: Theme.of(context).colorScheme.onError,
      textColor: Theme.of(context).colorScheme.onError,
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        color: Theme.of(context).colorScheme.error,
        child: ListTile(
          leading: const SizedBox(
            height: double.infinity,
            child: Icon(Icons.error),
          ),
          title: const Text(
            'An error occurred, please retry',
          ),
          subtitle: Text(
            'API returned: ${failures.map(api: (value) => value.errorCode)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: () {
              /*    ref
                  .read(starredRepoNotifierProvider.notifier)
                  .getNextStarredRepoPage(); */

              /*context
                  .findAncestorWidgetOfExactType<PaginatedReposListView>()
                  ?.getNextPage(ref);*/
            },
          ),
        ),
      ),
    );
  }
}
