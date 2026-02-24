const express = require('express');
const admin = require('firebase-admin');
const cron = require('node-cron');
require('dotenv').config();

// ===== INICIALIZAR FIREBASE =====
let serviceAccount;
try {
  serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
} catch (error) {
  console.error('❌ Error parseando FIREBASE_SERVICE_ACCOUNT:', error);
  process.exit(1);
}

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

// ===== ENDPOINTS =====

// Health Check
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    service: 'Logistics Delivery System - Backend',
    version: '1.0.0',
    uptime: process.uptime(),
  });
});

// ⭐ KEEP-ALIVE - Mantiene Render despierto
app.get('/keep-alive', (req, res) => {
  console.log('[KEEP-ALIVE] ✓ Ping recibido en', new Date().toISOString());
  res.json({
    status: 'alive',
    timestamp: new Date().toISOString(),
    message: 'Server is awake and running',
  });
});

// Status del servicio
app.get('/status', (req, res) => {
  res.json({
    status: 'running',
    cronSchedule: '0 2 1 */3 *',
    cronDescription: 'Limpieza automática cada 3 meses',
    nextCronRun: 'Primer día de cada trimestre a las 2:00 AM',
    collections: [
      'ingresos',
      'gastos_combustible',
      'mantenimiento_aceite',
      'gastos_varios'
    ],
    keepAlive: {
      endpoint: '/keep-alive',
      recommendation: 'Configure cron-job.org para hacer ping cada 10 minutos'
    }
  });
});

// ===== FUNCIÓN DE LIMPIEZA AUTOMÁTICA =====
async function limpiarDatosAntiguos() {
  const startTime = Date.now();
  
  try {
    console.log('[CLEANUP] ========================================');
    console.log('[CLEANUP] Iniciando limpieza de datos antiguos...');
    console.log('[CLEANUP] Fecha:', new Date().toISOString());
    
    // Calcular fecha límite (3 meses atrás)
    const tresMesesAtras = new Date();
    tresMesesAtras.setMonth(tresMesesAtras.getMonth() - 3);
    
    console.log('[CLEANUP] Fecha límite:', tresMesesAtras.toISOString());
    console.log('[CLEANUP] Se eliminarán registros liquidados anteriores a esta fecha');
    
    const colecciones = [
      'ingresos',
      'gastos_combustible',
      'mantenimiento_aceite',
      'gastos_varios'
    ];
    
    let totalEliminados = 0;
    const resumenPorColeccion = {};
    
    for (const coleccion of colecciones) {
      console.log(`[CLEANUP] Procesando colección: ${coleccion}...`);
      
      // Buscar documentos antiguos y liquidados
      const snapshot = await db.collection(coleccion)
        .where('liquidado', '==', true)
        .where('timestamp', '<', admin.firestore.Timestamp.fromDate(tresMesesAtras))
        .get();
      
      console.log(`[CLEANUP] Documentos encontrados en ${coleccion}: ${snapshot.size}`);
      
      if (snapshot.size === 0) {
        resumenPorColeccion[coleccion] = 0;
        continue;
      }
      
      // Eliminar en lotes (máximo 500 por batch)
      const batch = db.batch();
      let count = 0;
      let batchCount = 0;
      
      for (const doc of snapshot.docs) {
        batch.delete(doc.ref);
        count++;
        
        if (count % 500 === 0) {
          await batch.commit();
          batchCount++;
          console.log(`[CLEANUP] Batch ${batchCount} completado (${count} documentos)`);
        }
      }
      
      // Commit documentos restantes
      if (count % 500 !== 0) {
        await batch.commit();
        console.log(`[CLEANUP] Batch final completado`);
      }
      
      totalEliminados += count;
      resumenPorColeccion[coleccion] = count;
      console.log(`[CLEANUP] ✓ Eliminados ${count} registros de ${coleccion}`);
    }
    
    const duration = ((Date.now() - startTime) / 1000).toFixed(2);
    
    console.log('[CLEANUP] ========================================');
    console.log(`[CLEANUP] Limpieza completada en ${duration}s`);
    console.log(`[CLEANUP] Total eliminados: ${totalEliminados}`);
    console.log('[CLEANUP] Resumen:', resumenPorColeccion);
    console.log('[CLEANUP] ========================================');
    
    // Guardar log en Firestore
    await db.collection('cleanup_logs').add({
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      registrosEliminados: totalEliminados,
      resumenPorColeccion: resumenPorColeccion,
      duracionSegundos: parseFloat(duration),
      fechaLimite: admin.firestore.Timestamp.fromDate(tresMesesAtras),
      status: 'success'
    });
    
    return {
      success: true,
      totalEliminados,
      resumenPorColeccion,
      duracionSegundos: parseFloat(duration)
    };
    
  } catch (error) {
    console.error('[CLEANUP] ❌ Error durante la limpieza:', error);
    
    // Guardar log de error
    await db.collection('cleanup_logs').add({
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      error: error.message,
      errorStack: error.stack,
      status: 'failed'
    });
    
    throw error;
  }
}

// ===== CRON JOB - Limpieza cada 3 meses =====
// Ejecutar: primer día del trimestre a las 2:00 AM
cron.schedule('0 2 1 */3 *', () => {
  console.log('[CRON] ⏰ Ejecutando limpieza trimestral automática...');
  limpiarDatosAntiguos()
    .then(result => {
      console.log('[CRON] ✓ Limpieza completada:', result);
    })
    .catch(error => {
      console.error('[CRON] ❌ Error en limpieza automática:', error);
    });
}, {
  timezone: "America/Mexico_City" // Ajustar según tu zona horaria
});

console.log('[CRON] ✓ Tarea programada: Limpieza cada 3 meses');
console.log('[CRON] Próxima ejecución: Primer día del próximo trimestre a las 2:00 AM');

// ===== ENDPOINT MANUAL DE LIMPIEZA (PROTEGIDO) =====
app.post('/cleanup', async (req, res) => {
  const apiKey = req.headers['x-api-key'];
  
  if (apiKey !== process.env.ADMIN_API_KEY) {
    console.log('[CLEANUP] ❌ Intento de acceso no autorizado');
    return res.status(401).json({
      error: 'No autorizado',
      message: 'Se requiere una API Key válida'
    });
  }
  
  console.log('[CLEANUP] Limpieza manual iniciada por admin');
  
  try {
    const result = await limpiarDatosAntiguos();
    res.json({
      success: true,
      message: 'Limpieza completada exitosamente',
      ...result
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message,
      message: 'Error durante la limpieza'
    });
  }
});

// ===== VER LOGS DE LIMPIEZA =====
app.get('/cleanup/logs', async (req, res) => {
  const apiKey = req.headers['x-api-key'];
  
  if (apiKey !== process.env.ADMIN_API_KEY) {
    return res.status(401).json({ error: 'No autorizado' });
  }
  
  try {
    const limit = parseInt(req.query.limit) || 10;
    const snapshot = await db.collection('cleanup_logs')
      .orderBy('timestamp', 'desc')
      .limit(limit)
      .get();
    
    const logs = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data(),
      timestamp: doc.data().timestamp?.toDate().toISOString()
    }));
    
    res.json({ logs });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ===== 404 Handler =====
app.use((req, res) => {
  res.status(404).json({
    error: 'Endpoint no encontrado',
    availableEndpoints: [
      'GET /health',
      'GET /keep-alive',
      'GET /status',
      'POST /cleanup (requiere API Key)',
      'GET /cleanup/logs (requiere API Key)'
    ]
  });
});

// ===== INICIAR SERVIDOR =====
app.listen(PORT, () => {
  console.log('========================================');
  console.log('🚀 BACKEND - LOGISTICS DELIVERY SYSTEM');
  console.log(`📡 Puerto: ${PORT}`);
  console.log(`⏰ Cron Job: Activo`);
  console.log(`📅 Frecuencia: Cada 3 meses`);
  console.log(`⭐ Keep-Alive: /keep-alive`);
  console.log(`🔐 API Key: ${process.env.ADMIN_API_KEY ? 'Configurada ✓' : '⚠️ NO CONFIGURADA'}`);
  console.log('========================================');
  console.log('');
  console.log('💡 TIP: Configura un cron job en cron-job.org');
  console.log('   para hacer ping a /keep-alive cada 10 minutos');
  console.log('   y mantener el servidor despierto en Render.');
  console.log('========================================');
});

// ===== GRACEFUL SHUTDOWN =====
process.on('SIGTERM', () => {
  console.log('[SERVER] SIGTERM recibido, cerrando servidor...');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('[SERVER] SIGINT recibido, cerrando servidor...');
  process.exit(0);
});
