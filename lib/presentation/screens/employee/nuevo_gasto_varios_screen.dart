import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class NuevoGastoVariosScreen extends StatelessWidget {
  const NuevoGastoVariosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Gasto Varios '),
      ),
      body: Center(
        child: Text(
          'TODO: Implementar NuevoGastoVariosScreen',
          style: AppTheme.bodyLarge,
        ),
      ),
    );
  }
}
