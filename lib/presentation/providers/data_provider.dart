import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote_datasource.dart';
import '../../data/repositories/logistica_repository_impl.dart';
import '../../domain/entities/servicio_entity.dart';
import '../../domain/repositories/logistica_repository.dart';

// 1. Proveedor del DataSource (El motor)
final remoteDataSourceProvider = Provider((ref) => RemoteDataSource());

// 2. Proveedor del Repositorio (El puente)
final logisticaRepositoryProvider = Provider<LogisticaRepository>((ref) {
  final dataSource = ref.watch(remoteDataSourceProvider);
  return LogisticaRepositoryImpl(dataSource);
});

// 3. StateNotifier para manejar los datos en tiempo real en las pantallas
final dataProvider = StateNotifierProvider<DataNotifier, AsyncValue<List<ServicioEntity>>>((ref) {
  final repository = ref.watch(logisticaRepositoryProvider);
  return DataNotifier(repository);
});

class DataNotifier extends StateNotifier<AsyncValue<List<ServicioEntity>>> {
  final LogisticaRepository repository;

  DataNotifier(this.repository) : super(const AsyncValue.loading()) {
    cargarServicios();
  }

  // Función para obtener datos de Firebase
  Future<void> cargarServicios() async {
    state = const AsyncValue.loading();
    try {
      final servicios = await repository.obtenerTodosLosServicios();
      state = AsyncValue.data(servicios);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Función para registrar un nuevo servicio desde la app de empleado
  Future<void> nuevoServicio(ServicioEntity servicio) async {
    try {
      await repository.registrarServicio(servicio);
      await cargarServicios(); // Refrescar la lista automáticamente
    } catch (e) {
      // Manejo de errores de 64 bits
    }
  }

  // Función para liquidar (cobrar) desde la app de admin
  Future<void> liquidarIngreso(String id) async {
    try {
      await repository.liquidarServicio(id);
      await cargarServicios(); // Refrescar para que el admin vea que ya se cobró
    } catch (e) {
      // Manejo de errores
    }
  }
}