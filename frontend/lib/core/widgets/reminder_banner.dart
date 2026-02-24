import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../constants/app_constants.dart';

/// 🤖 BOT RECORDATORIO - Aparece cada 10 minutos
/// 
/// Muestra un banner flotante recordando al empleado agregar sus carreras
/// Se puede cerrar y vuelve a aparecer después del tiempo configurado
class ReminderBanner extends StatefulWidget {
  const ReminderBanner({Key? key}) : super(key: key);

  @override
  State<ReminderBanner> createState() => _ReminderBannerState();
}

class _ReminderBannerState extends State<ReminderBanner> with SingleTickerProviderStateMixin {
  Timer? _timer;
  bool _showBanner = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _startTimer();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: AppConstants.mediumAnimation,
    );
    
    _slideAnimation = Tween<double>(
      begin: -100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(Duration(minutes: AppConstants.reminderMinutes), () {
      if (mounted) {
        setState(() => _showBanner = true);
        _animationController.forward();
        
        // Auto-cerrar después de 5 segundos
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted && _showBanner) {
            _closeBanner();
          }
        });
      }
    });
  }

  void _closeBanner() {
    _animationController.reverse().then((_) {
      if (mounted) {
        setState(() => _showBanner = false);
        _startTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_showBanner) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.warningColor,
              AppTheme.warningColor.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _closeBanner,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.notifications_active,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '¡Recordatorio! 🤖',
                          style: AppTheme.labelLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppConstants.reminderMessage,
                          style: AppTheme.bodySmall.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: _closeBanner,
                    tooltip: 'Cerrar',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }
}

/// Widget flotante que se coloca en el Scaffold
class FloatingReminderBanner extends StatelessWidget {
  final Widget child;

  const FloatingReminderBanner({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: ReminderBanner(),
          ),
        ),
      ],
    );
  }
}
