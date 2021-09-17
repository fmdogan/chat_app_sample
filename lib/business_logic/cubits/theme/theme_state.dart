part of 'theme_cubit.dart';

abstract class ThemeState {
  const ThemeState();
}

// ignore: must_be_immutable
class ThemeNewState extends ThemeState {
  MyThemeData myTheme;
  ThemeNewState({
    required this.myTheme,
  });
}
