import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Implementar auth_provider
class AuthProvider extends StateNotifier<AsyncValue<dynamic>> {
  AuthProvider() : super(const AsyncValue.loading());
  
  // Implementar lógica del provider aquí
}

final authProviderProvider = StateNotifierProvider<AuthProvider, AsyncValue<dynamic>>((ref) {
  return AuthProvider();
});
