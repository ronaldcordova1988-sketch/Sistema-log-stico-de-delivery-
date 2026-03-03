import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ConfiguracionCortesScreen extends StatelessWidget {
  const ConfiguracionCortesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuracion Cortes '),
      ),
      body: Center(
        child: Text(
          'TODO: Implementar ConfiguracionCortesScreen',
          style: AppTheme.bodyLarge,
        ),
      ),
    );
  }
}
