import 'dart:convert';

import 'package:chat_app/all_packages.dart';
import 'package:chat_app/constants/color_constants.dart';
import 'package:http/http.dart' as http;

class APIService {

  final box = GetStorage();

  sendNotification(String message, String token) async{
    //var destination = Provider.of<AppData>(context,listen: false).dropoffLocation;
    Map<String, String> headerMap = {
      'Content-Type' : 'application/json',
      'Authorization' : serverToken,
    };

    Map notificationMap = {
      'body' : message,
      'title' : 'New Message'
    };

    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      //'ride_request_id': ride_request_id,
    };

    Map sendNotificationMap = {
      "notification": notificationMap,
      "data": dataMap,
      "priority": "high",
      "to": token,
    };

    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    var response = await http.post(
      url,
      headers: headerMap,
      body: jsonEncode(sendNotificationMap),
    );
    print(response.body);
    try{
      if(response.statusCode == 200) {
        print("Notification Success...........");
        print(message);
      }
      else {
        print("Notification failed...........");
        print(message);
      }
    } catch (e) {
      print(e.toString());
    }

    return response;
  }

}