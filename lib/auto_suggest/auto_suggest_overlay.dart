part of 'auto_suggest.dart';

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

  void _selectItem(int index) {
    if (index < 0 || index >= _sortedItems.length) return;

    setState(() {
      // Unselect all
      for (final item in _sortedItems) {
        item.isSelected = false;
      }

      // Select new item
      _selectedIndex = index;
      final item = _sortedItems.elementAt(index);
      item.isSelected = true;
    });

    // Scroll to item
    _scrollToIndex(index);
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients) return;

    final offset = widget.tileHeight * index;
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
          color: fluentTheme.acrylicBackgroundColor.withAlpha(
            (255 * .85).toInt(),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: widget.direction == AutoSuggestBoxDirection.below
                  ? const Radius.circular(4.0)
                  : Radius.zero,
              top: widget.direction == AutoSuggestBoxDirection.above
                  ? const Radius.circular(4.0)
                  : Radius.zero,
            ),
          ),
          shadows: kElevationToShadow[1],
        ),
        child: Card(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.zero,
          child: Container(
            color: fluentTheme.cardColor,
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
    return Semantics(
      label: '${_sortedItems.length} results available',
      container: true,
      child: ListView.builder(
        itemExtent: widget.tileHeight,
        controller: _scrollController,
        shrinkWrap: true,
        reverse: widget.direction == AutoSuggestBoxDirection.above,
        padding: const EdgeInsetsDirectional.only(bottom: 4.0),
        itemCount: _sortedItems.length,
        itemBuilder: (context, index) {
          final item = _sortedItems.elementAt(index);
          final isSelected = index == _selectedIndex || item.isSelected;

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
    final nextIndex = (_selectedIndex + 1) % _sortedItems.length;
    _selectItem(nextIndex);
  }

  void selectPrevious() {
    if (_sortedItems.isEmpty) return;
    final prevIndex = _selectedIndex <= 0
        ? _sortedItems.length - 1
        : _selectedIndex - 1;
    _selectItem(prevIndex);
  }

  FluentAutoSuggestBoxItem<T>? getSelectedItem() {
    if (_selectedIndex < 0 || _selectedIndex >= _sortedItems.length) {
      return null;
    }
    return _sortedItems.elementAt(_selectedIndex);
  }
}
