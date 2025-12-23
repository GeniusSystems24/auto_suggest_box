part of 'auto_suggest.dart';

/// Controller for managing AutoSuggestBox state and business logic
///
/// This controller handles:
/// - Search query debouncing to reduce API calls
/// - Loading and error states
/// - Overlay visibility management
/// - Recent searches tracking
/// - Search history management
class AutoSuggestController<T> extends ChangeNotifier {
  AutoSuggestController({
    this.debounceDelay = const Duration(seconds: 1),
    this.minSearchLength = 2,
    this.maxRecentSearches = 10,
    this.enableRecentSearches = false,
  });

  final Duration debounceDelay;
  final int minSearchLength;
  final int maxRecentSearches;
  final bool enableRecentSearches;

  Timer? _debounceTimer;
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isOverlayVisible = false;
  Object? _lastError;

  // Track the last search that was loaded to prevent duplicate requests
  String _lastSearchLoaded = '';

  // Recent searches history
  final List<String> _recentSearches = [];

  // Track search metrics
  int _totalSearches = 0;
  int _successfulSearches = 0;
  int _failedSearches = 0;

  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  bool get isOverlayVisible => _isOverlayVisible;
  Object? get lastError => _lastError;
  String get lastSearchLoaded => _lastSearchLoaded;
  List<String> get recentSearches => List.unmodifiable(_recentSearches);
  int get totalSearches => _totalSearches;
  int get successfulSearches => _successfulSearches;
  int get failedSearches => _failedSearches;

  /// Get search success rate (0.0 to 1.0)
  double get searchSuccessRate {
    if (_totalSearches == 0) return 0.0;
    return _successfulSearches / _totalSearches;
  }

  /// Update search query with debouncing
  void updateSearchQuery(String query, {required VoidCallback onDebounceComplete}) {
    _searchQuery = query;
    _debounceTimer?.cancel();

    if (query.length < minSearchLength) {
      notifyListeners();
      return;
    }

    _debounceTimer = Timer(debounceDelay, () {
      onDebounceComplete();
      notifyListeners();
    });
  }

  /// Set loading state
  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      if (loading) {
        _totalSearches++;
      }
      notifyListeners();
    }
  }

  /// Set overlay visibility
  void setOverlayVisible(bool visible) {
    if (_isOverlayVisible != visible) {
      _isOverlayVisible = visible;
      notifyListeners();
    }
  }

  /// Set error
  void setError(Object? error) {
    _lastError = error;
    if (error != null) {
      _isLoading = false;
      _failedSearches++;
    }
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _lastError = null;
    notifyListeners();
  }

  /// Update last search loaded
  void updateLastSearchLoaded(String search) {
    _lastSearchLoaded = search;
    _successfulSearches++;
    _addRecentSearch(search);
  }

  /// Add search to recent searches
  void _addRecentSearch(String query) {
    if (!enableRecentSearches || query.trim().isEmpty) return;

    final normalized = query.trim();

    // Remove if already exists to avoid duplicates
    _recentSearches.remove(normalized);

    // Add to the beginning
    _recentSearches.insert(0, normalized);

    // Keep only maxRecentSearches items
    if (_recentSearches.length > maxRecentSearches) {
      _recentSearches.removeRange(maxRecentSearches, _recentSearches.length);
    }

    notifyListeners();
  }

  /// Manually add a search to recent searches
  void addRecentSearch(String query) {
    _addRecentSearch(query);
  }

  /// Clear recent searches
  void clearRecentSearches() {
    _recentSearches.clear();
    notifyListeners();
  }

  /// Remove a specific recent search
  void removeRecentSearch(String query) {
    _recentSearches.remove(query);
    notifyListeners();
  }

  /// Reset search metrics
  void resetMetrics() {
    _totalSearches = 0;
    _successfulSearches = 0;
    _failedSearches = 0;
    notifyListeners();
  }

  /// Reset controller state
  void reset() {
    _searchQuery = '';
    _isLoading = false;
    _isOverlayVisible = false;
    _lastError = null;
    _lastSearchLoaded = '';
    _debounceTimer?.cancel();
    notifyListeners();
  }

  /// Check if a query should trigger a search
  bool shouldSearch(String query) {
    return query.trim().length >= minSearchLength;
  }

  /// Get controller statistics
  Map<String, dynamic> getStats() {
    return {
      'totalSearches': _totalSearches,
      'successfulSearches': _successfulSearches,
      'failedSearches': _failedSearches,
      'successRate': searchSuccessRate,
      'recentSearchesCount': _recentSearches.length,
      'isLoading': _isLoading,
      'hasError': _lastError != null,
    };
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
