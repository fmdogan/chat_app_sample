import 'package:bloc/bloc.dart';
import 'package:bloc_chat/data/models/theme.dart';
import 'package:bloc_chat/data/repositories/theme_repo.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(ThemeNewState(
          myTheme: MyThemeData(
            appBarColor: Colors.blueAccent,
            backgroundColor: Colors.green,
          ),
        ));

  ThemeRepository repository = ThemeRepository();
  late MyThemeData _myTheme;
  void changeTheme() => {
        _myTheme = repository.getMyTheme(),
        emit(ThemeNewState(
          myTheme: MyThemeData(
            appBarColor: _myTheme.appBarColor,
            backgroundColor: _myTheme.backgroundColor,
          ),
        ))
      };
}
