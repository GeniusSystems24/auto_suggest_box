# Fluent Auto Suggest Box

[![pub package](https://img.shields.io/pub/v/auto_suggest_box.svg)](https://pub.dev/packages/auto_suggest_box)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D1.17.0-blue.svg)](https://flutter.dev)

A highly customizable, performance-optimized auto-suggest/autocomplete widget for Flutter with Fluent UI design. Supports both **Fluent UI** and **Material Design** components.

## Features

- **Dual Design System** - Switch between Fluent UI and Material Design
- **Theme Extension** - Full theming support via `FluentAutoSuggestThemeData`
- **Smart Overlay Positioning** - Auto-shows above when space below < 300px
- **RTL Language Support** - Full right-to-left language support (Arabic, Hebrew, etc.)
- **Voice Search** - Speech-to-text integration for voice input
- **Grouped Suggestions** - Organize items into collapsible groups
- **Inline Suggestions** - Ghost text autocomplete as you type
- **Debounced Search** - Configurable delay to reduce API calls
- **LRU Caching** - Intelligent caching with TTL (Time To Live) expiration
- **Keyboard Navigation** - Full support for Arrow keys, Tab, Escape, and Enter
- **Form Validation** - Built-in validator support with AutovalidateMode
- **Server-Side Search** - Async search with `onNoResultsFound` callback
- **Loading & Error States** - Customizable loading and error handling
- **Custom Builders** - Full control over item rendering
- **Accessibility** - Semantic labels and screen reader support
- **Recent Searches** - Track and display search history
- **Advanced Search Dialog** - Full-featured search with filters and pagination
- **BLoC/Cubit Support** - State management integration
- **Performance Optimized** - Reduced rebuilds, efficient memory usage

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  auto_suggest_box: ^1.8.0
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

## RTL Language Support

Full support for right-to-left languages like Arabic, Hebrew, and Persian.

### RTL Theme

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      FluentAutoSuggestThemeData.rtl(), // Fluent UI RTL
      // or
      FluentAutoSuggestThemeData.materialRtl(), // Material RTL
    ],
  ),
)
```

### Custom RTL Configuration

```dart
FluentAutoSuggestThemeData(
  textDirection: TextDirection.rtl,
  rtlMirrorIcons: true,  // Mirror icons for RTL
  rtlMirrorLayout: true, // Mirror the entire layout
)
```

## Voice Search

Integrate speech-to-text for voice input.

### Using VoiceSearchController

```dart
final voiceController = VoiceSearchController(
  localeId: 'en_US', // or 'ar_SA' for Arabic
  onResult: (text, isFinal) {
    if (isFinal) {
      textController.text = text;
    }
  },
  onError: (error) {
    print('Voice error: $error');
  },
);

// Initialize
await voiceController.initialize();

// Start listening
await voiceController.startListening();

// Stop listening
await voiceController.stopListening();
```

### Voice Search Button

```dart
Row(
  children: [
    Expanded(
      child: FluentAutoSuggestBox<String>(
        items: items,
        controller: textController,
      ),
    ),
    VoiceSearchButton(
      controller: voiceController,
      activeColor: Colors.red,
      inactiveColor: Colors.grey,
    ),
  ],
)
```

## Grouped Suggestions

Organize suggestions into collapsible groups.

### Creating Groups

```dart
final groups = [
  SuggestionGroup<Product>(
    title: 'Recent',
    icon: FluentIcons.history,
    items: recentProducts,
    isExpanded: true,
  ),
  SuggestionGroup<Product>(
    title: 'Popular',
    icon: FluentIcons.favorite_star,
    items: popularProducts,
  ),
  SuggestionGroup<Product>(
    title: 'All Products',
    icon: FluentIcons.product,
    items: allProducts,
    showItemCount: true,
  ),
];
```

### Displaying Grouped Suggestions

```dart
GroupedSuggestionsOverlay<Product>(
  groups: groups,
  config: GroupedSuggestionsConfig(
    showGroupHeaders: true,
    collapsible: true,
    showDividers: true,
    stickyHeaders: false,
  ),
  onSelected: (item) {
    print('Selected: ${item.label}');
  },
)
```

### Grouping Items Automatically

```dart
// Group by first letter
final alphabeticalGroups = groupItemsAlphabetically(items);

// Group by custom key
final categoryGroups = groupItemsBy<Product, String>(
  items,
  (item) => item.value.category,
  titleBuilder: (category) => category.toUpperCase(),
  iconBuilder: (category) => categoryIcons[category],
);
```

## Inline Suggestions (Ghost Text)

Show autocomplete suggestions as ghost text while typing.

### Using InlineSuggestionTextField

```dart
InlineSuggestionTextField<Product>(
  items: products,
  config: InlineSuggestionConfig(
    ghostTextColor: Colors.grey,
    acceptOnTab: true,           // Tab to accept full suggestion
    partialAcceptOnArrowRight: true, // Right arrow to accept one word
  ),
  onSuggestionAccepted: (item) {
    print('Accepted: ${item.label}');
  },
)
```

### Using InlineSuggestionController

```dart
final suggestionController = InlineSuggestionController(
  acceptKey: LogicalKeyboardKey.tab,
  partialAcceptKey: LogicalKeyboardKey.arrowRight,
  caseSensitive: false,
);

// Update as user types
suggestionController.updateText(textController.text);

// Set suggestion from best match
suggestionController.setSuggestion(bestMatch.label);

// Accept full suggestion
final newText = suggestionController.acceptFull();

// Accept one word
final partialText = suggestionController.acceptWord();
```

## Theme Extension

Use `FluentAutoSuggestThemeData` to customize the appearance globally:

### Fluent UI Theme (Default)

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      FluentAutoSuggestThemeData.light(),
    ],
  ),
)
```

### Material Design Theme

```dart
MaterialApp(
  theme: ThemeData(
    extensions: [
      FluentAutoSuggestThemeData.material(isDark: false),
    ],
  ),
)
```

### Preset Themes

```dart
// Light theme (Fluent)
FluentAutoSuggestThemeData.light()

// Dark theme (Fluent)
FluentAutoSuggestThemeData.dark()

// Material Design theme
FluentAutoSuggestThemeData.material(isDark: false)

// RTL Fluent theme
FluentAutoSuggestThemeData.rtl(isDark: false)

// RTL Material theme
FluentAutoSuggestThemeData.materialRtl(isDark: false)
```

### Custom Theme

```dart
FluentAutoSuggestThemeData(
  // Design system
  designSystem: AutoSuggestDesignSystem.fluent, // or .material

  // Text field theming
  textFieldDecoration: InputDecoration(...),
  textFieldStyle: TextStyle(...),
  textFieldCursorColor: Colors.blue,
  textFieldFillColor: Colors.grey[100],
  textFieldBorderRadius: 8.0,

  // Overlay theming
  overlayBackgroundColor: Colors.white,
  overlayCardColor: Colors.white,
  overlayBorderRadius: 4.0,
  overlayShadows: [BoxShadow(...)],
  overlayElevation: 8.0,

  // Item theming
  itemBackgroundColor: Colors.transparent,
  itemSelectedBackgroundColor: Colors.blue.withOpacity(0.1),
  itemHoverBackgroundColor: Colors.grey.withOpacity(0.1),
  itemTextStyle: TextStyle(...),
  itemSelectedTextStyle: TextStyle(...),
  itemHeight: 48.0,

  // RTL support
  textDirection: TextDirection.rtl,
  rtlMirrorIcons: true,
  rtlMirrorLayout: true,

  // Loading state
  loadingIndicatorColor: Colors.blue,
  loadingTextStyle: TextStyle(...),

  // No results state
  noResultsTextStyle: TextStyle(...),
  noResultsIcon: Icons.search_off,
  noResultsIconColor: Colors.grey,

  // Icons
  iconColor: Colors.grey[600],
  clearButtonColor: Colors.grey[500],
  dropdownIconColor: Colors.grey[600],
)
```

## Smart Overlay Positioning

The overlay automatically positions itself based on available screen space:

- Shows **below** the text field by default
- Shows **above** when space below < 300px AND space above is larger
- When showing above, items are **reversed** so the first item appears at the bottom (closest to the text field)

```dart
FluentAutoSuggestBox<String>(
  items: items,
  direction: AutoSuggestBoxDirection.below, // Default, but auto-adjusts
  maxPopupHeight: 380.0,
)
```

## Cubit/BLoC State Management

### FluentAutoSuggestBoxCubit (Widget State Management)

```dart
final cubit = FluentAutoSuggestBoxCubit<Product>();

// Set items
cubit.setItems([
  FluentAutoSuggestBoxItem(value: product1, label: 'iPhone'),
  FluentAutoSuggestBoxItem(value: product2, label: 'Samsung'),
]);

// Add/Remove items
cubit.addItem(FluentAutoSuggestBoxItem(value: product3, label: 'Pixel'));
cubit.removeItem(item);

// Selection
cubit.selectItem(item);
cubit.selectByValue(product1);
cubit.selectByIndex(0);
cubit.clearSelection();

// State control
cubit.setLoading(true);
cubit.setError('Something went wrong');
cubit.setEnabled(false);
cubit.setReadOnly(true);

// Reset
cubit.reset();
cubit.clear();
```

### Using with BlocBuilder

```dart
BlocBuilder<FluentAutoSuggestBoxCubit<Product>, FluentAutoSuggestBoxState<Product>>(
  bloc: cubit,
  builder: (context, state) {
    return FluentAutoSuggestBox<Product>(
      items: state.items,
      enabled: state.isEnabled && !state.isLoading,
      onSelected: (item) {
        if (item != null) {
          cubit.selectItem(item);
        }
      },
    );
  },
)
```

### AutoSuggestCubit (Server Search)

```dart
final cubit = AutoSuggestCubit<Product>(
  provider: (query, {filters}) async {
    return await api.searchProducts(query, filters: filters);
  },
  cacheDuration: Duration(minutes: 5),
);

// Use with FluentAutoSuggestBox.cubit()
FluentAutoSuggestBox<Product>.cubit(
  cubit: cubit,
  cubitItemBuilder: (context, product, isSelected, onTap) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text(product.description),
      selected: isSelected,
      onPressed: onTap,
    );
  },
  labelBuilder: (product) => product.name,
  onCubitSelected: (product) {
    print('Selected: ${product.name}');
  },
)
```

## API Reference

### FluentAutoSuggestBox

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `items` | `List<FluentAutoSuggestBoxItem<T>>` | required | List of suggestion items |
| `controller` | `TextEditingController?` | null | Text controller for the input field |
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
| `direction` | `AutoSuggestBoxDirection` | below | Popup direction (auto-adjusts) |
| `validator` | `FormFieldValidator<String>?` | null | Form validation function |
| `autovalidateMode` | `AutovalidateMode` | disabled | Validation mode |

### FluentAutoSuggestBoxItem

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

### FluentAutoSuggestThemeData

| Property | Type | Description |
|----------|------|-------------|
| `designSystem` | `AutoSuggestDesignSystem` | fluent or material |
| `textDirection` | `TextDirection?` | ltr or rtl |
| `rtlMirrorIcons` | `bool` | Mirror icons in RTL mode |
| `rtlMirrorLayout` | `bool` | Mirror layout in RTL mode |
| `textFieldDecoration` | `InputDecoration?` | Text field decoration |
| `textFieldStyle` | `TextStyle?` | Text style for input |
| `overlayBackgroundColor` | `Color?` | Overlay background color |
| `overlayCardColor` | `Color?` | Overlay card color |
| `overlayBorderRadius` | `double?` | Overlay border radius |
| `itemSelectedBackgroundColor` | `Color?` | Selected item background |
| `itemHeight` | `double?` | Item height |
| `loadingIndicatorColor` | `Color?` | Loading indicator color |
| `clearButtonColor` | `Color?` | Clear button color |
| `dropdownIconColor` | `Color?` | Dropdown icon color |

## Keyboard Navigation

| Key | Action |
|-----|--------|
| `Arrow Down` | Select next item |
| `Arrow Up` | Select previous item |
| `Enter` | Confirm selection |
| `Tab` | Accept inline suggestion / Move to next field |
| `Shift+Tab` | Move to previous field |
| `Escape` | Close suggestions / Dismiss inline suggestion |
| `Right Arrow` | Accept one word of inline suggestion |
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

## Requirements

- Flutter >= 1.17.0
- Dart SDK >= 3.10.3

## Dependencies

- [fluent_ui](https://pub.dev/packages/fluent_ui) ^4.13.0
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) ^8.1.6
- [equatable](https://pub.dev/packages/equatable) ^2.0.5
- [gap](https://pub.dev/packages/gap) ^3.0.1
- [speech_to_text](https://pub.dev/packages/speech_to_text) ^7.0.0

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

## Roadmap

- [x] Cubit/BLoC state management integration
- [x] Theme extension support
- [x] Material Design components support
- [x] Smart overlay positioning
- [x] RTL language support
- [x] Voice search support
- [x] Grouped suggestions
- [x] Inline suggestions (ghost text)
- [ ] Pagination support for large datasets

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this package helpful, please give it a star on GitHub!
