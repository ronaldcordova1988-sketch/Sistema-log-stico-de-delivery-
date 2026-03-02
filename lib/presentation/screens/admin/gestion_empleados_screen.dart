import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class GestionEmpleadosScreen extends StatelessWidget {
  const GestionEmpleadosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion Empleados '),
      ),
      body: Center(
        child: Text(
          'TODO: Implementar GestionEmpleadosScreen',
          style: AppTheme.bodyLarge,
        ),
      ),
    );
  }
}
