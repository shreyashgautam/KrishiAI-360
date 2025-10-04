import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'iot_dashboard_screen.dart';
import 'analytics_dashboard_screen.dart';
import 'government_schemes_screen.dart';
import 'financial_advisory_screen_simple.dart';
import 'farmer_community_screen.dart';
import 'crop_advice_screen.dart';
import 'disease_detection_screen.dart';
import 'knowledge_screen.dart';
import 'weather_screen.dart';
import 'msp_market_prices_screen.dart';
import 'search_screen.dart';
import 'notifications_screen.dart';
import '../widgets/image_carousel.dart';
import '../widgets/voice_command_button.dart';
import '../services/notification_service.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({super.key});

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew> {
  final ScrollController _scrollController = ScrollController();
  final NotificationService _notificationService = NotificationService();
  bool _isLoading = true;
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    // Simulate loading time
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initialize();
    final hasPermission =
        await _notificationService.isNotificationPermissionGranted();
    if (hasPermission) {
      await _notificationService.startRandomNotifications();
      setState(() {
        _notificationsEnabled = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _notificationService.stopRandomNotifications();
    super.dispose();
  }

  String _getLocalizedAppName() {
    return 'app_name'.tr();
  }

  void _handleVoiceCommand(String command) {
    // Handle voice commands - the command now contains the full response from voice assistant
    _showSnackBar(command);

    // Check if the response contains navigation keywords
    if (command.toLowerCase().contains('crop') ||
        command.toLowerCase().contains('फसल') ||
        command.toLowerCase().contains('பயிர்')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CropAdviceScreen()),
      );
    } else if (command.toLowerCase().contains('weather') ||
        command.toLowerCase().contains('मौसम') ||
        command.toLowerCase().contains('வானிலை')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WeatherScreen()),
      );
    } else if (command.toLowerCase().contains('scheme') ||
        command.toLowerCase().contains('योजना') ||
        command.toLowerCase().contains('திட்டம்')) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const GovernmentSchemesScreen()),
      );
    } else if (command.toLowerCase().contains('financial') ||
        command.toLowerCase().contains('वित्त') ||
        command.toLowerCase().contains('நிதி')) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const FinancialAdvisoryScreenSimple()),
      );
    } else if (command.toLowerCase().contains('disease') ||
        command.toLowerCase().contains('रोग') ||
        command.toLowerCase().contains('நோய்')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DiseaseDetectionScreen()),
      );
    } else if (command.toLowerCase().contains('market') ||
        command.toLowerCase().contains('बाजार') ||
        command.toLowerCase().contains('சந்தை')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MSPMarketPricesScreen()),
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleTheme() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingScreen()
            : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // Header Section
                    _buildHeader(),

                    // Image Carousel
                    _buildImageCarousel(),

                    // Categories Section
                    _buildCategoriesSection(),

                    // Recent Activity
                    _buildRecentActivity(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
      floatingActionButton: VoiceCommandButton(
        onVoiceResult: _handleVoiceCommand,
        onStartListening: () => _showSnackBar('listening'.tr()),
        onStopListening: () => _showSnackBar('processing'.tr()),
        languageCode: context.locale.languageCode,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green.shade600, Colors.green.shade800],
        ),
      ),
      child: Column(
        children: [
          // Top Row
          Row(
            children: [
              // App Logo
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/krisi_deep_logo.png',
                    fit: BoxFit.contain,
                    width: 32,
                    height: 32,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // App Name
              Expanded(
                child: Text(
                  _getLocalizedAppName(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              // Theme Toggle, Search, Notification Controls and Notifications
              Row(
                children: [
                  // Theme Toggle
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return IconButton(
                        onPressed: _toggleTheme,
                        icon: Icon(
                          themeProvider.isDarkMode
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                          color: Colors.white,
                        ),
                        tooltip: themeProvider.isDarkMode
                            ? 'light_mode'.tr()
                            : 'dark_mode'.tr(),
                      );
                    },
                  ),
                  // Search
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchScreen()),
                    ),
                    icon:
                        const Icon(Icons.search_outlined, color: Colors.white),
                  ),
                  // Single Notifications Button
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        ),
                        icon: Icon(
                          _notificationsEnabled
                              ? Icons.notifications_active
                              : Icons.notifications_outlined,
                          color: _notificationsEnabled
                              ? Colors.green
                              : Colors.white,
                        ),
                        tooltip: 'notifications'.tr(),
                      ),
                      if (_notificationService.unreadCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: ImageCarousel(
        imagePaths: [
          'assets/images/image1sc.png',
          'assets/images/image2sc.png',
          'assets/images/image3sc.png',
          'assets/images/image4sc.png',
          'assets/images/image5sc.png',
        ],
        autoScrollDuration: const Duration(seconds: 5),
        height: 180,
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Farming Tools (formerly Quick Actions) - 2 items per row
          _buildFarmingToolsSection(),

          const SizedBox(height: 16),

          // Analytics & Monitoring
          _buildCategorySection(
            'analytics_monitoring'.tr(),
            [
              _buildServiceItem(
                  'iot_dashboard'.tr(),
                  Icons.dashboard_outlined,
                  Colors.blue,
                  () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const IoTDashboardScreen()),
                      )),
              _buildServiceItem(
                  'analytics'.tr(),
                  Icons.analytics_outlined,
                  Colors.purple,
                  () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AnalyticsDashboardScreen()),
                      )),
            ],
          ),

          const SizedBox(height: 16),

          // Government & Finance
          _buildCategorySection(
            'government_finance'.tr(),
            [
              _buildServiceItem(
                  'govt_schemes'.tr(),
                  Icons.account_balance_outlined,
                  Colors.green,
                  () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const GovernmentSchemesScreen()),
                      )),
              _buildServiceItem(
                  'financial_advisory'.tr(),
                  Icons.account_balance_wallet_outlined,
                  Colors.orange,
                  () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const FinancialAdvisoryScreenSimple()),
                      )),
            ],
          ),

          const SizedBox(height: 16),

          // Community & Support
          _buildCategorySection(
            'community_support'.tr(),
            [
              _buildServiceItem(
                  'farmer_community'.tr(),
                  Icons.forum_outlined,
                  Colors.teal,
                  () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const FarmerCommunityScreen()),
                      )),
              _buildServiceItem(
                  'knowledge_base'.tr(),
                  Icons.school_outlined,
                  Colors.indigo,
                  () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const KnowledgeScreen()),
                      )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: items,
        ),
      ],
    );
  }

  Widget _buildServiceItem(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'recent_activity'.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildActivityItem(
                  'crop_recommendation'.tr(),
                  'rice_cultivation_advice'.tr(),
                  Icons.agriculture,
                  Colors.green,
                  '2 ${'hours_ago'.tr()}',
                ),
                const Divider(),
                _buildActivityItem(
                  'weather_alert'.tr(),
                  'rain_expected'.tr(),
                  Icons.wb_cloudy,
                  Colors.blue,
                  '5 ${'hours_ago'.tr()}',
                ),
                const Divider(),
                _buildActivityItem(
                  'government_scheme'.tr(),
                  'pm_kisan_approved'.tr(),
                  Icons.account_balance,
                  Colors.orange,
                  '1 ${'day_ago'.tr()}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
      String title, String subtitle, IconData icon, Color color, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading...',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmingToolsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'farming_tools'.tr(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 6), // Reduced spacing
        // First row - 2 items
        Row(
          children: [
            Expanded(
              child: _buildServiceItem(
                  'crop_advice'.tr(),
                  Icons.agriculture_outlined,
                  Colors.green,
                  () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CropAdviceScreen()),
                      )),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildServiceItem(
                  'disease_detection'.tr(),
                  Icons.bug_report_outlined,
                  Colors.red,
                  () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const DiseaseDetectionScreen()),
                      )),
            ),
          ],
        ),
        const SizedBox(height: 6), // Reduced spacing
        // Second row - 2 items
        Row(
          children: [
            Expanded(
              child: _buildServiceItem(
                  'weather'.tr(),
                  Icons.wb_sunny_outlined,
                  Colors.orange,
                  () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WeatherScreen()),
                      )),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildServiceItem(
                  'market_prices'.tr(),
                  Icons.trending_up_outlined,
                  Colors.blue,
                  () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MSPMarketPricesScreen()),
                      )),
            ),
          ],
        ),
      ],
    );
  }
}
