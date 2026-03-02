import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class DashboardAdminScreen extends StatelessWidget {
  const DashboardAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Admin '),
      ),
      body: Center(
        child: Text(
          'TODO: Implementar DashboardAdminScreen',
          style: AppTheme.bodyLarge,
        ),
      ),
    );
  }
}
