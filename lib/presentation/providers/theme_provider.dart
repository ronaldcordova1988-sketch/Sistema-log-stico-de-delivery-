import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Proveedor de Estado para el Tema de la Aplicación
/// 
/// Utiliza [StateNotifier] para gestionar si el modo oscuro está activo.
/// Los cambios se persisten localmente usando Hive.
class ThemeNotifier extends StateNotifier<AsyncValue<bool>> {
  ThemeNotifier() : super(const AsyncValue.loading()) {
    _loadTheme();
  }

  /// Carga la preferencia guardada desde el almacenamiento local
  Future<void> _loadTheme() async {
    try {
      final box = await Hive.openBox('settings');
      // Por defecto, usamos el modo oscuro (Dark Mode) para eficiencia en 64-bit
      final isDark = box.get('isDarkMode', defaultValue: true);
      state = AsyncValue.data(isDark);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Alterna entre modo claro y oscuro y guarda la elección
  Future<void> toggleTheme() async {
    final currentState = state.value ?? true;
    state = AsyncValue.data(!currentState);
    
    final box = Hive.box('settings');
    await box.put('isDarkMode', !currentState);
  }
}

/// Provider global que será escuchado por el MaterialApp en main.dart
final themeProvider = StateNotifierProvider<ThemeNotifier, AsyncValue<bool>>((ref) {
  return ThemeNotifier();
});