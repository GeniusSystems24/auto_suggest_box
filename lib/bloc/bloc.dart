/// BLoC/Cubit state management for auto_suggest_box
///
/// This module provides Cubit-based state management for FluentAutoSuggestBox.
///
/// ## FluentAutoSuggestBoxCubit (Widget State Management)
///
/// Use this cubit to manage the state of FluentAutoSuggestBox widget:
///
/// ```dart
/// // 1. Create a cubit
/// final cubit = FluentAutoSuggestBoxCubit<Product>();
///
/// // 2. Set items
/// cubit.setItems([
///   FluentAutoSuggestBoxItem(value: product1, label: 'Product 1'),
///   FluentAutoSuggestBoxItem(value: product2, label: 'Product 2'),
/// ]);
///
/// // 3. Select an item
/// cubit.selectItem(items.first);
///
/// // 4. Clear selection
/// cubit.clearSelection();
///
/// // 5. Use with BlocBuilder
/// BlocBuilder<FluentAutoSuggestBoxCubit<Product>, FluentAutoSuggestBoxState<Product>>(
///   bloc: cubit,
///   builder: (context, state) {
///     return FluentAutoSuggestBox<Product>(
///       items: state.items,
///       enabled: state.isEnabled,
///       onSelected: (item) => cubit.selectItem(item),
///     );
///   },
/// );
/// ```
///
/// ## AutoSuggestCubit (Search Provider)
///
/// Use this cubit for server-side search with caching:
///
/// ```dart
/// final searchCubit = AutoSuggestCubit<Product>(
///   provider: (query, {filters}) async {
///     return await api.searchProducts(query);
///   },
///   config: AutoSuggestConfig(
///     debounceDelay: Duration(milliseconds: 300),
///     dataAge: Duration(minutes: 15),
///   ),
/// );
/// ```
library;

export 'auto_suggest_state.dart';
export 'auto_suggest_cubit.dart';
export 'auto_suggest_box_cubit.dart';
export 'bloc_auto_suggest_box.dart';
