import 'package:flutter/material.dart';

void showMessage(BuildContext context, String message) {
  if (message.contains('network_error')) {
    message = 'Please make sure that you have internet connection.';
  }
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
