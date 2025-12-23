/// BLoC/Cubit state management for auto_suggest_box
///
/// This module provides Cubit-based state management similar to
/// [smart_pagination](https://pub.dev/packages/smart_pagination).
///
/// ## Basic Usage
///
/// ```dart
/// // 1. Create a cubit
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
/// // 2. Use with BlocAutoSuggestBox
/// BlocAutoSuggestBox<Product>(
///   cubit: cubit,
///   itemBuilder: (context, product, isSelected, onTap) {
///     return ListTile(
///       title: Text(product.name),
///       selected: isSelected,
///       onPressed: onTap,
///     );
///   },
///   labelBuilder: (product) => product.name,
///   onSelected: (product) => print('Selected: ${product.name}'),
/// )
///
/// // 3. Or use with BlocBuilder directly
/// BlocBuilder<AutoSuggestCubit<Product>, AutoSuggestState<Product>>(
///   bloc: cubit,
///   builder: (context, state) {
///     return switch (state) {
///       AutoSuggestInitial() => Text('Start typing...'),
///       AutoSuggestLoading() => CircularProgressIndicator(),
///       AutoSuggestLoaded(:final items) => ListView(...),
///       AutoSuggestEmpty() => Text('No results'),
///       AutoSuggestError(:final error) => Text('Error: $error'),
///     };
///   },
/// );
/// ```
///
/// ## Features
///
/// - **Debounced Search**: Configurable delay to reduce API calls
/// - **LRU Caching**: Intelligent caching with TTL expiration
/// - **Retry Logic**: Exponential backoff for failed requests
/// - **Type-Safe States**: Sealed class hierarchy for exhaustive matching
/// - **Statistics**: Built-in cache hit rate and search metrics
/// - **Data Expiration**: Similar to smart_pagination's dataAge concept
library;

export 'auto_suggest_state.dart';
export 'auto_suggest_cubit.dart';
export 'bloc_auto_suggest_box.dart';
