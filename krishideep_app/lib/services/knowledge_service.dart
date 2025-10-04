import '../models/faq.dart';

class KnowledgeService {
  // Comprehensive FAQ data
  static final List<FAQ> _faqs = [
    // General Farming
    FAQ(
      id: '1',
      question: 'What is the best time to plant crops?',
      questionHindi: 'फसल बोने का सबसे अच्छा समय कौन सा है?',
      answer:
          'The best time to plant crops depends on the crop type and local climate. Generally, Kharif crops are planted during monsoon season (June-July), and Rabi crops are planted in winter season (November-December).',
      answerHindi:
          'फसल बोने का सबसे अच्छा समय फसल के प्रकार और स्थानीय जलवायु पर निर्भर करता है। आमतौर पर, खरीफ फसलें मानसून के मौसम में (जून-जुलाई) और रबी फसलें सर्दियों के मौसम में (नवंबर-दिसंबर) बोई जाती हैं।',
      category: 'General',
    ),
    FAQ(
      id: '2',
      question: 'How do I choose the right crop for my land?',
      questionHindi: 'मैं अपनी जमीन के लिए सही फसल कैसे चुनूं?',
      answer:
          'Consider soil type, climate, water availability, market demand, and your experience. Test your soil, check local weather patterns, and research which crops grow well in your region. Start with crops you have knowledge about.',
      answerHindi:
          'मिट्टी के प्रकार, जलवायु, पानी की उपलब्धता, बाजार की मांग, और अपने अनुभव पर विचार करें। अपनी मिट्टी का परीक्षण करें, स्थानीय मौसम के पैटर्न जांचें, और शोध करें कि आपके क्षेत्र में कौन सी फसलें अच्छी तरह उगती हैं।',
      category: 'General',
    ),
    FAQ(
      id: '3',
      question: 'What is crop rotation and why is it important?',
      questionHindi: 'फसल चक्र क्या है और यह क्यों महत्वपूर्ण है?',
      answer:
          'Crop rotation is growing different crops in the same field in sequential seasons. It helps maintain soil fertility, reduces pest and disease buildup, improves soil structure, and can increase overall yield and profitability.',
      answerHindi:
          'फसल चक्र एक ही खेत में क्रमिक मौसमों में अलग-अलग फसलें उगाना है। यह मिट्टी की उर्वरता बनाए रखने, कीट और रोग के निर्माण को कम करने, मिट्टी की संरचना में सुधार करने में मदद करता है।',
      category: 'General',
    ),

    // Soil Management
    FAQ(
      id: '4',
      question: 'How do I test my soil pH?',
      questionHindi: 'मैं अपनी मिट्टी का pH कैसे जांच सकता हूं?',
      answer:
          'You can test soil pH using pH test strips, digital pH meters, or by taking soil samples to agricultural testing laboratories. Most crops prefer slightly acidic to neutral pH (6.0-7.5).',
      answerHindi:
          'आप pH टेस्ट स्ट्रिप्स, डिजिटल pH मीटर का उपयोग करके या मिट्टी के नमूने कृषि परीक्षण प्रयोगशालाओं में भेजकर मिट्टी का pH जांच सकते हैं। अधिकांश फसलें हल्की अम्लीय से तटस्थ pH (6.0-7.5) पसंद करती हैं।',
      category: 'Soil Management',
    ),
    FAQ(
      id: '5',
      question: 'How can I improve soil fertility naturally?',
      questionHindi:
          'मैं मिट्टी की उर्वरता को प्राकृतिक रूप से कैसे बेहतर बना सकता हूं?',
      answer:
          'Add organic matter like compost, manure, or green manure. Practice crop rotation, use cover crops, apply biofertilizers, and maintain proper soil pH. Avoid over-tilling and use mulching to retain moisture.',
      answerHindi:
          'कंपोस्ट, खाद, या हरी खाद जैसे जैविक पदार्थ मिलाएं। फसल चक्र का अभ्यास करें, कवर क्रॉप्स का उपयोग करें, जैव उर्वरक लगाएं, और उचित मिट्टी pH बनाए रखें।',
      category: 'Soil Management',
    ),
    FAQ(
      id: '6',
      question:
          'What is the difference between organic and chemical fertilizers?',
      questionHindi: 'जैविक और रासायनिक उर्वरकों में क्या अंतर है?',
      answer:
          'Organic fertilizers are derived from natural sources (compost, manure) and release nutrients slowly, improving soil structure. Chemical fertilizers are synthetic, provide quick nutrients but can harm soil health if overused.',
      answerHindi:
          'जैविक उर्वरक प्राकृतिक स्रोतों (कंपोस्ट, खाद) से प्राप्त होते हैं और धीरे-धीरे पोषक तत्व छोड़ते हैं। रासायनिक उर्वरक कृत्रिम होते हैं, त्वरित पोषक तत्व प्रदान करते हैं लेकिन अधिक उपयोग से मिट्टी को नुकसान पहुंचा सकते हैं।',
      category: 'Soil Management',
    ),

    // Crop Health
    FAQ(
      id: '7',
      question: 'What are the signs of nutrient deficiency in crops?',
      questionHindi: 'फसलों में पोषक तत्वों की कमी के लक्षण क्या हैं?',
      answer:
          'Common signs include yellowing of leaves (nitrogen deficiency), purple leaves (phosphorus deficiency), brown leaf edges (potassium deficiency), and stunted growth. Visual inspection and soil testing can help identify specific deficiencies.',
      answerHindi:
          'सामान्य लक्षणों में पत्तियों का पीला होना (नाइट्रोजन की कमी), बैंगनी पत्तियां (फास्फोरस की कमी), पत्तियों के किनारे भूरे होना (पोटैशियम की कमी), और वृद्धि रुकना शामिल है।',
      category: 'Crop Health',
    ),
    FAQ(
      id: '8',
      question: 'How can I identify plant diseases early?',
      questionHindi: 'मैं पौधों के रोगों की शीघ्र पहचान कैसे कर सकता हूं?',
      answer:
          'Regular monitoring is key. Look for discolored leaves, spots, wilting, abnormal growth, or unusual patterns. Check both upper and lower leaf surfaces. Early detection allows for timely treatment and prevents spread.',
      answerHindi:
          'नियमित निगरानी महत्वपूर्ण है। रंग बदलने वाली पत्तियां, धब्बे, मुरझाना, असामान्य वृद्धि, या असामान्य पैटर्न देखें। ऊपरी और निचली पत्ती की सतह दोनों जांचें।',
      category: 'Crop Health',
    ),
    FAQ(
      id: '9',
      question: 'What causes yellowing of leaves in plants?',
      questionHindi: 'पौधों में पत्तियों के पीले होने का क्या कारण है?',
      answer:
          'Yellowing can indicate nitrogen deficiency, overwatering, poor drainage, pest damage, or disease. Check soil moisture, drainage, and look for pests. Test soil nutrients and adjust fertilization accordingly.',
      answerHindi:
          'पीला होना नाइट्रोजन की कमी, अधिक पानी, खराब जल निकासी, कीट क्षति, या रोग का संकेत हो सकता है। मिट्टी की नमी, जल निकासी जांचें, और कीटों की तलाश करें।',
      category: 'Crop Health',
    ),

    // Irrigation
    FAQ(
      id: '10',
      question: 'How often should I water my crops?',
      questionHindi: 'मुझे अपनी फसलों को कितनी बार पानी देना चाहिए?',
      answer:
          'Watering frequency depends on crop type, soil type, weather conditions, and growth stage. Generally, deep watering 2-3 times per week is better than daily shallow watering. Monitor soil moisture and adjust accordingly.',
      answerHindi:
          'पानी देने की आवृत्ति फसल के प्रकार, मिट्टी के प्रकार, मौसम की स्थिति और वृद्धि के चरण पर निर्भर करती है। आमतौर पर, सप्ताह में 2-3 बार गहरा पानी देना दैनिक उथले पानी से बेहतर है।',
      category: 'Irrigation',
    ),
    FAQ(
      id: '11',
      question: 'What is drip irrigation and its benefits?',
      questionHindi: 'ड्रिप सिंचाई क्या है और इसके क्या फायदे हैं?',
      answer:
          'Drip irrigation delivers water directly to plant roots through a network of tubes and emitters. Benefits include water conservation (30-50% savings), reduced weed growth, better plant health, and precise nutrient delivery.',
      answerHindi:
          'ड्रिप सिंचाई ट्यूबों और एमिटरों के नेटवर्क के माध्यम से पानी को सीधे पौधों की जड़ों तक पहुंचाती है। फायदों में जल संरक्षण (30-50% बचत), कम खरपतवार वृद्धि, बेहतर पौध स्वास्थ्य शामिल है।',
      category: 'Irrigation',
    ),
    FAQ(
      id: '12',
      question: 'How can I conserve water in farming?',
      questionHindi: 'मैं खेती में पानी कैसे बचा सकता हूं?',
      answer:
          'Use efficient irrigation methods (drip, sprinkler), practice mulching, choose drought-resistant crops, improve soil organic matter, use rainwater harvesting, and schedule irrigation during cooler parts of the day.',
      answerHindi:
          'कुशल सिंचाई विधियों (ड्रिप, स्प्रिंकलर) का उपयोग करें, मल्चिंग का अभ्यास करें, सूखा-प्रतिरोधी फसलें चुनें, मिट्टी के जैविक पदार्थ में सुधार करें।',
      category: 'Irrigation',
    ),

    // Pest Management
    FAQ(
      id: '13',
      question: 'How can I control pests without chemicals?',
      questionHindi: 'मैं रसायनों के बिना कीटों को कैसे नियंत्रित कर सकता हूं?',
      answer:
          'Use biological control (beneficial insects), crop rotation, companion planting, neem oil, garlic/chili sprays, physical barriers, and maintain healthy soil. Encourage natural predators and use trap crops.',
      answerHindi:
          'जैविक नियंत्रण (लाभकारी कीट), फसल चक्र, साथी रोपण, नीम का तेल, लहसुन/मिर्च स्प्रे, भौतिक बाधाएं का उपयोग करें।',
      category: 'Pest Management',
    ),
    FAQ(
      id: '14',
      question: 'What are the signs of pest infestation?',
      questionHindi: 'कीट संक्रमण के लक्षण क्या हैं?',
      answer:
          'Look for holes in leaves, chewed edges, sticky residue, webbing, visible insects, wilting, stunted growth, or yellowing. Check both sides of leaves and stems. Early detection is crucial for effective control.',
      answerHindi:
          'पत्तियों में छेद, चबाए गए किनारे, चिपचिपा अवशेष, जाले, दिखाई देने वाले कीट, मुरझाना, वृद्धि रुकना, या पीला होना देखें।',
      category: 'Pest Management',
    ),
    FAQ(
      id: '15',
      question: 'How do I make organic pest control sprays?',
      questionHindi: 'मैं जैविक कीट नियंत्रण स्प्रे कैसे बनाऊं?',
      answer:
          'Mix neem oil with water and soap, create garlic/chili spray, use tobacco water, or make soap solution. Always test on small area first. Apply early morning or evening, and reapply after rain.',
      answerHindi:
          'नीम के तेल को पानी और साबुन के साथ मिलाएं, लहसुन/मिर्च स्प्रे बनाएं, तंबाकू का पानी उपयोग करें, या साबुन का घोल बनाएं।',
      category: 'Pest Management',
    ),

    // Disease Management
    FAQ(
      id: '16',
      question: 'How can I prevent crop diseases?',
      questionHindi: 'मैं फसल रोगों को कैसे रोक सकता हूं?',
      answer:
          'Prevention strategies include using disease-resistant varieties, proper crop rotation, maintaining field hygiene, ensuring good air circulation, avoiding overwatering, and regular monitoring for early detection.',
      answerHindi:
          'रोकथाम की रणनीतियों में रोग-प्रतिरोधी किस्मों का उपयोग, उचित फसल चक्र, खेत की स्वच्छता बनाए रखना, अच्छी हवा का संचार सुनिश्चित करना शामिल है।',
      category: 'Disease Management',
    ),
    FAQ(
      id: '17',
      question: 'What causes fungal diseases in crops?',
      questionHindi: 'फसलों में फंगल रोगों का क्या कारण है?',
      answer:
          'Fungal diseases are caused by high humidity, poor air circulation, overwatering, contaminated soil, or infected seeds. Prevention includes proper spacing, good drainage, and avoiding overhead watering.',
      answerHindi:
          'फंगल रोग उच्च आर्द्रता, खराब हवा का संचार, अधिक पानी, दूषित मिट्टी, या संक्रमित बीज के कारण होते हैं।',
      category: 'Disease Management',
    ),
    FAQ(
      id: '18',
      question: 'How do I treat plant diseases organically?',
      questionHindi: 'मैं पौधों के रोगों का जैविक उपचार कैसे करूं?',
      answer:
          'Use copper-based fungicides, baking soda spray, milk solution, or compost tea. Remove infected parts immediately, improve air circulation, and ensure proper drainage. Strengthen plants with balanced nutrition.',
      answerHindi:
          'तांबा-आधारित फंगीसाइड, बेकिंग सोडा स्प्रे, दूध का घोल, या कंपोस्ट चाय का उपयोग करें। संक्रमित भागों को तुरंत हटाएं।',
      category: 'Disease Management',
    ),

    // Sustainable Farming
    FAQ(
      id: '19',
      question: 'What are organic farming practices?',
      questionHindi: 'जैविक खेती की प्रथाएं क्या हैं?',
      answer:
          'Organic farming involves using natural fertilizers (compost, manure), biological pest control, crop rotation, and avoiding synthetic chemicals. It focuses on soil health, biodiversity, and sustainable practices.',
      answerHindi:
          'जैविक खेती में प्राकृतिक उर्वरकों (खाद, गोबर) का उपयोग, जैविक कीट नियंत्रण, फसल चक्र, और कृत्रिम रसायनों से बचना शामिल है।',
      category: 'Sustainable Farming',
    ),
    FAQ(
      id: '20',
      question: 'How can I make my farm more sustainable?',
      questionHindi: 'मैं अपने खेत को अधिक टिकाऊ कैसे बना सकता हूं?',
      answer:
          'Practice crop rotation, use cover crops, implement water conservation, reduce chemical inputs, maintain soil health, use renewable energy, and focus on biodiversity. Plan for long-term soil and environmental health.',
      answerHindi:
          'फसल चक्र का अभ्यास करें, कवर क्रॉप्स का उपयोग करें, जल संरक्षण लागू करें, रासायनिक इनपुट कम करें, मिट्टी का स्वास्थ्य बनाए रखें।',
      category: 'Sustainable Farming',
    ),
    FAQ(
      id: '21',
      question: 'What is permaculture and how can it help farming?',
      questionHindi: 'पर्माकल्चर क्या है और यह खेती में कैसे मदद कर सकता है?',
      answer:
          'Permaculture is designing agricultural systems that mimic natural ecosystems. It promotes biodiversity, reduces inputs, increases resilience, and creates self-sustaining systems through careful planning and design.',
      answerHindi:
          'पर्माकल्चर कृषि प्रणालियों को डिजाइन करना है जो प्राकृतिक पारिस्थितिक तंत्र की नकल करती हैं। यह जैव विविधता को बढ़ावा देता है।',
      category: 'Sustainable Farming',
    ),

    // Weather and Climate
    FAQ(
      id: '22',
      question: 'How does weather affect crop growth?',
      questionHindi: 'मौसम फसल की वृद्धि को कैसे प्रभावित करता है?',
      answer:
          'Weather affects germination, growth rate, flowering, fruiting, and harvest timing. Temperature, rainfall, humidity, and wind all play crucial roles. Monitor weather forecasts and adjust farming practices accordingly.',
      answerHindi:
          'मौसम अंकुरण, वृद्धि दर, फूलना, फलना, और कटाई के समय को प्रभावित करता है। तापमान, वर्षा, आर्द्रता, और हवा सभी महत्वपूर्ण भूमिका निभाते हैं।',
      category: 'Weather & Climate',
    ),
    FAQ(
      id: '23',
      question: 'How can I protect crops from extreme weather?',
      questionHindi: 'मैं फसलों को चरम मौसम से कैसे बचा सकता हूं?',
      answer:
          'Use windbreaks, shade nets, mulching, proper drainage, and choose weather-resistant varieties. Monitor forecasts, have contingency plans, and use protective structures like greenhouses or tunnels.',
      answerHindi:
          'विंडब्रेक्स, शेड नेट्स, मल्चिंग, उचित जल निकासी का उपयोग करें, और मौसम-प्रतिरोधी किस्में चुनें। पूर्वानुमान की निगरानी करें।',
      category: 'Weather & Climate',
    ),

    // Market and Economics
    FAQ(
      id: '24',
      question: 'How can I get better prices for my crops?',
      questionHindi:
          'मैं अपनी फसलों के लिए बेहतर कीमतें कैसे प्राप्त कर सकता हूं?',
      answer:
          'Research market prices, sell directly to consumers, join farmer cooperatives, improve crop quality, time your harvest for better prices, and consider value addition through processing or packaging.',
      answerHindi:
          'बाजार की कीमतों का शोध करें, सीधे उपभोक्ताओं को बेचें, किसान सहकारी समितियों में शामिल हों, फसल की गुणवत्ता में सुधार करें।',
      category: 'Market & Economics',
    ),
    FAQ(
      id: '25',
      question: 'What is MSP and how does it help farmers?',
      questionHindi: 'MSP क्या है और यह किसानों की कैसे मदद करता है?',
      answer:
          'MSP (Minimum Support Price) is the government-guaranteed price for certain crops. It provides income security, protects against price fluctuations, and ensures farmers get fair returns for their produce.',
      answerHindi:
          'MSP (न्यूनतम समर्थन मूल्य) कुछ फसलों के लिए सरकार द्वारा गारंटीकृत मूल्य है। यह आय सुरक्षा प्रदान करता है।',
      category: 'Market & Economics',
    ),

    // Technology and Innovation
    FAQ(
      id: '26',
      question: 'How can technology help in farming?',
      questionHindi: 'तकनीक खेती में कैसे मदद कर सकती है?',
      answer:
          'Technology helps with precision farming, weather monitoring, soil testing, pest detection, irrigation management, and market access. Use apps for weather forecasts, soil analysis, and crop management.',
      answerHindi:
          'तकनीक सटीक खेती, मौसम निगरानी, मिट्टी परीक्षण, कीट पहचान, सिंचाई प्रबंधन में मदद करती है।',
      category: 'Technology',
    ),
    FAQ(
      id: '27',
      question: 'What are the benefits of precision agriculture?',
      questionHindi: 'सटीक कृषि के क्या फायदे हैं?',
      answer:
          'Precision agriculture optimizes inputs, reduces waste, increases yields, improves quality, and reduces environmental impact. It uses GPS, sensors, and data analysis for better decision-making.',
      answerHindi:
          'सटीक कृषि इनपुट को अनुकूलित करती है, अपशिष्ट कम करती है, उपज बढ़ाती है, गुणवत्ता में सुधार करती है।',
      category: 'Technology',
    ),
  ];

  // Get all FAQs
  List<FAQ> getAllFAQs() {
    return _faqs;
  }

  // Get FAQs by category
  List<FAQ> getFAQsByCategory(String category) {
    return _faqs.where((faq) => faq.category == category).toList();
  }

  // Search FAQs
  List<FAQ> searchFAQs(String query) {
    return _faqs
        .where(
          (faq) =>
              faq.question.toLowerCase().contains(query.toLowerCase()) ||
              faq.questionHindi.contains(query) ||
              faq.answer.toLowerCase().contains(query.toLowerCase()) ||
              faq.answerHindi.contains(query),
        )
        .toList();
  }

  // Get unique categories
  List<String> getCategories() {
    return _faqs.map((faq) => faq.category).toSet().toList();
  }

  // Get comprehensive farming guidelines
  Map<String, List<String>> getFarmingGuidelines() {
    return {
      'Soil Preparation': [
        'Test soil pH and nutrient levels before planting',
        'Add organic matter (compost, manure) to improve soil structure',
        'Ensure proper drainage to prevent waterlogging',
        'Remove weeds and crop residues from previous season',
        'Deep plowing (15-20 cm) before planting',
        'Level the field for uniform water distribution',
        'Apply lime if soil is too acidic (pH < 6.0)',
        'Create raised beds for better drainage in heavy soils',
        'Allow soil to rest for 2-3 weeks after plowing',
        'Test soil moisture content before planting',
      ],
      'Seed Selection & Treatment': [
        'Choose high-quality certified seeds from reliable sources',
        'Select varieties suitable for local climate and soil',
        'Consider disease-resistant and pest-resistant varieties',
        'Check seed germination rate (should be >85%)',
        'Treat seeds with fungicides to prevent soil-borne diseases',
        'Soak seeds in water for 8-12 hours before planting',
        'Use seed coating with beneficial microorganisms',
        'Store seeds in cool, dry conditions',
        'Check seed viability before planting',
        'Consider hybrid varieties for better yield potential',
      ],
      'Planting & Spacing': [
        'Follow recommended planting dates for your region',
        'Maintain proper spacing between plants and rows',
        'Plant at appropriate depth (2-3 times seed diameter)',
        'Ensure good seed-to-soil contact',
        'Water immediately after planting',
        'Use planting tools appropriate for seed size',
        'Mark rows for uniform spacing',
        'Plant in straight rows for easier management',
        'Consider companion planting for pest control',
        'Adjust planting density based on soil fertility',
      ],
      'Fertilization & Nutrition': [
        'Apply basal fertilizers before planting',
        'Follow recommended NPK ratios for your crop',
        'Use organic fertilizers (compost, manure) when possible',
        'Apply nutrients based on soil test results',
        'Time fertilizer applications properly (basal, top dressing)',
        'Use slow-release fertilizers for better efficiency',
        'Apply micronutrients if soil tests indicate deficiency',
        'Split nitrogen applications for better uptake',
        'Use foliar feeding for quick nutrient correction',
        'Maintain proper pH for nutrient availability',
      ],
      'Irrigation & Water Management': [
        'Water at appropriate growth stages (germination, flowering, fruiting)',
        'Maintain consistent soil moisture levels',
        'Use efficient irrigation methods (drip, sprinkler)',
        'Avoid waterlogging and overwatering',
        'Monitor weather conditions and adjust irrigation',
        'Use mulching to conserve soil moisture',
        'Implement rainwater harvesting systems',
        'Schedule irrigation during cooler parts of the day',
        'Check soil moisture before watering',
        'Use water-saving techniques like alternate furrow irrigation',
      ],
      'Pest & Disease Management': [
        'Regular monitoring for pests and diseases',
        'Use integrated pest management (IPM) approach',
        'Apply pesticides only when necessary and at right time',
        'Follow safety guidelines for pesticide application',
        'Encourage beneficial insects and natural predators',
        'Use biological control methods when possible',
        'Practice crop rotation to break pest cycles',
        'Remove infected plants immediately',
        'Use resistant varieties when available',
        'Maintain field hygiene and sanitation',
      ],
      'Weed Management': [
        'Start weed control early in the season',
        'Use mechanical weeding between rows',
        'Apply pre-emergence herbicides if needed',
        'Use mulching to suppress weed growth',
        'Hand weed around plants carefully',
        'Practice stale seedbed technique',
        'Use cover crops to suppress weeds',
        'Rotate crops to break weed cycles',
        'Clean equipment between fields',
        'Monitor for herbicide resistance in weeds',
      ],
      'Harvesting & Post-Harvest': [
        'Harvest at proper maturity stage for best quality',
        'Use appropriate harvesting tools and methods',
        'Handle produce carefully to avoid damage',
        'Clean and sort produce immediately after harvest',
        'Store in appropriate conditions (temperature, humidity)',
        'Use proper packaging materials',
        'Maintain cold chain for perishable crops',
        'Grade produce according to quality standards',
        'Keep records of harvest dates and quantities',
        'Plan for storage and marketing',
      ],
      'Crop Rotation & Planning': [
        'Plan crop rotation to improve soil health',
        'Include legumes in rotation for nitrogen fixation',
        'Avoid planting same crop family consecutively',
        'Consider market demand and prices',
        'Plan for different seasons (Kharif, Rabi, Zaid)',
        'Include cover crops in rotation',
        'Plan for pest and disease management',
        'Consider soil and climate requirements',
        'Plan for irrigation and water needs',
        'Keep detailed records of all activities',
      ],
      'Sustainable Practices': [
        'Practice conservation tillage to reduce soil erosion',
        'Use cover crops to improve soil health',
        'Implement agroforestry where appropriate',
        'Use renewable energy sources when possible',
        'Practice water conservation techniques',
        'Maintain biodiversity on the farm',
        'Use organic farming methods where feasible',
        'Implement integrated farming systems',
        'Plan for long-term soil health',
        'Educate yourself about new sustainable practices',
      ],
      'Record Keeping & Analysis': [
        'Keep detailed records of all farming activities',
        'Record weather data and its impact on crops',
        'Track input costs and yields for profitability analysis',
        'Document pest and disease occurrences',
        'Record soil test results and fertilizer applications',
        'Keep harvest and sales records',
        'Analyze data to improve future seasons',
        'Share knowledge with other farmers',
        'Participate in farmer groups and cooperatives',
        'Stay updated with latest agricultural research',
      ],
    };
  }
}
