import 'package:bloc_chat/data/models/theme.dart';
import 'package:flutter/material.dart';

class ThemeFuncs {
  Future<MyThemeData> setTheme(Color appBarColor, Color backgroundColor) async {
    late MyThemeData myTheme;
    await Future.delayed(Duration(milliseconds: 1)).whenComplete(() => {
          myTheme = MyThemeData(
              appBarColor: appBarColor, backgroundColor: backgroundColor),
        });
    return myTheme;
  }
}
