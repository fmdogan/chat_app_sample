import 'package:bloc_chat/business_logic/blocs/network/network_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showConnectivityWarningMessage(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Connection failed"),
          content: Text('Please check your internet connection'),
          actions: [
            TextButton(
              child: Text("Exit"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Try Again"),
              onPressed: () {
                BlocProvider.of<NetworkBloc>(context).add(NetworkListenEvent());
              },
            )
          ],
        );
      });
}
