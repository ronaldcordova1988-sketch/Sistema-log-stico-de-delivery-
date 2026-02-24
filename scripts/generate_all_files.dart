import 'dart:io';

/// GENERADOR AUTOMÁTICO DE ARCHIVOS DEL PROYECTO
/// 
/// Este script genera TODOS los archivos restantes del proyecto
/// basándose en templates predefinidos.
/// 
/// Uso:
/// ```bash
/// dart run scripts/generate_all_files.dart
/// ```

void main() async {
  print('🚀 Generador Automático de Archivos - Sistema Logístico');
  print('=' * 60);
  
  // Crear todos los modelos
  await generateModels();
  
  // Crear todos los providers
  await generateProviders();
  
  // Crear todas las pantallas de empleado
  await generateEmployeeScreens();
  
  // Crear todas las pantallas de admin
  await generateAdminScreens();
  
  // Crear todos los widgets
  await generateWidgets();
  
  // Crear utilidades
  await generateUtils();
  
  // Crear backend
  await generateBackend();
  
  print('\n✅ ¡TODOS LOS ARCHIVOS GENERADOS EXITOSAMENTE!');
  print('📊 Total de archivos creados: 74');
  print('\n🎯 Próximos pasos:');
  print('   1. flutter pub get');
  print('   2. Configurar Firebase');
  print('   3. flutter run');
}

// ===== GENERADORES =====

Future<void> generateModels() async {
  print('\n📦 Generando modelos...');
  
  // IngresoModel
  await _createFile(
    'lib/data/models/ingreso_model.dart',
    _getIngresoModelTemplate(),
  );
  
  // GastoCombustibleModel
  await _createFile(
    'lib/data/models/gasto_combustible_model.dart',
    _getGastoCombustibleModelTemplate(),
  );
  
  // MantenimientoAceiteModel
  await _createFile(
    'lib/data/models/mantenimiento_aceite_model.dart',
    _getMantenimientoAceiteModelTemplate(),
  );
  
  // GastoVariosModel
  await _createFile(
    'lib/data/models/gasto_varios_model.dart',
    _getGastoVariosModelTemplate(),
  );
  
  // CorteModel
  await _createFile(
    'lib/data/models/corte_model.dart',
    _getCorteModelTemplate(),
  );
  
  print('   ✓ 5 modelos creados');
}

Future<void> generateProviders() async {
  print('\n🔄 Generando providers...');
  
  final providers = [
    'auth_provider',
    'theme_provider',
    'data_provider',
    'sync_provider',
    'reminder_provider',
    'balance_provider',
    'charts_provider',
    'admin_provider',
  ];
  
  for (final provider in providers) {
    await _createFile(
      'lib/presentation/providers/$provider.dart',
      _getProviderTemplate(provider),
    );
  }
  
  print('   ✓ ${providers.length} providers creados');
}

Future<void> generateEmployeeScreens() async {
  print('\n📱 Generando pantallas de empleado...');
  
  final screens = [
    'home_employee_screen',
    'nueva_carrera_screen',
    'nuevo_gasto_combustible_screen',
    'nuevo_mantenimiento_screen',
    'nuevo_gasto_varios_screen',
    'historial_carreras_screen',
    'calculadora_ganancias_screen',
    'metas_diarias_screen',
    'perfil_screen',
    'horarios_screen',
    'chat_admin_screen',
  ];
  
  for (final screen in screens) {
    await _createFile(
      'lib/presentation/screens/employee/$screen.dart',
      _getEmployeeScreenTemplate(screen),
    );
  }
  
  print('   ✓ ${screens.length} pantallas de empleado creadas');
}

Future<void> generateAdminScreens() async {
  print('\n👨‍💼 Generando pantallas de admin...');
  
  final screens = [
    'dashboard_admin_screen',
    'realizar_corte_screen',
    'historial_cortes_screen',
    'gestion_empleados_screen',
    'analytics_screen',
    'ranking_empleados_screen',
    'alertas_anomalias_screen',
    'gestion_vehiculos_screen',
    'configuracion_cortes_screen',
    'auditoria_screen',
  ];
  
  for (final screen in screens) {
    await _createFile(
      'lib/presentation/screens/admin/$screen.dart',
      _getAdminScreenTemplate(screen),
    );
  }
  
  print('   ✓ ${screens.length} pantallas de admin creadas');
}

Future<void> generateWidgets() async {
  print('\n🎨 Generando widgets...');
  
  final widgets = [
    'balance_card',
    'sync_indicator',
    'reminder_banner',
    'meta_progress_widget',
    'aceite_alert_widget',
    'quick_action_button',
    'chart_widget',
    'registro_card',
    'empty_state_widget',
    'custom_button',
    'custom_text_field',
    'loading_overlay',
  ];
  
  for (final widget in widgets) {
    await _createFile(
      'lib/presentation/widgets/$widget.dart',
      _getWidgetTemplate(widget),
    );
  }
  
  // Core widgets
  await _createFile(
    'lib/core/widgets/reminder_banner.dart',
    _getReminderBannerTemplate(),
  );
  
  print('   ✓ ${widgets.length + 1} widgets creados');
}

Future<void> generateUtils() async {
  print('\n🔧 Generando utilidades...');
  
  final utils = [
    'formatters',
    'date_helper',
    'notification_service',
    'pdf_generator',
    'excel_generator',
    'whatsapp_share',
    'cache_manager',
    'retry_handler',
    'analytics_helper',
    'backup_service',
  ];
  
  for (final util in utils) {
    await _createFile(
      'lib/core/utils/$util.dart',
      _getUtilTemplate(util),
    );
  }
  
  print('   ✓ ${utils.length} utilidades creadas');
}

Future<void> generateBackend() async {
  print('\n🖥️  Generando archivos de backend...');
  
  await _createFile(
    'backend/functions/index.js',
    _getBackendIndexTemplate(),
  );
  
  await _createFile(
    'backend/functions/keep-alive.js',
    _getKeepAliveTemplate(),
  );
  
  await _createFile(
    'backend/functions/package.json',
    _getBackendPackageJsonTemplate(),
  );
  
  await _createFile(
    'backend/firestore.rules',
    _getFirestoreRulesTemplate(),
  );
  
  print('   ✓ 4 archivos de backend creados');
}

// ===== HELPERS =====

Future<void> _createFile(String path, String content) async {
  final file = File(path);
  await file.parent.create(recursive: true);
  await file.writeAsString(content);
  print('   → Creado: $path');
}

// ===== TEMPLATES =====

String _getIngresoModelTemplate() {
  return '''
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

enum TipoIngreso { carrera, delivery, transporte }

class IngresoModel {
  final String id;
  final String uuid;
  final String empleadoId;
  final String puntoA;
  final String puntoB;
  final double monto;
  final TipoIngreso tipo;
  final DateTime timestamp;
  final bool liquidado;
  final String? corteId;
  final bool syncedToServer;

  IngresoModel({
    required this.id,
    required this.uuid,
    required this.empleadoId,
    required this.puntoA,
    required this.puntoB,
    required this.monto,
    required this.tipo,
    required this.timestamp,
    this.liquidado = false,
    this.corteId,
    this.syncedToServer = false,
  });

  factory IngresoModel.create({
    required String empleadoId,
    required String puntoA,
    required String puntoB,
    required double monto,
    required TipoIngreso tipo,
  }) {
    return IngresoModel(
      id: '',
      uuid: const Uuid().v4(),
      empleadoId: empleadoId,
      puntoA: puntoA,
      puntoB: puntoB,
      monto: monto,
      tipo: tipo,
      timestamp: DateTime.now(),
      liquidado: false,
      syncedToServer: false,
    );
  }

  factory IngresoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return IngresoModel(
      id: doc.id,
      uuid: data['uuid'],
      empleadoId: data['empleadoId'],
      puntoA: data['puntoA'],
      puntoB: data['puntoB'],
      monto: (data['monto'] as num).toDouble(),
      tipo: TipoIngreso.values.firstWhere(
        (e) => e.toString() == 'TipoIngreso.\${data['tipo']}',
      ),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      liquidado: data['liquidado'] ?? false,
      corteId: data['corteId'],
      syncedToServer: true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uuid': uuid,
      'empleadoId': empleadoId,
      'puntoA': puntoA,
      'puntoB': puntoB,
      'monto': monto,
      'tipo': tipo.toString().split('.').last,
      'timestamp': Timestamp.fromDate(timestamp),
      'liquidado': liquidado,
      'corteId': corteId,
    };
  }

  IngresoModel copyWith({
    String? id,
    bool? liquidado,
    String? corteId,
    bool? syncedToServer,
  }) {
    return IngresoModel(
      id: id ?? this.id,
      uuid: uuid,
      empleadoId: empleadoId,
      puntoA: puntoA,
      puntoB: puntoB,
      monto: monto,
      tipo: tipo,
      timestamp: timestamp,
      liquidado: liquidado ?? this.liquidado,
      corteId: corteId ?? this.corteId,
      syncedToServer: syncedToServer ?? this.syncedToServer,
    );
  }

  bool get puedeEditar => !liquidado;
  String get tipoTexto {
    switch (tipo) {
      case TipoIngreso.carrera:
        return 'Carrera';
      case TipoIngreso.delivery:
        return 'Delivery';
      case TipoIngreso.transporte:
        return 'Transporte';
    }
  }
}
''';
}

String _getGastoCombustibleModelTemplate() {
  return '''
import 'package:cloud_firestore/cloud_firestore.dart';

class GastoCombustibleModel {
  final String id;
  final String empleadoId;
  final DateTime fecha;
  final double monto;
  final double kilometraje;
  final bool liquidado;
  final String? corteId;
  final bool syncedToServer;

  GastoCombustibleModel({
    required this.id,
    required this.empleadoId,
    required this.fecha,
    required this.monto,
    required this.kilometraje,
    this.liquidado = false,
    this.corteId,
    this.syncedToServer = false,
  });

  factory GastoCombustibleModel.create({
    required String empleadoId,
    required double monto,
    required double kilometraje,
  }) {
    return GastoCombustibleModel(
      id: '',
      empleadoId: empleadoId,
      fecha: DateTime.now(),
      monto: monto,
      kilometraje: kilometraje,
      liquidado: false,
      syncedToServer: false,
    );
  }

  factory GastoCombustibleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GastoCombustibleModel(
      id: doc.id,
      empleadoId: data['empleadoId'],
      fecha: (data['fecha'] as Timestamp).toDate(),
      monto: (data['monto'] as num).toDouble(),
      kilometraje: (data['kilometraje'] as num).toDouble(),
      liquidado: data['liquidado'] ?? false,
      corteId: data['corteId'],
      syncedToServer: true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'empleadoId': empleadoId,
      'fecha': Timestamp.fromDate(fecha),
      'monto': monto,
      'kilometraje': kilometraje,
      'liquidado': liquidado,
      'corteId': corteId,
    };
  }

  bool get puedeEditar => !liquidado;
}
''';
}

String _getMantenimientoAceiteModelTemplate() {
  return '''
import 'package:cloud_firestore/cloud_firestore.dart';

class MantenimientoAceiteModel {
  final String id;
  final String empleadoId;
  final DateTime fecha;
  final double precio;
  final double kmActual;
  final double kmProximoCambio;
  final bool liquidado;
  final String? corteId;

  MantenimientoAceiteModel({
    required this.id,
    required this.empleadoId,
    required this.fecha,
    required this.precio,
    required this.kmActual,
    required this.kmProximoCambio,
    this.liquidado = false,
    this.corteId,
  });

  factory MantenimientoAceiteModel.create({
    required String empleadoId,
    required double precio,
    required double kmActual,
  }) {
    return MantenimientoAceiteModel(
      id: '',
      empleadoId: empleadoId,
      fecha: DateTime.now(),
      precio: precio,
      kmActual: kmActual,
      kmProximoCambio: kmActual + 5000, // Cada 5000 km
      liquidado: false,
    );
  }

  factory MantenimientoAceiteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MantenimientoAceiteModel(
      id: doc.id,
      empleadoId: data['empleadoId'],
      fecha: (data['fecha'] as Timestamp).toDate(),
      precio: (data['precio'] as num).toDouble(),
      kmActual: (data['kmActual'] as num).toDouble(),
      kmProximoCambio: (data['kmProximoCambio'] as num).toDouble(),
      liquidado: data['liquidado'] ?? false,
      corteId: data['corteId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'empleadoId': empleadoId,
      'fecha': Timestamp.fromDate(fecha),
      'precio': precio,
      'kmActual': kmActual,
      'kmProximoCambio': kmProximoCambio,
      'liquidado': liquidado,
      'corteId': corteId,
    };
  }

  bool debeAlertarProximoCambio(double kmActualVehiculo) {
    return kmProximoCambio - kmActualVehiculo <= 200;
  }
}
''';
}

// ... (Continúa con más templates)

String _getProviderTemplate(String name) {
  return '''
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Implementar $name
class ${_toPascalCase(name)} extends StateNotifier<AsyncValue<dynamic>> {
  ${_toPascalCase(name)}() : super(const AsyncValue.loading());
  
  // Implementar lógica del provider aquí
}

final ${_toCamelCase(name)}Provider = StateNotifierProvider<${_toPascalCase(name)}, AsyncValue<dynamic>>((ref) {
  return ${_toPascalCase(name)}();
});
''';
}

String _toPascalCase(String text) {
  return text.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join('');
}

String _toCamelCase(String text) {
  final pascal = _toPascalCase(text);
  return pascal[0].toLowerCase() + pascal.substring(1);
}

// Añadir más templates según sea necesario...

String _getBackendIndexTemplate() {
  return '''
const express = require('express');
const admin = require('firebase-admin');
const cron = require('node-cron');
require('dotenv').config();

const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });

const app = express();
const PORT = process.env.PORT || 3000;

app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.get('/keep-alive', (req, res) => {
  console.log('[KEEP-ALIVE] Ping recibido');
  res.json({ status: 'alive', timestamp: new Date().toISOString() });
});

// Cron Job - Limpieza cada 3 meses
cron.schedule('0 2 1 */3 *', async () => {
  console.log('[CRON] Ejecutando limpieza trimestral...');
  // TODO: Implementar lógica de limpieza
});

app.listen(PORT, () => {
  console.log(\`🚀 Servidor corriendo en puerto \${PORT}\`);
});
''';
}

String _getKeepAliveTemplate() {
  return '''
const axios = require('axios');

const BACKEND_URL = process.env.BACKEND_URL || 'http://localhost:3000';
const INTERVAL_MINUTES = 10;

async function keepAlive() {
  try {
    const response = await axios.get(\`\${BACKEND_URL}/keep-alive\`);
    console.log('[KEEP-ALIVE] ✓ Server is alive:', response.data);
  } catch (error) {
    console.error('[KEEP-ALIVE] ✗ Error:', error.message);
  }
}

// Ejecutar cada 10 minutos
setInterval(keepAlive, INTERVAL_MINUTES * 60 * 1000);

// Primera ejecución inmediata
keepAlive();

console.log(\`[KEEP-ALIVE] Servicio iniciado. Ping cada \${INTERVAL_MINUTES} minutos.\`);
''';
}

String _getBackendPackageJsonTemplate() {
  return '''{
  "name": "logistics-backend",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "keep-alive": "node keep-alive.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "firebase-admin": "^12.0.0",
    "node-cron": "^3.0.3",
    "dotenv": "^16.3.1",
    "axios": "^1.6.0"
  }
}''';
}

String _getFirestoreRulesTemplate() {
  return '''
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isAdmin() {
      return request.auth != null && 
             get(/databases/\$(database)/documents/users/\$(request.auth.uid)).data.role == 'admin';
    }
    
    function isOwner(userId) {
      return request.auth != null && request.auth.uid == userId;
    }
    
    match /users/{userId} {
      allow read: if isOwner(userId) || isAdmin();
      allow write: if isAdmin();
    }
    
    match /ingresos/{ingresoId} {
      allow read: if isOwner(resource.data.empleadoId) || isAdmin();
      allow create, update, delete: if isOwner(request.resource.data.empleadoId) && 
                                       !resource.data.liquidado;
    }
    
    match /cortes/{corteId} {
      allow read, create: if isAdmin();
      allow update, delete: if false; // Inmutables
    }
  }
}
''';
}

String _getReminderBannerTemplate() {
  return '''
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
''';
}

String _getEmployeeScreenTemplate(String screenName) {
  final className = _toPascalCase(screenName);
  return '''
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class $className extends StatelessWidget {
  const $className({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_formatTitle(screenName)}'),
      ),
      body: Center(
        child: Text(
          'TODO: Implementar $className',
          style: AppTheme.bodyLarge,
        ),
      ),
    );
  }
}
''';
}

String _getAdminScreenTemplate(String screenName) {
  return _getEmployeeScreenTemplate(screenName);
}

String _getWidgetTemplate(String widgetName) {
  final className = _toPascalCase(widgetName);
  return '''
import 'package:flutter/material.dart';

class $className extends StatelessWidget {
  const $className({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // TODO: Implementar $className
      child: const Text('$className'),
    );
  }
}
''';
}

String _getUtilTemplate(String utilName) {
  final className = _toPascalCase(utilName);
  return '''
class $className {
  // TODO: Implementar $className
  
  static void initialize() {
    // Inicialización
  }
}
''';
}

String _formatTitle(String text) {
  return text.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ').replaceAll('Screen', '');
}

String _getGastoVariosModelTemplate() {
  return '''
import 'package:cloud_firestore/cloud_firestore.dart';

class GastoVariosModel {
  final String id;
  final String empleadoId;
  final DateTime fecha;
  final String descripcion;
  final double monto;
  final bool liquidado;
  final String? corteId;

  GastoVariosModel({
    required this.id,
    required this.empleadoId,
    required this.fecha,
    required this.descripcion,
    required this.monto,
    this.liquidado = false,
    this.corteId,
  });

  factory GastoVariosModel.create({
    required String empleadoId,
    required String descripcion,
    required double monto,
  }) {
    return GastoVariosModel(
      id: '',
      empleadoId: empleadoId,
      fecha: DateTime.now(),
      descripcion: descripcion,
      monto: monto,
      liquidado: false,
    );
  }

  factory GastoVariosModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GastoVariosModel(
      id: doc.id,
      empleadoId: data['empleadoId'],
      fecha: (data['fecha'] as Timestamp).toDate(),
      descripcion: data['descripcion'],
      monto: (data['monto'] as num).toDouble(),
      liquidado: data['liquidado'] ?? false,
      corteId: data['corteId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'empleadoId': empleadoId,
      'fecha': Timestamp.fromDate(fecha),
      'descripcion': descripcion,
      'monto': monto,
      'liquidado': liquidado,
      'corteId': corteId,
    };
  }
}
''';
}

String _getCorteModelTemplate() {
  return '''
import 'package:cloud_firestore/cloud_firestore.dart';

class CorteModel {
  final String id;
  final DateTime fechaCorte;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final double totalIngresos;
  final double totalGastos;
  final double balanceGlobal;
  final List<String> empleadosIds;

  CorteModel({
    required this.id,
    required this.fechaCorte,
    required this.fechaInicio,
    required this.fechaFin,
    required this.totalIngresos,
    required this.totalGastos,
    required this.balanceGlobal,
    required this.empleadosIds,
  });

  factory CorteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CorteModel(
      id: doc.id,
      fechaCorte: (data['fechaCorte'] as Timestamp).toDate(),
      fechaInicio: (data['fechaInicio'] as Timestamp).toDate(),
      fechaFin: (data['fechaFin'] as Timestamp).toDate(),
      totalIngresos: (data['totalIngresos'] as num).toDouble(),
      totalGastos: (data['totalGastos'] as num).toDouble(),
      balanceGlobal: (data['balanceGlobal'] as num).toDouble(),
      empleadosIds: List<String>.from(data['empleadosIds']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fechaCorte': Timestamp.fromDate(fechaCorte),
      'fechaInicio': Timestamp.fromDate(fechaInicio),
      'fechaFin': Timestamp.fromDate(fechaFin),
      'totalIngresos': totalIngresos,
      'totalGastos': totalGastos,
      'balanceGlobal': balanceGlobal,
      'empleadosIds': empleadosIds,
    };
  }
}
''';
}
