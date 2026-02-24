import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/reminder_banner.dart';
import '../../widgets/aceite_alert_widget.dart';
import '../routes/app_router.dart';

/// Pantalla principal del Empleado con balance y acciones rápidas
class HomeEmployeeScreen extends StatelessWidget {
  const HomeEmployeeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Dashboard'),
        actions: [
          // Indicador de sincronización
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              // TODO: Implementar sincronización
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('✓ Sincronización completada'),
                  backgroundColor: AppTheme.successColor,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Sincronizar',
          ),
          // Menú
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Perfil'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRouter.perfil);
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Historial'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRouter.historialCarreras);
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, AppRouter.login);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: FloatingReminderBanner(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Alerta de cambio de aceite (si aplica)
              // TODO: Conectar con datos reales
              // AceiteAlertWidget(
              //   ultimoMantenimiento: ultimoMantenimiento,
              //   kilometrajeActual: kmActual,
              // ),

              // Tarjeta de Balance
              _buildBalanceCard(context),

              const SizedBox(height: 24),

              // Acciones rápidas
              _buildQuickActions(context),

              const SizedBox(height: 24),

              // Resumen de hoy
              _buildTodaySummary(context),

              const SizedBox(height: 24),

              // Meta del día (si está configurada)
              _buildDailyGoal(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    // TODO: Conectar con datos reales del provider
    const ingresos = 1500.0;
    const gastos = 450.0;
    const balance = ingresos - gastos;

    return Card(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.secondaryDark,
              AppTheme.accentColor,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Balance Neto',
                  style: AppTheme.labelLarge.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Hoy',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              '\$${balance.toStringAsFixed(2)}',
              style: AppTheme.titleLarge.copyWith(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: balance >= 0 ? AppTheme.successColor : AppTheme.errorColor,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBalanceStat(
                  'Ingresos',
                  ingresos,
                  AppTheme.successColor,
                  Icons.arrow_upward,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.2),
                ),
                _buildBalanceStat(
                  'Gastos',
                  gastos,
                  AppTheme.errorColor,
                  Icons.arrow_downward,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceStat(String label, double value, Color color, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Rápidas',
          style: AppTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            _buildActionCard(
              context,
              icon: Icons.add_road,
              label: 'Nueva Carrera',
              color: AppTheme.highlightColor,
              onTap: () => Navigator.pushNamed(context, AppRouter.nuevaCarrera),
            ),
            _buildActionCard(
              context,
              icon: Icons.local_gas_station,
              label: 'Combustible',
              color: AppTheme.warningColor,
              onTap: () => Navigator.pushNamed(context, AppRouter.nuevoGastoCombustible),
            ),
            _buildActionCard(
              context,
              icon: Icons.build,
              label: 'Mantenimiento',
              color: AppTheme.accentColor,
              onTap: () => Navigator.pushNamed(context, AppRouter.nuevoMantenimiento),
            ),
            _buildActionCard(
              context,
              icon: Icons.receipt_long,
              label: 'Otros Gastos',
              color: AppTheme.successColor,
              onTap: () => Navigator.pushNamed(context, AppRouter.nuevoGastoVarios),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: AppTheme.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodaySummary(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Resumen de Hoy', style: AppTheme.titleMedium),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSummaryRow(Icons.directions_car, 'Carreras realizadas', '8', AppTheme.successColor),
                const Divider(height: 24),
                _buildSummaryRow(Icons.receipt, 'Gastos registrados', '3', AppTheme.warningColor),
                const Divider(height: 24),
                _buildSummaryRow(Icons.speed, 'Kilometraje recorrido', '245 km', AppTheme.infoColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: Colors.grey[400]),
          ),
        ),
        Text(
          value,
          style: AppTheme.labelLarge.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDailyGoal(BuildContext context) {
    // TODO: Conectar con datos reales
    const meta = 2000.0;
    const actual = 1500.0;
    final progreso = (actual / meta).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Meta del Día', style: AppTheme.titleMedium),
                TextButton.icon(
                  onPressed: () => Navigator.pushNamed(context, AppRouter.metasDiarias),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Editar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progreso,
                minHeight: 12,
                backgroundColor: AppTheme.accentColor,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progreso >= 1.0 ? AppTheme.successColor : AppTheme.highlightColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${actual.toStringAsFixed(2)} de \$${meta.toStringAsFixed(2)}',
                  style: AppTheme.bodySmall,
                ),
                Text(
                  '${(progreso * 100).toInt()}%',
                  style: AppTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: progreso >= 1.0 ? AppTheme.successColor : AppTheme.highlightColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
