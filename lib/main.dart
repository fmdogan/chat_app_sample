import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'business_logic/blocs/chat/chat_bloc.dart';
import 'business_logic/blocs/network/network_bloc.dart';
import 'business_logic/cubits/allusers/allusers_cubit.dart';
import 'business_logic/cubits/auth/auth_cubit.dart';
import 'business_logic/cubits/theme/theme_cubit.dart';
import 'presentation/widgets/network_warning_dialog.dart';
import 'services/fcm_services.dart';

// ignore: unused_import
import 'presentation/pages/chat_page.dart';
import 'presentation/pages/google_signin.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp()
      .then((value) => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp())))
      .onError((error, stackTrace) {
    print(error);
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('Firebase could not get initialized!'),
        ),
      ),
    ));
  });

  /// this backgroundHandler works without tapping on the notification
  FcmService().onBackgroundMessageHandler();
  //runApp(MaterialApp(
  //  debugShowCheckedModeBanner: false,
  //  home: MyApp(),
  //));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NetworkBloc()..add(NetworkInitialEvent())..add(NetworkListenEvent())),
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => AllUsersCubit()),
        BlocProvider(create: (context) => ChatBloc()),
      ],
      child: BlocConsumer<NetworkBloc, NetworkState>(
        listener: (context, networkState) {
          if (networkState is NetworkChangedState) {
            if (!networkState.isConnected) {
              showConnectivityWarningMessage(context);
            }
          }
        },
        builder: (context, networkState) {
          if (networkState is NetworkInitial) {
            print('on app start: in networkInitial');
            //BlocProvider.of<NetworkBloc>(context).add(NetworkInitialEvent());
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(child: Text('Checking for Network Connectivity...')),
              ),
            );
          } else if (networkState is NetworkChangedState) {
            print('on app start: networkCheckedState: ${networkState.isConnected}');

            return BlocConsumer<ThemeCubit, ThemeState>(
              listener: (context, themeState) {},
              builder: (context, themeState) {
                if (themeState is ThemeNewState) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Bloc Chat Sample',
                    theme: ThemeData(
                      primaryColor: themeState.myTheme.appBarColor,
                      backgroundColor: themeState.myTheme.backgroundColor,
                    ),
                    initialRoute: '/',
                    routes: {
                      '/': (BuildContext context) => GoogleSignInPage(/*isConnected: networkState.isConnected*/),
                      '/home': (BuildContext context) => HomePage(),
                      //'/chat': (BuildContext context) => ChatPage(),
                    },
                  );
                }
                return Text('error');
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
