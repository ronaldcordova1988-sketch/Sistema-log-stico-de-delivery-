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
          // Nota: En una fase avanzada, filtrarías por los últimos registros de cada vehículo
          // Por ahora, listamos los mantenimientos registrados para auditoría
          
          if (datos.isEmpty) {
            return const Center(
              child: Text('No hay registros de flota aún.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: datos.length,
            itemBuilder: (context, index) {
              // Asumimos que los datos contienen información de kilometraje
              // lógica: kmProximoCambio - kmActual = kmRestantes
              final registro = datos[index];
              final double kmRestantes = 5000; // Ejemplo estático hasta conectar lógica real de resta

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
                      title: Text('Vehículo ID: ${registro.empleadoId}'), // O ID del vehículo
                      subtitle: Text('Último cambio: ${DateFormat('dd/MM/yyyy').format(registro.timestamp)}'),
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
                          // Barra de progreso visual para el aceite
                          LinearProgressIndicator(
                            value: 0.8, // Ejemplo: 80% de vida útil consumida
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
        onPressed: () {
          // Acción para añadir vehículo nuevo o programar revisión
        },
        label: const Text('Programar Revisión'),
        icon: const Icon(Icons.calendar_today),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}