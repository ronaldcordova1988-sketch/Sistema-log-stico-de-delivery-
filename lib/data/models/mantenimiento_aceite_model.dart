class MantenimientoAceiteModel {
  final String id;
  final String vehiculoId;
  final double kmActual;
  final double kmProximo;
  final DateTime fecha;

  MantenimientoAceiteModel({
    required this.id,
    required this.vehiculoId,
    required this.kmActual,
    required this.kmProximo,
    required this.fecha,
  });

  factory MantenimientoAceiteModel.fromJson(Map<String, dynamic> json, String id) {
    return MantenimientoAceiteModel(
      id: id,
      vehiculoId: json['vehiculoId'] ?? '',
      kmActual: (json['kmActual'] ?? 0.0).toDouble(),
      kmProximo: (json['kmActual'] ?? 0.0).toDouble() + 5000, // Lógica automática
      fecha: json['fecha'] != null ? DateTime.parse(json['fecha']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehiculoId': vehiculoId,
      'kmActual': kmActual,
      'kmProximo': kmProximo,
      'fecha': fecha.toIso8601String(),
    };
  }
}