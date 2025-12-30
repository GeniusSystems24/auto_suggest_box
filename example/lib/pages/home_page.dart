import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.child});

  final Widget child;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<_NavigationItem> _navigationItems = [
    _NavigationItem(
      icon: FluentIcons.home,
      title: 'Basic Example',
      route: AppRoutes.basic,
    ),
    _NavigationItem(
      icon: FluentIcons.cloud,
      title: 'Server Search',
      route: AppRoutes.serverSearch,
    ),
    _NavigationItem(
      icon: FluentIcons.checkbox_composite,
      title: 'Form Validation',
      route: AppRoutes.formValidation,
    ),
    _NavigationItem(
      icon: FluentIcons.design,
      title: 'Custom Builders',
      route: AppRoutes.customBuilders,
    ),
    _NavigationItem(
      icon: FluentIcons.search,
      title: 'Advanced Search',
      route: AppRoutes.advancedSearch,
    ),
    _NavigationItem(
      icon: FluentIcons.database,
      title: 'Caching Demo',
      route: AppRoutes.cachingDemo,
    ),
    _NavigationItem(
      icon: FluentIcons.code,
      title: 'Cubit/BLoC',
      route: AppRoutes.cubitExample,
    ),
    // New v1.8.0 features
    _NavigationItem(
      icon: FluentIcons.locale_language,
      title: 'RTL Support',
      route: AppRoutes.rtlExample,
      isNew: true,
    ),
    _NavigationItem(
      icon: FluentIcons.microphone,
      title: 'Voice Search',
      route: AppRoutes.voiceSearch,
      isNew: true,
    ),
    _NavigationItem(
      icon: FluentIcons.group_list,
      title: 'Grouped Suggestions',
      route: AppRoutes.groupedSuggestions,
      isNew: true,
    ),
    _NavigationItem(
      icon: FluentIcons.text_field,
      title: 'Inline Suggestions',
      route: AppRoutes.inlineSuggestions,
      isNew: true,
    ),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    final location = GoRouterState.of(context).uri.path;
    final index = _navigationItems.indexWhere((item) => item.route == location);
    if (index != -1 && index != _selectedIndex) {
      setState(() => _selectedIndex = index);
    } else if (location == '/' && _selectedIndex != 0) {
      setState(() => _selectedIndex = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Text(
              'Auto Suggest Box',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: FluentTheme.of(context).accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'v1.8.0',
                style: TextStyle(
                  fontSize: 12,
                  color: FluentTheme.of(context).accentColor,
                ),
              ),
            ),
          ],
        ),
        actions: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Tooltip(
                message: 'Toggle Theme',
                child: IconButton(
                  icon: Icon(
                    FluentTheme.of(context).brightness == Brightness.dark
                        ? FluentIcons.sunny
                        : FluentIcons.clear_night,
                  ),
                  onPressed: () {
                    // Theme toggle would be handled by parent
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      pane: NavigationPane(
        selected: _selectedIndex,
        onChanged: (index) {
          setState(() => _selectedIndex = index);
          context.go(_navigationItems[index].route);
        },
        displayMode: PaneDisplayMode.auto,
        items: [
          PaneItemHeader(header: const Text('Examples')),
          ..._navigationItems.take(7).map((item) => _buildPaneItem(item)),
          PaneItemSeparator(),
          PaneItemHeader(header: const Text('v1.8.0 Features')),
          ..._navigationItems.skip(7).map((item) => _buildPaneItem(item)),
        ],
        footerItems: [
          PaneItem(
            icon: const Icon(FluentIcons.info),
            title: const Text('About'),
            body: const SizedBox.shrink(),
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
      content: NavigationBody(child: widget.child),
    );
  }

  PaneItem _buildPaneItem(_NavigationItem item) {
    return PaneItem(
      icon: Icon(item.icon),
      title: Row(
        children: [
          Text(item.title),
          if (item.isNew) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'NEW',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      body: const SizedBox.shrink(),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('About Auto Suggest Box'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'A highly customizable, performance-optimized auto-suggest/autocomplete '
              'widget for Flutter with Fluent UI design.',
            ),
            const SizedBox(height: 16),
            Text(
              'Version: 1.8.0',
              style: FluentTheme.of(context).typography.bodyStrong,
            ),
            const SizedBox(height: 8),
            const Text('New in v1.8.0:'),
            const SizedBox(height: 4),
            const Text('• RTL Language Support'),
            const Text('• Voice Search Integration'),
            const Text('• Grouped Suggestions'),
            const Text('• Inline Suggestions (Ghost Text)'),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _NavigationItem {
  const _NavigationItem({
    required this.icon,
    required this.title,
    required this.route,
    this.isNew = false,
  });

  final IconData icon;
  final String title;
  final String route;
  final bool isNew;
}
