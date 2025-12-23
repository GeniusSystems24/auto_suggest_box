import 'dart:async';

import 'package:auto_suggest_box/auto_suggest/auto_suggest.dart';
import 'package:auto_suggest_box/common/text.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart'
    hide
        showDialog,
        Tooltip,
        IconButton,
        Scrollbar,
        Card,
        Checkbox,
        ListTile,
        Colors;

part 'auto_suggest_advanced_wrapper.dart';

/// Configuration for advanced search dialog
///
/// Allows customization of the advanced search dialog appearance and behavior.
///
/// Example:
/// ```dart
/// AdvancedSearchConfig(
///   title: 'Find Product',
///   searchHint: 'Search products...',
///   keyboardShortcut: SingleActivator(LogicalKeyboardKey.f3),
///   showStats: true,
///   viewMode: AdvancedSearchViewMode.grid,
/// )
/// ```
class AdvancedSearchConfig {
  const AdvancedSearchConfig({
    this.title = 'Advanced Search',
    this.searchHint = 'Search...',
    this.constraints = const BoxConstraints(
      minWidth: 600,
      minHeight: 400,
      maxWidth: 1200,
      maxHeight: 800,
    ),
    this.keyboardShortcut = const SingleActivator(LogicalKeyboardKey.f3),
    this.enableKeyboardShortcut = true,
    this.barrierDismissible = true,
    this.showFilters = true,
    this.showStats = true,
    this.viewMode = AdvancedSearchViewMode.list,
    this.enableViewModeSwitch = true,
    this.resultsPerPage = 20,
    this.enablePagination = false,
    this.enableKeyboardNavigation = true,
    this.theme,
    this.icons = const AdvancedSearchIcons(),
    this.layout = const AdvancedSearchLayout(),
    this.animation = const AdvancedSearchAnimation(),
    this.toolbarActions = const [],
    this.showSearchIcon = true,
    this.showClearButton = true,
    this.enableAnimations = true,
  });

  final String title;
  final String searchHint;
  final BoxConstraints constraints;

  final SingleActivator keyboardShortcut;
  final bool enableKeyboardShortcut;
  final bool barrierDismissible;
  final bool showFilters;
  final bool showStats;
  final AdvancedSearchViewMode viewMode;
  final bool enableViewModeSwitch;
  final int resultsPerPage;
  final bool enablePagination;
  final bool enableKeyboardNavigation;

  // Customization properties
  final AdvancedSearchTheme? theme;
  final AdvancedSearchIcons icons;
  final AdvancedSearchLayout layout;
  final AdvancedSearchAnimation animation;
  final List<AdvancedSearchAction> toolbarActions;
  final bool showSearchIcon;
  final bool showClearButton;
  final bool enableAnimations;

  AdvancedSearchConfig copyWith({
    String? title,
    String? searchHint,
    BoxConstraints? constraints,
    SingleActivator? keyboardShortcut,
    bool? enableKeyboardShortcut,
    bool? barrierDismissible,
    bool? showFilters,
    bool? showStats,
    AdvancedSearchViewMode? viewMode,
    bool? enableViewModeSwitch,
    int? resultsPerPage,
    bool? enablePagination,
    bool? enableKeyboardNavigation,
    AdvancedSearchTheme? theme,
    AdvancedSearchIcons? icons,
    AdvancedSearchLayout? layout,
    AdvancedSearchAnimation? animation,
    List<AdvancedSearchAction>? toolbarActions,
    bool? showSearchIcon,
    bool? showClearButton,
    bool? enableAnimations,
  }) {
    return AdvancedSearchConfig(
      title: title ?? this.title,
      searchHint: searchHint ?? this.searchHint,
      constraints: constraints ?? this.constraints,
      keyboardShortcut: keyboardShortcut ?? this.keyboardShortcut,
      enableKeyboardShortcut:
          enableKeyboardShortcut ?? this.enableKeyboardShortcut,
      barrierDismissible: barrierDismissible ?? this.barrierDismissible,
      showFilters: showFilters ?? this.showFilters,
      showStats: showStats ?? this.showStats,
      viewMode: viewMode ?? this.viewMode,
      enableViewModeSwitch: enableViewModeSwitch ?? this.enableViewModeSwitch,
      resultsPerPage: resultsPerPage ?? this.resultsPerPage,
      enablePagination: enablePagination ?? this.enablePagination,
      enableKeyboardNavigation:
          enableKeyboardNavigation ?? this.enableKeyboardNavigation,
      theme: theme ?? this.theme,
      icons: icons ?? this.icons,
      layout: layout ?? this.layout,
      animation: animation ?? this.animation,
      toolbarActions: toolbarActions ?? this.toolbarActions,
      showSearchIcon: showSearchIcon ?? this.showSearchIcon,
      showClearButton: showClearButton ?? this.showClearButton,
      enableAnimations: enableAnimations ?? this.enableAnimations,
    );
  }
}

/// View modes for advanced search
enum AdvancedSearchViewMode { list, grid, compact }

/// Theme customization for advanced search dialog
///
/// Allows full customization of colors, spacing, and visual appearance.
///
/// Example:
/// ```dart
/// AdvancedSearchTheme(
///   primaryColor: Colors.blue,
///   backgroundColor: Colors.white,
///   borderRadius: BorderRadius.circular(16),
///   spacing: 16,
///   elevation: 8,
/// )
/// ```
class AdvancedSearchTheme {
  const AdvancedSearchTheme({
    this.primaryColor,
    this.backgroundColor,
    this.cardColor,
    this.selectedItemColor,
    this.borderColor,
    this.textColor,
    this.hintColor,
    this.iconColor,
    this.borderRadius,
    this.spacing = 16.0,
    this.padding,
    this.elevation = 4.0,
    this.overlayColor,
    this.shadowColor,
  });

  final Color? primaryColor;
  final Color? backgroundColor;
  final Color? cardColor;
  final Color? selectedItemColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? iconColor;
  final BorderRadius? borderRadius;
  final double spacing;
  final EdgeInsets? padding;
  final double elevation;
  final Color? overlayColor;
  final Color? shadowColor;

  AdvancedSearchTheme copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    Color? cardColor,
    Color? selectedItemColor,
    Color? borderColor,
    Color? textColor,
    Color? hintColor,
    Color? iconColor,
    BorderRadius? borderRadius,
    double? spacing,
    EdgeInsets? padding,
    double? elevation,
    Color? overlayColor,
    Color? shadowColor,
  }) {
    return AdvancedSearchTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      cardColor: cardColor ?? this.cardColor,
      selectedItemColor: selectedItemColor ?? this.selectedItemColor,
      borderColor: borderColor ?? this.borderColor,
      textColor: textColor ?? this.textColor,
      hintColor: hintColor ?? this.hintColor,
      iconColor: iconColor ?? this.iconColor,
      borderRadius: borderRadius ?? this.borderRadius,
      spacing: spacing ?? this.spacing,
      padding: padding ?? this.padding,
      elevation: elevation ?? this.elevation,
      overlayColor: overlayColor ?? this.overlayColor,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }
}

/// Icons customization for advanced search dialog
class AdvancedSearchIcons {
  const AdvancedSearchIcons({
    this.search = FluentIcons.search,
    this.clear = FluentIcons.clear,
    this.close = FluentIcons.cancel,
    this.filter = FluentIcons.filter,
    this.sort = FluentIcons.sort,
    this.viewList = FluentIcons.view_list,
    this.viewGrid = FluentIcons.grid_view_medium,
    this.viewCompact = FluentIcons.view_dashboard,
    this.info = FluentIcons.info,
    this.error = FluentIcons.error,
    this.loading = FluentIcons.progress_ring_dots,
    this.empty = FluentIcons.search,
    this.chevronRight = FluentIcons.chevron_right,
    this.checkbox = FluentIcons.checkbox_composite,
  });

  final IconData search;
  final IconData clear;
  final IconData close;
  final IconData filter;
  final IconData sort;
  final IconData viewList;
  final IconData viewGrid;
  final IconData viewCompact;
  final IconData info;
  final IconData error;
  final IconData loading;
  final IconData empty;
  final IconData chevronRight;
  final IconData checkbox;
}

/// Layout customization for advanced search dialog
class AdvancedSearchLayout {
  const AdvancedSearchLayout({
    this.headerHeight = 120.0,
    this.footerHeight = 80.0,
    this.itemHeight = 72.0,
    this.gridCrossAxisCount = 3,
    this.gridCrossAxisSpacing = 16.0,
    this.gridMainAxisSpacing = 16.0,
    this.gridChildAspectRatio = 1.2,
    this.listItemSpacing = 8.0,
    this.compactItemHeight = 48.0,
    this.searchFieldHeight = 48.0,
    this.borderWidth = 1.0,
  });

  final double headerHeight;
  final double footerHeight;
  final double itemHeight;
  final int gridCrossAxisCount;
  final double gridCrossAxisSpacing;
  final double gridMainAxisSpacing;
  final double gridChildAspectRatio;
  final double listItemSpacing;
  final double compactItemHeight;
  final double searchFieldHeight;
  final double borderWidth;
}

/// Animation customization for advanced search dialog
class AdvancedSearchAnimation {
  const AdvancedSearchAnimation({
    this.dialogEnterDuration = const Duration(milliseconds: 300),
    this.dialogExitDuration = const Duration(milliseconds: 250),
    this.itemEnterDuration = const Duration(milliseconds: 200),
    this.viewSwitchDuration = const Duration(milliseconds: 350),
    this.searchDebounceDuration = const Duration(milliseconds: 300),
    this.dialogCurve = Curves.easeOutBack,
    this.itemCurve = Curves.easeOut,
    this.viewSwitchCurve = Curves.easeInOut,
  });

  final Duration dialogEnterDuration;
  final Duration dialogExitDuration;
  final Duration itemEnterDuration;
  final Duration viewSwitchDuration;
  final Duration searchDebounceDuration;
  final Curve dialogCurve;
  final Curve itemCurve;
  final Curve viewSwitchCurve;
}

/// Toolbar action for advanced search
class AdvancedSearchAction {
  const AdvancedSearchAction({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.label,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final String? label;
}

/// Builder for custom filter widgets
typedef FilterBuilder =
    Widget Function(
      BuildContext context,
      Map<String, dynamic> filters,
      void Function(Map<String, dynamic>) onFiltersChanged,
    );

/// Builder for custom item cards in grid view
typedef AdvancedItemCardBuilder<T> =
    Widget Function(
      BuildContext context,
      FluentAutoSuggestBoxItem<T> item,
      bool isSelected,
    );

/// Builder for custom stats display
typedef StatsBuilder<T> =
    Widget Function(
      BuildContext context,
      int totalResults,
      int displayedResults,
      String query,
      Duration searchDuration,
    );

/// Advanced search dialog widget
class AdvancedSearchDialog<T> extends StatefulWidget {
  const AdvancedSearchDialog({
    super.key,
    required this.items,
    required this.onSearch,
    this.config = const AdvancedSearchConfig(),
    this.initialQuery = '',
    this.onSelected,
    this.onMultipleSelected,
    this.itemBuilder,
    this.itemCardBuilder,
    this.filterBuilder,
    this.statsBuilder,
    this.headerBuilder,
    this.footerBuilder,
    this.emptyStateBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.controller,
    this.enableMultiSelect = false,
    this.maxSelections,
    this.sorter,
  });

  final List<FluentAutoSuggestBoxItem<T>> items;
  final Future<List<FluentAutoSuggestBoxItem<T>>> Function(
    String query,
    Map<String, dynamic> filters,
  )
  onSearch;
  final AdvancedSearchConfig config;
  final String initialQuery;
  final void Function(FluentAutoSuggestBoxItem<T>?)? onSelected;
  final void Function(List<FluentAutoSuggestBoxItem<T>>)? onMultipleSelected;
  final Widget Function(BuildContext, FluentAutoSuggestBoxItem<T>)? itemBuilder;
  final AdvancedItemCardBuilder<T>? itemCardBuilder;
  final FilterBuilder? filterBuilder;
  final StatsBuilder<T>? statsBuilder;
  final WidgetBuilder? headerBuilder;
  final WidgetBuilder? footerBuilder;
  final WidgetBuilder? emptyStateBuilder;
  final Widget Function(BuildContext, Object error)? errorBuilder;
  final WidgetBuilder? loadingBuilder;
  final AutoSuggestController<T>? controller;
  final bool enableMultiSelect;
  final int? maxSelections;
  final Set<FluentAutoSuggestBoxItem<T>> Function(
    String text,
    Set<FluentAutoSuggestBoxItem<T>> items,
  )?
  sorter;

  @override
  State<AdvancedSearchDialog<T>> createState() =>
      _AdvancedSearchDialogState<T>();

  /// Show the advanced search dialog
  static Future<T?> show<T>({
    required BuildContext context,
    required List<FluentAutoSuggestBoxItem<T>> items,
    required Future<List<FluentAutoSuggestBoxItem<T>>> Function(
      String query,
      Map<String, dynamic> filters,
    )
    onSearch,
    AdvancedSearchConfig config = const AdvancedSearchConfig(),
    String initialQuery = '',
    Widget Function(BuildContext, FluentAutoSuggestBoxItem<T>)? itemBuilder,
    AdvancedItemCardBuilder<T>? itemCardBuilder,
    FilterBuilder? filterBuilder,
    StatsBuilder<T>? statsBuilder,
    WidgetBuilder? headerBuilder,
    WidgetBuilder? footerBuilder,
    WidgetBuilder? emptyStateBuilder,
    Widget Function(BuildContext, Object error)? errorBuilder,
    WidgetBuilder? loadingBuilder,
    AutoSuggestController<T>? controller,
    Set<FluentAutoSuggestBoxItem<T>> Function(
      String text,
      Set<FluentAutoSuggestBoxItem<T>> items,
    )?
    sorter,
  }) async {
    final result = await showDialog<FluentAutoSuggestBoxItem<T>>(
      context: context,
      barrierDismissible: config.barrierDismissible,
      builder: (context) => AdvancedSearchDialog<T>(
        items: items,
        onSearch: onSearch,
        config: config,
        initialQuery: initialQuery,
        itemBuilder: itemBuilder,
        itemCardBuilder: itemCardBuilder,
        filterBuilder: filterBuilder,
        statsBuilder: statsBuilder,
        headerBuilder: headerBuilder,
        footerBuilder: footerBuilder,
        emptyStateBuilder: emptyStateBuilder,
        errorBuilder: errorBuilder,
        loadingBuilder: loadingBuilder,
        controller: controller,
        sorter: sorter,
      ),
    );
    return result?.value;
  }

  /// Show the advanced search dialog with multi-select
  static Future<List<T>?> showMultiSelect<T>({
    required BuildContext context,
    required List<FluentAutoSuggestBoxItem<T>> items,
    required Future<List<FluentAutoSuggestBoxItem<T>>> Function(
      String query,
      Map<String, dynamic> filters,
    )
    onSearch,
    AdvancedSearchConfig config = const AdvancedSearchConfig(),
    String initialQuery = '',
    int? maxSelections,
    Widget Function(BuildContext, FluentAutoSuggestBoxItem<T>)? itemBuilder,
    AdvancedItemCardBuilder<T>? itemCardBuilder,
    FilterBuilder? filterBuilder,
    StatsBuilder<T>? statsBuilder,
    WidgetBuilder? headerBuilder,
    WidgetBuilder? footerBuilder,
    WidgetBuilder? emptyStateBuilder,
    Widget Function(BuildContext, Object error)? errorBuilder,
    WidgetBuilder? loadingBuilder,
    AutoSuggestController<T>? controller,
    Set<FluentAutoSuggestBoxItem<T>> Function(
      String text,
      Set<FluentAutoSuggestBoxItem<T>> items,
    )?
    sorter,
  }) async {
    final result = await showDialog<List<FluentAutoSuggestBoxItem<T>>>(
      context: context,
      barrierDismissible: config.barrierDismissible,
      builder: (context) => AdvancedSearchDialog<T>(
        items: items,
        onSearch: onSearch,
        config: config,
        initialQuery: initialQuery,
        enableMultiSelect: true,
        maxSelections: maxSelections,
        itemBuilder: itemBuilder,
        itemCardBuilder: itemCardBuilder,
        filterBuilder: filterBuilder,
        statsBuilder: statsBuilder,
        headerBuilder: headerBuilder,
        footerBuilder: footerBuilder,
        emptyStateBuilder: emptyStateBuilder,
        errorBuilder: errorBuilder,
        loadingBuilder: loadingBuilder,
        controller: controller,
        sorter: sorter,
      ),
    );
    return result?.map((item) => item.value).toList();
  }
}

class _AdvancedSearchDialogState<T> extends State<AdvancedSearchDialog<T>>
    with TickerProviderStateMixin {
  late TextEditingController _searchController;
  late AutoSuggestController<T> _autoController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  List<FluentAutoSuggestBoxItem<T>> _results = [];
  final List<FluentAutoSuggestBoxItem<T>> _selectedItems = [];
  Map<String, dynamic> _filters = {};
  AdvancedSearchViewMode _viewMode = AdvancedSearchViewMode.list;
  bool _isLoading = false;
  Object? _error;
  DateTime? _searchStartTime;
  Duration _lastSearchDuration = Duration.zero;
  int _currentPage = 0;
  // ignore: unused_field
  String? _lastValidQuery;
  // ignore: unused_field
  FluentAutoSuggestBoxItem<T>? _lastSelectedItem;

  final _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController(text: widget.initialQuery);
    _autoController = widget.controller ?? AutoSuggestController<T>();
    _viewMode = widget.config.viewMode;

    // Animation setup with custom duration and curve
    final animConfig = widget.config.animation;
    _animationController = AnimationController(
      vsync: this,
      duration: animConfig.dialogEnterDuration,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: animConfig.dialogCurve,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: animConfig.itemCurve,
    );

    if (widget.config.enableAnimations) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
    }

    // Initial search
    if (widget.initialQuery.isNotEmpty) {
      _performSearch();
    } else {
      _results = widget.items;
    }

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    if (widget.controller == null) _autoController.dispose();
    _animationController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.config.animation.searchDebounceDuration, () {
      _performSearch();
    });
  }

  Future<void> _performSearch() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _searchStartTime = DateTime.now();
    });

    try {
      final query = _searchController.text.trim();
      List<FluentAutoSuggestBoxItem<T>> results;

      if (query.isEmpty && _filters.isEmpty) {
        results = widget.items;
      } else {
        results = await widget.onSearch(query, _filters);
      }

      // Apply sorter if provided
      if (widget.sorter != null) {
        results = widget.sorter!(query, results.toSet()).toList();
      }

      if (mounted) {
        setState(() {
          _results = results;
          _isLoading = false;
          _lastSearchDuration = DateTime.now().difference(_searchStartTime!);
          _currentPage = 0;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
          _isLoading = false;
        });
      }
    }
  }

  void _onFiltersChanged(Map<String, dynamic> newFilters) {
    setState(() {
      _filters = newFilters;
    });
    _performSearch();
  }

  void _toggleViewMode() {
    setState(() {
      switch (_viewMode) {
        case AdvancedSearchViewMode.list:
          _viewMode = AdvancedSearchViewMode.grid;
          break;
        case AdvancedSearchViewMode.grid:
          _viewMode = AdvancedSearchViewMode.compact;
          break;
        case AdvancedSearchViewMode.compact:
          _viewMode = AdvancedSearchViewMode.list;
          break;
      }
    });
  }

  void _selectItem(FluentAutoSuggestBoxItem<T> item) {
    if (widget.enableMultiSelect) {
      setState(() {
        if (_selectedItems.contains(item)) {
          _selectedItems.remove(item);
        } else {
          if (widget.maxSelections == null ||
              _selectedItems.length < widget.maxSelections!) {
            _selectedItems.add(item);
          }
        }
      });
    } else {
      // Update search controller with selected item
      _searchController.text = item.label;
      _lastValidQuery = item.label;
      _lastSelectedItem = item;

      Navigator.of(context).pop(item);
      widget.onSelected?.call(item);
    }
  }

  void _confirmSelection() {
    if (widget.enableMultiSelect) {
      // Save selected items labels for reference
      if (_selectedItems.isNotEmpty) {
        _lastValidQuery = _selectedItems.map((e) => e.label).join(', ');
      }

      Navigator.of(context).pop(_selectedItems);
      widget.onMultipleSelected?.call(_selectedItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ContentDialog(
          title: _buildHeader(theme),
          constraints: widget.config.constraints,
          content: Column(
            children: [
              if (widget.config.showFilters && widget.filterBuilder != null)
                _buildFilters(),
              if (widget.config.showStats) _buildStats(theme),
              Expanded(child: _buildContent(theme)),
              if (widget.enableMultiSelect) _buildFooter(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(FluentThemeData theme) {
    if (widget.headerBuilder != null) {
      return widget.headerBuilder!(context);
    }

    final customTheme = widget.config.theme;
    final icons = widget.config.icons;
    final layout = widget.config.layout;

    return Container(
      padding: customTheme?.padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: customTheme?.backgroundColor,
        borderRadius:
            customTheme?.borderRadius ??
            const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.config.title,
                  style: TextStyle(color: customTheme?.textColor),
                ),
              ),
              // Custom toolbar actions
              ...widget.config.toolbarActions.map(
                (action) => Padding(
                  padding: EdgeInsets.only(left: customTheme?.spacing ?? 8),
                  child: Tooltip(
                    message: action.tooltip ?? action.label ?? '',
                    child: IconButton(
                      icon: Icon(action.icon, color: customTheme?.iconColor),
                      onPressed: action.onPressed,
                    ),
                  ),
                ),
              ),
              if (widget.config.enableViewModeSwitch)
                Tooltip(
                  message: 'Switch View Mode',
                  child: IconButton(
                    icon: Icon(
                      _getViewModeIcon(),
                      color: customTheme?.iconColor,
                    ),
                    onPressed: _toggleViewMode,
                  ),
                ),
              IconButton(
                icon: Icon(icons.close, color: customTheme?.iconColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          SizedBox(height: customTheme?.spacing ?? 12),
          SizedBox(
            height: layout.searchFieldHeight,
            child: FluentTextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: widget.config.searchHint,
                hintStyle: TextStyle(color: customTheme?.hintColor),
                prefixIcon: widget.config.showSearchIcon
                    ? Icon(icons.search, color: customTheme?.iconColor)
                    : null,
                suffixIcon:
                    _searchController.text.isNotEmpty &&
                        widget.config.showClearButton
                    ? IconButton(
                        icon: Icon(icons.clear, color: customTheme?.iconColor),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius:
                      customTheme?.borderRadius ?? BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color:
                        customTheme?.borderColor ??
                        theme.resources.dividerStrokeColorDefault,
                    width: layout.borderWidth,
                  ),
                ),
                filled: true,
                fillColor: customTheme?.cardColor ?? theme.cardColor,
              ),
              style: TextStyle(color: customTheme?.textColor),
              autofocus: true,
              onSubmitted: (_) => _performSearch(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: widget.filterBuilder!(context, _filters, _onFiltersChanged),
    );
  }

  Widget _buildStats(FluentThemeData theme) {
    if (widget.statsBuilder != null) {
      return widget.statsBuilder!(
        context,
        _results.length,
        _getDisplayedResults().length,
        _searchController.text,
        _lastSearchDuration,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        // color: theme.accentColor.withValues(alpha:0.05),
        border: Border(
          bottom: BorderSide(color: theme.resources.dividerStrokeColorDefault),
        ),
      ),
      child: Row(
        children: [
          Icon(FluentIcons.info, size: 16, color: theme.accentColor),
          const SizedBox(width: 8),
          Text(
            '${_results.length} results found',
            style: theme.typography.body,
          ),
          if (_lastSearchDuration.inMilliseconds > 0) ...[
            const SizedBox(width: 16),
            Text(
              'in ${_lastSearchDuration.inMilliseconds}ms',
              style: theme.typography.body?.copyWith(
                color: theme.typography.body?.color?.withValues(alpha: 0.6),
              ),
            ),
          ],
          const Spacer(),
          if (widget.enableMultiSelect && _selectedItems.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                // color: theme.accentColor.withValues(alpha:0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text('${_selectedItems.length} selected'),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(FluentThemeData theme) {
    if (_isLoading) {
      return widget.loadingBuilder?.call(context) ?? _buildDefaultLoading();
    }

    if (_error != null) {
      return widget.errorBuilder?.call(context, _error!) ??
          _buildDefaultError();
    }

    if (_results.isEmpty) {
      return widget.emptyStateBuilder?.call(context) ??
          _buildDefaultEmptyState(theme);
    }

    final displayedResults = _getDisplayedResults();

    return Scrollbar(
      controller: _scrollController,
      child: _buildResultsView(displayedResults, theme),
    );
  }

  Widget _buildResultsView(
    List<FluentAutoSuggestBoxItem<T>> results,
    FluentThemeData theme,
  ) {
    switch (_viewMode) {
      case AdvancedSearchViewMode.list:
        return _buildListView(results, theme);
      case AdvancedSearchViewMode.grid:
        return _buildGridView(results, theme);
      case AdvancedSearchViewMode.compact:
        return _buildCompactView(results, theme);
    }
  }

  Widget _buildListView(
    List<FluentAutoSuggestBoxItem<T>> results,
    FluentThemeData theme,
  ) {
    final layout = widget.config.layout;
    final customTheme = widget.config.theme;
    final icons = widget.config.icons;

    return ListView.builder(
      controller: _scrollController,
      padding: customTheme?.padding ?? const EdgeInsets.all(8),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        final isSelected = _selectedItems.contains(item);

        return Card(
          margin: EdgeInsets.symmetric(
            vertical: layout.listItemSpacing / 2,
            horizontal: customTheme?.spacing ?? 8,
          ),
          backgroundColor: isSelected
              ? (customTheme?.selectedItemColor ??
                    theme.accentColor.withValues(alpha: 0.1))
              : customTheme?.cardColor,
          child: GestureDetector(
            onTap: () => _selectItem(item),
            child: Container(
              height: layout.itemHeight,
              padding: customTheme?.padding ?? const EdgeInsets.all(12),
              child: Row(
                children: [
                  if (widget.enableMultiSelect)
                    Checkbox(
                      checked: isSelected,
                      onChanged: (_) => _selectItem(item),
                    ),
                  Expanded(
                    child:
                        widget.itemBuilder?.call(context, item) ??
                        _buildDefaultListItem(item, theme),
                  ),
                  Icon(
                    icons.chevronRight,
                    color:
                        customTheme?.iconColor ?? theme.typography.body?.color,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(
    List<FluentAutoSuggestBoxItem<T>> results,
    FluentThemeData theme,
  ) {
    final layout = widget.config.layout;
    final customTheme = widget.config.theme;

    return GridView.builder(
      controller: _scrollController,
      padding: customTheme?.padding ?? const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: layout.gridCrossAxisCount,
        crossAxisSpacing: layout.gridCrossAxisSpacing,
        mainAxisSpacing: layout.gridMainAxisSpacing,
        childAspectRatio: layout.gridChildAspectRatio,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        final isSelected = _selectedItems.contains(item);

        return widget.itemCardBuilder?.call(context, item, isSelected) ??
            _buildDefaultGridCard(item, isSelected, theme);
      },
    );
  }

  Widget _buildCompactView(
    List<FluentAutoSuggestBoxItem<T>> results,
    FluentThemeData theme,
  ) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        final isSelected = _selectedItems.contains(item);

        return ListTile.selectable(
          selected: isSelected,
          leading: widget.enableMultiSelect
              ? Checkbox(
                  checked: isSelected,
                  onChanged: (_) => _selectItem(item),
                )
              : null,
          title: Text(item.label, maxLines: 1, overflow: TextOverflow.ellipsis),
          onPressed: () => _selectItem(item),
        );
      },
    );
  }

  Widget _buildDefaultListItem(
    FluentAutoSuggestBoxItem<T> item,
    FluentThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.label,
          style: theme.typography.title?.copyWith(fontWeight: FontWeight.w500),
        ),
        if (item.subtitle != null) ...[
          const SizedBox(height: 4),
          DefaultTextStyle(
            style: theme.typography.body!,
            child: item.subtitle!,
          ),
        ],
      ],
    );
  }

  Widget _buildDefaultGridCard(
    FluentAutoSuggestBoxItem<T> item,
    bool isSelected,
    FluentThemeData theme,
  ) {
    return Card(
      backgroundColor: isSelected
          ? theme.accentColor.withValues(alpha: 0.1)
          : null,
      child: GestureDetector(
        onTap: () => _selectItem(item),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FluentIcons.articles,
                      size: 48,
                      color: theme.accentColor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.typography.bodyStrong,
                    ),
                  ],
                ),
              ),
            ),
            if (widget.enableMultiSelect)
              Positioned(
                top: 8,
                right: 8,
                child: Checkbox(
                  checked: isSelected,
                  onChanged: (_) => _selectItem(item),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ProgressRing(), SizedBox(height: 16), Text('Searching...')],
      ),
    );
  }

  Widget _buildDefaultError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FluentIcons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: ${_error.toString()}'),
          const SizedBox(height: 16),
          Button(onPressed: _performSearch, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildDefaultEmptyState(FluentThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FluentIcons.search,
            size: 64,
            color: theme.typography.body?.color,
          ),
          const SizedBox(height: 16),
          Text('No results found', style: theme.typography.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: theme.typography.body,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(FluentThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
          top: BorderSide(color: theme.resources.dividerStrokeColorDefault),
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child:
          widget.footerBuilder?.call(context) ??
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              HyperlinkButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              Button(
                onPressed: _selectedItems.isEmpty ? null : _confirmSelection,
                child: Text('Select (${_selectedItems.length})'),
              ),
            ],
          ),
    );
  }

  List<FluentAutoSuggestBoxItem<T>> _getDisplayedResults() {
    if (!widget.config.enablePagination) {
      return _results;
    }

    final start = _currentPage * widget.config.resultsPerPage;
    final end = start + widget.config.resultsPerPage;

    if (start >= _results.length) return [];
    return _results.sublist(start, end.clamp(0, _results.length));
  }

  IconData _getViewModeIcon() {
    final icons = widget.config.icons;
    switch (_viewMode) {
      case AdvancedSearchViewMode.list:
        return icons.viewList;
      case AdvancedSearchViewMode.grid:
        return icons.viewGrid;
      case AdvancedSearchViewMode.compact:
        return icons.viewCompact;
    }
  }
}
