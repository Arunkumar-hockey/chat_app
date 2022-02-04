import 'package:chat_app/all_packages.dart';
import 'package:chat_app/constants/color_constants.dart';
import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/controller/userinfo_controller.dart';
import 'package:chat_app/service/apiservice.dart';
import 'package:chat_app/view/login_screen.dart';

import '../main.dart';

class HomeScreen extends GetView<UserInfoController> {
  HomeScreen({Key? key}) : super(key: key);

  //final controller = Get.put(AuthController());
  final controller = Get.put(UserInfoController());
  final msg = TextEditingController();
  // final storeMessage = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Chat Screen'),
          backgroundColor: const Color(PRIMARY_COLOUR),
          actions: [
            TextButton(
                onPressed: () {
                  //controller.signOut();
                  Get.offAll(LoginScreen());
                },
                child: Text("Sign Out"))
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildMessage(),
            Row(
              children: [
                Expanded(
                    child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.black, width: 0.5))),
                  child: TextField(
                    controller: msg,
                    decoration:
                        const InputDecoration(hintText: "Enter Message..."),
                  ),
                )),
                IconButton(
                    onPressed: () {
                      if (msg.text.isNotEmpty) {
                        APIService().sendNotification(msg.text);
                        storeMessage.collection("Messages").doc().set({
                          "messages": msg.text.trim(),
                          "user": controller.loginUser?.email.toString(),
                          "time": DateTime.now()
                        });
                        msg.clear();
                      }
                    },
                    icon: Icon(Icons.send))
              ],
            ),
          ],
        ));
  }

  buildMessage() {
    return Expanded(
      child: Container(
       // height: 700,
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          reverse: true,
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Messages")
                  .orderBy("time")
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
                        return ListTile(
                          title: Column(
                            crossAxisAlignment: controller.loginUser?.email ==x['user'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color:  controller.loginUser?.email ==x['user'] ? Colors.blue.withOpacity(0.2) : Colors.amber.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(15 )
                                ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(x['messages']),
                                      SizedBox(height: 5),
                                      Text(x['user'], style: TextStyle(fontSize: 10, color: Colors.green),)
                                    ],
                                  )),
                            ],
                          ),
                        );
                      });
                }
              }),
        ),
      ),
    );
  }
}
