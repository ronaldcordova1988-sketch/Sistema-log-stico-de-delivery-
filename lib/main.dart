import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Importaciones de la estructura generada
import 'core/theme/app_theme.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/auth_provider.dart';
import 'config/router/app_router.dart'; // Importante para la navegación

void main() async {
  // 1. Asegurar la vinculación de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializar Persistencia Local (Offline First)
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('cache_logistica');

  // 3. Inicializar Firebase con manejo de errores
  try {
    await Firebase.initializeApp();
    debugPrint('🚀 Firebase conectado exitosamente');
  } catch (e) {
    debugPrint('⚠️ Error al conectar Firebase: $e');
  }

  runApp(
    const ProviderScope(
      child: LogisticsApp(),
    ),
  );
}

class LogisticsApp extends ConsumerWidget {
  const LogisticsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos el tema global del sistema
    final themeAsync = ref.watch(themeProvider);

    // Mantenemos tu estructura de MaterialApp pero lista para rutas
    return MaterialApp(
      title: 'Sistema Logístico Delivery',
      debugShowCheckedModeBanner: false,
      
      // Configuración de Temas (Mantengo tu lógica exacta)
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.yellow,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.yellow,
        brightness: Brightness.dark,
      ),
      
      // El modo depende del provider de tema
      themeMode: themeAsync.maybeWhen(
        data: (isDark) => isDark ? ThemeMode.dark : ThemeMode.light,
        orElse: () => ThemeMode.system,
      ),

      // Mantenemos tu AuthWrapper como puerta de entrada
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos el proveedor de isAdmin para reaccionar a cambios de rol
    final esAdmin = ref.watch(isAdminProvider);
    final authState = ref.watch(authProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          // Redirección automática basada en el rol del usuario
          // Usamos un frame de espera para asegurar que el router esté listo
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (esAdmin) {
              appRouter.go('/admin/dashboard');
            } else {
              appRouter.go('/employee/home');
            }
          });
          // Mientras se redirige, mostramos un loader para evitar parpadeos
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // Si no hay usuario, mostramos pantalla de bienvenida/login
        return const WelcomeScreen();
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, stack) => Scaffold(
        body: Center(child: Text('❌ Error de conexión: $e')),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delivery_dining, size: 80, color: Colors.amber),
            const SizedBox(height: 20),
            const Text(
              'LOGÍSTICA DELIVERY',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('Versión 2026 - 64 Bit Optimized'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Integración con el router para ir al login que ya programamos
                appRouter.go('/login');
              },
              child: const Text('Comenzar Jornada'),
            ),
          ],
        ),
      ),
    );
  }
}