import 'dart:math' as math;
import '../models/farmer_community.dart';

class FarmerCommunityService {
  // Mock database
  static final List<ForumPost> _forumPosts = [];
  static final List<ForumComment> _comments = [];
  static final List<ExperienceShare> _experiences = [];
  static final List<CommunityMember> _members = [];
  static final List<CommunityNotification> _notifications = [];
  static final List<PeerLearningGroup> _learningGroups = [];
  static final List<ExpertAdvice> _expertAdvice = [];

  // Forum Operations
  Future<List<ForumPost>> getForumPosts({
    String? category,
    String? searchQuery,
    int limit = 20,
    int offset = 0,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (_forumPosts.isEmpty) {
      _generateMockForumPosts();
    }

    var posts = List<ForumPost>.from(_forumPosts);

    // Filter by category
    if (category != null && category.isNotEmpty) {
      posts = posts.where((post) => post.category == category).toList();
    }

    // Search functionality
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      posts = posts
          .where((post) =>
              post.title.toLowerCase().contains(query) ||
              post.titleHindi.contains(searchQuery) ||
              post.content.toLowerCase().contains(query) ||
              post.contentHindi.contains(searchQuery) ||
              post.tags.any((tag) => tag.toLowerCase().contains(query)))
          .toList();
    }

    // Sort by creation date (newest first) and pinned posts
    posts.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });

    // Apply pagination
    final endIndex = math.min(offset + limit, posts.length);
    return posts.sublist(offset, endIndex);
  }

  Future<String> createForumPost(
    String authorId,
    String title,
    String titleHindi,
    String content,
    String contentHindi,
    String category,
    List<String> tags,
    List<String> tagsHindi,
    List<String> images,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final postId = 'POST_${DateTime.now().millisecondsSinceEpoch}';

    final post = ForumPost(
      id: postId,
      authorId: authorId,
      authorName: 'Demo Farmer', // In real app, get from user profile
      authorNameHindi: 'डेमो किसान',
      title: title,
      titleHindi: titleHindi,
      content: content,
      contentHindi: contentHindi,
      category: category,
      tags: tags,
      tagsHindi: tagsHindi,
      attachedImages: images,
      createdAt: DateTime.now(),
      location: 'Maharashtra',
      locationHindi: 'महाराष्ट्र',
      metadata: {
        'deviceInfo': 'Mobile App',
        'version': '1.0.0',
      },
    );

    _forumPosts.add(post);
    return postId;
  }

  Future<List<ForumComment>> getPostComments(String postId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (_comments.isEmpty) {
      _generateMockComments();
    }

    return _comments.where((comment) => comment.postId == postId).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future<String> addComment(
    String postId,
    String authorId,
    String content,
    String contentHindi,
    String? parentCommentId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final commentId = 'COMMENT_${DateTime.now().millisecondsSinceEpoch}';

    final comment = ForumComment(
      id: commentId,
      postId: postId,
      authorId: authorId,
      authorName: 'Demo User',
      authorNameHindi: 'डेमो उपयोगकर्ता',
      content: content,
      contentHindi: contentHindi,
      createdAt: DateTime.now(),
      parentCommentId: parentCommentId,
    );

    _comments.add(comment);

    // Update post comment count
    final postIndex = _forumPosts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      _forumPosts[postIndex] = ForumPost(
        id: _forumPosts[postIndex].id,
        authorId: _forumPosts[postIndex].authorId,
        authorName: _forumPosts[postIndex].authorName,
        authorNameHindi: _forumPosts[postIndex].authorNameHindi,
        title: _forumPosts[postIndex].title,
        titleHindi: _forumPosts[postIndex].titleHindi,
        content: _forumPosts[postIndex].content,
        contentHindi: _forumPosts[postIndex].contentHindi,
        category: _forumPosts[postIndex].category,
        tags: _forumPosts[postIndex].tags,
        tagsHindi: _forumPosts[postIndex].tagsHindi,
        attachedImages: _forumPosts[postIndex].attachedImages,
        createdAt: _forumPosts[postIndex].createdAt,
        lastUpdatedAt: DateTime.now(),
        likeCount: _forumPosts[postIndex].likeCount,
        commentCount: _forumPosts[postIndex].commentCount + 1,
        isPinned: _forumPosts[postIndex].isPinned,
        isExpertVerified: _forumPosts[postIndex].isExpertVerified,
        location: _forumPosts[postIndex].location,
        locationHindi: _forumPosts[postIndex].locationHindi,
        metadata: _forumPosts[postIndex].metadata,
      );
    }

    return commentId;
  }

  // Experience Sharing Operations
  Future<List<ExperienceShare>> getExperienceShares({
    String? category,
    String? cropType,
    bool? isFeatured,
    int limit = 10,
    int offset = 0,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    if (_experiences.isEmpty) {
      _generateMockExperiences();
    }

    var experiences = List<ExperienceShare>.from(_experiences);

    // Apply filters
    if (category != null) {
      experiences =
          experiences.where((exp) => exp.category == category).toList();
    }

    if (cropType != null) {
      experiences = experiences
          .where((exp) =>
              exp.cropType.toLowerCase().contains(cropType.toLowerCase()))
          .toList();
    }

    if (isFeatured != null) {
      experiences =
          experiences.where((exp) => exp.isFeatured == isFeatured).toList();
    }

    // Sort by helpful count and view count
    experiences.sort((a, b) {
      if (a.isFeatured && !b.isFeatured) return -1;
      if (!a.isFeatured && b.isFeatured) return 1;
      return (b.helpfulCount + b.viewCount)
          .compareTo(a.helpfulCount + a.viewCount);
    });

    // Apply pagination
    final endIndex = math.min(offset + limit, experiences.length);
    return experiences.sublist(offset, endIndex);
  }

  Future<String> shareExperience(
      String farmerId,
      String title,
      String titleHindi,
      String experience,
      String experienceHindi,
      String category,
      String cropType,
      String cropTypeHindi,
      String season,
      List<String> techniques,
      List<String> techniquesHindi,
      List<String> challenges,
      List<String> challengesHindi,
      List<String> lessons,
      List<String> lessonsHindi,
      {double? yieldAchieved,
      double? profitMargin,
      List<String>? images}) async {
    await Future.delayed(const Duration(seconds: 1));

    final experienceId = 'EXP_${DateTime.now().millisecondsSinceEpoch}';

    final experienceShare = ExperienceShare(
      id: experienceId,
      farmerId: farmerId,
      farmerName: 'Demo Farmer',
      farmerNameHindi: 'डेमो किसान',
      title: title,
      titleHindi: titleHindi,
      experience: experience,
      experienceHindi: experienceHindi,
      category: category,
      cropType: cropType,
      cropTypeHindi: cropTypeHindi,
      season: season,
      yieldAchieved: yieldAchieved,
      profitMargin: profitMargin,
      techniquesUsed: techniques,
      techniquesUsedHindi: techniquesHindi,
      challengesFaced: challenges,
      challengesFacedHindi: challengesHindi,
      lessonsLearned: lessons,
      lessonsLearnedHindi: lessonsHindi,
      images: images ?? [],
      sharedAt: DateTime.now(),
      location: 'Punjab',
      locationHindi: 'पंजाब',
    );

    _experiences.add(experienceShare);
    return experienceId;
  }

  // Community Members
  Future<List<CommunityMember>> getCommunityMembers({
    String? location,
    String? expertise,
    String? membershipLevel,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (_members.isEmpty) {
      _generateMockMembers();
    }

    var members = List<CommunityMember>.from(_members);

    // Apply filters
    if (location != null) {
      members = members
          .where((member) =>
              member.location.toLowerCase().contains(location.toLowerCase()))
          .toList();
    }

    if (membershipLevel != null) {
      members = members
          .where((member) => member.membershipLevel == membershipLevel)
          .toList();
    }

    // Sort by rating and helpful answers
    members.sort((a, b) => (b.communityRating * 10 + b.helpfulAnswers)
        .compareTo(a.communityRating * 10 + a.helpfulAnswers));

    return members.take(limit).toList();
  }

  // Expert Advice
  Future<List<ExpertAdvice>> getExpertAdvice({
    String? category,
    String? expertise,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (_expertAdvice.isEmpty) {
      _generateMockExpertAdvice();
    }

    var advice = List<ExpertAdvice>.from(_expertAdvice);

    // Apply filters
    if (category != null) {
      advice = advice.where((adv) => adv.category == category).toList();
    }

    if (expertise != null) {
      advice = advice.where((adv) => adv.expertise == expertise).toList();
    }

    // Sort by helpful votes and verification
    advice.sort((a, b) {
      if (a.isVerifiedAnswer && !b.isVerifiedAnswer) return -1;
      if (!a.isVerifiedAnswer && b.isVerifiedAnswer) return 1;
      return b.helpfulVotes.compareTo(a.helpfulVotes);
    });

    return advice.take(limit).toList();
  }

  Future<String> askExpert(
    String question,
    String questionHindi,
    String category,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    // Simulate expert response generation
    final questionId = 'QUESTION_${DateTime.now().millisecondsSinceEpoch}';

    // Generate automatic response from available experts
    final random = math.Random();
    final expertResponses = [
      {
        'answer':
            'Based on your question, I recommend conducting a soil test first to determine the exact nutrient requirements. This will help you choose the right fertilizer combination.',
        'answerHindi':
            'आपके प्रश्न के आधार पर, मैं पहले मिट्टी का परीक्षण करने की सिफारिश करता हूं ताकि सही पोषक तत्वों की आवश्यकताओं का पता लग सके। इससे आपको सही उर्वरक संयोजन चुनने में मदद मिलेगी।',
        'expert': 'Dr. Rajesh Kumar',
        'expertHindi': 'डॉ. राजेश कुमार',
        'expertise': 'soil_science',
      },
      {
        'answer':
            'For better pest management, try integrated pest management (IPM) approach. Use biological controls along with minimal chemical intervention.',
        'answerHindi':
            'बेहतर कीट प्रबंधन के लिए, एकीकृत कीट प्रबंधन (IPM) दृष्टिकोण अपनाएं। न्यूनतम रासायनिक हस्तक्षेप के साथ जैविक नियंत्रण का उपयोग करें।',
        'expert': 'Dr. Priya Sharma',
        'expertHindi': 'डॉ. प्रिया शर्मा',
        'expertise': 'pest_management',
      },
    ];

    final selectedResponse =
        expertResponses[random.nextInt(expertResponses.length)];

    final advice = ExpertAdvice(
      id: 'ADVICE_${DateTime.now().millisecondsSinceEpoch}',
      expertId: 'EXPERT_001',
      expertName: selectedResponse['expert']!,
      expertNameHindi: selectedResponse['expertHindi']!,
      questionId: questionId,
      question: question,
      questionHindi: questionHindi,
      answer: selectedResponse['answer']!,
      answerHindi: selectedResponse['answerHindi']!,
      category: category,
      expertise: selectedResponse['expertise']!,
      providedAt: DateTime.now(),
      isVerifiedAnswer: true,
      references: [
        'Agricultural Extension Guidelines 2024',
        'Integrated Farming Systems Manual',
      ],
      referencesHindi: [
        'कृषि विस्तार दिशानिर्देश 2024',
        'एकीकृत कृषि प्रणाली मैनुअल',
      ],
    );

    _expertAdvice.add(advice);
    return questionId;
  }

  // Peer Learning Groups
  Future<List<PeerLearningGroup>> getPeerLearningGroups({
    String? category,
    String? location,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (_learningGroups.isEmpty) {
      _generateMockLearningGroups();
    }

    var groups = List<PeerLearningGroup>.from(_learningGroups);

    // Apply filters
    if (category != null) {
      groups = groups.where((group) => group.category == category).toList();
    }

    if (location != null) {
      groups = groups
          .where((group) =>
              group.location.toLowerCase().contains(location.toLowerCase()))
          .toList();
    }

    // Sort by member count and activity
    groups = groups.where((group) => group.isActive).toList();
    groups.sort((a, b) => b.memberIds.length.compareTo(a.memberIds.length));

    return groups.take(limit).toList();
  }

  Future<String> createLearningGroup(
    String adminId,
    String name,
    String nameHindi,
    String description,
    String descriptionHindi,
    String category,
    List<String> tags,
    List<String> tagsHindi,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final groupId = 'GROUP_${DateTime.now().millisecondsSinceEpoch}';

    final group = PeerLearningGroup(
      id: groupId,
      name: name,
      nameHindi: nameHindi,
      description: description,
      descriptionHindi: descriptionHindi,
      category: category,
      adminId: adminId,
      memberIds: [adminId], // Admin is the first member
      location: 'India',
      locationHindi: 'भारत',
      createdAt: DateTime.now(),
      tags: tags,
      tagsHindi: tagsHindi,
    );

    _learningGroups.add(group);
    return groupId;
  }

  // Notifications
  Future<List<CommunityNotification>> getNotifications(String userId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (_notifications.isEmpty) {
      _generateMockNotifications();
    }

    return _notifications.where((notif) => notif.recipientId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Community Statistics
  Future<Map<String, dynamic>> getCommunityStatistics() async {
    await Future.delayed(const Duration(milliseconds: 600));

    final random = math.Random();

    return {
      'totalMembers': _members.length + random.nextInt(1000),
      'totalPosts': _forumPosts.length + random.nextInt(500),
      'totalExperiences': _experiences.length + random.nextInt(200),
      'totalComments': _comments.length + random.nextInt(2000),
      'activeExperts': random.nextInt(20) + 10,
      'totalGroups': _learningGroups.length + random.nextInt(50),
      'dailyActiveUsers': random.nextInt(200) + 100,
      'monthlyActiveUsers': random.nextInt(2000) + 1000,
      'topCategories': {
        'crop_advice': random.nextInt(100) + 50,
        'market_info': random.nextInt(80) + 30,
        'success_story': random.nextInt(60) + 20,
        'problem_solving': random.nextInt(120) + 80,
      },
      'engagementMetrics': {
        'averagePostLikes': random.nextDouble() * 20 + 5,
        'averageComments': random.nextDouble() * 10 + 2,
        'helpfulAnswerRate': random.nextDouble() * 30 + 70,
        'responseTime': '${random.nextInt(60) + 30} minutes',
      },
    };
  }

  // Private helper methods for generating mock data
  void _generateMockForumPosts() {
    final random = math.Random();

    final mockPosts = [
      // Crop Advice Posts
      {
        'title': 'Best organic fertilizers for wheat crop',
        'titleHindi': 'गेहूं की फसल के लिए सर्वोत्तम जैविक उर्वरक',
        'content':
            'I have been experimenting with different organic fertilizers for my wheat crop. Based on my experience, cow manure mixed with compost works best.',
        'contentHindi':
            'मैं अपनी गेहूं की फसल के लिए विभिन्न जैविक उर्वरकों के साथ प्रयोग कर रहा हूं। मेरे अनुभव के आधार पर, गोबर खाद और कंपोस्ट का मिश्रण सबसे अच्छा काम करता है।',
        'category': 'crop_advice',
        'tags': ['organic', 'fertilizer', 'wheat'],
        'tagsHindi': ['जैविक', 'उर्वरक', 'गेहूं'],
      },
      {
        'title': 'How to control aphids in mustard crop naturally',
        'titleHindi':
            'सरसों की फसल में प्राकृतिक रूप से एफिड्स को कैसे नियंत्रित करें',
        'content':
            'Neem oil spray mixed with garlic extract works wonders for aphid control. Apply early morning for best results. Also plant marigolds as companion crops.',
        'contentHindi':
            'लहसुन के अर्क के साथ मिलाकर नीम तेल स्प्रे एफिड नियंत्रण के लिए कमाल करता है। सबसे अच्छे परिणाम के लिए सुबह जल्दी लगाएं। साथी फसल के रूप में गेंदे भी लगाएं।',
        'category': 'crop_advice',
        'tags': ['pest control', 'mustard', 'natural', 'neem'],
        'tagsHindi': ['कीट नियंत्रण', 'सरसों', 'प्राकृतिक', 'नीम'],
      },
      {
        'title': 'Optimal spacing for tomato plants in greenhouse',
        'titleHindi': 'ग्रीनहाउस में टमाटर के पौधों के लिए इष्टतम दूरी',
        'content':
            'For greenhouse tomatoes, maintain 60cm between rows and 45cm between plants. This ensures good air circulation and reduces disease spread.',
        'contentHindi':
            'ग्रीनहाउस टमाटर के लिए, पंक्तियों के बीच 60 सेमी और पौधों के बीच 45 सेमी दूरी रखें। यह अच्छे वायु संचार को सुनिश्चित करता है और रोग फैलाव को कम करता है।',
        'category': 'crop_advice',
        'tags': ['tomato', 'greenhouse', 'spacing', 'disease prevention'],
        'tagsHindi': ['टमाटर', 'ग्रीनहाउस', 'दूरी', 'रोग निवारण'],
      },
      {
        'title': 'Rice cultivation in water-scarce areas',
        'titleHindi': 'पानी की कमी वाले क्षेत्रों में धान की खेती',
        'content':
            'Use System of Rice Intensification (SRI) method. Transplant single seedlings at wider spacing, use intermittent irrigation, and apply organic mulch.',
        'contentHindi':
            'धान गहनता प्रणाली (SRI) विधि का उपयोग करें। एकल पौधों को अधिक दूरी पर रोपें, रुक-रुक कर सिंचाई करें, और जैविक मल्च लगाएं।',
        'category': 'crop_advice',
        'tags': ['rice', 'SRI', 'water conservation', 'organic'],
        'tagsHindi': ['धान', 'SRI', 'जल संरक्षण', 'जैविक'],
      },

      // Success Stories
      {
        'title': 'Successful cotton farming with drip irrigation',
        'titleHindi': 'ड्रिप सिंचाई के साथ सफल कपास की खेती',
        'content':
            'This season I achieved 25% higher yield using drip irrigation system. Water consumption reduced by 40% and quality improved significantly.',
        'contentHindi':
            'इस सीजन में मैंने ड्रिप सिंचाई प्रणाली का उपयोग करके 25% अधिक उत्पादन प्राप्त किया। पानी की खपत 40% कम हो गई और गुणवत्ता में काफी सुधार हुआ।',
        'category': 'success_story',
        'tags': ['cotton', 'drip irrigation', 'success'],
        'tagsHindi': ['कपास', 'ड्रिप सिंचाई', 'सफलता'],
      },
      {
        'title': 'Integrated farming doubled my income',
        'titleHindi': 'एकीकृत खेती ने मेरी आय दोगुनी कर दी',
        'content':
            'Combined fish farming with rice cultivation. Fish waste fertilizes rice, rice provides shade for fish. Increased income by 200% in 2 years.',
        'contentHindi':
            'मछली पालन को धान की खेती के साथ जोड़ा। मछली का अपशिष्ट धान को उर्वरित करता है, धान मछली को छाया प्रदान करता है। 2 साल में आय 200% बढ़ी।',
        'category': 'success_story',
        'tags': ['integrated farming', 'fish', 'rice', 'income'],
        'tagsHindi': ['एकीकृत खेती', 'मछली', 'धान', 'आय'],
      },
      {
        'title': 'From 2 acres to 20 acres - My farming journey',
        'titleHindi': '2 एकड़ से 20 एकड़ तक - मेरी खेती की यात्रा',
        'content':
            'Started with 2 acres, now farming 20 acres. Key was adopting modern techniques, proper planning, and building good relationships with buyers.',
        'contentHindi':
            '2 एकड़ से शुरुआत की, अब 20 एकड़ की खेती कर रहा हूं। मुख्य बात आधुनिक तकनीक अपनाना, उचित योजना बनाना, और खरीदारों के साथ अच्छे संबंध बनाना था।',
        'category': 'success_story',
        'tags': ['expansion', 'modern farming', 'planning', 'growth'],
        'tagsHindi': ['विस्तार', 'आधुनिक खेती', 'योजना', 'वृद्धि'],
      },
      {
        'title': 'Organic vegetables - Premium prices achieved',
        'titleHindi': 'जैविक सब्जियां - प्रीमियम कीमतें प्राप्त कीं',
        'content':
            'Switched to organic farming 3 years ago. Initially faced challenges but now getting 40% higher prices. Healthier soil, better quality produce.',
        'contentHindi':
            '3 साल पहले जैविक खेती में बदलाव किया। शुरुआत में चुनौतियां आईं लेकिन अब 40% अधिक कीमतें मिल रही हैं। स्वस्थ मिट्टी, बेहतर गुणवत्ता वाली उपज।',
        'category': 'success_story',
        'tags': ['organic', 'vegetables', 'premium', 'quality'],
        'tagsHindi': ['जैविक', 'सब्जियां', 'प्रीमियम', 'गुणवत्ता'],
      },

      // Market Information
      {
        'title': 'Current market prices in Maharashtra',
        'titleHindi': 'महाराष्ट्र में वर्तमान बाजार भाव',
        'content':
            'Sharing today\'s market rates from APMC Pune. Onion prices are up by 15% compared to last week.',
        'contentHindi':
            'APMC पुणे से आज के बाजार भाव साझा कर रहा हूं। प्याज की कीमतें पिछले सप्ताह की तुलना में 15% बढ़ी हैं।',
        'category': 'market_info',
        'tags': ['market', 'prices', 'onion', 'Maharashtra'],
        'tagsHindi': ['बाजार', 'भाव', 'प्याज', 'महाराष्ट्र'],
      },
      {
        'title': 'Export opportunities for organic spices',
        'titleHindi': 'जैविक मसालों के लिए निर्यात के अवसर',
        'content':
            'High demand for organic turmeric and ginger in European markets. Prices are 3x higher than domestic market. Certification process is straightforward.',
        'contentHindi':
            'यूरोपीय बाजारों में जैविक हल्दी और अदरक की अधिक मांग है। कीमतें घरेलू बाजार से 3 गुना अधिक हैं। प्रमाणन प्रक्रिया सरल है।',
        'category': 'market_info',
        'tags': ['export', 'organic', 'spices', 'turmeric', 'ginger'],
        'tagsHindi': ['निर्यात', 'जैविक', 'मसाले', 'हल्दी', 'अदरक'],
      },
      {
        'title': 'Direct selling to consumers - Higher profits',
        'titleHindi': 'उपभोक्ताओं को सीधे बेचना - अधिक मुनाफा',
        'content':
            'Started selling directly to consumers through WhatsApp groups. Cut out middlemen, getting 50% higher prices. Building loyal customer base.',
        'contentHindi':
            'व्हाट्सऐप ग्रुप्स के माध्यम से उपभोक्ताओं को सीधे बेचना शुरू किया। बिचौलियों को हटाया, 50% अधिक कीमतें मिल रही हैं। वफादार ग्राहक आधार बना रहा हूं।',
        'category': 'market_info',
        'tags': ['direct selling', 'WhatsApp', 'consumers', 'profit'],
        'tagsHindi': ['सीधी बिक्री', 'व्हाट्सऐप', 'उपभोक्ता', 'मुनाफा'],
      },

      // Problem Solving
      {
        'title': 'Yellowing leaves in tomato plants - Solution found',
        'titleHindi': 'टमाटर के पौधों में पीली पत्तियां - समाधान मिला',
        'content':
            'Faced severe yellowing in tomato plants. Root cause was nitrogen deficiency and poor drainage. Applied organic nitrogen and improved drainage. Plants recovered in 2 weeks.',
        'contentHindi':
            'टमाटर के पौधों में गंभीर पीलापन का सामना किया। मूल कारण नाइट्रोजन की कमी और खराब जल निकासी था। जैविक नाइट्रोजन लगाया और जल निकासी में सुधार किया। 2 सप्ताह में पौधे ठीक हो गए।',
        'category': 'problem_solving',
        'tags': ['tomato', 'yellowing', 'nitrogen', 'drainage'],
        'tagsHindi': ['टमाटर', 'पीलापन', 'नाइट्रोजन', 'जल निकासी'],
      },
      {
        'title': 'Fruit drop in mango trees - How I solved it',
        'titleHindi': 'आम के पेड़ों में फल गिरना - मैंने कैसे हल किया',
        'content':
            'Heavy fruit drop in mango trees during flowering. Applied calcium and boron spray, improved irrigation timing. Fruit retention increased by 60%.',
        'contentHindi':
            'फूल आने के दौरान आम के पेड़ों में भारी फल गिरना। कैल्शियम और बोरॉन स्प्रे लगाया, सिंचाई का समय सुधारा। फल धारण 60% बढ़ गया।',
        'category': 'problem_solving',
        'tags': ['mango', 'fruit drop', 'calcium', 'boron'],
        'tagsHindi': ['आम', 'फल गिरना', 'कैल्शियम', 'बोरॉन'],
      },
      {
        'title': 'Soil salinity issue - Reclamation success',
        'titleHindi': 'मिट्टी की लवणता की समस्या - सुधार में सफलता',
        'content':
            'Farm had high soil salinity affecting crop growth. Applied gypsum, used salt-tolerant varieties, improved drainage. Soil health improved significantly in 2 years.',
        'contentHindi':
            'खेत में उच्च मिट्टी लवणता थी जो फसल वृद्धि को प्रभावित कर रही थी। जिप्सम लगाया, नमक-सहिष्णु किस्में उपयोग कीं, जल निकासी सुधारी। 2 साल में मिट्टी का स्वास्थ्य काफी सुधरा।',
        'category': 'problem_solving',
        'tags': ['salinity', 'gypsum', 'drainage', 'soil health'],
        'tagsHindi': ['लवणता', 'जिप्सम', 'जल निकासी', 'मिट्टी स्वास्थ्य'],
      },
      {
        'title': 'Pest attack on brinjal - Natural solution',
        'titleHindi': 'बैंगन पर कीट आक्रमण - प्राकृतिक समाधान',
        'content':
            'Severe pest attack on brinjal crop. Used neem oil + soap solution, planted marigolds as trap crops, released beneficial insects. Pest population reduced by 80%.',
        'contentHindi':
            'बैंगन की फसल पर गंभीर कीट आक्रमण। नीम तेल + साबुन घोल का उपयोग किया, ट्रैप फसल के रूप में गेंदे लगाए, लाभकारी कीट छोड़े। कीट आबादी 80% कम हो गई।',
        'category': 'problem_solving',
        'tags': ['pest control', 'brinjal', 'neem', 'biological control'],
        'tagsHindi': ['कीट नियंत्रण', 'बैंगन', 'नीम', 'जैविक नियंत्रण'],
      },

      // Technology and Innovation
      {
        'title': 'Drone technology in agriculture - My experience',
        'titleHindi': 'कृषि में ड्रोन तकनीक - मेरा अनुभव',
        'content':
            'Used drone for crop monitoring and pesticide spraying. 50% reduction in pesticide use, better coverage, time saving. Investment recovered in 2 seasons.',
        'contentHindi':
            'फसल निगरानी और कीटनाशक छिड़काव के लिए ड्रोन का उपयोग किया। कीटनाशक उपयोग में 50% कमी, बेहतर कवरेज, समय की बचत। 2 सीजन में निवेश वसूला।',
        'category': 'crop_advice',
        'tags': ['drone', 'technology', 'monitoring', 'spraying'],
        'tagsHindi': ['ड्रोन', 'तकनीक', 'निगरानी', 'छिड़काव'],
      },
      {
        'title': 'IoT sensors for smart irrigation',
        'titleHindi': 'स्मार्ट सिंचाई के लिए IoT सेंसर',
        'content':
            'Installed soil moisture sensors connected to mobile app. Automatic irrigation based on soil conditions. Water usage reduced by 30%, yield increased by 15%.',
        'contentHindi':
            'मोबाइल ऐप से जुड़े मिट्टी नमी सेंसर लगाए। मिट्टी की स्थिति के आधार पर स्वचालित सिंचाई। पानी का उपयोग 30% कम, उत्पादन 15% बढ़ा।',
        'category': 'crop_advice',
        'tags': ['IoT', 'sensors', 'smart irrigation', 'automation'],
        'tagsHindi': ['IoT', 'सेंसर', 'स्मार्ट सिंचाई', 'स्वचालन'],
      },
    ];

    for (int i = 0; i < mockPosts.length; i++) {
      final post = mockPosts[i];
      _forumPosts.add(ForumPost(
        id: 'MOCK_POST_$i',
        authorId: 'USER_${random.nextInt(100)}',
        authorName: 'Farmer ${i + 1}',
        authorNameHindi: 'किसान ${i + 1}',
        title: post['title'] as String,
        titleHindi: post['titleHindi'] as String,
        content: post['content'] as String,
        contentHindi: post['contentHindi'] as String,
        category: post['category'] as String,
        tags: List<String>.from(post['tags']! as List),
        tagsHindi: List<String>.from(post['tagsHindi']! as List),
        createdAt: DateTime.now().subtract(Duration(days: random.nextInt(30))),
        likeCount: random.nextInt(50),
        commentCount: random.nextInt(20),
        isPinned: i == 0,
        isExpertVerified: random.nextBool(),
        location: 'Maharashtra',
        locationHindi: 'महाराष्ट्र',
      ));
    }
  }

  void _generateMockComments() {
    final random = math.Random();

    for (int i = 0; i < 10; i++) {
      _comments.add(ForumComment(
        id: 'MOCK_COMMENT_$i',
        postId: 'MOCK_POST_${i % 3}',
        authorId: 'USER_${random.nextInt(100)}',
        authorName: 'Commenter ${i + 1}',
        authorNameHindi: 'टिप्पणीकर्ता ${i + 1}',
        content:
            'Thank you for sharing this valuable information. Very helpful!',
        contentHindi:
            'इस मूल्यवान जानकारी को साझा करने के लिए धन्यवाद। बहुत उपयोगी!',
        createdAt: DateTime.now().subtract(Duration(hours: random.nextInt(48))),
        likeCount: random.nextInt(10),
        isExpertComment: random.nextBool(),
        isHelpful: random.nextBool(),
      ));
    }
  }

  void _generateMockExperiences() {
    final random = math.Random();

    final mockExperiences = [
      {
        'title': 'Integrated farming increased my income by 60%',
        'titleHindi': 'एकीकृत कृषि ने मेरी आय 60% बढ़ाई',
        'experience':
            'By combining crop farming with fish farming and dairy, I diversified my income sources and reduced risks.',
        'experienceHindi':
            'फसल की खेती को मछली पालन और डेयरी के साथ जोड़कर, मैंने अपनी आय के स्रोतों में विविधता लाई और जोखिम कम किया।',
        'category': 'success',
        'cropType': 'Mixed Farming',
        'cropTypeHindi': 'मिश्रित कृषि',
      },
      {
        'title': 'Lesson learned from crop failure',
        'titleHindi': 'फसल खराब होने से सीखा गया सबक',
        'experience':
            'Due to improper water management, I lost 30% of my crop. Now I use moisture sensors for better irrigation control.',
        'experienceHindi':
            'अनुचित जल प्रबंधन के कारण, मैंने अपनी फसल का 30% नुकसान उठाया। अब मैं बेहतर सिंचाई नियंत्रण के लिए नमी सेंसर का उपयोग करता हूं।',
        'category': 'failure',
        'cropType': 'Tomato',
        'cropTypeHindi': 'टमाटर',
      },
    ];

    for (int i = 0; i < mockExperiences.length; i++) {
      final exp = mockExperiences[i];
      _experiences.add(ExperienceShare(
        id: 'MOCK_EXP_$i',
        farmerId: 'FARMER_${random.nextInt(100)}',
        farmerName: 'Success Farmer ${i + 1}',
        farmerNameHindi: 'सफल किसान ${i + 1}',
        title: exp['title'] as String,
        titleHindi: exp['titleHindi'] as String,
        experience: exp['experience'] as String,
        experienceHindi: exp['experienceHindi'] as String,
        category: exp['category'] as String,
        cropType: exp['cropType'] as String,
        cropTypeHindi: exp['cropTypeHindi'] as String,
        season: 'Kharif 2024',
        yieldAchieved: 2500 + random.nextDouble() * 2000,
        profitMargin: 15 + random.nextDouble() * 35,
        techniquesUsed: ['Drip irrigation', 'Organic fertilizers', 'IPM'],
        techniquesUsedHindi: [
          'ड्रिप सिंचाई',
          'जैविक उर्वरक',
          'एकीकृत कीट प्रबंधन'
        ],
        challengesFaced: [
          'Weather variations',
          'Pest attacks',
          'Labor shortage'
        ],
        challengesFacedHindi: ['मौसम की मार', 'कीट आक्रमण', 'श्रमिक की कमी'],
        lessonsLearned: [
          'Plan for contingencies',
          'Diversify crops',
          'Use technology'
        ],
        lessonsLearnedHindi: [
          'आकस्मिकताओं के लिए योजना',
          'फसलों में विविधता',
          'तकनीक का उपयोग'
        ],
        sharedAt: DateTime.now().subtract(Duration(days: random.nextInt(60))),
        helpfulCount: random.nextInt(100),
        viewCount: random.nextInt(500),
        isFeatured: i == 0,
        location: 'Punjab',
        locationHindi: 'पंजाब',
      ));
    }
  }

  void _generateMockMembers() {
    final random = math.Random();
    final levels = ['beginner', 'intermediate', 'advanced', 'expert'];

    for (int i = 0; i < 20; i++) {
      _members.add(CommunityMember(
        id: 'MEMBER_$i',
        name: 'Farmer ${i + 1}',
        nameHindi: 'किसान ${i + 1}',
        profileImage: 'assets/images/profile_placeholder.png',
        location: 'Maharashtra',
        locationHindi: 'महाराष्ट्र',
        farmSize: 1.0 + random.nextDouble() * 10,
        cropSpecializations: ['Wheat', 'Rice', 'Cotton'],
        cropSpecializationsHindi: ['गेहूं', 'धान', 'कपास'],
        membershipLevel: levels[random.nextInt(levels.length)],
        postsCount: random.nextInt(50),
        helpfulAnswers: random.nextInt(30),
        communityRating: 3.0 + random.nextDouble() * 2,
        joinedDate:
            DateTime.now().subtract(Duration(days: random.nextInt(365))),
        isVerifiedFarmer: random.nextBool(),
        isExpert: i < 3,
        bio: 'Experienced farmer with focus on sustainable agriculture',
        bioHindi: 'टिकाऊ कृषि पर ध्यान देने वाला अनुभवी किसान',
        achievements: ['Best Yield 2023', 'Organic Certified'],
        achievementsHindi: ['सर्वश्रेष्ठ उत्पादन 2023', 'जैविक प्रमाणित'],
      ));
    }
  }

  void _generateMockExpertAdvice() {
    final random = math.Random();

    final mockAdvice = [
      {
        'question': 'How to control pest attack in tomato crop?',
        'questionHindi': 'टमाटर की फसल में कीट आक्रमण को कैसे नियंत्रित करें?',
        'answer':
            'Use IPM approach combining biological controls, neem oil spray, and yellow sticky traps. Monitor regularly and spray only when threshold is reached.',
        'answerHindi':
            'जैविक नियंत्रण, नीम तेल स्प्रे, और पीले स्टिकी ट्रैप्स को मिलाकर IPM दृष्टिकोण का उपयोग करें। नियमित निगरानी करें और केवल तभी स्प्रे करें जब सीमा पहुंच जाए।',
        'expertise': 'pest_management',
      },
      {
        'question': 'Best soil preparation for wheat sowing?',
        'questionHindi': 'गेहूं की बुआई के लिए सर्वोत्तम मिट्टी की तैयारी?',
        'answer':
            'Deep plowing followed by 2-3 harrowing. Add farmyard manure @10 tons/hectare. Ensure proper leveling for uniform water distribution.',
        'answerHindi':
            'गहरी जुताई के बाद 2-3 बार हैरो करें। 10 टन/हेक्टेयर की दर से गोबर खाद डालें। समान पानी वितरण के लिए उचित समतलीकरण सुनिश्चित करें।',
        'expertise': 'agronomy',
      },
    ];

    for (int i = 0; i < mockAdvice.length; i++) {
      final advice = mockAdvice[i];
      _expertAdvice.add(ExpertAdvice(
        id: 'MOCK_ADVICE_$i',
        expertId: 'EXPERT_${i + 1}',
        expertName: 'Dr. Expert ${i + 1}',
        expertNameHindi: 'डॉ. विशेषज्ञ ${i + 1}',
        questionId: 'QUESTION_$i',
        question: advice['question'] as String,
        questionHindi: advice['questionHindi'] as String,
        answer: advice['answer'] as String,
        answerHindi: advice['answerHindi'] as String,
        category: 'crop_advice',
        expertise: advice['expertise'] as String,
        providedAt:
            DateTime.now().subtract(Duration(hours: random.nextInt(168))),
        helpfulVotes: random.nextInt(50),
        isVerifiedAnswer: true,
        references: [
          'Agricultural Extension Guidelines',
          'Research Paper 2024'
        ],
        referencesHindi: ['कृषि विस्तार दिशानिर्देश', 'अनुसंधान पत्र 2024'],
      ));
    }
  }

  void _generateMockLearningGroups() {
    final random = math.Random();

    final mockGroups = [
      {
        'name': 'Organic Farming Enthusiasts',
        'nameHindi': 'जैविक खेती प्रेमी',
        'description':
            'Learn and share organic farming techniques and experiences',
        'descriptionHindi':
            'जैविक खेती तकनीकों और अनुभवों को सीखें और साझा करें',
        'category': 'technique_focused',
      },
      {
        'name': 'Punjab Wheat Growers',
        'nameHindi': 'पंजाब गेहूं उत्पादक',
        'description': 'Regional group for wheat farmers in Punjab',
        'descriptionHindi': 'पंजाब में गेहूं किसानों के लिए क्षेत्रीय समूह',
        'category': 'region_based',
      },
    ];

    for (int i = 0; i < mockGroups.length; i++) {
      final group = mockGroups[i];
      final memberCount = 10 + random.nextInt(40);
      _learningGroups.add(PeerLearningGroup(
        id: 'MOCK_GROUP_$i',
        name: group['name'] as String,
        nameHindi: group['nameHindi'] as String,
        description: group['description'] as String,
        descriptionHindi: group['descriptionHindi'] as String,
        category: group['category'] as String,
        adminId: 'ADMIN_$i',
        memberIds: List.generate(memberCount, (index) => 'MEMBER_$index'),
        location: 'All India',
        locationHindi: 'सभी भारत',
        createdAt: DateTime.now().subtract(Duration(days: random.nextInt(180))),
        tags: ['farming', 'community', 'learning'],
        tagsHindi: ['खेती', 'समुदाय', 'शिक्षा'],
      ));
    }
  }

  void _generateMockNotifications() {
    final random = math.Random();

    for (int i = 0; i < 5; i++) {
      _notifications.add(CommunityNotification(
        id: 'MOCK_NOTIF_$i',
        recipientId: 'USER_123',
        type: 'post_like',
        title: 'Your post got a new like!',
        titleHindi: 'आपकी पोस्ट को नया लाइक मिला!',
        message: 'Someone liked your post about organic farming',
        messageHindi: 'किसी ने जैविक खेती के बारे में आपकी पोस्ट को पसंद किया',
        relatedPostId: 'MOCK_POST_0',
        createdAt: DateTime.now().subtract(Duration(hours: random.nextInt(72))),
      ));
    }
  }
}
