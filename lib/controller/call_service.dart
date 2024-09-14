import 'package:url_launcher/url_launcher.dart';

class CallService {
  Future<void> startCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
