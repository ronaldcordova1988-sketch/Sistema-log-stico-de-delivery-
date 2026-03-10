import '../../data/models/user_model.dart';
import '../entities/servicio_entity.dart';

abstract class LogisticaRepository {
  Future<List<ServicioEntity>> obtenerServiciosPendientes();
  Future<List<ServicioEntity>> obtenerTodosLosServicios();
  Future<List<ServicioEntity>> obtenerServiciosPorEmpleado(String id);
  Future<void> registrarServicio(ServicioEntity servicio);
  Future<void> liquidarServicio(String id);
  Future<UserModel?> obtenerDatosPerfil(String uid);
}