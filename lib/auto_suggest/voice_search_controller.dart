import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

/// Controller for managing voice search functionality
class VoiceSearchController extends ChangeNotifier {
  VoiceSearchController({
    this.localeId,
    this.onResult,
    this.onError,
    this.listenFor = const Duration(seconds: 30),
    this.pauseFor = const Duration(seconds: 3),
  });

  /// The locale to use for speech recognition (e.g., 'en_US', 'ar_SA')
  final String? localeId;

  /// Callback when speech recognition produces a result
  final void Function(String text, bool isFinal)? onResult;

  /// Callback when an error occurs
  final void Function(String error)? onError;

  /// Maximum duration to listen for speech
  final Duration listenFor;

  /// Duration of silence before stopping
  final Duration pauseFor;

  final SpeechToText _speech = SpeechToText();

  bool _isInitialized = false;
  bool _isListening = false;
  bool _isAvailable = false;
  String _lastWords = '';
  String _currentLocale = '';
  List<LocaleName> _availableLocales = [];

  /// Whether the speech recognition is initialized
  bool get isInitialized => _isInitialized;

  /// Whether speech recognition is currently listening
  bool get isListening => _isListening;

  /// Whether speech recognition is available on this device
  bool get isAvailable => _isAvailable;

  /// The last recognized words
  String get lastWords => _lastWords;

  /// The current locale being used
  String get currentLocale => _currentLocale;

  /// Available locales for speech recognition
  List<LocaleName> get availableLocales => _availableLocales;

  /// Initialize speech recognition
  Future<bool> initialize() async {
    if (_isInitialized) return _isAvailable;

    try {
      _isAvailable = await _speech.initialize(
        onError: _handleError,
        onStatus: _handleStatus,
        debugLogging: kDebugMode,
      );

      if (_isAvailable) {
        _availableLocales = await _speech.locales();

        // Set current locale
        if (localeId != null) {
          _currentLocale = localeId!;
        } else {
          final systemLocale = await _speech.systemLocale();
          _currentLocale = systemLocale?.localeId ?? 'en_US';
        }
      }

      _isInitialized = true;
      notifyListeners();
      return _isAvailable;
    } catch (e) {
      _isInitialized = false;
      _isAvailable = false;
      onError?.call('Failed to initialize speech recognition: $e');
      notifyListeners();
      return false;
    }
  }

  /// Start listening for speech
  Future<void> startListening() async {
    if (!_isInitialized) {
      final available = await initialize();
      if (!available) return;
    }

    if (!_isAvailable || _isListening) return;

    _lastWords = '';
    _isListening = true;
    notifyListeners();

    await _speech.listen(
      onResult: _handleResult,
      listenFor: listenFor,
      pauseFor: pauseFor,
      localeId: _currentLocale,
      cancelOnError: true,
      partialResults: true,
      listenMode: ListenMode.confirmation,
    );
  }

  /// Stop listening for speech
  Future<void> stopListening() async {
    if (!_isListening) return;

    await _speech.stop();
    _isListening = false;
    notifyListeners();
  }

  /// Cancel speech recognition
  Future<void> cancel() async {
    await _speech.cancel();
    _isListening = false;
    _lastWords = '';
    notifyListeners();
  }

  /// Change the locale for speech recognition
  void setLocale(String localeId) {
    _currentLocale = localeId;
    notifyListeners();
  }

  void _handleResult(SpeechRecognitionResult result) {
    _lastWords = result.recognizedWords;
    onResult?.call(result.recognizedWords, result.finalResult);

    if (result.finalResult) {
      _isListening = false;
    }

    notifyListeners();
  }

  void _handleError(SpeechRecognitionError error) {
    _isListening = false;
    onError?.call(error.errorMsg);
    notifyListeners();
  }

  void _handleStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      _isListening = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }
}

/// Widget for voice search button
class VoiceSearchButton extends StatelessWidget {
  const VoiceSearchButton({
    super.key,
    required this.controller,
    this.onPressed,
    this.activeColor,
    this.inactiveColor,
    this.size = 24.0,
    this.tooltip,
  });

  final VoiceSearchController controller;
  final VoidCallback? onPressed;
  final Color? activeColor;
  final Color? inactiveColor;
  final double size;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final isListening = controller.isListening;
        final isAvailable = controller.isAvailable;

        return Tooltip(
          message: tooltip ?? (isListening ? 'Stop listening' : 'Voice search'),
          child: IconButton(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isListening ? Icons.mic : Icons.mic_none,
                size: size,
                color: isListening
                    ? (activeColor ?? Colors.red)
                    : (inactiveColor ?? (isAvailable ? null : Colors.grey)),
              ),
            ),
            onPressed: isAvailable
                ? () {
                    if (isListening) {
                      controller.stopListening();
                    } else {
                      controller.startListening();
                    }
                    onPressed?.call();
                  }
                : null,
          ),
        );
      },
    );
  }
}

/// Mixin for adding voice search capability to widgets
mixin VoiceSearchMixin<T extends StatefulWidget> on State<T> {
  late VoiceSearchController _voiceController;

  VoiceSearchController get voiceController => _voiceController;

  void initVoiceSearch({
    String? localeId,
    void Function(String text, bool isFinal)? onResult,
    void Function(String error)? onError,
  }) {
    _voiceController = VoiceSearchController(
      localeId: localeId,
      onResult: onResult,
      onError: onError,
    );
    _voiceController.initialize();
  }

  void disposeVoiceSearch() {
    _voiceController.dispose();
  }
}

// Re-export for convenience
import 'package:flutter/material.dart';
