import 'dart:io' show Platform;

import 'package:google_api_availability/google_api_availability.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_chat/business_logic/blocs/chat/chat_bloc.dart';
import 'package:bloc_chat/data/models/user.dart';
import 'package:bloc_chat/data/repositories/chat_repo.dart';
import 'package:bloc_chat/presentation/pages/chat_page.dart';
import 'package:bloc_chat/presentation/widgets/homeAppBar.dart';
import 'package:bloc_chat/business_logic/cubits/allusers/allusers_cubit.dart';
import 'package:bloc_chat/services/fcm_services.dart';
import 'package:bloc_chat/services/local_notification_service.dart';
import 'package:bloc_chat/services/pushy_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final ChatRepo _chatRepo = ChatRepo();
  final _fcmService = FcmService();
  final _pushyService = PushyService();
  bool isGmsAvailable = false;

  Future<bool> checkGmsAvailability() async {
    bool value = false;
    GooglePlayServicesAvailability availability =
        await GoogleApiAvailability.instance.checkGooglePlayServicesAvailability();
    print('Google Play Store status: ${availability.toString().split('.').last}\n');
    if (availability.toString().split('.').last == "success") value = true;
    return value;
  }

  void initState() {
    super.initState();

    BlocProvider.of<AllUsersCubit>(context).getAllUsers();

    LocalNotificationService.initialize(context);

    Future.delayed(Duration.zero, () async {
      isGmsAvailable = await checkGmsAvailability();
    }).whenComplete(() {
      if ((Platform.isAndroid & isGmsAvailable) || Platform.isIOS) {
        LocalNotificationService.initialize(context);
        _fcmService.initFCM(context);
      } else {
        print('gsm (in else): ' + isGmsAvailable.toString());

        _pushyService.initPushy(context);
        /*
        /// implementing Pushy
        _pushyService.listen();
        _pushyService.pushyRegister();
        _pushyService.setNotificationListener();
        _pushyService.setNotificationClickListener(context);
        */
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: HomeAppBar(
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
        body: BlocConsumer<AllUsersCubit, AllUsersState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is AllUsersLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is AllUsersReady) {
              return ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    User _targetUser = state.users[index];
                    print('home/userlist : targetuser.id: ${_targetUser.id}');
                    return Container(
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).backgroundColor,
                      ),
                      height: 50,
                      child: InkWell(
                        onTap: () {
                          _chatRepo.getChatData(usersIDs: [loggedUser.id, _targetUser.id]).then(
                            (_chat) {
                              print(
                                'home/userlist click: fetched chat data: ' +
                                    'id: ${_chat.id} : users: ${_chat.users[0]} : ${_chat.users[1]}',
                              );
                              BlocProvider.of<ChatBloc>(context).add(ChatLoadNewEvent());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                          currentChat: _chat,
                                          targetuser: _targetUser,
                                        )),
                              );
                            },
                          );

                          //Navigator.of(context)
                          //    .pushNamed('/chat', arguments: ChatPageArguments(targetUser: _targetUser));
                        },
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Column(
                              children: [
                                Text(_targetUser.name, style: TextStyle(color: Colors.white, fontSize: 20)),
                                Text('Message..', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return Center(
                child: Text('Something went wrong!'),
              );
            }
          },
        ),
      ),
    );
  }
}
