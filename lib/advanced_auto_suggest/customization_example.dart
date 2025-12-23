import 'package:auto_suggest_box/auto_suggest/auto_suggest.dart';
import 'package:fluent_ui/fluent_ui.dart';


import 'auto_suggest_advanced.dart';

/// Comprehensive example of customizing the Advanced Search Dialog
///
/// This example demonstrates all available customization options including:
/// - Custom theme (colors, spacing, borders)
/// - Custom icons
/// - Custom layout (grid size, spacing, heights)
/// - Custom animations
/// - Custom toolbar actions
///
/// Usage:
/// ```dart
/// // Simple usage with default theme
/// await AdvancedSearchDialog.show<String>(
///   context: context,
///   items: myItems,
///   onSearch: performSearch,
/// );
///
/// // Fully customized usage
/// await AdvancedSearchDialog.show<Product>(
///   context: context,
///   items: productItems,
///   onSearch: searchProducts,
///   config: customConfig,
/// );
/// ```
class AdvancedSearchCustomizationExample {
  /// Example 1: Custom Blue Theme
  static AdvancedSearchConfig get blueTheme {
    return AdvancedSearchConfig(
      title: 'Find Products',
      searchHint: 'Search by name, code, or category...',
      theme: AdvancedSearchTheme(
        primaryColor: Colors.blue,
        backgroundColor: Colors.white,
        cardColor: const Color(0xFFF5F7FA),
        selectedItemColor: Colors.blue.withValues(alpha: 0.15),
        borderColor: Colors.blue.withValues(alpha: 0.3),
        textColor: Colors.black,
        hintColor: Colors.grey,
        iconColor: Colors.blue,
        borderRadius: BorderRadius.circular(12),
        spacing: 16,
        padding: const EdgeInsets.all(20),
        elevation: 8,
      ),
      layout: const AdvancedSearchLayout(
        gridCrossAxisCount: 4, // 4 columns in grid view
        itemHeight: 80,
        searchFieldHeight: 56,
      ),
      animation: const AdvancedSearchAnimation(
        dialogEnterDuration: Duration(milliseconds: 400),
        dialogCurve: Curves.elasticOut,
        searchDebounceDuration: Duration(milliseconds: 500),
      ),
      toolbarActions: [
        AdvancedSearchAction(
          icon: FluentIcons.refresh,
          tooltip: 'Refresh',
          onPressed: () {
            // Refresh logic here
          },
        ),
        AdvancedSearchAction(
          icon: FluentIcons.settings,
          tooltip: 'Settings',
          onPressed: () {
            // Settings logic here
          },
        ),
      ],
      viewMode: AdvancedSearchViewMode.grid,
      showStats: true,
      enableAnimations: true,
    );
  }

  /// Example 2: Dark Theme
  static AdvancedSearchConfig get darkTheme {
    return AdvancedSearchConfig(
      title: 'Advanced Search',
      searchHint: 'Type to search...',
      theme: AdvancedSearchTheme(
        primaryColor: const Color(0xFF60A5FA),
        backgroundColor: const Color(0xFF1E1E2E),
        cardColor: const Color(0xFF2A2A3E),
        selectedItemColor: const Color(0xFF60A5FA).withValues(alpha: 0.2),
        borderColor: const Color(0xFF3F3F5F),
        textColor: Colors.white,
        hintColor: Colors.grey[400],
        iconColor: const Color(0xFF60A5FA),
        borderRadius: BorderRadius.circular(8),
        spacing: 12,
        elevation: 16,
      ),
      icons: const AdvancedSearchIcons(
        search: FluentIcons.search,
        clear: FluentIcons.cancel,
        close: FluentIcons.chrome_close,
        viewList: FluentIcons.list,
        viewGrid: FluentIcons.grid_view_large,
      ),
      animation: const AdvancedSearchAnimation(
        dialogEnterDuration: Duration(milliseconds: 250),
        dialogCurve: Curves.easeOutCubic,
        itemCurve: Curves.easeOut,
      ),
    );
  }

  /// Example 3: Compact/Minimal Theme
  static AdvancedSearchConfig get compactTheme {
    return AdvancedSearchConfig(
      title: 'Quick Search',
      searchHint: 'Search...',
      constraints: const BoxConstraints(
        minWidth: 500,
        minHeight: 300,
        maxWidth: 800,
        maxHeight: 600,
      ),
      theme: AdvancedSearchTheme(
        spacing: 8,
        padding: const EdgeInsets.all(12),
        borderRadius: BorderRadius.circular(4),
        elevation: 2,
      ),
      layout: const AdvancedSearchLayout(
        headerHeight: 80,
        itemHeight: 48,
        compactItemHeight: 40,
        searchFieldHeight: 40,
        listItemSpacing: 4,
      ),
      viewMode: AdvancedSearchViewMode.compact,
      showStats: false,
      showFilters: false,
      enableViewModeSwitch: false,
      enableAnimations: false, // Instant, no animations
    );
  }

  /// Example 4: Colorful/Fun Theme
  static AdvancedSearchConfig get colorfulTheme {
    return AdvancedSearchConfig(
      title: '🔍 Discover Items',
      searchHint: '✨ Type something magical...',
      theme: AdvancedSearchTheme(
        primaryColor: Colors.purple,
        backgroundColor: const Color(0xFFFFF8F0),
        cardColor: Colors.white,
        selectedItemColor: Colors.purple.withValues(alpha: 0.1),
        borderColor: Colors.purple.withValues(alpha: 0.3),
        textColor: const Color(0xFF2D3748),
        iconColor: Colors.purple,
        borderRadius: BorderRadius.circular(16),
        spacing: 20,
        padding: const EdgeInsets.all(24),
      ),
      animation: const AdvancedSearchAnimation(
        dialogEnterDuration: Duration(milliseconds: 500),
        dialogCurve: Curves.bounceOut,
        itemEnterDuration: Duration(milliseconds: 300),
        viewSwitchDuration: Duration(milliseconds: 400),
      ),
      toolbarActions: [
        AdvancedSearchAction(
          icon: FluentIcons.emoji2,
          tooltip: 'Fun Mode!',
          onPressed: () {},
        ),
      ],
    );
  }

  /// Example 5: Professional/Enterprise Theme
  static AdvancedSearchConfig get professionalTheme {
    return AdvancedSearchConfig(
      title: 'Enterprise Search',
      searchHint: 'Search across all resources...',
      constraints: const BoxConstraints(
        minWidth: 800,
        minHeight: 600,
        maxWidth: 1400,
        maxHeight: 900,
      ),
      theme: AdvancedSearchTheme(
        primaryColor: const Color(0xFF0066CC),
        backgroundColor: Colors.white,
        cardColor: const Color(0xFFFAFAFA),
        selectedItemColor: const Color(0xFF0066CC).withValues(alpha: 0.08),
        borderColor: const Color(0xFFE0E0E0),
        textColor: const Color(0xFF212121),
        hintColor: const Color(0xFF757575),
        iconColor: const Color(0xFF0066CC),
        borderRadius: BorderRadius.circular(4),
        spacing: 16,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 4,
      ),
      layout: const AdvancedSearchLayout(
        headerHeight: 100,
        footerHeight: 72,
        itemHeight: 72,
        gridCrossAxisCount: 3,
        searchFieldHeight: 48,
        borderWidth: 1.5,
      ),
      toolbarActions: [
        AdvancedSearchAction(
          icon: FluentIcons.filter_solid,
          tooltip: 'Advanced Filters',
          onPressed: () {},
        ),
        AdvancedSearchAction(
          icon: FluentIcons.sort,
          tooltip: 'Sort Options',
          onPressed: () {},
        ),
        AdvancedSearchAction(
          icon: FluentIcons.export,
          tooltip: 'Export Results',
          onPressed: () {},
        ),
      ],
      showStats: true,
      showFilters: true,
      enablePagination: true,
      resultsPerPage: 50,
    );
  }

  /// Example 6: Minimalist Theme (Material Design inspired)
  static AdvancedSearchConfig get minimalistTheme {
    return AdvancedSearchConfig(
      title: 'Search',
      searchHint: 'Find anything...',
      theme: AdvancedSearchTheme(
        backgroundColor: Colors.white,
        cardColor: Colors.white,
        selectedItemColor: Colors.grey[200],
        borderColor: Colors.grey[300],
        textColor: Colors.black,
        hintColor: Colors.grey[600],
        iconColor: Colors.grey[700],
        borderRadius: BorderRadius.circular(0), // No border radius
        spacing: 16,
        elevation: 0, // Flat design
      ),
      layout: const AdvancedSearchLayout(borderWidth: 1),
      showClearButton: true,
      showSearchIcon: true,
    );
  }
}

/// Example of how to use custom theme in practice
class CustomizedAdvancedSearchWidget extends StatelessWidget {
  const CustomizedAdvancedSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: () async {
        final result = await AdvancedSearchDialog.show<String>(
          context: context,
          items: _getDemoItems(),
          onSearch: _performSearch,
          config: AdvancedSearchCustomizationExample.blueTheme,
          itemBuilder: (context, item) => _buildCustomItemWidget(item),
        );

        if (result != null) {
          // Handle selection
        }
      },
      child: const Text('Open Advanced Search'),
    );
  }

  List<FluentAutoSuggestBoxItem<String>> _getDemoItems() {
    return List.generate(
      50,
      (index) => FluentAutoSuggestBoxItem(
        value: 'item_$index',
        label: 'Item $index',
        subtitle: Text('Description for item $index'),
      ),
    );
  }

  Future<List<FluentAutoSuggestBoxItem<String>>> _performSearch(
    String query,
    Map<String, dynamic> filters,
  ) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    // Filter items based on query
    return _getDemoItems().where((item) {
      return item.label.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Widget _buildCustomItemWidget(FluentAutoSuggestBoxItem<String> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        if (item.subtitle != null) item.subtitle!,
      ],
    );
  }
}
