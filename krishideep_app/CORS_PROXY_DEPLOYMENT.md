# CORS Proxy Deployment Guide

This guide helps you deploy a CORS proxy server to resolve CORS issues with your backend APIs.

## Quick Deployment Options

### Option 1: Deploy to Heroku (Recommended)

1. **Install Heroku CLI** (if not already installed):
   ```bash
   # macOS
   brew install heroku/brew/heroku
   
   # Or download from https://devcenter.heroku.com/articles/heroku-cli
   ```

2. **Login to Heroku**:
   ```bash
   heroku login
   ```

3. **Create a new Heroku app**:
   ```bash
   heroku create your-cors-proxy-name
   ```

4. **Deploy the proxy**:
   ```bash
   git init
   git add .
   git commit -m "Initial CORS proxy deployment"
   git push heroku main
   ```

5. **Your proxy will be available at**:
   ```
   https://your-cors-proxy-name.herokuapp.com
   ```

### Option 2: Deploy to Vercel

1. **Install Vercel CLI**:
   ```bash
   npm i -g vercel
   ```

2. **Deploy**:
   ```bash
   vercel
   ```

3. **Follow the prompts** and your proxy will be deployed.

### Option 3: Deploy to Railway

1. **Go to** [railway.app](https://railway.app)
2. **Connect your GitHub repository**
3. **Select the CORS proxy files**
4. **Deploy automatically**

## Update Your Flutter App

After deploying the CORS proxy, update your Flutter app to use it:

### 1. Update Enhanced Soil Data Service

Replace the proxy URLs in `lib/services/enhanced_soil_data_service.dart`:

```dart
class EnhancedSoilDataService {
  // Replace with your deployed proxy URL
  static const String proxyBaseUrl = 'https://your-cors-proxy-name.herokuapp.com';
  static const String baseUrl = 'https://backend-krisi.onrender.com';
  static const String predictionUrl = 'https://backend-krisi-ml.onrender.com';
  
  // Update the proxy methods to use your deployed proxy
  static Future<http.Response> _makeRequestThroughProxy(
    String targetUrl,
    {String method = 'GET', Map<String, String>? headers, String? body}
  ) async {
    // Use your deployed proxy
    final proxyUrl = '$proxyBaseUrl/api/main$targetUrl';
    // ... rest of the implementation
  }
}
```

### 2. Update API Endpoints

In your Flutter app, the proxy will handle these endpoints:

- **ML Prediction**: `https://your-proxy.herokuapp.com/api/ml/predict`
- **Insert Soil Data**: `https://your-proxy.herokuapp.com/api/main/soildata/insert`
- **Get All Soil Data**: `https://your-proxy.herokuapp.com/api/main/soildata/all`
- **Get Latest Soil Data**: `https://your-proxy.herokuapp.com/api/main/soildata/latest`

## Testing the Proxy

### 1. Health Check
```bash
curl https://your-cors-proxy-name.herokuapp.com/health
```

### 2. Test ML Prediction
```bash
curl -X POST https://your-cors-proxy-name.herokuapp.com/api/ml/predict \
  -H "Content-Type: application/json" \
  -d '{
    "N": 110,
    "P": 115,
    "K": 120,
    "temperature": 18,
    "humidity": 100,
    "ph": 1.8,
    "rainfall": 20,
    "soil_moisture_avg": 20
  }'
```

### 3. Test Soil Data Insert
```bash
curl -X POST https://your-cors-proxy-name.herokuapp.com/api/main/soildata/insert \
  -H "Content-Type: application/json" \
  -d '{
    "N": 50.0,
    "P": 30.0,
    "K": 20.0,
    "temperature": 25.5,
    "humidity": 70.2,
    "ph": 6.5,
    "rainfall": 120.3,
    "soil_moisture_avg": 35.0
  }'
```

## Alternative Solutions

### 1. Use Public CORS Proxies (Not Recommended for Production)

You can use public CORS proxy services, but they're not reliable for production:

```dart
static const List<String> _publicProxies = [
  'https://cors-anywhere.herokuapp.com/',
  'https://api.allorigins.win/raw?url=',
  'https://thingproxy.freeboard.io/fetch/',
];
```

### 2. Configure Backend CORS Headers

If you control the backend, add these headers to your backend server:

```javascript
// Express.js example
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Accept']
}));
```

### 3. Use Flutter Web with Different Build Configuration

For Flutter web, you can also try:

```bash
flutter build web --web-renderer html --release
```

## Troubleshooting

### Common Issues:

1. **Proxy not responding**: Check if the proxy server is running
2. **Still getting CORS errors**: Make sure you're using the proxy URLs in your Flutter app
3. **Timeout errors**: The proxy might be slow, consider using a faster hosting service

### Debug Steps:

1. **Check proxy health**: Visit `https://your-proxy-url/health`
2. **Test with curl**: Use the curl commands above
3. **Check Flutter logs**: Look for CORS-related errors in the console
4. **Verify URLs**: Make sure all URLs in your Flutter app point to the proxy

## Security Considerations

- The proxy is configured to allow all origins (`*`) for development
- For production, consider restricting origins to your specific domains
- Monitor proxy usage to prevent abuse
- Consider implementing rate limiting

## Cost Considerations

- **Heroku**: Free tier available, but with limitations
- **Vercel**: Free tier with generous limits
- **Railway**: Free tier available
- **AWS/GCP**: More expensive but more reliable

Choose based on your needs and budget.
