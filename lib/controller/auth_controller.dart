import 'package:chat_app/all_packages.dart';
import 'package:chat_app/view/home_screen.dart';
import 'package:chat_app/view/login_screen.dart';

class AuthController extends GetxController {

  final auth = FirebaseAuth.instance;

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
      var credentials =await auth.signInWithEmailAndPassword(email: email, password: password).catchError((errMsg) {
        Get.back();
        Fluttertoast.showToast(
            msg: "Error:" + errMsg.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1);
      });
      if(credentials.user != null) {
        print('Login Success....');
        Get.to(HomeScreen());
        // userRef.child(credentials.user!.uid).once().then((value) => (DataSnapshot snap) {
        //   if(snap.value != null) {
        //     print('snapshot......');
        //     Get.to(MainScreen());
        //     Fluttertoast.showToast(
        //         msg: "You are logged-in now",
        //         toastLength: Toast.LENGTH_SHORT,
        //         gravity: ToastGravity.BOTTOM,
        //         timeInSecForIosWeb: 1);
        //   } else{
        //     _auth.signOut();
        //     Fluttertoast.showToast(
        //         msg: "No records exists for this user. Please create account now",
        //         toastLength: Toast.LENGTH_SHORT,
        //         gravity: ToastGravity.CENTER,
        //         timeInSecForIosWeb: 1);
        //   }
        // });


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