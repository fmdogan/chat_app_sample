import 'dart:math';

import 'package:flutter/material.dart';

import 'package:bloc_chat/data/models/theme.dart';

class ThemeRepository {
  //final themeService = themeProv.ThemeFuncs();

  MyThemeData getMyTheme() {
    List<Color> appBarColorOptions = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.black,
    ];
    List<Color> backgroundColorOptions = [
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.red,
      Colors.black87,
    ];

    Random random = new Random();
    int randomNumber = random.nextInt(5);

    late MyThemeData _myTheme;
    _myTheme = MyThemeData(
      appBarColor: appBarColorOptions[randomNumber],
      backgroundColor: backgroundColorOptions[randomNumber],
    );
    return _myTheme;
  }
}
