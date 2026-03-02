import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Implementar theme_provider
class ThemeProvider extends StateNotifier<AsyncValue<dynamic>> {
  ThemeProvider() : super(const AsyncValue.loading());
  
  // Implementar lógica del provider aquí
}

final themeProviderProvider = StateNotifierProvider<ThemeProvider, AsyncValue<dynamic>>((ref) {
  return ThemeProvider();
});
