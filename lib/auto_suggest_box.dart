/// A highly customizable, performance-optimized auto-suggest/autocomplete
/// widget for Flutter with Fluent UI design.
///
/// Features include debounced search, LRU caching, keyboard navigation,
/// form validation, advanced search dialog, and BLoC/Cubit state management.
///
/// ## Basic Usage
///
/// ```dart
/// FluentAutoSuggestBox<String>(
///   items: [
///     FluentAutoSuggestBoxItem(value: '1', label: 'Apple'),
///     FluentAutoSuggestBoxItem(value: '2', label: 'Banana'),
///   ],
///   onSelected: (item) => print('Selected: ${item?.label}'),
/// )
/// ```
///
/// ## With Server Search
///
/// ```dart
/// FluentAutoSuggestBox<Product>(
///   items: localProducts,
///   onNoResultsFound: (query) async {
///     return await api.searchProducts(query);
///   },
///   onSelected: (item) => print('Selected: ${item?.label}'),
/// )
/// ```
///
/// ## With Cubit State Management
///
/// ```dart
/// final cubit = FluentAutoSuggestBoxCubit<Product>();
///
/// // Set items
/// cubit.setItems([
///   FluentAutoSuggestBoxItem(value: product1, label: 'Product 1'),
///   FluentAutoSuggestBoxItem(value: product2, label: 'Product 2'),
/// ]);
///
/// // Use with BlocBuilder
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
/// ## With AutoSuggestCubit (Server Search)
///
/// ```dart
/// final cubit = AutoSuggestCubit<Product>(
///   provider: (query, {filters}) async => await api.search(query),
/// );
///
/// FluentAutoSuggestBox<Product>.cubit(
///   cubit: cubit,
///   cubitItemBuilder: (context, product, isSelected, onTap) {
///     return ListTile(title: Text(product.name), onPressed: onTap);
///   },
///   labelBuilder: (product) => product.name,
/// )
/// ```
library auto_suggest_box;

// Core auto suggest components
export 'auto_suggest/auto_suggest.dart';

// BLoC/Cubit state management
export 'bloc/bloc.dart';

// Advanced search components
export 'advanced_auto_suggest/auto_suggest_advanced.dart';

// Common utilities
export 'common/text.dart';
export 'common/text_form.dart';
export 'common/form_field.dart';
