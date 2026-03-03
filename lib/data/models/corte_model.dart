class CorteModel {
  final String id;
  final String empleadoId;
  final double montoTotal;
  final double montoEntregado;
  final double diferencia;
  final DateTime fecha;

  CorteModel({
    required this.id,
    required this.empleadoId,
    required this.montoTotal,
    required this.montoEntregado,
    required this.diferencia,
    required this.fecha,
  });

  factory CorteModel.fromJson(Map<String, dynamic> json, String id) {
    return CorteModel(
      id: id,
      empleadoId: json['empleadoId'] ?? '',
      montoTotal: (json['montoTotal'] ?? 0.0).toDouble(),
      montoEntregado: (json['montoEntregado'] ?? 0.0).toDouble(),
      diferencia: (json['diferencia'] ?? 0.0).toDouble(),
      fecha: json['fecha'] != null ? DateTime.parse(json['fecha']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'empleadoId': empleadoId,
      'montoTotal': montoTotal,
      'montoEntregado': montoEntregado,
      'diferencia': diferencia,
      'fecha': fecha.toIso8601String(),
    };
  }
}