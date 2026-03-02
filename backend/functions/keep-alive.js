const axios = require('axios');

const BACKEND_URL = process.env.BACKEND_URL || 'http://localhost:3000';
const INTERVAL_MINUTES = 10;

async function keepAlive() {
  try {
    const response = await axios.get(`${BACKEND_URL}/keep-alive`);
    console.log('[KEEP-ALIVE] ✓ Server is alive:', response.data);
  } catch (error) {
    console.error('[KEEP-ALIVE] ✗ Error:', error.message);
  }
}

// Ejecutar cada 10 minutos
setInterval(keepAlive, INTERVAL_MINUTES * 60 * 1000);

// Primera ejecución inmediata
keepAlive();

console.log(`[KEEP-ALIVE] Servicio iniciado. Ping cada ${INTERVAL_MINUTES} minutos.`);
