import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class NuevoMantenimientoScreen extends StatelessWidget {
  const NuevoMantenimientoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mantenimiento de Aceite')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.build_circle, size: 80, color: AppTheme.accentColor),
              const SizedBox(height: 24),
              Text('Mantenimiento de Aceite', style: AppTheme.titleMedium),
              const SizedBox(height: 16),
              const Text('Registra el cambio de aceite y el sistema calculará automáticamente el próximo cambio (5000 km).'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
