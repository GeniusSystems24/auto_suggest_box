part of 'auto_suggest.dart';

/// Cache for storing search results with LRU eviction policy
///
/// Features:
/// - Automatic expiration of old entries
/// - LRU (Least Recently Used) eviction policy
/// - Hit/miss tracking for performance monitoring
/// - Prefix matching for better cache utilization
/// - Memory-efficient storage
class SearchResultsCache<T> {
  SearchResultsCache({
    this.maxSize = 100,
    this.maxAge = const Duration(minutes: 30),
    this.enablePrefixMatching = true,
  });

  final int maxSize;
  final Duration maxAge;
  final bool enablePrefixMatching;

  final _cache = <String, _CacheEntry<T>>{};

  // Cache metrics
  int _hits = 0;
  int _misses = 0;
  int _evictions = 0;

  /// Get cache hit rate (0.0 to 1.0)
  double get hitRate {
    final total = _hits + _misses;
    if (total == 0) return 0.0;
    return _hits / total;
  }

  int get hits => _hits;
  int get misses => _misses;
  int get evictions => _evictions;
  int get size => _cache.length;

  /// Get cached results for a query
  List<T>? get(String query) {
    final normalizedQuery = _normalizeQuery(query);

    // Direct match
    final entry = _cache[normalizedQuery];

    if (entry != null) {
      // Check if entry is expired
      if (DateTime.now().difference(entry.timestamp) > maxAge) {
        _cache.remove(normalizedQuery);
        _misses++;
        return null;
      }

      // Update access time and move to end (most recently used)
      entry.lastAccessed = DateTime.now();
      entry.accessCount++;
      _cache.remove(normalizedQuery);
      _cache[normalizedQuery] = entry;

      _hits++;
      return List<T>.from(entry.results); // Return copy to prevent modification
    }

    // Try prefix matching if enabled
    if (enablePrefixMatching && normalizedQuery.length >= 3) {
      final prefixEntry = _findPrefixMatch(normalizedQuery);
      if (prefixEntry != null) {
        _hits++;
        return List<T>.from(prefixEntry.results);
      }
    }

    _misses++;
    return null;
  }

  /// Find a cached entry that could be used as a prefix match
  _CacheEntry<T>? _findPrefixMatch(String query) {
    for (final key in _cache.keys.toList().reversed) {
      if (query.startsWith(key) && key.length >= 2) {
        final entry = _cache[key];
        if (entry != null && DateTime.now().difference(entry.timestamp) <= maxAge) {
          return entry;
        }
      }
    }
    return null;
  }

  /// Store results in cache
  void set(String query, List<T> results) {
    final normalizedQuery = _normalizeQuery(query);

    // Remove oldest entry if cache is full
    if (_cache.length >= maxSize && !_cache.containsKey(normalizedQuery)) {
      _evictLeastRecentlyUsed();
      _evictions++;
    }

    _cache[normalizedQuery] = _CacheEntry(
      results: List<T>.from(results), // Store copy to prevent external modification
      timestamp: DateTime.now(),
      lastAccessed: DateTime.now(),
      accessCount: 0,
    );
  }

  /// Evict the least recently used entry
  void _evictLeastRecentlyUsed() {
    if (_cache.isEmpty) return;

    // Find entry with oldest last accessed time
    String? oldestKey;
    DateTime? oldestTime;

    for (final entry in _cache.entries) {
      if (oldestTime == null || entry.value.lastAccessed.isBefore(oldestTime)) {
        oldestTime = entry.value.lastAccessed;
        oldestKey = entry.key;
      }
    }

    if (oldestKey != null) {
      _cache.remove(oldestKey);
    }
  }

  /// Check if query is in cache and valid
  bool contains(String query) {
    return get(query) != null;
  }

  /// Clear all cache
  void clear() {
    _cache.clear();
    _hits = 0;
    _misses = 0;
    _evictions = 0;
  }

  /// Remove expired entries
  void cleanExpired() {
    final now = DateTime.now();
    final keysToRemove = <String>[];

    for (final entry in _cache.entries) {
      if (now.difference(entry.value.timestamp) > maxAge) {
        keysToRemove.add(entry.key);
      }
    }

    for (final key in keysToRemove) {
      _cache.remove(key);
    }
  }

  /// Remove a specific entry from cache
  void remove(String query) {
    final normalizedQuery = _normalizeQuery(query);
    _cache.remove(normalizedQuery);
  }

  /// Get cache statistics
  CacheStats getStats() {
    DateTime? oldestTimestamp;
    DateTime? newestTimestamp;
    int totalAccessCount = 0;

    for (final entry in _cache.values) {
      if (oldestTimestamp == null || entry.timestamp.isBefore(oldestTimestamp)) {
        oldestTimestamp = entry.timestamp;
      }
      if (newestTimestamp == null || entry.timestamp.isAfter(newestTimestamp)) {
        newestTimestamp = entry.timestamp;
      }
      totalAccessCount += entry.accessCount;
    }

    return CacheStats(
      size: _cache.length,
      maxSize: maxSize,
      oldestEntryAge: oldestTimestamp == null ? null : DateTime.now().difference(oldestTimestamp),
      newestEntryAge: newestTimestamp == null ? null : DateTime.now().difference(newestTimestamp),
      hitRate: hitRate,
      hits: _hits,
      misses: _misses,
      evictions: _evictions,
      averageAccessCount: _cache.isEmpty ? 0 : totalAccessCount / _cache.length,
    );
  }

  /// Reset cache metrics
  void resetMetrics() {
    _hits = 0;
    _misses = 0;
    _evictions = 0;
  }

  /// Normalize query for consistent caching
  String _normalizeQuery(String query) {
    return query.trim().toLowerCase();
  }
}

/// Cache entry with timestamp and access tracking
class _CacheEntry<T> {
  _CacheEntry({
    required this.results,
    required this.timestamp,
    required this.lastAccessed,
    required this.accessCount,
  });

  final List<T> results;
  final DateTime timestamp;
  DateTime lastAccessed;
  int accessCount;
}

/// Cache statistics
class CacheStats {
  CacheStats({
    required this.size,
    required this.maxSize,
    this.oldestEntryAge,
    this.newestEntryAge,
    this.hitRate = 0.0,
    this.hits = 0,
    this.misses = 0,
    this.evictions = 0,
    this.averageAccessCount = 0.0,
  });

  final int size;
  final int maxSize;
  final Duration? oldestEntryAge;
  final Duration? newestEntryAge;
  final double hitRate;
  final int hits;
  final int misses;
  final int evictions;
  final double averageAccessCount;

  double get utilizationPercent => maxSize == 0 ? 0 : (size / maxSize) * 100;

  @override
  String toString() {
    return 'CacheStats(size: $size/$maxSize, hitRate: ${(hitRate * 100).toStringAsFixed(1)}%, '
        'hits: $hits, misses: $misses, evictions: $evictions, avgAccess: ${averageAccessCount.toStringAsFixed(1)})';
  }
}
