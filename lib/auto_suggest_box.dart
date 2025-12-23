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
/// ## With Cubit (like smart_pagination)
///
/// ```dart
/// final cubit = AutoSuggestCubit<Product>(
///   provider: (query, {filters}) async => await api.search(query),
/// );
///
/// BlocAutoSuggestBox<Product>(
///   cubit: cubit,
///   itemBuilder: (context, product, isSelected, onTap) {
///     return ListTile(title: Text(product.name), onPressed: onTap);
///   },
///   labelBuilder: (product) => product.name,
/// )
/// ```
library auto_suggest_box;

// Core auto suggest components
export 'auto_suggest/auto_suggest.dart';

// Advanced search components
export 'advanced_auto_suggest/auto_suggest_advanced.dart';

// BLoC/Cubit state management
export 'bloc/bloc.dart';

// Common utilities
export 'common/text.dart';
export 'common/text_form.dart';
export 'common/form_field.dart';
