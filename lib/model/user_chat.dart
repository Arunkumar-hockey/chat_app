import 'package:chat_app/all_packages.dart';
import 'package:chat_app/constants/firestore_constants.dart';

class UserChat {
  String id;
  String email;

  UserChat({
    required this.id,
    required this.email
});

  Map<String, String> toJson() {
    return {
      FirestoreConstants.Email : email
    };
  }

  factory UserChat.fromDocument(DocumentSnapshot doc) {
    String email = "";
    try {
      email = doc.get(FirestoreConstants.Email);
    } catch (e) {}
    return UserChat(
        id: doc.id,
        email: email
    );
  }
}