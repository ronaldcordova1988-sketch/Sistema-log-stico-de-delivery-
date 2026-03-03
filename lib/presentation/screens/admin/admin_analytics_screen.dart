import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/data_provider.dart';

class AdminAnalyticsScreen extends ConsumerWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingresosAsync = ref.watch(dataProvider);
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Análisis de Rendimiento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () {
              // Futura función: Exportar a Excel/PDF
            },
          ),
        ],
      ),
      body: ingresosAsync.when(
        data: (ingresos) {
          // Lógica de Analytics: Agrupar por tipo de servicio
          final totalCarreras = ingresos.where((i) => i.tipo.toString().contains('carrera')).length;
          final totalDelivery = ingresos.where((i) => i.tipo.toString().contains('delivery')).length;
          final montoTotal = ingresos.fold(0.0, (prev, e) => prev + e.monto);

          if (ingresos.isEmpty) {
            return const Center(child: Text('No hay datos suficientes para el análisis.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'RESUMEN GENERAL',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 15),
                
                // Tarjeta de Ingreso Total Destacada
                _buildMainStatCard(context, montoTotal, currencyFormat),
                
                const SizedBox(height: 25),
                const Text(
                  'DISTRIBUCIÓN POR SERVICIO',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 15),

                // Gráfica de Barras Proporcional
                _buildAnalyticsBar(context, 'Carreras', totalCarreras, ingresos.length, Colors.amber),
                _buildAnalyticsBar(context, 'Delivery / Encomiendas', totalDelivery, ingresos.length, Colors.blue),
                _buildAnalyticsBar(context, 'Otros Servicios', (ingresos.length - totalCarreras - totalDelivery), ingresos.length, Colors.purple),

                const SizedBox(height: 30),
                const Text(
                  'EFICIENCIA OPERATIVA',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 15),

                // Tarjetas de métricas rápidas
                Row(
                  children: [
                    _buildMiniMetric(context, 'Promedio/Viaje', currencyFormat.format(montoTotal / ingresos.length), Icons.trending_up),
                    _buildMiniMetric(context, 'Servicios Hoy', ingresos.length.toString(), Icons.calendar_today),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error en Analytics: $e')),
      ),
    );
  }

  Widget _buildMainStatCard(BuildContext context, double monto, NumberFormat fmt) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          const Text('INGRESOS TOTALES PROCESADOS', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 10),
          Text(
            fmt.format(monto),
            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text('Datos actualizados en tiempo real', style: TextStyle(color: Colors.white54, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildAnalyticsBar(BuildContext context, String label, int count, int total, Color color) {
    final double percent = total > 0 ? count / total : 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('$count (${(percent * 100).toStringAsFixed(1)}%)'),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: color.withOpacity(0.1),
            color: color,
            minHeight: 12,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetric(BuildContext context, String label, String value, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Icon(icon, color: Colors.blueGrey, size: 20),
              const SizedBox(height: 10),
              Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}