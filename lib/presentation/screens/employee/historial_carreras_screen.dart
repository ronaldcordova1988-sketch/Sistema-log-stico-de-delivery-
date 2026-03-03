import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/models/ingreso_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/data_provider.dart';

class HistorialCarrerasScreen extends ConsumerWidget {
  const HistorialCarrerasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.value;
    
    // Obtenemos el flujo de ingresos filtrado por el empleado actual
    final ingresosAsync = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Historial de Trabajo'),
      ),
      body: ingresosAsync.when(
        data: (ingresos) {
          // Filtramos solo los ingresos del empleado logueado
          final misIngresos = ingresos.where((i) => i.empleadoId == user?.uid).toList();
          
          // Ordenamos por fecha (más reciente primero)
          misIngresos.sort((a, b) => b.timestamp.compareTo(a.timestamp));

          if (misIngresos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Aún no tienes registros hoy', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: misIngresos.length,
            itemBuilder: (context, index) {
              final ingreso = misIngresos[index];
              return _buildCarreraCard(context, ingreso);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stack) => Center(child: Text('❌ Error al cargar historial: $e')),
      ),
    );
  }

  Widget _buildCarreraCard(BuildContext context, IngresoModel ingreso) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: _getTipoColor(ingreso.tipo).withOpacity(0.2),
          child: Icon(_getTipoIcon(ingreso.tipo), color: _getTipoColor(ingreso.tipo)),
        ),
        title: Text(
          '${ingreso.puntoA} ➔ ${ingreso.puntoB}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateFormat.format(ingreso.timestamp)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: ingreso.liquidado ? Colors.green.withOpacity(0.1) : Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                ingreso.liquidado ? 'LIQUIDADO' : 'PENDIENTE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: ingreso.liquidado ? Colors.green : Colors.orange[800],
                ),
              ),
            ),
          ],
        ),
        trailing: Text(
          currencyFormat.format(ingreso.monto),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  IconData _getTipoIcon(TipoIngreso tipo) {
    switch (tipo) {
      case TipoIngreso.carrera: return Icons.directions_car;
      case TipoIngreso.delivery: return Icons.delivery_dining;
      case TipoIngreso.transporte: return Icons.local_shipping;
    }
  }

  Color _getTipoColor(TipoIngreso tipo) {
    switch (tipo) {
      case TipoIngreso.carrera: return Colors.amber;
      case TipoIngreso.delivery: return Colors.blue;
      case TipoIngreso.transporte: return Colors.purple;
    }
  }
}