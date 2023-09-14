import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repository_search/repository_search/presentation/manager/search/search_cubit.dart';
import 'package:repository_search/repository_search/presentation/widgets/custom_search_bar.dart';
import 'package:repository_search/repository_search/presentation/widgets/paginated_repos_list_view.dart';

@RoutePage()
class SearchedReposScreen extends StatefulWidget {
  final String searchedRepoName;

  const SearchedReposScreen({
    required this.searchedRepoName,
    super.key,
  });

  @override
  State<SearchedReposScreen> createState() => _SearchedReposPageState();
}

class _SearchedReposPageState extends State<SearchedReposScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 0.85.sw,
                  child: CustomSearchBar(
                    context.read<SearchCubit>().searchController,
                    hint: 'Type in searched text',
                  ),
                ),
                InkWell(
                  onTap: () => context.read<SearchCubit>().search(),
                  child: Icon(
                    Icons.search,
                    size: 50.w,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 0.8.sh,
              child: RepositoryListView(
                getNextPage: (context) {
                  context.read<SearchCubit>().getNextPage();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
