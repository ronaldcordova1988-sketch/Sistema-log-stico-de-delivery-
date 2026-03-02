import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class NuevoGastoCombustibleScreen extends StatelessWidget {
  const NuevoGastoCombustibleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Gasto Combustible '),
      ),
      body: Center(
        child: Text(
          'TODO: Implementar NuevoGastoCombustibleScreen',
          style: AppTheme.bodyLarge,
        ),
      ),
    );
  }
}
