import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository_search/authentication/presentation/manager/authentication/authentication_cubit.dart';
import 'package:repository_search/core/routes/app_routes.dart';

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({this.authenticationCubit, super.key});

  @visibleForTesting
  final AuthenticationCubit? authenticationCubit;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.scheduleFrameCallback((timeStamp) async {
      final authCubit = widget.authenticationCubit ?? context.read<AuthenticationCubit>();
      await authCubit.checkAndUpdateAuthStatus();
    });
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.co_present,
                  size: 150,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Welcome to \n Repository Viewer',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 32,
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthenticationCubit>().signIn((authorizationUri) {
                      final completer = Completer<Uri>();
                      context.router.push(
                        AuthorizationRoute(
                          authorizationUrl: authorizationUri,
                          onAuthorizationCodeRedirectAttempt: completer.complete,
                        ),
                      );
                      return completer.future;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
