import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meme_editor_mobile/core/constants/constants.dart';
import 'package:meme_editor_mobile/core/theme/app_theme_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class ThemeEvent {}

class LoadThemeEvent extends ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

// States
abstract class ThemeState {
  final ThemeData themeData;
  final bool isDarkMode;

  const ThemeState({required this.themeData, required this.isDarkMode});
}

class LightThemeState extends ThemeState {
  LightThemeState()
      : super(
          themeData: lightTheme,
          isDarkMode: false,
        );
}

class DarkThemeState extends ThemeState {
  DarkThemeState()
      : super(
          themeData: darkTheme,
          isDarkMode: true,
        );
}

// BLoC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences sharedPreferences;

  ThemeBloc({required this.sharedPreferences}) : super(LightThemeState()) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  void _onLoadTheme(LoadThemeEvent event, Emitter<ThemeState> emit) {
    final isDarkMode = sharedPreferences.getBool(StorageKeys.isDarkMode) ?? false;
    if (isDarkMode) {
      emit(DarkThemeState());
    } else {
      emit(LightThemeState());
    }
  }

  Future<void> _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    final currentState = state;
    final isDarkMode = !currentState.isDarkMode;

    await sharedPreferences.setBool(StorageKeys.isDarkMode, isDarkMode);

    if (isDarkMode) {
      emit(DarkThemeState());
    } else {
      emit(LightThemeState());
    }
  }
}
