import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material show TimeOfDay, RangeValues;

import 'auto_suggest_advanced.dart';

/// Advanced Fluent UI Examples with Complex Interactions
///
/// This file demonstrates:
/// - Complex forms with multiple Fluent UI components
/// - Advanced filtering and sorting
/// - Real-time search with filters
/// - Data visualization with Fluent UI
/// - Interactive dashboards

// ============================================================================
// Example 1: Advanced Product Catalog with Filters
// ============================================================================

class AdvancedProductCatalog extends StatefulWidget {
  const AdvancedProductCatalog({super.key});

  @override
  State<AdvancedProductCatalog> createState() => _AdvancedProductCatalogState();
}

class _AdvancedProductCatalogState extends State<AdvancedProductCatalog> {
  String selectedCategory = 'All';
  material.RangeValues priceRange = const material.RangeValues(0, 2000);
  double minRating = 0;
  bool inStockOnly = false;
  String sortBy = 'name';

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(title: Text('Product Catalog')),
      content: Row(
        children: [
          // Filters Sidebar
          Container(
            width: 280,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: FluentTheme.of(context).cardColor,
              border: Border(
                right: BorderSide(
                  color: FluentTheme.of(
                    context,
                  ).resources.dividerStrokeColorDefault,
                ),
              ),
            ),
            child: _buildFiltersPanel(),
          ),

          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildQuickFilters(),
                  const SizedBox(height: 16),
                  Expanded(child: _buildProductGrid()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersPanel() {
    final theme = FluentTheme.of(context);

    return ListView(
      children: [
        Text('Filters', style: theme.typography.subtitle),
        const SizedBox(height: 16),

        // Category Filter
        Expander(
          header: const Text('Category'),
          initiallyExpanded: true,
          content: Column(
            children:
                [
                  'All',
                  'Electronics',
                  'Accessories',
                  'Audio',
                  'Office',
                  'Furniture',
                ].map((category) {
                  return RadioButton(
                    checked: selectedCategory == category,
                    onChanged: (checked) {
                      if (checked) {
                        setState(() => selectedCategory = category);
                      }
                    },
                    content: Text(category),
                  );
                }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        // Price Range Filter
        Expander(
          header: const Text('Price Range'),
          initiallyExpanded: true,
          content: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${priceRange.start.round()} - \$${priceRange.end.round()}',
                  style: theme.typography.bodyStrong,
                ),
                const SizedBox(height: 8),
                Slider(
                  min: 0,
                  max: 2000,
                  value: priceRange.start,
                  onChanged: (value) {
                    setState(() {
                      priceRange = material.RangeValues(value, priceRange.end);
                    });
                  },
                  label: '\$${priceRange.start.round()}',
                ),
                Slider(
                  min: 0,
                  max: 2000,
                  value: priceRange.end,
                  onChanged: (value) {
                    setState(() {
                      priceRange = material.RangeValues(
                        priceRange.start,
                        value,
                      );
                    });
                  },
                  label: '\$${priceRange.end.round()}',
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Rating Filter
        Expander(
          header: const Text('Minimum Rating'),
          initiallyExpanded: true,
          content: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                RatingBar(
                  rating: minRating,
                  onChanged: (rating) {
                    setState(() => minRating = rating);
                  },
                  amount: 5,
                ),
                const SizedBox(height: 8),
                Text('${minRating.toStringAsFixed(1)} stars & up'),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Stock Filter
        Expander(
          header: const Text('Availability'),
          content: Padding(
            padding: const EdgeInsets.all(12),
            child: Checkbox(
              checked: inStockOnly,
              onChanged: (checked) {
                setState(() => inStockOnly = checked ?? false);
              },
              content: const Text('In Stock Only'),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Reset Button
        FilledButton(
          onPressed: _resetFilters,
          child: const Text('Reset Filters'),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: _openAdvancedSearch,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(FluentIcons.search, size: 16),
                SizedBox(width: 8),
                Text('Advanced Search'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        ComboBox<String>(
          placeholder: const Text('Sort by'),
          value: sortBy,
          items: const [
            ComboBoxItem(value: 'name', child: Text('Name')),
            ComboBoxItem(value: 'price_low', child: Text('Price: Low to High')),
            ComboBoxItem(
              value: 'price_high',
              child: Text('Price: High to Low'),
            ),
            ComboBoxItem(value: 'rating', child: Text('Rating')),
            ComboBoxItem(value: 'newest', child: Text('Newest')),
          ],
          onChanged: (value) {
            setState(() => sortBy = value ?? 'name');
          },
        ),
      ],
    );
  }

  Widget _buildQuickFilters() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (selectedCategory != 'All')
          _buildFilterChip(
            'Category: $selectedCategory',
            () => setState(() => selectedCategory = 'All'),
          ),
        if (priceRange.start > 0 || priceRange.end < 2000)
          _buildFilterChip(
            'Price: \$${priceRange.start.round()}-\$${priceRange.end.round()}',
            () => setState(
              () => priceRange = const material.RangeValues(0, 2000),
            ),
          ),
        if (minRating > 0)
          _buildFilterChip(
            'Rating: ${minRating.toStringAsFixed(1)}+',
            () => setState(() => minRating = 0),
          ),
        if (inStockOnly)
          _buildFilterChip(
            'In Stock Only',
            () => setState(() => inStockOnly = false),
          ),
      ],
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: FluentTheme.of(context).accentColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: FluentTheme.of(context).accentColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              FluentIcons.cancel,
              size: 14,
              color: FluentTheme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: 9,
      itemBuilder: (context, index) => _buildProductCard(index),
    );
  }

  Widget _buildProductCard(int index) {
    final theme = FluentTheme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Icon(
                  FluentIcons.product,
                  size: 64,
                  color: theme.accentColor.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Product ${index + 1}',
              style: theme.typography.bodyStrong,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '\$${(index + 1) * 99.99}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.accentColor,
              ),
            ),
            const SizedBox(height: 8),
            RatingBar(rating: 4.0, amount: 5, starSpacing: 2, iconSize: 14),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                child: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      selectedCategory = 'All';
      priceRange = const material.RangeValues(0, 2000);
      minRating = 0;
      inStockOnly = false;
    });
  }

  Future<void> _openAdvancedSearch() async {
    await AdvancedSearchDialog.show(
      context: context,
      items: [],
      onSearch: (query, filters) async {
        await Future.delayed(const Duration(milliseconds: 300));
        return [];
      },
      config: AdvancedSearchConfig(
        title: 'Advanced Product Search',
        theme: AdvancedSearchTheme(
          primaryColor: FluentTheme.of(context).accentColor,
          borderRadius: BorderRadius.circular(12),
        ),
        showFilters: true,
        showStats: true,
      ),
      filterBuilder: (context, filters, onFiltersChanged) {
        return _buildAdvancedFilters(filters, onFiltersChanged);
      },
    );
  }

  Widget _buildAdvancedFilters(
    Map<String, dynamic> filters,
    Function(Map<String, dynamic>) onFiltersChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Advanced Filters',
          style: FluentTheme.of(context).typography.subtitle,
        ),
        const SizedBox(height: 16),
        // Add more complex filter widgets here
      ],
    );
  }
}

// ============================================================================
// Example 2: Task Manager with Date/Time Pickers
// ============================================================================

class TaskManagerExample extends StatefulWidget {
  const TaskManagerExample({super.key});

  @override
  State<TaskManagerExample> createState() => _TaskManagerExampleState();
}

class _TaskManagerExampleState extends State<TaskManagerExample> {
  DateTime? selectedDate;
  material.TimeOfDay? selectedTime;
  String priority = 'Medium';
  String status = 'Pending';

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Task Manager'),
        commandBar: CommandBar(
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.add),
              label: const Text('New Task'),
              onPressed: _showNewTaskDialog,
            ),
            CommandBarButton(
              icon: const Icon(FluentIcons.search),
              label: const Text('Search'),
              onPressed: _openTaskSearch,
            ),
          ],
        ),
      ),
      content: _buildTaskList(),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) => _buildTaskCard(index),
    );
  }

  Widget _buildTaskCard(int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Checkbox(checked: index % 3 == 0, onChanged: (checked) {}),
        title: Text('Task ${index + 1}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Due: ${DateTime.now().add(Duration(days: index)).toString().split(' ')[0]}',
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildPriorityBadge(
                  index % 3 == 0
                      ? 'High'
                      : index % 3 == 1
                      ? 'Medium'
                      : 'Low',
                ),
                const SizedBox(width: 8),
                _buildStatusBadge(index % 2 == 0 ? 'Pending' : 'Completed'),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(FluentIcons.more),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(String priority) {
    Color color;
    switch (priority) {
      case 'High':
        color = const Color(0xFFEF4444);
        break;
      case 'Medium':
        color = const Color(0xFFF59E0B);
        break;
      default:
        color = const Color(0xFF10B981);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        priority,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = status == 'Completed'
        ? const Color(0xFF10B981)
        : const Color(0xFF3B82F6);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _showNewTaskDialog() async {
    await showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextBox(placeholder: 'Task title'),
            const SizedBox(height: 16),
            const TextBox(placeholder: 'Description', maxLines: 3),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DatePicker(
                    selected: selectedDate,
                    onChanged: (date) {
                      setState(() => selectedDate = date);
                    },
                    header: 'Due Date',
                  ),
                ),
                const SizedBox(width: 12),
                // Expanded(
                //   child: TimePicker(
                //     selected: selectedTime,
                //     onChanged: (time) {
                //       setState(() => selectedTime = time);
                //     },
                //     header: 'Time',
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 16),
            ComboBox<String>(
              placeholder: const Text('Priority'),
              value: priority,
              items: const [
                ComboBoxItem(value: 'Low', child: Text('Low')),
                ComboBoxItem(value: 'Medium', child: Text('Medium')),
                ComboBoxItem(value: 'High', child: Text('High')),
              ],
              onChanged: (value) {
                setState(() => priority = value ?? 'Medium');
              },
            ),
          ],
        ),
        actions: [
          Button(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _openTaskSearch() async {
    await AdvancedSearchDialog.show(
      context: context,
      items: [],
      onSearch: (query, filters) async {
        await Future.delayed(const Duration(milliseconds: 200));
        return [];
      },
      config: AdvancedSearchConfig(
        title: 'Search Tasks',
        theme: AdvancedSearchTheme(
          primaryColor: FluentTheme.of(context).accentColor,
        ),
      ),
    );
  }
}

// ============================================================================
// Example 3: Settings Panel with Toggle Switches
// ============================================================================

class SettingsPanelExample extends StatefulWidget {
  const SettingsPanelExample({super.key});

  @override
  State<SettingsPanelExample> createState() => _SettingsPanelExampleState();
}

class _SettingsPanelExampleState extends State<SettingsPanelExample> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  bool autoSaveEnabled = true;
  bool soundEnabled = true;
  double volume = 50;
  String language = 'English';
  String theme = 'Light';

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(title: Text('Settings')),
      content: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSettingsSection('General', [
            _buildToggleSetting(
              'Notifications',
              'Receive notifications for updates',
              notificationsEnabled,
              (value) => setState(() => notificationsEnabled = value),
            ),
            _buildToggleSetting(
              'Auto Save',
              'Automatically save changes',
              autoSaveEnabled,
              (value) => setState(() => autoSaveEnabled = value),
            ),
            _buildComboSetting(
              'Language',
              language,
              ['English', 'Arabic', 'French', 'Spanish'],
              (value) => setState(() => language = value ?? 'English'),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSettingsSection('Appearance', [
            _buildToggleSetting(
              'Dark Mode',
              'Use dark theme',
              darkModeEnabled,
              (value) => setState(() => darkModeEnabled = value),
            ),
            _buildComboSetting('Theme', theme, [
              'Light',
              'Dark',
              'Auto',
            ], (value) => setState(() => theme = value ?? 'Light')),
          ]),
          const SizedBox(height: 24),
          _buildSettingsSection('Audio', [
            _buildToggleSetting(
              'Sound',
              'Enable sound effects',
              soundEnabled,
              (value) => setState(() => soundEnabled = value),
            ),
            _buildSliderSetting(
              'Volume',
              volume,
              (value) => setState(() => volume = value),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    final theme = FluentTheme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.typography.subtitle),
            const SizedBox(height: 16),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSetting(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: FluentTheme.of(context).typography.body),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: FluentTheme.of(context).typography.caption,
                ),
              ],
            ),
          ),
          ToggleSwitch(checked: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildComboSetting(
    String title,
    String value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: FluentTheme.of(context).typography.body),
          ),
          ComboBox<String>(
            value: value,
            items: options.map((option) {
              return ComboBoxItem(value: option, child: Text(option));
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSetting(
    String title,
    double value,
    Function(double) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: FluentTheme.of(context).typography.body),
              Text(
                '${value.round()}%',
                style: FluentTheme.of(context).typography.bodyStrong,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: value,
            min: 0,
            max: 100,
            onChanged: onChanged,
            label: '${value.round()}%',
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Main Demo Container
// ============================================================================

class AdvancedFluentExamplesDemo extends StatefulWidget {
  const AdvancedFluentExamplesDemo({super.key});

  @override
  State<AdvancedFluentExamplesDemo> createState() =>
      _AdvancedFluentExamplesDemoState();
}

class _AdvancedFluentExamplesDemoState
    extends State<AdvancedFluentExamplesDemo> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: const NavigationAppBar(title: Text('Advanced Fluent Examples')),
      pane: NavigationPane(
        selected: selectedIndex,
        onChanged: (index) => setState(() => selectedIndex = index),
        displayMode: PaneDisplayMode.open,
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.product_catalog),
            title: const Text('Product Catalog'),
            body: const AdvancedProductCatalog(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.task_manager),
            title: const Text('Task Manager'),
            body: const TaskManagerExample(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Settings'),
            body: const SettingsPanelExample(),
          ),
        ],
      ),
    );
  }
}
