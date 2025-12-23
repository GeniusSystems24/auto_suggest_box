# 🎨 Advanced Auto Suggest Examples - Complete Guide

## 📚 Overview

This directory contains comprehensive examples demonstrating the full capabilities of the Advanced Search Dialog with Fluent UI integration. All examples are production-ready and can be used as references for your own implementations.

---

## 📁 Files Structure

```
advanced_auto_suggest/
├── auto_suggest_advanced.dart           # Core advanced search dialog
├── auto_suggest_advanced_wrapper.dart   # Keyboard shortcuts wrapper
├── customization_example.dart           # 6 ready-to-use themes
├── fluent_examples.dart                 # Basic Fluent UI examples
├── advanced_fluent_examples.dart        # Advanced Fluent UI examples
└── EXAMPLES_README.md                   # This file
```

---

## 🎯 Quick Start

### Basic Usage

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genius_link_core_app/genius_link_core_app.dart' show SvgPicture;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genius_link_core_app/genius_link_core_app.dart' show SvgPicture;
import 'package:fluent_ui/fluent_ui.dart';
import 'advanced_auto_suggest/auto_suggest_advanced.dart';

// Simple search dialog
final result = await AdvancedSearchDialog.show<String>(
  context: context,
  items: myItems,
  onSearch: performSearch,
);
```

### Using Pre-built Themes

```dart
import 'advanced_auto_suggest/customization_example.dart';

// Use a ready-made theme
final result = await AdvancedSearchDialog.show<Product>(
  context: context,
  items: products,
  onSearch: searchProducts,
  config: AdvancedSearchCustomizationExample.blueTheme,
);
```

---

## 📖 Examples Guide

### 1. **customization_example.dart** - Theme Customization

Contains 6 complete, production-ready themes:

#### 🔵 Blue Theme (Professional)

```dart
config: AdvancedSearchCustomizationExample.blueTheme
```

- Blue accent color
- Modern, clean design
- 4-column grid view
- Perfect for business applications

#### 🌙 Dark Theme

```dart
config: AdvancedSearchCustomizationExample.darkTheme
```

- Dark background with light text
- Blue accent
- Great for night mode
- Reduced eye strain

#### 📦 Compact Theme (Minimal)

```dart
config: AdvancedSearchCustomizationExample.compactTheme
```

- Smaller dialogs
- Reduced spacing
- No animations
- Perfect for quick searches
- Compact view mode

#### 🎨 Colorful Theme (Fun)

```dart
config: AdvancedSearchCustomizationExample.colorfulTheme
```

- Purple accent
- Playful animations
- Bounce effects
- Great for creative apps

#### 💼 Professional Theme (Enterprise)

```dart
config: AdvancedSearchCustomizationExample.professionalTheme
```

- Corporate blue
- Advanced toolbar actions
- Large dialog size
- Pagination enabled
- 50 results per page

#### ⚪ Minimalist Theme (Material Design)

```dart
config: AdvancedSearchCustomizationExample.minimalistTheme
```

- Flat design
- No elevation
- Sharp corners
- Material Design inspired

---

### 2. **fluent_examples.dart** - Basic Fluent UI Integration

Contains 3 complete working examples:

#### 🛍️ Product Search Example

**Features:**

- Grid and list view modes
- Product cards with images and prices
- Stock level indicators
- Info badges (stock status)
- Expandable product details
- InfoBar notifications

**Components Used:**

- `Card`
- `Button`
- `Flyout`
- `FlyoutContent`
- `Icon`
- `Expander`
- `ProgressBar`
- `InfoBar`

**Usage:**

```dart
const ProductSearchExample()
```

**Screenshot Flow:**

1. Click "Search Products" button
2. Advanced search dialog opens
3. Select a product
4. Product details shown in expandable card
5. Success notification appears

---

#### 👥 Employee Directory Example

**Features:**

- NavigationView with sidebar
- Tab views for different sections
- Employee profile cards
- Contact information tabs
- Department organization
- Recent views tracking

**Components Used:**

- `NavigationView`
- `NavigationPane`
- `NavigationAppBar`
- `CommandBar`
- `TabView`
- `ListTile`
- `Expander`

**Usage:**

```dart
const EmployeeDirectoryExample()
```

**Sections:**

1. **All Employees** - Full directory
2. **Departments** - Organized by department
3. **Recent** - Recently viewed employees

---

#### 📄 Document Manager Example

**Features:**

- Document search with file type icons
- Grid view with document previews
- Document details with metadata
- Upload and browse functionality
- File type indicators (PDF, Word, Excel, PowerPoint, Images)

**Components Used:**

- `ScaffoldPage`
- `PageHeader`
- `CommandBar`
- `Card`
- `Expander`
- `Icon` (dynamic based on file type)

**Usage:**

```dart
const DocumentManagerExample()
```

**Document Types Supported:**

- PDF
- Word (.docx)
- Excel (.xlsx)
- PowerPoint (.pptx)
- Images

---

### 3. **advanced_fluent_examples.dart** - Advanced Integration

Contains 3 advanced examples with complex interactions:

#### 🏪 Advanced Product Catalog

**Features:**

- Sidebar filters panel
- Multi-level filtering (Category, Price, Rating, Stock)
- Range sliders for price filtering
- Rating bar for minimum rating
- Quick filter chips
- Sorting options (ComboBox)
- Reset filters functionality
- Real-time filter updates

**Components Used:**

- `Expander` (for filter sections)
- `RadioButton` (category selection)
- `Slider` (price range)
- `RatingBar` (rating filter)
- `Checkbox` (stock filter)
- `ComboBox` (sorting)
- `FilledButton`
- Custom filter chips

**Usage:**

```dart
const AdvancedProductCatalog()
```

**Filter Options:**

- **Category**: All, Electronics, Accessories, Audio, Office, Furniture
- **Price Range**: $0 - $2,000 (dual sliders)
- **Rating**: 0-5 stars
- **Availability**: In Stock Only checkbox
- **Sort By**: Name, Price (Low/High), Rating, Newest

---

#### ✅ Task Manager Example

**Features:**

- Task creation with dialog
- Date and time pickers
- Priority selection (Low, Medium, High)
- Status badges
- Task checklist
- Due date tracking

**Components Used:**

- `ContentDialog` (new task form)
- `DatePicker`
- `TimePicker`
- `ComboBox` (priority selection)
- `TextBox` (title and description)
- `Checkbox` (task completion)
- `ListTile` (task cards)

**Usage:**

```dart
const TaskManagerExample()
```

**Task Properties:**

- Title
- Description
- Due Date (DatePicker)
- Time (TimePicker)
- Priority (Low, Medium, High)
- Status (Pending, Completed)

---

#### ⚙️ Settings Panel Example

**Features:**

- Organized settings sections
- Toggle switches for boolean settings
- ComboBox for selection settings
- Sliders for numeric settings
- Real-time preview
- Grouped by categories

**Components Used:**

- `ToggleSwitch`
- `ComboBox`
- `Slider`
- `Card` (section containers)
- `Divider`

**Usage:**

```dart
const SettingsPanelExample()
```

**Settings Categories:**

**General:**

- Notifications (Toggle)
- Auto Save (Toggle)
- Language (ComboBox: English, Arabic, French, Spanish)

**Appearance:**

- Dark Mode (Toggle)
- Theme (ComboBox: Light, Dark, Auto)

**Audio:**

- Sound (Toggle)
- Volume (Slider: 0-100%)

---

## 🎨 Customization Classes

### AdvancedSearchTheme

Complete theme customization for colors, spacing, and visual appearance.

```dart
AdvancedSearchTheme(
  // Colors
  primaryColor: Colors.blue,
  backgroundColor: Colors.white,
  cardColor: Colors.grey[100],
  selectedItemColor: Colors.blue.withValues(alpha:0.1),
  borderColor: Colors.grey[300],
  textColor: Colors.black,
  hintColor: Colors.grey,
  iconColor: Colors.blue,
  overlayColor: Colors.black54,
  shadowColor: Colors.grey,

  // Layout
  borderRadius: BorderRadius.circular(12),
  spacing: 16.0,
  padding: EdgeInsets.all(20),
  elevation: 8.0,
)
```

### AdvancedSearchIcons

Customize all icons in the dialog.

```dart
AdvancedSearchIcons(
  search: FluentIcons.search,
  clear: FluentIcons.clear,
  close: FluentIcons.cancel,
  filter: FluentIcons.filter,
  sort: FluentIcons.sort,
  viewList: FluentIcons.view_list,
  viewGrid: FluentIcons.grid_view_medium,
  viewCompact: FluentIcons.view_dashboard,
  info: FluentIcons.info,
  error: FluentIcons.error,
  loading: FluentIcons.progress_ring_dots,
  empty: FluentIcons.search,
  chevronRight: FluentIcons.chevron_right,
  checkbox: FluentIcons.checkbox_composite,
)
```

### AdvancedSearchLayout

Control dimensions and spacing.

```dart
AdvancedSearchLayout(
  headerHeight: 120.0,
  footerHeight: 80.0,
  itemHeight: 72.0,
  gridCrossAxisCount: 3,
  gridCrossAxisSpacing: 16.0,
  gridMainAxisSpacing: 16.0,
  gridChildAspectRatio: 1.2,
  listItemSpacing: 8.0,
  compactItemHeight: 48.0,
  searchFieldHeight: 48.0,
  borderWidth: 1.0,
)
```

### AdvancedSearchAnimation

Customize animations and timing.

```dart
AdvancedSearchAnimation(
  dialogEnterDuration: Duration(milliseconds: 300),
  dialogExitDuration: Duration(milliseconds: 250),
  itemEnterDuration: Duration(milliseconds: 200),
  viewSwitchDuration: Duration(milliseconds: 350),
  searchDebounceDuration: Duration(milliseconds: 300),
  dialogCurve: Curves.easeOutBack,
  itemCurve: Curves.easeOut,
  viewSwitchCurve: Curves.easeInOut,
)
```

### AdvancedSearchAction

Add custom toolbar buttons.

```dart
toolbarActions: [
  AdvancedSearchAction(
    icon: FluentIcons.refresh,
    tooltip: 'Refresh',
    onPressed: () => refreshData(),
  ),
  AdvancedSearchAction(
    icon: FluentIcons.filter,
    tooltip: 'Filter',
    onPressed: () => openFilters(),
  ),
  AdvancedSearchAction(
    icon: FluentIcons.export,
    tooltip: 'Export',
    onPressed: () => exportResults(),
  ),
]
```

---

## 🚀 Common Use Cases

### 1. E-Commerce Product Search

```dart
final product = await AdvancedSearchDialog.show<Product>(
  context: context,
  items: products,
  onSearch: searchProducts,
  config: AdvancedSearchConfig(
    title: 'Find Products',
    viewMode: AdvancedSearchViewMode.grid,
    layout: AdvancedSearchLayout(gridCrossAxisCount: 4),
    showStats: true,
  ),
  itemCardBuilder: (context, item, isSelected) {
    return ProductCard(product: item.value, isSelected: isSelected);
  },
);
```

### 2. Employee Directory

```dart
final employee = await AdvancedSearchDialog.show<Employee>(
  context: context,
  items: employees,
  onSearch: searchEmployees,
  config: AdvancedSearchConfig(
    title: 'Employee Directory',
    viewMode: AdvancedSearchViewMode.list,
    showStats: false,
  ),
);
```

### 3. Document Library

```dart
final document = await AdvancedSearchDialog.show<Document>(
  context: context,
  items: documents,
  onSearch: searchDocuments,
  config: AdvancedSearchConfig(
    title: 'Search Documents',
    viewMode: AdvancedSearchViewMode.grid,
    toolbarActions: [
      AdvancedSearchAction(
        icon: FluentIcons.upload,
        tooltip: 'Upload',
        onPressed: () => uploadDocument(),
      ),
    ],
  ),
);
```

### 4. Multi-Select Mode

```dart
final selectedItems = await AdvancedSearchDialog.showMultiSelect<Item>(
  context: context,
  items: allItems,
  onSearch: searchItems,
  maxSelections: 10,
  config: AdvancedSearchConfig(
    title: 'Select Items',
    viewMode: AdvancedSearchViewMode.list,
  ),
);

if (selectedItems != null) {
  print('Selected ${selectedItems.length} items');
}
```

---

## 💡 Best Practices

### 1. Performance

```dart
// ✅ DO: Use debouncing for search
config: AdvancedSearchConfig(
  animation: AdvancedSearchAnimation(
    searchDebounceDuration: Duration(milliseconds: 300),
  ),
)

// ✅ DO: Limit results for large datasets
config: AdvancedSearchConfig(
  enablePagination: true,
  resultsPerPage: 50,
)

// ✅ DO: Disable animations for better performance
config: AdvancedSearchConfig(
  enableAnimations: false,
)
```

### 2. User Experience

```dart
// ✅ DO: Show loading states
onSearch: (query, filters) async {
  // Show loading indicator
  return await fetchResults(query, filters);
}

// ✅ DO: Provide clear empty states
emptyStateBuilder: (context) {
  return Center(
    child: Text('No results found. Try different keywords.'),
  );
}

// ✅ DO: Show stats to user
config: AdvancedSearchConfig(
  showStats: true,
)
```

### 3. Accessibility

```dart
// ✅ DO: Provide semantic labels
FluentAutoSuggestBoxItem(
  value: product,
  label: product.name,
  semanticLabel: '${product.name}, ${product.category}, \$${product.price}',
)

// ✅ DO: Enable keyboard navigation
config: AdvancedSearchConfig(
  enableKeyboardNavigation: true,
  enableKeyboardShortcut: true,
  keyboardShortcut: SingleActivator(LogicalKeyboardKey.f3),
)
```

---

## 🎓 Learning Path

### Beginner

1. Start with `customization_example.dart`
2. Use a pre-built theme (blueTheme, darkTheme)
3. Basic item display

### Intermediate

1. Read `fluent_examples.dart`
2. Study ProductSearchExample
3. Implement custom item builders
4. Add Fluent UI components

### Advanced

1. Study `advanced_fluent_examples.dart`
2. Implement complex filters
3. Add multiple view modes
4. Custom toolbar actions
5. Advanced state management

---

## 📝 Code Templates

### Basic Product Search

```dart
class MyProductSearch extends StatelessWidget {
  Future<void> openSearch(BuildContext context) async {
    final result = await AdvancedSearchDialog.show<Product>(
      context: context,
      items: _getProducts(),
      onSearch: _search,
      config: AdvancedSearchCustomizationExample.blueTheme,
    );

    if (result != null) {
      // Handle selection
      print('Selected: ${result.name}');
    }
  }

  List<FluentAutoSuggestBoxItem<Product>> _getProducts() {
    // Return your products
    return [];
  }

  Future<List<FluentAutoSuggestBoxItem<Product>>> _search(
    String query,
    Map<String, dynamic> filters,
  ) async {
    // Implement search logic
    return [];
  }
}
```

### Custom Theme Template

```dart
static AdvancedSearchConfig get myCustomTheme {
  return AdvancedSearchConfig(
    title: 'My Search',
    searchHint: 'Type to search...',

    theme: AdvancedSearchTheme(
      primaryColor: Colors.blue,
      // Add your colors
    ),

    layout: AdvancedSearchLayout(
      gridCrossAxisCount: 3,
      // Add your layout
    ),

    animation: AdvancedSearchAnimation(
      dialogEnterDuration: Duration(milliseconds: 300),
      // Add your animations
    ),

    toolbarActions: [
      AdvancedSearchAction(
        icon: FluentIcons.refresh,
        onPressed: () {},
      ),
    ],
  );
}
```

---

## 🐛 Troubleshooting

### Common Issues

**Issue: Dialog doesn't show**

```dart
// ✅ Solution: Make sure you await the result
final result = await AdvancedSearchDialog.show(...);
```

**Issue: Items not filtering**

```dart
// ✅ Solution: Implement onSearch properly
onSearch: (query, filters) async {
  return items.where((item) {
    return item.label.toLowerCase().contains(query.toLowerCase());
  }).toList();
}
```

**Issue: Keyboard shortcut not working**

```dart
// ✅ Solution: Enable keyboard shortcuts
config: AdvancedSearchConfig(
  enableKeyboardShortcut: true,
  keyboardShortcut: SingleActivator(LogicalKeyboardKey.f3),
)
```

---

## 📚 Additional Resources

- [Fluent UI Documentation](https://pub.dev/packages/fluent_ui)
- [Flutter Documentation](https://flutter.dev/docs)
- [Material Design Guidelines](https://material.io/design)

---

## 🤝 Contributing

Feel free to:

- Add more examples
- Improve existing examples
- Fix bugs
- Add documentation

---

## 📄 License

These examples are part of the Genius Link Desktop App project.

---

**Happy Coding! 🚀**
