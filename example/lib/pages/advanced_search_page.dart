import 'package:fluent_ui/fluent_ui.dart';
import 'package:auto_suggest_box/auto_suggest/auto_suggest.dart';
import 'package:auto_suggest_box/advanced_auto_suggest/auto_suggest_advanced.dart';
import 'package:flutter/material.dart' show Chip;
import 'package:gap/gap.dart';
import 'package:flutter/services.dart';

import '../data/sample_data.dart';

class AdvancedSearchPage extends StatefulWidget {
  const AdvancedSearchPage({super.key});

  @override
  State<AdvancedSearchPage> createState() => _AdvancedSearchPageState();
}

class _AdvancedSearchPageState extends State<AdvancedSearchPage> {
  Product? _selectedProduct;
  List<Product> _selectedProducts = [];
  AdvancedSearchViewMode _viewMode = AdvancedSearchViewMode.list;

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.f3): _openAdvancedSearch,
      },
      child: Focus(
        autofocus: true,
        child: ScaffoldPage.scrollable(
          header: const PageHeader(
            title: Text('Advanced Search Dialog'),
          ),
          children: [
            _buildInfoCard(
              'Advanced Search',
              'Press F3 or click the button to open advanced search dialog.',
            ),
            const Gap(16),
            _buildBasicAdvancedSearch(),
            const Gap(32),
            _buildInfoCard(
              'Multi-Select Mode',
              'Select multiple items with checkboxes.',
            ),
            const Gap(16),
            _buildMultiSelectSearch(),
            const Gap(32),
            _buildInfoCard(
              'View Modes',
              'Switch between List, Grid, and Compact views.',
            ),
            const Gap(16),
            _buildViewModeDemo(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String description) {
    return InfoBar(
      title: Text(title),
      content: Text(description),
      severity: InfoBarSeverity.info,
    );
  }

  Widget _buildBasicAdvancedSearch() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Single Selection Search',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  const Icon(FluentIcons.keyboard_classic, size: 14),
                  const Gap(4),
                  const Text('F3', style: TextStyle(fontSize: 12)),
                  const Gap(8),
                  FilledButton(
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(FluentIcons.search, size: 14),
                        Gap(8),
                        Text('Open Search'),
                      ],
                    ),
                    onPressed: _openAdvancedSearch,
                  ),
                ],
              ),
            ],
          ),
          const Gap(16),
          if (_selectedProduct != null)
            Card(
              backgroundColor:
                  FluentTheme.of(context).accentColor.withOpacity(0.1),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: FluentTheme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(FluentIcons.product_catalog,
                        color: Colors.white),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedProduct!.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(_selectedProduct!.category),
                      ],
                    ),
                  ),
                  Text(
                    '\$${_selectedProduct!.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: FluentTheme.of(context).accentColor,
                    ),
                  ),
                ],
              ),
            )
          else
            const Text('No product selected. Press F3 to search.'),
        ],
      ),
    );
  }

  Widget _buildMultiSelectSearch() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Multi-Selection Search',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              FilledButton(
                onPressed: _openMultiSelectSearch,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FluentIcons.checkbox_composite, size: 14),
                    Gap(8),
                    Text('Select Products'),
                  ],
                ),
              ),
            ],
          ),
          const Gap(16),
          if (_selectedProducts.isNotEmpty) ...[
            Text('Selected ${_selectedProducts.length} products:'),
            const Gap(8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedProducts
                  .map((p) => Chip(
                        label: Text(p.name),
                        onDeleted: () {
                          setState(() {
                            _selectedProducts.remove(p);
                          });
                        },
                      ))
                  .toList(),
            ),
            const Gap(8),
            Text(
              'Total: \$${_selectedProducts.fold<double>(0, (sum, p) => sum + p.price).toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: FluentTheme.of(context).accentColor,
              ),
            ),
          ] else
            const Text('No products selected.'),
        ],
      ),
    );
  }

  Widget _buildViewModeDemo() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'View Mode Selection',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Gap(16),
          Row(
            children: [
              _buildViewModeButton(
                AdvancedSearchViewMode.list,
                FluentIcons.view_list,
                'List',
              ),
              const Gap(8),
              _buildViewModeButton(
                AdvancedSearchViewMode.grid,
                FluentIcons.grid_view_medium,
                'Grid',
              ),
              const Gap(8),
              _buildViewModeButton(
                AdvancedSearchViewMode.compact,
                FluentIcons.view_dashboard,
                'Compact',
              ),
              const Spacer(),
              Button(
                child: const Text('Open with Selected Mode'),
                onPressed: () => _openAdvancedSearchWithMode(_viewMode),
              ),
            ],
          ),
          const Gap(16),
          InfoBar(
            title: Text('Current Mode: ${_viewMode.name}'),
            content: const Text(
              'Click the button to open search dialog with the selected view mode.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewModeButton(
    AdvancedSearchViewMode mode,
    IconData icon,
    String label,
  ) {
    final isSelected = _viewMode == mode;

    return ToggleButton(
      checked: isSelected,
      onChanged: (_) => setState(() => _viewMode = mode),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const Gap(8),
          Text(label),
        ],
      ),
    );
  }

  Future<void> _openAdvancedSearch() async {
    final result = await AdvancedSearchDialog.show<Product>(
      context: context,
      items: sampleProducts
          .map((p) => FluentAutoSuggestBoxItem(
                value: p,
                label: p.name,
                subtitle: Text('${p.category} - \$${p.price.toStringAsFixed(2)}'),
              ))
          .toList(),
      onSearch: (query, filters) async {
        await Future.delayed(const Duration(milliseconds: 300));
        if (query.isEmpty) {
          return sampleProducts
              .map((p) => FluentAutoSuggestBoxItem(
                    value: p,
                    label: p.name,
                    subtitle:
                        Text('${p.category} - \$${p.price.toStringAsFixed(2)}'),
                  ))
              .toList();
        }
        return sampleProducts
            .where((p) =>
                p.name.toLowerCase().contains(query.toLowerCase()) ||
                p.category.toLowerCase().contains(query.toLowerCase()))
            .map((p) => FluentAutoSuggestBoxItem(
                  value: p,
                  label: p.name,
                  subtitle:
                      Text('${p.category} - \$${p.price.toStringAsFixed(2)}'),
                ))
            .toList();
      },
      config: const AdvancedSearchConfig(
        title: 'Find Product',
        searchHint: 'Search by name or category...',
        showStats: true,
        enableViewModeSwitch: true,
      ),
    );

    if (result != null) {
      setState(() => _selectedProduct = result);
    }
  }

  Future<void> _openMultiSelectSearch() async {
    final results = await AdvancedSearchDialog.showMultiSelect<Product>(
      context: context,
      items: sampleProducts
          .map((p) => FluentAutoSuggestBoxItem(
                value: p,
                label: p.name,
                subtitle: Text('\$${p.price.toStringAsFixed(2)}'),
              ))
          .toList(),
      onSearch: (query, filters) async {
        await Future.delayed(const Duration(milliseconds: 200));
        if (query.isEmpty) {
          return sampleProducts
              .map((p) => FluentAutoSuggestBoxItem(
                    value: p,
                    label: p.name,
                    subtitle: Text('\$${p.price.toStringAsFixed(2)}'),
                  ))
              .toList();
        }
        return sampleProducts
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .map((p) => FluentAutoSuggestBoxItem(
                  value: p,
                  label: p.name,
                  subtitle: Text('\$${p.price.toStringAsFixed(2)}'),
                ))
            .toList();
      },
      maxSelections: 5,
      config: const AdvancedSearchConfig(
        title: 'Select Products',
        searchHint: 'Search products...',
        showStats: true,
      ),
    );

    if (results != null && results.isNotEmpty) {
      setState(() => _selectedProducts = results);
    }
  }

  Future<void> _openAdvancedSearchWithMode(AdvancedSearchViewMode mode) async {
    final result = await AdvancedSearchDialog.show<Product>(
      context: context,
      items: sampleProducts
          .map((p) => FluentAutoSuggestBoxItem(
                value: p,
                label: p.name,
                subtitle: Text(p.category),
              ))
          .toList(),
      onSearch: (query, filters) async {
        await Future.delayed(const Duration(milliseconds: 200));
        return sampleProducts
            .where((p) =>
                query.isEmpty ||
                p.name.toLowerCase().contains(query.toLowerCase()))
            .map((p) => FluentAutoSuggestBoxItem(
                  value: p,
                  label: p.name,
                  subtitle: Text(p.category),
                ))
            .toList();
      },
      config: AdvancedSearchConfig(
        title: 'Products (${mode.name} view)',
        searchHint: 'Search...',
        viewMode: mode,
        enableViewModeSwitch: true,
        showStats: true,
      ),
    );

    if (result != null) {
      setState(() => _selectedProduct = result);
    }
  }
}
