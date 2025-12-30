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
  // Calculate selected index based on current route
  int _getSelectedIndex(String location) {
    switch (location) {
      case '/':
      case '/basic':
        return 0;
      case '/server-search':
        return 1;
      case '/form-validation':
        return 2;
      case '/custom-builders':
        return 3;
      case '/advanced-search':
        return 4;
      case '/caching-demo':
        return 5;
      case '/cubit-example':
        return 6;
      case '/rtl-example':
        return 7;
      case '/voice-search':
        return 8;
      case '/grouped-suggestions':
        return 9;
      case '/inline-suggestions':
        return 10;
      default:
        return 0;
    }
  }

  // Get route from selected index
  String _getRouteFromIndex(int index) {
    switch (index) {
      case 0:
        return AppRoutes.basic;
      case 1:
        return AppRoutes.serverSearch;
      case 2:
        return AppRoutes.formValidation;
      case 3:
        return AppRoutes.customBuilders;
      case 4:
        return AppRoutes.advancedSearch;
      case 5:
        return AppRoutes.cachingDemo;
      case 6:
        return AppRoutes.cubitExample;
      case 7:
        return AppRoutes.rtlExample;
      case 8:
        return AppRoutes.voiceSearch;
      case 9:
        return AppRoutes.groupedSuggestions;
      case 10:
        return AppRoutes.inlineSuggestions;
      default:
        return AppRoutes.basic;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = _getSelectedIndex(location);

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
      ),
      pane: NavigationPane(
        selected: selectedIndex,
        onChanged: (index) {
          final route = _getRouteFromIndex(index);
          context.go(route);
        },
        displayMode: PaneDisplayMode.auto,
        items: [
          // Basic Examples
          PaneItem(
            icon: const Icon(FluentIcons.home),
            title: const Text('Basic Example'),
            body: widget.child,
          ),
          PaneItem(
            icon: const Icon(FluentIcons.cloud),
            title: const Text('Server Search'),
            body: widget.child,
          ),
          PaneItem(
            icon: const Icon(FluentIcons.checkbox_composite),
            title: const Text('Form Validation'),
            body: widget.child,
          ),
          PaneItem(
            icon: const Icon(FluentIcons.design),
            title: const Text('Custom Builders'),
            body: widget.child,
          ),
          PaneItem(
            icon: const Icon(FluentIcons.search),
            title: const Text('Advanced Search'),
            body: widget.child,
          ),
          PaneItem(
            icon: const Icon(FluentIcons.database),
            title: const Text('Caching Demo'),
            body: widget.child,
          ),
          PaneItem(
            icon: const Icon(FluentIcons.code),
            title: const Text('Cubit/BLoC'),
            body: widget.child,
          ),
          // v1.8.0 Features
          PaneItem(
            icon: const Icon(FluentIcons.locale_language),
            title: const Text('RTL Support'),
            body: widget.child,
            infoBadge: const InfoBadge(source: Text('NEW')),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.microphone),
            title: const Text('Voice Search'),
            body: widget.child,
            infoBadge: const InfoBadge(source: Text('NEW')),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.group_list),
            title: const Text('Grouped Suggestions'),
            body: widget.child,
            infoBadge: const InfoBadge(source: Text('NEW')),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.text_field),
            title: const Text('Inline Suggestions'),
            body: widget.child,
            infoBadge: const InfoBadge(source: Text('NEW')),
          ),
        ],
        footerItems: [
          PaneItem(
            icon: const Icon(FluentIcons.info),
            title: const Text('About'),
            body: widget.child,
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
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
