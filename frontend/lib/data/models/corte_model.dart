import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de Corte - SISTEMA INMUTABLE
class CorteModel {
  final String id;
  final DateTime fechaCorte;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final double totalIngresos;
  final double totalGastos;
  final double balanceGlobal;
  final List<String> empleadosIds;
  final Map<String, ResumenEmpleado> resumenPorEmpleado;
  final String? pdfUrl;
  final String? excelUrl;

  CorteModel({
    required this.id,
    required this.fechaCorte,
    required this.fechaInicio,
    required this.fechaFin,
    required this.totalIngresos,
    required this.totalGastos,
    required this.balanceGlobal,
    required this.empleadosIds,
    required this.resumenPorEmpleado,
    this.pdfUrl,
    this.excelUrl,
  });

  factory CorteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    final resumenMap = <String, ResumenEmpleado>{};
    if (data['resumenPorEmpleado'] != null) {
      (data['resumenPorEmpleado'] as Map<String, dynamic>).forEach((key, value) {
        resumenMap[key] = ResumenEmpleado.fromMap(value as Map<String, dynamic>);
      });
    }

    return CorteModel(
      id: doc.id,
      fechaCorte: (data['fechaCorte'] as Timestamp).toDate(),
      fechaInicio: (data['fechaInicio'] as Timestamp).toDate(),
      fechaFin: (data['fechaFin'] as Timestamp).toDate(),
      totalIngresos: (data['totalIngresos'] as num).toDouble(),
      totalGastos: (data['totalGastos'] as num).toDouble(),
      balanceGlobal: (data['balanceGlobal'] as num).toDouble(),
      empleadosIds: List<String>.from(data['empleadosIds'] ?? []),
      resumenPorEmpleado: resumenMap,
      pdfUrl: data['pdfUrl'],
      excelUrl: data['excelUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    final resumenMap = <String, dynamic>{};
    resumenPorEmpleado.forEach((key, value) {
      resumenMap[key] = value.toMap();
    });

    return {
      'fechaCorte': Timestamp.fromDate(fechaCorte),
      'fechaInicio': Timestamp.fromDate(fechaInicio),
      'fechaFin': Timestamp.fromDate(fechaFin),
      'totalIngresos': totalIngresos,
      'totalGastos': totalGastos,
      'balanceGlobal': balanceGlobal,
      'empleadosIds': empleadosIds,
      'resumenPorEmpleado': resumenMap,
      'pdfUrl': pdfUrl,
      'excelUrl': excelUrl,
    };
  }

  int get cantidadEmpleados => empleadosIds.length;
  Duration get duracionPeriodo => fechaFin.difference(fechaInicio);
  bool get tieneReportes => pdfUrl != null || excelUrl != null;
}

/// Resumen de un empleado en un corte
class ResumenEmpleado {
  final String empleadoId;
  final String nombreEmpleado;
  final double totalIngresos;
  final double totalGastosCombustible;
  final double totalMantenimiento;
  final double totalGastosVarios;
  final double totalGastos;
  final double balanceNeto;
  final int cantidadCarreras;
  final int cantidadGastos;

  ResumenEmpleado({
    required this.empleadoId,
    required this.nombreEmpleado,
    required this.totalIngresos,
    required this.totalGastosCombustible,
    required this.totalMantenimiento,
    required this.totalGastosVarios,
    required this.totalGastos,
    required this.balanceNeto,
    required this.cantidadCarreras,
    required this.cantidadGastos,
  });

  factory ResumenEmpleado.fromMap(Map<String, dynamic> map) {
    return ResumenEmpleado(
      empleadoId: map['empleadoId'],
      nombreEmpleado: map['nombreEmpleado'],
      totalIngresos: (map['totalIngresos'] as num).toDouble(),
      totalGastosCombustible: (map['totalGastosCombustible'] as num).toDouble(),
      totalMantenimiento: (map['totalMantenimiento'] as num).toDouble(),
      totalGastosVarios: (map['totalGastosVarios'] as num).toDouble(),
      totalGastos: (map['totalGastos'] as num).toDouble(),
      balanceNeto: (map['balanceNeto'] as num).toDouble(),
      cantidadCarreras: map['cantidadCarreras'],
      cantidadGastos: map['cantidadGastos'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'empleadoId': empleadoId,
      'nombreEmpleado': nombreEmpleado,
      'totalIngresos': totalIngresos,
      'totalGastosCombustible': totalGastosCombustible,
      'totalMantenimiento': totalMantenimiento,
      'totalGastosVarios': totalGastosVarios,
      'totalGastos': totalGastos,
      'balanceNeto': balanceNeto,
      'cantidadCarreras': cantidadCarreras,
      'cantidadGastos': cantidadGastos,
    };
  }

  double get promedioIngresoPorCarrera => 
      cantidadCarreras > 0 ? totalIngresos / cantidadCarreras : 0;
  
  double get promedioGastoPorRegistro => 
      cantidadGastos > 0 ? totalGastos / cantidadGastos : 0;
  
  double get porcentajeGastos => 
      totalIngresos > 0 ? (totalGastos / totalIngresos) * 100 : 0;
}
