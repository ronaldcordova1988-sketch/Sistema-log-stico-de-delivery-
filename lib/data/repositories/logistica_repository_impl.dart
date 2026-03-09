import 'package:sistema_logistico_delivery/domain/entities/servicio_entity.dart';
import 'package:sistema_logistico_delivery/domain/repositories/logistica_repository.dart';
import 'package:sistema_logistico_delivery/data/datasources/remote_datasource.dart';
import 'package:sistema_logistico_delivery/data/models/ingreso_model.dart';

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
    return await remoteDataSource.obtenerTodosLosIngresos();
  }

  @override
  Future<void> liquidarServicio(String servicioId) async {
    return await remoteDataSource.liquidarIngresoIndividual(servicioId);
  }

  @override
  Future<List<ServicioEntity>> obtenerServiciosPorEmpleado(String empleadoId) async {
    return await remoteDataSource.obtenerIngresosPorEmpleado(empleadoId);
  }
}