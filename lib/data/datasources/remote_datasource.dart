import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/ingreso_model.dart';
import '../models/gasto_combustible_model.dart';
import '../models/mantenimiento_aceite_model.dart';

class RemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- GESTIÓN DE USUARIOS ---
  Future<UserModel?> getUsuario(String uid) async {
    final doc = await _firestore.collection('usuarios').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!, doc.id);
    }
    return null;
  }

  // --- GESTIÓN DE INGRESOS (CARRERAS/DELIVERY) ---
  Future<void> registrarIngreso(IngresoModel ingreso) async {
    await _firestore.collection('ingresos').add(ingreso.toJson());
    
    // Acción de 64 bits: Actualizar saldo pendiente del empleado automáticamente
    await _firestore.collection('usuarios').doc(ingreso.empleadoId).update({
      'saldoPendiente': FieldValue.increment(ingreso.monto)
    });
  }

  // --- GESTIÓN DE GASTOS Y MANTENIMIENTO ---
  Future<void> registrarGastoCombustible(GastoCombustibleModel gasto) async {
    await _firestore.collection('gastos_combustible').add(gasto.toJson());
  }

  Future<void> registrarMantenimiento(MantenimientoAceiteModel mantenimiento) async {
    await _firestore.collection('mantenimientos').add(mantenimiento.toJson());
    
    // Actualizar el kilometraje actual en el documento del vehículo
    await _firestore.collection('vehiculos').doc(mantenimiento.vehiculoId).update({
      'kmActual': mantenimiento.kmActual,
      'ultimoCambioAceite': mantenimiento.kmActual,
      'proximoCambioAceite': mantenimiento.kmActual + 5000,
    });
  }

  // --- FLUJO DE ADMINISTRACIÓN (CORTES) ---
  Future<void> liquidarServiciosEmpleado(String empleadoId) async {
    final batch = _firestore.batch();
    
    // Buscamos todos los ingresos no liquidados de este empleado
    final query = await _firestore
        .collection('ingresos')
        .where('empleadoId', isEqualTo: empleadoId)
        .where('liquidado', isEqualTo: false)
        .get();

    for (var doc in query.docs) {
      batch.update(doc.reference, {'liquidado': true});
    }

    // Ponemos el saldo del empleado en cero
    batch.update(_firestore.collection('usuarios').doc(empleadoId), {
      'saldoPendiente': 0.0
    });

    await batch.commit();
  }
}