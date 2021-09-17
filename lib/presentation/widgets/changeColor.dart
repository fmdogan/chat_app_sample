/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_chat_sample/business_logic/blocs/theme/theme_bloc.dart';
import 'package:bloc_chat_sample/data/models/theme.dart';

// ignore: must_be_immutable
class MyAlertDialog extends StatefulWidget {
  @override
  _MyAlertDialogState createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<MyAlertDialog> {
  var themeBloc = new ThemeBloc();

  @override
  Widget build(BuildContext context) {
    MyTheme _myTheme =
        MyTheme(appBarColor: Colors.blueAccent, backgroundColor: Colors.green);
    int appBarOption = 0;
    int backgroundOption = 0;

    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        content: Container(
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    // choose color for appBar
                    Column(
                      children: [
                        Text('appBar'),
                        IconButton(
                          onPressed: () {
                            _myTheme.appBarColor = Colors.red;
                            setState(() {
                              appBarOption = 1;
                            });
                            print(appBarOption.toString());
                          },
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                              border: Border.all(
                                color: appBarOption == 1
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 5,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _myTheme.appBarColor = Colors.yellow;
                            setState(() {
                              appBarOption = 2;
                            });
                          },
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow,
                              border: Border.all(
                                color: appBarOption == 2
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 5,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _myTheme.appBarColor = Colors.green;

                            setState(() {
                              appBarOption = 3;
                            });
                          },
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                              border: Border.all(
                                color: appBarOption == 3
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // choose color for background
                    Column(
                      children: [
                        Text('Background'),
                        IconButton(
                          onPressed: () {
                            _myTheme.backgroundColor = Colors.red;
                            setState(() {
                              backgroundOption = 1;
                            });
                          },
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                              border: Border.all(
                                color: backgroundOption == 1
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 5,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _myTheme.backgroundColor = Colors.yellow;
                            setState(() {
                              backgroundOption = 2;
                            });
                          },
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow,
                              border: Border.all(
                                color: backgroundOption == 2
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 5,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _myTheme.backgroundColor = Colors.green;
                            setState(() {
                              backgroundOption = 3;
                            });
                          },
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                              border: Border.all(
                                color: backgroundOption == 3
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    setMyTheme = _myTheme;
                    BlocProvider.of<ThemeBloc>(context).add(ChangeThemeEvent(
                        appBarColor: _myTheme.appBarColor,
                        backgroundColor: _myTheme.backgroundColor));
                  },
                  child: Text('Change Theme'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
*/