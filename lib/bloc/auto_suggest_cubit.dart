import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auto_suggest_state.dart';

/// Configuration for retry behavior
class RetryConfig {
  /// Maximum number of retry attempts
  final int maxRetries;

  /// Initial delay before first retry
  final Duration initialDelay;

  /// Multiplier for exponential backoff
  final double backoffMultiplier;

  /// Maximum delay between retries
  final Duration maxDelay;

  const RetryConfig({
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffMultiplier = 2.0,
    this.maxDelay = const Duration(seconds: 30),
  });
}

/// Configuration for AutoSuggestCubit
///
/// Similar to SmartPagination configuration, this controls the behavior
/// of the auto-suggest cubit including debouncing, caching, and retry logic.
class AutoSuggestConfig {
  /// Delay before executing search after user stops typing
  final Duration debounceDelay;

  /// Minimum number of characters required to trigger search
  final int minSearchLength;

  /// How long to cache results (null for no expiry)
  final Duration? dataAge;

  /// Maximum number of items to cache
  final int maxCacheSize;

  /// Whether to use prefix matching for cache lookups
  final bool enablePrefixMatching;

  /// Retry configuration for failed requests
  final RetryConfig? retryConfig;

  /// Whether to emit loading state for cached results
  final bool showLoadingForCache;

  /// Whether to keep previous results while loading
  final bool keepPreviousOnLoading;

  const AutoSuggestConfig({
    this.debounceDelay = const Duration(milliseconds: 300),
    this.minSearchLength = 2,
    this.dataAge = const Duration(minutes: 30),
    this.maxCacheSize = 100,
    this.enablePrefixMatching = true,
    this.retryConfig,
    this.showLoadingForCache = false,
    this.keepPreviousOnLoading = true,
  });

  AutoSuggestConfig copyWith({
    Duration? debounceDelay,
    int? minSearchLength,
    Duration? dataAge,
    int? maxCacheSize,
    bool? enablePrefixMatching,
    RetryConfig? retryConfig,
    bool? showLoadingForCache,
    bool? keepPreviousOnLoading,
  }) {
    return AutoSuggestConfig(
      debounceDelay: debounceDelay ?? this.debounceDelay,
      minSearchLength: minSearchLength ?? this.minSearchLength,
      dataAge: dataAge ?? this.dataAge,
      maxCacheSize: maxCacheSize ?? this.maxCacheSize,
      enablePrefixMatching: enablePrefixMatching ?? this.enablePrefixMatching,
      retryConfig: retryConfig ?? this.retryConfig,
      showLoadingForCache: showLoadingForCache ?? this.showLoadingForCache,
      keepPreviousOnLoading:
          keepPreviousOnLoading ?? this.keepPreviousOnLoading,
    );
  }
}

/// Provider function type for fetching search results
///
/// Takes a query string and optional filters, returns a list of results.
typedef AutoSuggestProvider<T> = Future<List<T>> Function(
  String query, {
  Map<String, dynamic>? filters,
});

/// Cache entry for storing search results
class _CacheEntry<T> {
  final List<T> items;
  final DateTime fetchedAt;
  final DateTime? expiresAt;
  int accessCount;

  _CacheEntry({
    required this.items,
    required this.fetchedAt,
    this.expiresAt,
    this.accessCount = 0,
  });

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }
}

/// AutoSuggestCubit - BLoC-based state management for auto-suggest
///
/// Similar to SmartPaginationCubit, this cubit handles:
/// - Debounced search to reduce API calls
/// - LRU caching with TTL expiration
/// - Retry with exponential backoff
/// - Loading and error states
///
/// Example usage:
/// ```dart
/// final cubit = AutoSuggestCubit<Product>(
///   provider: (query, {filters}) async {
///     return await api.searchProducts(query);
///   },
///   config: AutoSuggestConfig(
///     debounceDelay: Duration(milliseconds: 300),
///     dataAge: Duration(minutes: 15),
///   ),
/// );
///
/// // Use with BlocBuilder
/// BlocBuilder<AutoSuggestCubit<Product>, AutoSuggestState<Product>>(
///   bloc: cubit,
///   builder: (context, state) {
///     return switch (state) {
///       AutoSuggestInitial() => Text('Start typing...'),
///       AutoSuggestLoading(:final previousItems) => // show loading,
///       AutoSuggestLoaded(:final items) => // show items,
///       AutoSuggestError(:final error) => // show error,
///       AutoSuggestEmpty() => Text('No results'),
///     };
///   },
/// );
/// ```
class AutoSuggestCubit<T> extends Cubit<AutoSuggestState<T>> {
  /// The provider function for fetching results
  final AutoSuggestProvider<T> provider;

  /// Configuration options
  final AutoSuggestConfig config;

  /// Debounce timer
  Timer? _debounceTimer;

  /// Cache for search results
  final Map<String, _CacheEntry<T>> _cache = {};

  /// Current query being processed
  String? _currentQuery;

  /// Filters for search
  Map<String, dynamic>? _currentFilters;

  /// Statistics tracking
  int _totalSearches = 0;
  int _cacheHits = 0;
  int _cacheMisses = 0;
  int _errors = 0;

  AutoSuggestCubit({
    required this.provider,
    this.config = const AutoSuggestConfig(),
  }) : super(const AutoSuggestInitial());

  // ============== Public Getters ==============

  /// Get the current query
  String? get currentQuery => _currentQuery;

  /// Get current filters
  Map<String, dynamic>? get currentFilters => _currentFilters;

  /// Get last fetch time (if loaded)
  DateTime? get lastFetchTime {
    final state = this.state;
    if (state is AutoSuggestLoaded<T>) {
      return state.fetchedAt;
    }
    return null;
  }

  /// Check if data is expired
  bool get isDataExpired {
    final state = this.state;
    if (state is AutoSuggestLoaded<T>) {
      return state.isDataExpired;
    }
    return false;
  }

  /// Get data age (if loaded)
  Duration? get dataAge {
    final state = this.state;
    if (state is AutoSuggestLoaded<T>) {
      return state.dataAge;
    }
    return null;
  }

  /// Get cache size
  int get cacheSize => _cache.length;

  /// Get cache hit rate
  double get cacheHitRate {
    final total = _cacheHits + _cacheMisses;
    if (total == 0) return 0.0;
    return _cacheHits / total;
  }

  /// Get statistics
  Map<String, dynamic> get stats => {
        'totalSearches': _totalSearches,
        'cacheHits': _cacheHits,
        'cacheMisses': _cacheMisses,
        'cacheHitRate': cacheHitRate,
        'cacheSize': cacheSize,
        'errors': _errors,
      };

  // ============== Public Methods ==============

  /// Search with debouncing
  ///
  /// This is the main method to call when user types in the search box.
  /// It will debounce the input and only execute the search after
  /// the configured delay.
  void search(String query, {Map<String, dynamic>? filters}) {
    _debounceTimer?.cancel();

    // Store current query and filters
    _currentQuery = query;
    _currentFilters = filters;

    // Check minimum length
    if (query.length < config.minSearchLength) {
      emit(const AutoSuggestInitial());
      return;
    }

    // Check cache first (without loading state for instant response)
    final cached = _getFromCache(query);
    if (cached != null && !config.showLoadingForCache) {
      _cacheHits++;
      emit(AutoSuggestLoaded<T>(
        items: cached.items,
        query: query,
        fetchedAt: cached.fetchedAt,
        dataExpiredAt: cached.expiresAt,
      ));
      return;
    }

    // Set up debounce
    _debounceTimer = Timer(config.debounceDelay, () {
      _executeSearch(query, filters: filters);
    });
  }

  /// Search immediately without debouncing
  ///
  /// Use this when you want to execute a search right away,
  /// for example when pressing Enter or clicking a search button.
  Future<void> searchImmediate(
    String query, {
    Map<String, dynamic>? filters,
  }) async {
    _debounceTimer?.cancel();
    _currentQuery = query;
    _currentFilters = filters;

    if (query.length < config.minSearchLength) {
      emit(const AutoSuggestInitial());
      return;
    }

    await _executeSearch(query, filters: filters);
  }

  /// Refresh current search
  ///
  /// Re-executes the last search, bypassing the cache.
  Future<void> refresh() async {
    if (_currentQuery == null) return;

    // Remove from cache to force refresh
    _removeFromCache(_currentQuery!);

    await _executeSearch(
      _currentQuery!,
      filters: _currentFilters,
    );
  }

  /// Check and reset if data is expired
  ///
  /// Similar to SmartPaginationCubit, this checks if the current
  /// data has expired and refreshes if necessary.
  Future<void> checkAndRefreshIfExpired() async {
    if (isDataExpired && _currentQuery != null) {
      await refresh();
    }
  }

  /// Clear the search and reset to initial state
  void clear() {
    _debounceTimer?.cancel();
    _currentQuery = null;
    _currentFilters = null;
    emit(const AutoSuggestInitial());
  }

  /// Clear the cache
  void clearCache() {
    _cache.clear();
  }

  /// Reset statistics
  void resetStats() {
    _totalSearches = 0;
    _cacheHits = 0;
    _cacheMisses = 0;
    _errors = 0;
  }

  /// Update items in the current state
  ///
  /// Useful for optimistic updates or local modifications.
  void updateItems(List<T> Function(List<T>) updater) {
    final state = this.state;
    if (state is AutoSuggestLoaded<T>) {
      emit(state.copyWith(items: updater(state.items)));
    }
  }

  // ============== Private Methods ==============

  Future<void> _executeSearch(
    String query, {
    Map<String, dynamic>? filters,
  }) async {
    _totalSearches++;

    // Check cache
    final cached = _getFromCache(query);
    if (cached != null) {
      _cacheHits++;
      emit(AutoSuggestLoaded<T>(
        items: cached.items,
        query: query,
        fetchedAt: cached.fetchedAt,
        dataExpiredAt: cached.expiresAt,
      ));
      return;
    }

    _cacheMisses++;

    // Get previous items for smooth transition
    List<T>? previousItems;
    if (config.keepPreviousOnLoading) {
      final state = this.state;
      if (state is AutoSuggestLoaded<T>) {
        previousItems = state.items;
      }
    }

    // Emit loading state
    emit(AutoSuggestLoading<T>(
      query: query,
      previousItems: previousItems,
    ));

    try {
      // Execute with optional retry
      final results = await _executeWithRetry(
        () => provider(query, filters: filters),
      );

      // Check if query is still current (race condition prevention)
      if (_currentQuery != query) return;

      // Handle empty results
      if (results.isEmpty) {
        emit(AutoSuggestEmpty<T>(
          query: query,
          searchedAt: DateTime.now(),
        ));
        return;
      }

      // Cache the results
      _addToCache(query, results);

      // Emit loaded state
      final now = DateTime.now();
      emit(AutoSuggestLoaded<T>(
        items: results,
        query: query,
        fetchedAt: now,
        dataExpiredAt:
            config.dataAge != null ? now.add(config.dataAge!) : null,
      ));
    } catch (error, stackTrace) {
      _errors++;

      // Check if query is still current
      if (_currentQuery != query) return;

      emit(AutoSuggestError<T>(
        error: error,
        stackTrace: stackTrace,
        query: query,
        previousItems: previousItems,
      ));
    }
  }

  Future<List<T>> _executeWithRetry(Future<List<T>> Function() operation) async {
    final retryConfig = config.retryConfig;
    if (retryConfig == null) {
      return operation();
    }

    Object? lastError;
    var delay = retryConfig.initialDelay;

    for (var i = 0; i <= retryConfig.maxRetries; i++) {
      try {
        return await operation();
      } catch (e) {
        lastError = e;
        if (i < retryConfig.maxRetries) {
          await Future.delayed(delay);
          delay = Duration(
            milliseconds:
                (delay.inMilliseconds * retryConfig.backoffMultiplier).toInt(),
          );
          if (delay > retryConfig.maxDelay) {
            delay = retryConfig.maxDelay;
          }
        }
      }
    }

    throw lastError!;
  }

  _CacheEntry<T>? _getFromCache(String query) {
    final normalizedQuery = query.trim().toLowerCase();

    // Direct match
    final entry = _cache[normalizedQuery];
    if (entry != null && !entry.isExpired) {
      entry.accessCount++;
      return entry;
    }

    // Remove expired entry
    if (entry != null && entry.isExpired) {
      _cache.remove(normalizedQuery);
    }

    // Prefix matching
    if (config.enablePrefixMatching && normalizedQuery.length >= 3) {
      for (final key in _cache.keys.toList().reversed) {
        if (normalizedQuery.startsWith(key)) {
          final prefixEntry = _cache[key];
          if (prefixEntry != null && !prefixEntry.isExpired) {
            prefixEntry.accessCount++;
            return prefixEntry;
          }
        }
      }
    }

    return null;
  }

  void _addToCache(String query, List<T> items) {
    final normalizedQuery = query.trim().toLowerCase();

    // Evict if cache is full
    if (_cache.length >= config.maxCacheSize) {
      _evictLeastRecentlyUsed();
    }

    final now = DateTime.now();
    _cache[normalizedQuery] = _CacheEntry<T>(
      items: List.unmodifiable(items),
      fetchedAt: now,
      expiresAt: config.dataAge != null ? now.add(config.dataAge!) : null,
    );
  }

  void _removeFromCache(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    _cache.remove(normalizedQuery);
  }

  void _evictLeastRecentlyUsed() {
    if (_cache.isEmpty) return;

    String? oldestKey;
    int lowestAccess = -1;

    for (final entry in _cache.entries) {
      if (lowestAccess == -1 || entry.value.accessCount < lowestAccess) {
        lowestAccess = entry.value.accessCount;
        oldestKey = entry.key;
      }
    }

    if (oldestKey != null) {
      _cache.remove(oldestKey);
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
