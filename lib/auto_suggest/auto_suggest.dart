// ignore_for_file: unused_field
import 'dart:async';
import 'package:auto_suggest_box/common/text_form.dart';
import 'package:flutter/material.dart' hide Card, ListTile, Divider, Tooltip, IconButton, Colors;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

import '../common/text.dart';
import '../bloc/auto_suggest_cubit.dart';
import '../bloc/auto_suggest_state.dart';

// Export all components
export 'auto_suggest_item.dart';
export 'auto_suggest_cache.dart';
export 'auto_suggest_controller.dart';
export 'auto_suggest_overlay.dart';
export 'auto_suggest_theme.dart';
export 'voice_search_controller.dart';
export 'grouped_suggestions.dart';
export 'inline_suggestion.dart';

// Import for internal use
import 'auto_suggest_item.dart';
import 'auto_suggest_cache.dart';
import 'auto_suggest_controller.dart';
import 'auto_suggest_overlay.dart';
import 'auto_suggest_theme.dart';

const double kDefaultMaxPopupHeight = 380.0;

/// Callback for text changes
typedef OnTextChanged<T> = void Function(String text, TextChangedReason reason);

/// Builder for items in the cubit-based suggestion list
typedef CubitItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  bool isSelected,
  VoidCallback onTap,
);

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
/// - BLoC/Cubit state management support
///
/// Example usage:
/// ```dart
/// // Standard usage with items:
/// FluentAutoSuggestBox<String>(
///   items: [
///     FluentAutoSuggestBoxItem(value: '1', label: 'Item 1'),
///     FluentAutoSuggestBoxItem(value: '2', label: 'Item 2'),
///   ],
///   onSelected: (item) {
///     print('Selected: ${item.label}');
///   },
/// )
///
/// // With Cubit state management:
/// FluentAutoSuggestBox<Product>.cubit(
///   cubit: productsCubit,
///   cubitItemBuilder: (context, product, isSelected, onTap) {
///     return ListTile(
///       title: Text(product.name),
///       selected: isSelected,
///       onPressed: onTap,
///     );
///   },
///   labelBuilder: (product) => product.name,
///   onCubitSelected: (product) {
///     print('Selected: ${product.name}');
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
       items = ValueNotifier(items.toSet()),
       cubit = null,
       cubitItemBuilder = null,
       labelBuilder = null,
       onCubitSelected = null,
       cubitFilters = null,
       showCubitStats = false,
       cubitLoadingBuilder = null,
       cubitErrorBuilder = null,
       cubitEmptyBuilder = null;

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
  }) : items = ValueNotifier(items.toSet()),
       cubit = null,
       cubitItemBuilder = null,
       labelBuilder = null,
       onCubitSelected = null,
       cubitFilters = null,
       showCubitStats = false,
       cubitLoadingBuilder = null,
       cubitErrorBuilder = null,
       cubitEmptyBuilder = null;

  /// Creates a fluent-styled auto suggest box with Cubit state management
  ///
  /// This constructor integrates with [AutoSuggestCubit] for BLoC-based
  /// state management, similar to smart_pagination package.
  FluentAutoSuggestBox.cubit({
    super.key,
    required AutoSuggestCubit<T> this.cubit,
    required CubitItemBuilder<T> this.cubitItemBuilder,
    required String Function(T item) this.labelBuilder,
    this.onCubitSelected,
    this.cubitFilters,
    this.showCubitStats = false,
    this.cubitLoadingBuilder,
    this.cubitErrorBuilder,
    this.cubitEmptyBuilder,
    this.controller,
    this.onChanged,
    this.onOverlayVisibilityChanged,
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
    this.tileHeight = kDefaultItemHeight,
    this.direction = AutoSuggestBoxDirection.below,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.offset,
    this.onEditingComplete,
  }) : items = ValueNotifier(<FluentAutoSuggestBoxItem<T>>{}),
       autoSuggestController = null,
       onSelected = null,
       itemBuilder = null,
       noResultsFoundBuilder = null,
       loadingBuilder = null,
       sorter = null,
       onNoResultsFound = null,
       onError = null,
       autovalidateMode = AutovalidateMode.disabled,
       validator = null,
       enableCache = false,
       cacheMaxSize = 0,
       cacheDuration = Duration.zero,
       debounceDelay = Duration.zero,
       minSearchLength = 0;

  // Core properties
  final ValueNotifier<Set<FluentAutoSuggestBoxItem<T>>> items;
  final TextEditingController? controller;
  final AutoSuggestController<T>? autoSuggestController;
  final OnTextChanged<T>? onChanged;
  final ValueChanged<FluentAutoSuggestBoxItem<T>?>? onSelected;
  final ValueChanged<bool>? onOverlayVisibilityChanged;

  // Cubit properties
  /// The cubit for BLoC-based state management
  final AutoSuggestCubit<T>? cubit;

  /// Builder for items when using cubit mode
  final CubitItemBuilder<T>? cubitItemBuilder;

  /// Function to get label text from an item in cubit mode
  final String Function(T item)? labelBuilder;

  /// Callback when an item is selected in cubit mode
  final void Function(T item)? onCubitSelected;

  /// Filters to pass to the cubit search
  final Map<String, dynamic>? cubitFilters;

  /// Whether to show cache statistics in cubit mode
  final bool showCubitStats;

  /// Builder for loading state in cubit mode
  final Widget Function(BuildContext context, String query)? cubitLoadingBuilder;

  /// Builder for error state in cubit mode
  final Widget Function(BuildContext context, Object error, String query, VoidCallback onRetry)? cubitErrorBuilder;

  /// Builder for empty state in cubit mode
  final Widget Function(BuildContext context, String query)? cubitEmptyBuilder;

  /// Whether the widget is using cubit mode
  bool get isCubitMode => cubit != null;

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

  // Cubit mode state
  int _cubitSelectedIndex = -1;

  // Getters
  ItemSorter<T> get _sorter =>
      widget.sorter ?? FluentAutoSuggestBox.defaultItemSorter;
  bool get _isFormField => widget.validator != null;
  bool get _isCubitMode => widget.isCubitMode;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _textController = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    // Only create autoSuggestController in non-cubit mode
    if (!_isCubitMode) {
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

    // Only update autoSuggestController in non-cubit mode
    if (!_isCubitMode && widget.autoSuggestController != oldWidget.autoSuggestController) {
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
    if (!_isCubitMode && widget.autoSuggestController == null) {
      _autoSuggestController.dispose();
    }

    super.dispose();
  }

  void _handleFocusChanged() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      if (_isCubitMode) {
        // In cubit mode, just dismiss the overlay
        _dismissOverlay();
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
    }

    if (mounted) setState(() {});
  }

  void _handleTextChanged() {
    if (!mounted) return;

    if (_isCubitMode) {
      // In cubit mode, use the cubit for search
      widget.cubit!.search(_textController.text, filters: widget.cubitFilters);
      _cubitSelectedIndex = -1;
    } else {
      _autoSuggestController.updateSearchQuery(
        _textController.text,
        onDebounceComplete: _onDebounceComplete,
      );
    }

    // Show overlay if text is entered
    if (_textController.text.isNotEmpty && _focusNode.hasFocus) {
      _showOverlay();
    } else if (_textController.text.isEmpty) {
      _dismissOverlay();
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
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
      return;
    }

    final overlayState = Overlay.of(
      context,
      rootOverlay: true,
      debugRequiredFor: widget,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => _isCubitMode
          ? _buildCubitOverlay(context, overlayState)
          : _buildOverlay(context, overlayState),
    );

    if (_textBoxKey.currentContext != null) {
      overlayState.insert(_overlayEntry!);
      if (!_isCubitMode) {
        _autoSuggestController.setOverlayVisible(true);
      }
      widget.onOverlayVisibilityChanged?.call(true);
    }
  }

  void _dismissOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (!_isCubitMode) {
      _autoSuggestController.setOverlayVisible(false);
    }
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

    // Calculate available space below and above
    final spaceBelow = screenHeight - (globalOffset.dy + box.size.height);
    final spaceAbove = globalOffset.dy - MediaQuery.viewPaddingOf(context).top;

    // Determine direction: show above if space below < 300 and space above is larger
    final effectiveDirection = (spaceBelow < 300 && spaceAbove > spaceBelow)
        ? AutoSuggestBoxDirection.above
        : widget.direction;

    final maxHeight = effectiveDirection == AutoSuggestBoxDirection.below
        ? spaceBelow.clamp(0.0, widget.maxPopupHeight)
        : spaceAbove.clamp(0.0, widget.maxPopupHeight);

    return Positioned(
      width: box.size.width,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        targetAnchor: effectiveDirection == AutoSuggestBoxDirection.below
            ? Alignment.bottomCenter
            : Alignment.topCenter,
        followerAnchor: effectiveDirection == AutoSuggestBoxDirection.below
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
          direction: effectiveDirection,
          focusNode: _focusNode,
          onError: widget.onError,
        ),
      ),
    );
  }

  Widget _buildCubitOverlay(BuildContext context, OverlayState overlayState) {
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

    // Calculate available space below and above
    final spaceBelow = screenHeight - (globalOffset.dy + box.size.height);
    final spaceAbove = globalOffset.dy - MediaQuery.viewPaddingOf(context).top;

    // Determine direction: show above if space below < 300 and space above is larger
    final effectiveDirection = (spaceBelow < 300 && spaceAbove > spaceBelow)
        ? AutoSuggestBoxDirection.above
        : widget.direction;

    final maxHeight = effectiveDirection == AutoSuggestBoxDirection.below
        ? spaceBelow.clamp(0.0, widget.maxPopupHeight)
        : spaceAbove.clamp(0.0, widget.maxPopupHeight);

    return Positioned(
      width: box.size.width,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        targetAnchor: effectiveDirection == AutoSuggestBoxDirection.below
            ? Alignment.bottomCenter
            : Alignment.topCenter,
        followerAnchor: effectiveDirection == AutoSuggestBoxDirection.below
            ? Alignment.topCenter
            : Alignment.bottomCenter,
        offset: widget.offset ?? const Offset(0, 0.8),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: BlocBuilder<AutoSuggestCubit<T>, AutoSuggestState<T>>(
              bloc: widget.cubit,
              builder: (context, state) => _buildCubitOverlayContent(state),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCubitOverlayContent(AutoSuggestState<T> state) {
    return switch (state) {
      AutoSuggestInitial() => const SizedBox.shrink(),
      AutoSuggestLoading(:final query, :final previousItems) =>
        _buildCubitLoadingState(query, previousItems),
      AutoSuggestLoaded(:final items, :final query) =>
        _buildCubitLoadedState(items, query),
      AutoSuggestEmpty(:final query) => _buildCubitEmptyState(query),
      AutoSuggestError(:final error, :final query, :final previousItems) =>
        _buildCubitErrorState(error, query, previousItems),
    };
  }

  Widget _buildCubitLoadingState(String query, List<T>? previousItems) {
    if (widget.cubitLoadingBuilder != null) {
      return widget.cubitLoadingBuilder!(context, query);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4, child: ProgressBar()),
          const Gap(12),
          Text('Searching for "$query"...'),
          if (previousItems != null && previousItems.isNotEmpty) ...[
            const Gap(8),
            const Divider(),
            Flexible(
              child: _buildCubitItemsList(previousItems, opacity: 0.5),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCubitLoadedState(List<T> items, String query) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showCubitStats) _buildCubitStatsBar(),
        Flexible(
          child: _buildCubitItemsList(items),
        ),
      ],
    );
  }

  Widget _buildCubitItemsList(List<T> items, {double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = index == _cubitSelectedIndex;

          return widget.cubitItemBuilder!(
            context,
            item,
            isSelected,
            () => _handleCubitItemSelected(item),
          );
        },
      ),
    );
  }

  Widget _buildCubitEmptyState(String query) {
    if (widget.cubitEmptyBuilder != null) {
      return widget.cubitEmptyBuilder!(context, query);
    }

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FluentIcons.search,
            size: 48,
            color: FluentTheme.of(context).accentColor.withOpacity(0.5),
          ),
          const Gap(12),
          Text(
            'No results found',
            style: FluentTheme.of(context).typography.subtitle,
          ),
          const Gap(4),
          Text(
            'No results for "$query"',
            style: FluentTheme.of(context).typography.body,
          ),
        ],
      ),
    );
  }

  Widget _buildCubitErrorState(
    Object error,
    String query,
    List<T>? previousItems,
  ) {
    if (widget.cubitErrorBuilder != null) {
      return widget.cubitErrorBuilder!(
        context,
        error,
        query,
        () => widget.cubit!.refresh(),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FluentIcons.error,
            size: 48,
            color: Colors.red,
          ),
          const Gap(12),
          Text('Error: ${error.toString()}'),
          const Gap(8),
          Button(
            onPressed: () => widget.cubit!.refresh(),
            child: const Text('Retry'),
          ),
          if (previousItems != null && previousItems.isNotEmpty) ...[
            const Gap(8),
            const Divider(),
            const Gap(8),
            const Text('Previous results:'),
            Flexible(
              child: _buildCubitItemsList(previousItems, opacity: 0.5),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCubitStatsBar() {
    final stats = widget.cubit!.stats;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).accentColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: FluentTheme.of(context).resources.dividerStrokeColorDefault,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(FluentIcons.database, size: 14),
          const Gap(4),
          Text(
            'Cache: ${stats['cacheSize']} | '
            'Hit rate: ${(stats['cacheHitRate'] * 100).toStringAsFixed(0)}%',
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  void _handleCubitItemSelected(T item) {
    final label = widget.labelBuilder!(item);
    _textController.text = label;
    _textController.selection = TextSelection.collapsed(offset: label.length);
    _lastValidValue = label;
    _dismissOverlay();
    widget.onCubitSelected?.call(item);
    widget.onChanged?.call(label, TextChangedReason.suggestionChosen);
    _focusNode.unfocus();
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
    if (_isCubitMode) {
      // In cubit mode, select the highlighted item
      final state = widget.cubit!.state;
      if (state is AutoSuggestLoaded<T> &&
          _cubitSelectedIndex >= 0 &&
          _cubitSelectedIndex < state.items.length) {
        _handleCubitItemSelected(state.items[_cubitSelectedIndex]);
      }
    } else {
      final selectedItem = _overlayKey.currentState?.getSelectedItem();
      if (selectedItem != null) {
        _handleItemSelected(selectedItem);
      }
    }
    _dismissOverlay();
  }

  void _handleKeyboardNavigation(LogicalKeyboardKey key) {
    if (_isCubitMode) {
      _handleCubitKeyboardNavigation(key);
      return;
    }

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

  void _handleCubitKeyboardNavigation(LogicalKeyboardKey key) {
    final state = widget.cubit!.state;
    if (state is! AutoSuggestLoaded<T>) return;

    final items = state.items;
    if (items.isEmpty) return;

    switch (key) {
      case LogicalKeyboardKey.arrowDown:
        setState(() {
          _cubitSelectedIndex = (_cubitSelectedIndex + 1) % items.length;
        });
        _overlayEntry?.markNeedsBuild();
        break;
      case LogicalKeyboardKey.arrowUp:
        setState(() {
          _cubitSelectedIndex =
              _cubitSelectedIndex <= 0 ? items.length - 1 : _cubitSelectedIndex - 1;
        });
        _overlayEntry?.markNeedsBuild();
        break;
      case LogicalKeyboardKey.enter:
        if (_cubitSelectedIndex >= 0 && _cubitSelectedIndex < items.length) {
          _handleCubitItemSelected(items[_cubitSelectedIndex]);
        }
        break;
      case LogicalKeyboardKey.escape:
        _dismissOverlay();
        _focusNode.unfocus();
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
    final theme = Theme.of(context);
    final autoSuggestTheme = theme.extension<FluentAutoSuggestThemeData>();
    final useMaterial = autoSuggestTheme?.designSystem == AutoSuggestDesignSystem.material;

    // Build suffix widget based on mode
    Widget? suffixWidget;
    if (_isCubitMode) {
      suffixWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.clearButtonEnabled && _textController.text.isNotEmpty)
            useMaterial
                ? Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        _textController.clear();
                        widget.cubit!.clear();
                        _dismissOverlay();
                      },
                      child: Icon(
                        Icons.clear,
                        size: 18,
                        color: autoSuggestTheme?.clearButtonColor,
                      ),
                    ),
                  )
                : IconButton(
                    icon: Icon(
                      FluentIcons.clear,
                      size: 14,
                      color: autoSuggestTheme?.clearButtonColor,
                    ),
                    onPressed: () {
                      _textController.clear();
                      widget.cubit!.clear();
                      _dismissOverlay();
                    },
                  ),
          BlocBuilder<AutoSuggestCubit<T>, AutoSuggestState<T>>(
            bloc: widget.cubit,
            builder: (context, state) {
              if (state is AutoSuggestLoading) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: useMaterial
                        ? CircularProgressIndicator(
                            strokeWidth: 2,
                            color: autoSuggestTheme?.loadingIndicatorColor,
                          )
                        : ProgressRing(
                            strokeWidth: 2,
                            activeColor: autoSuggestTheme?.loadingIndicatorColor,
                          ),
                  ),
                );
              }
              return Icon(
                Icons.arrow_drop_down,
                color: autoSuggestTheme?.dropdownIconColor,
              );
            },
          ),
        ],
      );
    } else {
      suffixWidget = widget.decoration?.suffix ??
          Icon(
            Icons.arrow_drop_down,
            color: autoSuggestTheme?.dropdownIconColor,
          );
    }

    // Use theme decoration or widget decoration
    final baseDecoration = autoSuggestTheme?.textFieldDecoration ?? widget.decoration ?? const InputDecoration();
    final decoration = baseDecoration.copyWith(
      suffix: suffixWidget,
      prefix: widget.decoration?.prefix == null
          ? null
          : Padding(
              padding: const EdgeInsetsDirectional.only(start: 4.0),
              child: widget.decoration?.prefix,
            ),
    );

    // Use Material components
    if (useMaterial) {
      return _buildMaterialTextField(decoration, autoSuggestTheme);
    }

    // Use Fluent components (default)
    return _buildFluentTextField(decoration, autoSuggestTheme);
  }

  Widget _buildFluentTextField(InputDecoration decoration, FluentAutoSuggestThemeData? themeData) {
    if (_isFormField) {
      return FluentTextFormField(
        key: _textBoxKey,
        controller: _textController,
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        style: themeData?.textFieldStyle ?? widget.style,
        decoration: decoration,
        cursorColor: themeData?.textFieldCursorColor ?? widget.cursorColor,
        cursorHeight: themeData?.textFieldCursorHeight ?? widget.cursorHeight,
        cursorRadius: themeData?.textFieldCursorRadius ?? widget.cursorRadius,
        cursorWidth: themeData?.textFieldCursorWidth ?? widget.cursorWidth,
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
        style: themeData?.textFieldStyle ?? widget.style,
        decoration: decoration,
        cursorColor: themeData?.textFieldCursorColor ?? widget.cursorColor,
        cursorHeight: themeData?.textFieldCursorHeight ?? widget.cursorHeight,
        cursorRadius: themeData?.textFieldCursorRadius ?? widget.cursorRadius,
        cursorWidth: themeData?.textFieldCursorWidth ?? widget.cursorWidth,
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

  Widget _buildMaterialTextField(InputDecoration decoration, FluentAutoSuggestThemeData? themeData) {
    if (_isFormField) {
      return TextFormField(
        key: _textBoxKey,
        controller: _textController,
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        style: themeData?.textFieldStyle ?? widget.style,
        decoration: decoration,
        cursorColor: themeData?.textFieldCursorColor ?? widget.cursorColor,
        cursorHeight: themeData?.textFieldCursorHeight ?? widget.cursorHeight,
        cursorRadius: themeData?.textFieldCursorRadius ?? widget.cursorRadius,
        cursorWidth: themeData?.textFieldCursorWidth ?? widget.cursorWidth,
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
      return TextField(
        key: _textBoxKey,
        controller: _textController,
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        style: themeData?.textFieldStyle ?? widget.style,
        decoration: decoration,
        cursorColor: themeData?.textFieldCursorColor ?? widget.cursorColor,
        cursorHeight: themeData?.textFieldCursorHeight ?? widget.cursorHeight,
        cursorRadius: themeData?.textFieldCursorRadius ?? widget.cursorRadius,
        cursorWidth: themeData?.textFieldCursorWidth ?? widget.cursorWidth,
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
