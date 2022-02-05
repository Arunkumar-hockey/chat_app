import 'package:chat_app/all_packages.dart';

class TestScreen extends StatelessWidget {
  final String? userToken;
  const TestScreen({Key? key, required this.userToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Column(
        children: [
          Text(userToken!)
        ],
      ),
    );
  }
}
