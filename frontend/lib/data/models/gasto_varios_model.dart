import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de Gastos Varios (Repuestos, Reparaciones, etc.) - SIN FOTO
class GastoVariosModel {
  final String id;
  final String empleadoId;
  final DateTime fecha;
  final String descripcion;
  final double monto;
  final bool liquidado;
  final String? corteId;
  final bool syncedToServer;
  final String? categoria; // 'repuesto', 'reparacion', 'peaje', 'parqueo', 'otro'

  GastoVariosModel({
    required this.id,
    required this.empleadoId,
    required this.fecha,
    required this.descripcion,
    required this.monto,
    this.liquidado = false,
    this.corteId,
    this.syncedToServer = false,
    this.categoria,
  });

  factory GastoVariosModel.create({
    required String empleadoId,
    required String descripcion,
    required double monto,
    String? categoria,
  }) {
    return GastoVariosModel(
      id: '',
      empleadoId: empleadoId,
      fecha: DateTime.now(),
      descripcion: descripcion,
      monto: monto,
      liquidado: false,
      syncedToServer: false,
      categoria: categoria ?? 'otro',
    );
  }

  factory GastoVariosModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GastoVariosModel(
      id: doc.id,
      empleadoId: data['empleadoId'],
      fecha: (data['fecha'] as Timestamp).toDate(),
      descripcion: data['descripcion'],
      monto: (data['monto'] as num).toDouble(),
      liquidado: data['liquidado'] ?? false,
      corteId: data['corteId'],
      syncedToServer: true,
      categoria: data['categoria'] ?? 'otro',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'empleadoId': empleadoId,
      'fecha': Timestamp.fromDate(fecha),
      'descripcion': descripcion,
      'monto': monto,
      'liquidado': liquidado,
      'corteId': corteId,
      'categoria': categoria,
    };
  }

  Map<String, dynamic> toHive() {
    return {
      'id': id,
      'empleadoId': empleadoId,
      'fecha': fecha.toIso8601String(),
      'descripcion': descripcion,
      'monto': monto,
      'liquidado': liquidado,
      'corteId': corteId,
      'syncedToServer': syncedToServer,
      'categoria': categoria,
    };
  }

  factory GastoVariosModel.fromHive(Map<String, dynamic> data) {
    return GastoVariosModel(
      id: data['id'] ?? '',
      empleadoId: data['empleadoId'],
      fecha: DateTime.parse(data['fecha']),
      descripcion: data['descripcion'],
      monto: (data['monto'] as num).toDouble(),
      liquidado: data['liquidado'] ?? false,
      corteId: data['corteId'],
      syncedToServer: data['syncedToServer'] ?? false,
      categoria: data['categoria'],
    );
  }

  GastoVariosModel copyWith({
    String? id,
    bool? liquidado,
    String? corteId,
    bool? syncedToServer,
  }) {
    return GastoVariosModel(
      id: id ?? this.id,
      empleadoId: empleadoId,
      fecha: fecha,
      descripcion: descripcion,
      monto: monto,
      liquidado: liquidado ?? this.liquidado,
      corteId: corteId ?? this.corteId,
      syncedToServer: syncedToServer ?? this.syncedToServer,
      categoria: categoria,
    );
  }

  bool get puedeEditar => !liquidado;
  bool get necesitaSync => !syncedToServer;
  
  String get categoriaTexto {
    switch (categoria) {
      case 'repuesto':
        return 'Repuesto';
      case 'reparacion':
        return 'Reparación';
      case 'peaje':
        return 'Peaje';
      case 'parqueo':
        return 'Parqueo';
      default:
        return 'Otro';
    }
  }
}
