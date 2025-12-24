# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.3] - 2024-12-24

### Changed

#### Library Structure
- **Refactored to pub.dev style**: Converted `part` files to standalone files with proper imports/exports
- Improved modularity with separate files for each component:
  - `auto_suggest_item.dart` - Item model and tile widget
  - `auto_suggest_cache.dart` - LRU cache implementation
  - `auto_suggest_controller.dart` - State management controller
  - `auto_suggest_overlay.dart` - Overlay widget for suggestions
  - `auto_suggest_theme.dart` - Theme extension for customization

### Fixed

#### Overlay Improvements
- **Smart overlay positioning**: Automatically shows overlay above when space below < 300px and space above is larger
- **Empty results display**: Shows "No results found" when server search returns empty instead of stuck on "Searching..."
- **Reversed items order for above overlay**: When showing overlay above, items are now reversed so the first item appears at the bottom (closest to the text field)

### Added

#### FluentAutoSuggestThemeData (Theme Extension)
- New `FluentAutoSuggestThemeData` extending `ThemeExtension` for comprehensive theming
- `AutoSuggestDesignSystem` enum to switch between Fluent and Material design
- Text field theming: decoration, style, cursor color/width/height/radius, fill color, border radius
- Overlay theming: background color, card color, border radius, shadows, elevation
- Item theming: background colors (normal/selected/hover), text styles, padding, height
- Loading state theming: indicator color, text style
- No results theming: text styles, icon, icon color
- General theming: icon color, clear button color, dropdown icon color
- Preset themes: `light()`, `dark()`, `material()`

#### Material Components Support
- Support for Material Design components (TextField, TextFormField)
- Set `designSystem: AutoSuggestDesignSystem.material` in theme to use Material components
- Automatic switching between Fluent and Material loading indicators
- Material-styled clear button with InkWell ripple effect

#### FluentAutoSuggestBoxCubit (Widget State Management)
- New `FluentAutoSuggestBoxCubit<T>` for simple widget state management
- `FluentAutoSuggestBoxState<T>` with full state tracking:
  - `items` - List of suggestion items
  - `selectedItem` - Currently selected item
  - `text` - Current input text
  - `isLoading` / `error` - Loading and error states
  - `isEnabled` / `isReadOnly` - Widget states
- Item management: `setItems`, `addItem`, `addItems`, `removeItem`, `clearItems`
- Selection: `selectItem`, `selectByValue`, `selectByIndex`, `clearSelection`
- State control: `setLoading`, `setError`, `clearError`, `setEnabled`, `setReadOnly`
- Helpers: `reset`, `clear`, `search`, `getItemAt`, `getItemByValue`

---

## [0.1.2] - 2024-12-23

### Added
- Initial BLoC/Cubit integration with `FluentAutoSuggestBox.cubit()` constructor

---

## [0.1.1] - 2024-12-23

### Fixed
- Minor bug fixes and improvements

---

## [0.1.0] - 2024-12-23

### Added

#### Core Widget - FluentAutoSuggestBox
- `FluentAutoSuggestBox<T>` - Main autocomplete widget with generic type support
- `FluentAutoSuggestBox.form()` - Form-enabled constructor with validation support
- Debounced search with configurable delay (default: 300ms)
- Minimum search length requirement to prevent unnecessary searches
- Custom item builders for full control over suggestion rendering
- Custom sorter function for controlling match logic
- Loading and error state builders
- Overlay direction control (above/below)
- Clear button toggle
- Keyboard type and input formatters support

#### State Management - AutoSuggestController
- `AutoSuggestController<T>` - Centralized state management
- Debounce timer management
- Loading/error state tracking
- Overlay visibility control
- Recent searches history with configurable limit
- Search metrics and statistics (success rate, total searches)
- `getStats()` method for performance monitoring
- Proper disposal and cleanup

#### Caching System - SearchResultsCache
- `SearchResultsCache<T>` - LRU cache implementation
- Time-To-Live (TTL) expiration for cached entries
- Automatic LRU eviction when cache is full
- Prefix matching for better cache hit rates
- Cache statistics (hit rate, size, evictions)
- `CacheStats` class for detailed metrics

#### Item Model - FluentAutoSuggestBoxItem
- Generic type support for any data model
- Label and custom child widget support
- Subtitle widget for additional information
- Selection state tracking
- Focus change callbacks
- Semantic labels for accessibility
- Enabled/disabled state

#### Overlay System - AutoSuggestOverlay
- Smooth overlay positioning with CompositedTransformFollower
- Race condition prevention for async searches
- Automatic scroll to selected item
- Loading indicator during server search
- Empty state with helpful message
- Bidirectional display support

#### Keyboard Navigation
- Arrow Up/Down for item selection
- Enter to confirm selection
- Escape to close overlay
- Tab/Shift+Tab for focus navigation
- Keyboard shortcuts for advanced search

#### Advanced Search Dialog
- `AdvancedSearchDialog<T>` - Full-featured search dialog
- `AdvancedSearchDialog.show()` - Single selection mode
- `AdvancedSearchDialog.showMultiSelect()` - Multi-selection mode
- Three view modes: List, Grid, Compact
- Custom filter builder support
- Search statistics display
- Pagination support
- Custom animations with configurable duration and curves
- Keyboard shortcut trigger (default: F3)

#### Configuration Classes
- `AdvancedSearchConfig` - Main dialog configuration
- `AdvancedSearchTheme` - Visual theming (colors, spacing, radius)
- `AdvancedSearchIcons` - Icon customization
- `AdvancedSearchLayout` - Layout dimensions
- `AdvancedSearchAnimation` - Animation settings

#### Common Utilities
- `FluentTextField` - Fluent-styled text field wrapper
- `FluentTextFormField` - Form field with validation support
- `ValidatorFormField` - Custom form field with error display

#### Performance Optimizations
- Reduced widget rebuilds (only when necessary)
- Efficient memory usage with proper disposal
- Smart caching with prefix matching
- Debouncing to minimize API calls
- Race condition prevention for async operations

#### Accessibility
- Semantic labels throughout
- Screen reader support
- Proper focus management
- ARIA-like attributes

#### BLoC/Cubit State Management
- `AutoSuggestCubit<T>` - Cubit for server-side search with caching
- `AutoSuggestState<T>` - State classes for search states
- Cache integration with configurable TTL

### Dependencies
- fluent_ui: ^4.13.0 - Fluent UI design system
- flutter_bloc: ^8.1.6 - BLoC state management
- equatable: ^2.0.5 - Value equality for states
- gap: ^3.0.1 - Spacing utilities

---

## Future Releases

### [0.2.0] - Planned

#### Planned Features
- Pagination support for large datasets
- RTL language improvements
- Voice search support
- Grouped suggestions
- Inline suggestions (ghost text)
