import 'package:flutter/material.dart' hide Card, ListTile, Divider, Tooltip, IconButton, Colors;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:gap/gap.dart';

import 'auto_suggest_item.dart';
import 'auto_suggest_theme.dart';

enum AutoSuggestBoxDirection { below, above }

/// Sorter function type
typedef ItemSorter<T> =
    Set<FluentAutoSuggestBoxItem<T>> Function(
      String text,
      Set<FluentAutoSuggestBoxItem<T>> items,
    );

/// on no results found callback
typedef OnNoResultsFound<T> =
    Future<List<FluentAutoSuggestBoxItem<T>>> Function(String query);

/// Overlay widget for displaying suggestions
class AutoSuggestOverlay<T> extends StatefulWidget {
  const AutoSuggestOverlay({
    super.key,
    required this.items,
    required this.controller,
    required this.onSelected,
    required this.sorter,
    required this.maxHeight,
    this.itemBuilder,
    this.noResultsBuilder,
    this.loadingBuilder,
    required this.onNoResultsFound,
    this.isLoading = false,
    this.tileHeight = kDefaultItemHeight,
    this.direction = AutoSuggestBoxDirection.below,
    this.focusNode,
    this.onError,
  });

  final ValueNotifier<Set<FluentAutoSuggestBoxItem<T>>> items;
  final TextEditingController controller;
  final ValueChanged<FluentAutoSuggestBoxItem<T>> onSelected;
  final ItemSorter<T> sorter;
  final double maxHeight;
  final ItemBuilder<T>? itemBuilder;
  final WidgetBuilder? noResultsBuilder;
  final WidgetBuilder? loadingBuilder;
  final OnNoResultsFound<T> onNoResultsFound;
  final bool isLoading;
  final double tileHeight;
  final AutoSuggestBoxDirection direction;
  final FocusNode? focusNode;
  final void Function(Object error, StackTrace stack)? onError;

  @override
  State<AutoSuggestOverlay<T>> createState() => AutoSuggestOverlayState<T>();
}

class AutoSuggestOverlayState<T> extends State<AutoSuggestOverlay<T>> {
  final ScrollController _scrollController = ScrollController();
  late ValueNotifier<Set<FluentAutoSuggestBoxItem<T>>> _items;
  Set<FluentAutoSuggestBoxItem<T>> _sortedItems = {};
  int _selectedIndex = -1;

  // Track pending search to prevent race conditions
  String? _pendingSearch;
  bool _isSearching = false;
  bool _searchCompletedWithNoResults = false;

  /// Get items in display order (reversed when showing above)
  List<FluentAutoSuggestBoxItem<T>> get _displayItems {
    final items = _sortedItems.toList();
    if (widget.direction == AutoSuggestBoxDirection.above) {
      return items.reversed.toList();
    }
    return items;
  }

  /// Convert display index to actual index in _sortedItems
  int _toActualIndex(int displayIndex) {
    if (widget.direction == AutoSuggestBoxDirection.above) {
      return _sortedItems.length - 1 - displayIndex;
    }
    return displayIndex;
  }

  /// Convert actual index to display index
  int _toDisplayIndex(int actualIndex) {
    if (widget.direction == AutoSuggestBoxDirection.above) {
      return _sortedItems.length - 1 - actualIndex;
    }
    return actualIndex;
  }

  @override
  void initState() {
    super.initState();
    _items = widget.items;
    _updateSortedItems();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(AutoSuggestOverlay<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _items = widget.items;
      _updateSortedItems();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _scrollController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (!mounted) return;
    // Reset search completed flag when text changes
    _searchCompletedWithNoResults = false;
    _updateSortedItems();
  }

  void _updateSortedItems() {
    // search text should be from start to cursor position
    final cursorPosition = widget.controller.selection.baseOffset;
    final searchText = widget.controller.text.trim().substring(
      0,
      cursorPosition >= 0 ? cursorPosition : 0,
    );
    final newSortedItems = widget.sorter(searchText, _items.value);

    if (!mounted) return;

    setState(() {
      _sortedItems = newSortedItems;
      _selectedIndex = -1;
      // Reset search completed flag when text changes
      if (newSortedItems.isNotEmpty) {
        _searchCompletedWithNoResults = false;
      }
    });

    // Trigger search if no results and callback is provided
    if (searchText.isNotEmpty && newSortedItems.isEmpty && !_isSearching && !_searchCompletedWithNoResults) {
      _performSearch(searchText);
    }
  }

  Future<void> _performSearch(String query) async {
    if (_isSearching && _pendingSearch == query) return;

    _pendingSearch = query;
    _isSearching = true;

    if (mounted) {
      setState(() {});
    }

    try {
      // Add delay to prevent too many requests
      await Future.delayed(const Duration(milliseconds: 300));

      // Check if search is still relevant
      if (!mounted || widget.controller.text.trim() != query) {
        return;
      }

      final results = await widget.onNoResultsFound(query);

      if (!mounted || widget.controller.text.trim() != query) {
        return;
      }

      if (results.isNotEmpty) {
        // Add new items to the set
        _items.value = {..._items.value, ...results};
        _searchCompletedWithNoResults = false;
        _updateSortedItems();
      } else {
        // Search completed but no results found
        setState(() {
          _searchCompletedWithNoResults = true;
        });
      }
    } catch (e, stack) {
      if (mounted) {
        widget.onError?.call(e, stack);
        setState(() {
          _searchCompletedWithNoResults = true;
        });
      }
    } finally {
      _isSearching = false;
      _pendingSearch = null;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _selectItem(int actualIndex) {
    if (actualIndex < 0 || actualIndex >= _sortedItems.length) return;

    setState(() {
      // Unselect all
      for (final item in _sortedItems) {
        item.isSelected = false;
      }

      // Select new item
      _selectedIndex = actualIndex;
      final item = _sortedItems.elementAt(actualIndex);
      item.isSelected = true;
    });

    // Scroll to item (use display index for scrolling)
    _scrollToDisplayIndex(_toDisplayIndex(actualIndex));
  }

  void _scrollToDisplayIndex(int displayIndex) {
    if (!_scrollController.hasClients) return;

    final offset = widget.tileHeight * displayIndex;
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fluentTheme = FluentTheme.of(context);
    final theme = Theme.of(context);
    final autoSuggestTheme = theme.extension<FluentAutoSuggestThemeData>();

    final backgroundColor = autoSuggestTheme?.overlayBackgroundColor ??
        fluentTheme.acrylicBackgroundColor.withAlpha((255 * .85).toInt());
    final cardColor = autoSuggestTheme?.overlayCardColor ?? fluentTheme.cardColor;
    final borderRadius = autoSuggestTheme?.overlayBorderRadius ?? 4.0;

    return TextFieldTapRegion(
      child: Container(
        margin: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: widget.direction == AutoSuggestBoxDirection.above ? 8 : 0,
        ),
        constraints: BoxConstraints(maxHeight: widget.maxHeight),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: widget.direction == AutoSuggestBoxDirection.below
                  ? Radius.circular(borderRadius)
                  : Radius.zero,
              top: widget.direction == AutoSuggestBoxDirection.above
                  ? Radius.circular(borderRadius)
                  : Radius.zero,
            ),
          ),
          shadows: autoSuggestTheme?.overlayShadows ?? kElevationToShadow[1],
        ),
        child: Card(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.zero,
          child: Container(
            color: cardColor,
            child: _buildContent(theme),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    // Show loading state only if searching and not completed
    if ((widget.isLoading || _isSearching) && !_searchCompletedWithNoResults) {
      return widget.loadingBuilder?.call(context) ??
          _buildDefaultLoadingWidget();
    }

    // Show results or no results
    if (_sortedItems.isEmpty) {
      return _buildNoResultsWidget();
    }

    return _buildItemsList();
  }

  Widget _buildDefaultLoadingWidget() {
    final theme = Theme.of(context);

    return Semantics(
      label: 'Loading search results',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4, child: ProgressBar()),
          ListTile(
            title: Text("searching..."),
            subtitle: Text(
              "Searching in server...",
              style: TextStyle(
                fontSize: 14.0,
                color: theme.colorScheme.outline,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsWidget() {
    final theme = Theme.of(context);

    final children = [
      if (widget.noResultsBuilder != null) ...[
        const Gap(8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: widget.noResultsBuilder!.call(context),
        ),
        const Divider(),
      ] else
        const SizedBox(height: 4),
      Semantics(
        label: 'No results found. Try adjusting your search.',
        container: true,
        child: ListTile(
          focusNode: FocusNode(skipTraversal: true),
          title: Tooltip(
            message: "No results found",
            child: Text("No results found", overflow: TextOverflow.ellipsis),
          ),
          subtitle: Tooltip(
            message: "Try adjusting your search",
            child: Text(
              "Try adjusting your search",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: widget.direction == AutoSuggestBoxDirection.above
          ? children.reversed.toList()
          : children,
    );
  }

  Widget _buildItemsList() {
    final displayItems = _displayItems;

    return Semantics(
      label: '${_sortedItems.length} results available',
      container: true,
      child: ListView.builder(
        itemExtent: widget.tileHeight,
        controller: _scrollController,
        shrinkWrap: true,
        padding: const EdgeInsetsDirectional.only(bottom: 4.0),
        itemCount: displayItems.length,
        itemBuilder: (context, displayIndex) {
          final item = displayItems[displayIndex];
          final actualIndex = _toActualIndex(displayIndex);
          final isSelected = actualIndex == _selectedIndex || item.isSelected;

          return Semantics(
            label:
                '${item.semanticLabel ?? item.label}${isSelected ? ", selected" : ""}',
            button: true,
            selected: isSelected,
            child:
                widget.itemBuilder?.call(context, item) ??
                defaultItemBuilder<T>(
                  context,
                  item,
                  isSelected,
                  item.enabled ? () => widget.onSelected(item) : null,
                ),
          );
        },
      ),
    );
  }

  // Public method for keyboard navigation
  void selectNext() {
    if (_sortedItems.isEmpty) return;

    if (widget.direction == AutoSuggestBoxDirection.above) {
      // When showing above, "next" goes to a smaller actual index (visually down, toward text field)
      final nextIndex = _selectedIndex <= 0
          ? _sortedItems.length - 1
          : _selectedIndex - 1;
      _selectItem(nextIndex);
    } else {
      // Normal direction: next increments the index
      final nextIndex = (_selectedIndex + 1) % _sortedItems.length;
      _selectItem(nextIndex);
    }
  }

  void selectPrevious() {
    if (_sortedItems.isEmpty) return;

    if (widget.direction == AutoSuggestBoxDirection.above) {
      // When showing above, "previous" goes to a larger actual index (visually up)
      final prevIndex = (_selectedIndex + 1) % _sortedItems.length;
      _selectItem(prevIndex);
    } else {
      // Normal direction: previous decrements the index
      final prevIndex = _selectedIndex <= 0
          ? _sortedItems.length - 1
          : _selectedIndex - 1;
      _selectItem(prevIndex);
    }
  }

  FluentAutoSuggestBoxItem<T>? getSelectedItem() {
    if (_selectedIndex < 0 || _selectedIndex >= _sortedItems.length) {
      return null;
    }
    return _sortedItems.elementAt(_selectedIndex);
  }
}
