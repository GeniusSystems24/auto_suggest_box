# Fluent Auto Suggest Box

[![pub package](https://img.shields.io/pub/v/auto_suggest_box.svg)](https://pub.dev/packages/auto_suggest_box)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D1.17.0-blue.svg)](https://flutter.dev)

A highly customizable, performance-optimized auto-suggest/autocomplete widget for Flutter with Fluent UI design. Features include debounced search, LRU caching, keyboard navigation, form validation, advanced search dialog, and BLoC/Cubit state management (similar to [smart_pagination](https://pub.dev/packages/smart_pagination)).

## Features

- **Debounced Search** - Configurable delay to reduce API calls
- **LRU Caching** - Intelligent caching with TTL (Time To Live) expiration
- **Keyboard Navigation** - Full support for Arrow keys, Tab, Escape, and Enter
- **Form Validation** - Built-in validator support with AutovalidateMode
- **Server-Side Search** - Async search with `onNoResultsFound` callback
- **Loading & Error States** - Customizable loading and error handling
- **Custom Builders** - Full control over item rendering
- **Accessibility** - Semantic labels and screen reader support
- **Recent Searches** - Track and display search history
- **Advanced Search Dialog** - Full-featured search with filters, pagination, and multiple view modes
- **BLoC/Cubit Support** - State management similar to smart_pagination
- **Performance Optimized** - Reduced rebuilds, efficient memory usage

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  auto_suggest_box: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### Basic Usage

```dart
import 'package:auto_suggest_box/auto_suggest_box.dart';

FluentAutoSuggestBox<String>(
  items: [
    FluentAutoSuggestBoxItem(value: '1', label: 'Apple'),
    FluentAutoSuggestBoxItem(value: '2', label: 'Banana'),
    FluentAutoSuggestBoxItem(value: '3', label: 'Cherry'),
  ],
  onSelected: (item) {
    print('Selected: ${item?.label}');
  },
)
```

### With Server Search

```dart
FluentAutoSuggestBox<Product>(
  items: localProducts,
  enableCache: true,
  cacheMaxSize: 100,
  cacheDuration: Duration(minutes: 30),
  debounceDelay: Duration(milliseconds: 300),
  onNoResultsFound: (query) async {
    // Fetch from server
    final response = await api.searchProducts(query);
    return response.map((p) => FluentAutoSuggestBoxItem(
      value: p,
      label: p.name,
      subtitle: Text(p.description),
    )).toList();
  },
  onSelected: (item) {
    if (item != null) {
      navigateToProduct(item.value);
    }
  },
)
```

### Form Validation

```dart
FluentAutoSuggestBox<String>.form(
  items: countries,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please select a country';
    }
    return null;
  },
  autovalidateMode: AutovalidateMode.onUserInteraction,
  onSelected: (item) => setState(() => selectedCountry = item?.value),
)
```

## Cubit/BLoC State Management

Similar to [smart_pagination](https://pub.dev/packages/smart_pagination), this package provides a Cubit-based state management solution integrated directly into `FluentAutoSuggestBox`.

### Creating a Cubit

```dart
final productsCubit = AutoSuggestCubit<Product>(
  provider: (query, {filters}) async {
    return await api.searchProducts(query);
  },
  config: AutoSuggestConfig(
    debounceDelay: Duration(milliseconds: 300),
    dataAge: Duration(minutes: 15),  // Cache expiration
    maxCacheSize: 50,
    retryConfig: RetryConfig(
      maxRetries: 3,
      initialDelay: Duration(seconds: 1),
    ),
  ),
);
```

### Using FluentAutoSuggestBox.cubit (Recommended)

The integrated cubit mode provides the same FluentAutoSuggestBox experience with Cubit state management:

```dart
FluentAutoSuggestBox<Product>.cubit(
  cubit: productsCubit,
  cubitItemBuilder: (context, product, isSelected, onTap) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text('\$${product.price}'),
      selected: isSelected,
      onPressed: onTap,
    );
  },
  labelBuilder: (product) => product.name,
  onCubitSelected: (product) {
    print('Selected: ${product.name}');
  },
  showCubitStats: true,  // Show cache statistics
)
```

### Using BlocAutoSuggestBox (Standalone)

You can also use the standalone `BlocAutoSuggestBox` widget:

```dart
BlocAutoSuggestBox<Product>(
  cubit: productsCubit,
  itemBuilder: (context, product, isSelected, onTap) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text('\$${product.price}'),
      selected: isSelected,
      onPressed: onTap,
    );
  },
  labelBuilder: (product) => product.name,
  onSelected: (product) {
    print('Selected: ${product.name}');
  },
  showStats: true,  // Show cache statistics
)
```

### Using BlocBuilder Directly

```dart
BlocBuilder<AutoSuggestCubit<Product>, AutoSuggestState<Product>>(
  bloc: productsCubit,
  builder: (context, state) {
    return switch (state) {
      AutoSuggestInitial() => Text('Start typing to search...'),
      AutoSuggestLoading(:final query) => CircularProgressIndicator(),
      AutoSuggestLoaded(:final items) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => Text(items[index].name),
      ),
      AutoSuggestEmpty(:final query) => Text('No results for "$query"'),
      AutoSuggestError(:final error) => Text('Error: $error'),
    };
  },
)
```

### AutoSuggestBlocBuilder (Convenience Widget)

```dart
AutoSuggestBlocBuilder<Product>(
  cubit: productsCubit,
  onInitial: (context) => Text('Ready to search'),
  onLoading: (context, query, previousItems) => ProgressRing(),
  onLoaded: (context, items, query) => ProductList(items: items),
  onEmpty: (context, query) => Text('No products found'),
  onError: (context, error, query, previousItems) => ErrorWidget(error),
)
```

### State Classes

| State | Properties | Description |
|-------|------------|-------------|
| `AutoSuggestInitial` | - | Initial state before any search |
| `AutoSuggestLoading` | `query`, `previousItems`, `isLoadingMore` | Loading state |
| `AutoSuggestLoaded` | `items`, `query`, `fetchedAt`, `dataExpiredAt` | Success with data |
| `AutoSuggestEmpty` | `query`, `searchedAt` | No results found |
| `AutoSuggestError` | `error`, `query`, `previousItems` | Error state |

### Data Expiration (like smart_pagination)

```dart
// Check if data is expired
if (cubit.isDataExpired) {
  await cubit.refresh();
}

// Or use automatic check
await cubit.checkAndRefreshIfExpired();

// Access data age
final age = cubit.dataAge;  // Duration since last fetch
```

### Statistics

```dart
final stats = cubit.stats;
print('Cache hits: ${stats['cacheHits']}');
print('Cache misses: ${stats['cacheMisses']}');
print('Hit rate: ${(stats['cacheHitRate'] * 100).toStringAsFixed(1)}%');
```

## API Reference

### FluentAutoSuggestBox

The main widget for creating auto-suggest input fields.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `items` | `List<FluentAutoSuggestBoxItem<T>>` | required | List of suggestion items |
| `controller` | `TextEditingController?` | null | Text controller for the input field |
| `autoSuggestController` | `AutoSuggestController<T>?` | null | Controller for managing state |
| `onChanged` | `OnTextChanged<T>?` | null | Callback when text changes |
| `onSelected` | `ValueChanged<FluentAutoSuggestBoxItem<T>?>?` | null | Callback when item is selected |
| `itemBuilder` | `ItemBuilder<T>?` | null | Custom widget builder for items |
| `noResultsFoundBuilder` | `WidgetBuilder?` | null | Widget shown when no results |
| `loadingBuilder` | `WidgetBuilder?` | null | Widget shown while loading |
| `sorter` | `ItemSorter<T>?` | defaultItemSorter | Custom sorting function |
| `enableCache` | `bool` | true | Enable result caching |
| `cacheMaxSize` | `int` | 100 | Maximum cache entries |
| `cacheDuration` | `Duration` | 30 minutes | Cache TTL |
| `debounceDelay` | `Duration` | 300ms | Debounce delay for search |
| `minSearchLength` | `int` | 2 | Minimum characters to trigger search |
| `maxPopupHeight` | `double` | 380.0 | Maximum height of suggestion popup |
| `direction` | `AutoSuggestBoxDirection` | below | Popup direction (above/below) |
| `validator` | `FormFieldValidator<String>?` | null | Form validation function |
| `autovalidateMode` | `AutovalidateMode` | disabled | Validation mode |

### FluentAutoSuggestBoxItem

Represents a single suggestion item.

```dart
FluentAutoSuggestBoxItem<T>({
  required T value,        // The actual data value
  required String label,   // Display text
  Widget? child,           // Custom widget (overrides label)
  Widget? subtitle,        // Secondary text/widget
  bool enabled = true,     // Whether item is selectable
  String? semanticLabel,   // Accessibility label
})
```

### AutoSuggestController

Controller for managing search state and metrics.

```dart
final controller = AutoSuggestController<String>(
  debounceDelay: Duration(milliseconds: 300),
  minSearchLength: 2,
  maxRecentSearches: 10,
  enableRecentSearches: true,
);

// Access state
print(controller.searchQuery);
print(controller.isLoading);
print(controller.recentSearches);

// Get statistics
final stats = controller.getStats();
print('Success rate: ${stats['successRate']}');

// Clean up
controller.dispose();
```

### SearchResultsCache

LRU cache with automatic expiration.

```dart
final cache = SearchResultsCache<Product>(
  maxSize: 100,
  maxAge: Duration(minutes: 30),
  enablePrefixMatching: true,
);

// Cache operations
cache.set('query', results);
final cached = cache.get('query');
cache.clear();

// Get statistics
final stats = cache.getStats();
print('Hit rate: ${(stats.hitRate * 100).toStringAsFixed(1)}%');
```

## Advanced Search Dialog

For complex search requirements, use the `AdvancedSearchDialog`:

```dart
// Single selection
final result = await AdvancedSearchDialog.show<Product>(
  context: context,
  items: products,
  onSearch: (query, filters) async {
    return await api.search(query, filters: filters);
  },
  config: AdvancedSearchConfig(
    title: 'Find Product',
    searchHint: 'Search by name or SKU...',
    showFilters: true,
    showStats: true,
    viewMode: AdvancedSearchViewMode.grid,
    keyboardShortcut: SingleActivator(LogicalKeyboardKey.f3),
  ),
);

// Multi-selection
final results = await AdvancedSearchDialog.showMultiSelect<Product>(
  context: context,
  items: products,
  onSearch: (query, filters) async => await api.search(query),
  maxSelections: 5,
);
```

### View Modes

| Mode | Description |
|------|-------------|
| `list` | Traditional list view with details |
| `grid` | Card-based grid layout |
| `compact` | Condensed single-line items |

### Configuration Options

```dart
AdvancedSearchConfig(
  title: 'Search',                    // Dialog title
  searchHint: 'Type to search...',    // Placeholder text
  keyboardShortcut: SingleActivator(LogicalKeyboardKey.f3),
  showFilters: true,                  // Show filter panel
  showStats: true,                    // Show result statistics
  viewMode: AdvancedSearchViewMode.list,
  enableViewModeSwitch: true,         // Allow mode switching
  resultsPerPage: 20,                 // Pagination size
  enablePagination: false,            // Enable pagination
  enableAnimations: true,             // Enable animations
)
```

## Custom Builders

### Custom Item Builder

```dart
FluentAutoSuggestBox<Product>(
  items: products,
  itemBuilder: (context, item) {
    return ListTile(
      leading: Image.network(item.value.imageUrl),
      title: Text(item.label),
      subtitle: Text('\$${item.value.price}'),
      trailing: Icon(Icons.chevron_right),
    );
  },
)
```

### Custom Sorter

```dart
FluentAutoSuggestBox<Product>(
  items: products,
  sorter: (query, items) {
    return items.where((item) {
      // Custom matching logic
      return item.label.toLowerCase().contains(query.toLowerCase()) ||
             item.value.sku.contains(query);
    }).toSet();
  },
)
```

### Custom Loading Builder

```dart
FluentAutoSuggestBox<String>(
  items: items,
  loadingBuilder: (context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 16),
          Text('Searching...'),
        ],
      ),
    );
  },
)
```

## Keyboard Navigation

| Key | Action |
|-----|--------|
| `Arrow Down` | Select next item |
| `Arrow Up` | Select previous item |
| `Enter` | Confirm selection |
| `Tab` | Move to next field |
| `Shift+Tab` | Move to previous field |
| `Escape` | Close suggestions |
| `F3` | Open advanced search (if enabled) |

## Performance Tips

1. **Enable Caching** - Set `enableCache: true` for repeated searches
2. **Adjust Debounce** - Increase `debounceDelay` for slow APIs
3. **Set Min Length** - Use `minSearchLength` to prevent unnecessary searches
4. **Use Prefix Matching** - Cache uses prefix matching by default
5. **Limit Results** - Return limited results from `onNoResultsFound`

```dart
FluentAutoSuggestBox<String>(
  items: items,
  enableCache: true,
  cacheMaxSize: 50,
  cacheDuration: Duration(minutes: 15),
  debounceDelay: Duration(milliseconds: 500),
  minSearchLength: 3,
)
```

## Theming

### Custom Theme

```dart
AdvancedSearchConfig(
  theme: AdvancedSearchTheme(
    primaryColor: Colors.blue,
    backgroundColor: Colors.white,
    cardColor: Colors.grey[50],
    selectedItemColor: Colors.blue.withOpacity(0.1),
    borderRadius: BorderRadius.circular(12),
    spacing: 16.0,
    elevation: 8.0,
  ),
)
```

### Custom Icons

```dart
AdvancedSearchConfig(
  icons: AdvancedSearchIcons(
    search: FluentIcons.search,
    clear: FluentIcons.clear,
    filter: FluentIcons.filter,
    viewList: FluentIcons.view_list,
    viewGrid: FluentIcons.grid_view_medium,
  ),
)
```

## Example App

See the `/example` folder for a complete sample application demonstrating:

- Basic autocomplete
- Server-side search with caching
- Form validation
- Custom builders
- Advanced search dialog
- Multiple view modes
- Keyboard shortcuts

Run the example:

```bash
cd example
flutter run
```

## Requirements

- Flutter >= 1.17.0
- Dart SDK >= 3.10.3

## Dependencies

- [fluent_ui](https://pub.dev/packages/fluent_ui) ^4.13.0
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) ^8.1.6
- [equatable](https://pub.dev/packages/equatable) ^2.0.5
- [gap](https://pub.dev/packages/gap) ^3.0.1

## Roadmap

- [x] Cubit/BLoC state management integration (similar to smart_pagination)
- [ ] RTL language support improvements
- [ ] More animation options
- [ ] Voice search support
- [ ] Grouped suggestions
- [ ] Inline suggestions (ghost text)
- [ ] Pagination support for large datasets

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this package helpful, please give it a star on GitHub!
