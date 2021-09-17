import 'package:bloc_chat/data/dataproviders/user_providers.dart';
import 'package:bloc_chat/data/repositories/user_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pushy_flutter/pushy_flutter.dart';

class PushyService {
  UserRepo _userRepo = UserRepo();
  void initPushy(BuildContext context) {
    listen();
    pushyRegister();
    setNotificationListener();
    setNotificationClickListener(context);
  }

  void listen() {
    // Start the Pushy service
    Pushy.listen();
  }

  Future<String?> pushyRegister() async {
    try {
      // Register the user for push notifications
      String deviceToken = await Pushy.register();

      // Print token to console/logcat
      print('Device token: $deviceToken');
      // sets user's pushy token
      loggedUser.pushyId = deviceToken;
      _userRepo.insertPushNotificationIDs(user: loggedUser);

      return deviceToken;
      // Optionally send the token to your backend server via an HTTP GET request
    } on PlatformException catch (error) {
      print(error);
    }
  }

  void setNotificationClickListener(BuildContext context) {
    // Listen for notification click
    Pushy.setNotificationClickListener((Map<String, dynamic> data) {
      // Print notification payload data
      print('Notification click: $data');

      /// assuming that a route data pair sent in the data message
      final routeFromMessage = data['route'];
      print(routeFromMessage);

      // Extract notification messsage
      String message = data['message'] ?? 'Hello World!';
      print(message);

      Navigator.of(context).pushNamed(routeFromMessage);

      // Clear iOS app badge number
      Pushy.clearBadge();
    });
  }

  void setNotificationListener() {
    // Listen for push notifications received
    Pushy.setNotificationListener(backgroundNotificationListener);
  }
}

// Please place this code in main.dart,
// After the import statements, and outside any Widget class (top-level)
void backgroundNotificationListener(Map<String, dynamic> data) {
  // Print notification payload data
  print('Received notification: $data');

  // Notification title
  String notificationTitle = 'Chat App';

  // Attempt to extract the "message" property from the payload: {"message":"Hello World!"}
  String notificationText = data['message'] ?? 'Hello World!';

  // Android: Displays a system notification
  // iOS: Displays an alert dialog
  Pushy.notify(notificationTitle, notificationText, data);

  // Clear iOS app badge number
  //Pushy.clearBadge();
}
