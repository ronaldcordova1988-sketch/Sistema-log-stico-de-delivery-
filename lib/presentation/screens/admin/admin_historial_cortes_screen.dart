import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/servicio_entity.dart';
import '../../providers/data_provider.dart';

class AdminHistorialCortesScreen extends ConsumerWidget {
  const AdminHistorialCortesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingresosAsync = ref.watch(dataProvider);
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Liquidaciones'),
      ),
      body: ingresosAsync.when(
        data: (ingresos) {
          // Filtramos solo lo que YA está liquidado (histórico)
          final historial = ingresos.where((i) => i.liquidado).toList();
          
          // Ordenamos por fecha descendente (lo más reciente arriba)
          historial.sort((a, b) => b.fecha.compareTo(a.fecha));

          if (historial.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No hay cortes archivados todavía.', 
                       style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: historial.length,
            itemBuilder: (context, index) {
              final corte = historial[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.green.withOpacity(0.2)),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                  title: Text(
                    'Corte: ${corte.puntoA} - ${corte.puntoB}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Empleado ID: ${corte.empleadoId}\nFecha: ${dateFormat.format(corte.fecha)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Text(
                    currencyFormat.format(corte.monto),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: Colors.green,
                      fontSize: 16
                    ),
                  ),
                  onTap: () {
                    // Detalle del recibo digital
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error al cargar historial: $e')),
      ),
    );
  }
}