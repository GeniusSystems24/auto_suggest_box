import 'package:fluent_ui/fluent_ui.dart';
import 'package:auto_suggest_box/auto_suggest/auto_suggest.dart';
import 'package:flutter/material.dart' show InputDecoration;
import 'package:gap/gap.dart';

import '../data/sample_data.dart';

class CachingDemoPage extends StatefulWidget {
  const CachingDemoPage({super.key});

  @override
  State<CachingDemoPage> createState() => _CachingDemoPageState();
}

class _CachingDemoPageState extends State<CachingDemoPage> {
  late SearchResultsCache<FluentAutoSuggestBoxItem<Product>> _cache;
  int _searchCount = 0;
  int _apiCalls = 0;
  final List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _cache = SearchResultsCache<FluentAutoSuggestBoxItem<Product>>(
      maxSize: 20,
      maxAge: const Duration(minutes: 5),
      enablePrefixMatching: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('Caching Demo'),
      ),
      children: [
        _buildInfoCard(
          'LRU Cache with TTL',
          'Demonstrates caching behavior with statistics tracking.',
        ),
        const Gap(16),
        _buildSearchWithCache(),
        const Gap(32),
        _buildCacheStats(),
        const Gap(32),
        _buildSearchHistory(),
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

  Widget _buildSearchWithCache() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Product Search with Caching',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Button(
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FluentIcons.delete, size: 14),
                    Gap(8),
                    Text('Clear Cache'),
                  ],
                ),
                onPressed: () {
                  _cache.clear();
                  setState(() {
                    _searchHistory.clear();
                    _searchCount = 0;
                    _apiCalls = 0;
                  });
                  displayInfoBar(
                    context,
                    builder: (context, close) {
                      return InfoBar(
                        title: const Text('Cache Cleared'),
                        severity: InfoBarSeverity.warning,
                        action: IconButton(
                          icon: const Icon(FluentIcons.clear),
                          onPressed: close,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          const Gap(8),
          const Text(
            'Try searching the same term twice - the second search will be instant (cached).',
            style: TextStyle(fontSize: 12),
          ),
          const Gap(16),
          FluentAutoSuggestBox<Product>(
            items: const [],
            enableCache: false, // We're using our own cache for demo
            onNoResultsFound: (query) async {
              setState(() => _searchCount++);

              // Check cache first
              final cached = _cache.get(query);
              if (cached != null) {
                setState(() {
                  _searchHistory.add('$query (cached)');
                });
                return cached;
              }

              // Simulate API call
              setState(() => _apiCalls++);
              await Future.delayed(const Duration(milliseconds: 800));

              final results = await searchProducts(query);
              final items = results
                  .map((p) => FluentAutoSuggestBoxItem(
                        value: p,
                        label: p.name,
                        subtitle:
                            Text('${p.category} - \$${p.price.toStringAsFixed(2)}'),
                      ))
                  .toList();

              // Store in cache
              _cache.set(query, items);
              setState(() {
                _searchHistory.add('$query (API call)');
              });

              return items;
            },
            onSelected: (item) {
              if (item != null) {
                displayInfoBar(
                  context,
                  builder: (context, close) {
                    return InfoBar(
                      title: Text('Selected: ${item.label}'),
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
              hintText: 'Search products...',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCacheStats() {
    final stats = _cache.getStats();

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cache Statistics',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Gap(16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildStatCard(
                'Total Searches',
                _searchCount.toString(),
                FluentIcons.search,
              ),
              _buildStatCard(
                'API Calls',
                _apiCalls.toString(),
                FluentIcons.cloud,
              ),
              _buildStatCard(
                'Cache Hits',
                stats.hits.toString(),
                FluentIcons.check_mark,
                color: Colors.green,
              ),
              _buildStatCard(
                'Cache Misses',
                stats.misses.toString(),
                FluentIcons.cancel,
                color: Colors.red,
              ),
              _buildStatCard(
                'Hit Rate',
                '${(stats.hitRate * 100).toStringAsFixed(1)}%',
                FluentIcons.chart_series,
              ),
              _buildStatCard(
                'Cache Size',
                '${stats.size}/${stats.maxSize}',
                FluentIcons.database,
              ),
              _buildStatCard(
                'Evictions',
                stats.evictions.toString(),
                FluentIcons.delete,
              ),
              _buildStatCard(
                'Utilization',
                '${stats.utilizationPercent.toStringAsFixed(1)}%',
                FluentIcons.pie_single,
              ),
            ],
          ),
          const Gap(16),
          _buildProgressBar('Cache Utilization', stats.utilizationPercent / 100),
          const Gap(8),
          _buildProgressBar('Hit Rate', stats.hitRate),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    final theme = FluentTheme.of(context);

    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.resources.dividerStrokeColorDefault,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color ?? theme.accentColor),
          const Gap(8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color ?? theme.accentColor,
            ),
          ),
          const Gap(4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12)),
            Text(
              '${(value * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Gap(4),
        ProgressBar(value: value * 100),
      ],
    );
  }

  Widget _buildSearchHistory() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Search History',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              if (_searchHistory.isNotEmpty)
                Button(
                  child: const Text('Clear'),
                  onPressed: () {
                    setState(() => _searchHistory.clear());
                  },
                ),
            ],
          ),
          const Gap(16),
          if (_searchHistory.isEmpty)
            const Text('No searches yet. Try searching for something!')
          else
            Column(
              children: _searchHistory.reversed.take(10).map((search) {
                final isCached = search.contains('(cached)');
                return ListTile(
                  leading: Icon(
                    isCached ? FluentIcons.database : FluentIcons.cloud,
                    color: isCached ? Colors.green : null,
                  ),
                  title: Text(search),
                  subtitle: Text(isCached ? 'From cache' : 'Network request'),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
