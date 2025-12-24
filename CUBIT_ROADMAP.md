# Cubit/BLoC Integration Roadmap

This document outlines the plan for integrating Cubit/BLoC state management into `auto_suggest_box`, following the approach used by [smart_pagination](https://pub.dev/packages/smart_pagination).

## Overview

The goal is to provide a low-level `AutoSuggestCubit<T>` that developers can use directly for advanced state management, while keeping the widget layer optional.

## Proposed Architecture

### 1. State Classes

```dart
/// Base state for auto suggest
sealed class AutoSuggestState<T> {
  const AutoSuggestState();
}

/// Initial state before any search
class AutoSuggestInitial<T> extends AutoSuggestState<T> {
  const AutoSuggestInitial();
}

/// Loading state during search
class AutoSuggestLoading<T> extends AutoSuggestState<T> {
  final String query;
  final List<T>? previousItems;

  const AutoSuggestLoading({
    required this.query,
    this.previousItems,
  });
}

/// Loaded state with results
class AutoSuggestLoaded<T> extends AutoSuggestState<T> {
  final List<T> items;
  final String query;
  final bool hasMoreResults;
  final DateTime fetchedAt;
  final Duration? cacheExpiry;

  const AutoSuggestLoaded({
    required this.items,
    required this.query,
    this.hasMoreResults = false,
    required this.fetchedAt,
    this.cacheExpiry,
  });

  bool get isCacheValid {
    if (cacheExpiry == null) return true;
    return DateTime.now().difference(fetchedAt) < cacheExpiry!;
  }
}

/// Error state
class AutoSuggestError<T> extends AutoSuggestState<T> {
  final Object error;
  final StackTrace? stackTrace;
  final String query;
  final List<T>? previousItems;

  const AutoSuggestError({
    required this.error,
    this.stackTrace,
    required this.query,
    this.previousItems,
  });
}
```

### 2. AutoSuggestCubit

```dart
import 'package:flutter_bloc/flutter_bloc.dart';

/// Configuration for AutoSuggestCubit
class AutoSuggestConfig {
  final Duration debounceDelay;
  final int minSearchLength;
  final Duration? cacheDuration;
  final int maxCacheSize;
  final bool enablePrefixMatching;
  final RetryConfig? retryConfig;

  const AutoSuggestConfig({
    this.debounceDelay = const Duration(milliseconds: 300),
    this.minSearchLength = 2,
    this.cacheDuration = const Duration(minutes: 30),
    this.maxCacheSize = 100,
    this.enablePrefixMatching = true,
    this.retryConfig,
  });
}

/// Retry configuration
class RetryConfig {
  final int maxRetries;
  final Duration initialDelay;
  final double backoffMultiplier;

  const RetryConfig({
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffMultiplier = 2.0,
  });
}

/// Provider function type
typedef AutoSuggestProvider<T> = Future<List<T>> Function(
  String query,
  Map<String, dynamic>? filters,
);

/// Main Cubit for auto suggest functionality
class AutoSuggestCubit<T> extends Cubit<AutoSuggestState<T>> {
  final AutoSuggestProvider<T> provider;
  final AutoSuggestConfig config;

  Timer? _debounceTimer;
  final SearchResultsCache<T> _cache;

  AutoSuggestCubit({
    required this.provider,
    this.config = const AutoSuggestConfig(),
  }) : _cache = SearchResultsCache<T>(
         maxSize: config.maxCacheSize,
         maxAge: config.cacheDuration ?? const Duration(minutes: 30),
         enablePrefixMatching: config.enablePrefixMatching,
       ),
       super(const AutoSuggestInitial());

  /// Search with debouncing
  void search(String query, {Map<String, dynamic>? filters}) {
    _debounceTimer?.cancel();

    if (query.length < config.minSearchLength) {
      emit(const AutoSuggestInitial());
      return;
    }

    _debounceTimer = Timer(config.debounceDelay, () {
      _performSearch(query, filters: filters);
    });
  }

  /// Immediate search without debouncing
  Future<void> searchImmediate(
    String query, {
    Map<String, dynamic>? filters,
  }) async {
    _debounceTimer?.cancel();
    await _performSearch(query, filters: filters);
  }

  Future<void> _performSearch(
    String query, {
    Map<String, dynamic>? filters,
  }) async {
    // Check cache first
    final cached = _cache.get(query);
    if (cached != null) {
      emit(AutoSuggestLoaded(
        items: cached,
        query: query,
        fetchedAt: DateTime.now(),
        cacheExpiry: config.cacheDuration,
      ));
      return;
    }

    // Get previous items for smooth transition
    final previousItems = state is AutoSuggestLoaded<T>
        ? (state as AutoSuggestLoaded<T>).items
        : null;

    emit(AutoSuggestLoading(query: query, previousItems: previousItems));

    try {
      final results = await _executeWithRetry(
        () => provider(query, filters),
      );

      _cache.set(query, results);

      emit(AutoSuggestLoaded(
        items: results,
        query: query,
        fetchedAt: DateTime.now(),
        cacheExpiry: config.cacheDuration,
      ));
    } catch (error, stackTrace) {
      emit(AutoSuggestError(
        error: error,
        stackTrace: stackTrace,
        query: query,
        previousItems: previousItems,
      ));
    }
  }

  Future<List<T>> _executeWithRetry(
    Future<List<T>> Function() operation,
  ) async {
    final retryConfig = config.retryConfig;
    if (retryConfig == null) {
      return operation();
    }

    var lastError;
    var delay = retryConfig.initialDelay;

    for (var i = 0; i <= retryConfig.maxRetries; i++) {
      try {
        return await operation();
      } catch (e) {
        lastError = e;
        if (i < retryConfig.maxRetries) {
          await Future.delayed(delay);
          delay *= retryConfig.backoffMultiplier.toInt();
        }
      }
    }

    throw lastError;
  }

  /// Clear search and reset to initial state
  void clear() {
    _debounceTimer?.cancel();
    emit(const AutoSuggestInitial());
  }

  /// Clear cache
  void clearCache() {
    _cache.clear();
  }

  /// Get cache statistics
  CacheStats getCacheStats() => _cache.getStats();

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
```

### 3. Widget Integration

```dart
/// Widget that uses AutoSuggestCubit
class BlocAutoSuggestBox<T> extends StatelessWidget {
  final AutoSuggestCubit<T> cubit;
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget Function(BuildContext)? loadingBuilder;
  final Widget Function(BuildContext, Object)? errorBuilder;
  final Widget Function(BuildContext)? emptyBuilder;
  final void Function(T)? onSelected;
  final InputDecoration? decoration;

  const BlocAutoSuggestBox({
    super.key,
    required this.cubit,
    required this.itemBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.onSelected,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AutoSuggestCubit<T>, AutoSuggestState<T>>(
      bloc: cubit,
      builder: (context, state) {
        return Column(
          children: [
            TextField(
              onChanged: (query) => cubit.search(query),
              decoration: decoration,
            ),
            _buildResults(context, state),
          ],
        );
      },
    );
  }

  Widget _buildResults(BuildContext context, AutoSuggestState<T> state) {
    return switch (state) {
      AutoSuggestInitial() => const SizedBox.shrink(),
      AutoSuggestLoading(:final previousItems) =>
        loadingBuilder?.call(context) ??
        _buildPreviousItemsWithLoading(previousItems),
      AutoSuggestLoaded(:final items) when items.isEmpty =>
        emptyBuilder?.call(context) ?? const Text('No results'),
      AutoSuggestLoaded(:final items) =>
        _buildItemsList(context, items),
      AutoSuggestError(:final error, :final previousItems) =>
        errorBuilder?.call(context, error) ??
        Text('Error: $error'),
    };
  }

  Widget _buildItemsList(BuildContext context, List<T> items) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => onSelected?.call(item),
          child: itemBuilder(context, item),
        );
      },
    );
  }

  Widget _buildPreviousItemsWithLoading(List<T>? previousItems) {
    // Show previous items with loading indicator
    return const CircularProgressIndicator();
  }
}
```

## Implementation Plan

### Phase 1: Core Cubit (v0.1.1)
1. Create `AutoSuggestState` sealed class hierarchy
2. Implement `AutoSuggestCubit` with basic functionality
3. Add debouncing and caching integration
4. Add retry mechanism with exponential backoff
5. Write unit tests for cubit

### Phase 2: Widget Integration (v0.2.0)
1. Create `BlocAutoSuggestBox` widget
2. Add `BlocProvider` integration
3. Create `AutoSuggestBlocBuilder` convenience widget
4. Add animation support for state transitions
5. Write widget tests

### Phase 3: Advanced Features (v0.3.0)
1. Add pagination support (like smart_pagination)
2. Add real-time stream support
3. Add filters integration
4. Add multi-select with cubit
5. Performance optimizations

## File Structure

```
lib/
├── bloc/
│   ├── auto_suggest_bloc.dart
│   ├── auto_suggest_cubit.dart
│   ├── auto_suggest_state.dart
│   ├── auto_suggest_event.dart  (for Bloc)
│   └── bloc.dart                 (exports)
├── widgets/
│   ├── bloc_auto_suggest_box.dart
│   ├── auto_suggest_bloc_builder.dart
│   └── widgets.dart              (exports)
└── auto_suggest_box.dart         (main export)
```

## Dependencies to Add

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5  # For state equality
```

## Usage Example

```dart
// Create cubit
final cubit = AutoSuggestCubit<Product>(
  provider: (query, filters) async {
    return await api.searchProducts(query);
  },
  config: AutoSuggestConfig(
    debounceDelay: Duration(milliseconds: 300),
    cacheDuration: Duration(minutes: 15),
    retryConfig: RetryConfig(maxRetries: 3),
  ),
);

// Use in widget
BlocAutoSuggestBox<Product>(
  cubit: cubit,
  itemBuilder: (context, product) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text('\$${product.price}'),
    );
  },
  onSelected: (product) {
    // Handle selection
  },
);

// Or use with BlocBuilder directly
BlocBuilder<AutoSuggestCubit<Product>, AutoSuggestState<Product>>(
  bloc: cubit,
  builder: (context, state) {
    return switch (state) {
      AutoSuggestInitial() => Text('Start typing...'),
      AutoSuggestLoading() => CircularProgressIndicator(),
      AutoSuggestLoaded(:final items) => ListView(...),
      AutoSuggestError(:final error) => Text('Error: $error'),
    };
  },
);
```

## Comparison with smart_pagination

| Feature | smart_pagination | auto_suggest_box (planned) |
|---------|-----------------|---------------------------|
| Cubit support | Yes | Yes (v0.1.1) |
| Bloc support | Yes | Yes (v0.1.1) |
| Debouncing | Manual | Built-in |
| Caching | No | Yes (LRU with TTL) |
| Retry logic | Yes | Yes |
| Pagination | Yes | Planned (v0.3.0) |
| State types | 3 | 4 (with Error) |
| Widget | SmartPagination | BlocAutoSuggestBox |

## Notes

- The Cubit will be optional - existing widgets will continue to work with `AutoSuggestController`
- Both approaches will share the same cache implementation
- Migration guide will be provided for users who want to switch to Cubit
