import '../../domain/entities/servicio_entity.dart';
import '../../domain/repositories/logistica_repository.dart';
import '../datasources/remote_datasource.dart';
import '../models/ingreso_model.dart';

class LogisticaRepositoryImpl implements LogisticaRepository {
  final RemoteDataSource remoteDataSource;

  LogisticaRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> registrarServicio(ServicioEntity servicio) async {
    // Convertimos la Entity en un Model para que el DataSource lo entienda
    final model = IngresoModel(
      id: servicio.id,
      empleadoId: servicio.empleadoId,
      puntoA: servicio.puntoA,
      puntoB: servicio.puntoB,
      monto: servicio.monto,
      tipo: servicio.tipo,
      fecha: servicio.fecha,
      liquidado: servicio.liquidado,
    );
    return await remoteDataSource.registrarIngreso(model);
  }

  @override
  Future<List<ServicioEntity>> obtenerTodosLosServicios() async {
    // Aquí el DataSource nos devolvería la lista de Firestore
    // Por ahora conectamos la firma del método
    return []; 
  }

  @override
  Future<void> liquidarServicio(String servicioId) async {
    // Lógica para marcar como cobrado en la base de datos
    return await remoteDataSource.liquidarServiciosEmpleado(servicioId);
  }

  @override
  Future<List<ServicioEntity>> obtenerServiciosPorEmpleado(String empleadoId) async {
    // Filtrado de servicios para el historial del trabajador
    return [];
  }
}