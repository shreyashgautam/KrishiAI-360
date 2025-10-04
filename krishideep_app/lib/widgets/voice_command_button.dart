import 'package:flutter/material.dart';
import '../services/simple_voice_assistant_service.dart';

class VoiceCommandButton extends StatefulWidget {
  final Function(String) onVoiceResult;
  final Function()? onStartListening;
  final Function()? onStopListening;
  final String languageCode;

  const VoiceCommandButton({
    super.key,
    required this.onVoiceResult,
    this.onStartListening,
    this.onStopListening,
    this.languageCode = 'en',
  });

  @override
  State<VoiceCommandButton> createState() => _VoiceCommandButtonState();
}

class _VoiceCommandButtonState extends State<VoiceCommandButton>
    with TickerProviderStateMixin {
  bool _isListening = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final SimpleVoiceAssistantService _voiceAssistant =
      SimpleVoiceAssistantService();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _initializeVoiceAssistant();
  }

  Future<void> _initializeVoiceAssistant() async {
    try {
      _isInitialized = await _voiceAssistant.initialize();
      await _voiceAssistant.setLanguage(widget.languageCode);
    } catch (e) {
      print('Error initializing voice assistant: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startListening() async {
    if (!_isInitialized) {
      await _initializeVoiceAssistant();
    }

    if (!_isInitialized) {
      widget.onVoiceResult(
          'Voice assistant not available. Please check microphone permissions.');
      return;
    }

    setState(() {
      _isListening = true;
    });
    _animationController.repeat(reverse: true);
    widget.onStartListening?.call();

    // Simulate voice command processing
    await _voiceAssistant.processVoiceCommand(
      'weather forecast', // Default command for demo
      (result) {
        setState(() {
          _isListening = false;
        });
        _animationController.stop();
        _animationController.reset();
        widget.onStopListening?.call();
        widget.onVoiceResult(result);
      },
      (error) {
        setState(() {
          _isListening = false;
        });
        _animationController.stop();
        _animationController.reset();
        widget.onStopListening?.call();
        widget.onVoiceResult('Error: $error');
      },
    );
  }

  void _stopListening() async {
    setState(() {
      _isListening = false;
    });
    _animationController.stop();
    _animationController.reset();
    widget.onStopListening?.call();
    await _voiceAssistant.stopSpeaking();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isListening ? _stopListening : _startListening,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isListening ? _scaleAnimation.value : 1.0,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isListening ? Colors.red : Colors.blue.shade600,
                boxShadow: [
                  BoxShadow(
                    color: (_isListening ? Colors.red : Colors.blue.shade600)
                        .withOpacity(0.3),
                    blurRadius: _isListening ? 15 : 8,
                    spreadRadius: _isListening ? 3 : 1,
                  ),
                ],
              ),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 28,
              ),
            ),
          );
        },
      ),
    );
  }
}
