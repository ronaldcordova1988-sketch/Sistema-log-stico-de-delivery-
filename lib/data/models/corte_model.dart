import 'package:cloud_firestore/cloud_firestore.dart';

class CorteModel {
  final String id;
  final DateTime fechaCorte;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final double totalIngresos;
  final double totalGastos;
  final double balanceGlobal;
  final List<String> empleadosIds;

  CorteModel({
    required this.id,
    required this.fechaCorte,
    required this.fechaInicio,
    required this.fechaFin,
    required this.totalIngresos,
    required this.totalGastos,
    required this.balanceGlobal,
    required this.empleadosIds,
  });

  factory CorteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CorteModel(
      id: doc.id,
      fechaCorte: (data['fechaCorte'] as Timestamp).toDate(),
      fechaInicio: (data['fechaInicio'] as Timestamp).toDate(),
      fechaFin: (data['fechaFin'] as Timestamp).toDate(),
      totalIngresos: (data['totalIngresos'] as num).toDouble(),
      totalGastos: (data['totalGastos'] as num).toDouble(),
      balanceGlobal: (data['balanceGlobal'] as num).toDouble(),
      empleadosIds: List<String>.from(data['empleadosIds']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fechaCorte': Timestamp.fromDate(fechaCorte),
      'fechaInicio': Timestamp.fromDate(fechaInicio),
      'fechaFin': Timestamp.fromDate(fechaFin),
      'totalIngresos': totalIngresos,
      'totalGastos': totalGastos,
      'balanceGlobal': balanceGlobal,
      'empleadosIds': empleadosIds,
    };
  }
}
