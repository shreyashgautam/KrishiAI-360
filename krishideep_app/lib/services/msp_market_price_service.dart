import '../models/market_price.dart';

class MSPMarketPriceService {
  // MSP Data for 2024-25 (as per government notification)
  static final Map<String, Map<String, dynamic>> _mspData = {
    // KHARIF CROPS
    'PADDY': {
      'Common': {'msp202425': 2300, 'msp202324': 2183, 'season': 'Kharif'},
      'Grade A': {'msp202425': 2320, 'msp202324': 2203, 'season': 'Kharif'},
    },
    'JOWAR': {
      'Hybrid': {'msp202425': 3371, 'msp202324': 3180, 'season': 'Kharif'},
      'Maldandi': {'msp202425': 3421, 'msp202324': 3225, 'season': 'Kharif'},
    },
    'BAJRA': {
      'FAQ': {'msp202425': 2625, 'msp202324': 2500, 'season': 'Kharif'},
    },
    'RAGI': {
      'FAQ': {'msp202425': 4290, 'msp202324': 3846, 'season': 'Kharif'},
    },
    'MAIZE': {
      'FAQ': {'msp202425': 2225, 'msp202324': 2090, 'season': 'Kharif'},
    },
    'TUR (ARHAR)': {
      'FAQ': {'msp202425': 7550, 'msp202324': 7000, 'season': 'Kharif'},
    },
    'MOONG': {
      'FAQ': {'msp202425': 8682, 'msp202324': 8558, 'season': 'Kharif'},
    },
    'URAD': {
      'FAQ': {'msp202425': 7400, 'msp202324': 6950, 'season': 'Kharif'},
    },
    'GROUNDNUT': {
      'FAQ': {'msp202425': 6783, 'msp202324': 6377, 'season': 'Kharif'},
    },
    'SUNFLOWER SEED': {
      'FAQ': {'msp202425': 7280, 'msp202324': 6760, 'season': 'Kharif'},
    },
    'SOYABEAN': {
      'Yellow': {'msp202425': 4892, 'msp202324': 4600, 'season': 'Kharif'},
    },
    'SESAMUM': {
      'FAQ': {'msp202425': 9267, 'msp202324': 8635, 'season': 'Kharif'},
    },
    'NIGERSEED': {
      'FAQ': {'msp202425': 8717, 'msp202324': 7734, 'season': 'Kharif'},
    },
    'COTTON': {
      'Medium Staple': {
        'msp202425': 7121,
        'msp202324': 6620,
        'season': 'Kharif'
      },
      'Long Staple': {'msp202425': 7521, 'msp202324': 7020, 'season': 'Kharif'},
    },

    // RABI CROPS
    'WHEAT': {
      'FAQ': {'msp202425': 2425, 'msp202324': 2275, 'season': 'Rabi'},
    },
    'BARLEY': {
      'FAQ': {'msp202425': 1980, 'msp202324': 1850, 'season': 'Rabi'},
    },
    'GRAM': {
      'FAQ': {'msp202425': 5650, 'msp202324': 5440, 'season': 'Rabi'},
    },
    'MASUR (LENTIL)': {
      'FAQ': {'msp202425': 6700, 'msp202324': 6425, 'season': 'Rabi'},
    },
    'RAPESEED & MUSTARD': {
      'FAQ': {'msp202425': 5950, 'msp202324': 5650, 'season': 'Rabi'},
    },
    'SAFFLOWER': {
      'FAQ': {'msp202425': 5940, 'msp202324': 5800, 'season': 'Rabi'},
    },
    'TORIA': {
      'FAQ': {'msp202425': 5950, 'msp202324': 5650, 'season': 'Rabi'},
    },

    // COMMERCIAL CROPS
    'COPRA': {
      'Milling': {
        'msp202425': 11160,
        'msp202324': 10860,
        'season': 'Commercial'
      },
      'Ball': {'msp202425': 12000, 'msp202324': 11750, 'season': 'Commercial'},
    },
    'DE-HUSKED COCONUT': {
      'FAQ': {'msp202425': 3013, 'msp202324': 2930, 'season': 'Commercial'},
    },
    'JUTE': {
      'FAQ': {'msp202425': 5335, 'msp202324': 5050, 'season': 'Commercial'},
    },
  };

  // Hindi translations
  static final Map<String, String> _cropNamesHindi = {
    'PADDY': 'धान',
    'JOWAR': 'ज्वार',
    'BAJRA': 'बाजरा',
    'RAGI': 'रागी',
    'MAIZE': 'मक्का',
    'TUR (ARHAR)': 'तूर (अरहर)',
    'MOONG': 'मूंग',
    'URAD': 'उड़द',
    'GROUNDNUT': 'मूंगफली',
    'SUNFLOWER SEED': 'सूरजमुखी के बीज',
    'SOYABEAN': 'सोयाबीन',
    'SESAMUM': 'तिल',
    'NIGERSEED': 'नाइजर बीज',
    'COTTON': 'कपास',
    'WHEAT': 'गेहूं',
    'BARLEY': 'जौ',
    'GRAM': 'चना',
    'MASUR (LENTIL)': 'मसूर (दाल)',
    'RAPESEED & MUSTARD': 'सरसों और राई',
    'SAFFLOWER': 'कुसुम',
    'TORIA': 'तोरिया',
    'COPRA': 'खोपरा',
    'DE-HUSKED COCONUT': 'नारियल (छिलका हटा)',
    'JUTE': 'जूट',
  };

  static final Map<String, String> _varietyNamesHindi = {
    'Common': 'सामान्य',
    'Grade A': 'ग्रेड ए',
    'Hybrid': 'संकर',
    'Maldandi': 'मालदंडी',
    'FAQ': 'सामान्य गुणवत्ता',
    'Yellow': 'पीला',
    'Medium Staple': 'मध्यम रेशा',
    'Long Staple': 'लंबा रेशा',
    'Milling': 'पिसाई',
    'Ball': 'गोल',
  };

  static final Map<String, String> _seasonNamesHindi = {
    'Kharif': 'खरीफ',
    'Rabi': 'रबी',
    'Commercial': 'व्यावसायिक',
  };

  // Get all MSP prices
  Future<List<MarketPrice>> getAllMSPPrices() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final prices = <MarketPrice>[];

    _mspData.forEach((crop, varieties) {
      varieties.forEach((variety, data) {
        final msp202425 = data['msp202425'] as int;
        final msp202324 = data['msp202324'] as int;
        final season = data['season'] as String;

        final increase = msp202425 - msp202324;
        final increasePercentage = (increase / msp202324) * 100;

        prices.add(MarketPrice(
          id: '${crop.toLowerCase()}_${variety.toLowerCase()}_msp',
          cropName: crop,
          cropNameHindi: _cropNamesHindi[crop] ?? crop,
          variety: variety,
          varietyHindi: _varietyNamesHindi[variety] ?? variety,
          currentPrice: msp202425.toDouble(),
          previousPrice: msp202324.toDouble(),
          changePercentage: increasePercentage,
          season: season,
          seasonHindi: _seasonNamesHindi[season] ?? season,
          timestamp: DateTime.now(),
          priceUnit: 'per quintal',
          grade: 'MSP',
          isMSP: true,
          msp202425: msp202425.toDouble(),
          msp202324: msp202324.toDouble(),
          mspIncrease: increase.toDouble(),
          mspIncreasePercentage: increasePercentage,
        ));
      });
    });

    return prices;
  }

  // Get MSP prices for specific season
  Future<List<MarketPrice>> getMSPPricesBySeason(String season) async {
    final allPrices = await getAllMSPPrices();
    return allPrices.where((price) => price.season == season).toList();
  }

  // Get MSP prices for specific crop
  Future<List<MarketPrice>> getMSPPricesForCrop(String cropName) async {
    final allPrices = await getAllMSPPrices();
    return allPrices.where((price) => price.cropName == cropName).toList();
  }

  // Get MSP trend analysis
  Future<Map<String, dynamic>> getMSPTrendAnalysis() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final allPrices = await getAllMSPPrices();

    // Calculate statistics
    final totalCrops = allPrices.length;
    final averageIncrease =
        allPrices.map((p) => p.mspIncreasePercentage).reduce((a, b) => a + b) /
            totalCrops;
    final highestIncrease = allPrices
        .map((p) => p.mspIncreasePercentage)
        .reduce((a, b) => a > b ? a : b);
    final lowestIncrease = allPrices
        .map((p) => p.mspIncreasePercentage)
        .reduce((a, b) => a < b ? a : b);

    // Find crops with highest and lowest increases
    final highestIncreaseCrop =
        allPrices.firstWhere((p) => p.mspIncreasePercentage == highestIncrease);
    final lowestIncreaseCrop =
        allPrices.firstWhere((p) => p.mspIncreasePercentage == lowestIncrease);

    // Season-wise analysis
    final kharifCrops = allPrices.where((p) => p.season == 'Kharif').length;
    final rabiCrops = allPrices.where((p) => p.season == 'Rabi').length;
    final commercialCrops =
        allPrices.where((p) => p.season == 'Commercial').length;

    return {
      'totalCrops': totalCrops,
      'averageIncrease': averageIncrease,
      'highestIncrease': {
        'crop': highestIncreaseCrop.cropName,
        'variety': highestIncreaseCrop.variety,
        'increase': highestIncreaseCrop.mspIncrease,
        'increasePercentage': highestIncreaseCrop.mspIncreasePercentage,
      },
      'lowestIncrease': {
        'crop': lowestIncreaseCrop.cropName,
        'variety': lowestIncreaseCrop.variety,
        'increase': lowestIncreaseCrop.mspIncrease,
        'increasePercentage': lowestIncreaseCrop.mspIncreasePercentage,
      },
      'seasonBreakdown': {
        'kharif': kharifCrops,
        'rabi': rabiCrops,
        'commercial': commercialCrops,
      },
      'recommendations': _generateMSPRecommendations(allPrices),
    };
  }

  // Get MSP comparison between years
  Future<Map<String, dynamic>> getMSPYearComparison() async {
    await Future.delayed(const Duration(milliseconds: 400));

    final allPrices = await getAllMSPPrices();

    // Group by crop for comparison
    final Map<String, List<MarketPrice>> cropGroups = {};
    for (final price in allPrices) {
      if (!cropGroups.containsKey(price.cropName)) {
        cropGroups[price.cropName] = [];
      }
      cropGroups[price.cropName]!.add(price);
    }

    final comparison = <Map<String, dynamic>>[];

    cropGroups.forEach((crop, prices) {
      final totalMSP202425 =
          prices.map((p) => p.msp202425).reduce((a, b) => a + b);
      final totalMSP202324 =
          prices.map((p) => p.msp202324).reduce((a, b) => a + b);
      final averageIncrease =
          ((totalMSP202425 - totalMSP202324) / totalMSP202324) * 100;

      comparison.add({
        'crop': crop,
        'cropHindi': _cropNamesHindi[crop] ?? crop,
        'msp202425': totalMSP202425,
        'msp202324': totalMSP202324,
        'increase': totalMSP202425 - totalMSP202324,
        'increasePercentage': averageIncrease,
        'varieties': prices.length,
      });
    });

    // Sort by increase percentage
    comparison.sort(
        (a, b) => b['increasePercentage'].compareTo(a['increasePercentage']));

    return {
      'comparison': comparison,
      'summary': {
        'totalCrops': comparison.length,
        'averageIncrease': comparison
                .map((c) => c['increasePercentage'])
                .reduce((a, b) => a + b) /
            comparison.length,
        'highestIncrease': comparison.first,
        'lowestIncrease': comparison.last,
      },
    };
  }

  // Get MSP alerts and notifications
  Future<List<MSPAlert>> getMSPAlerts() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final allPrices = await getAllMSPPrices();
    final alerts = <MSPAlert>[];

    // Find crops with significant MSP increases
    final significantIncreases =
        allPrices.where((p) => p.mspIncreasePercentage > 10).toList();

    for (final price in significantIncreases) {
      alerts.add(MSPAlert(
        id: 'msp_alert_${price.cropName}_${price.variety}',
        cropName: price.cropName,
        cropNameHindi: price.cropNameHindi,
        variety: price.variety,
        varietyHindi: price.varietyHindi,
        alertType: 'significant_increase',
        title: 'Significant MSP Increase for ${price.cropName}',
        titleHindi: '${price.cropNameHindi} के लिए महत्वपूर्ण MSP वृद्धि',
        message:
            'MSP for ${price.cropName} (${price.variety}) increased by ₹${price.mspIncrease.toInt()} (${price.mspIncreasePercentage.toStringAsFixed(1)}%)',
        messageHindi:
            '${price.cropNameHindi} (${price.varietyHindi}) के लिए MSP ₹${price.mspIncrease.toInt()} (${price.mspIncreasePercentage.toStringAsFixed(1)}%) बढ़ा',
        newMSP: price.msp202425,
        previousMSP: price.msp202324,
        increase: price.mspIncrease,
        increasePercentage: price.mspIncreasePercentage,
        season: price.season,
        seasonHindi: price.seasonHindi,
        createdAt: DateTime.now(),
      ));
    }

    return alerts;
  }

  // Helper method to generate MSP recommendations
  List<String> _generateMSPRecommendations(List<MarketPrice> prices) {
    final recommendations = <String>[];

    // Find crops with highest MSP increases
    final sortedByIncrease = List<MarketPrice>.from(prices);
    sortedByIncrease.sort(
        (a, b) => b.mspIncreasePercentage.compareTo(a.mspIncreasePercentage));

    final topIncrease = sortedByIncrease.take(3).toList();

    recommendations.add(
        'Top MSP increases: ${topIncrease.map((p) => '${p.cropName} (${p.mspIncreasePercentage.toStringAsFixed(1)}%)').join(', ')}');

    // Season-wise recommendations
    final kharifCrops = prices.where((p) => p.season == 'Kharif').toList();
    final rabiCrops = prices.where((p) => p.season == 'Rabi').toList();

    if (kharifCrops.isNotEmpty) {
      final avgKharifIncrease = kharifCrops
              .map((p) => p.mspIncreasePercentage)
              .reduce((a, b) => a + b) /
          kharifCrops.length;
      recommendations.add(
          'Kharif crops average MSP increase: ${avgKharifIncrease.toStringAsFixed(1)}%');
    }

    if (rabiCrops.isNotEmpty) {
      final avgRabiIncrease = rabiCrops
              .map((p) => p.mspIncreasePercentage)
              .reduce((a, b) => a + b) /
          rabiCrops.length;
      recommendations.add(
          'Rabi crops average MSP increase: ${avgRabiIncrease.toStringAsFixed(1)}%');
    }

    return recommendations;
  }
}

// MSP Alert model
class MSPAlert {
  final String id;
  final String cropName;
  final String cropNameHindi;
  final String variety;
  final String varietyHindi;
  final String alertType;
  final String title;
  final String titleHindi;
  final String message;
  final String messageHindi;
  final double newMSP;
  final double previousMSP;
  final double increase;
  final double increasePercentage;
  final String season;
  final String seasonHindi;
  final DateTime createdAt;

  MSPAlert({
    required this.id,
    required this.cropName,
    required this.cropNameHindi,
    required this.variety,
    required this.varietyHindi,
    required this.alertType,
    required this.title,
    required this.titleHindi,
    required this.message,
    required this.messageHindi,
    required this.newMSP,
    required this.previousMSP,
    required this.increase,
    required this.increasePercentage,
    required this.season,
    required this.seasonHindi,
    required this.createdAt,
  });
}
