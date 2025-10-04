import 'dart:math' as math;
import '../models/financial_advisory.dart';

class FinancialAdvisoryService {
  // Mock database
  static final List<LoanApplication> _loanApplications = [];
  static final List<InsurancePlan> _insurancePlans = [];
  static final List<CostBenefitAnalysis> _analyses = [];
  static final List<FinancialAdvisory> _advisories = [];
  static final List<FinancialGoal> _financialGoals = [];

  // Loan Services
  Future<LoanEligibility> checkLoanEligibility(
    String farmerId,
    String loanType,
    double requestedAmount,
    Map<String, dynamic> farmerProfile,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    final random = math.Random();

    // Calculate eligibility score based on farmer profile
    double score = 50.0; // Base score

    // Farm size factor
    final farmSize = (farmerProfile['farmSize'] ?? 1.0) as double;
    if (farmSize > 5.0)
      score += 15.0;
    else if (farmSize > 2.0)
      score += 10.0;
    else if (farmSize > 1.0) score += 5.0;

    // Annual income factor
    final annualIncome = (farmerProfile['annualIncome'] ?? 100000.0) as double;
    if (annualIncome > 500000.0)
      score += 15.0;
    else if (annualIncome > 200000.0)
      score += 10.0;
    else if (annualIncome > 100000.0) score += 5.0;

    // Credit history factor
    final creditScore = farmerProfile['creditScore'] ?? 'fair';
    switch (creditScore) {
      case 'excellent':
        score += 20.0;
        break;
      case 'good':
        score += 15.0;
        break;
      case 'fair':
        score += 8.0;
        break;
      case 'poor':
        score -= 10.0;
        break;
    }

    // Existing loans factor
    final existingLoans = (farmerProfile['existingLoans'] ?? 0.0) as double;
    if (existingLoans > 100000.0)
      score -= 10.0;
    else if (existingLoans > 0.0) score -= 5.0;

    // Random adjustment for realism
    score += random.nextDouble() * 10.0 - 5.0; // -5 to +5

    score = math.max(
        0.0, math.min(100.0, score)); // Ensure score is between 0 and 100

    final isEligible = score > 60.0;
    final maxAmount = _calculateMaxLoanAmount(loanType, farmSize, annualIncome);

    return LoanEligibility(
      farmerId: farmerId,
      loanType: loanType,
      isEligible: isEligible,
      eligibilityScore: score,
      maxEligibleAmount: maxAmount,
      recommendedAmount: math.min(requestedAmount, maxAmount * 0.8),
      suggestedInterestRate: _getSuggestedInterestRate(loanType, score),
      recommendedTenureMonths: _getRecommendedTenure(loanType, requestedAmount),
      eligibleCriteria: _getEligibleCriteria(farmerProfile, score),
      eligibleCriteriaHindi: _getEligibleCriteriaHindi(farmerProfile, score),
      ineligibleCriteria: _getIneligibleCriteria(farmerProfile, score),
      ineligibleCriteriaHindi:
          _getIneligibleCriteriaHindi(farmerProfile, score),
      improvementSuggestions: _getImprovementSuggestions(farmerProfile, score),
      improvementSuggestionsHindi:
          _getImprovementSuggestionsHindi(farmerProfile, score),
      assessmentDetails: {
        'farmSizeScore': farmSize > 2.0 ? 'Good' : 'Average',
        'incomeScore': annualIncome > 200000.0 ? 'Good' : 'Average',
        'creditScore': creditScore,
        'repaymentCapacity':
            '${((annualIncome * 0.3) / 12.0).toStringAsFixed(0)} per month',
      },
      requiredDocuments: _getRequiredDocuments(loanType),
      requiredDocumentsHindi: _getRequiredDocumentsHindi(loanType),
      bankRecommendations: {
        'primary': 'State Bank of India',
        'secondary': 'HDFC Bank',
        'government': 'NABARD',
      },
    );
  }

  Future<List<FinancialAdvisory>> getPersonalizedAdvisory(
    String farmerId,
    Map<String, dynamic> farmerProfile,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    // Mock data generation based on profile
    final advisories = <FinancialAdvisory>[];

    // Example: Loan advisory
    if ((farmerProfile['existingLoans'] ?? 0.0) < 100000.0) {
      advisories.add(
        FinancialAdvisory(
          id: 'ADVISORY_LOAN_001',
          farmerId: farmerId,
          advisoryType: 'loan',
          title: 'Explore Government Crop Loans',
          titleHindi: 'सरकारी फसल ऋणों का अन्वेषण करें',
          advice:
              'Consider applying for low-interest government crop loans to manage your seasonal expenses and boost productivity.',
          adviceHindi:
              'अपने मौसमी खर्चों का प्रबंधन करने और उत्पादकता बढ़ाने के लिए कम ब्याज वाले सरकारी फसल ऋणों के लिए आवेदन करने पर विचार करें।',
          actionItems: [
            'Check eligibility for Kisan Credit Card',
            'Visit nearest agricultural bank branch',
            'Prepare land ownership documents'
          ],
          actionItemsHindi: [
            'किसान क्रेडिट कार्ड के लिए पात्रता जांचें',
            'निकटतम कृषि बैंक शाखा पर जाएँ',
            'भूमि स्वामित्व दस्तावेज तैयार करें'
          ],
          priority: 'high',
          generatedAt: DateTime.now().subtract(const Duration(days: 5)),
          financialData: {
            'estimatedLoanAmount': 100000.0,
            'interestRate': 7.5,
            'tenure': 60,
          },
        ),
      );
    }

    return advisories;
  }

  Future<List<LoanApplication>> getLoanApplications(String farmerId) async {
    await Future.delayed(const Duration(seconds: 1));
    return _loanApplications.where((app) => app.farmerId == farmerId).toList();
  }

  Future<LoanApplication> applyForLoan(
    String farmerId,
    String farmerName,
    String farmerNameHindi,
    String loanType,
    double requestedAmount,
    String purpose,
    String purposeHindi,
    double farmSize,
    double annualIncome,
    String creditScore,
    List<String> collaterals,
    List<String> collateralsHindi,
    Map<String, dynamic> financialDetails,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    final newApplication = LoanApplication(
      id: 'LOAN_${DateTime.now().millisecondsSinceEpoch}',
      farmerId: farmerId,
      farmerName: farmerName,
      farmerNameHindi: farmerNameHindi,
      loanType: loanType,
      requestedAmount: requestedAmount,
      purpose: purpose,
      purposeHindi: purposeHindi,
      applicationDate: DateTime.now(),
      status: 'pending',
      farmSize: farmSize,
      annualIncome: annualIncome,
      creditScore: creditScore,
      collaterals: collaterals,
      collateralsHindi: collateralsHindi,
      financialDetails: {
        'monthlyIncome': (financialDetails['annualIncome'] ?? 100000.0) / 12.0,
        'existingLoans': financialDetails['existingLoans'] ?? 0.0,
        'assets': financialDetails['assets'] ?? {},
        'expenses': financialDetails['expenses'] ?? {},
      },
    );
    _loanApplications.add(newApplication);
    return newApplication;
  }

  Future<List<InsurancePlan>> getInsurancePlans() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      InsurancePlan(
        id: 'INS_001',
        planName: 'Pradhan Mantri Fasal Bima Yojana (PMFBY)',
        planNameHindi: 'प्रधानमंत्री फसल बीमा योजना (पीएमएफबीवाई)',
        category: 'Crop Insurance',
        provider: 'Government of India',
        providerHindi: 'भारत सरकार',
        description: 'Comprehensive crop insurance scheme covering natural calamities and yield losses',
        descriptionHindi: 'प्राकृतिक आपदाओं और उपज हानि को कवर करने वाली व्यापक फसल बीमा योजना',
        premiumAmount: 500.0, // per acre
        coverageAmount: 50000.0, // per acre
        coveragePeriod: 'Seasonal',
        coverageDetails: [
          'Covers yield losses due to natural calamities',
          'Post-harvest losses covered',
          'Localized calamities covered'
        ],
        coverageDetailsHindi: [
          'प्राकृतिक आपदाओं के कारण उपज के नुकसान को कवर करता है',
          'फसल कटाई के बाद के नुकसान को कवर किया गया',
          'स्थानीय आपदाओं को कवर किया गया'
        ],
        exclusions: [
          'War and nuclear risks',
          'Intentional damage',
          'Pre-existing conditions'
        ],
        exclusionsHindi: [
          'युद्ध और परमाणु जोखिम',
          'जानबूझकर नुकसान',
          'पूर्व-मौजूदा स्थितियां'
        ],
        claimProcess: 'Report loss within 72 hours, submit claim form with documents, survey by insurance company, settlement within 15 days',
        claimProcessHindi: '72 घंटे के भीतर नुकसान की रिपोर्ट करें, दस्तावेजों के साथ दावा फॉर्म जमा करें, बीमा कंपनी द्वारा सर्वेक्षण, 15 दिनों के भीतर निपटान',
        subsidyPercentage: 50.0,
        isGovernmentScheme: true,
        eligibilityCriteria: {
          'farmer_registration': 'Must be a registered farmer',
          'land_ownership': 'Land ownership documents required',
          'minimum_land': 'Minimum 1 acre of land'
        },
        requiredDocuments: [
          'Land ownership documents',
          'Identity proof',
          'Bank account details',
          'Crop cultivation certificate'
        ],
        requiredDocumentsHindi: [
          'भूमि स्वामित्व दस्तावेज',
          'पहचान प्रमाण',
          'बैंक खाता विवरण',
          'फसल खेती प्रमाण पत्र'
        ],
      ),
    ];
  }

  Future<Map<String, dynamic>> calculateInsurancePremium(
    String planId,
    double farmSize,
    Map<String, dynamic> farmerProfile,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    final plan = _insurancePlans.firstWhere((p) => p.id == planId);
    final random = math.Random();

    final basePremium = plan.premiumAmount * farmSize;
    final riskMultiplier = 0.8 + random.nextDouble() * 0.4; // 0.8 to 1.2
    final calculatedPremium = basePremium * riskMultiplier;
    final subsidizedPremium =
        calculatedPremium * (1.0 - plan.subsidyPercentage / 100.0);

    return {
      'planId': planId,
      'planName': plan.planName,
      'basePremium': basePremium,
      'calculatedPremium': calculatedPremium,
      'subsidyPercentage': plan.subsidyPercentage,
      'finalPremium': subsidizedPremium,
      'coverageAmount': plan.coverageAmount * farmSize,
      'coveragePeriod': plan.coveragePeriod,
      'paymentSchedule': {
        'annual': subsidizedPremium,
        'semiAnnual': subsidizedPremium / 2.0 * 1.02,
        'quarterly': subsidizedPremium / 4.0 * 1.05,
      },
    };
  }

  Future<CostBenefitAnalysis> performCostBenefitAnalysis(
    String farmerId,
    String cropType,
    double farmSize,
    Map<String, double> inputCosts,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    final random = math.Random();

    final totalInputCost =
        inputCosts.values.fold(0.0, (sum, cost) => sum + cost) * farmSize;
    final expectedYield = _getExpectedYield(cropType) *
        farmSize *
        (0.8 + random.nextDouble() * 0.4); // +/- 20% variation
    final expectedMarketPrice = _getCurrentMarketPrice(cropType) *
        (0.9 + random.nextDouble() * 0.2); // +/- 10% variation
    final expectedRevenue = expectedYield * expectedMarketPrice;
    final expectedProfit = expectedRevenue - totalInputCost;
    final profitMargin = (expectedProfit / expectedRevenue) * 100.0;

    return CostBenefitAnalysis(
      id: 'CBA_${DateTime.now().millisecondsSinceEpoch}',
      farmerId: farmerId,
      cropType: cropType,
      cropTypeHindi: _getCropTypeHindi(cropType),
      farmSize: farmSize,
      season: 'Kharif',
      analysisDate: DateTime.now(),
      inputCosts: inputCosts,
      inputCostsPerAcre: inputCosts,
      totalInputCost: totalInputCost,
      expectedYield: expectedYield,
      expectedMarketPrice: expectedMarketPrice,
      expectedRevenue: expectedRevenue,
      expectedProfit: expectedProfit,
      profitMarginPercentage: profitMargin,
      breakEvenPrice: totalInputCost / expectedYield,
      riskFactors: {
        'market_volatility': 'High price fluctuations in crop markets',
        'weather_risk': 'Unpredictable weather conditions affecting yield',
        'pest_disease': 'Potential pest and disease outbreaks',
        'input_cost': 'Fluctuating input costs (seeds, fertilizers)'
      },
      recommendations: [
        'Consider crop rotation to improve soil health',
        'Explore government subsidies for input costs',
        'Monitor market prices for optimal selling time'
      ],
      recommendationsHindi: [
        'मिट्टी के स्वास्थ्य में सुधार के लिए फसल चक्र पर विचार करें',
        'इनपुट लागत के लिए सरकारी सब्सिडी का अन्वेषण करें',
        'इष्टतम बिक्री समय के लिए बाजार मूल्यों की निगरानी करें'
      ],
      scenarioAnalysis: {
        'optimistic': expectedProfit * 1.3,
        'realistic': expectedProfit,
        'pessimistic': expectedProfit * 0.7,
      },
      subsidyBenefits: {
        'fertilizerSubsidy': inputCosts['fertilizer'] != null
            ? inputCosts['fertilizer']! * 0.15
            : 0.0,
        'seedSubsidy':
            inputCosts['seeds'] != null ? inputCosts['seeds']! * 0.1 : 0.0,
        'equipmentSubsidy': 5000.0,
      },
    );
  }

  Future<List<FinancialGoal>> getFinancialGoals(String farmerId) async {
    await Future.delayed(const Duration(seconds: 1));
    return _financialGoals.where((goal) => goal.farmerId == farmerId).toList();
  }

  Future<FinancialGoal> addFinancialGoal(
    String farmerId,
    String goalName,
    String goalNameHindi,
    double targetAmount,
    DateTime targetDate,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final goalId = 'GOAL_${DateTime.now().millisecondsSinceEpoch}';
    final monthsToTarget = targetDate.difference(DateTime.now()).inDays / 30.0;
    final monthlySaving = targetAmount / monthsToTarget;

    final goal = FinancialGoal(
      id: goalId,
      farmerId: farmerId,
      goalType: 'savings',
      title: goalName,
      titleHindi: goalNameHindi,
      description: 'Financial goal for $goalName',
      descriptionHindi: '$goalNameHindi के लिए वित्तीय लक्ष्य',
      targetAmount: targetAmount,
      targetDate: targetDate,
      createdAt: DateTime.now(),
      status: 'active',
      currentProgress: 0.0, // Starts at 0
      monthlySavingRequired: double.parse(monthlySaving.toStringAsFixed(2)),
      milestones: _generateMilestones(targetAmount),
      milestonesHindi: _generateMilestonesHindi(targetAmount),
      actionPlan: {
        'step1': 'Set up automatic savings',
        'step2': 'Review progress monthly',
        'step3': 'Adjust strategy if needed'
      },
      strategies: [
        'Cut unnecessary expenses',
        'Increase income sources',
        'Invest in low-risk options'
      ],
      strategiesHindi: [
        'अनावश्यक खर्चों में कटौती करें',
        'आय के स्रोत बढ़ाएं',
        'कम जोखिम वाले विकल्पों में निवेश करें'
      ],
    );
    _financialGoals.add(goal);
    return goal;
  }

  Future<Map<String, dynamic>> getFinancialDashboard(String farmerId) async {
    await Future.delayed(const Duration(seconds: 1));
    final random = math.Random();

    return {
      'totalAssets': 500000.0 + random.nextDouble() * 1000000.0,
      'totalLiabilities': 50000.0 + random.nextDouble() * 200000.0,
      'netWorth': 450000.0 + random.nextDouble() * 800000.0,
      'monthlyIncome': 25000.0 + random.nextDouble() * 50000.0,
      'monthlyExpenses': 18000.0 + random.nextDouble() * 30000.0,
      'savings': 7000.0 + random.nextDouble() * 20000.0,
      'activeLoans': _loanApplications
          .where((l) => l.farmerId == farmerId && l.status == 'disbursed')
          .length
          .toDouble(),
      'insuranceCoverage': 200000.0 + random.nextDouble() * 500000.0,
      'creditScore': (650 + random.nextInt(200)).toDouble(),
      'financialHealthScore': (70 + random.nextInt(25)).toDouble(),
      'monthlyTrends': {
        'income': List.generate(
            6, (index) => 20000.0 + random.nextDouble() * 30000.0),
        'expenses': List.generate(
            6, (index) => 15000.0 + random.nextDouble() * 25000.0),
        'savings':
            List.generate(6, (index) => 5000.0 + random.nextDouble() * 15000.0),
      },
      'upcomingPayments': [
        {
          'type': 'Loan EMI',
          'amount': 8500.0,
          'dueDate': DateTime.now().add(const Duration(days: 15)),
        },
        {
          'type': 'Insurance Premium',
          'amount': 12000.0,
          'dueDate': DateTime.now().add(const Duration(days: 30)),
        },
      ],
      'recentTransactions': [
        {
          'type': 'Income',
          'amount': 45000.0,
          'date': DateTime.now().subtract(const Duration(days: 5)),
          'description': 'Crop Sale - Wheat',
        },
        {
          'type': 'Expense',
          'amount': 15000.0,
          'date': DateTime.now().subtract(const Duration(days: 10)),
          'description': 'Fertilizer Purchase',
        },
      ],
    };
  }

  // Private helper methods
  double _calculateMaxLoanAmount(
      String loanType, double farmSize, double annualIncome) {
    final baseMultiplier = {
          'crop_loan': 2.0,
          'farm_equipment': 5.0,
          'infrastructure': 10.0,
          'kisan_credit_card': 1.5,
        }[loanType] ??
        2.0;

    return math.min(
      annualIncome * baseMultiplier,
      farmSize * 100000.0, // ₹1 lakh per acre max
    );
  }

  double _getSuggestedInterestRate(String loanType, double eligibilityScore) {
    double baseRate = {
          'crop_loan': 7.0,
          'farm_equipment': 8.5,
          'infrastructure': 9.0,
          'kisan_credit_card': 7.5,
        }[loanType] ??
        8.0;

    // Adjust based on eligibility score
    if (eligibilityScore > 80.0)
      baseRate -= 0.5;
    else if (eligibilityScore < 60.0) baseRate += 1.0;

    return baseRate;
  }

  int _getRecommendedTenure(String loanType, double amount) {
    if (amount < 100000.0) return 24;
    if (amount < 500000.0) return 48;
    return 60;
  }

  List<String> _getEligibleCriteria(
      Map<String, dynamic> profile, double score) {
    final criteria = <String>[];
    if ((profile['farmSize'] ?? 0.0) > 1.0)
      criteria.add('Owns agricultural land');
    if ((profile['annualIncome'] ?? 0.0) > 100000.0)
      criteria.add('Adequate annual income');
    if (profile['creditScore'] != 'poor') criteria.add('Good credit history');
    return criteria;
  }

  List<String> _getEligibleCriteriaHindi(
      Map<String, dynamic> profile, double score) {
    final criteria = <String>[];
    if ((profile['farmSize'] ?? 0.0) > 1.0)
      criteria.add('कृषि भूमि का स्वामित्व');
    if ((profile['annualIncome'] ?? 0.0) > 100000.0)
      criteria.add('पर्याप्त वार्षिक आय');
    if (profile['creditScore'] != 'poor') criteria.add('अच्छा क्रेडिट इतिहास');
    return criteria;
  }

  List<String> _getIneligibleCriteria(
      Map<String, dynamic> profile, double score) {
    final criteria = <String>[];
    if ((profile['farmSize'] ?? 0.0) <= 1.0)
      criteria.add('Insufficient farm size');
    if ((profile['annualIncome'] ?? 0.0) <= 100000.0)
      criteria.add('Low annual income');
    if (profile['creditScore'] == 'poor') criteria.add('Poor credit history');
    return criteria;
  }

  List<String> _getIneligibleCriteriaHindi(
      Map<String, dynamic> profile, double score) {
    final criteria = <String>[];
    if ((profile['farmSize'] ?? 0.0) <= 1.0)
      criteria.add('अपर्याप्त खेत का आकार');
    if ((profile['annualIncome'] ?? 0.0) <= 100000.0)
      criteria.add('कम वार्षिक आय');
    if (profile['creditScore'] == 'poor') criteria.add('खराब क्रेडिट इतिहास');
    return criteria;
  }

  List<String> _getImprovementSuggestions(
      Map<String, dynamic> profile, double score) {
    final suggestions = <String>[];
    if (score < 70.0) {
      suggestions.add('Maintain regular income records');
      suggestions.add('Clear any pending loan dues');
      suggestions.add('Consider a co-applicant');
    }
    return suggestions;
  }

  List<String> _getImprovementSuggestionsHindi(
      Map<String, dynamic> profile, double score) {
    final suggestions = <String>[];
    if (score < 70.0) {
      suggestions.add('नियमित आय रिकॉर्ड बनाए रखें');
      suggestions.add('किसी भी लंबित ऋण बकाया को साफ करें');
      suggestions.add('सह-आवेदक पर विचार करें');
    }
    return suggestions;
  }

  List<String> _getRequiredDocuments(String loanType) {
    return [
      'Land ownership documents',
      'Income certificate',
      'Bank statements (6 months)',
      'Identity proof',
      'Address proof',
    ];
  }

  List<String> _getRequiredDocumentsHindi(String loanType) {
    return [
      'भूमि स्वामित्व दस्तावेज',
      'आय प्रमाण पत्र',
      'बैंक स्टेटमेंट (6 महीने)',
      'पहचान प्रमाण',
      'पता प्रमाण',
    ];
  }

  List<String> _getApplicationProcess(String loanType) {
    return [
      'Submit application form',
      'Attach required documents',
      'Verification by bank',
      'Approval and disbursement',
    ];
  }

  List<String> _getApplicationProcessHindi(String loanType) {
    return [
      'आवेदन पत्र जमा करें',
      'आवश्यक दस्तावेज संलग्न करें',
      'बैंक द्वारा सत्यापन',
      'अनुमोदन और वितरण',
    ];
  }

  List<String> _getApplicationTimeline(String loanType) {
    return [
      'Application submission: Day 1',
      'Document verification: 3-5 days',
      'Approval decision: 7-10 days',
      'Disbursement: 2-3 days after approval',
    ];
  }

  List<String> _getApplicationTimelineHindi(String loanType) {
    return [
      'आवेदन जमा: दिन 1',
      'दस्तावेज सत्यापन: 3-5 दिन',
      'अनुमोदन निर्णय: 7-10 दिन',
      'वितरण: अनुमोदन के 2-3 दिन बाद',
    ];
  }

  List<String> _getNextSteps(bool isEligible, double score) {
    if (isEligible) {
      return [
        'Gather required documents',
        'Visit nearest bank branch',
        'Submit loan application',
        'Follow up on application status',
      ];
    } else {
      return [
        'Improve credit score',
        'Increase farm size or income',
        'Clear existing debts',
        'Reapply after improvements',
      ];
    }
  }

  List<String> _getNextStepsHindi(bool isEligible, double score) {
    if (isEligible) {
      return [
        'आवश्यक दस्तावेज एकत्र करें',
        'निकटतम बैंक शाखा पर जाएं',
        'ऋण आवेदन जमा करें',
        'आवेदन स्थिति का अनुसरण करें',
      ];
    } else {
      return [
        'क्रेडिट स्कोर में सुधार करें',
        'खेत का आकार या आय बढ़ाएं',
        'मौजूदा ऋण साफ करें',
        'सुधार के बाद पुन: आवेदन करें',
      ];
    }
  }

  String _getEstimatedProcessingTime(String loanType) {
    return '7-15 business days';
  }

  String _getEstimatedProcessingTimeHindi(String loanType) {
    return '7-15 कार्य दिवस';
  }

  String _getContactInformation(String loanType) {
    return 'Contact your nearest agricultural bank branch or call 1800-XXX-XXXX';
  }

  String _getContactInformationHindi(String loanType) {
    return 'अपनी निकटतम कृषि बैंक शाखा से संपर्क करें या 1800-XXX-XXXX पर कॉल करें';
  }

  List<String> _getAdditionalBenefits(String loanType) {
    return [
      'Low interest rates',
      'Flexible repayment options',
      'Government subsidy available',
      'No prepayment penalty',
    ];
  }

  List<String> _getAdditionalBenefitsHindi(String loanType) {
    return [
      'कम ब्याज दरें',
      'लचीली चुकौती विकल्प',
      'सरकारी सब्सिडी उपलब्ध',
      'पूर्व भुगतान जुर्माना नहीं',
    ];
  }

  List<String> _getRiskFactors(Map<String, dynamic> profile, double score) {
    final risks = <String>[];
    if (score < 70.0) risks.add('Higher interest rates');
    if ((profile['existingLoans'] ?? 0.0) > 100000.0)
      risks.add('High debt burden');
    if ((profile['farmSize'] ?? 0.0) < 2.0) risks.add('Limited collateral');
    return risks;
  }

  List<String> _getRiskFactorsHindi(
      Map<String, dynamic> profile, double score) {
    final risks = <String>[];
    if (score < 70.0) risks.add('उच्च ब्याज दरें');
    if ((profile['existingLoans'] ?? 0.0) > 100000.0) risks.add('उच्च ऋण बोझ');
    if ((profile['farmSize'] ?? 0.0) < 2.0) risks.add('सीमित संपार्श्विक');
    return risks;
  }

  List<String> _getMitigationStrategies(
      Map<String, dynamic> profile, double score) {
    final strategies = <String>[];
    if (score < 70.0) strategies.add('Improve credit score before applying');
    if ((profile['existingLoans'] ?? 0.0) > 100000.0)
      strategies.add('Consider debt consolidation');
    if ((profile['farmSize'] ?? 0.0) < 2.0)
      strategies.add('Provide additional collateral');
    return strategies;
  }

  List<String> _getMitigationStrategiesHindi(
      Map<String, dynamic> profile, double score) {
    final strategies = <String>[];
    if (score < 70.0)
      strategies.add('आवेदन से पहले क्रेडिट स्कोर में सुधार करें');
    if ((profile['existingLoans'] ?? 0.0) > 100000.0)
      strategies.add('ऋण समेकन पर विचार करें');
    if ((profile['farmSize'] ?? 0.0) < 2.0)
      strategies.add('अतिरिक्त संपार्श्विक प्रदान करें');
    return strategies;
  }

  double _getExpectedYield(String cropType) {
    switch (cropType.toLowerCase()) {
      case 'wheat':
        return 2500.0; // kg per acre
      case 'rice':
        return 3000.0; // kg per acre
      case 'corn':
        return 4000.0; // kg per acre
      case 'cotton':
        return 400.0; // kg per acre
      case 'sugarcane':
        return 80000.0; // kg per acre
      default:
        return 1000.0;
    }
  }

  double _getCurrentMarketPrice(String cropType) {
    switch (cropType.toLowerCase()) {
      case 'wheat':
        return 25.0; // ₹ per kg
      case 'rice':
        return 30.0; // ₹ per kg
      case 'corn':
        return 20.0; // ₹ per kg
      case 'cotton':
        return 60.0; // ₹ per kg
      case 'sugarcane':
        return 3.0; // ₹ per kg
      default:
        return 15.0;
    }
  }

  double _calculateEMI(double principal, double rate, int months) {
    final monthlyRate = rate / (12.0 * 100.0);
    final emi = (principal * monthlyRate * math.pow(1 + monthlyRate, months)) /
        (math.pow(1 + monthlyRate, months) - 1);
    return emi;
  }

  List<String> _generateMilestones(double targetAmount) {
    return [
      'Save ${(targetAmount * 0.25).toStringAsFixed(0)} (25%)',
      'Save ${(targetAmount * 0.50).toStringAsFixed(0)} (50%)',
      'Save ${(targetAmount * 0.75).toStringAsFixed(0)} (75%)',
      'Achieve target amount',
    ];
  }

  List<String> _generateMilestonesHindi(double targetAmount) {
    return [
      '${(targetAmount * 0.25).toStringAsFixed(0)} बचाएं (25%)',
      '${(targetAmount * 0.50).toStringAsFixed(0)} बचाएं (50%)',
      '${(targetAmount * 0.75).toStringAsFixed(0)} बचाएं (75%)',
      'लक्ष्य राशि प्राप्त करें',
    ];
  }

  int _getPriorityOrder(String priority) {
    switch (priority) {
      case 'urgent':
        return 1;
      case 'high':
        return 2;
      case 'medium':
        return 3;
      case 'low':
        return 4;
      default:
        return 5;
    }
  }

  String _getCropTypeHindi(String cropType) {
    switch (cropType.toLowerCase()) {
      case 'wheat':
        return 'गेहूं';
      case 'rice':
        return 'धान';
      case 'corn':
        return 'मक्का';
      case 'cotton':
        return 'कपास';
      case 'sugarcane':
        return 'गन्ना';
      case 'potato':
        return 'आलू';
      case 'tomato':
        return 'टमाटर';
      default:
        return cropType;
    }
  }
}
