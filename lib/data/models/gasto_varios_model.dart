class GastoVariosModel {
  final String id;
  final String descripcion;
  final double monto;
  final String categoria; // e.g., 'Repuestos', 'Limpieza', 'Otros'
  final DateTime fecha;

  GastoVariosModel({
    required this.id,
    required this.descripcion,
    required this.monto,
    required this.categoria,
    required this.fecha,
  });

  factory GastoVariosModel.fromJson(Map<String, dynamic> json, String id) {
    return GastoVariosModel(
      id: id,
      descripcion: json['descripcion'] ?? '',
      monto: (json['monto'] ?? 0.0).toDouble(),
      categoria: json['categoria'] ?? 'Otros',
      fecha: json['fecha'] != null ? DateTime.parse(json['fecha']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descripcion': descripcion,
      'monto': monto,
      'categoria': categoria,
      'fecha': fecha.toIso8601String(),
    };
  }
}