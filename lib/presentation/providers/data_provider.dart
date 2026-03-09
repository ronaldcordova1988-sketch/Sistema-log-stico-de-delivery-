import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_logistico_delivery/domain/entities/servicio_entity.dart';
import 'package:sistema_logistico_delivery/domain/repositories/logistica_repository.dart';
import 'package:sistema_logistico_delivery/presentation/providers/auth_provider.dart';

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

// 4. Provider para el historial de un empleado específico
final historialEmpleadoProvider = FutureProvider<List<ServicioEntity>>((ref) async {
  // Obtiene el usuario actual del authProvider
  final user = ref.watch(authProvider).value;
  if (user == null) return [];

  // Llama al repositorio para obtener los servicios de ese empleado
  final repository = ref.watch(logisticaRepositoryProvider);
  return repository.obtenerServiciosPorEmpleado(user.uid);
});