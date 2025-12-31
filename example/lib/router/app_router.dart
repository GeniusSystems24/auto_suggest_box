import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../pages/home_page.dart';
import '../pages/basic_example_page.dart';
import '../pages/server_search_page.dart';
import '../pages/form_validation_page.dart';
import '../pages/custom_builders_page.dart';
import '../pages/advanced_search_page.dart';
import '../pages/caching_demo_page.dart';
import '../pages/cubit_example_page.dart';
import '../pages/rtl_example_page.dart';
import '../pages/voice_search_page.dart';
import '../pages/grouped_suggestions_page.dart';
import '../pages/inline_suggestions_page.dart';

/// Route names for navigation
abstract class AppRoutes {
  static const String home = '/';
  static const String basic = '/basic';
  static const String serverSearch = '/server-search';
  static const String formValidation = '/form-validation';
  static const String customBuilders = '/custom-builders';
  static const String advancedSearch = '/advanced-search';
  static const String cachingDemo = '/caching-demo';
  static const String cubitExample = '/cubit-example';
  static const String rtlExample = '/rtl-example';
  static const String voiceSearch = '/voice-search';
  static const String groupedSuggestions = '/grouped-suggestions';
  static const String inlineSuggestions = '/inline-suggestions';
}

/// App router configuration using go_router
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: true,
  routes: [
    // Shell route for the main navigation
    ShellRoute(
      builder: (context, state, child) {
        return HomePage(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: BasicExamplePage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.basic,
          name: 'basic',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: BasicExamplePage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.serverSearch,
          name: 'serverSearch',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ServerSearchPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.formValidation,
          name: 'formValidation',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: FormValidationPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.customBuilders,
          name: 'customBuilders',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: CustomBuildersPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.advancedSearch,
          name: 'advancedSearch',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AdvancedSearchPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.cachingDemo,
          name: 'cachingDemo',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: CachingDemoPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.cubitExample,
          name: 'cubitExample',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: CubitExamplePage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.rtlExample,
          name: 'rtlExample',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: RtlExamplePage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.voiceSearch,
          name: 'voiceSearch',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: VoiceSearchPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.groupedSuggestions,
          name: 'groupedSuggestions',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: GroupedSuggestionsPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.inlineSuggestions,
          name: 'inlineSuggestions',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: InlineSuggestionsPage(),
          ),
        ),
      ],
    ),
  ],
);

/// Extension for easy navigation
extension GoRouterExtension on BuildContext {
  void goToBasic() => go(AppRoutes.basic);
  void goToServerSearch() => go(AppRoutes.serverSearch);
  void goToFormValidation() => go(AppRoutes.formValidation);
  void goToCustomBuilders() => go(AppRoutes.customBuilders);
  void goToAdvancedSearch() => go(AppRoutes.advancedSearch);
  void goToCachingDemo() => go(AppRoutes.cachingDemo);
  void goToCubitExample() => go(AppRoutes.cubitExample);
  void goToRtlExample() => go(AppRoutes.rtlExample);
  void goToVoiceSearch() => go(AppRoutes.voiceSearch);
  void goToGroupedSuggestions() => go(AppRoutes.groupedSuggestions);
  void goToInlineSuggestions() => go(AppRoutes.inlineSuggestions);
}
