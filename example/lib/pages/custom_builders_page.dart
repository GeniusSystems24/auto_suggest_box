import 'package:fluent_ui/fluent_ui.dart';
import 'package:auto_suggest_box/auto_suggest/auto_suggest.dart';
import 'package:flutter/material.dart' show InputDecoration;
import 'package:gap/gap.dart';

import '../data/sample_data.dart';

class CustomBuildersPage extends StatefulWidget {
  const CustomBuildersPage({super.key});

  @override
  State<CustomBuildersPage> createState() => _CustomBuildersPageState();
}

class _CustomBuildersPageState extends State<CustomBuildersPage> {
  Product? _selectedProduct;
  User? _selectedUser;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('Custom Builders'),
      ),
      children: [
        _buildInfoCard(
          'Custom Item Builder',
          'Fully customize how each suggestion item is displayed.',
        ),
        const Gap(16),
        _buildCustomItemExample(),
        const Gap(32),
        _buildInfoCard(
          'Custom Loading & Empty States',
          'Customize loading indicator and empty results message.',
        ),
        const Gap(16),
        _buildCustomStateBuilders(),
        const Gap(32),
        _buildInfoCard(
          'Custom Sorter',
          'Implement custom matching and sorting logic.',
        ),
        const Gap(16),
        _buildCustomSorterExample(),
      ],
    );
  }

  Widget _buildInfoCard(String title, String description) {
    return InfoBar(
      title: Text(title),
      content: Text(description),
      severity: InfoBarSeverity.info,
    );
  }

  Widget _buildCustomItemExample() {
    final theme = FluentTheme.of(context);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Search with Custom Card',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Gap(8),
          FluentAutoSuggestBox<Product>(
            items: sampleProducts
                .map((p) => FluentAutoSuggestBoxItem(
                      value: p,
                      label: p.name,
                    ))
                .toList(),
            itemBuilder: (context, item) {
              final product = item.value;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: HoverButton(
                  onPressed: () {},
                  builder: (context, states) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: states.isHovered
                            ? theme.accentColor.withOpacity(0.1)
                            : null,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: states.isHovered
                              ? theme.accentColor
                              : theme.resources.dividerStrokeColorDefault,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: theme.accentColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getCategoryIcon(product.category),
                              color: theme.accentColor,
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  product.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.typography.body?.color
                                        ?.withOpacity(0.7),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.accentColor,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: product.inStock
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  product.inStock ? 'In Stock' : 'Out of Stock',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: product.inStock
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
            tileHeight: 80,
            onSelected: (item) {
              setState(() => _selectedProduct = item?.value);
            },
            decoration: const InputDecoration(
              hintText: 'Search products...',
            ),
          ),
          if (_selectedProduct != null) ...[
            const Gap(16),
            InfoBar(
              title: Text('Selected: ${_selectedProduct!.name}'),
              content: Text('\$${_selectedProduct!.price.toStringAsFixed(2)}'),
              severity: InfoBarSeverity.success,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomStateBuilders() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Search with Custom States',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Gap(8),
          FluentAutoSuggestBox<User>(
            items: const [],
            onNoResultsFound: (query) async {
              await Future.delayed(const Duration(seconds: 1));
              return searchUsers(query).then(
                (users) => users
                    .map((u) => FluentAutoSuggestBoxItem(
                          value: u,
                          label: u.name,
                        ))
                    .toList(),
              );
            },
            loadingBuilder: (context) {
              return Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ProgressRing(),
                    const Gap(12),
                    Text(
                      'Searching users...',
                      style: TextStyle(
                        color: FluentTheme.of(context).typography.body?.color,
                      ),
                    ),
                  ],
                ),
              );
            },
            noResultsFoundBuilder: (context) {
              return Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FluentIcons.emoji_neutral,
                      size: 48,
                      color: FluentTheme.of(context).accentColor,
                    ),
                    const Gap(12),
                    const Text(
                      'No users found',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Gap(4),
                    const Text(
                      'Try a different search term',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            },
            onSelected: (item) {
              setState(() => _selectedUser = item?.value);
            },
            decoration: const InputDecoration(
              hintText: 'Search users...',
            ),
          ),
          if (_selectedUser != null) ...[
            const Gap(16),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: FluentTheme.of(context).accentColor,
                child: Text(
                  _selectedUser!.avatar,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(_selectedUser!.name),
              subtitle: Text(_selectedUser!.email),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomSorterExample() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Custom Fuzzy Search',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Gap(8),
          const Text(
            'This sorter matches products by name OR category, and prioritizes exact matches.',
            style: TextStyle(fontSize: 12),
          ),
          const Gap(8),
          FluentAutoSuggestBox<Product>(
            items: sampleProducts
                .map((p) => FluentAutoSuggestBoxItem(
                      value: p,
                      label: p.name,
                      subtitle: Text(p.category),
                    ))
                .toList(),
            sorter: (query, items) {
              if (query.isEmpty) return items;

              final lowerQuery = query.toLowerCase();

              // Filter and sort by relevance
              final matches = items.where((item) {
                final product = item.value;
                return product.name.toLowerCase().contains(lowerQuery) ||
                    product.category.toLowerCase().contains(lowerQuery) ||
                    product.description.toLowerCase().contains(lowerQuery);
              }).toList();

              // Sort: exact name match > starts with > contains
              matches.sort((a, b) {
                final aName = a.value.name.toLowerCase();
                final bName = b.value.name.toLowerCase();

                // Exact match first
                if (aName == lowerQuery) return -1;
                if (bName == lowerQuery) return 1;

                // Starts with second
                if (aName.startsWith(lowerQuery) && !bName.startsWith(lowerQuery)) {
                  return -1;
                }
                if (bName.startsWith(lowerQuery) && !aName.startsWith(lowerQuery)) {
                  return 1;
                }

                // Alphabetical
                return aName.compareTo(bName);
              });

              return matches.toSet();
            },
            onSelected: (item) {
              displayInfoBar(
                context,
                builder: (context, close) {
                  return InfoBar(
                    title: Text('Selected: ${item?.label}'),
                    content: Text('Category: ${item?.value.category}'),
                    severity: InfoBarSeverity.success,
                    action: IconButton(
                      icon: const Icon(FluentIcons.clear),
                      onPressed: close,
                    ),
                  );
                },
              );
            },
            decoration: const InputDecoration(
              hintText: 'Try "gaming" or "phone"...',
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return FluentIcons.devices2;
      case 'footwear':
        return FluentIcons.running;
      case 'clothing':
        return FluentIcons.shirt;
      case 'gaming':
        return FluentIcons.game;
      case 'home':
        return FluentIcons.home;
      default:
        return FluentIcons.product_catalog;
    }
  }
}
