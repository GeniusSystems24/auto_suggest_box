import 'package:fluent_ui/fluent_ui.dart';
import 'package:auto_suggest_box/auto_suggest_box.dart';
import 'package:gap/gap.dart';

class RtlExamplePage extends StatefulWidget {
  const RtlExamplePage({super.key});

  @override
  State<RtlExamplePage> createState() => _RtlExamplePageState();
}

class _RtlExamplePageState extends State<RtlExamplePage> {
  bool _isRtl = true;
  bool _isDark = false;
  String? _selectedCity;

  // Arabic cities
  final List<FluentAutoSuggestBoxItem<String>> _arabicCities = [
    FluentAutoSuggestBoxItem(value: 'riyadh', label: 'الرياض'),
    FluentAutoSuggestBoxItem(value: 'jeddah', label: 'جدة'),
    FluentAutoSuggestBoxItem(value: 'mecca', label: 'مكة المكرمة'),
    FluentAutoSuggestBoxItem(value: 'medina', label: 'المدينة المنورة'),
    FluentAutoSuggestBoxItem(value: 'dammam', label: 'الدمام'),
    FluentAutoSuggestBoxItem(value: 'khobar', label: 'الخبر'),
    FluentAutoSuggestBoxItem(value: 'taif', label: 'الطائف'),
    FluentAutoSuggestBoxItem(value: 'tabuk', label: 'تبوك'),
    FluentAutoSuggestBoxItem(value: 'buraidah', label: 'بريدة'),
    FluentAutoSuggestBoxItem(value: 'khamis', label: 'خميس مشيط'),
    FluentAutoSuggestBoxItem(value: 'hofuf', label: 'الهفوف'),
    FluentAutoSuggestBoxItem(value: 'jubail', label: 'الجبيل'),
    FluentAutoSuggestBoxItem(value: 'yanbu', label: 'ينبع'),
    FluentAutoSuggestBoxItem(value: 'abha', label: 'أبها'),
    FluentAutoSuggestBoxItem(value: 'najran', label: 'نجران'),
  ];

  // Hebrew cities
  final List<FluentAutoSuggestBoxItem<String>> _hebrewCities = [
    FluentAutoSuggestBoxItem(value: 'jerusalem', label: 'ירושלים'),
    FluentAutoSuggestBoxItem(value: 'telaviv', label: 'תל אביב'),
    FluentAutoSuggestBoxItem(value: 'haifa', label: 'חיפה'),
    FluentAutoSuggestBoxItem(value: 'beersheba', label: 'באר שבע'),
    FluentAutoSuggestBoxItem(value: 'netanya', label: 'נתניה'),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Theme(
        data: ThemeData(
          extensions: [
            _isRtl
                ? FluentAutoSuggestThemeData.rtl(isDark: _isDark)
                : (_isDark
                    ? FluentAutoSuggestThemeData.dark()
                    : FluentAutoSuggestThemeData.light()),
          ],
        ),
        child: ScaffoldPage.scrollable(
          header: PageHeader(
            title: Text(_isRtl ? 'دعم اللغات من اليمين لليسار' : 'RTL Language Support'),
          ),
          children: [
            // Controls
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isRtl ? 'الإعدادات' : 'Settings',
                    style: FluentTheme.of(context).typography.subtitle,
                  ),
                  const Gap(16),
                  Row(
                    children: [
                      ToggleSwitch(
                        checked: _isRtl,
                        onChanged: (value) => setState(() => _isRtl = value),
                        content: Text(_isRtl ? 'من اليمين لليسار (RTL)' : 'Right-to-Left (RTL)'),
                      ),
                      const Gap(24),
                      ToggleSwitch(
                        checked: _isDark,
                        onChanged: (value) => setState(() => _isDark = value),
                        content: Text(_isRtl ? 'الوضع الداكن' : 'Dark Mode'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(24),

            // Arabic Example
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(FluentIcons.globe, size: 20),
                      const Gap(8),
                      Text(
                        _isRtl ? 'المدن العربية' : 'Arabic Cities',
                        style: FluentTheme.of(context).typography.subtitle,
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    _isRtl
                        ? 'ابحث عن مدينة عربية'
                        : 'Search for an Arabic city',
                    style: FluentTheme.of(context).typography.body,
                  ),
                  const Gap(16),
                  FluentAutoSuggestBox<String>(
                    items: _arabicCities,
                    decoration: InputDecoration(
                      labelText: _isRtl ? 'اختر مدينة' : 'Select a city',
                      hintText: _isRtl ? 'ابدأ الكتابة للبحث...' : 'Start typing to search...',
                    ),
                    onSelected: (item) {
                      setState(() => _selectedCity = item?.label);
                    },
                  ),
                  if (_selectedCity != null) ...[
                    const Gap(12),
                    InfoBar(
                      title: Text(_isRtl ? 'تم الاختيار' : 'Selected'),
                      content: Text(_selectedCity!),
                      severity: InfoBarSeverity.success,
                    ),
                  ],
                ],
              ),
            ),
            const Gap(24),

            // Hebrew Example
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(FluentIcons.globe, size: 20),
                      const Gap(8),
                      Text(
                        _isRtl ? 'المدن العبرية' : 'Hebrew Cities',
                        style: FluentTheme.of(context).typography.subtitle,
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    _isRtl
                        ? 'ابحث عن مدينة عبرية'
                        : 'Search for a Hebrew city',
                    style: FluentTheme.of(context).typography.body,
                  ),
                  const Gap(16),
                  FluentAutoSuggestBox<String>(
                    items: _hebrewCities,
                    decoration: InputDecoration(
                      labelText: _isRtl ? 'اختر مدينة' : 'Select a city',
                      hintText: _isRtl ? 'ابدأ الكتابة للبحث...' : 'Start typing to search...',
                    ),
                    onSelected: (item) {
                      if (item != null) {
                        displayInfoBar(
                          context,
                          builder: (context, close) => InfoBar(
                            title: Text(_isRtl ? 'تم اختيار' : 'Selected'),
                            content: Text(item.label),
                            severity: InfoBarSeverity.info,
                            action: IconButton(
                              icon: const Icon(FluentIcons.clear),
                              onPressed: close,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const Gap(24),

            // Theme Code Example
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(FluentIcons.code, size: 20),
                      const Gap(8),
                      Text(
                        _isRtl ? 'مثال الكود' : 'Code Example',
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
// RTL Theme Setup
MaterialApp(
  theme: ThemeData(
    extensions: [
      FluentAutoSuggestThemeData.rtl(isDark: false),
    ],
  ),
  // Wrap with Directionality for RTL
  builder: (context, child) => Directionality(
    textDirection: TextDirection.rtl,
    child: child!,
  ),
)

// Custom RTL Configuration
FluentAutoSuggestThemeData(
  textDirection: TextDirection.rtl,
  rtlMirrorIcons: true,
  rtlMirrorLayout: true,
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
        ),
      ),
    );
  }
}
