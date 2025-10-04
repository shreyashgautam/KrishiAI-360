import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/market_price.dart';
import '../services/msp_market_price_service.dart';

class MSPMarketPricesScreen extends StatefulWidget {
  const MSPMarketPricesScreen({super.key});

  @override
  State<MSPMarketPricesScreen> createState() => _MSPMarketPricesScreenState();
}

class _MSPMarketPricesScreenState extends State<MSPMarketPricesScreen>
    with TickerProviderStateMixin {
  final MSPMarketPriceService _mspService = MSPMarketPriceService();

  late TabController _tabController;
  List<MarketPrice> _mspPrices = [];
  Map<String, dynamic> _trendAnalysis = {};
  Map<String, dynamic> _yearComparison = {};
  List<MSPAlert> _alerts = [];

  bool _isLoading = true;
  String _selectedSeason = 'All';
  String _selectedCrop = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadMSPData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMSPData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prices = await _mspService.getAllMSPPrices();
      final trendAnalysis = await _mspService.getMSPTrendAnalysis();
      final yearComparison = await _mspService.getMSPYearComparison();
      final alerts = await _mspService.getMSPAlerts();

      setState(() {
        _mspPrices = prices;
        _trendAnalysis = trendAnalysis;
        _yearComparison = yearComparison;
        _alerts = alerts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${'error'.tr()}: $e')),
      );
    }
  }

  List<MarketPrice> get _filteredPrices {
    var filtered = _mspPrices;

    if (_selectedSeason != 'All') {
      filtered = filtered.where((p) => p.season == _selectedSeason).toList();
    }

    if (_selectedCrop != 'All') {
      filtered = filtered.where((p) => p.cropName == _selectedCrop).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('msp_market_prices'.tr()),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'msp_prices'.tr(), icon: const Icon(Icons.price_check)),
            Tab(
                text: 'trend_analysis'.tr(),
                icon: const Icon(Icons.trending_up)),
            Tab(text: 'year_comparison'.tr(), icon: const Icon(Icons.compare)),
            Tab(text: 'alerts'.tr(), icon: const Icon(Icons.notifications)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildMSPPricesTab(),
                _buildTrendAnalysisTab(),
                _buildYearComparisonTab(),
                _buildAlertsTab(),
              ],
            ),
    );
  }

  Widget _buildMSPPricesTab() {
    return Column(
      children: [
        _buildFilters(),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredPrices.length,
            itemBuilder: (context, index) {
              final price = _filteredPrices[index];
              return _buildMSPPriceCard(price);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedSeason,
              decoration: const InputDecoration(
                labelText: 'Season',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: [
                'All',
                'Kharif',
                'Rabi',
                'Commercial',
              ]
                  .map((season) => DropdownMenuItem(
                        value: season,
                        child: Text(season),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSeason = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedCrop,
              decoration: const InputDecoration(
                labelText: 'Crop',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: [
                'All',
                ..._mspPrices.map((p) => p.cropName).toSet().toList(),
              ]
                  .map((crop) => DropdownMenuItem(
                        value: crop,
                        child: Text(crop),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCrop = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMSPPriceCard(MarketPrice price) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        price.cropName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        price.cropNameHindi,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (price.variety.isNotEmpty)
                        Text(
                          '${price.variety} (${price.varietyHindi})',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSeasonColor(price.season),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    price.season,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MSP 2024-25',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '₹${price.msp202425.toInt()}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MSP 2023-24',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '₹${price.msp202324.toInt()}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Increase',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.trending_up,
                          color: Colors.green[600],
                          size: 16,
                        ),
                        Text(
                          '₹${price.mspIncrease.toInt()}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[600],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '(${price.mspIncreasePercentage.toStringAsFixed(1)}%)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendAnalysisTab() {
    if (_trendAnalysis.isEmpty) {
      return Center(child: Text('no_trend_data'.tr()));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTrendCard(
            'Overall Statistics',
            [
              'Total Crops: ${_trendAnalysis['totalCrops']}',
              'Average Increase: ${_trendAnalysis['averageIncrease']?.toStringAsFixed(1)}%',
            ],
            Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildTrendCard(
            'Highest MSP Increase',
            [
              'Crop: ${_trendAnalysis['highestIncrease']?['crop']}',
              'Variety: ${_trendAnalysis['highestIncrease']?['variety']}',
              'Increase: ₹${_trendAnalysis['highestIncrease']?['increase']}',
              'Percentage: ${_trendAnalysis['highestIncrease']?['increasePercentage']?.toStringAsFixed(1)}%',
            ],
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildTrendCard(
            'Lowest MSP Increase',
            [
              'Crop: ${_trendAnalysis['lowestIncrease']?['crop']}',
              'Variety: ${_trendAnalysis['lowestIncrease']?['variety']}',
              'Increase: ₹${_trendAnalysis['lowestIncrease']?['increase']}',
              'Percentage: ${_trendAnalysis['lowestIncrease']?['increasePercentage']?.toStringAsFixed(1)}%',
            ],
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildTrendCard(
            'Season Breakdown',
            [
              'Kharif Crops: ${_trendAnalysis['seasonBreakdown']?['kharif']}',
              'Rabi Crops: ${_trendAnalysis['seasonBreakdown']?['rabi']}',
              'Commercial Crops: ${_trendAnalysis['seasonBreakdown']?['commercial']}',
            ],
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildYearComparisonTab() {
    if (_yearComparison.isEmpty) {
      return Center(child: Text('no_comparison_data'.tr()));
    }

    final comparison = _yearComparison['comparison'] as List<dynamic>? ?? [];
    final summary = _yearComparison['summary'] as Map<String, dynamic>? ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTrendCard(
            'Summary',
            [
              'Total Crops: ${summary['totalCrops']}',
              'Average Increase: ${summary['averageIncrease']?.toStringAsFixed(1)}%',
            ],
            Colors.blue,
          ),
          const SizedBox(height: 16),
          const Text(
            'Crop-wise Comparison',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...comparison.map((crop) => _buildComparisonCard(crop)).toList(),
        ],
      ),
    );
  }

  Widget _buildAlertsTab() {
    if (_alerts.isEmpty) {
      return Center(child: Text('no_alerts_available'.tr()));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _alerts.length,
      itemBuilder: (context, index) {
        final alert = _alerts[index];
        return _buildAlertCard(alert);
      },
    );
  }

  Widget _buildTrendCard(String title, List<String> items, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            ...items
                .map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(item),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonCard(Map<String, dynamic> crop) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crop['crop'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    crop['cropHindi'] ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${crop['msp202425']?.toInt()}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  '+₹${crop['increase']?.toInt()} (${crop['increasePercentage']?.toStringAsFixed(1)}%)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(MSPAlert alert) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_active,
                  color: Colors.orange[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    alert.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              alert.message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${alert.cropName} (${alert.variety})',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '₹${alert.newMSP.toInt()}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeasonColor(String season) {
    switch (season) {
      case 'Kharif':
        return Colors.green;
      case 'Rabi':
        return Colors.blue;
      case 'Commercial':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
