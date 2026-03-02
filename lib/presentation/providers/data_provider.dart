import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Implementar data_provider
class DataProvider extends StateNotifier<AsyncValue<dynamic>> {
  DataProvider() : super(const AsyncValue.loading());
  
  // Implementar lógica del provider aquí
}

final dataProviderProvider = StateNotifierProvider<DataProvider, AsyncValue<dynamic>>((ref) {
  return DataProvider();
});
