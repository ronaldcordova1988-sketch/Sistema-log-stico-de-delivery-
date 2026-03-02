import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Implementar charts_provider
class ChartsProvider extends StateNotifier<AsyncValue<dynamic>> {
  ChartsProvider() : super(const AsyncValue.loading());
  
  // Implementar lógica del provider aquí
}

final chartsProviderProvider = StateNotifierProvider<ChartsProvider, AsyncValue<dynamic>>((ref) {
  return ChartsProvider();
});
