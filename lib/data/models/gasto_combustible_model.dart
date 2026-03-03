class GastoCombustibleModel {
  final String id;
  final String empleadoId;
  final String vehiculoId;
  final double monto;
  final double kilometraje;
  final DateTime fecha;

  GastoCombustibleModel({
    required this.id,
    required this.empleadoId,
    required this.vehiculoId,
    required this.monto,
    required this.kilometraje,
    required this.fecha,
  });

  factory GastoCombustibleModel.fromJson(Map<String, dynamic> json, String id) {
    return GastoCombustibleModel(
      id: id,
      empleadoId: json['empleadoId'] ?? '',
      vehiculoId: json['vehiculoId'] ?? '',
      monto: (json['monto'] ?? 0.0).toDouble(),
      kilometraje: (json['kilometraje'] ?? 0.0).toDouble(),
      fecha: json['fecha'] != null ? DateTime.parse(json['fecha']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'empleadoId': empleadoId,
      'vehiculoId': vehiculoId,
      'monto': monto,
      'kilometraje': kilometraje,
      'fecha': fecha.toIso8601String(),
    };
  }
}