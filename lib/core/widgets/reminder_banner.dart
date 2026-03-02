import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';

class ReminderBanner extends StatefulWidget {
  const ReminderBanner({Key? key}) : super(key: key);

  @override
  State<ReminderBanner> createState() => _ReminderBannerState();
}

class _ReminderBannerState extends State<ReminderBanner> {
  Timer? _timer;
  bool _showBanner = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(const Duration(minutes: 10), () {
      if (mounted) {
        setState(() => _showBanner = true);
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) setState(() => _showBanner = false);
        });
      }
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    _startTimer();
    setState(() => _showBanner = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resetTimer,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _showBanner ? 60 : 0,
        child: _showBanner
            ? Material(
                color: AppTheme.warningColor,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.notifications_active, color: Colors.white),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          '🤖 ¡Hola! No olvides agregar tus carreras',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: _resetTimer,
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
