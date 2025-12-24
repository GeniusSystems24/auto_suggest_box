import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auto_suggest/auto_suggest.dart';

/// حالة FluentAutoSuggestBox
class FluentAutoSuggestBoxState<T> extends Equatable {
  /// قائمة العناصر
  final List<FluentAutoSuggestBoxItem<T>> items;

  /// العنصر المختار
  final FluentAutoSuggestBoxItem<T>? selectedItem;

  /// النص الحالي في حقل الإدخال
  final String text;

  /// حالة التحميل
  final bool isLoading;

  /// رسالة الخطأ (إن وجدت)
  final Object? error;

  /// هل القائمة مفتوحة
  final bool isOverlayVisible;

  /// هل الحقل مفعل
  final bool isEnabled;

  /// هل الحقل للقراءة فقط
  final bool isReadOnly;

  const FluentAutoSuggestBoxState({
    this.items = const [],
    this.selectedItem,
    this.text = '',
    this.isLoading = false,
    this.error,
    this.isOverlayVisible = false,
    this.isEnabled = true,
    this.isReadOnly = false,
  });

  /// هل هناك خطأ
  bool get hasError => error != null;

  /// هل هناك عنصر مختار
  bool get hasSelection => selectedItem != null;

  /// هل القائمة فارغة
  bool get isEmpty => items.isEmpty;

  /// هل القائمة ليست فارغة
  bool get isNotEmpty => items.isNotEmpty;

  /// عدد العناصر
  int get itemCount => items.length;

  /// نسخة معدلة من الحالة
  FluentAutoSuggestBoxState<T> copyWith({
    List<FluentAutoSuggestBoxItem<T>>? items,
    FluentAutoSuggestBoxItem<T>? selectedItem,
    bool clearSelectedItem = false,
    String? text,
    bool? isLoading,
    Object? error,
    bool clearError = false,
    bool? isOverlayVisible,
    bool? isEnabled,
    bool? isReadOnly,
  }) {
    return FluentAutoSuggestBoxState<T>(
      items: items ?? this.items,
      selectedItem: clearSelectedItem ? null : (selectedItem ?? this.selectedItem),
      text: text ?? this.text,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      isOverlayVisible: isOverlayVisible ?? this.isOverlayVisible,
      isEnabled: isEnabled ?? this.isEnabled,
      isReadOnly: isReadOnly ?? this.isReadOnly,
    );
  }

  @override
  List<Object?> get props => [
        items,
        selectedItem,
        text,
        isLoading,
        error,
        isOverlayVisible,
        isEnabled,
        isReadOnly,
      ];
}

/// Cubit لإدارة حالة FluentAutoSuggestBox
///
/// يوفر دوال للتحكم الكامل في حالة الأداة:
/// - تعيين/تحديث العناصر
/// - تحديد عنصر
/// - التحكم في النص
/// - إدارة حالة التحميل والخطأ
///
/// مثال:
/// ```dart
/// final cubit = FluentAutoSuggestBoxCubit<Product>();
///
/// // تعيين العناصر
/// cubit.setItems([
///   FluentAutoSuggestBoxItem(value: product1, label: 'Product 1'),
///   FluentAutoSuggestBoxItem(value: product2, label: 'Product 2'),
/// ]);
///
/// // تحديد عنصر
/// cubit.selectItem(items.first);
///
/// // مسح الاختيار
/// cubit.clearSelection();
///
/// // تحميل من السيرفر
/// cubit.setLoading(true);
/// final items = await api.getProducts();
/// cubit.setItems(items);
/// cubit.setLoading(false);
/// ```
class FluentAutoSuggestBoxCubit<T> extends Cubit<FluentAutoSuggestBoxState<T>> {
  FluentAutoSuggestBoxCubit([FluentAutoSuggestBoxState<T>? initialState])
      : super(initialState ?? FluentAutoSuggestBoxState<T>());

  // ============== دوال العناصر ==============

  /// تعيين قائمة العناصر
  void setItems(List<FluentAutoSuggestBoxItem<T>> items) {
    emit(state.copyWith(items: items, clearError: true));
  }

  /// إضافة عنصر واحد
  void addItem(FluentAutoSuggestBoxItem<T> item) {
    emit(state.copyWith(items: [...state.items, item]));
  }

  /// إضافة عدة عناصر
  void addItems(List<FluentAutoSuggestBoxItem<T>> items) {
    emit(state.copyWith(items: [...state.items, ...items]));
  }

  /// إزالة عنصر
  void removeItem(FluentAutoSuggestBoxItem<T> item) {
    final newItems = state.items.where((i) => i != item).toList();
    emit(state.copyWith(
      items: newItems,
      clearSelectedItem: state.selectedItem == item,
    ));
  }

  /// إزالة عنصر بالقيمة
  void removeItemByValue(T value) {
    final newItems = state.items.where((i) => i.value != value).toList();
    emit(state.copyWith(
      items: newItems,
      clearSelectedItem: state.selectedItem?.value == value,
    ));
  }

  /// مسح جميع العناصر
  void clearItems() {
    emit(state.copyWith(items: [], clearSelectedItem: true));
  }

  /// تحديث عنصر
  void updateItem(
    FluentAutoSuggestBoxItem<T> oldItem,
    FluentAutoSuggestBoxItem<T> newItem,
  ) {
    final index = state.items.indexOf(oldItem);
    if (index == -1) return;

    final newItems = [...state.items];
    newItems[index] = newItem;

    emit(state.copyWith(
      items: newItems,
      selectedItem: state.selectedItem == oldItem ? newItem : null,
    ));
  }

  // ============== دوال الاختيار ==============

  /// تحديد عنصر
  void selectItem(FluentAutoSuggestBoxItem<T>? item) {
    emit(state.copyWith(
      selectedItem: item,
      clearSelectedItem: item == null,
      text: item?.label ?? '',
      isOverlayVisible: false,
    ));
  }

  /// تحديد عنصر بالقيمة
  void selectByValue(T value) {
    final item = state.items.cast<FluentAutoSuggestBoxItem<T>?>().firstWhere(
          (i) => i?.value == value,
          orElse: () => null,
        );
    if (item != null) {
      selectItem(item);
    }
  }

  /// تحديد عنصر بالفهرس
  void selectByIndex(int index) {
    if (index >= 0 && index < state.items.length) {
      selectItem(state.items[index]);
    }
  }

  /// مسح الاختيار
  void clearSelection() {
    emit(state.copyWith(clearSelectedItem: true, text: ''));
  }

  // ============== دوال النص ==============

  /// تعيين النص
  void setText(String text) {
    emit(state.copyWith(text: text));
  }

  /// مسح النص
  void clearText() {
    emit(state.copyWith(text: '', clearSelectedItem: true));
  }

  // ============== دوال الحالة ==============

  /// تعيين حالة التحميل
  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading, clearError: isLoading));
  }

  /// تعيين خطأ
  void setError(Object error) {
    emit(state.copyWith(error: error, isLoading: false));
  }

  /// مسح الخطأ
  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  /// تعيين حالة ظهور القائمة
  void setOverlayVisible(bool visible) {
    emit(state.copyWith(isOverlayVisible: visible));
  }

  /// تعيين حالة التفعيل
  void setEnabled(bool enabled) {
    emit(state.copyWith(isEnabled: enabled));
  }

  /// تعيين حالة القراءة فقط
  void setReadOnly(bool readOnly) {
    emit(state.copyWith(isReadOnly: readOnly));
  }

  // ============== دوال مساعدة ==============

  /// إعادة تعيين الحالة بالكامل
  void reset() {
    emit(FluentAutoSuggestBoxState<T>());
  }

  /// مسح كل شيء مع الاحتفاظ بالعناصر
  void clear() {
    emit(state.copyWith(
      clearSelectedItem: true,
      text: '',
      clearError: true,
      isLoading: false,
      isOverlayVisible: false,
    ));
  }

  /// البحث في العناصر المحلية
  List<FluentAutoSuggestBoxItem<T>> search(String query) {
    if (query.isEmpty) return state.items;

    return state.items.where((item) {
      return item.label.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  /// الحصول على العنصر بالفهرس
  FluentAutoSuggestBoxItem<T>? getItemAt(int index) {
    if (index >= 0 && index < state.items.length) {
      return state.items[index];
    }
    return null;
  }

  /// الحصول على العنصر بالقيمة
  FluentAutoSuggestBoxItem<T>? getItemByValue(T value) {
    return state.items.cast<FluentAutoSuggestBoxItem<T>?>().firstWhere(
          (i) => i?.value == value,
          orElse: () => null,
        );
  }

  /// هل القيمة موجودة في القائمة
  bool containsValue(T value) {
    return state.items.any((i) => i.value == value);
  }
}
