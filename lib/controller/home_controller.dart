import 'package:chat_app/all_packages.dart';
import 'package:chat_app/service/pushnotification.dart';

class HomeController extends GetxController {

  @override
  void onInit() {
    PushNotificationService().initFirebaseCM();
    PushNotificationService().getToken();
    super.onInit();
  }

}