import 'package:fluent_ui/fluent_ui.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Auto Suggest Box Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: FluentThemeData.dark(),
      theme: FluentThemeData.light(),
      home: const HomePage(),
    );
  }
}
