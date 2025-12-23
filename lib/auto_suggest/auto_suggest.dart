// ignore_for_file: unused_field
import 'dart:async';
import 'package:auto_suggest_box/common/text_form.dart';
import 'package:flutter/material.dart' hide Card, ListTile, Divider, Tooltip;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:gap/gap.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

import '../common/text.dart';

part 'auto_suggest_controller.dart';
part 'auto_suggest_cache.dart';
part 'auto_suggest_item.dart';
part 'auto_suggest_overlay.dart';

const double kDefaultMaxPopupHeight = 380.0;

/// Callback for text changes
typedef OnTextChanged<T> = void Function(String text, TextChangedReason reason);

/// Main AutoSuggestBox widget - refactored and optimized
///
/// A highly customizable auto-suggest/autocomplete widget with:
/// - Debounced search for performance
/// - LRU caching with expiration
/// - Keyboard navigation (Arrow keys, Tab, Escape, Enter)
/// - Form validation support
/// - Loading and error states
/// - Customizable builders
/// - Accessibility support
/// - Recent searches tracking
/// - Overlay positioning control
///
/// Example usage:
/// ```dart
/// FluentAutoSuggestBox<String>(
///   items: [
///     FluentAutoSuggestBoxItem(value: '1', label: 'Item 1'),
///     FluentAutoSuggestBoxItem(value: '2', label: 'Item 2'),
///   ],
///   onSelected: (item) {
///     print('Selected: ${item.label}');
///   },
/// )
/// ```
class FluentAutoSuggestBox<T> extends StatefulWidget {
  /// Creates a fluent-styled auto suggest box
  FluentAutoSuggestBox({
    super.key,
    required List<FluentAutoSuggestBoxItem<T>> items,
    this.controller,
    this.autoSuggestController,
    this.onChanged,
    this.onSelected,
    this.onOverlayVisibilityChanged,
    this.itemBuilder,
    this.noResultsFoundBuilder,
    this.loadingBuilder,
    this.sorter,
    this.trailingIcon,
    this.clearButtonEnabled = true,
    this.style,
    this.decoration,
    this.cursorColor,
    this.cursorHeight,
    this.cursorRadius = const Radius.circular(2.0),
    this.cursorWidth = 1.5,
    this.showCursor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.textInputAction,
    this.focusNode,
    this.autofocus = false,
    this.enableKeyboardControls = true,
    this.enabled = true,
    this.readOnly = false,
    this.inputFormatters,
    this.maxPopupHeight = kDefaultMaxPopupHeight,
    this.onNoResultsFound,
    this.onError,
    this.tileHeight = kDefaultItemHeight,
    this.direction = AutoSuggestBoxDirection.below,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.offset,
    this.onEditingComplete,
    this.enableCache = true,
    this.cacheMaxSize = 100,
    this.cacheDuration = const Duration(minutes: 30),
    this.debounceDelay = const Duration(milliseconds: 300),
    this.minSearchLength = 2,
  }) : autovalidateMode = AutovalidateMode.disabled,
       validator = null,
       items = ValueNotifier(items.toSet());

  /// Creates a fluent-styled auto suggest form box
  FluentAutoSuggestBox.form({
    super.key,
    required List<FluentAutoSuggestBoxItem<T>> items,
    this.controller,
    this.autoSuggestController,
    this.onChanged,
    this.onSelected,
    this.onOverlayVisibilityChanged,
    this.itemBuilder,
    this.noResultsFoundBuilder,
    this.loadingBuilder,
    this.sorter,
    this.trailingIcon,
    this.clearButtonEnabled = true,
    this.style,
    this.decoration,
    this.cursorColor,
    this.cursorHeight,
    this.cursorRadius = const Radius.circular(2.0),
    this.cursorWidth = 1.5,
    this.showCursor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.textInputAction,
    this.focusNode,
    this.autofocus = false,
    this.enableKeyboardControls = true,
    this.enabled = true,
    this.readOnly = false,
    this.inputFormatters,
    this.maxPopupHeight = kDefaultMaxPopupHeight,
    this.onNoResultsFound,
    this.onError,
    this.tileHeight = kDefaultItemHeight,
    this.direction = AutoSuggestBoxDirection.below,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.offset,
    this.onEditingComplete,
    this.enableCache = true,
    this.cacheMaxSize = 100,
    this.cacheDuration = const Duration(minutes: 30),
    this.debounceDelay = const Duration(milliseconds: 300),
    this.minSearchLength = 2,
  }) : items = ValueNotifier(items.toSet());

  // Core properties
  final ValueNotifier<Set<FluentAutoSuggestBoxItem<T>>> items;
  final TextEditingController? controller;
  final AutoSuggestController<T>? autoSuggestController;
  final OnTextChanged<T>? onChanged;
  final ValueChanged<FluentAutoSuggestBoxItem<T>?>? onSelected;
  final ValueChanged<bool>? onOverlayVisibilityChanged;

  // Builders
  final ItemBuilder<T>? itemBuilder;
  final WidgetBuilder? noResultsFoundBuilder;
  final WidgetBuilder? loadingBuilder;

  // Search and sorting
  final ItemSorter<T>? sorter;
  final Future<List<FluentAutoSuggestBoxItem<T>>> Function(String)?
  onNoResultsFound;
  final void Function(Object error, StackTrace stack)? onError;

  // UI properties
  final Widget? trailingIcon;
  final bool clearButtonEnabled;
  final TextStyle? style;
  final InputDecoration? decoration;
  final Color? cursorColor;
  final double? cursorHeight;
  final Radius cursorRadius;
  final double cursorWidth;
  final bool? showCursor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;

  // Form validation
  final FormFieldValidator<String>? validator;
  final AutovalidateMode autovalidateMode;

  // Behavior
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enableKeyboardControls;
  final bool enabled;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;

  // Overlay properties
  final double maxPopupHeight;
  final double tileHeight;
  final AutoSuggestBoxDirection direction;
  final Offset? offset;

  // Input properties
  final TextInputType keyboardType;
  final int? maxLength;
  final VoidCallback? onEditingComplete;

  // Performance properties
  final bool enableCache;
  final int cacheMaxSize;
  final Duration cacheDuration;
  final Duration debounceDelay;
  final int minSearchLength;

  @override
  State<FluentAutoSuggestBox<T>> createState() =>
      FluentAutoSuggestBoxState<T>();

  /// Default item sorter
  static Set<FluentAutoSuggestBoxItem<T>> defaultItemSorter<T>(
    String text,
    Set<FluentAutoSuggestBoxItem<T>> items,
  ) {
    text = text.trim();
    if (text.isEmpty) return items;

    return items.where((element) {
      return element.label.toLowerCase().contains(text.toLowerCase());
    }).toSet();
  }
}

class FluentAutoSuggestBoxState<T> extends State<FluentAutoSuggestBox<T>> {
  // Controllers and nodes
  late TextEditingController _textController;
  late FocusNode _focusNode;
  late AutoSuggestController<T> _autoSuggestController;

  // Cache
  late SearchResultsCache<FluentAutoSuggestBoxItem<T>> _cache;

  // Overlay management
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _textBoxKey = GlobalKey(debugLabel: 'AutoSuggestBoxTextBox');
  final GlobalKey<AutoSuggestOverlayState<T>> _overlayKey = GlobalKey();

  // State
  Size _lastBoxSize = Size.zero;
  double? _lastMaxWidth;
  String? _lastValidValue;
  FluentAutoSuggestBoxItem<T>? _lastSelectedItem;

  // Getters
  ItemSorter<T> get _sorter =>
      widget.sorter ?? FluentAutoSuggestBox.defaultItemSorter;
  bool get _isFormField => widget.validator != null;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _textController = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _autoSuggestController =
        widget.autoSuggestController ??
        AutoSuggestController<T>(
          debounceDelay: widget.debounceDelay,
          minSearchLength: widget.minSearchLength,
        );

    // Initialize cache
    if (widget.enableCache) {
      _cache = SearchResultsCache<FluentAutoSuggestBoxItem<T>>(
        maxSize: widget.cacheMaxSize,
        maxAge: widget.cacheDuration,
        enablePrefixMatching: true,
      );
    }

    // Add listeners
    _focusNode.addListener(_handleFocusChanged);
    _textController.addListener(_handleTextChanged);

    // Schedule initial size check
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkBoxSizeChanged());
  }

  @override
  void didUpdateWidget(FluentAutoSuggestBox<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controllers if they changed
    if (widget.controller != oldWidget.controller) {
      _textController.removeListener(_handleTextChanged);
      if (oldWidget.controller == null) _textController.dispose();
      _textController = widget.controller ?? TextEditingController();
      _textController.addListener(_handleTextChanged);
    }

    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_handleFocusChanged);
      if (oldWidget.focusNode == null) _focusNode.dispose();
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_handleFocusChanged);
    }

    if (widget.autoSuggestController != oldWidget.autoSuggestController) {
      if (oldWidget.autoSuggestController == null) {
        _autoSuggestController.dispose();
      }
      _autoSuggestController =
          widget.autoSuggestController ??
          AutoSuggestController<T>(
            debounceDelay: widget.debounceDelay,
            minSearchLength: widget.minSearchLength,
          );
    }
  }

  @override
  void dispose() {
    // Remove listeners
    _focusNode.removeListener(_handleFocusChanged);
    _textController.removeListener(_handleTextChanged);

    // Dispose resources
    _dismissOverlay();

    if (widget.controller == null) _textController.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    if (widget.autoSuggestController == null) _autoSuggestController.dispose();

    super.dispose();
  }

  void _handleFocusChanged() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      // When losing focus, check if current text is valid
      final currentText = _textController.text.trim();
      final isValidSelection = widget.items.value.any(
        (item) => item.label.toLowerCase() == currentText.toLowerCase(),
      );

      // If not valid and we have a last valid value, restore it
      if (!isValidSelection &&
          _lastValidValue != null &&
          currentText.isNotEmpty) {
        _textController.text = _lastValidValue!;
        _textController.selection = TextSelection.collapsed(
          offset: _lastValidValue!.length,
        );
      } else if (isValidSelection) {
        // Update last valid value if current text is valid
        _lastValidValue = currentText;
      }

      _dismissOverlay();
    }

    if (mounted) setState(() {});
  }

  void _handleTextChanged() {
    if (!mounted) return;

    _autoSuggestController.updateSearchQuery(
      _textController.text,
      onDebounceComplete: _onDebounceComplete,
    );

    // Show overlay if text is entered
    if (_textController.text.isNotEmpty && _focusNode.hasFocus) {
      _showOverlay();
    }

    // Check if box size changed
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkBoxSizeChanged());
  }

  void _onDebounceComplete() {
    // This is called after debounce - can be used for additional logic
    if (mounted) setState(() {});
  }

  void _checkBoxSizeChanged() {
    if (!mounted) return;

    final context = _textBoxKey.currentContext;
    if (context == null) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    if (_lastBoxSize != box.size) {
      _lastBoxSize = box.size;
      if (_overlayEntry != null) {
        _dismissOverlay();
        _showOverlay();
      }
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    final overlayState = Overlay.of(
      context,
      rootOverlay: true,
      debugRequiredFor: widget,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => _buildOverlay(context, overlayState),
    );

    if (_textBoxKey.currentContext != null) {
      overlayState.insert(_overlayEntry!);
      _autoSuggestController.setOverlayVisible(true);
      widget.onOverlayVisibilityChanged?.call(true);
    }
  }

  void _dismissOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _autoSuggestController.setOverlayVisible(false);
    widget.onOverlayVisibilityChanged?.call(false);
  }

  Widget _buildOverlay(BuildContext context, OverlayState overlayState) {
    assert(debugCheckHasMediaQuery(context));

    final boxContext = _textBoxKey.currentContext;
    if (boxContext == null) return const SizedBox.shrink();

    final box = boxContext.findRenderObject() as RenderBox;
    final globalOffset = box.localToGlobal(
      Offset.zero,
      ancestor: overlayState.context.findRenderObject(),
    );

    final screenHeight =
        MediaQuery.sizeOf(context).height -
        MediaQuery.viewPaddingOf(context).bottom;
    final overlayY = globalOffset.dy + box.size.height;
    final maxHeight = (screenHeight - overlayY).clamp(
      0.0,
      widget.maxPopupHeight,
    );

    return Positioned(
      width: box.size.width,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        targetAnchor: widget.direction == AutoSuggestBoxDirection.below
            ? Alignment.bottomCenter
            : Alignment.topCenter,
        followerAnchor: widget.direction == AutoSuggestBoxDirection.below
            ? Alignment.topCenter
            : Alignment.bottomCenter,
        offset: widget.offset ?? const Offset(0, 0.8),

        child: AutoSuggestOverlay<T>(
          key: _overlayKey,
          items: widget.items,
          controller: _textController,
          sorter: _sorter,
          maxHeight: maxHeight,
          itemBuilder: widget.itemBuilder,
          noResultsBuilder: widget.noResultsFoundBuilder,
          loadingBuilder: widget.loadingBuilder,
          onNoResultsFound: _handleNoResultsFound,
          onSelected: _handleItemSelected,
          isLoading: _autoSuggestController.isLoading,
          tileHeight: widget.tileHeight,
          direction: widget.direction,
          focusNode: _focusNode,
          onError: widget.onError,
        ),
      ),
    );
  }

  Future<List<FluentAutoSuggestBoxItem<T>>> _handleNoResultsFound(
    String query,
  ) async {
    if (widget.onNoResultsFound == null) return [];

    // Check cache first
    if (widget.enableCache) {
      final cached = _cache.get(query);
      if (cached != null) {
        return cached;
      }
    }

    try {
      _autoSuggestController.setLoading(true);
      final results = await widget.onNoResultsFound!(query);

      // Cache results
      if (widget.enableCache && results.isNotEmpty) {
        _cache.set(query, results);
      }

      _autoSuggestController.setLoading(false);
      setState(() {});
      return results;
    } catch (e, stack) {
      _autoSuggestController.setLoading(false);
      _autoSuggestController.setError(e);
      widget.onError?.call(e, stack);
      setState(() {});
      rethrow;
    }
  }

  void _handleItemSelected(FluentAutoSuggestBoxItem<T> item) {
    item.onSelected?.call();
    widget.onSelected?.call(item);

    // Update TextBox with selected value
    _textController.text = item.label;
    _textController.selection = TextSelection.collapsed(
      offset: item.label.length,
    );

    // Save as last valid value
    _lastValidValue = item.label;
    _lastSelectedItem = item;

    widget.onChanged?.call(item.label, TextChangedReason.suggestionChosen);

    // Dismiss overlay and remove focus after selection
    _dismissOverlay();
    if (widget.textInputAction == null ||
        [
          TextInputAction.done,
          TextInputAction.none,
        ].contains(widget.textInputAction)) {
      _focusNode.unfocus();
    }
  }

  void _handleSubmitted(String text) {
    final selectedItem = _overlayKey.currentState?.getSelectedItem();
    if (selectedItem != null) {
      _handleItemSelected(selectedItem);
    }
    _dismissOverlay();
  }

  void _handleKeyboardNavigation(LogicalKeyboardKey key) {
    final overlayState = _overlayKey.currentState;
    if (overlayState == null) return;

    switch (key) {
      case LogicalKeyboardKey.arrowDown:
        overlayState.selectNext();
        break;
      case LogicalKeyboardKey.arrowUp:
        overlayState.selectPrevious();
        break;
      case LogicalKeyboardKey.escape:
        _dismissOverlay();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: CallbackShortcuts(
        bindings: widget.enableKeyboardControls
            ? {
                const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
                    _handleKeyboardNavigation(LogicalKeyboardKey.arrowDown),
                const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
                    _handleKeyboardNavigation(LogicalKeyboardKey.arrowUp),
                const SingleActivator(LogicalKeyboardKey.escape): () =>
                    _handleKeyboardNavigation(LogicalKeyboardKey.escape),
                const SingleActivator(
                  LogicalKeyboardKey.tab,
                  shift: false,
                ): () {
                  _dismissOverlay();
                  _focusNode.nextFocus();
                },
                const SingleActivator(LogicalKeyboardKey.tab, shift: true): () {
                  _dismissOverlay();
                  _focusNode.previousFocus();
                },
              }
            : {},
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Handle width changes
            if (_lastMaxWidth != null &&
                _lastMaxWidth != constraints.maxWidth) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_overlayEntry != null) {
                  _dismissOverlay();
                  _showOverlay();
                }
              });
            }
            _lastMaxWidth = constraints.maxWidth;

            return _buildTextField();
          },
        ),
      ),
    );
  }

  Widget _buildTextField() {
    final decoration = (widget.decoration ?? InputDecoration()).copyWith(
      suffix: widget.decoration?.suffix ?? const Icon(Icons.arrow_drop_down),
      prefix: widget.decoration?.prefix == null
          ? null
          : Padding(
              padding: const EdgeInsetsDirectional.only(start: 4.0),
              child: widget.decoration?.prefix,
            ),
    );

    if (_isFormField) {
      return FluentTextFormField(
        key: _textBoxKey,
        controller: _textController,
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        style: widget.style,
        decoration: decoration,
        cursorColor: widget.cursorColor,
        cursorHeight: widget.cursorHeight,
        cursorRadius: widget.cursorRadius,
        cursorWidth: widget.cursorWidth,
        showCursor: widget.showCursor,
        scrollPadding: widget.scrollPadding,
        selectionHeightStyle: widget.selectionHeightStyle,
        selectionWidthStyle: widget.selectionWidthStyle,
        textInputAction: widget.textInputAction,
        keyboardAppearance: widget.keyboardAppearance,
        inputFormatters: widget.inputFormatters,
        keyboardType: widget.keyboardType,
        maxLength: widget.maxLength,
        onEditingComplete: widget.onEditingComplete,
        onChanged: (text) {
          widget.onChanged?.call(text, TextChangedReason.userInput);
        },
        onTapOutside: (_) => _focusNode.unfocus(),
        onFieldSubmitted: _handleSubmitted,
        validator: (_) => widget.validator?.call(_textController.text),
        autovalidateMode: widget.autovalidateMode,
      );
    } else {
      return FluentTextField(
        key: _textBoxKey,
        controller: _textController,
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        style: widget.style,
        decoration: decoration,
        cursorColor: widget.cursorColor,
        cursorHeight: widget.cursorHeight,
        cursorRadius: widget.cursorRadius,
        cursorWidth: widget.cursorWidth,
        showCursor: widget.showCursor,
        scrollPadding: widget.scrollPadding,
        selectionHeightStyle: widget.selectionHeightStyle,
        selectionWidthStyle: widget.selectionWidthStyle,
        textInputAction: widget.textInputAction,
        keyboardAppearance: widget.keyboardAppearance,
        inputFormatters: widget.inputFormatters,
        keyboardType: widget.keyboardType,
        maxLength: widget.maxLength,
        onEditingComplete: widget.onEditingComplete,
        onChanged: (text) {
          widget.onChanged?.call(text, TextChangedReason.userInput);
        },
        onTapOutside: (_) => _focusNode.unfocus(),
        onSubmitted: _handleSubmitted,
      );
    }
  }
}
