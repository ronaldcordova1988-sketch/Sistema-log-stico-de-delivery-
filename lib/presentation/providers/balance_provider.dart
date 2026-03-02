import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Implementar balance_provider
class BalanceProvider extends StateNotifier<AsyncValue<dynamic>> {
  BalanceProvider() : super(const AsyncValue.loading());
  
  // Implementar lógica del provider aquí
}

final balanceProviderProvider = StateNotifierProvider<BalanceProvider, AsyncValue<dynamic>>((ref) {
  return BalanceProvider();
});
