import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

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
    return Container();
  }
}
