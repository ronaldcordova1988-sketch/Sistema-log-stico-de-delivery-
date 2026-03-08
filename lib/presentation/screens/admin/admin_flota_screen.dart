import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/data_provider.dart';

class AdminFlotaScreen extends ConsumerWidget {
  const AdminFlotaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtenemos los datos de mantenimiento (asumiendo que dataProvider los trae)
    final mantenimientosAsync = ref.watch(dataProvider);
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de Flota y Mantenimiento'),
      ),
      body: mantenimientosAsync.when(
        data: (datos) {
          if (datos.isEmpty) {
            return const Center(
              child: Text('No hay registros de flota aún.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: datos.length,
            itemBuilder: (context, index) {
              final registro = datos[index];
              final double kmRestantes = 5000; // Ejemplo estático

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.directions_car,
                        color: kmRestantes < 500 ? Colors.red : Colors.green,
                        size: 35,
                      ),
                      title: Text('Vehículo ID: ${registro.empleadoId}'), 
                      // AJUSTE: .timestamp -> .fecha
                      subtitle: Text('Último cambio: ${DateFormat('dd/MM/yyyy').format(registro.fecha)}'),
                      trailing: const Icon(Icons.more_vert),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Próximo cambio en:', style: TextStyle(fontSize: 12)),
                              Text('${kmRestantes.toStringAsFixed(0)} KM', 
                                   style: TextStyle(
                                     fontWeight: FontWeight.bold, 
                                     color: kmRestantes < 500 ? Colors.red : Colors.blue
                                   )),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: 0.8, 
                            backgroundColor: Colors.grey[300],
                            color: kmRestantes < 500 ? Colors.red : Colors.blue,
                            minHeight: 8,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Inversión: ${currencyFormat.format(registro.monto)}',
                                   style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error al cargar flota: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Programar Revisión'),
        icon: const Icon(Icons.calendar_today),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}