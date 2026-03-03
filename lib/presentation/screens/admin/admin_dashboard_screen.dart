import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/data_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.value;
    
    // Aquí escucharemos todos los ingresos de todos los empleados
    final todosLosIngresos = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Control Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido, Administrador',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // --- SECCIÓN DE ESTADÍSTICAS GLOBALES ---
            todosLosIngresos.when(
              data: (ingresos) {
                final totalPendiente = ingresos
                    .where((i) => !i.liquidado)
                    .fold(0.0, (prev, element) => prev + element.monto);

                return Row(
                  children: [
                    _buildStatCard(
                      context,
                      'Total en Calle',
                      '\$ ${totalPendiente.toStringAsFixed(2)}',
                      Icons.monetization_on,
                      Colors.green,
                    ),
                    _buildStatCard(
                      context,
                      'Alertas Aceite',
                      '2', // Esto se conectará con la lógica de mantenimiento
                      Icons.warning_amber_rounded,
                      Colors.red,
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Text('Error: $e'),
            ),

            const SizedBox(height: 30),

            // --- MENÚ DE GESTIÓN ---
            const Text(
              'Gestión Operativa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            _buildAdminMenuTile(
              context,
              'Liquidaciones y Cortes',
              'Procesar pagos y cerrar caja del día',
              Icons.account_balance_wallet,
              () => Navigator.pushNamed(context, '/admin/cortes'),
            ),
            _buildAdminMenuTile(
              context,
              'Gestión de Empleados',
              'Ver rendimiento y saldos individuales',
              Icons.people_alt,
              () => Navigator.pushNamed(context, '/admin/empleados'),
            ),
            _buildAdminMenuTile(
              context,
              'Control de Flota',
              'Estado de vehículos y próximos cambios de aceite',
              Icons.minor_crash,
              () => Navigator.pushNamed(context, '/admin/flota'),
            ),
            _buildAdminMenuTile(
              context,
              'Reportes Globales',
              'Historial completo de ingresos y gastos',
              Icons.bar_chart,
              () => Navigator.pushNamed(context, '/admin/reportes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminMenuTile(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.amber.withOpacity(0.1),
          child: Icon(icon, color: Colors.amber[800]),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}