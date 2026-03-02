import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Implementar admin_provider
class AdminProvider extends StateNotifier<AsyncValue<dynamic>> {
  AdminProvider() : super(const AsyncValue.loading());
  
  // Implementar lógica del provider aquí
}

final adminProviderProvider = StateNotifierProvider<AdminProvider, AsyncValue<dynamic>>((ref) {
  return AdminProvider();
});
