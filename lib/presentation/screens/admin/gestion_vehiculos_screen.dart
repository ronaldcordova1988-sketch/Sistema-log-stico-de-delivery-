import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class GestionVehiculosScreen extends StatelessWidget {
  const GestionVehiculosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion Vehiculos '),
      ),
      body: Center(
        child: Text(
          'TODO: Implementar GestionVehiculosScreen',
          style: AppTheme.bodyLarge,
        ),
      ),
    );
  }
}
