// Simple CORS Proxy Server
// Deploy this to Heroku, Vercel, or any Node.js hosting service

const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

// Enable CORS for all routes
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Accept'],
  credentials: true
}));

// Handle preflight requests
app.options('*', cors());

// Proxy configuration
const proxyOptions = {
  target: 'https://backend-krisi-ml.onrender.com',
  changeOrigin: true,
  pathRewrite: {
    '^/api/ml': '' // Remove /api/ml prefix when forwarding to target
  },
  onProxyReq: (proxyReq, req, res) => {
    // Add CORS headers to the proxied request
    proxyReq.setHeader('Access-Control-Allow-Origin', '*');
    proxyReq.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    proxyReq.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  },
  onProxyRes: (proxyRes, req, res) => {
    // Add CORS headers to the response
    proxyRes.headers['Access-Control-Allow-Origin'] = '*';
    proxyRes.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS';
    proxyRes.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization';
  }
};

// Create proxy middleware for ML API
const mlProxy = createProxyMiddleware('/api/ml', proxyOptions);

// Create proxy middleware for main API
const mainProxy = createProxyMiddleware('/api/main', {
  target: 'https://backend-krisi.onrender.com',
  changeOrigin: true,
  pathRewrite: {
    '^/api/main': '' // Remove /api/main prefix when forwarding to target
  },
  onProxyReq: (proxyReq, req, res) => {
    proxyReq.setHeader('Access-Control-Allow-Origin', '*');
    proxyReq.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    proxyReq.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  },
  onProxyRes: (proxyRes, req, res) => {
    proxyRes.headers['Access-Control-Allow-Origin'] = '*';
    proxyRes.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS';
    proxyRes.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization';
  }
});

// Use the proxy middleware
app.use(mlProxy);
app.use(mainProxy);

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    message: 'CORS Proxy Server is running'
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'CORS Proxy Server for Krisi Deep App',
    endpoints: {
      'ML API': '/api/ml/predict',
      'Main API': '/api/main/soildata/insert',
      'Health': '/health'
    },
    usage: {
      'ML Prediction': 'POST /api/ml/predict',
      'Insert Soil Data': 'POST /api/main/soildata/insert',
      'Get All Soil Data': 'GET /api/main/soildata/all',
      'Get Latest Soil Data': 'GET /api/main/soildata/latest'
    }
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Proxy Error:', err);
  res.status(500).json({
    error: 'Internal Server Error',
    message: err.message
  });
});

// Start the server
app.listen(PORT, () => {
  console.log(`CORS Proxy Server running on port ${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/health`);
  console.log(`ML API proxy: http://localhost:${PORT}/api/ml/predict`);
  console.log(`Main API proxy: http://localhost:${PORT}/api/main/soildata/insert`);
});

module.exports = app;
