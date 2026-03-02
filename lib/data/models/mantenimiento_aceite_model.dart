import 'package:cloud_firestore/cloud_firestore.dart';

class MantenimientoAceiteModel {
  final String id;
  final String empleadoId;
  final DateTime fecha;
  final double precio;
  final double kmActual;
  final double kmProximoCambio;
  final bool liquidado;
  final String? corteId;

  MantenimientoAceiteModel({
    required this.id,
    required this.empleadoId,
    required this.fecha,
    required this.precio,
    required this.kmActual,
    required this.kmProximoCambio,
    this.liquidado = false,
    this.corteId,
  });

  factory MantenimientoAceiteModel.create({
    required String empleadoId,
    required double precio,
    required double kmActual,
  }) {
    return MantenimientoAceiteModel(
      id: '',
      empleadoId: empleadoId,
      fecha: DateTime.now(),
      precio: precio,
      kmActual: kmActual,
      kmProximoCambio: kmActual + 5000, // Cada 5000 km
      liquidado: false,
    );
  }

  factory MantenimientoAceiteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MantenimientoAceiteModel(
      id: doc.id,
      empleadoId: data['empleadoId'],
      fecha: (data['fecha'] as Timestamp).toDate(),
      precio: (data['precio'] as num).toDouble(),
      kmActual: (data['kmActual'] as num).toDouble(),
      kmProximoCambio: (data['kmProximoCambio'] as num).toDouble(),
      liquidado: data['liquidado'] ?? false,
      corteId: data['corteId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'empleadoId': empleadoId,
      'fecha': Timestamp.fromDate(fecha),
      'precio': precio,
      'kmActual': kmActual,
      'kmProximoCambio': kmProximoCambio,
      'liquidado': liquidado,
      'corteId': corteId,
    };
  }

  bool debeAlertarProximoCambio(double kmActualVehiculo) {
    return kmProximoCambio - kmActualVehiculo <= 200;
  }
}
