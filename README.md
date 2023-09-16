# github_repository_viewer
## about
# It's a simple flutter application using GitHub API to search throw public repositories and display their issues.
# It allows you to log in to you're GitHub account to authenticate all the API calls.
# It allows you to display the repository GitHub page in the webView widget.
# It is built using block as state management and implementing Uncle BOB's clean architecture.
# It is tested using mockito, bloc_test, and golden test which covers unit, widget, and integration testing.
# It has a GitHub hooks script to inject hooks in the local repository.
# I have used the feature branch GitHub workflow.

## building flow
1. flutter pub get
2. dart pub run build_runner build --delete-conflicting-outputs
3. open android/IOS emulator
4. flutter run
   
**It was not written using TDD, because it would take much more time**
**it requires more testing but due to the limit of time, I was not able to spend more time on that.**
**I was not focusing much on the design itself.**
