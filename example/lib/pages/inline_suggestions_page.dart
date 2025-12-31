import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show InputDecoration;
import 'package:flutter/services.dart';
import 'package:auto_suggest_box/auto_suggest_box.dart';
import 'package:gap/gap.dart';

class InlineSuggestionsPage extends StatefulWidget {
  const InlineSuggestionsPage({super.key});

  @override
  State<InlineSuggestionsPage> createState() => _InlineSuggestionsPageState();
}

class _InlineSuggestionsPageState extends State<InlineSuggestionsPage> {
  final TextEditingController _textController = TextEditingController();
  late InlineSuggestionController _suggestionController;
  FluentAutoSuggestBoxItem<String>? _currentMatch;
  String _acceptedText = '';

  final List<FluentAutoSuggestBoxItem<String>> _items = [
    FluentAutoSuggestBoxItem(value: '1', label: 'flutter create my_app'),
    FluentAutoSuggestBoxItem(value: '2', label: 'flutter run'),
    FluentAutoSuggestBoxItem(value: '3', label: 'flutter build apk'),
    FluentAutoSuggestBoxItem(value: '4', label: 'flutter build ios'),
    FluentAutoSuggestBoxItem(value: '5', label: 'flutter clean'),
    FluentAutoSuggestBoxItem(value: '6', label: 'flutter pub get'),
    FluentAutoSuggestBoxItem(value: '7', label: 'flutter pub upgrade'),
    FluentAutoSuggestBoxItem(value: '8', label: 'flutter doctor'),
    FluentAutoSuggestBoxItem(value: '9', label: 'flutter analyze'),
    FluentAutoSuggestBoxItem(value: '10', label: 'flutter test'),
    FluentAutoSuggestBoxItem(value: '11', label: 'dart format .'),
    FluentAutoSuggestBoxItem(value: '12', label: 'dart fix --apply'),
    FluentAutoSuggestBoxItem(value: '13', label: 'dart pub outdated'),
    FluentAutoSuggestBoxItem(value: '14', label: 'dart compile exe'),
  ];

  @override
  void initState() {
    super.initState();
    _suggestionController = InlineSuggestionController(
      acceptKey: LogicalKeyboardKey.tab,
      partialAcceptKey: LogicalKeyboardKey.arrowRight,
      caseSensitive: false,
    );
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = _textController.text;
    _updateSuggestion(text);
  }

  void _updateSuggestion(String text) {
    if (text.isEmpty) {
      _suggestionController.clear();
      setState(() => _currentMatch = null);
      return;
    }

    final lowerText = text.toLowerCase();
    final match = _items.cast<FluentAutoSuggestBoxItem<String>?>().firstWhere(
          (item) => item!.label.toLowerCase().startsWith(lowerText),
          orElse: () => null,
        );

    if (match != null) {
      _currentMatch = match;
      _suggestionController.setSuggestion(match.label);
      _suggestionController.updateText(text);
    } else {
      _currentMatch = null;
      _suggestionController.clear();
    }
    setState(() {});
  }

  void _acceptFull() {
    if (_suggestionController.isVisible) {
      final newText = _suggestionController.acceptFull();
      _textController.text = newText;
      _textController.selection = TextSelection.collapsed(offset: newText.length);
      setState(() => _acceptedText = newText);
    }
  }

  void _acceptWord() {
    if (_suggestionController.isVisible) {
      final newText = _suggestionController.acceptWord();
      _textController.text = newText;
      _textController.selection = TextSelection.collapsed(offset: newText.length);
      setState(() {});
    }
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.tab && _suggestionController.isVisible) {
      _acceptFull();
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
        _suggestionController.isVisible &&
        _textController.selection.baseOffset == _textController.text.length) {
      _acceptWord();
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.escape && _suggestionController.isVisible) {
      _suggestionController.hide();
      setState(() {});
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _suggestionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('Inline Suggestions (Ghost Text)'),
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
                    'About Inline Suggestions',
                    style: theme.typography.subtitle,
                  ),
                ],
              ),
              const Gap(12),
              const Text(
                'Inline suggestions show autocomplete text as "ghost text" while you type. '
                'This provides a seamless typing experience similar to code editors and terminals.',
              ),
              const Gap(16),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildKeyHint(context, 'Tab', 'Accept full suggestion'),
                  _buildKeyHint(context, '→', 'Accept one word'),
                  _buildKeyHint(context, 'Esc', 'Dismiss suggestion'),
                ],
              ),
            ],
          ),
        ),
        const Gap(24),

        // Demo Card
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(FluentIcons.text_field, size: 20),
                  const Gap(8),
                  Text(
                    'Terminal Command Demo',
                    style: theme.typography.subtitle,
                  ),
                ],
              ),
              const Gap(8),
              const Text(
                'Try typing "flutter" or "dart" to see inline suggestions.',
              ),
              const Gap(16),

              // Input with ghost text
              KeyboardListener(
                focusNode: FocusNode(),
                onKeyEvent: _handleKeyEvent,
                child: Stack(
                  children: [
                    // Ghost text layer
                    ListenableBuilder(
                      listenable: _suggestionController,
                      builder: (context, _) {
                        if (!_suggestionController.isVisible) {
                          return const SizedBox.shrink();
                        }

                        return Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: _textController.text,
                                      style: theme.typography.body?.copyWith(
                                        color: Colors.transparent,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                    TextSpan(
                                      text: _suggestionController.ghostText,
                                      style: theme.typography.body?.copyWith(
                                        color: theme.resources.textFillColorDisabled,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    // Actual text field
                    TextBox(
                      controller: _textController,
                      placeholder: 'Type a command...',
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text('\$', style: TextStyle(fontFamily: 'monospace')),
                      ),
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ],
                ),
              ),
              const Gap(16),

              // Current suggestion info
              if (_currentMatch != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.micaBackgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(FluentIcons.lightbulb, size: 16),
                          const Gap(8),
                          Text(
                            'Suggestion: ${_currentMatch!.label}',
                            style: theme.typography.body,
                          ),
                        ],
                      ),
                      if (_suggestionController.ghostText.isNotEmpty) ...[
                        const Gap(4),
                        Text(
                          'Ghost text: "${_suggestionController.ghostText}"',
                          style: theme.typography.caption,
                        ),
                      ],
                    ],
                  ),
                ),

              if (_acceptedText.isNotEmpty) ...[
                const Gap(12),
                InfoBar(
                  title: const Text('Accepted'),
                  content: Text(_acceptedText),
                  severity: InfoBarSeverity.success,
                ),
              ],
            ],
          ),
        ),
        const Gap(24),

        // Using InlineSuggestionTextField Widget
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(FluentIcons.text_box, size: 20),
                  const Gap(8),
                  Text(
                    'InlineSuggestionTextField Widget',
                    style: theme.typography.subtitle,
                  ),
                ],
              ),
              const Gap(8),
              const Text(
                'A ready-to-use widget with built-in ghost text support.',
              ),
              const Gap(16),
              InlineSuggestionTextField<String>(
                items: _items,
                config: const InlineSuggestionConfig(
                  acceptOnTab: true,
                  partialAcceptOnArrowRight: true,
                ),
                decoration: const InputDecoration(
                  hintText: 'Start typing a command...',
                  prefixText: '\$ ',
                ),
                style: const TextStyle(fontFamily: 'monospace'),
                onSuggestionAccepted: (item) {
                  displayInfoBar(
                    context,
                    builder: (context, close) => InfoBar(
                      title: const Text('Command Selected'),
                      content: Text(item.label),
                      severity: InfoBarSeverity.info,
                      action: IconButton(
                        icon: const Icon(FluentIcons.clear),
                        onPressed: close,
                      ),
                    ),
                  );
                },
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
                    style: theme.typography.subtitle,
                  ),
                ],
              ),
              const Gap(16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.micaBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  '''
// Using InlineSuggestionTextField (simple)
InlineSuggestionTextField<Product>(
  items: products,
  config: InlineSuggestionConfig(
    ghostTextColor: Colors.grey,
    acceptOnTab: true,
    partialAcceptOnArrowRight: true,
  ),
  onSuggestionAccepted: (item) {
    print('Accepted: \${item.label}');
  },
)

// Using InlineSuggestionController (advanced)
final controller = InlineSuggestionController(
  acceptKey: LogicalKeyboardKey.tab,
  partialAcceptKey: LogicalKeyboardKey.arrowRight,
  caseSensitive: false,
);

// Update as user types
controller.updateText(textController.text);
controller.setSuggestion(bestMatch.label);

// Accept suggestions
final fullText = controller.acceptFull();
final partialText = controller.acceptWord();

// Check visibility
if (controller.isVisible) {
  print('Ghost text: \${controller.ghostText}');
}''',
                  style: theme.typography.body?.copyWith(
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

  Widget _buildKeyHint(BuildContext context, String key, String description) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: FluentTheme.of(context).accentColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            key,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Gap(8),
        Text(description),
      ],
    );
  }
}
