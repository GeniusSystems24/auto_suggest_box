import 'dart:async';

import 'package:auto_suggest_box/auto_suggest/auto_suggest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'auto_suggest_advanced.dart';

/// 🚀 Advanced Search Examples with F3 Dialog
/// 6 Complete Examples demonstrating all advanced features

void main() {
  runApp(const AdvancedExamplesApp());
}

// ============================================================================
// Example 1: Basic F3 Dialog
// ============================================================================

class BasicF3Example extends StatelessWidget {
  const BasicF3Example({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(
      50,
      (i) => FluentAutoSuggestBoxItem(value: 'item_$i', label: 'Item ${i + 1}', subtitle: Text('Description for item ${i + 1}')),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.search, color: Colors.blue),
                SizedBox(width: 8),
                Text('Example 1: Basic F3 Dialog', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Press F3 to open advanced search dialog',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      'F3',
                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.keyboard_arrow_right, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('Opens full-screen search dialog with 800x600 size', style: TextStyle(color: Colors.blue[900])),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AdvancedSearchExtension.withAdvancedSearch<String>(
              autoSuggestBox: FluentAutoSuggestBox<String>(
                items: items,
                decoration: InputDecoration(hintText: 'Type to search or press F3...'),

                onSelected: (item) {
                  if (item != null) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Selected: ${item.label}'), backgroundColor: Colors.green));
                  }
                },
              ),
              config: const AdvancedSearchConfig(
                title: 'Advanced Search',
                constraints: BoxConstraints(minWidth: 800, minHeight: 600),
                keyboardShortcut: SingleActivator(LogicalKeyboardKey.f3),
                enableKeyboardShortcut: true,
              ),
              onAdvancedSearch: (query, filters) async {
                await Future.delayed(const Duration(milliseconds: 300));
                return items.where((item) => item.label.toLowerCase().contains(query.toLowerCase())).toList();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Example 2: With Custom Filters (E-commerce)
// ============================================================================

class AdvancedFiltersExample extends StatefulWidget {
  const AdvancedFiltersExample({super.key});

  @override
  State<AdvancedFiltersExample> createState() => _AdvancedFiltersExampleState();
}

class _AdvancedFiltersExampleState extends State<AdvancedFiltersExample> {
  final products = List.generate(
    30,
    (i) => Product(
      id: 'prod_$i',
      name: [
        'iPhone 15 Pro',
        'MacBook Pro',
        'AirPods Pro',
        'iPad Air',
        'Apple Watch',
        'Samsung Galaxy S24',
        'Dell XPS 13',
        'Sony Headphones',
        'Nike Air Max',
        'Adidas Ultraboost',
      ][i % 10],
      category: ['Electronics', 'Clothing', 'Books', 'Home'][i % 4],
      price: 50.0 + (i * 20),
      inStock: i % 3 != 0,
      rating: 3 + (i % 3),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final items = products
        .map(
          (p) =>
              FluentAutoSuggestBoxItem<Product>(value: p, label: p.name, subtitle: Text('${p.category} - \$${p.price.toStringAsFixed(0)}')),
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
                Icon(Icons.filter_list, color: Colors.purple),
                SizedBox(width: 8),
                Text('Example 2: Advanced Filters', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'E-commerce search with category, price, and stock filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AdvancedSearchExtension.withAdvancedSearch<Product>(
                    autoSuggestBox: FluentAutoSuggestBox<Product>(
                      items: items,
                      decoration: InputDecoration(hintText: 'Search products (Press F3 for advanced filters)...'),

                      onSelected: (item) {
                        if (item != null) {
                          _showProductDetails(context, item.value);
                        }
                      },
                      itemBuilder: (context, item) {
                        final product = item.value;
                        return ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(color: Colors.purple.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                            child: Icon(Icons.shopping_bag, color: Colors.purple),
                          ),
                          title: Text(product.name),
                          subtitle: Text(product.category),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(0)}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                              ),
                              Text(
                                product.inStock ? 'In Stock' : 'Out of Stock',
                                style: TextStyle(fontSize: 11, color: product.inStock ? Colors.green : Colors.red),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    config: AdvancedSearchConfig(
                      title: 'Product Search',
                      constraints: BoxConstraints(minWidth: 900, minHeight: 650),
                      showFilters: true,
                      viewMode: AdvancedSearchViewMode.list,
                    ),
                    onAdvancedSearch: _performProductSearch,
                    filterBuilder: _buildProductFilters,
                    itemCardBuilder: _buildProductCard,
                    statsBuilder: _buildProductStats,
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.purple.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      Icon(Icons.keyboard, color: Colors.purple),
                      SizedBox(height: 4),
                      Text('F3', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<List<FluentAutoSuggestBoxItem<Product>>> _performProductSearch(String query, Map<String, dynamic> filters) async {
    await Future.delayed(const Duration(milliseconds: 300));

    var filtered = products.where((p) {
      // Text search
      if (query.isNotEmpty && !p.name.toLowerCase().contains(query.toLowerCase())) {
        return false;
      }

      // Category filter
      final category = filters['category'] as String?;
      if (category != null && category != 'All' && p.category != category) {
        return false;
      }

      // Stock filter
      final inStockOnly = filters['inStock'] as bool? ?? false;
      if (inStockOnly && !p.inStock) {
        return false;
      }

      // Price filter
      final minPrice = filters['minPrice'] as double? ?? 0;
      final maxPrice = filters['maxPrice'] as double? ?? double.infinity;
      if (p.price < minPrice || p.price > maxPrice) {
        return false;
      }

      // Rating filter
      final minRating = filters['minRating'] as int? ?? 0;
      if (p.rating < minRating) {
        return false;
      }

      return true;
    });

    return filtered
        .map(
          (p) =>
              FluentAutoSuggestBoxItem<Product>(value: p, label: p.name, subtitle: Text('${p.category} - \$${p.price.toStringAsFixed(0)}')),
        )
        .toList();
  }

  Widget _buildProductFilters(BuildContext context, Map<String, dynamic> filters, void Function(Map<String, dynamic>) onFiltersChanged) {
    final categories = ['All', 'Electronics', 'Clothing', 'Books', 'Home'];
    final selectedCategory = filters['category'] as String? ?? 'All';
    final inStockOnly = filters['inStock'] as bool? ?? false;
    final minPrice = filters['minPrice'] as double? ?? 0;
    final maxPrice = filters['maxPrice'] as double? ?? 1000;
    final minRating = filters['minRating'] as int? ?? 0;

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),

          // Category Filter
          Text('Category', style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: categories.map((category) {
              return ChoiceChip(
                label: Text(category),
                selected: selectedCategory == category,
                onSelected: (selected) {
                  if (selected) {
                    final newFilters = Map<String, dynamic>.from(filters);
                    newFilters['category'] = category;
                    onFiltersChanged(newFilters);
                  }
                },
              );
            }).toList(),
          ),
          SizedBox(height: 16),

          // Price Range
          Text('Price Range: \$${minPrice.toInt()} - \$${maxPrice.toInt()}'),
          RangeSlider(
            values: RangeValues(minPrice, maxPrice),
            min: 0,
            max: 1000,
            divisions: 20,
            labels: RangeLabels('\$${minPrice.toInt()}', '\$${maxPrice.toInt()}'),
            onChanged: (values) {
              final newFilters = Map<String, dynamic>.from(filters);
              newFilters['minPrice'] = values.start;
              newFilters['maxPrice'] = values.end;
              onFiltersChanged(newFilters);
            },
          ),
          SizedBox(height: 16),

          // Rating Filter
          Text('Minimum Rating'),
          Slider(
            value: minRating.toDouble(),
            min: 0,
            max: 5,
            divisions: 5,
            label: '$minRating ⭐',
            onChanged: (value) {
              final newFilters = Map<String, dynamic>.from(filters);
              newFilters['minRating'] = value.toInt();
              onFiltersChanged(newFilters);
            },
          ),
          SizedBox(height: 8),

          // Stock Filter
          CheckboxListTile(
            title: Text('In Stock Only'),
            value: inStockOnly,
            onChanged: (value) {
              final newFilters = Map<String, dynamic>.from(filters);
              newFilters['inStock'] = value ?? false;
              onFiltersChanged(newFilters);
            },
            dense: true,
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, FluentAutoSuggestBoxItem<Product> item, bool isSelected) {
    final product = item.value;
    final theme = Theme.of(context);

    return Card(
      color: isSelected ? theme.primaryColor.withValues(alpha: 0.1) : null,
      elevation: isSelected ? 8 : 2,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop(item);
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag, size: 48, color: theme.primaryColor),
              SizedBox(height: 12),
              Text(
                product.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Text(product.category, style: TextStyle(fontSize: 12)),
              SizedBox(height: 4),
              Text(
                '\$${product.price.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) => Icon(i < product.rating ? Icons.star : Icons.star_border, size: 14, color: Colors.amber)),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: product.inStock ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  product.inStock ? 'In Stock' : 'Out of Stock',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: product.inStock ? Colors.green : Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductStats(BuildContext context, int totalResults, int displayedResults, String query, Duration searchDuration) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.1),
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(8)),
            child: Text(
              '$totalResults',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Products Found', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Search in ${searchDuration.inMilliseconds}ms', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  void _showProductDetails(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${product.category}'),
            Text('Price: \$${product.price.toStringAsFixed(2)}'),
            Text('Rating: ${'⭐' * product.rating}'),
            Text('Status: ${product.inStock ? "In Stock" : "Out of Stock"}'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Close'))],
      ),
    );
  }
}

// ============================================================================
// Example 3: Multi-Select Mode
// ============================================================================

class MultiSelectExample extends StatefulWidget {
  const MultiSelectExample({super.key});

  @override
  State<MultiSelectExample> createState() => _MultiSelectExampleState();
}

class _MultiSelectExampleState extends State<MultiSelectExample> {
  final List<String> _selectedTags = [];

  @override
  Widget build(BuildContext context) {
    final tags = [
      'Flutter',
      'Dart',
      'Mobile',
      'Web',
      'Desktop',
      'Firebase',
      'UI/UX',
      'Backend',
      'API',
      'Database',
      'Cloud',
      'DevOps',
      'Testing',
      'Security',
      'Performance',
      'React',
      'Vue',
      'Angular',
      'Node.js',
      'Python',
    ];

    final items = tags.map((tag) => FluentAutoSuggestBoxItem<String>(value: tag, label: tag)).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_box, color: Colors.green),
                SizedBox(width: 8),
                Text('Example 3: Multi-Select Mode', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Select multiple tags (max 5) using F3 dialog',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                final results = await AdvancedSearchDialog.showMultiSelect<String>(
                  context: context,
                  items: items,
                  maxSelections: 5,
                  onSearch: (query, filters) async {
                    await Future.delayed(const Duration(milliseconds: 200));
                    return items.where((item) => item.label.toLowerCase().contains(query.toLowerCase())).toList();
                  },
                  config: AdvancedSearchConfig(
                    title: 'Select Tags (Max 5)',

                    constraints: BoxConstraints(minWidth: 700, minHeight: 500),
                    viewMode: AdvancedSearchViewMode.grid,
                  ),
                );

                if (results != null) {
                  setState(() {
                    _selectedTags.clear();
                    _selectedTags.addAll(results);
                  });
                }
              },
              icon: Icon(Icons.add),
              label: Text('Select Tags (F3)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
            if (_selectedTags.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('Selected Tags (${_selectedTags.length}/5):', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedTags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    onDeleted: () {
                      setState(() {
                        _selectedTags.remove(tag);
                      });
                    },
                    backgroundColor: Colors.green.withValues(alpha: 0.2),
                    deleteIconColor: Colors.green,
                  );
                }).toList(),
              ),
            ] else
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Center(
                  child: Text(
                    'No tags selected. Click the button above to select.',
                    style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Continue with more examples in next message due to length...

// ============================================================================
// Models
// ============================================================================

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final bool inStock;
  final int rating;

  Product({required this.id, required this.name, required this.category, required this.price, required this.inStock, required this.rating});
}

// ============================================================================
// Demo App
// ============================================================================

class AdvancedExamplesApp extends StatelessWidget {
  const AdvancedExamplesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Search Examples',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const AdvancedExamplesHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AdvancedExamplesHome extends StatefulWidget {
  const AdvancedExamplesHome({super.key});

  @override
  State<AdvancedExamplesHome> createState() => _AdvancedExamplesHomeState();
}

class _AdvancedExamplesHomeState extends State<AdvancedExamplesHome> {
  int _selectedIndex = 0;

  final _examples = [
    ('Basic F3', BasicF3Example(), Icons.search),
    ('With Filters', AdvancedFiltersExample(), Icons.filter_list),
    ('Multi-Select', MultiSelectExample(), Icons.check_box),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [Icon(Icons.rocket_launch), SizedBox(width: 12), Text('Advanced Search Examples')]),
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
              return NavigationRailDestination(icon: Icon(example.$3), label: Text(example.$1));
            }).toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: SingleChildScrollView(padding: const EdgeInsets.all(32), child: _examples[_selectedIndex].$2),
          ),
        ],
      ),
    );
  }
}
