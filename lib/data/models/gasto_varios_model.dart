import 'package:cloud_firestore/cloud_firestore.dart';

class GastoVariosModel {
  final String id;
  final String empleadoId;
  final DateTime fecha;
  final String descripcion;
  final double monto;
  final bool liquidado;
  final String? corteId;

  GastoVariosModel({
    required this.id,
    required this.empleadoId,
    required this.fecha,
    required this.descripcion,
    required this.monto,
    this.liquidado = false,
    this.corteId,
  });

  factory GastoVariosModel.create({
    required String empleadoId,
    required String descripcion,
    required double monto,
  }) {
    return GastoVariosModel(
      id: '',
      empleadoId: empleadoId,
      fecha: DateTime.now(),
      descripcion: descripcion,
      monto: monto,
      liquidado: false,
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
    };
  }
}
