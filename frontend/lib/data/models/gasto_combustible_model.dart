import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de Gasto de Combustible - SIN FOTO
class GastoCombustibleModel {
  final String id;
  final String empleadoId;
  final DateTime fecha;
  final double monto;
  final double kilometraje;
  final bool liquidado;
  final String? corteId;
  final bool syncedToServer;
  final String? notas;

  GastoCombustibleModel({
    required this.id,
    required this.empleadoId,
    required this.fecha,
    required this.monto,
    required this.kilometraje,
    this.liquidado = false,
    this.corteId,
    this.syncedToServer = false,
    this.notas,
  });

  factory GastoCombustibleModel.create({
    required String empleadoId,
    required double monto,
    required double kilometraje,
    String? notas,
  }) {
    return GastoCombustibleModel(
      id: '',
      empleadoId: empleadoId,
      fecha: DateTime.now(),
      monto: monto,
      kilometraje: kilometraje,
      liquidado: false,
      syncedToServer: false,
      notas: notas,
    );
  }

  factory GastoCombustibleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GastoCombustibleModel(
      id: doc.id,
      empleadoId: data['empleadoId'],
      fecha: (data['fecha'] as Timestamp).toDate(),
      monto: (data['monto'] as num).toDouble(),
      kilometraje: (data['kilometraje'] as num).toDouble(),
      liquidado: data['liquidado'] ?? false,
      corteId: data['corteId'],
      syncedToServer: true,
      notas: data['notas'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'empleadoId': empleadoId,
      'fecha': Timestamp.fromDate(fecha),
      'monto': monto,
      'kilometraje': kilometraje,
      'liquidado': liquidado,
      'corteId': corteId,
      'notas': notas,
    };
  }

  Map<String, dynamic> toHive() {
    return {
      'id': id,
      'empleadoId': empleadoId,
      'fecha': fecha.toIso8601String(),
      'monto': monto,
      'kilometraje': kilometraje,
      'liquidado': liquidado,
      'corteId': corteId,
      'syncedToServer': syncedToServer,
      'notas': notas,
    };
  }

  factory GastoCombustibleModel.fromHive(Map<String, dynamic> data) {
    return GastoCombustibleModel(
      id: data['id'] ?? '',
      empleadoId: data['empleadoId'],
      fecha: DateTime.parse(data['fecha']),
      monto: (data['monto'] as num).toDouble(),
      kilometraje: (data['kilometraje'] as num).toDouble(),
      liquidado: data['liquidado'] ?? false,
      corteId: data['corteId'],
      syncedToServer: data['syncedToServer'] ?? false,
      notas: data['notas'],
    );
  }

  GastoCombustibleModel copyWith({
    String? id,
    bool? liquidado,
    String? corteId,
    bool? syncedToServer,
  }) {
    return GastoCombustibleModel(
      id: id ?? this.id,
      empleadoId: empleadoId,
      fecha: fecha,
      monto: monto,
      kilometraje: kilometraje,
      liquidado: liquidado ?? this.liquidado,
      corteId: corteId ?? this.corteId,
      syncedToServer: syncedToServer ?? this.syncedToServer,
      notas: notas,
    );
  }

  bool get puedeEditar => !liquidado;
  bool get necesitaSync => !syncedToServer;
  double get costoXKilometro => kilometraje > 0 ? monto / kilometraje : 0;
}
