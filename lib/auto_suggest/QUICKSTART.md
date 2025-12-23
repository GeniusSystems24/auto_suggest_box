# 🚀 Quick Start Guide

## Installation

### Step 1: Add Files to Your Project

Copy these files to your project:

```text
lib/
└── widgets/
    └── auto_suggest/
        ├── auto_suggest.dart
        ├── auto_suggest_controller.dart
        ├── auto_suggest_cache.dart
        ├── auto_suggest_item.dart
        └── auto_suggest_overlay.dart
```

### Step 2: Import

```dart
import 'package:your_app/widgets/auto_suggest/auto_suggest.dart';
```

---

## ⚡ Quick Examples

### 1. Basic Usage (2 minutes)

```dart
FluentAutoSuggestBox<String>(
  items: [
    FluentAutoSuggestBoxItem(value: '1', label: 'Apple'),
    FluentAutoSuggestBoxItem(value: '2', label: 'Banana'),
    FluentAutoSuggestBoxItem(value: '3', label: 'Cherry'),
  ],
  onSelected: (item) {
    print('Selected: ${item?.label}');
  },
)
```

**That's it!** The widget now has:

- ✅ Debouncing (300ms)
- ✅ Caching enabled
- ✅ Keyboard navigation
- ✅ Loading states
- ✅ Error handling

---

### 2. With Server Search (5 minutes)

```dart
FluentAutoSuggestBox<User>(
  items: [],
  onNoResultsFound: (query) async {
    // Call your API
    final response = await http.get('/api/users?q=$query');
    final users = parseUsers(response);
    
    // Convert to items
    return users.map((user) => 
      FluentAutoSuggestBoxItem(
        value: user,
        label: user.name,
        subtitle: Text(user.email),
      )
    ).toList();
  },
  onSelected: (item) {
    if (item != null) {
      Navigator.push(context, 
        MaterialPageRoute(builder: (_) => UserProfile(item.value))
      );
    }
  },
  onError: (error, stack) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $error')),
    );
  },
)
```

---

### 3. With Form Validation (3 minutes)

```dart
final formKey = GlobalKey<FormState>();

Form(
  key: formKey,
  child: Column(
    children: [
      FluentAutoSuggestBox.form(
        items: countryItems,
        validator: (text) {
          if (text?.isEmpty ?? true) {
            return 'Please select a country';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
      ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            // Submit form
          }
        },
        child: Text('Submit'),
      ),
    ],
  ),
)
```

---

## 🎛️ Configuration Options

### Performance Tuning

```dart
FluentAutoSuggestBox(
  items: items,
  
  // Adjust debounce (default: 300ms)
  debounceDelay: Duration(milliseconds: 500),
  
  // Set minimum search length (default: 2)
  minSearchLength: 3,
  
  // Configure cache
  enableCache: true,
  cacheMaxSize: 200,
  cacheDuration: Duration(hours: 1),
)
```

### UI Customization

```dart
FluentAutoSuggestBox(
  items: items,
  
  // Custom item builder
  itemBuilder: (context, item) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(item.label),
      subtitle: item.subtitle,
    );
  },
  
  // Custom loading widget
  loadingBuilder: (context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  },
  
  // Custom no results widget
  noResultsBuilder: (context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Text('No results found'),
    );
  },
  
  // Adjust overlay
  maxPopupHeight: 300,
  tileHeight: 60,
  direction: AutoSuggestBoxDirection.below,
)
```

---

## 🎮 Using the Controller

### When to Use Controller?

Use controller when you need to:

- Access loading state in parent widget
- Programmatically reset the search
- Listen to state changes
- Implement custom logic

### Example

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final _controller = AutoSuggestController<Product>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Show loading indicator elsewhere
        ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            if (_controller.isLoading) {
              return LinearProgressIndicator();
            }
            return SizedBox.shrink();
          },
        ),
        
        // The auto suggest box
        FluentAutoSuggestBox<Product>(
          items: products,
          autoSuggestController: _controller,
          onNoResultsFound: searchProducts,
        ),
        
        // Reset button
        ElevatedButton(
          onPressed: () => _controller.reset(),
          child: Text('Reset'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

---

## 📊 Performance Tips

### 1. For Large Lists

```dart
FluentAutoSuggestBox(
  items: largeList,
  minSearchLength: 3,  // Don't search until 3 chars
  debounceDelay: Duration(milliseconds: 500),  // Wait longer
)
```

### 2. For Expensive API Calls

```dart
FluentAutoSuggestBox(
  items: [],
  enableCache: true,
  cacheMaxSize: 500,  // Cache more results
  cacheDuration: Duration(hours: 24),  // Keep cache longer
  debounceDelay: Duration(seconds: 1),  // Wait even longer
)
```

### 3. For Fast, Local Data

```dart
FluentAutoSuggestBox(
  items: localData,
  enableCache: false,  // No need to cache
  debounceDelay: Duration(milliseconds: 150),  // Respond faster
  minSearchLength: 1,  // Search from first char
)
```

---

## 🐛 Troubleshooting

### Problem: Too many API calls

**Solution:**

```dart
FluentAutoSuggestBox(
  debounceDelay: Duration(milliseconds: 800),  // Increase delay
  minSearchLength: 3,  // Require more characters
  enableCache: true,  // Enable caching
)
```

### Problem: Slow performance with large lists

**Solution:**

```dart
FluentAutoSuggestBox(
  items: items,
  sorter: (text, items) {
    // Optimize your sorter
    if (text.isEmpty) return items;
    return items.where((item) => 
      item.label.toLowerCase().startsWith(text.toLowerCase())
    ).take(50).toSet();  // Limit results
  },
)
```

### Problem: Memory issues

**Solution:**

```dart
FluentAutoSuggestBox(
  enableCache: true,
  cacheMaxSize: 50,  // Reduce cache size
  cacheDuration: Duration(minutes: 5),  // Shorter TTL
)
```

---

## ✅ Checklist for Production

- [ ] Debounce delay appropriate for your use case
- [ ] Cache enabled if using server search
- [ ] Error handling implemented
- [ ] Loading states handled
- [ ] Form validation if in a form
- [ ] Keyboard navigation tested
- [ ] Performance tested with realistic data
- [ ] Memory usage monitored
- [ ] Accessibility tested

---

## 📚 Learn More

- **README.md** - Full documentation
- **examples.dart** - 5 comprehensive examples
- **COMPARISON.md** - Performance details
- **CHANGELOG.md** - All changes

---

## 🎯 Common Patterns

### Pattern 1: Search with Fallback

```dart
FluentAutoSuggestBox(
  items: commonItems,  // Show common items first
  onNoResultsFound: (query) async {
    return await searchDatabase(query);  // Fallback to full search
  },
)
```

### Pattern 2: Recent Searches

```dart
class SearchWidget extends StatefulWidget {
  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  List<String> recentSearches = [];

  @override
  Widget build(BuildContext context) {
    return FluentAutoSuggestBox(
      items: [
        ...recentSearches.map((search) => 
          FluentAutoSuggestBoxItem(
            value: search,
            label: search,
            child: Row(
              children: [
                Icon(Icons.history),
                SizedBox(width: 8),
                Text(search),
              ],
            ),
          )
        ),
        ...allItems,
      ],
      onSelected: (item) {
        if (item != null && !recentSearches.contains(item.label)) {
          setState(() {
            recentSearches.insert(0, item.label);
            if (recentSearches.length > 5) {
              recentSearches.removeLast();
            }
          });
        }
      },
    );
  }
}
```

### Pattern 3: Infinite Scroll (Future Enhancement)

Currently not supported, but you can implement pagination:

```dart
int currentPage = 0;
List<Item> allItems = [];

FluentAutoSuggestBox(
  items: allItems.map((item) => FluentAutoSuggestBoxItem(...)).toList(),
  onNoResultsFound: (query) async {
    currentPage++;
    final newItems = await api.search(query, page: currentPage);
    allItems.addAll(newItems);
    return newItems.map((item) => FluentAutoSuggestBoxItem(...)).toList();
  },
)
```

---

## 🎉 You're Ready

Start with the basic example and gradually add features as needed. The widget is designed to be simple by default and powerful when you need it.

**Happy coding!** 🚀
