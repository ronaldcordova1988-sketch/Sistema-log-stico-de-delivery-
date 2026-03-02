import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Implementar sync_provider
class SyncProvider extends StateNotifier<AsyncValue<dynamic>> {
  SyncProvider() : super(const AsyncValue.loading());
  
  // Implementar lógica del provider aquí
}

final syncProviderProvider = StateNotifierProvider<SyncProvider, AsyncValue<dynamic>>((ref) {
  return SyncProvider();
});
