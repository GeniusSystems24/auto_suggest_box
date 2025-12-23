import 'package:fluent_ui/fluent_ui.dart';
import 'package:auto_suggest_box/auto_suggest/auto_suggest.dart';
import 'package:gap/gap.dart';

import '../data/sample_data.dart';

class BasicExamplePage extends StatefulWidget {
  const BasicExamplePage({super.key});

  @override
  State<BasicExamplePage> createState() => _BasicExamplePageState();
}

class _BasicExamplePageState extends State<BasicExamplePage> {
  String? _selectedFruit;
  Country? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('Basic Example'),
      ),
      children: [
        _buildInfoCard(
          'Simple String List',
          'Basic autocomplete with a list of fruits.',
        ),
        const Gap(16),
        _buildSimpleExample(),
        const Gap(32),
        _buildInfoCard(
          'Object-Based Items',
          'Autocomplete with custom objects (countries) including subtitles.',
        ),
        const Gap(16),
        _buildCountryExample(),
        const Gap(32),
        _buildInfoCard(
          'Keyboard Navigation',
          'Use Arrow Up/Down to navigate, Enter to select, Escape to close.',
        ),
        const Gap(16),
        _buildKeyboardExample(),
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

  Widget _buildSimpleExample() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select a Fruit',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Gap(8),
          FluentAutoSuggestBox<String>(
            items: fruits
                .map((f) => FluentAutoSuggestBoxItem(
                      value: f,
                      label: f,
                    ))
                .toList(),
            onSelected: (item) {
              setState(() => _selectedFruit = item?.value);
            },
            decoration: const InputDecoration(
              hintText: 'Type to search fruits...',
            ),
          ),
          const Gap(16),
          if (_selectedFruit != null)
            InfoBar(
              title: Text('Selected: $_selectedFruit'),
              severity: InfoBarSeverity.success,
            ),
        ],
      ),
    );
  }

  Widget _buildCountryExample() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select a Country',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Gap(8),
          FluentAutoSuggestBox<Country>(
            items: sampleCountries
                .map((c) => FluentAutoSuggestBoxItem(
                      value: c,
                      label: '${c.flag} ${c.name}',
                      subtitle: Text(c.continent),
                    ))
                .toList(),
            onSelected: (item) {
              setState(() => _selectedCountry = item?.value);
            },
            decoration: const InputDecoration(
              hintText: 'Search countries...',
            ),
          ),
          const Gap(16),
          if (_selectedCountry != null)
            InfoBar(
              title: Text(
                'Selected: ${_selectedCountry!.flag} ${_selectedCountry!.name}',
              ),
              content: Text('Continent: ${_selectedCountry!.continent}'),
              severity: InfoBarSeverity.success,
            ),
        ],
      ),
    );
  }

  Widget _buildKeyboardExample() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Try Keyboard Navigation',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Gap(8),
          FluentAutoSuggestBox<String>(
            items: fruits
                .map((f) => FluentAutoSuggestBoxItem(
                      value: f,
                      label: f,
                    ))
                .toList(),
            enableKeyboardControls: true,
            onSelected: (item) {
              if (item != null) {
                displayInfoBar(
                  context,
                  builder: (context, close) {
                    return InfoBar(
                      title: Text('Selected via keyboard: ${item.label}'),
                      severity: InfoBarSeverity.success,
                      action: IconButton(
                        icon: const Icon(FluentIcons.clear),
                        onPressed: close,
                      ),
                    );
                  },
                );
              }
            },
            decoration: const InputDecoration(
              hintText: 'Use arrow keys to navigate...',
            ),
          ),
          const Gap(16),
          const Row(
            children: [
              Icon(FluentIcons.keyboard, size: 16),
              Gap(8),
              Text('Arrow Down/Up: Navigate | Enter: Select | Escape: Close'),
            ],
          ),
        ],
      ),
    );
  }
}
