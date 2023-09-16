import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:repository_search/core/routes/app_routes.dart';
import 'package:repository_search/repository_detail/domain/use_cases/repositorium_url_lunch_usecase.dart';
import 'package:repository_search/repository_search/domain/entities/github_repo.dart';

@RoutePage()
class DetailScreen extends StatefulWidget {
  final GithubRepo githubRepo;

  const DetailScreen({required this.githubRepo});

  @override
  DetailScreenState createState() => DetailScreenState();
}

class DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ColoredBox(
              color: Colors.blueAccent,
              child: Center(
                child: Text(
                  'Repository Name',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            ColoredBox(
              color: Colors.greenAccent,
              child: Center(
                child: Text(
                  widget.githubRepo.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.githubRepo.stargazersCount.toString(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Icon(
                  Icons.star,
                  size: 30.h,
                ),
              ],
            ),
            0.3.sh.verticalSpace,
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.amberAccent),
              ),
              onPressed: () {
                RepositoriumUrlLunchUsecase().call(Uri.parse(widget.githubRepo.url));
              },
              child: Text(
                'go to github page',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            0.030.sh.verticalSpace,
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
              ),
              onPressed: () async {
                await context.router.push(
                  IssuesRoute(githubRepoDTO: widget.githubRepo.toDomain()),
                );
              },
              child: Text(
                'get repository issues',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
