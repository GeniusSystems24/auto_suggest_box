# 🏗️ Architecture Documentation

## System Overview

```text
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│                    FluentAutoSuggestBox                         │
│                      (Main Widget)                              │
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │              │  │              │  │              │         │
│  │   TextField  │  │   Overlay    │  │  Controller  │         │
│  │              │  │              │  │              │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                          │
                          │ uses
                          ▼
        ┌─────────────────────────────────────────┐
        │                                         │
        │           Support Components            │
        │                                         │
        │  ┌──────────┐  ┌──────────┐  ┌───────┐ │
        │  │  Cache   │  │   Item   │  │ Utils │ │
        │  └──────────┘  └──────────┘  └───────┘ │
        │                                         │
        └─────────────────────────────────────────┘
```

## Component Breakdown

### 1. Main Widget (auto_suggest.dart)

**Responsibilities:**

- Widget composition and orchestration
- Event handling and delegation
- Lifecycle management
- Integration of all components

**Key Classes:**

- `FluentAutoSuggestBox` - Main widget
- `FluentAutoSuggestBoxState` - State management
- `_CommonTextFieldProps` - Helper for DRY

**Data Flow:**

```text
User Input → TextField → Controller → Debounce → Search/Sort → Cache → Overlay
     ↑                                                                     ↓
     └─────────────────────── Selection ───────────────────────────────────┘
```

---

### 2. Controller (auto_suggest_controller.dart)

**Responsibilities:**

- State management
- Debouncing logic
- Loading state tracking
- Error management

**State Model:**

```dart
class AutoSuggestController {
  String _searchQuery       // Current search text
  bool _isLoading          // Loading state
  bool _isOverlayVisible   // Overlay visibility
  Object? _lastError       // Last error occurred
  String _lastSearchLoaded // Track loaded searches
  Timer? _debounceTimer    // Debounce timer
}
```

**State Transitions:**

```text
Idle → Typing → Debouncing → Searching → Results → Idle
  ↑                              ↓
  └──────────── Error ───────────┘
```

---

### 3. Cache (auto_suggest_cache.dart)

**Responsibilities:**

- Result caching with LRU eviction
- TTL (Time To Live) management
- Cache statistics

**Cache Structure:**

```text
LinkedHashMap<String, CacheEntry>
    ↓
CacheEntry {
  results: List<T>
  timestamp: DateTime
}
```

**Cache Flow:**

```text
Query → Normalize → Check Cache
                       ↓
                  Hit? ─┬─ Yes → Return Cached Results
                       │
                       └─ No → Perform Search → Cache Results
```

**LRU Eviction:**

```text
Cache Full?
    ↓
  Yes → Remove Oldest Entry → Add New Entry
    ↓
   No → Add New Entry
```

---

### 4. Item (auto_suggest_item.dart)

**Responsibilities:**

- Item data model
- Item presentation
- Animation handling

**Component Structure:**

```text
FluentAutoSuggestBoxItem<T>  (Data Model)
    ↓
AutoSuggestItemTile  (Presentation)
    ↓
Animation Controller → Fade Animation
```

---

### 5. Overlay (auto_suggest_overlay.dart)

**Responsibilities:**

- Display search results
- Handle item selection
- Manage loading states
- Keyboard navigation

**Overlay States:**

```text
┌─────────────┐
│   Loading   │ ←──────┐
└─────────────┘        │
       ↓               │
┌─────────────┐        │
│   Results   │        │ Search
└─────────────┘        │
       ↓               │
┌─────────────┐        │
│ No Results  │ ───────┘
└─────────────┘
```

---

## Detailed Architecture

### Component Communication

```text
┌──────────────────────────────────────────────────────────────┐
│                        User Action                           │
└──────────────────────────────────────────────────────────────┘
                             │
                             ▼
┌──────────────────────────────────────────────────────────────┐
│                    FluentAutoSuggestBox                      │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │                    TextField Widget                     │ │
│  │                                                          │ │
│  │  onChanged → handleTextChanged()                        │ │
│  └────────────────────────────────────────────────────────┘ │
│                             │                                │
│                             ▼                                │
│  ┌────────────────────────────────────────────────────────┐ │
│  │              AutoSuggestController                      │ │
│  │                                                          │ │
│  │  updateSearchQuery() → debounceTimer                    │ │
│  │                             │                            │ │
│  │                             ▼                            │ │
│  │                      onDebounceComplete                  │ │
│  └────────────────────────────────────────────────────────┘ │
│                             │                                │
│                             ▼                                │
│  ┌────────────────────────────────────────────────────────┐ │
│  │              SearchResultsCache                         │ │
│  │                                                          │ │
│  │  cache.get(query) → Hit? ──┬─ Yes → Return Results     │ │
│  │                             │                            │ │
│  │                             └─ No → Continue ───┐        │ │
│  └────────────────────────────────────────────────┼────────┘ │
│                                                    │          │
│                                                    ▼          │
│  ┌────────────────────────────────────────────────────────┐ │
│  │              Server Search (Optional)                   │ │
│  │                                                          │ │
│  │  onNoResultsFound(query) → API Call                     │ │
│  │                             │                            │ │
│  │                             ▼                            │ │
│  │                      Parse Results                       │ │
│  │                             │                            │ │
│  │                             ▼                            │ │
│  │                      cache.set(results)                  │ │
│  └────────────────────────────────────────────────────────┘ │
│                             │                                │
│                             ▼                                │
│  ┌────────────────────────────────────────────────────────┐ │
│  │              AutoSuggestOverlay                         │ │
│  │                                                          │ │
│  │  Display Results → User Selects Item                    │ │
│  │                             │                            │ │
│  │                             ▼                            │ │
│  │                      onSelected(item)                    │ │
│  └────────────────────────────────────────────────────────┘ │
│                             │                                │
└─────────────────────────────┼────────────────────────────────┘
                              │
                              ▼
                      ┌──────────────┐
                      │   Callback   │
                      └──────────────┘
```

---

## Sequence Diagrams

### 1. Normal Search Flow

```text
User    TextField   Controller   Cache   Server   Overlay
 │          │           │          │        │        │
 │  Type    │           │          │        │        │
 ├─────────>│           │          │        │        │
 │          │  onChange │          │        │        │
 │          ├──────────>│          │        │        │
 │          │           │ Debounce │        │        │
 │          │           │────┐     │        │        │
 │          │           │    │     │        │        │
 │          │           │<───┘     │        │        │
 │          │           │  Check   │        │        │
 │          │           ├─────────>│        │        │
 │          │           │  Miss    │        │        │
 │          │           │<─────────┤        │        │
 │          │           │          │  Call  │        │
 │          │           ├─────────────────>│        │
 │          │           │          │ Results│        │
 │          │           │<─────────────────┤        │
 │          │           │  Store   │        │        │
 │          │           ├─────────>│        │        │
 │          │           │          │        │ Show   │
 │          │           ├────────────────────────────>│
 │          │           │          │        │        │
 │  Select  │           │          │        │        │
 │<─────────────────────────────────────────────────┤
 │          │           │          │        │        │
```

### 2. Cached Search Flow

```text
User    TextField   Controller   Cache   Overlay
 │          │           │          │        │
 │  Type    │           │          │        │
 ├─────────>│           │          │        │
 │          │  onChange │          │        │
 │          ├──────────>│          │        │
 │          │           │ Debounce │        │
 │          │           │────┐     │        │
 │          │           │<───┘     │        │
 │          │           │  Check   │        │
 │          │           ├─────────>│        │
 │          │           │   Hit!   │        │
 │          │           │<─────────┤        │
 │          │           │          │  Show  │
 │          │           ├─────────────────>│
 │          │           │          │        │
 │  Select  │           │          │        │
 │<───────────────────────────────────────┤
 │          │           │          │        │
```

### 3. Error Handling Flow

```text
User    TextField   Controller   Server   ErrorHandler
 │          │           │          │            │
 │  Type    │           │          │            │
 ├─────────>│           │          │            │
 │          │  onChange │          │            │
 │          ├──────────>│          │            │
 │          │           │  Call    │            │
 │          │           ├─────────>│            │
 │          │           │   Error  │            │
 │          │           │<─────────┤            │
 │          │           │  setError│            │
 │          │           ├────┐     │            │
 │          │           │<───┘     │            │
 │          │           │  onError │            │
 │          │           ├───────────────────────>│
 │          │           │          │  Show      │
 │  Error   │           │          │            │
 │<────────────────────────────────────────────┤
 │          │           │          │            │
```

---

## Data Flow Patterns

### 1. User Input → Results

```text
Keyboard Input
    ↓
TextField.onChanged
    ↓
Controller.updateSearchQuery
    ↓
Debounce Timer (300ms)
    ↓
Check Cache
    ├─ Hit → Return Cached Results
    └─ Miss → Search (Local or Server)
        ↓
    Store in Cache
        ↓
    Update Items
        ↓
    Sort & Filter
        ↓
    Display in Overlay
        ↓
    User Selection
        ↓
    onSelected Callback
```

### 2. Error Flow

```text
Error Occurs
    ↓
Controller.setError(error)
    ↓
NotifyListeners()
    ↓
onError Callback (if provided)
    ↓
Display Error UI
```

### 3. Cache Flow

```text
Search Query
    ↓
Normalize Query (lowercase, trim)
    ↓
Check if in Cache
    ├─ Yes → Check TTL
    │    ├─ Valid → Return Results
    │    └─ Expired → Remove & Search
    └─ No → Search
        ↓
    Store Results in Cache
        ↓
    Check Cache Size
        ├─ < Max → Done
        └─ >= Max → Evict Oldest Entry
```

---

## Threading Model

### Main Thread Operations

- UI rendering
- User input handling
- State updates
- Widget rebuilds

### Async Operations

- API calls (on background isolate)
- Cache lookup (synchronous)
- Debounce timers (on event loop)
- Animations (on UI thread)

```text
┌─────────────────────┐
│    Main Thread      │
├─────────────────────┤
│ UI Rendering        │
│ State Updates       │
│ User Input          │
│ Debouncing          │
│ Cache Lookup        │
└─────────────────────┘
          │
          │ async
          ▼
┌─────────────────────┐
│  Background Work    │
├─────────────────────┤
│ API Calls           │
│ Data Parsing        │
│ Heavy Computations  │
└─────────────────────┘
```

---

## Memory Management

### Object Lifecycle

```text
Widget Created
    ↓
initState()
    ├─ Create Controllers
    ├─ Create Cache
    ├─ Add Listeners
    └─ Initialize State
    ↓
Widget Active
    ├─ Handle User Input
    ├─ Manage Overlay
    └─ Update Cache
    ↓
Widget Disposed
    ├─ Remove Listeners
    ├─ Cancel Timers
    ├─ Close Streams
    ├─ Dispose Controllers
    └─ Clear References
    ↓
Garbage Collection
```

### Memory Optimization Strategies

1. **Lazy Loading**: Items created only when needed
2. **Viewport Culling**: Only visible items rendered
3. **Cache Limits**: Max cache size enforced
4. **TTL Cleanup**: Expired entries removed
5. **Weak References**: No circular references
6. **Proper Disposal**: All resources cleaned up

---

## Performance Characteristics

### Time Complexity

| Operation | Before | After | Improvement |
|-----------|--------|-------|-------------|
| Text Input | O(n) | O(1) | Debounced |
| Cache Lookup | N/A | O(1) | New |
| Cache Insert | N/A | O(1) | New |
| Sorting | O(n log n) | O(n log n) | Same |
| Rendering | O(n) | O(viewport) | Optimized |

### Space Complexity

| Component | Memory Usage |
|-----------|--------------|
| Cache | O(cache_size × item_size) |
| Items List | O(n × item_size) |
| Overlay | O(viewport_size) |
| Controller | O(1) |

---

## Design Patterns Used

### 1. **Controller Pattern**

- Separates business logic from UI
- Enables state management
- Testable and reusable

### 2. **Observer Pattern**

- ValueNotifier / ChangeNotifier
- Stream-based updates
- Event-driven architecture

### 3. **Strategy Pattern**

- Custom sorters
- Custom builders
- Pluggable behavior

### 4. **Factory Pattern**

- Item creation
- Cache entry creation

### 5. **Composite Pattern**

- Widget composition
- Layered UI structure

### 6. **Proxy Pattern**

- Cache as proxy to server
- Intercepts and caches requests

---

## Extension Points

### 1. Custom Sorter

```dart
Set<Item> customSorter(String text, Set<Item> items) {
  // Your custom sorting logic
}
```

### 2. Custom Builder

```dart
Widget customBuilder(BuildContext context, Item item) {
  // Your custom UI
}
```

### 3. Custom Cache Strategy

```dart
class CustomCache<T> extends SearchResultsCache<T> {
  @override
  List<T>? get(String query) {
    // Your custom caching logic
  }
}
```

### 4. Custom Controller Logic

```dart
class CustomController<T> extends AutoSuggestController<T> {
  @override
  void updateSearchQuery(String query, {required VoidCallback onComplete}) {
    // Your custom debouncing or logic
    super.updateSearchQuery(query, onComplete: onComplete);
  }
}
```

---

## Best Practices Implemented

1. ✅ **Separation of Concerns** - Each component has one responsibility
2. ✅ **DRY Principle** - No code duplication
3. ✅ **SOLID Principles** - Clean architecture
4. ✅ **Composition over Inheritance** - Flexible design
5. ✅ **Dependency Injection** - Testable components
6. ✅ **Immutability** - Where possible
7. ✅ **Error Handling** - Comprehensive error management
8. ✅ **Resource Management** - Proper cleanup
9. ✅ **Performance Optimization** - Efficient algorithms
10. ✅ **Documentation** - Well-documented code

---

## Future Architecture Considerations

### Potential Enhancements

1. **Plugin System** - Allow third-party extensions
2. **State Management Integration** - Bloc, Riverpod, etc.
3. **Persistence Layer** - Save searches to disk
4. **Analytics Integration** - Track usage patterns
5. **A/B Testing Framework** - Test variations
6. **Accessibility Layer** - Enhanced screen reader support
7. **Internationalization** - Multi-language support
8. **Theming System** - Complete theme customization

---

This architecture is designed to be:

- 🔄 **Maintainable** - Easy to update and fix
- 🧪 **Testable** - Each component can be tested independently
- 📈 **Scalable** - Can handle growing requirements
- 🔌 **Extensible** - Easy to add new features
- ⚡ **Performant** - Optimized for speed and efficiency
