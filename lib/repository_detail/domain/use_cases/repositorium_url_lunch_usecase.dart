import 'package:url_launcher/url_launcher.dart';

class RepositoriumUrlLunchUsecase {
  Future<void> call(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
