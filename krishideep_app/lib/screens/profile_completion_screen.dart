import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_profile.dart';
import '../services/user_profile_service.dart';
import '../main.dart' as app_main;

class ProfileCompletionScreen extends StatefulWidget {
  final String? email;
  final String? phone;

  const ProfileCompletionScreen({
    super.key,
    this.email,
    this.phone,
  });

  @override
  State<ProfileCompletionScreen> createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _userProfileService = UserProfileService();

  bool _isLoading = false;
  bool _canSkip = true;

  @override
  void initState() {
    super.initState();
    // Pre-fill phone if available
    if (widget.phone != null) {
      _phoneController.text = widget.phone!.replaceAll('+91', '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('complete_profile'.tr()),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          if (_canSkip)
            TextButton(
              onPressed: _skipProfile,
              child: Text(
                'skip_for_now'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade700, Colors.green.shade50],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Welcome Message
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person_add,
                        size: 64,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'complete_profile'.tr(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'complete_profile_message'.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Profile Form
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'profile_information'.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Name Field
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'full_name'.tr(),
                            hintText: 'enter_full_name'.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'name_required'.tr();
                            }
                            if (value.trim().length < 2) {
                              return 'invalid_name'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Phone Field
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'phone_number'.tr(),
                            hintText: 'phone_number'.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.phone),
                            prefixText: '+91 ',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'phone_required'.tr();
                            }
                            if (value.trim().length != 10) {
                              return 'invalid_phone'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // City Field
                        TextFormField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            labelText: 'city'.tr(),
                            hintText: 'enter_city'.tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.location_city),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'city_required'.tr();
                            }
                            if (value.trim().length < 2) {
                              return 'invalid_city'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'save_profile'.tr(),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final profile = UserProfile(
        uid: user.uid,
        name: _nameController.text.trim(),
        phone: '+91${_phoneController.text.trim()}',
        city: _cityController.text.trim(),
        email: widget.email ?? user.email ?? '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        // Save to Firebase
        await _userProfileService.createOrUpdateProfile(profile);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('profile_saved'.tr()),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        print('Firebase save failed: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('profile_save_failed'.tr()),
            backgroundColor: Colors.red,
          ),
        );
      }

      // Update auth provider
      final authProvider =
          Provider.of<app_main.AuthProvider>(context, listen: false);
      authProvider.setLoggedIn(true);

      // Navigate to main screen
      Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _skipProfile() async {
    // Update auth provider
    final authProvider =
        Provider.of<app_main.AuthProvider>(context, listen: false);
    authProvider.setLoggedIn(true);

    // Navigate to main screen
    Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}
