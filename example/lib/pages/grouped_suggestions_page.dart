import 'package:fluent_ui/fluent_ui.dart';
import 'package:auto_suggest_box/auto_suggest_box.dart';
import 'package:gap/gap.dart';

class GroupedSuggestionsPage extends StatefulWidget {
  const GroupedSuggestionsPage({super.key});

  @override
  State<GroupedSuggestionsPage> createState() => _GroupedSuggestionsPageState();
}

class _GroupedSuggestionsPageState extends State<GroupedSuggestionsPage> {
  bool _showHeaders = true;
  bool _collapsible = true;
  bool _showDividers = true;
  bool _showItemCount = true;
  FluentAutoSuggestBoxItem<String>? _selectedItem;

  // Recent items
  final List<FluentAutoSuggestBoxItem<String>> _recentItems = [
    FluentAutoSuggestBoxItem(value: 'recent_1', label: 'Flutter'),
    FluentAutoSuggestBoxItem(value: 'recent_2', label: 'Dart'),
    FluentAutoSuggestBoxItem(value: 'recent_3', label: 'Auto Suggest Box'),
  ];

  // Popular items
  final List<FluentAutoSuggestBoxItem<String>> _popularItems = [
    FluentAutoSuggestBoxItem(value: 'pop_1', label: 'React Native'),
    FluentAutoSuggestBoxItem(value: 'pop_2', label: 'Swift UI'),
    FluentAutoSuggestBoxItem(value: 'pop_3', label: 'Kotlin'),
    FluentAutoSuggestBoxItem(value: 'pop_4', label: 'Jetpack Compose'),
  ];

  // All items (programming languages)
  final List<FluentAutoSuggestBoxItem<String>> _allItems = [
    FluentAutoSuggestBoxItem(value: 'lang_1', label: 'JavaScript'),
    FluentAutoSuggestBoxItem(value: 'lang_2', label: 'Python'),
    FluentAutoSuggestBoxItem(value: 'lang_3', label: 'Java'),
    FluentAutoSuggestBoxItem(value: 'lang_4', label: 'C++'),
    FluentAutoSuggestBoxItem(value: 'lang_5', label: 'C#'),
    FluentAutoSuggestBoxItem(value: 'lang_6', label: 'Go'),
    FluentAutoSuggestBoxItem(value: 'lang_7', label: 'Rust'),
    FluentAutoSuggestBoxItem(value: 'lang_8', label: 'TypeScript'),
    FluentAutoSuggestBoxItem(value: 'lang_9', label: 'Ruby'),
    FluentAutoSuggestBoxItem(value: 'lang_10', label: 'PHP'),
  ];

  // Fruits for alphabetical grouping
  final List<FluentAutoSuggestBoxItem<String>> _fruits = [
    FluentAutoSuggestBoxItem(value: 'apple', label: 'Apple'),
    FluentAutoSuggestBoxItem(value: 'apricot', label: 'Apricot'),
    FluentAutoSuggestBoxItem(value: 'avocado', label: 'Avocado'),
    FluentAutoSuggestBoxItem(value: 'banana', label: 'Banana'),
    FluentAutoSuggestBoxItem(value: 'blackberry', label: 'Blackberry'),
    FluentAutoSuggestBoxItem(value: 'blueberry', label: 'Blueberry'),
    FluentAutoSuggestBoxItem(value: 'cherry', label: 'Cherry'),
    FluentAutoSuggestBoxItem(value: 'coconut', label: 'Coconut'),
    FluentAutoSuggestBoxItem(value: 'date', label: 'Date'),
    FluentAutoSuggestBoxItem(value: 'dragon', label: 'Dragon Fruit'),
    FluentAutoSuggestBoxItem(value: 'elderberry', label: 'Elderberry'),
    FluentAutoSuggestBoxItem(value: 'fig', label: 'Fig'),
    FluentAutoSuggestBoxItem(value: 'grape', label: 'Grape'),
    FluentAutoSuggestBoxItem(value: 'guava', label: 'Guava'),
    FluentAutoSuggestBoxItem(value: 'honeydew', label: 'Honeydew'),
  ];

  late List<SuggestionGroup<String>> _groups;
  late List<SuggestionGroup<String>> _alphabeticalGroups;

  @override
  void initState() {
    super.initState();
    _buildGroups();
  }

  void _buildGroups() {
    _groups = [
      SuggestionGroup<String>(
        title: 'Recent Searches',
        icon: FluentIcons.history,
        items: _recentItems,
        isExpanded: true,
        showItemCount: _showItemCount,
      ),
      SuggestionGroup<String>(
        title: 'Popular',
        icon: FluentIcons.favorite_star,
        items: _popularItems,
        isExpanded: true,
        showItemCount: _showItemCount,
      ),
      SuggestionGroup<String>(
        title: 'All Technologies',
        icon: FluentIcons.code,
        items: _allItems,
        isExpanded: false,
        showItemCount: _showItemCount,
      ),
    ];

    _alphabeticalGroups = groupItemsAlphabetically(_fruits);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('Grouped Suggestions'),
      ),
      children: [
        // Settings Card
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: FluentTheme.of(context).typography.subtitle,
              ),
              const Gap(16),
              Wrap(
                spacing: 24,
                runSpacing: 12,
                children: [
                  ToggleSwitch(
                    checked: _showHeaders,
                    onChanged: (value) => setState(() {
                      _showHeaders = value;
                      _buildGroups();
                    }),
                    content: const Text('Show Headers'),
                  ),
                  ToggleSwitch(
                    checked: _collapsible,
                    onChanged: (value) => setState(() {
                      _collapsible = value;
                      _buildGroups();
                    }),
                    content: const Text('Collapsible'),
                  ),
                  ToggleSwitch(
                    checked: _showDividers,
                    onChanged: (value) => setState(() {
                      _showDividers = value;
                      _buildGroups();
                    }),
                    content: const Text('Show Dividers'),
                  ),
                  ToggleSwitch(
                    checked: _showItemCount,
                    onChanged: (value) => setState(() {
                      _showItemCount = value;
                      _buildGroups();
                    }),
                    content: const Text('Show Item Count'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Gap(24),

        // Manual Groups Example
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(FluentIcons.group_list, size: 20),
                  const Gap(8),
                  Text(
                    'Manual Groups',
                    style: FluentTheme.of(context).typography.subtitle,
                  ),
                ],
              ),
              const Gap(8),
              const Text(
                'Groups defined manually with custom icons and titles.',
              ),
              const Gap(16),
              Container(
                constraints: const BoxConstraints(maxHeight: 400),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: FluentTheme.of(context).resources.dividerStrokeColorDefault,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GroupedSuggestionsOverlay<String>(
                  groups: _groups,
                  config: GroupedSuggestionsConfig(
                    showGroupHeaders: _showHeaders,
                    collapsible: _collapsible,
                    showDividers: _showDividers,
                  ),
                  selectedItem: _selectedItem,
                  onSelected: (item) {
                    setState(() => _selectedItem = item);
                    displayInfoBar(
                      context,
                      builder: (context, close) => InfoBar(
                        title: const Text('Selected'),
                        content: Text(item.label),
                        severity: InfoBarSeverity.success,
                        action: IconButton(
                          icon: const Icon(FluentIcons.clear),
                          onPressed: close,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const Gap(24),

        // Alphabetical Groups Example
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(FluentIcons.sort_lines, size: 20),
                  const Gap(8),
                  Text(
                    'Alphabetical Groups',
                    style: FluentTheme.of(context).typography.subtitle,
                  ),
                ],
              ),
              const Gap(8),
              const Text(
                'Items automatically grouped by first letter using groupItemsAlphabetically().',
              ),
              const Gap(16),
              Container(
                constraints: const BoxConstraints(maxHeight: 400),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: FluentTheme.of(context).resources.dividerStrokeColorDefault,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GroupedSuggestionsOverlay<String>(
                  groups: _alphabeticalGroups,
                  config: GroupedSuggestionsConfig(
                    showGroupHeaders: true,
                    collapsible: true,
                    showDividers: true,
                  ),
                  onSelected: (item) {
                    displayInfoBar(
                      context,
                      builder: (context, close) => InfoBar(
                        title: const Text('Selected Fruit'),
                        content: Text(item.label),
                        severity: InfoBarSeverity.info,
                        action: IconButton(
                          icon: const Icon(FluentIcons.clear),
                          onPressed: close,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const Gap(24),

        // Code Example
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(FluentIcons.code, size: 20),
                  const Gap(8),
                  Text(
                    'Code Example',
                    style: FluentTheme.of(context).typography.subtitle,
                  ),
                ],
              ),
              const Gap(16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: FluentTheme.of(context).micaBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  '''
// Create suggestion groups manually
final groups = [
  SuggestionGroup<Product>(
    title: 'Recent',
    icon: FluentIcons.history,
    items: recentItems,
    isExpanded: true,
    showItemCount: true,
  ),
  SuggestionGroup<Product>(
    title: 'Popular',
    icon: FluentIcons.favorite_star,
    items: popularItems,
  ),
];

// Or group items automatically
final alphabeticalGroups = groupItemsAlphabetically(items);

final categoryGroups = groupItemsBy<Product, String>(
  items,
  (item) => item.value.category,
  titleBuilder: (category) => category.toUpperCase(),
);

// Display grouped suggestions
GroupedSuggestionsOverlay<Product>(
  groups: groups,
  config: GroupedSuggestionsConfig(
    showGroupHeaders: true,
    collapsible: true,
    showDividers: true,
  ),
  onSelected: (item) => print('Selected: \${item.label}'),
)''',
                  style: FluentTheme.of(context).typography.body?.copyWith(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
