import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_chat/business_logic/cubits/auth/auth_cubit.dart';

// ignore: must_be_immutable
class GoogleSignInPage extends StatefulWidget {
  //final bool isConnected;

  const GoogleSignInPage({
    Key? key,
    //required this.isConnected,
  }) : super(key: key);

  @override
  _GoogleSignInPageState createState() => _GoogleSignInPageState(/*isConnected: isConnected*/);
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  //final bool isConnected = false;
  //_GoogleSignInPageState({required bool isConnected});

  @override
  Widget build(BuildContext context) {
    //print('signin/ isConnected: $isConnected');
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AuthInitial) {
            return Center(
              child: SizedBox(
                width: size.width * 0.8,
                child: OutlinedButton.icon(
                  icon: Icon(Icons.login),
                  onPressed: () {
                    BlocProvider.of<AuthCubit>(context).signIn(context);
                    //if (isConnected) {
                    //} else {
                    //  showConnectivityWarningMessage(context);
                    //}
                  },
                  label: Text(
                    'Sign In',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                      side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
