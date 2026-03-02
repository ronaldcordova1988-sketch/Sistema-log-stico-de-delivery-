import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class HomeEmployeeScreen extends StatelessWidget {
  const HomeEmployeeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Employee '),
      ),
      body: Center(
        child: Text(
          'TODO: Implementar HomeEmployeeScreen',
          style: AppTheme.bodyLarge,
        ),
      ),
    );
  }
}
