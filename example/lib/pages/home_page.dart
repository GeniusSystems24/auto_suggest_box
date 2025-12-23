import 'package:fluent_ui/fluent_ui.dart';

import 'basic_example_page.dart';
import 'server_search_page.dart';
import 'form_validation_page.dart';
import 'custom_builders_page.dart';
import 'advanced_search_page.dart';
import 'caching_demo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<NavigationPaneItem> _items = [
    PaneItem(
      icon: const Icon(FluentIcons.home),
      title: const Text('Basic Example'),
      body: const BasicExamplePage(),
    ),
    PaneItem(
      icon: const Icon(FluentIcons.cloud),
      title: const Text('Server Search'),
      body: const ServerSearchPage(),
    ),
    PaneItem(
      icon: const Icon(FluentIcons.checkbox_composite),
      title: const Text('Form Validation'),
      body: const FormValidationPage(),
    ),
    PaneItem(
      icon: const Icon(FluentIcons.design),
      title: const Text('Custom Builders'),
      body: const CustomBuildersPage(),
    ),
    PaneItem(
      icon: const Icon(FluentIcons.search),
      title: const Text('Advanced Search'),
      body: const AdvancedSearchPage(),
    ),
    PaneItem(
      icon: const Icon(FluentIcons.database),
      title: const Text('Caching Demo'),
      body: const CachingDemoPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: const NavigationAppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Auto Suggest Box - Examples',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      pane: NavigationPane(
        selected: _selectedIndex,
        onChanged: (index) => setState(() => _selectedIndex = index),
        displayMode: PaneDisplayMode.auto,
        items: _items,
      ),
    );
  }
}
