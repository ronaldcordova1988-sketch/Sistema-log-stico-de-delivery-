import '../../domain/entities/servicio_entity.dart';

class IngresoModel extends ServicioEntity {
  IngresoModel({
    required super.id,
    required super.empleadoId,
    required super.puntoA,
    required super.puntoB,
    required super.monto,
    required super.tipo,
    required super.fecha,
    super.liquidado,
  });

  factory IngresoModel.fromJson(Map<String, dynamic> json, String id) {
    return IngresoModel(
      id: id,
      empleadoId: json['empleadoId'] ?? '',
      puntoA: json['puntoA'] ?? '',
      puntoB: json['puntoB'] ?? '',
      monto: (json['monto'] ?? 0.0).toDouble(),
      tipo: TipoServicio.values.firstWhere(
        (e) => e.toString() == json['tipo'],
        orElse: () => TipoServicio.otro,
      ),
      fecha: json['fecha'] != null ? DateTime.parse(json['fecha']) : DateTime.now(),
      liquidado: json['liquidado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'empleadoId': empleadoId,
      'puntoA': puntoA,
      'puntoB': puntoB,
      'monto': monto,
      'tipo': tipo.toString(),
      'fecha': fecha.toIso8601String(),
      'liquidado': liquidado,
    };
  }
}