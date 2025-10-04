import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_tts/flutter_tts.dart';
import '../models/weather.dart';
import '../models/market_price.dart';
import '../models/government_scheme.dart';
import 'weather_service.dart';
import 'market_price_service.dart';
import 'government_scheme_service.dart';

class SimpleVoiceAssistantService {
  static final SimpleVoiceAssistantService _instance =
      SimpleVoiceAssistantService._internal();
  factory SimpleVoiceAssistantService() => _instance;
  SimpleVoiceAssistantService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  String _currentLanguage = 'en';

  // Services
  final WeatherService _weatherService = WeatherService();
  final MarketPriceService _marketPriceService = MarketPriceService();
  final GovernmentSchemeService _governmentSchemeService =
      GovernmentSchemeService();

  // Language configurations
  final Map<String, Map<String, String>> _languageConfig = {
    'en': {
      'locale': 'en_US',
      'language': 'English',
      'code': 'en',
    },
    'hi': {
      'locale': 'hi_IN',
      'language': 'Hindi',
      'code': 'hi',
    },
    'ta': {
      'locale': 'ta_IN',
      'language': 'Tamil',
      'code': 'ta',
    },
  };

  // Response templates
  final Map<String, Map<String, String>> _responses = {
    'en': {
      'greeting':
          'Hello! I am your farming assistant. How can I help you today?',
      'weather_intro': 'Let me check the weather for you.',
      'crop_intro': 'I will provide crop advice based on your needs.',
      'market_intro': 'Let me check the latest market prices.',
      'scheme_intro': 'I will help you find government schemes.',
      'financial_intro': 'I will assist you with financial information.',
      'disease_intro': 'I can help you identify and treat crop diseases.',
      'error': 'Sorry, I did not understand. Could you please repeat?',
      'processing': 'Let me process your request...',
      'no_data': 'Sorry, I could not find the information you requested.',
    },
    'hi': {
      'greeting':
          'नमस्ते! मैं आपका कृषि सहायक हूं। आज मैं आपकी कैसे मदद कर सकता हूं?',
      'weather_intro': 'मैं आपके लिए मौसम की जांच करता हूं।',
      'crop_intro': 'मैं आपकी जरूरतों के आधार पर फसल सलाह दूंगा।',
      'market_intro': 'मैं नवीनतम बाजार कीमतों की जांच करता हूं।',
      'scheme_intro': 'मैं आपको सरकारी योजनाएं खोजने में मदद करूंगा।',
      'financial_intro': 'मैं आपकी वित्तीय जानकारी में मदद करूंगा।',
      'disease_intro':
          'मैं आपको फसल रोगों की पहचान और उपचार में मदद कर सकता हूं।',
      'error': 'क्षमा करें, मैं समझ नहीं पाया। क्या आप दोबारा कह सकते हैं?',
      'processing': 'मैं आपके अनुरोध को संसाधित कर रहा हूं...',
      'no_data': 'क्षमा करें, मुझे आपके द्वारा मांगी गई जानकारी नहीं मिली।',
    },
    'ta': {
      'greeting':
          'வணக்கம்! நான் உங்கள் விவசாய உதவியாளர். இன்று நான் உங்களுக்கு எப்படி உதவ முடியும்?',
      'weather_intro': 'உங்களுக்காக வானிலையை சரிபார்க்கிறேன்.',
      'crop_intro': 'உங்கள் தேவைகளின் அடிப்படையில் பயிர் ஆலோசனை வழங்குவேன்.',
      'market_intro': 'சமீபத்திய சந்தை விலைகளை சரிபார்க்கிறேன்.',
      'scheme_intro': 'அரசு திட்டங்களை கண்டுபிடிக்க உதவுவேன்.',
      'financial_intro': 'நிதி தகவல்களில் உதவுவேன்.',
      'disease_intro':
          'பயிர் நோய்களை அடையாளம் கண்டு சிகிச்சை அளிக்க உதவ முடியும்.',
      'error':
          'மன்னிக்கவும், நான் புரிந்து கொள்ளவில்லை. மீண்டும் சொல்ல முடியுமா?',
      'processing': 'உங்கள் கோரிக்கையை செயலாக்குகிறேன்...',
      'no_data':
          'மன்னிக்கவும், நீங்கள் கேட்ட தகவலை என்னால் கண்டுபிடிக்க முடியவில்லை.',
    },
  };

  // Initialize the voice assistant
  Future<bool> initialize() async {
    try {
      // Initialize text to speech
      await _flutterTts
          .setLanguage(_languageConfig[_currentLanguage]!['locale']!);
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      return true;
    } catch (e) {
      print('Error initializing voice assistant: $e');
      return false;
    }
  }

  // Set language
  Future<void> setLanguage(String languageCode) async {
    if (_languageConfig.containsKey(languageCode)) {
      _currentLanguage = languageCode;
      await _flutterTts.setLanguage(_languageConfig[languageCode]!['locale']!);
    }
  }

  // Simulate voice command processing
  Future<void> processVoiceCommand(String command, Function(String) onResult,
      Function(String) onError) async {
    try {
      // Speak processing message
      await speak(_responses[_currentLanguage]!['processing']!);

      // Simulate processing delay
      await Future.delayed(const Duration(seconds: 1));

      // Determine intent based on command
      String intent = _determineIntent(command.toLowerCase());

      // Process based on intent
      switch (intent) {
        case 'weather':
          await _handleWeatherQuery(onResult, onError);
          break;
        case 'crop_advice':
          await _handleCropAdviceQuery(onResult, onError);
          break;
        case 'market_prices':
          await _handleMarketPricesQuery(onResult, onError);
          break;
        case 'government_schemes':
          await _handleGovernmentSchemesQuery(onResult, onError);
          break;
        case 'financial':
          await _handleFinancialQuery(onResult, onError);
          break;
        case 'disease':
          await _handleDiseaseQuery(onResult, onError);
          break;
        default:
          await _handleGeneralQuery(command, onResult, onError);
      }
    } catch (e) {
      onError('Error processing voice command: $e');
    }
  }

  // Determine intent from voice command
  String _determineIntent(String command) {
    // English patterns
    if (command.contains('weather') ||
        command.contains('forecast') ||
        command.contains('temperature') ||
        command.contains('rain') ||
        command.contains('climate')) {
      return 'weather';
    } else if (command.contains('crop') ||
        command.contains('advice') ||
        command.contains('recommendation') ||
        command.contains('planting') ||
        command.contains('farming')) {
      return 'crop_advice';
    } else if (command.contains('price') ||
        command.contains('market') ||
        command.contains('cost') ||
        command.contains('rate') ||
        command.contains('value')) {
      return 'market_prices';
    } else if (command.contains('scheme') ||
        command.contains('government') ||
        command.contains('subsidy') ||
        command.contains('benefit') ||
        command.contains('help')) {
      return 'government_schemes';
    } else if (command.contains('loan') ||
        command.contains('finance') ||
        command.contains('money') ||
        command.contains('credit') ||
        command.contains('funding')) {
      return 'financial';
    } else if (command.contains('disease') ||
        command.contains('pest') ||
        command.contains('problem') ||
        command.contains('sick') ||
        command.contains('treatment')) {
      return 'disease';
    }

    // Hindi patterns
    if (command.contains('मौसम') ||
        command.contains('तापमान') ||
        command.contains('बारिश') ||
        command.contains('जलवायु') ||
        command.contains('पूर्वानुमान')) {
      return 'weather';
    } else if (command.contains('फसल') ||
        command.contains('सलाह') ||
        command.contains('सुझाव') ||
        command.contains('खेती') ||
        command.contains('बुवाई')) {
      return 'crop_advice';
    } else if (command.contains('कीमत') ||
        command.contains('बाजार') ||
        command.contains('दर') ||
        command.contains('मूल्य') ||
        command.contains('लागत')) {
      return 'market_prices';
    } else if (command.contains('योजना') ||
        command.contains('सरकार') ||
        command.contains('सब्सिडी') ||
        command.contains('लाभ') ||
        command.contains('मदद')) {
      return 'government_schemes';
    } else if (command.contains('कर्ज') ||
        command.contains('वित्त') ||
        command.contains('पैसा') ||
        command.contains('क्रेडिट') ||
        command.contains('फंडिंग')) {
      return 'financial';
    } else if (command.contains('रोग') ||
        command.contains('कीट') ||
        command.contains('समस्या') ||
        command.contains('बीमार') ||
        command.contains('उपचार')) {
      return 'disease';
    }

    // Tamil patterns
    if (command.contains('வானிலை') ||
        command.contains('வெப்பநிலை') ||
        command.contains('மழை') ||
        command.contains('காலநிலை') ||
        command.contains('வானிலை முன்னறிவிப்பு')) {
      return 'weather';
    } else if (command.contains('பயிர்') ||
        command.contains('ஆலோசனை') ||
        command.contains('பரிந்துரை') ||
        command.contains('விவசாயம்') ||
        command.contains('நடவு')) {
      return 'crop_advice';
    } else if (command.contains('விலை') ||
        command.contains('சந்தை') ||
        command.contains('விகிதம்') ||
        command.contains('மதிப்பு') ||
        command.contains('செலவு')) {
      return 'market_prices';
    } else if (command.contains('திட்டம்') ||
        command.contains('அரசு') ||
        command.contains('மானியம்') ||
        command.contains('நன்மை') ||
        command.contains('உதவி')) {
      return 'government_schemes';
    } else if (command.contains('கடன்') ||
        command.contains('நிதி') ||
        command.contains('பணம்') ||
        command.contains('கடன்') ||
        command.contains('நிதியுதவி')) {
      return 'financial';
    } else if (command.contains('நோய்') ||
        command.contains('பூச்சி') ||
        command.contains('பிரச்சினை') ||
        command.contains('நோய்வாய்ப்பட்ட') ||
        command.contains('சிகிச்சை')) {
      return 'disease';
    }

    return 'general';
  }

  // Handle weather queries
  Future<void> _handleWeatherQuery(
      Function(String) onResult, Function(String) onError) async {
    try {
      await speak(_responses[_currentLanguage]!['weather_intro']!);

      final weather = await _weatherService.getCurrentWeather('Land 1');
      final forecast = weather.forecast;

      String response = _formatWeatherResponse(weather, forecast);
      await speak(response);
      onResult(response);
    } catch (e) {
      await speak(_responses[_currentLanguage]!['no_data']!);
      onError('Weather data not available');
    }
  }

  // Handle crop advice queries
  Future<void> _handleCropAdviceQuery(
      Function(String) onResult, Function(String) onError) async {
    try {
      await speak(_responses[_currentLanguage]!['crop_intro']!);

      final advice = await _generateCropAdvice();
      await speak(advice);
      onResult(advice);
    } catch (e) {
      await speak(_responses[_currentLanguage]!['no_data']!);
      onError('Crop advice not available');
    }
  }

  // Handle market prices queries
  Future<void> _handleMarketPricesQuery(
      Function(String) onResult, Function(String) onError) async {
    try {
      await speak(_responses[_currentLanguage]!['market_intro']!);

      final prices = await _marketPriceService.getCurrentMarketPrices();
      String response = _formatMarketPricesResponse(prices);
      await speak(response);
      onResult(response);
    } catch (e) {
      await speak(_responses[_currentLanguage]!['no_data']!);
      onError('Market prices not available');
    }
  }

  // Handle government schemes queries
  Future<void> _handleGovernmentSchemesQuery(
      Function(String) onResult, Function(String) onError) async {
    try {
      await speak(_responses[_currentLanguage]!['scheme_intro']!);

      final schemes = await _governmentSchemeService.getAllSchemes();
      String response = _formatGovernmentSchemesResponse(schemes);
      await speak(response);
      onResult(response);
    } catch (e) {
      await speak(_responses[_currentLanguage]!['no_data']!);
      onError('Government schemes not available');
    }
  }

  // Handle financial queries
  Future<void> _handleFinancialQuery(
      Function(String) onResult, Function(String) onError) async {
    try {
      await speak(_responses[_currentLanguage]!['financial_intro']!);

      final advice = await _generateFinancialAdvice();
      await speak(advice);
      onResult(advice);
    } catch (e) {
      await speak(_responses[_currentLanguage]!['no_data']!);
      onError('Financial advice not available');
    }
  }

  // Handle disease queries
  Future<void> _handleDiseaseQuery(
      Function(String) onResult, Function(String) onError) async {
    try {
      await speak(_responses[_currentLanguage]!['disease_intro']!);

      String response = _formatDiseaseResponse();
      await speak(response);
      onResult(response);
    } catch (e) {
      await speak(_responses[_currentLanguage]!['no_data']!);
      onError('Disease information not available');
    }
  }

  // Handle general queries
  Future<void> _handleGeneralQuery(String command, Function(String) onResult,
      Function(String) onError) async {
    await speak(_responses[_currentLanguage]!['error']!);
    onResult('I did not understand your request. Please try again.');
  }

  // Format weather response
  String _formatWeatherResponse(
      WeatherData weather, List<WeatherForecast> forecast) {
    switch (_currentLanguage) {
      case 'hi':
        return 'वर्तमान तापमान ${weather.temperature.round()} डिग्री सेल्सियस है। मौसम ${weather.conditionHindi} है। आर्द्रता ${weather.humidity.round()} प्रतिशत है।';
      case 'ta':
        return 'தற்போதைய வெப்பநிலை ${weather.temperature.round()} டிகிரி செல்சியஸ். வானிலை ${weather.conditionHindi}. ஈரப்பதம் ${weather.humidity.round()} சதவீதம்.';
      default:
        return 'Current temperature is ${weather.temperature.round()}°C. Weather is ${weather.condition}. Humidity is ${weather.humidity.round()}%.';
    }
  }

  // Format market prices response
  String _formatMarketPricesResponse(List<MarketPrice> prices) {
    if (prices.isEmpty) {
      return _responses[_currentLanguage]!['no_data']!;
    }

    String response = '';
    for (int i = 0; i < math.min(3, prices.length); i++) {
      final price = prices[i];
      switch (_currentLanguage) {
        case 'hi':
          response +=
              '${price.cropName} की कीमत ₹${price.currentPrice} प्रति क्विंटल है। ';
          break;
        case 'ta':
          response +=
              '${price.cropName} விலை ₹${price.currentPrice} குவிண்டலுக்கு. ';
          break;
        default:
          response +=
              '${price.cropName} price is ₹${price.currentPrice} per quintal. ';
      }
    }
    return response;
  }

  // Format government schemes response
  String _formatGovernmentSchemesResponse(List<GovernmentScheme> schemes) {
    if (schemes.isEmpty) {
      return _responses[_currentLanguage]!['no_data']!;
    }

    String response = '';
    for (int i = 0; i < math.min(2, schemes.length); i++) {
      final scheme = schemes[i];
      switch (_currentLanguage) {
        case 'hi':
          response += '${scheme.schemeName} योजना उपलब्ध है। ';
          break;
        case 'ta':
          response += '${scheme.schemeName} திட்டம் கிடைக்கிறது. ';
          break;
        default:
          response += '${scheme.schemeName} scheme is available. ';
      }
    }
    return response;
  }

  // Generate financial advice
  Future<String> _generateFinancialAdvice() async {
    switch (_currentLanguage) {
      case 'hi':
        return 'वित्तीय सलाह उपलब्ध है। कृपया ऐप में वित्तीय सलाह अनुभाग देखें।';
      case 'ta':
        return 'நிதி ஆலோசனை கிடைக்கிறது. தயவுசெய்து ஆப்பில் நிதி ஆலோசனை பிரிவை பாருங்கள்.';
      default:
        return 'Financial advice is available. Please check the financial advisory section in the app.';
    }
  }

  // Format disease response
  String _formatDiseaseResponse() {
    switch (_currentLanguage) {
      case 'hi':
        return 'फसल रोग पहचान के लिए कैमरा का उपयोग करें। रोग की तस्वीर लें और AI विश्लेषण प्राप्त करें।';
      case 'ta':
        return 'பயிர் நோய் அடையாளம் காண கேமராவை பயன்படுத்தவும். நோயின் படத்தை எடுத்து AI பகுப்பாய்வு பெறவும்.';
      default:
        return 'Use the camera for crop disease detection. Take a photo of the disease and get AI analysis.';
    }
  }

  // Generate crop advice
  Future<String> _generateCropAdvice() async {
    final crops = ['Rice', 'Wheat', 'Maize', 'Sugarcane', 'Cotton'];
    final random = math.Random();
    final crop = crops[random.nextInt(crops.length)];

    switch (_currentLanguage) {
      case 'hi':
        return '$crop की खेती के लिए उपयुक्त समय है। मिट्टी की जांच करें और उर्वरक का उपयोग करें।';
      case 'ta':
        return '$crop விவசாயத்திற்கு ஏற்ற நேரம். மண்ணை சரிபார்த்து உரம் பயன்படுத்தவும்.';
      default:
        return 'It is a good time for $crop cultivation. Check soil conditions and use appropriate fertilizers.';
    }
  }

  // Speak text
  Future<void> speak(String text) async {
    if (_isSpeaking) return;

    try {
      _isSpeaking = true;
      await _flutterTts.speak(text);

      // Wait for speech to complete
      await Future.delayed(Duration(seconds: text.length ~/ 10 + 2));
      _isSpeaking = false;
    } catch (e) {
      _isSpeaking = false;
      print('Error speaking: $e');
    }
  }

  // Stop speaking
  Future<void> stopSpeaking() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      _isSpeaking = false;
    }
  }

  // Get current language
  String get currentLanguage => _currentLanguage;

  // Check if speaking
  bool get isSpeaking => _isSpeaking;

  // Get available languages
  List<String> get availableLanguages => _languageConfig.keys.toList();

  // Get language name
  String getLanguageName(String code) {
    return _languageConfig[code]?['language'] ?? code;
  }
}
