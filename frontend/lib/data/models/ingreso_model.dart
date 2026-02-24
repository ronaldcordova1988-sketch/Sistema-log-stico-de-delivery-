import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

enum TipoIngreso { carrera, delivery, transporte }

/// Modelo de Ingreso (Carreras) - SIN GPS
class IngresoModel {
  final String id;
  final String uuid;
  final String empleadoId;
  final String puntoA;
  final String puntoB;
  final double monto;
  final TipoIngreso tipo;
  final DateTime timestamp;
  final bool liquidado;
  final String? corteId;
  final bool syncedToServer;

  IngresoModel({
    required this.id,
    required this.uuid,
    required this.empleadoId,
    required this.puntoA,
    required this.puntoB,
    required this.monto,
    required this.tipo,
    required this.timestamp,
    this.liquidado = false,
    this.corteId,
    this.syncedToServer = false,
  });

  factory IngresoModel.create({
    required String empleadoId,
    required String puntoA,
    required String puntoB,
    required double monto,
    required TipoIngreso tipo,
  }) {
    return IngresoModel(
      id: '',
      uuid: const Uuid().v4(),
      empleadoId: empleadoId,
      puntoA: puntoA,
      puntoB: puntoB,
      monto: monto,
      tipo: tipo,
      timestamp: DateTime.now(),
      liquidado: false,
      syncedToServer: false,
    );
  }

  factory IngresoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return IngresoModel(
      id: doc.id,
      uuid: data['uuid'],
      empleadoId: data['empleadoId'],
      puntoA: data['puntoA'],
      puntoB: data['puntoB'],
      monto: (data['monto'] as num).toDouble(),
      tipo: TipoIngreso.values.firstWhere(
        (e) => e.toString() == 'TipoIngreso.${data['tipo']}',
      ),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      liquidado: data['liquidado'] ?? false,
      corteId: data['corteId'],
      syncedToServer: true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uuid': uuid,
      'empleadoId': empleadoId,
      'puntoA': puntoA,
      'puntoB': puntoB,
      'monto': monto,
      'tipo': tipo.toString().split('.').last,
      'timestamp': Timestamp.fromDate(timestamp),
      'liquidado': liquidado,
      'corteId': corteId,
    };
  }

  Map<String, dynamic> toHive() {
    return {
      'id': id,
      'uuid': uuid,
      'empleadoId': empleadoId,
      'puntoA': puntoA,
      'puntoB': puntoB,
      'monto': monto,
      'tipo': tipo.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'liquidado': liquidado,
      'corteId': corteId,
      'syncedToServer': syncedToServer,
    };
  }

  factory IngresoModel.fromHive(Map<String, dynamic> data) {
    return IngresoModel(
      id: data['id'] ?? '',
      uuid: data['uuid'],
      empleadoId: data['empleadoId'],
      puntoA: data['puntoA'],
      puntoB: data['puntoB'],
      monto: (data['monto'] as num).toDouble(),
      tipo: TipoIngreso.values.firstWhere(
        (e) => e.toString() == 'TipoIngreso.${data['tipo']}',
      ),
      timestamp: DateTime.parse(data['timestamp']),
      liquidado: data['liquidado'] ?? false,
      corteId: data['corteId'],
      syncedToServer: data['syncedToServer'] ?? false,
    );
  }

  IngresoModel copyWith({
    String? id,
    bool? liquidado,
    String? corteId,
    bool? syncedToServer,
  }) {
    return IngresoModel(
      id: id ?? this.id,
      uuid: uuid,
      empleadoId: empleadoId,
      puntoA: puntoA,
      puntoB: puntoB,
      monto: monto,
      tipo: tipo,
      timestamp: timestamp,
      liquidado: liquidado ?? this.liquidado,
      corteId: corteId ?? this.corteId,
      syncedToServer: syncedToServer ?? this.syncedToServer,
    );
  }

  bool get puedeEditar => !liquidado;
  bool get necesitaSync => !syncedToServer;
  
  String get tipoTexto {
    switch (tipo) {
      case TipoIngreso.carrera:
        return 'Carrera';
      case TipoIngreso.delivery:
        return 'Delivery';
      case TipoIngreso.transporte:
        return 'Transporte';
    }
  }
}
