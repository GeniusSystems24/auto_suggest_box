part of 'auto_suggest_advanced.dart';

/// Extension to add advanced search capabilities to FluentAutoSuggestBox
///
/// This extension wraps a basic FluentAutoSuggestBox with advanced search features:
/// - Full-screen search dialog
/// - Multiple view modes (list, grid, compact)
/// - Keyboard shortcuts (default: F3)
/// - Filters support
/// - Statistics display
/// - Multi-select support
///
/// Example usage:
/// ```dart
/// AdvancedSearchExtension.withAdvancedSearch<String>(
///   autoSuggestBox: FluentAutoSuggestBox<String>(...),
///   config: AdvancedSearchConfig(
///     title: 'Advanced Product Search',
///     keyboardShortcut: SingleActivator(LogicalKeyboardKey.f3),
///   ),
///   onAdvancedSearch: (query, filters) async {
///     // Perform advanced search
///     return results;
///   },
/// )
/// ```
extension AdvancedSearchExtension on FluentAutoSuggestBox {
  /// Enable advanced search dialog with keyboard shortcut
  static Widget withAdvancedSearch<T>({
    required FluentAutoSuggestBox<T> autoSuggestBox,
    required AdvancedSearchConfig config,
    required Future<List<FluentAutoSuggestBoxItem<T>>> Function(
      String query,
      Map<String, dynamic> filters,
    ) onAdvancedSearch,
    Widget Function(BuildContext, FluentAutoSuggestBoxItem<T>)? advancedItemBuilder,
    AdvancedItemCardBuilder<T>? itemCardBuilder,
    FilterBuilder? filterBuilder,
    StatsBuilder<T>? statsBuilder,
    WidgetBuilder? headerBuilder,
    WidgetBuilder? footerBuilder,
    WidgetBuilder? emptyStateBuilder,
    Widget Function(BuildContext, Object error)? errorBuilder,
    WidgetBuilder? loadingBuilder,
    Set<FluentAutoSuggestBoxItem<T>> Function(
      String text,
      Set<FluentAutoSuggestBoxItem<T>> items,
    )? sorter,
  }) {
    return _AdvancedSearchWrapper<T>(
      autoSuggestBox: autoSuggestBox,
      config: config,
      onAdvancedSearch: onAdvancedSearch,
      advancedItemBuilder: advancedItemBuilder,
      itemCardBuilder: itemCardBuilder,
      filterBuilder: filterBuilder,
      statsBuilder: statsBuilder,
      headerBuilder: headerBuilder,
      footerBuilder: footerBuilder,
      emptyStateBuilder: emptyStateBuilder,
      errorBuilder: errorBuilder,
      loadingBuilder: loadingBuilder,
      sorter: sorter,
    );
  }
}

/// Wrapper widget to add keyboard shortcut support
class _AdvancedSearchWrapper<T> extends StatefulWidget {
  const _AdvancedSearchWrapper({
    required this.autoSuggestBox,
    required this.config,
    required this.onAdvancedSearch,
    this.advancedItemBuilder,
    this.itemCardBuilder,
    this.filterBuilder,
    this.statsBuilder,
    this.headerBuilder,
    this.footerBuilder,
    this.emptyStateBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.sorter,
  });

  final FluentAutoSuggestBox<T> autoSuggestBox;
  final AdvancedSearchConfig config;
  final Future<List<FluentAutoSuggestBoxItem<T>>> Function(
    String query,
    Map<String, dynamic> filters,
  ) onAdvancedSearch;
  final Widget Function(BuildContext, FluentAutoSuggestBoxItem<T>)? advancedItemBuilder;
  final AdvancedItemCardBuilder<T>? itemCardBuilder;
  final FilterBuilder? filterBuilder;
  final StatsBuilder<T>? statsBuilder;
  final WidgetBuilder? headerBuilder;
  final WidgetBuilder? footerBuilder;
  final WidgetBuilder? emptyStateBuilder;
  final Widget Function(BuildContext, Object error)? errorBuilder;
  final WidgetBuilder? loadingBuilder;
  final Set<FluentAutoSuggestBoxItem<T>> Function(
    String text,
    Set<FluentAutoSuggestBoxItem<T>> items,
  )? sorter;

  @override
  State<_AdvancedSearchWrapper<T>> createState() => _AdvancedSearchWrapperState<T>();
}

class _AdvancedSearchWrapperState<T> extends State<_AdvancedSearchWrapper<T>> {
  final FocusNode _focusNode = FocusNode();

  void _openAdvancedSearch() async {
    final result = await AdvancedSearchDialog.show<T>(
      context: context,
      items: widget.autoSuggestBox.items.value.toList(),
      onSearch: widget.onAdvancedSearch,
      config: widget.config,
      itemBuilder: widget.advancedItemBuilder,
      itemCardBuilder: widget.itemCardBuilder,
      filterBuilder: widget.filterBuilder,
      statsBuilder: widget.statsBuilder,
      headerBuilder: widget.headerBuilder,
      footerBuilder: widget.footerBuilder,
      emptyStateBuilder: widget.emptyStateBuilder,
      errorBuilder: widget.errorBuilder,
      loadingBuilder: widget.loadingBuilder,
      controller: widget.autoSuggestBox.autoSuggestController,
      sorter: widget.sorter,
    );

    if (result != null && widget.autoSuggestBox.onSelected != null) {
      // Find the item in the list
      final item = widget.autoSuggestBox.items.value
          .firstWhere((i) => i.value == result, orElse: () => FluentAutoSuggestBoxItem(
            value: result,
            label: result.toString(),
          ));
      widget.autoSuggestBox.onSelected!(item);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.config.enableKeyboardShortcut) {
      return widget.autoSuggestBox;
    }

    return CallbackShortcuts(
      bindings: {
        widget.config.keyboardShortcut: _openAdvancedSearch,
      },
      child: Focus(
        focusNode: _focusNode,
        autofocus: false,
        child: widget.autoSuggestBox,
      ),
    );
  }
}
