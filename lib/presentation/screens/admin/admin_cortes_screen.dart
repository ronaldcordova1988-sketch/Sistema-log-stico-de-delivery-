import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/models/ingreso_model.dart';
import '../../providers/data_provider.dart';

class AdminCortesScreen extends ConsumerStatefulWidget {
  const AdminCortesScreen({super.key});

  @override
  ConsumerState<AdminCortesScreen> createState() => _AdminCortesScreenState();
}

class _AdminCortesScreenState extends ConsumerState<AdminCortesScreen> {
  final currencyFormat = NumberFormat.currency(symbol: '\$');
  final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    // Escuchamos todos los ingresos registrados en el sistema
    final ingresosAsync = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liquidaciones Pendientes'),
      ),
      body: ingresosAsync.when(
        data: (ingresos) {
          // Filtramos solo lo que NO ha sido liquidado (dinero en calle)
          // Ajustado para manejar la lista de IngresoModel correctamente
          final pendientes = ingresos.where((i) => !i.liquidado).toList();

          if (pendientes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
                  SizedBox(height: 16),
                  Text(
                    'No hay cuentas pendientes por cobrar.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              _buildResumenHeader(pendientes),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'LISTA DE SERVICIOS POR LIQUIDAR',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: pendientes.length,
                  itemBuilder: (context, index) {
                    final ingreso = pendientes[index];
                    return _buildItemLiquidacion(ingreso);
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildResumenHeader(List<IngresoModel> pendientes) {
    final total = pendientes.fold(0.0, (sum, i) => sum + i.monto);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.amber.shade700,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          const Text(
            'TOTAL PENDIENTE DE COBRO',
            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormat.format(total),
            style: const TextStyle(
              fontSize: 32, 
              fontWeight: FontWeight.bold, 
              color: Colors.white
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${pendientes.length} servicios sin liquidar',
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildItemLiquidacion(IngresoModel ingreso) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: const Icon(Icons.directions_car, color: Colors.blue),
        ),
        title: Text(
          '${ingreso.puntoA} ➔ ${ingreso.puntoB}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Empleado: ${ingreso.empleadoId}'),
            // Corregido: .timestamp a .fecha
            Text(dateFormat.format(ingreso.fecha), style: const TextStyle(fontSize: 11)),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currencyFormat.format(ingreso.monto),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
            ),
            const SizedBox(height: 4),
            InkWell(
              onTap: () => _confirmarLiquidacion(ingreso),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'COBRAR',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmarLiquidacion(IngresoModel ingreso) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Recepción de Dinero'),
        content: Text('¿Confirmas que has recibido ${currencyFormat.format(ingreso.monto)} por este servicio?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), 
            child: const Text('CANCELAR')
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('SÍ, LIQUIDAR', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      // Acción de 64 bits: Llamamos al provider para marcar como liquidado en Firestore
      await ref.read(dataProvider.notifier).liquidarIngreso(ingreso.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Servicio de ${ingreso.empleadoId} liquidado con éxito'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
}