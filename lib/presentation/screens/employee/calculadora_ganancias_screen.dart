import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/data_provider.dart';

class CalculadoraGananciasScreen extends ConsumerWidget {
  const CalculadoraGananciasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.value;
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    // Escuchamos los datos globales
    final ingresosAsync = ref.watch(dataProvider);
    // Nota: Aquí asumimos que el dataProvider también gestiona gastos o tenemos providers específicos
    // Para este ejemplo, filtraremos ingresos y gastos del empleado actual

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Ganancias'),
      ),
      body: ingresosAsync.when(
        data: (ingresos) {
          // 1. Filtrar solo lo no liquidado del usuario actual
          final misIngresos = ingresos.where((i) => i.empleadoId == user?.uid && !i.liquidado).toList();
          
          // 2. Cálculos (Simulados hasta conectar los providers de gastos específicos)
          double totalIngresos = misIngresos.fold(0, (prev, element) => prev + element.monto);
          double totalGastos = 0.0; // Aquí conectarás con ref.watch(gastosProvider)
          double gananciaNeta = totalIngresos - totalGastos;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildBalanceCard(context, totalIngresos, totalGastos, gananciaNeta, currencyFormat),
                const SizedBox(height: 30),
                _buildSectionHeader('Desglose de Ingresos'),
                _buildSimpleStat(Icons.directions_car, 'Carreras', totalIngresos, Colors.green),
                const SizedBox(height: 15),
                _buildSectionHeader('Egresos del Periodo'),
                _buildSimpleStat(Icons.local_gas_station, 'Combustible', 0.0, Colors.red),
                _buildSimpleStat(Icons.build, 'Mantenimiento', 0.0, Colors.red),
                const SizedBox(height: 40),
                const Text(
                  'Nota: Estos montos son preliminares hasta que el administrador realice el corte oficial.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stack) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, double ing, double gas, double neta, NumberFormat fmt) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.amber.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          const Text('GANANCIA NETA ESTIMADA', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(
            fmt.format(neta),
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniStat('Ingresos', fmt.format(ing), Colors.blueGrey),
              _buildMiniStat('Gastos', fmt.format(gas), Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSimpleStat(IconData icon, String label, double value, Color color) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(label),
        trailing: Text(
          NumberFormat.currency(symbol: '\$').format(value),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}