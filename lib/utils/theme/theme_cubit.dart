import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeType {
  mint,
  ocean,
  sunset,
  lavender,
}

class ThemeState {
  final AppThemeType themeType;
  final ThemeMode themeMode;

  const ThemeState({
    required this.themeType,
    required this.themeMode,
  });

  ThemeState copyWith({
    AppThemeType? themeType,
    ThemeMode? themeMode,
  }) {
    return ThemeState(
      themeType: themeType ?? this.themeType,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeTypeKey = 'theme_type';
  static const String _themeModeKey = 'theme_mode';

  ThemeCubit({
    AppThemeType initialThemeType = AppThemeType.mint,
    ThemeMode initialThemeMode = ThemeMode.light,
  }) : super(ThemeState(
          themeType: initialThemeType,
          themeMode: initialThemeMode,
        ));

  static Future<ThemeState> loadThemeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final typeString = prefs.getString(_themeTypeKey) ?? 'mint';
    final modeString = prefs.getString(_themeModeKey) ?? 'light';

    final themeType = AppThemeType.values.firstWhere(
      (e) => e.name == typeString,
      orElse: () => AppThemeType.mint,
    );

    final themeMode = ThemeMode.values.firstWhere(
      (e) => e.name == modeString,
      orElse: () => ThemeMode.light,
    );

    return ThemeState(themeType: themeType, themeMode: themeMode);
  }

  Future<void> changeThemeType(AppThemeType type) async {
    emit(state.copyWith(themeType: type));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeTypeKey, type.name);
  }

  Future<void> changeThemeMode(ThemeMode mode) async {
    emit(state.copyWith(themeMode: mode));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
  }
}
