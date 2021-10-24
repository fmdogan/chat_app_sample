import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:bloc_chat/data/dataproviders/user_providers.dart';
import 'package:bloc_chat/data/repositories/user_repo.dart';
import 'package:bloc_chat/services/local_notification_service.dart';

String serverToken =
    'AAAAsiQhs4c:APA91bHRwkcaCthXTMfGc5B6HdS_SzGeJw34LNy894-ZUjeLg8V0Qqc93TTxQNYLHPodhjdhh-cdDC-U3w0DGXIjVoSalFTHmvHO0q0GMi_CQnKgr3zzitVgC1nKyOedAC0fEUfpVWoT';

Future<void> backgroundHandler(RemoteMessage message) async {
  print('fcm_services/backgroundHandler: msg: ${message.notification!.title}');
}

class FcmService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  UserRepo _userRepo = UserRepo();

  void initFCM(BuildContext context) {
    getToken();

    /// handles the message when user taps on the notification
    /// and runs the app from the terminated state
    getInitialMessage(context);

    /// when app works on foreground
    onMessage(context);

    /// when app is open on background and if only user taps on the notification
    onMessageOpenedApp(context);
  }

  void getToken() {
    _fcm.getToken().then((token) => {
          print('device token:  $token'),

          // sets user's fcm token
          loggedUser.fcmId = token ?? '',
          _userRepo.insertPushNotificationIDs(user: loggedUser),
        });
  }

  /// this backgroundHandler works without tapping on the notification
  void onBackgroundMessageHandler() {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  }

  /// handles the message when user taps on the notification
  /// and runs the app from the terminated state
  void getInitialMessage(BuildContext context) {
    _fcm.getInitialMessage().then((message) {
      if (message != null) {
        print('fcm_services/getInitialMessage: msg: ${message.notification!.body}');
      }
    });
  }

  /// when app works on foreground
  void onMessage(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) => {
          if (message.notification != null)
            {
              print('fcm_services/onMessage: msg: ${message.notification!.title} ${message.notification!.body}'),
              LocalNotificationService.display(message),
            }
        });
  }

  /// when app is open on background and if only user taps on the notification
  void onMessageOpenedApp(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      /// in case a route key:data pair sent in the data message
      final routeFromMessage = message.data['route'];
      print(routeFromMessage);

      ///
      Navigator.of(context).pushNamed(routeFromMessage);
    });
  }

  /// send notification to the target user
  Future<Map<String, dynamic>> sendMessage({targetToken, title, body, route}) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': body, 'title': title},
          'priority': 'high',
          'data': <String, dynamic>{
            'route': route,
          },
          'to': targetToken,
        },
      ),
    );
    return {};
  }
}
