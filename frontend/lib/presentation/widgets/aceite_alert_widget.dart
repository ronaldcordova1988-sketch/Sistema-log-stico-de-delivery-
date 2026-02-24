import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/mantenimiento_aceite_model.dart';

/// ⚠️ ALERTA DE CAMBIO DE ACEITE - Aparece cuando faltan 200km o menos
class AceiteAlertWidget extends StatelessWidget {
  final MantenimientoAceiteModel? ultimoMantenimiento;
  final double kilometrajeActual;
  final VoidCallback? onTap;

  const AceiteAlertWidget({
    Key? key,
    required this.ultimoMantenimiento,
    required this.kilometrajeActual,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Si no hay mantenimiento registrado, no mostrar nada
    if (ultimoMantenimiento == null) {
      return const SizedBox.shrink();
    }

    // Verificar si debe alertar
    if (!ultimoMantenimiento!.debeAlertarProximoCambio(kilometrajeActual) &&
        !ultimoMantenimiento!.cambioVencido(kilometrajeActual)) {
      return const SizedBox.shrink();
    }

    final kmRestantes = ultimoMantenimiento!.kmRestantes(kilometrajeActual);
    final esVencido = kmRestantes <= 0;
    final color = esVencido ? AppTheme.errorColor : AppTheme.warningColor;
    final icon = esVencido ? Icons.warning : Icons.notification_important;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color,
            color.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        esVencido 
                            ? '⚠️ ¡Cambio de Aceite Vencido!' 
                            : '⚠️ Cambio de Aceite Próximo',
                        style: AppTheme.labelLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        esVencido
                            ? 'Debes cambiar el aceite urgentemente (${kmRestantes.abs().toInt()} km de retraso)'
                            : 'Te quedan ${kmRestantes.toInt()} km para el cambio',
                        style: AppTheme.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.speed,
                            color: Colors.white.withOpacity(0.8),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'KM Actual: ${kilometrajeActual.toInt()}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.event,
                            color: Colors.white.withOpacity(0.8),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Próximo: ${ultimoMantenimiento!.kmProximoCambio.toInt()}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget compacto para mostrar en cards
class AceiteAlertCompact extends StatelessWidget {
  final MantenimientoAceiteModel? ultimoMantenimiento;
  final double kilometrajeActual;

  const AceiteAlertCompact({
    Key? key,
    required this.ultimoMantenimiento,
    required this.kilometrajeActual,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ultimoMantenimiento == null) {
      return const SizedBox.shrink();
    }

    if (!ultimoMantenimiento!.debeAlertarProximoCambio(kilometrajeActual) &&
        !ultimoMantenimiento!.cambioVencido(kilometrajeActual)) {
      return const SizedBox.shrink();
    }

    final kmRestantes = ultimoMantenimiento!.kmRestantes(kilometrajeActual);
    final esVencido = kmRestantes <= 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: esVencido 
            ? AppTheme.errorColor.withOpacity(0.1) 
            : AppTheme.warningColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: esVencido ? AppTheme.errorColor : AppTheme.warningColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            esVencido ? Icons.error : Icons.warning_amber,
            color: esVencido ? AppTheme.errorColor : AppTheme.warningColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            esVencido 
                ? 'Aceite vencido' 
                : 'Cambio en ${kmRestantes.toInt()} km',
            style: TextStyle(
              color: esVencido ? AppTheme.errorColor : AppTheme.warningColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
