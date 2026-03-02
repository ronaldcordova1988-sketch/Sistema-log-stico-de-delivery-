import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Implementar reminder_provider
class ReminderProvider extends StateNotifier<AsyncValue<dynamic>> {
  ReminderProvider() : super(const AsyncValue.loading());
  
  // Implementar lógica del provider aquí
}

final reminderProviderProvider = StateNotifierProvider<ReminderProvider, AsyncValue<dynamic>>((ref) {
  return ReminderProvider();
});
