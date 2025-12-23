import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' hide Card, ListTile, Divider, Tooltip, Colors;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../common/text.dart';
import 'auto_suggest_cubit.dart';
import 'auto_suggest_state.dart';

/// Builder for items in the suggestion list
typedef BlocItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  bool isSelected,
  VoidCallback onTap,
);

/// Builder for loading state
typedef BlocLoadingBuilder = Widget Function(
  BuildContext context,
  String query,
);

/// Builder for error state
typedef BlocErrorBuilder<T> = Widget Function(
  BuildContext context,
  Object error,
  String query,
  VoidCallback onRetry,
);

/// Builder for empty state
typedef BlocEmptyBuilder = Widget Function(
  BuildContext context,
  String query,
);

/// A widget that integrates FluentAutoSuggestBox with BLoC pattern
///
/// This widget uses [AutoSuggestCubit] for state management, providing
/// a clean separation of concerns and testability.
///
/// Example usage:
/// ```dart
/// BlocAutoSuggestBox<Product>(
///   cubit: productsCubit,
///   itemBuilder: (context, product, isSelected, onTap) {
///     return ListTile(
///       title: Text(product.name),
///       selected: isSelected,
///       onPressed: onTap,
///     );
///   },
///   onSelected: (product) {
///     print('Selected: ${product.name}');
///   },
///   labelBuilder: (product) => product.name,
/// )
/// ```
class BlocAutoSuggestBox<T> extends StatefulWidget {
  /// The cubit to use for state management
  final AutoSuggestCubit<T> cubit;

  /// Builder for each item in the suggestion list
  final BlocItemBuilder<T> itemBuilder;

  /// Function to get the label text from an item
  final String Function(T item) labelBuilder;

  /// Callback when an item is selected
  final void Function(T item)? onSelected;

  /// Builder for loading state
  final BlocLoadingBuilder? loadingBuilder;

  /// Builder for error state
  final BlocErrorBuilder<T>? errorBuilder;

  /// Builder for empty state
  final BlocEmptyBuilder? emptyBuilder;

  /// Input decoration
  final InputDecoration? decoration;

  /// Text style for the input
  final TextStyle? style;

  /// Maximum height of the suggestions overlay
  final double maxPopupHeight;

  /// Height of each item tile
  final double tileHeight;

  /// Whether to autofocus the input
  final bool autofocus;

  /// Whether the input is enabled
  final bool enabled;

  /// Whether the input is read-only
  final bool readOnly;

  /// Clear button enabled
  final bool clearButtonEnabled;

  /// Text controller (optional - will create internal one if not provided)
  final TextEditingController? controller;

  /// Focus node (optional)
  final FocusNode? focusNode;

  /// Filters to pass to the search
  final Map<String, dynamic>? filters;

  /// Show stats bar
  final bool showStats;

  const BlocAutoSuggestBox({
    super.key,
    required this.cubit,
    required this.itemBuilder,
    required this.labelBuilder,
    this.onSelected,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.decoration,
    this.style,
    this.maxPopupHeight = 380.0,
    this.tileHeight = 50.0,
    this.autofocus = false,
    this.enabled = true,
    this.readOnly = false,
    this.clearButtonEnabled = true,
    this.controller,
    this.focusNode,
    this.filters,
    this.showStats = false,
  });

  @override
  State<BlocAutoSuggestBox<T>> createState() => _BlocAutoSuggestBoxState<T>();
}

class _BlocAutoSuggestBoxState<T> extends State<BlocAutoSuggestBox<T>> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _textBoxKey = GlobalKey();
  int _selectedIndex = -1;
  bool _isOverlayVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _dismissOverlay();
    _focusNode.removeListener(_onFocusChanged);
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      if (_controller.text.isNotEmpty) {
        _showOverlay();
      }
    } else {
      _dismissOverlay();
    }
  }

  void _onTextChanged() {
    widget.cubit.search(_controller.text, filters: widget.filters);
    if (_controller.text.isNotEmpty && _focusNode.hasFocus) {
      _showOverlay();
    } else if (_controller.text.isEmpty) {
      _dismissOverlay();
    }
    _selectedIndex = -1;
  }

  void _showOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => _buildOverlay(),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isOverlayVisible = true;
  }

  void _dismissOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOverlayVisible = false;
  }

  Widget _buildOverlay() {
    final boxContext = _textBoxKey.currentContext;
    if (boxContext == null) return const SizedBox.shrink();

    final box = boxContext.findRenderObject() as RenderBox;

    return Positioned(
      width: box.size.width,
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        targetAnchor: Alignment.bottomCenter,
        followerAnchor: Alignment.topCenter,
        offset: const Offset(0, 4),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: widget.maxPopupHeight),
            child: BlocBuilder<AutoSuggestCubit<T>, AutoSuggestState<T>>(
              bloc: widget.cubit,
              builder: (context, state) => _buildOverlayContent(state),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayContent(AutoSuggestState<T> state) {
    return switch (state) {
      AutoSuggestInitial() => const SizedBox.shrink(),
      AutoSuggestLoading(:final query, :final previousItems) =>
        _buildLoadingState(query, previousItems),
      AutoSuggestLoaded(:final items, :final query) =>
        _buildLoadedState(items, query),
      AutoSuggestEmpty(:final query) => _buildEmptyState(query),
      AutoSuggestError(:final error, :final query, :final previousItems) =>
        _buildErrorState(error, query, previousItems),
    };
  }

  Widget _buildLoadingState(String query, List<T>? previousItems) {
    if (widget.loadingBuilder != null) {
      return widget.loadingBuilder!(context, query);
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
              child: _buildItemsList(previousItems, opacity: 0.5),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadedState(List<T> items, String query) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showStats) _buildStatsBar(),
        Flexible(
          child: _buildItemsList(items),
        ),
      ],
    );
  }

  Widget _buildItemsList(List<T> items, {double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = index == _selectedIndex;

          return widget.itemBuilder(
            context,
            item,
            isSelected,
            () => _selectItem(item),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String query) {
    if (widget.emptyBuilder != null) {
      return widget.emptyBuilder!(context, query);
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

  Widget _buildErrorState(
    Object error,
    String query,
    List<T>? previousItems,
  ) {
    if (widget.errorBuilder != null) {
      return widget.errorBuilder!(
        context,
        error,
        query,
        () => widget.cubit.refresh(),
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
            onPressed: () => widget.cubit.refresh(),
            child: const Text('Retry'),
          ),
          if (previousItems != null && previousItems.isNotEmpty) ...[
            const Gap(8),
            const Divider(),
            const Gap(8),
            const Text('Previous results:'),
            Flexible(
              child: _buildItemsList(previousItems, opacity: 0.5),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsBar() {
    final stats = widget.cubit.stats;
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
          Icon(FluentIcons.database, size: 14),
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

  void _selectItem(T item) {
    final label = widget.labelBuilder(item);
    _controller.text = label;
    _controller.selection = TextSelection.collapsed(offset: label.length);
    _dismissOverlay();
    widget.onSelected?.call(item);
    _focusNode.unfocus();
  }

  void _handleKeyEvent(KeyEvent event) {
    final state = widget.cubit.state;
    if (state is! AutoSuggestLoaded<T>) return;

    final items = state.items;
    if (items.isEmpty) return;

    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          _selectedIndex = (_selectedIndex + 1) % items.length;
        });
        _overlayEntry?.markNeedsBuild();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          _selectedIndex =
              _selectedIndex <= 0 ? items.length - 1 : _selectedIndex - 1;
        });
        _overlayEntry?.markNeedsBuild();
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (_selectedIndex >= 0 && _selectedIndex < items.length) {
          _selectItem(items[_selectedIndex]);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        _dismissOverlay();
        _focusNode.unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: KeyboardListener(
        focusNode: FocusNode(skipTraversal: true),
        onKeyEvent: _handleKeyEvent,
        child: FluentTextField(
          key: _textBoxKey,
          controller: _controller,
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          style: widget.style,
          decoration: (widget.decoration ?? const InputDecoration()).copyWith(
            suffix: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.clearButtonEnabled && _controller.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(FluentIcons.clear, size: 14),
                    onPressed: () {
                      _controller.clear();
                      widget.cubit.clear();
                      _dismissOverlay();
                    },
                  ),
                BlocBuilder<AutoSuggestCubit<T>, AutoSuggestState<T>>(
                  bloc: widget.cubit,
                  builder: (context, state) {
                    if (state is AutoSuggestLoading) {
                      return const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: ProgressRing(strokeWidth: 2),
                        ),
                      );
                    }
                    return const Icon(Icons.arrow_drop_down);
                  },
                ),
              ],
            ),
          ),
          onSubmitted: (_) {
            final state = widget.cubit.state;
            if (state is AutoSuggestLoaded<T> &&
                _selectedIndex >= 0 &&
                _selectedIndex < state.items.length) {
              _selectItem(state.items[_selectedIndex]);
            }
          },
        ),
      ),
    );
  }
}

/// A convenient builder widget for AutoSuggestCubit
///
/// This provides a simpler way to build UI based on cubit state
/// without the full BlocAutoSuggestBox widget.
class AutoSuggestBlocBuilder<T> extends StatelessWidget {
  final AutoSuggestCubit<T> cubit;
  final Widget Function(BuildContext) onInitial;
  final Widget Function(BuildContext, String query, List<T>? previousItems)
      onLoading;
  final Widget Function(BuildContext, List<T> items, String query) onLoaded;
  final Widget Function(BuildContext, String query) onEmpty;
  final Widget Function(
          BuildContext, Object error, String query, List<T>? previousItems)
      onError;

  const AutoSuggestBlocBuilder({
    super.key,
    required this.cubit,
    required this.onInitial,
    required this.onLoading,
    required this.onLoaded,
    required this.onEmpty,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AutoSuggestCubit<T>, AutoSuggestState<T>>(
      bloc: cubit,
      builder: (context, state) {
        return switch (state) {
          AutoSuggestInitial() => onInitial(context),
          AutoSuggestLoading(:final query, :final previousItems) =>
            onLoading(context, query, previousItems),
          AutoSuggestLoaded(:final items, :final query) =>
            onLoaded(context, items, query),
          AutoSuggestEmpty(:final query) => onEmpty(context, query),
          AutoSuggestError(
            :final error,
            :final query,
            :final previousItems
          ) =>
            onError(context, error, query, previousItems),
        };
      },
    );
  }
}
