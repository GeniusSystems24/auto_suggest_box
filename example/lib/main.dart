import 'package:fluent_ui/fluent_ui.dart';
import 'package:auto_suggest_box/auto_suggest_box.dart';

import 'router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp.router(
      title: 'Auto Suggest Box Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: FluentThemeData.dark().copyWith(
        extensions: [
          FluentAutoSuggestThemeData.dark(),
        ],
      ),
      theme: FluentThemeData.light().copyWith(
        extensions: [
          FluentAutoSuggestThemeData.light(),
        ],
      ),
      routerConfig: appRouter,
    );
  }
}
