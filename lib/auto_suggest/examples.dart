import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart' show TextChangedReason;
import 'package:flutter/material.dart';

import 'auto_suggest.dart';

/// 🎯 Comprehensive Examples for FluentAutoSuggestBox
/// 8 Complete Working Examples covering all major use cases

void main() {
  runApp(const ExamplesApp());
}

// ============================================================================
// Example 1: Basic Usage (Simplest Example)
// ============================================================================

class BasicExample extends StatefulWidget {
  const BasicExample({super.key});

  @override
  State<BasicExample> createState() => _BasicExampleState();
}

class _BasicExampleState extends State<BasicExample> {
  String? selectedFruit;

  @override
  Widget build(BuildContext context) {
    final items = [
      FluentAutoSuggestBoxItem(value: 'apple', label: 'Apple 🍎'),
      FluentAutoSuggestBoxItem(value: 'banana', label: 'Banana 🍌'),
      FluentAutoSuggestBoxItem(value: 'cherry', label: 'Cherry 🍒'),
      FluentAutoSuggestBoxItem(value: 'date', label: 'Date 📅'),
      FluentAutoSuggestBoxItem(value: 'elderberry', label: 'Elderberry 🫐'),
      FluentAutoSuggestBoxItem(value: 'fig', label: 'Fig 🥭'),
      FluentAutoSuggestBoxItem(value: 'grape', label: 'Grape 🍇'),
      FluentAutoSuggestBoxItem(value: 'kiwi', label: 'Kiwi 🥝'),
      FluentAutoSuggestBoxItem(value: 'mango', label: 'Mango 🥭'),
      FluentAutoSuggestBoxItem(value: 'orange', label: 'Orange 🍊'),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  'Example 1: Basic Usage',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Simple autocomplete with fruits - Type to search',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            FluentAutoSuggestBox<String>(
              items: items,
              // placeholder: 'Search for a fruit...',
              onSelected: (item) {
                setState(() {
                  selectedFruit = item?.label;
                });
                if (item != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('You selected: ${item.label}'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
            if (selectedFruit != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected Fruit',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            selectedFruit!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => setState(() => selectedFruit = null),
                      tooltip: 'Clear selection',
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Example 2: Custom Item Builder with Rich Display
// ============================================================================

class CustomItemBuilderExample extends StatefulWidget {
  const CustomItemBuilderExample({super.key});

  @override
  State<CustomItemBuilderExample> createState() =>
      _CustomItemBuilderExampleState();
}

class _CustomItemBuilderExampleState extends State<CustomItemBuilderExample> {
  Person? selectedPerson;

  final people = [
    Person(
      '1',
      'John Doe',
      'john@example.com',
      'Developer',
      '👨‍💻',
      Colors.blue,
    ),
    Person(
      '2',
      'Jane Smith',
      'jane@example.com',
      'Designer',
      '👩‍🎨',
      Colors.pink,
    ),
    Person(
      '3',
      'Bob Johnson',
      'bob@example.com',
      'Manager',
      '👨‍💼',
      Colors.orange,
    ),
    Person(
      '4',
      'Alice Williams',
      'alice@example.com',
      'Developer',
      '👩‍💻',
      Colors.blue,
    ),
    Person(
      '5',
      'Charlie Brown',
      'charlie@example.com',
      'Designer',
      '👨‍🎨',
      Colors.pink,
    ),
    Person(
      '6',
      'Diana Prince',
      'diana@example.com',
      'Team Lead',
      '👩‍💼',
      Colors.purple,
    ),
    Person(
      '7',
      'Eve Anderson',
      'eve@example.com',
      'QA Engineer',
      '👩‍🔬',
      Colors.green,
    ),
    Person(
      '8',
      'Frank Miller',
      'frank@example.com',
      'DevOps',
      '👨‍🔧',
      Colors.teal,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final items = people
        .map(
          (person) => FluentAutoSuggestBoxItem<Person>(
            value: person,
            label: person.name,
            semanticLabel: '${person.name} ${person.email} ${person.role}',
          ),
        )
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'Example 2: Custom Item Builder',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Rich item display with avatars, roles, and custom styling',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            FluentAutoSuggestBox<Person>(
              items: items,
              decoration: InputDecoration(
                hintText: 'Search by name, email, or role...',
              ),
              onSelected: (item) {
                setState(() {
                  selectedPerson = item?.value;
                });
              },
              itemBuilder: (context, item) {
                final person = item.value;
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: person.color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            person.avatar,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              person.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: person.color.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    person.role,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: person.color,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.email, size: 12, color: Colors.grey),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    person.email,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                );
              },
            ),
            if (selectedPerson != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      selectedPerson!.color.withValues(alpha: 0.1),
                      selectedPerson!.color.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selectedPerson!.color.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: selectedPerson!.color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              selectedPerson!.avatar,
                              style: TextStyle(fontSize: 32),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedPerson!.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                selectedPerson!.role,
                                style: TextStyle(
                                  color: selectedPerson!.color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                selectedPerson!.email,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () =>
                              setState(() => selectedPerson = null),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Example 3: Server Search with Caching & Performance Metrics
// ============================================================================

class ServerSearchExample extends StatefulWidget {
  const ServerSearchExample({super.key});

  @override
  State<ServerSearchExample> createState() => _ServerSearchExampleState();
}

class _ServerSearchExampleState extends State<ServerSearchExample> {
  final _controller = AutoSuggestController<Product>();
  final _cache = SearchResultsCache<FluentAutoSuggestBoxItem<Product>>();
  Product? selectedProduct;
  bool _isSearching = false;
  int _apiCallCount = 0;
  int _cacheHitCount = 0;
  int _totalSearches = 0;

  final allProducts = [
    Product('1', 'iPhone 15 Pro', 'Electronics', 999, '📱'),
    Product('2', 'MacBook Pro', 'Electronics', 2499, '💻'),
    Product('3', 'AirPods Pro', 'Electronics', 249, '🎧'),
    Product('4', 'iPad Air', 'Electronics', 599, '📱'),
    Product('5', 'Apple Watch', 'Electronics', 399, '⌚'),
    Product('6', 'Samsung Galaxy S24', 'Electronics', 899, '📱'),
    Product('7', 'Dell XPS 13', 'Electronics', 1299, '💻'),
    Product('8', 'Sony WH-1000XM5', 'Electronics', 399, '🎧'),
    Product('9', 'Nike Air Max', 'Shoes', 150, '👟'),
    Product('10', 'Adidas Ultraboost', 'Shoes', 180, '👟'),
    Product('11', 'Canon EOS R5', 'Electronics', 3899, '📷'),
    Product('12', 'PlayStation 5', 'Electronics', 499, '🎮'),
  ];

  // ignore: unused_element
  Future<List<FluentAutoSuggestBoxItem<Product>>> _searchProducts(
    String query,
  ) async {
    if (query.isEmpty) {
      return [];
    }

    setState(() => _totalSearches++);

    // Check cache first
    final cached = _cache.get(query);
    if (cached != null) {
      setState(() => _cacheHitCount++);
      return cached;
    }

    setState(() {
      _isSearching = true;
      _apiCallCount++;
    });

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    final results = allProducts
        .where(
          (p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.category.toLowerCase().contains(query.toLowerCase()),
        )
        .map(
          (p) => FluentAutoSuggestBoxItem<Product>(
            value: p,
            label: p.name,
            semanticLabel: '${p.name} ${p.category}',
          ),
        )
        .toList();

    _cache.set(query, results);

    if (mounted) {
      setState(() => _isSearching = false);
    }

    return results;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hitRate = _totalSearches > 0
        ? ((_cacheHitCount / _totalSearches) * 100).toStringAsFixed(1)
        : '0.0';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.cloud, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Example 3: Server Search with Caching',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Simulated API calls with LRU cache - Watch the performance metrics!',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FluentAutoSuggestBox<Product>(
                    autoSuggestController: _controller,
                    items: [],
                    decoration: InputDecoration(
                      hintText:
                          'Search products (try "iphone", "samsung", "nike")...',
                    ),
                    onChanged: (text, reason) async {
                      if (reason == TextChangedReason.userInput) {
                        // final results = await _searchProducts(text);
                        // _controller.items.value = results.toSet();
                      }
                    },
                    onSelected: (item) {
                      setState(() => selectedProduct = item?.value);
                    },
                    itemBuilder: (context, item) {
                      final product = item.value;
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              product.icon,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        title: Text(product.name),
                        subtitle: Text(product.category),
                        trailing: Text(
                          '\$${product.price}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_isSearching)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Searching...',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Performance Metrics',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _MetricChip(
                        icon: Icons.api,
                        label: 'API Calls',
                        value: '$_apiCallCount',
                        color: Colors.orange,
                      ),
                      _MetricChip(
                        icon: Icons.cached,
                        label: 'Cache Hits',
                        value: '$_cacheHitCount',
                        color: Colors.green,
                      ),
                      _MetricChip(
                        icon: Icons.search,
                        label: 'Total Searches',
                        value: '$_totalSearches',
                        color: Colors.blue,
                      ),
                      _MetricChip(
                        icon: Icons.speed,
                        label: 'Cache Hit Rate',
                        value: '$hitRate%',
                        color: Colors.purple,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (selectedProduct != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          selectedProduct!.icon,
                          style: TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedProduct!.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            selectedProduct!.category,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '\$${selectedProduct!.price}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => selectedProduct = null),
                      icon: Icon(Icons.close, size: 18),
                      label: Text('Clear'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withValues(alpha: 0.1),
                        foregroundColor: Colors.red,
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MetricChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Models
// ============================================================================

class Person {
  final String id;
  final String name;
  final String email;
  final String role;
  final String avatar;
  final Color color;

  Person(this.id, this.name, this.email, this.role, this.avatar, this.color);
}

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String icon;

  Product(this.id, this.name, this.category, this.price, this.icon);
}

// ============================================================================
// Demo App
// ============================================================================

class ExamplesApp extends StatelessWidget {
  const ExamplesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FluentAutoSuggestBox Examples',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const ExamplesHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ExamplesHomePage extends StatefulWidget {
  const ExamplesHomePage({super.key});

  @override
  State<ExamplesHomePage> createState() => _ExamplesHomePageState();
}

class _ExamplesHomePageState extends State<ExamplesHomePage> {
  int _selectedIndex = 0;

  final _examples = [
    ('Basic', BasicExample(), Icons.star, 'Simple autocomplete'),
    ('Custom Items', CustomItemBuilderExample(), Icons.person, 'Rich display'),
    ('Server Search', ServerSearchExample(), Icons.cloud, 'With caching'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.code, size: 28),
            SizedBox(width: 12),
            Text('FluentAutoSuggestBox Examples'),
          ],
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: _examples.map((example) {
              return NavigationRailDestination(
                icon: Icon(example.$3),
                selectedIcon: Icon(example.$3),
                label: Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Column(
                    children: [
                      Text(example.$1),
                      Text(
                        example.$4,
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Container(
              // color: Colors.grey[50],
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: _examples[_selectedIndex].$2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
