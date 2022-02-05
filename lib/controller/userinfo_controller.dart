import 'package:chat_app/all_packages.dart';
import 'package:chat_app/service/pushnotification.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInfoController extends GetxController {
  var loginUser = FirebaseAuth.instance.currentUser;

  final auth = FirebaseAuth.instance;

  getCurrentUser() {
    final user = auth.currentUser;
    if(user != null) {
      loginUser = user;
    }
  }

  @override
  void onInit() {
    getCurrentUser();
    super.onInit();
  }

}