import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class NuevoMantenimientoScreen extends StatelessWidget {
  const NuevoMantenimientoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Mantenimiento '),
      ),
      body: Center(
        child: Text(
          'TODO: Implementar NuevoMantenimientoScreen',
          style: AppTheme.bodyLarge,
        ),
      ),
    );
  }
}
