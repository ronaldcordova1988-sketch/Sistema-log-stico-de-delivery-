import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

/// Provider para gestionar el tema de la aplicación
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.dark) {
    _loadThemeMode();
  }

  /// Cargar tema guardado
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(AppConstants.keyThemeMode);
    
    if (savedTheme != null) {
      state = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedTheme,
        orElse: () => ThemeMode.dark,
      );
    }
  }

  /// Cambiar a modo oscuro
  Future<void> setDarkMode() async {
    state = ThemeMode.dark;
    await _saveThemeMode();
  }

  /// Cambiar a modo claro
  Future<void> setLightMode() async {
    state = ThemeMode.light;
    await _saveThemeMode();
  }

  /// Cambiar a modo sistema
  Future<void> setSystemMode() async {
    state = ThemeMode.system;
    await _saveThemeMode();
  }

  /// Toggle entre claro y oscuro
  Future<void> toggleTheme() async {
    if (state == ThemeMode.dark) {
      await setLightMode();
    } else {
      await setDarkMode();
    }
  }

  /// Guardar tema en SharedPreferences
  Future<void> _saveThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyThemeMode, state.toString());
  }

  /// Verificar si está en modo oscuro
  bool get isDarkMode => state == ThemeMode.dark;

  /// Verificar si está en modo claro
  bool get isLightMode => state == ThemeMode.light;

  /// Verificar si está en modo sistema
  bool get isSystemMode => state == ThemeMode.system;
}

/// Provider global del tema
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

/// Provider para saber si está en modo oscuro
final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  return themeMode == ThemeMode.dark;
});
