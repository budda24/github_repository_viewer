import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository_search/core/widgets/loading_indicator.dart';
import 'package:repository_search/repository_search/presentation/manager/search/search_cubit.dart';
import 'package:repository_search/repository_search/presentation/manager/search/search_state.dart';
import 'package:repository_search/repository_search/presentation/pages/empty_repo_page.dart';
import 'package:repository_search/repository_search/presentation/widgets/failure_repo_tile.dart';
import 'package:repository_search/repository_search/presentation/widgets/loading_repo_tile.dart';
import 'package:repository_search/repository_search/presentation/widgets/repo_tile.dart';

class RepositoryListView extends StatefulWidget {
  final void Function(BuildContext context) getNextPage;
  final SearchCubit? searchCubit;

  const RepositoryListView({
    required this.getNextPage,
    super.key,
    this.searchCubit,
  });

  @override
  State<RepositoryListView> createState() => _RepositoryListViewState();
}

class _RepositoryListViewState extends State<RepositoryListView> {
  bool canLoadNextPage = false;
  bool hasAlreadyShowNoConnectionToast = false;

  Widget _body = const EmptyRepoPage(
    message: 'Nothing found yet',
  );

  @override
  Widget build(
    BuildContext context,
  ) {
    final cubit = widget.searchCubit;
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final metrics = notification.metrics;

        final limit = metrics.maxScrollExtent - metrics.viewportDimension / 3;

        if (canLoadNextPage && metrics.pixels >= limit) {
          canLoadNextPage = false;

          widget.getNextPage(context);
        }

        return false;
      },
      child: BlocListener<SearchCubit, SearchState>(
        bloc: cubit,
        listener: (context, state) {
          state.map(
            initial: (_) {
              canLoadNextPage = false;
              return const EmptyRepoPage(
                message: 'Nothing found yet',
              );
            },
            loadFailure: (state) => canLoadNextPage = false,
            loadingInProgress: (state) {
              canLoadNextPage = false;
              setState(() {
                _body = const CustomLoadingIndicator();
              });
            },
            loadSuccess: (state) {
              state.repos.entity.isEmpty
                  ? setState(() {
                      canLoadNextPage = false;
                      _body = const EmptyRepoPage(
                        message: 'Nothing found yet',
                      );
                    })
                  : setState(() {
                      canLoadNextPage = state.repos.isNextPageAvailable ?? false;
                      _body = _PaginatedListView(
                        state: state,
                      );
                    });
            },
          );
        },
        child: _body,
      ),
    );
  }
}

class _PaginatedListView extends StatelessWidget {
  final SearchState state;

  const _PaginatedListView({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: state.map(
        initial: (_) => 0,
        loadingInProgress: (_) => _.repos.entity.length + _.itemsPerPage,
        loadSuccess: (_) {
          if (_.isNextPageAvailable) {
            return _.repos.entity.length + 5;
          } else {
            return _.repos.entity.length;
          }
        },
        loadFailure: (_) => _.repos.entity.length + 1,
      ),
      itemBuilder: (context, index) => state.map(
        initial: (_) => const SizedBox.shrink(),
        loadingInProgress: (_) {
          if (index < _.repos.entity.length) {
            return RepoTile(repo: _.repos.entity[index]);
          } else {
            return const LoadingRepoTile();
          }
        },
        loadSuccess: (_) {
          if (index < _.repos.entity.length) {
            return RepoTile(repo: _.repos.entity[index]);
          } else {
            return const LoadingRepoTile();
          }
        },
        loadFailure: (_) {
          if (index < _.repos.entity.length) {
            return RepoTile(repo: _.repos.entity[index]);
          } else {
            return FailureRepoTile(
              failures: _.failures,
            );
          }
        },
      ),
    );
  }
}
