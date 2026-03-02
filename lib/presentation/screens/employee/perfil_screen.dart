import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil '),
      ),
      body: Center(
        child: Text(
          'TODO: Implementar PerfilScreen',
          style: AppTheme.bodyLarge,
        ),
      ),
    );
  }
}
