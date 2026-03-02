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
  console.log(`🚀 Servidor corriendo en puerto ${PORT}`);
});
