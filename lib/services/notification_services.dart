import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class NotificationServices {
  init() async {
    FirebaseMessaging messaging = await FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    getToken();
    // messaging.onTokenRefresh.listen((token) {
    //   if (token != null && FirebaseAuth.instance.currentUser != null)
    //     FirebaseFirestore.instance.collection('tokens').doc(FirebaseAuth.instance.currentUser!.uid).set({'token': token});
    // });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        print("Got Notification");
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      print("Got Another Notification");

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  //homepage init
  getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null && FirebaseAuth.instance.currentUser != null)
      FirebaseFirestore.instance.collection('tokens').doc(FirebaseAuth.instance.currentUser!.uid).set({'token': token});
  }

  void sendPushNotification(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization":
              "key=AAAAt-h8pEQ:APA91bGYiQIKcPNHvcJ5X7S8ZRdFLKjJssQTtlptbUuKb0rPTmfqpsHKknt5lo4cWpetFnbVSJap1RSekJ8ecD3efnIGxudZtag4w2l1la1FI0R2CYDLAn_hESYU-WVLzI9D5ZnGqGou",
        },
        body: jsonEncode(
          <String, dynamic>{
            'priority': "high",
            "data": <String, dynamic>{
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "id": '1',
              "status": "done",
            },
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              // "android_channel_id": "abc",
            },
            "to": token
          },
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
