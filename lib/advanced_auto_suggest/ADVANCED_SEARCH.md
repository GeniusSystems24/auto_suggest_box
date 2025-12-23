# 🚀 Advanced Search Feature Documentation

## Overview

ميزة البحث المتقدم تضيف Dialog كبير وقابل للتخصيص بالكامل مع دعم اختصارات لوحة المفاتيح (F3 افتراضياً).

## ✨ Features

### Core Features
- ✅ **Dialog كبير وقابل للتخصيص** (800x600 افتراضياً)
- ✅ **اختصارات لوحة المفاتيح** (F3, Ctrl+K, أو أي اختصار)
- ✅ **ثلاثة أوضاع عرض**: List, Grid, Compact
- ✅ **Multi-Select Mode** - اختيار متعدد مع حد أقصى اختياري
- ✅ **Custom Filters** - فلاتر مخصصة بالكامل
- ✅ **Stats Display** - عرض إحصائيات البحث
- ✅ **Animations** - حركات سلسة للظهور والاختفاء
- ✅ **Customizable Builders** - تخصيص كل جزء من الـ Dialog

### Performance Features
- ✅ Debouncing للبحث
- ✅ Lazy loading للنتائج
- ✅ Pagination support (اختياري)
- ✅ Error handling شامل

---

## 🎯 Quick Start

### 1. Basic Usage (دقيقتان)

```dart
import 'auto_suggest_advanced_wrapper.dart';

// استخدام بسيط مع F3
AdvancedSearchExtension.withAdvancedSearch<String>(
  autoSuggestBox: FluentAutoSuggestBox<String>(
    items: yourItems,
    onSelected: (item) => print(item?.label),
  ),
  config: const AdvancedSearchConfig(
    title: 'Advanced Search',
  ),
  onAdvancedSearch: (query, filters) async {
    return await searchFunction(query, filters);
  },
)
```

**That's it!** الآن المستخدم يمكنه:
- الضغط على F3 لفتح البحث المتقدم
- البحث في dialog كبير
- رؤية النتائج بأوضاع عرض مختلفة

---

## 📚 Configuration Options

### AdvancedSearchConfig

```dart
const AdvancedSearchConfig(
  // UI Settings
  title: 'Advanced Search',           // عنوان الـ Dialog
  searchHint: 'Search...',            // نص placeholder
  width: 800,                         // عرض الـ Dialog
  height: 600,                        // ارتفاع الـ Dialog
  
  // Keyboard Shortcut
  keyboardShortcut: SingleActivator(LogicalKeyboardKey.f3),
  enableKeyboardShortcut: true,       // تفعيل/تعطيل الاختصار
  
  // Behavior
  barrierDismissible: true,           // الإغلاق عند النقر خارج الـ Dialog
  
  // Features
  showFilters: true,                  // إظهار منطقة الفلاتر
  showStats: true,                    // إظهار الإحصائيات
  
  // View Mode
  viewMode: AdvancedSearchViewMode.list,  // الوضع الافتراضي
  enableViewModeSwitch: true,         // السماح بتبديل الأوضاع
  
  // Pagination
  resultsPerPage: 20,                 // عدد النتائج في الصفحة
  enablePagination: false,            // تفعيل التقسيم
)
```

---

## 🎨 View Modes

### 1. List View (Default)
```dart
AdvancedSearchViewMode.list
```
- عرض تفصيلي كقائمة
- مثالي للعناصر ذات المعلومات الكثيرة
- يدعم subtitle و custom builders

### 2. Grid View
```dart
AdvancedSearchViewMode.grid
```
- عرض البطاقات في شبكة 3 أعمدة
- مثالي للمنتجات والصور
- قابل للتخصيص بالكامل

### 3. Compact View
```dart
AdvancedSearchViewMode.compact
```
- عرض مضغوط جداً
- مثالي للقوائم الطويلة
- أسرع في التمرير

---

## 🎛️ Customization Options

### 1. Custom Item Builder (List View)

```dart
AdvancedSearchExtension.withAdvancedSearch<Product>(
  // ... other params
  advancedItemBuilder: (context, item) {
    final product = item.value;
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      subtitle: Text('${product.category} - \$${product.price}'),
      trailing: Icon(Icons.arrow_forward),
    );
  },
)
```

### 2. Custom Card Builder (Grid View)

```dart
itemCardBuilder: (context, item, isSelected) {
  final product = item.value;
  return Card(
    color: isSelected ? Colors.blue.shade100 : null,
    child: Column(
      children: [
        Image.network(product.imageUrl, height: 100),
        Text(product.name),
        Text('\$${product.price}'),
      ],
    ),
  );
}
```

### 3. Custom Filters

```dart
filterBuilder: (context, filters, onFiltersChanged) {
  return Column(
    children: [
      // Category Filter
      DropdownButton<String>(
        value: filters['category'],
        items: categories.map((cat) => 
          DropdownMenuItem(value: cat, child: Text(cat))
        ).toList(),
        onChanged: (value) {
          final newFilters = Map<String, dynamic>.from(filters);
          newFilters['category'] = value;
          onFiltersChanged(newFilters);
        },
      ),
      
      // Price Range
      RangeSlider(
        values: RangeValues(
          filters['minPrice'] ?? 0,
          filters['maxPrice'] ?? 1000,
        ),
        min: 0,
        max: 1000,
        onChanged: (values) {
          final newFilters = Map<String, dynamic>.from(filters);
          newFilters['minPrice'] = values.start;
          newFilters['maxPrice'] = values.end;
          onFiltersChanged(newFilters);
        },
      ),
      
      // In Stock Only
      CheckboxListTile(
        title: Text('In Stock Only'),
        value: filters['inStock'] ?? false,
        onChanged: (value) {
          final newFilters = Map<String, dynamic>.from(filters);
          newFilters['inStock'] = value;
          onFiltersChanged(newFilters);
        },
      ),
    ],
  );
}
```

### 4. Custom Stats Display

```dart
statsBuilder: (context, totalResults, displayedResults, query, duration) {
  return Container(
    padding: EdgeInsets.all(16),
    color: Colors.blue.shade50,
    child: Row(
      children: [
        Icon(Icons.analytics, color: Colors.blue),
        SizedBox(width: 8),
        Text('Found $totalResults items in ${duration.inMilliseconds}ms'),
        Spacer(),
        Text('Showing $displayedResults items'),
      ],
    ),
  );
}
```

### 5. Custom Header

```dart
headerBuilder: (context) {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue, Colors.purple],
      ),
    ),
    child: Column(
      children: [
        Text(
          'Search Our Catalog',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // Your custom search field here
      ],
    ),
  );
}
```

### 6. Custom Empty State

```dart
emptyStateBuilder: (context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.search_off, size: 100, color: Colors.grey),
        SizedBox(height: 20),
        Text(
          'No Results Found',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text('Try different search terms'),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {/* Clear filters */},
          child: Text('Clear Filters'),
        ),
      ],
    ),
  );
}
```

### 7. Custom Loading

```dart
loadingBuilder: (context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 20),
        Text('Searching our database...'),
        SizedBox(height: 10),
        Text('Please wait', style: TextStyle(fontSize: 12)),
      ],
    ),
  );
}
```

### 8. Custom Error Display

```dart
errorBuilder: (context, error) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error, size: 80, color: Colors.red),
        SizedBox(height: 20),
        Text('Oops! Something went wrong'),
        SizedBox(height: 10),
        Text(error.toString(), style: TextStyle(fontSize: 12)),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {/* Retry */},
          child: Text('Retry'),
        ),
      ],
    ),
  );
}
```

---

## 🎹 Keyboard Shortcuts

### Predefined Shortcuts

```dart
// F3 (Default)
SingleActivator(LogicalKeyboardKey.f3)

// Ctrl+K (Popular for search)
SingleActivator(LogicalKeyboardKey.keyK, control: true)

// Ctrl+Shift+F (Advanced)
SingleActivator(
  LogicalKeyboardKey.keyF,
  control: true,
  shift: true,
)

// Alt+S
SingleActivator(LogicalKeyboardKey.keyS, alt: true)

// Cmd+K (Mac)
SingleActivator(LogicalKeyboardKey.keyK, meta: true)
```

### Custom Shortcuts

```dart
AdvancedSearchConfig(
  keyboardShortcut: SingleActivator(
    LogicalKeyboardKey.keyP,  // أي مفتاح
    control: true,             // Ctrl (اختياري)
    shift: false,              // Shift (اختياري)
    alt: false,                // Alt (اختياري)
    meta: false,               // Cmd/Win (اختياري)
  ),
)
```

---

## 🎯 Multi-Select Mode

### Enable Multi-Select

```dart
final selectedItems = await AdvancedSearchDialog.showMultiSelect<Product>(
  context: context,
  items: items,
  maxSelections: 5,  // حد أقصى اختياري
  onSearch: searchFunction,
  config: AdvancedSearchConfig(
    title: 'Select Products (Max 5)',
  ),
);

// selectedItems is List<Product>?
if (selectedItems != null) {
  print('Selected ${selectedItems.length} items');
}
```

### Features in Multi-Select
- ✅ Checkboxes on items
- ✅ Selection counter in stats
- ✅ Confirm/Cancel buttons
- ✅ Maximum selections limit
- ✅ Visual feedback for selected items

---

## 🔍 Search Function

### Basic Search

```dart
Future<List<FluentAutoSuggestBoxItem<T>>> onAdvancedSearch(
  String query,
  Map<String, dynamic> filters,
) async {
  // Your search logic
  final results = await api.search(query);
  
  return results.map((item) => FluentAutoSuggestBoxItem(
    value: item,
    label: item.name,
  )).toList();
}
```

### With Filters

```dart
Future<List<FluentAutoSuggestBoxItem<Product>>> searchProducts(
  String query,
  Map<String, dynamic> filters,
) async {
  var products = await api.getProducts();
  
  // Apply text search
  if (query.isNotEmpty) {
    products = products.where((p) =>
      p.name.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
  
  // Apply category filter
  if (filters['category'] != null && filters['category'] != 'All') {
    products = products.where((p) =>
      p.category == filters['category']
    ).toList();
  }
  
  // Apply price filter
  if (filters['maxPrice'] != null) {
    products = products.where((p) =>
      p.price <= filters['maxPrice']
    ).toList();
  }
  
  // Apply stock filter
  if (filters['inStock'] == true) {
    products = products.where((p) => p.inStock).toList();
  }
  
  return products.map((p) => FluentAutoSuggestBoxItem(
    value: p,
    label: p.name,
    subtitle: Text('${p.category} - \$${p.price}'),
  )).toList();
}
```

---

## 🎨 Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'auto_suggest_advanced_wrapper.dart';

class CompleteAdvancedSearchExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdvancedSearchExtension.withAdvancedSearch<Product>(
      // Basic AutoSuggestBox
      autoSuggestBox: FluentAutoSuggestBox<Product>(
        items: products.map((p) => FluentAutoSuggestBoxItem(
          value: p,
          label: p.name,
        )).toList(),
        onSelected: (item) {
          if (item != null) {
            showProductDetails(item.value);
          }
        },
      ),
      
      // Advanced Search Configuration
      config: AdvancedSearchConfig(
        title: 'Product Catalog',
        searchHint: 'Search products...',
        width: 900,
        height: 650,
        keyboardShortcut: SingleActivator(
          LogicalKeyboardKey.keyK,
          control: true,
        ),
        showFilters: true,
        showStats: true,
        viewMode: AdvancedSearchViewMode.grid,
        enableViewModeSwitch: true,
      ),
      
      // Search Function
      onAdvancedSearch: (query, filters) async {
        return await searchProducts(query, filters);
      },
      
      // Custom Builders
      filterBuilder: buildProductFilters,
      itemCardBuilder: buildProductCard,
      statsBuilder: buildCustomStats,
      headerBuilder: buildCustomHeader,
      emptyStateBuilder: buildEmptyState,
      loadingBuilder: buildLoadingState,
      errorBuilder: buildErrorState,
      
      // Optional
      sorter: (text, items) {
        // Custom sorting logic
        return items;
      },
    );
  }
}
```

---

## 📊 API Reference

### AdvancedSearchDialog.show()

```dart
static Future<T?> show<T>({
  required BuildContext context,
  required List<FluentAutoSuggestBoxItem<T>> items,
  required Future<List<FluentAutoSuggestBoxItem<T>>> Function(
    String query,
    Map<String, dynamic> filters,
  ) onSearch,
  AdvancedSearchConfig config = const AdvancedSearchConfig(),
  String initialQuery = '',
  Widget Function(BuildContext, FluentAutoSuggestBoxItem<T>)? itemBuilder,
  AdvancedItemCardBuilder<T>? itemCardBuilder,
  FilterBuilder? filterBuilder,
  StatsBuilder<T>? statsBuilder,
  WidgetBuilder? headerBuilder,
  WidgetBuilder? footerBuilder,
  WidgetBuilder? emptyStateBuilder,
  Widget Function(BuildContext, Object error)? errorBuilder,
  WidgetBuilder? loadingBuilder,
  AutoSuggestController<T>? controller,
})
```

### AdvancedSearchDialog.showMultiSelect()

```dart
static Future<List<T>?> showMultiSelect<T>({
  // All parameters from show() plus:
  int? maxSelections,  // Maximum number of selections
})
```

---

## 💡 Best Practices

### 1. Search Function Optimization

```dart
// ✅ Good - Use caching
final _cache = <String, List<Product>>{};

Future<List<FluentAutoSuggestBoxItem<Product>>> search(
  String query,
  Map<String, dynamic> filters,
) async {
  final cacheKey = '$query-${filters.toString()}';
  
  if (_cache.containsKey(cacheKey)) {
    return _cache[cacheKey]!.map(...).toList();
  }
  
  final results = await api.search(query, filters);
  _cache[cacheKey] = results;
  
  return results.map(...).toList();
}
```

### 2. Filter State Management

```dart
// ✅ Good - Keep filter state
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  Map<String, dynamic> _lastFilters = {};
  
  Widget buildFilters(context, filters, onChanged) {
    _lastFilters = filters;  // Save for later
    // ... build filters
  }
}
```

### 3. Large Result Sets

```dart
// ✅ Good - Enable pagination
AdvancedSearchConfig(
  enablePagination: true,
  resultsPerPage: 20,
)
```

### 4. Error Handling

```dart
// ✅ Good - Handle all errors
Future<List<FluentAutoSuggestBoxItem<Product>>> search(
  String query,
  Map<String, dynamic> filters,
) async {
  try {
    return await api.search(query, filters);
  } on NetworkException {
    throw 'Network error. Check your connection.';
  } on TimeoutException {
    throw 'Request timed out. Try again.';
  } catch (e) {
    throw 'Unexpected error: $e';
  }
}
```

---

## 🎯 Use Cases

### 1. E-Commerce Product Search
```dart
// Grid view with filters for category, price, rating
// Multi-select for adding to cart
```

### 2. Employee Directory
```dart
// List view with department and position filters
// Click to view profile
```

### 3. Document Search
```dart
// Compact view for file browser
// Filters for file type, date, size
```

### 4. Tag Selection
```dart
// Multi-select mode
// Max selections = 10
// Compact view
```

### 5. Address Book
```dart
// List view with photo
// Filters for favorites, recent
// Click to dial or message
```

---

## 🐛 Troubleshooting

### Issue: Keyboard shortcut not working

**Solution:**
```dart
// Make sure the widget tree has Focus
AdvancedSearchConfig(
  enableKeyboardShortcut: true,  // Must be true
)
```

### Issue: Dialog not showing

**Solution:**
```dart
// Make sure context is valid
showDialog(
  context: context,  // Use correct context
  builder: ...
)
```

### Issue: Custom builders not appearing

**Solution:**
```dart
// Make sure you're providing the builder
advancedItemBuilder: (context, item) {
  return YourWidget();  // Must return Widget
}
```

---

## 📈 Performance Tips

1. **Use caching** for search results
2. **Enable pagination** for large datasets
3. **Debounce** is already built-in
4. **Lazy load** images in grid view
5. **Limit** max results to 100-200

---

## 🎉 Conclusion

ميزة البحث المتقدم توفر:
- ✅ تجربة مستخدم ممتازة
- ✅ قابلية تخصيص كاملة
- ✅ أداء عالي
- ✅ سهولة الاستخدام

**جرّبها الآن واضغط F3!** 🚀
