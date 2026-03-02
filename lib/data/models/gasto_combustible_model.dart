import 'package:cloud_firestore/cloud_firestore.dart';

class GastoCombustibleModel {
  final String id;
  final String empleadoId;
  final DateTime fecha;
  final double monto;
  final double kilometraje;
  final bool liquidado;
  final String? corteId;
  final bool syncedToServer;

  GastoCombustibleModel({
    required this.id,
    required this.empleadoId,
    required this.fecha,
    required this.monto,
    required this.kilometraje,
    this.liquidado = false,
    this.corteId,
    this.syncedToServer = false,
  });

  factory GastoCombustibleModel.create({
    required String empleadoId,
    required double monto,
    required double kilometraje,
  }) {
    return GastoCombustibleModel(
      id: '',
      empleadoId: empleadoId,
      fecha: DateTime.now(),
      monto: monto,
      kilometraje: kilometraje,
      liquidado: false,
      syncedToServer: false,
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
    };
  }

  bool get puedeEditar => !liquidado;
}
