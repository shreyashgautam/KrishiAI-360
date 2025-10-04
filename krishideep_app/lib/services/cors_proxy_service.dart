import 'package:http/http.dart' as http;

class CORSProxyService {
  // List of CORS proxy services (free public proxies)
  static const List<String> _proxyUrls = [
    'https://cors-anywhere.herokuapp.com/',
    'https://api.allorigins.win/raw?url=',
    'https://thingproxy.freeboard.io/fetch/',
  ];

  static int _currentProxyIndex = 0;

  // Method to make requests through CORS proxy
  static Future<http.Response> makeRequestThroughProxy(
    String targetUrl, {
    String method = 'GET',
    Map<String, String>? headers,
    String? body,
  }) async {
    for (int i = 0; i < _proxyUrls.length; i++) {
      try {
        final proxyUrl = _proxyUrls[_currentProxyIndex];
        final fullUrl = '$proxyUrl$targetUrl';

        print('Trying proxy: $proxyUrl');

        http.Response response;
        if (method == 'POST') {
          response = await http.post(
            Uri.parse(fullUrl),
            headers: headers,
            body: body,
          );
        } else {
          response = await http.get(
            Uri.parse(fullUrl),
            headers: headers,
          );
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Success with proxy: ${_proxyUrls[_currentProxyIndex]}');
          return response;
        }
      } catch (e) {
        print('Proxy ${_proxyUrls[_currentProxyIndex]} failed: $e');
      }

      // Try next proxy
      _currentProxyIndex = (_currentProxyIndex + 1) % _proxyUrls.length;
    }

    throw Exception('All CORS proxies failed');
  }

  // Alternative: Use a custom proxy endpoint
  static Future<http.Response> makeRequestWithCustomProxy(
    String targetUrl, {
    String method = 'GET',
    Map<String, String>? headers,
    String? body,
  }) async {
    // You can deploy your own CORS proxy or use a service like:
    // https://github.com/Rob--W/cors-anywhere
    const customProxyUrl = 'https://your-cors-proxy.herokuapp.com/';

    final fullUrl = '$customProxyUrl$targetUrl';

    if (method == 'POST') {
      return await http.post(
        Uri.parse(fullUrl),
        headers: headers,
        body: body,
      );
    } else {
      return await http.get(
        Uri.parse(fullUrl),
        headers: headers,
      );
    }
  }

  // Method to test if direct connection works
  static Future<bool> testDirectConnection(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Direct connection failed: $e');
      return false;
    }
  }

  // Method to get the best available proxy
  static Future<String?> getBestProxy() async {
    for (final proxyUrl in _proxyUrls) {
      try {
        final testUrl = '${proxyUrl}https://httpbin.org/get';
        final response = await http.get(
          Uri.parse(testUrl),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          print('Working proxy found: $proxyUrl');
          return proxyUrl;
        }
      } catch (e) {
        print('Proxy $proxyUrl not working: $e');
      }
    }
    return null;
  }
}
