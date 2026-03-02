import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class NuevaCarreraScreen extends StatelessWidget {
  const NuevaCarreraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva Carrera '),
      ),
      body: Center(
        child: Text(
          'TODO: Implementar NuevaCarreraScreen',
          style: AppTheme.bodyLarge,
        ),
      ),
    );
  }
}
