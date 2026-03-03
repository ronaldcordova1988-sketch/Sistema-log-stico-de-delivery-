import '../entities/servicio_entity.dart';

abstract class LogisticaRepository {
  Future<void> registrarServicio(ServicioEntity servicio);
  Future<List<ServicioEntity>> obtenerTodosLosServicios();
  Future<void> liquidarServicio(String servicioId);
  Future<List<ServicioEntity>> obtenerServiciosPorEmpleado(String empleadoId);
}