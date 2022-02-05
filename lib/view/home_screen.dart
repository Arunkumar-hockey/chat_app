import 'package:chat_app/all_packages.dart';
import 'package:chat_app/constants/color_constants.dart';
import 'package:chat_app/constants/firestore_constants.dart';
import 'package:chat_app/controller/home_controller.dart';
import 'package:chat_app/view/testscreen.dart';

import 'chat_screen.dart';
import 'login_screen.dart';


class HomeScreen extends GetView<HomeController> {
  HomeScreen({Key? key}) : super(key: key);

  final controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home'),
        backgroundColor: const Color(PRIMARY_COLOUR),
        actions: [
          TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Get.offAll(LoginScreen());
              },
              child: Text("Sign Out", style: TextStyle(fontSize: 20),))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(FirestoreConstants.pathUserCollection)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  primary: true,
                  physics: ScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, i) {
                    QueryDocumentSnapshot x = snapshot.data!.docs[i];
                    return 
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                userToken: x['token'],
                                userEmail: x[FirestoreConstants.Email],
                                peerId: x['id']
                              )));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: ListTile(
                            title: Text(x[FirestoreConstants.Email],style: TextStyle(color: Colors.white, fontSize: 20),),
                          //subtitle: Text(x['token']),
                    ),
                        ),
                      );
                  });
            }
          }),
    );
  }
}
