class UsuarioEntity {
  final String id;
  final String nombre;
  final String email;
  final String rol; // 'admin' o 'empleado'
  final double saldoPendiente;
  final String? vehiculoId;
  final DateTime fechaRegistro;

  UsuarioEntity({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rol,
    this.saldoPendiente = 0.0,
    this.vehiculoId,
    required this.fechaRegistro,
  });

  bool get isAdmin => rol == 'admin';
  bool get tieneDeuda => saldoPendiente > 0;
}