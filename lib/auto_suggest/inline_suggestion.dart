import 'package:flutter/material.dart' hide Card, ListTile, Divider, Tooltip, IconButton, Colors;
import 'package:flutter/services.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'auto_suggest_item.dart';

/// Controller for inline suggestions (ghost text)
class InlineSuggestionController extends ChangeNotifier {
  InlineSuggestionController({
    this.acceptKey = LogicalKeyboardKey.tab,
    this.partialAcceptKey = LogicalKeyboardKey.arrowRight,
    this.dismissKey = LogicalKeyboardKey.escape,
    this.caseSensitive = false,
  });

  /// Key to accept the entire suggestion
  final LogicalKeyboardKey acceptKey;

  /// Key to accept one word of the suggestion
  final LogicalKeyboardKey partialAcceptKey;

  /// Key to dismiss the suggestion
  final LogicalKeyboardKey dismissKey;

  /// Whether matching should be case-sensitive
  final bool caseSensitive;

  String _currentText = '';
  String _suggestion = '';
  String _ghostText = '';
  bool _isVisible = false;

  /// The current text in the input field
  String get currentText => _currentText;

  /// The full suggestion text
  String get suggestion => _suggestion;

  /// The ghost text (part of suggestion not yet typed)
  String get ghostText => _ghostText;

  /// Whether the ghost text is visible
  bool get isVisible => _isVisible && _ghostText.isNotEmpty;

  /// Update the current text and recalculate ghost text
  void updateText(String text) {
    _currentText = text;
    _updateGhostText();
    notifyListeners();
  }

  /// Set a new suggestion
  void setSuggestion(String suggestion) {
    _suggestion = suggestion;
    _updateGhostText();
    notifyListeners();
  }

  /// Clear the current suggestion
  void clear() {
    _suggestion = '';
    _ghostText = '';
    _isVisible = false;
    notifyListeners();
  }

  /// Show the ghost text
  void show() {
    _isVisible = true;
    notifyListeners();
  }

  /// Hide the ghost text
  void hide() {
    _isVisible = false;
    notifyListeners();
  }

  void _updateGhostText() {
    if (_suggestion.isEmpty || _currentText.isEmpty) {
      _ghostText = '';
      _isVisible = false;
      return;
    }

    final compareText = caseSensitive ? _currentText : _currentText.toLowerCase();
    final compareSuggestion = caseSensitive ? _suggestion : _suggestion.toLowerCase();

    if (compareSuggestion.startsWith(compareText)) {
      _ghostText = _suggestion.substring(_currentText.length);
      _isVisible = _ghostText.isNotEmpty;
    } else {
      _ghostText = '';
      _isVisible = false;
    }
  }

  /// Accept the full suggestion
  String acceptFull() {
    if (_ghostText.isEmpty) return _currentText;

    final result = _currentText + _ghostText;
    clear();
    return result;
  }

  /// Accept one word of the suggestion
  String acceptWord() {
    if (_ghostText.isEmpty) return _currentText;

    // Find the next word boundary
    final nextSpace = _ghostText.indexOf(' ');
    if (nextSpace == -1) {
      return acceptFull();
    }

    final wordToAccept = _ghostText.substring(0, nextSpace + 1);
    final result = _currentText + wordToAccept;
    _currentText = result;
    _updateGhostText();
    notifyListeners();
    return result;
  }

  /// Handle keyboard input
  KeyEventResult handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == acceptKey && isVisible) {
      return KeyEventResult.handled;
    }

    if (event.logicalKey == partialAcceptKey && isVisible) {
      return KeyEventResult.handled;
    }

    if (event.logicalKey == dismissKey && isVisible) {
      hide();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }
}

/// Configuration for inline suggestion display
class InlineSuggestionConfig {
  const InlineSuggestionConfig({
    this.ghostTextColor,
    this.ghostTextStyle,
    this.animationDuration = const Duration(milliseconds: 150),
    this.showOnFocus = true,
    this.hideOnBlur = true,
    this.acceptOnTab = true,
    this.partialAcceptOnArrowRight = true,
  });

  /// Color for the ghost text
  final Color? ghostTextColor;

  /// Style for the ghost text
  final TextStyle? ghostTextStyle;

  /// Animation duration for showing/hiding
  final Duration animationDuration;

  /// Show ghost text when field gains focus
  final bool showOnFocus;

  /// Hide ghost text when field loses focus
  final bool hideOnBlur;

  /// Accept suggestion on Tab key
  final bool acceptOnTab;

  /// Accept one word on Right Arrow key
  final bool partialAcceptOnArrowRight;
}

/// Widget that displays inline suggestions as ghost text
class InlineSuggestionTextField<T> extends StatefulWidget {
  const InlineSuggestionTextField({
    super.key,
    required this.items,
    this.controller,
    this.focusNode,
    this.config = const InlineSuggestionConfig(),
    this.onChanged,
    this.onSubmitted,
    this.onSuggestionAccepted,
    this.suggestionMatcher,
    this.decoration,
    this.style,
    this.enabled = true,
    this.autofocus = false,
    this.textInputAction,
    this.keyboardType,
  });

  /// List of items to suggest from
  final List<FluentAutoSuggestBoxItem<T>> items;

  /// Text controller
  final TextEditingController? controller;

  /// Focus node
  final FocusNode? focusNode;

  /// Configuration for the inline suggestion
  final InlineSuggestionConfig config;

  /// Callback when text changes
  final ValueChanged<String>? onChanged;

  /// Callback when submitted
  final ValueChanged<String>? onSubmitted;

  /// Callback when a suggestion is accepted
  final void Function(FluentAutoSuggestBoxItem<T> item)? onSuggestionAccepted;

  /// Custom matcher for finding suggestions
  final FluentAutoSuggestBoxItem<T>? Function(String text, List<FluentAutoSuggestBoxItem<T>> items)? suggestionMatcher;

  /// Input decoration
  final InputDecoration? decoration;

  /// Text style
  final TextStyle? style;

  /// Whether the field is enabled
  final bool enabled;

  /// Whether to autofocus
  final bool autofocus;

  /// Text input action
  final TextInputAction? textInputAction;

  /// Keyboard type
  final TextInputType? keyboardType;

  @override
  State<InlineSuggestionTextField<T>> createState() => _InlineSuggestionTextFieldState<T>();
}

class _InlineSuggestionTextFieldState<T> extends State<InlineSuggestionTextField<T>> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late InlineSuggestionController _suggestionController;
  FluentAutoSuggestBoxItem<T>? _currentSuggestion;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _suggestionController = InlineSuggestionController();

    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);

    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    _suggestionController.dispose();

    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    _updateSuggestion(text);
    widget.onChanged?.call(text);
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus && widget.config.showOnFocus) {
      _suggestionController.show();
    } else if (!_focusNode.hasFocus && widget.config.hideOnBlur) {
      _suggestionController.hide();
    }
  }

  void _updateSuggestion(String text) {
    if (text.isEmpty) {
      _suggestionController.clear();
      _currentSuggestion = null;
      return;
    }

    FluentAutoSuggestBoxItem<T>? match;

    if (widget.suggestionMatcher != null) {
      match = widget.suggestionMatcher!(text, widget.items);
    } else {
      // Default matcher: find first item that starts with the text
      final lowerText = text.toLowerCase();
      match = widget.items.cast<FluentAutoSuggestBoxItem<T>?>().firstWhere(
            (item) => item!.label.toLowerCase().startsWith(lowerText),
            orElse: () => null,
          );
    }

    if (match != null) {
      _currentSuggestion = match;
      _suggestionController.setSuggestion(match.label);
      _suggestionController.updateText(text);
    } else {
      _currentSuggestion = null;
      _suggestionController.clear();
    }
  }

  void _acceptSuggestion() {
    if (_currentSuggestion != null && _suggestionController.isVisible) {
      final newText = _suggestionController.acceptFull();
      _controller.text = newText;
      _controller.selection = TextSelection.collapsed(offset: newText.length);
      widget.onSuggestionAccepted?.call(_currentSuggestion!);
      _currentSuggestion = null;
    }
  }

  void _acceptWord() {
    if (_suggestionController.isVisible) {
      final newText = _suggestionController.acceptWord();
      _controller.text = newText;
      _controller.selection = TextSelection.collapsed(offset: newText.length);
    }
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (widget.config.acceptOnTab &&
        event.logicalKey == LogicalKeyboardKey.tab &&
        _suggestionController.isVisible) {
      _acceptSuggestion();
      return KeyEventResult.handled;
    }

    if (widget.config.partialAcceptOnArrowRight &&
        event.logicalKey == LogicalKeyboardKey.arrowRight &&
        _suggestionController.isVisible &&
        _controller.selection.baseOffset == _controller.text.length) {
      _acceptWord();
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.escape &&
        _suggestionController.isVisible) {
      _suggestionController.hide();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final materialTheme = Theme.of(context);

    return KeyboardListener(
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

              final ghostStyle = widget.config.ghostTextStyle ??
                  (widget.style ?? materialTheme.textTheme.bodyLarge)?.copyWith(
                    color: widget.config.ghostTextColor ??
                        theme.resources.textFillColorDisabled,
                  );

              return Positioned.fill(
                child: IgnorePointer(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    child: AnimatedOpacity(
                      duration: widget.config.animationDuration,
                      opacity: _suggestionController.isVisible ? 1.0 : 0.0,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: _controller.text,
                              style: (widget.style ?? materialTheme.textTheme.bodyLarge)?.copyWith(
                                color: Colors.transparent,
                              ),
                            ),
                            TextSpan(
                              text: _suggestionController.ghostText,
                              style: ghostStyle,
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // Actual text field
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: widget.decoration,
            style: widget.style,
            enabled: widget.enabled,
            autofocus: widget.autofocus,
            textInputAction: widget.textInputAction,
            keyboardType: widget.keyboardType,
            onSubmitted: widget.onSubmitted,
          ),
        ],
      ),
    );
  }
}

/// Mixin for adding inline suggestion capability to auto suggest box
mixin InlineSuggestionMixin<T> {
  InlineSuggestionController? _inlineSuggestionController;

  InlineSuggestionController get inlineSuggestionController {
    _inlineSuggestionController ??= InlineSuggestionController();
    return _inlineSuggestionController!;
  }

  void updateInlineSuggestion(String text, List<FluentAutoSuggestBoxItem<T>> items) {
    if (text.isEmpty) {
      inlineSuggestionController.clear();
      return;
    }

    final lowerText = text.toLowerCase();
    final match = items.cast<FluentAutoSuggestBoxItem<T>?>().firstWhere(
          (item) => item!.label.toLowerCase().startsWith(lowerText),
          orElse: () => null,
        );

    if (match != null) {
      inlineSuggestionController.setSuggestion(match.label);
      inlineSuggestionController.updateText(text);
    } else {
      inlineSuggestionController.clear();
    }
  }

  void disposeInlineSuggestion() {
    _inlineSuggestionController?.dispose();
  }
}
