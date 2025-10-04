import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class FinancialAdvisoryScreenSimple extends StatefulWidget {
  const FinancialAdvisoryScreenSimple({super.key});

  @override
  State<FinancialAdvisoryScreenSimple> createState() =>
      _FinancialAdvisoryScreenSimpleState();
}

class _FinancialAdvisoryScreenSimpleState
    extends State<FinancialAdvisoryScreenSimple> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('financial_advisory'.tr()),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'dashboard'.tr()),
            Tab(text: 'loans'.tr()),
            Tab(text: 'insurance'.tr()),
            Tab(text: 'goals'.tr()),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboard(),
          _buildLoans(),
          _buildInsurance(),
          _buildGoals(),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            'Total Assets',
            '₹5,00,000',
            Icons.account_balance_wallet_outlined,
            Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Active Loans',
            '₹50,000',
            Icons.credit_card_outlined,
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Insurance Coverage',
            '₹2,00,000',
            Icons.security_outlined,
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Monthly Income',
            '₹15,000',
            Icons.trending_up_outlined,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildLoans() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLoanCard(
            'Kisan Credit Card',
            '₹1,00,000',
            'Approved',
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildLoanCard(
            'Crop Loan',
            '₹50,000',
            'Pending',
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildLoanCard(
            'Equipment Loan',
            '₹75,000',
            'Under Review',
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildInsurance() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInsuranceCard(
            'PMFBY - Paddy',
            '₹25,000',
            'Active',
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildInsuranceCard(
            'Livestock Insurance',
            '₹15,000',
            'Active',
            Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildInsuranceCard(
            'Equipment Insurance',
            '₹10,000',
            'Expired',
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildGoals() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGoalCard(
            'New Tractor',
            '₹3,00,000',
            '75%',
            Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildGoalCard(
            'Farm Expansion',
            '₹5,00,000',
            '40%',
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildGoalCard(
            'Education Fund',
            '₹1,00,000',
            '90%',
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanCard(
      String title, String amount, String status, Color statusColor) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Track'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsuranceCard(
      String title, String amount, String status, Color statusColor) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Renew'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(
      String title, String amount, String progress, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: double.parse(progress.replaceAll('%', '')) / 100,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  progress,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Update'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
