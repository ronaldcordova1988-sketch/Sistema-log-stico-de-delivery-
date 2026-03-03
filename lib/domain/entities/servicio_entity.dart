enum TipoServicio { carrera, delivery, encomienda, otro }

class ServicioEntity {
  final String id;
  final String empleadoId;
  final String puntoA;
  final String puntoB;
  final double monto;
  final TipoServicio tipo;
  final DateTime fecha;
  final bool liquidado;

  ServicioEntity({
    required this.id,
    required this.empleadoId,
    required this.puntoA,
    required this.puntoB,
    required this.monto,
    required this.tipo,
    required this.fecha,
    this.liquidado = false,
  });
}