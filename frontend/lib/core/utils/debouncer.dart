import 'dart:async';
import 'package:flutter/foundation.dart';

/// Debouncer para evitar múltiples llamadas rápidas
/// 
/// Uso:
/// ```dart
/// final _debouncer = Debouncer(milliseconds: 500);
/// 
/// void guardarDatos() {
///   _debouncer.run(() {
///     // Esta función solo se ejecutará después de 500ms sin nuevas llamadas
///     repository.guardar(datos);
///   });
/// }
/// ```
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  /// Ejecuta la acción después del delay especificado
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Cancela cualquier acción pendiente
  void cancel() {
    _timer?.cancel();
  }

  /// Limpia recursos
  void dispose() {
    _timer?.cancel();
  }

  /// Verifica si hay una acción pendiente
  bool get isPending => _timer != null && _timer!.isActive;
}
