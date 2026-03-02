import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ChatAdminScreen extends StatelessWidget {
  const ChatAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Admin '),
      ),
      body: Center(
        child: Text(
          'TODO: Implementar ChatAdminScreen',
          style: AppTheme.bodyLarge,
        ),
      ),
    );
  }
}
