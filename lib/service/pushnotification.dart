import 'package:chat_app/all_packages.dart';

import '../main.dart';

class PushNotificationService {

  final box = GetStorage();

  void initFirebaseCM() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //retrieveRideRequestInfo(getRideRequestId(message), context);
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if(notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            message.notification!.title,
            message.notification!.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id,
                    channel.name,
                    color: Colors.blue,
                    playSound: true,
                    icon: '@mipmap/ic_launcher'
                )
            )
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Message Opened..........");
      //retrieveRideRequestInfo(getRideRequestId(message), context);
    });

  }

  void getToken() async{
    String? token = await FirebaseMessaging.instance.getToken();
    storeMessage.collection("Messages").doc().set({
      "token": token
    });
    box.write('token', token);
    print("Token value====$token");
    // driversRef.child(currentfirebaseUser?.uid??'').child("token").set(token);
    //
    // FirebaseMessaging.instance.subscribeToTopic("alldrivers");
    // FirebaseMessaging.instance.subscribeToTopic("allUsers");
  }

  // String getRideRequestId(message) {
  //   String rideRequestId = "";
  //   if(Platform.isAndroid) {
  //     rideRequestId = message.data['ride_request_id'];
  //   } else {
  //     rideRequestId = message['ride_request_id'];
  //   }
  //   return rideRequestId;
  // }

  // void retrieveRideRequestInfo(String rideRequestId, BuildContext context) {
  //   newRequestRef.child(rideRequestId).once().then((DataSnapshot dataSnapshot) async {
  //     if(dataSnapshot.value != null) {
  //       var duration = await player.setAsset('assets/sound.mp3');
  //       player.play();
  //
  //       double pickUpLocationLat = double.parse(dataSnapshot.value['pickup']['latitude'].toString());
  //       double pickUpLocationLng = double.parse(dataSnapshot.value['pickup']['longitude'].toString());
  //       String pickUpAddress = dataSnapshot.value['pickup_address'].toString();
  //
  //       double dropOffLocationLat = double.parse(dataSnapshot.value['dropoff']['latitude'].toString());
  //       double dropOffLocationLng = double.parse(dataSnapshot.value['dropoff']['longitude'].toString());
  //       String dropOffAddress = dataSnapshot.value['dropoff_address'].toString();
  //       String paymentMethod =  dataSnapshot.value['payment_method'].toString();
  //
  //       String rider_name = dataSnapshot.value["rider_name"];
  //       String rider_phone = dataSnapshot.value["rider_phone"];
  //
  //       RideDetails rideDetails = RideDetails(
  //           pickup_address: pickUpAddress ,
  //           dropoff_address: dropOffAddress,
  //           pickup: LatLng(pickUpLocationLat, pickUpLocationLng),
  //           dropoff: LatLng(dropOffLocationLat, dropOffLocationLng),
  //           ride_request_id: rideRequestId,
  //           payment_method: paymentMethod,
  //           rider_name: rider_name,
  //           rider_phone: rider_phone
  //       );
  //       print("Information ::");
  //       print(rideDetails.pickup_address);
  //       print(rideDetails.dropoff_address);
  //
  //       showDialog(
  //           context: context,
  //           barrierDismissible: false,
  //           builder: (BuildContext context) => NotificationDialog(rideDetails: rideDetails)
  //       );
  //     } else {
  //
  //     }
  //   });
  // }

}

