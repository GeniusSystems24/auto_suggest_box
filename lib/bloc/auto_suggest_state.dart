import 'package:equatable/equatable.dart';

/// Base state for AutoSuggestCubit
///
/// Similar to SmartPaginationState, this sealed class hierarchy provides
/// type-safe state management for auto-suggest functionality.
sealed class AutoSuggestState<T> extends Equatable {
  const AutoSuggestState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any search is performed
///
/// This is the default state when the cubit is first created or after reset.
class AutoSuggestInitial<T> extends AutoSuggestState<T> {
  const AutoSuggestInitial();
}

/// Loading state while fetching search results
///
/// Contains the current query and optionally previous items for smooth UX.
class AutoSuggestLoading<T> extends AutoSuggestState<T> {
  /// The current search query
  final String query;

  /// Previous items to display while loading (for smooth transitions)
  final List<T>? previousItems;

  /// Whether this is loading more results (for pagination)
  final bool isLoadingMore;

  const AutoSuggestLoading({
    required this.query,
    this.previousItems,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [query, previousItems, isLoadingMore];
}

/// Loaded state with search results
///
/// Contains all the data needed to display search results and manage cache.
class AutoSuggestLoaded<T> extends AutoSuggestState<T> {
  /// The search results
  final List<T> items;

  /// The query that produced these results
  final String query;

  /// Whether there are more results available (for pagination)
  final bool hasMoreResults;

  /// When the data was fetched
  final DateTime fetchedAt;

  /// When the data will expire (null if no expiry configured)
  final DateTime? dataExpiredAt;

  /// Whether currently loading more items
  final bool isLoadingMore;

  /// Error while loading more (if any)
  final Object? loadMoreError;

  const AutoSuggestLoaded({
    required this.items,
    required this.query,
    this.hasMoreResults = false,
    required this.fetchedAt,
    this.dataExpiredAt,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  /// Check if the cached data has expired
  bool get isDataExpired {
    if (dataExpiredAt == null) return false;
    return DateTime.now().isAfter(dataExpiredAt!);
  }

  /// Get the age of the data
  Duration get dataAge => DateTime.now().difference(fetchedAt);

  /// Time until data expires (null if no expiry or already expired)
  Duration? get timeUntilExpiry {
    if (dataExpiredAt == null) return null;
    final remaining = dataExpiredAt!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Create a copy with updated values
  AutoSuggestLoaded<T> copyWith({
    List<T>? items,
    String? query,
    bool? hasMoreResults,
    DateTime? fetchedAt,
    DateTime? dataExpiredAt,
    bool? isLoadingMore,
    Object? loadMoreError,
  }) {
    return AutoSuggestLoaded<T>(
      items: items ?? this.items,
      query: query ?? this.query,
      hasMoreResults: hasMoreResults ?? this.hasMoreResults,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      dataExpiredAt: dataExpiredAt ?? this.dataExpiredAt,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: loadMoreError,
    );
  }

  @override
  List<Object?> get props => [
        items,
        query,
        hasMoreResults,
        fetchedAt,
        dataExpiredAt,
        isLoadingMore,
        loadMoreError,
      ];
}

/// Error state when search fails
///
/// Contains the error details and optionally previous items.
class AutoSuggestError<T> extends AutoSuggestState<T> {
  /// The error that occurred
  final Object error;

  /// Stack trace for debugging
  final StackTrace? stackTrace;

  /// The query that failed
  final String query;

  /// Previous items to display (for graceful degradation)
  final List<T>? previousItems;

  const AutoSuggestError({
    required this.error,
    this.stackTrace,
    required this.query,
    this.previousItems,
  });

  @override
  List<Object?> get props => [error, query, previousItems];
}

/// Empty state when search returns no results
///
/// Separate from Loaded with empty list for explicit handling.
class AutoSuggestEmpty<T> extends AutoSuggestState<T> {
  /// The query that returned no results
  final String query;

  /// When the search was performed
  final DateTime searchedAt;

  const AutoSuggestEmpty({
    required this.query,
    required this.searchedAt,
  });

  @override
  List<Object?> get props => [query, searchedAt];
}
