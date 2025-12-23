# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2024-01-01

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

### Dependencies
- fluent_ui: ^4.13.0 - Fluent UI design system
- gap: ^3.0.1 - Spacing utilities

---

## Future Releases

### [0.1.0] - Planned

#### Planned Features
- Cubit/BLoC state management integration
- `AutoSuggestCubit<T>` for bloc-based state management
- `AutoSuggestState` classes (Initial, Loading, Loaded, Error)
- Integration with existing bloc patterns
- RTL language improvements
- Voice search support
- Grouped suggestions
- Inline suggestions (ghost text)

---

## Migration Guides

### From 0.0.x to 0.1.0

_Migration guide will be added when 0.1.0 is released._
