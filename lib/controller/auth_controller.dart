import 'package:chat_app/all_packages.dart';
import 'package:chat_app/constants/firestore_constants.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/user_chat.dart';
import 'package:chat_app/view/chat_screen.dart';
import 'package:chat_app/view/home_screen.dart';
import 'package:chat_app/view/login_screen.dart';

class AuthController extends GetxController {

  final auth = FirebaseAuth.instance;
  final box = GetStorage();

  void createUser(String email, String password) async{
    Get.defaultDialog(
      content: Row(
        children: const <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
          SizedBox(width: 15),
          Text('Registering, Please wait')
        ],
      ),
      contentPadding: const EdgeInsets.all(10),
      title: '',
    );
    try{
      var credentials = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credentials.user != null) {

        Get.to(LoginScreen());

        Fluttertoast.showToast(
            msg: "Account Created",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1);
        print('created successfully.......');
      } else {
        print('Failed........');
      }
    } catch(e) {
      print(e.toString());
      throw e.toString();
    }
  }

  void loginUser(String email, String password) async{
    Get.defaultDialog(
      content: Row(
        children: const <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
          SizedBox(width: 15),
          Text('Authenticating, Please wait')
        ],
      ),
      contentPadding: const EdgeInsets.all(10),
      title: '',
    );
    try{
      var firebaseUser =await auth.signInWithEmailAndPassword(email: email, password: password).catchError((errMsg) {
        Get.back();
        Fluttertoast.showToast(
            msg: "Error:" + errMsg.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1);
      });
      if(firebaseUser.user != null) {
        final QuerySnapshot result = await firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .where(FirestoreConstants.id, isEqualTo: firebaseUser.user?.uid)
        .get();

        final List<DocumentSnapshot> document = result.docs;
        if(document.length == 0) {
          firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(firebaseUser.user?.uid).set({
            FirestoreConstants.id : firebaseUser.user?.uid,
            FirestoreConstants.Email : firebaseUser.user?.email,
            "fcmToken" : null,
            'createdAt': DateTime.now().toString(),
            FirestoreConstants.chattingWith : null
          });

          var currentUser = firebaseUser;
          box.write(FirestoreConstants.id, currentUser.user?.uid);
          box.write(FirestoreConstants.Email, currentUser.user?.email);
        } else {
          DocumentSnapshot documentSnapshot = document[0];
          UserChat userChat = UserChat.fromDocument(documentSnapshot);

          box.write(FirestoreConstants.id, userChat.id);
          box.write(FirestoreConstants.Email, userChat.email);
        }

        print('Login Success....');
        Get.to(HomeScreen());

      } else {
        Fluttertoast.showToast(
            msg: "Error Occured",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1);
        print('Login Failed');
      }
    } catch(e) {

    }
  }

  void signOut() async{
    Get.defaultDialog(
      content: Row(
        children: const <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
          SizedBox(width: 15),
          Text('Signing Off, Please wait')
        ],
      ),
      contentPadding: const EdgeInsets.all(10),
      title: '',
    );
    try {
      await auth.signOut();
      Get.offAll(LoginScreen());
      Fluttertoast.showToast(
          msg: "Logged Out",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1);
    } catch (e) {
      print(e.toString());
      throw e.toString();
    }

  }


}