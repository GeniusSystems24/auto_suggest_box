import 'package:fluent_ui/fluent_ui.dart';
import 'package:auto_suggest_box/auto_suggest_box.dart';
import 'package:flutter/material.dart' show InputDecoration;
import 'package:gap/gap.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceSearchPage extends StatefulWidget {
  const VoiceSearchPage({super.key});

  @override
  State<VoiceSearchPage> createState() => _VoiceSearchPageState();
}

class _VoiceSearchPageState extends State<VoiceSearchPage> {
  final TextEditingController _textController = TextEditingController();
  late VoiceSearchController _voiceController;
  String _status = 'Not initialized';
  String _lastRecognizedWords = '';
  bool _isInitialized = false;
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  bool _isCheckingPermission = false;

  final List<FluentAutoSuggestBoxItem<String>> _items = [
    FluentAutoSuggestBoxItem(value: '1', label: 'Apple iPhone 15 Pro'),
    FluentAutoSuggestBoxItem(value: '2', label: 'Samsung Galaxy S24 Ultra'),
    FluentAutoSuggestBoxItem(value: '3', label: 'Google Pixel 8 Pro'),
    FluentAutoSuggestBoxItem(value: '4', label: 'OnePlus 12'),
    FluentAutoSuggestBoxItem(value: '5', label: 'Xiaomi 14 Pro'),
    FluentAutoSuggestBoxItem(value: '6', label: 'Sony Xperia 1 V'),
    FluentAutoSuggestBoxItem(value: '7', label: 'Motorola Edge 40 Pro'),
    FluentAutoSuggestBoxItem(value: '8', label: 'Asus ROG Phone 8'),
    FluentAutoSuggestBoxItem(value: '9', label: 'Nothing Phone 2'),
    FluentAutoSuggestBoxItem(value: '10', label: 'Oppo Find X7 Pro'),
  ];

  @override
  void initState() {
    super.initState();
    _initVoiceController();
    _checkPermission();
  }

  void _initVoiceController() {
    _voiceController = VoiceSearchController(
      localeId: 'en_US',
      onResult: (text, isFinal) {
        setState(() {
          _lastRecognizedWords = text;
          if (isFinal) {
            _textController.text = text;
            _textController.selection = TextSelection.collapsed(offset: text.length);
          }
        });
      },
      onError: (error) {
        setState(() {
          _status = 'Error: $error';
        });
      },
    );

    _voiceController.addListener(_onVoiceStateChanged);
  }

  Future<void> _checkPermission() async {
    setState(() => _isCheckingPermission = true);
    _permissionStatus = await _voiceController.checkPermission();
    setState(() => _isCheckingPermission = false);
  }

  Future<void> _requestPermission() async {
    setState(() => _isCheckingPermission = true);
    _permissionStatus = await _voiceController.requestPermission();
    setState(() => _isCheckingPermission = false);

    if (_permissionStatus.isGranted) {
      _initialize();
    }
  }

  Future<void> _openSettings() async {
    await _voiceController.openSettings();
  }

  void _onVoiceStateChanged() {
    if (!mounted) return;
    setState(() {
      if (_voiceController.isListening) {
        _status = 'Listening...';
      } else if (_voiceController.isAvailable) {
        _status = 'Ready';
      } else if (_voiceController.isInitialized) {
        _status = 'Not available on this device';
      }
    });
  }

  Future<void> _initialize() async {
    setState(() => _status = 'Initializing...');
    final available = await _voiceController.initialize();
    setState(() {
      _isInitialized = true;
      _status = available ? 'Ready' : 'Not available on this device';
    });
  }

  @override
  void dispose() {
    _voiceController.removeListener(_onVoiceStateChanged);
    _voiceController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Color _getPermissionColor() {
    switch (_permissionStatus) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return Colors.green;
      case PermissionStatus.denied:
        return Colors.orange;
      case PermissionStatus.permanentlyDenied:
        return Colors.red;
      case PermissionStatus.restricted:
        return Colors.grey;
      case PermissionStatus.provisional:
        return Colors.blue;
    }
  }

  String _getPermissionStatusText() {
    switch (_permissionStatus) {
      case PermissionStatus.granted:
        return 'Granted';
      case PermissionStatus.limited:
        return 'Limited';
      case PermissionStatus.denied:
        return 'Denied';
      case PermissionStatus.permanentlyDenied:
        return 'Permanently Denied';
      case PermissionStatus.restricted:
        return 'Restricted';
      case PermissionStatus.provisional:
        return 'Provisional';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('Voice Search'),
      ),
      children: [
        // Info Card
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(FluentIcons.info, size: 20),
                  const Gap(8),
                  Text(
                    'About Voice Search',
                    style: FluentTheme.of(context).typography.subtitle,
                  ),
                ],
              ),
              const Gap(12),
              const Text(
                'Voice search allows users to speak their search queries instead of typing. '
                'This feature uses the device\'s speech recognition capabilities.',
              ),
              const Gap(8),
              InfoBar(
                title: const Text('Note'),
                content: const Text(
                  'Voice search requires microphone permissions and may not be available on all devices or platforms.',
                ),
                severity: InfoBarSeverity.warning,
              ),
            ],
          ),
        ),
        const Gap(24),

        // Permission Status Card
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(FluentIcons.permissions, size: 20),
                  const Gap(8),
                  Text(
                    'Microphone Permission',
                    style: FluentTheme.of(context).typography.subtitle,
                  ),
                ],
              ),
              const Gap(16),

              // Permission status indicator
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getPermissionColor(),
                    ),
                  ),
                  const Gap(8),
                  Text('Status: ${_getPermissionStatusText()}'),
                  if (_isCheckingPermission) ...[
                    const Gap(8),
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: ProgressRing(strokeWidth: 2),
                    ),
                  ],
                ],
              ),
              const Gap(16),

              // Permission action buttons
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  if (!_permissionStatus.isGranted && !_permissionStatus.isPermanentlyDenied)
                    FilledButton(
                      onPressed: _isCheckingPermission ? null : _requestPermission,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(FluentIcons.microphone, size: 16),
                          const Gap(8),
                          const Text('Request Permission'),
                        ],
                      ),
                    ),
                  if (_permissionStatus.isPermanentlyDenied)
                    FilledButton(
                      onPressed: _openSettings,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(FluentIcons.settings, size: 16),
                          const Gap(8),
                          const Text('Open Settings'),
                        ],
                      ),
                    ),
                  Button(
                    onPressed: _isCheckingPermission ? null : _checkPermission,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(FluentIcons.refresh, size: 16),
                        const Gap(8),
                        const Text('Refresh Status'),
                      ],
                    ),
                  ),
                ],
              ),

              if (_permissionStatus.isPermanentlyDenied) ...[
                const Gap(12),
                InfoBar(
                  title: const Text('Permission Denied'),
                  content: const Text(
                    'Microphone permission was permanently denied. Please enable it from app settings.',
                  ),
                  severity: InfoBarSeverity.error,
                ),
              ],
            ],
          ),
        ),
        const Gap(24),

        // Voice Search Demo
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(FluentIcons.microphone, size: 20),
                  const Gap(8),
                  Text(
                    'Voice Search Demo',
                    style: FluentTheme.of(context).typography.subtitle,
                  ),
                ],
              ),
              const Gap(16),

              // Status
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _voiceController.isListening
                          ? Colors.red
                          : (_voiceController.isAvailable ? Colors.green : Colors.grey),
                    ),
                  ),
                  const Gap(8),
                  Text('Status: $_status'),
                ],
              ),
              const Gap(16),

              // Initialize button
              if (!_isInitialized)
                FilledButton(
                  onPressed: _initialize,
                  child: const Text('Initialize Voice Recognition'),
                ),

              if (_isInitialized) ...[
                // Search field with voice button
                Row(
                  children: [
                    Expanded(
                      child: FluentAutoSuggestBox<String>(
                        items: _items,
                        controller: _textController,
                        decoration: const InputDecoration(
                          labelText: 'Search products',
                          hintText: 'Type or use voice search...',
                        ),
                        onSelected: (item) {
                          if (item != null) {
                            displayInfoBar(
                              context,
                              builder: (context, close) => InfoBar(
                                title: const Text('Selected'),
                                content: Text(item.label),
                                severity: InfoBarSeverity.success,
                                action: IconButton(
                                  icon: const Icon(FluentIcons.clear),
                                  onPressed: close,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const Gap(12),
                    // Voice button
                    ListenableBuilder(
                      listenable: _voiceController,
                      builder: (context, _) {
                        final isListening = _voiceController.isListening;
                        final isAvailable = _voiceController.isAvailable;

                        return Tooltip(
                          message: isListening ? 'Stop listening' : 'Start voice search',
                          child: Container(
                            decoration: BoxDecoration(
                              color: isListening
                                  ? Colors.red.withOpacity(0.2)
                                  : FluentTheme.of(context).accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  isListening ? FluentIcons.microphone : FluentIcons.microphone,
                                  size: 24,
                                  color: isListening
                                      ? Colors.red
                                      : (isAvailable
                                          ? FluentTheme.of(context).accentColor
                                          : Colors.grey),
                                ),
                              ),
                              onPressed: isAvailable
                                  ? () {
                                      if (isListening) {
                                        _voiceController.stopListening();
                                      } else {
                                        _voiceController.startListening();
                                      }
                                    }
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const Gap(16),

                // Recognized words
                if (_lastRecognizedWords.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: FluentTheme.of(context).micaBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(FluentIcons.chat, size: 16),
                        const Gap(8),
                        Expanded(
                          child: Text(
                            'Recognized: "$_lastRecognizedWords"',
                            style: FluentTheme.of(context).typography.body,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
        const Gap(24),

        // Available Locales
        if (_isInitialized && _voiceController.availableLocales.isNotEmpty)
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(FluentIcons.locale_language, size: 20),
                    const Gap(8),
                    Text(
                      'Available Languages',
                      style: FluentTheme.of(context).typography.subtitle,
                    ),
                  ],
                ),
                const Gap(12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _voiceController.availableLocales.take(10).map((locale) {
                    final isSelected = locale.localeId == _voiceController.currentLocale;
                    return Button(
                      onPressed: () {
                        _voiceController.setLocale(locale.localeId);
                        setState(() {});
                      },
                      style: ButtonStyle(
                        backgroundColor: isSelected
                            ? WidgetStatePropertyAll(FluentTheme.of(context).accentColor)
                            : null,
                      ),
                      child: Text(locale.name),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        const Gap(24),

        // Code Example
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(FluentIcons.code, size: 20),
                  const Gap(8),
                  Text(
                    'Code Example',
                    style: FluentTheme.of(context).typography.subtitle,
                  ),
                ],
              ),
              const Gap(16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: FluentTheme.of(context).micaBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  '''
// Create voice controller
final voiceController = VoiceSearchController(
  localeId: 'en_US', // or 'ar_SA' for Arabic
  onResult: (text, isFinal) {
    if (isFinal) {
      textController.text = text;
    }
  },
  onError: (error) => print('Error: \$error'),
);

// Check permission status
final status = await voiceController.checkPermission();
print('Permission status: \$status');

// Request permission
final newStatus = await voiceController.requestPermission();
if (newStatus.isGranted) {
  // Permission granted, proceed with initialization
}

// Open app settings (if permanently denied)
if (newStatus.isPermanentlyDenied) {
  await voiceController.openSettings();
}

// Initialize (auto-requests permission if needed)
await voiceController.initialize();

// Start/Stop listening
await voiceController.startListening();
await voiceController.stopListening();

// Use VoiceSearchButton widget
VoiceSearchButton(
  controller: voiceController,
  activeColor: Colors.red,
  inactiveColor: Colors.grey,
)''',
                  style: FluentTheme.of(context).typography.body?.copyWith(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
