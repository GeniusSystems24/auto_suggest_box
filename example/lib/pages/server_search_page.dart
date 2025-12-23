import 'package:fluent_ui/fluent_ui.dart';
import 'package:auto_suggest_box/auto_suggest/auto_suggest.dart';
import 'package:gap/gap.dart';

import '../data/sample_data.dart';

class ServerSearchPage extends StatefulWidget {
  const ServerSearchPage({super.key});

  @override
  State<ServerSearchPage> createState() => _ServerSearchPageState();
}

class _ServerSearchPageState extends State<ServerSearchPage> {
  Product? _selectedProduct;
  User? _selectedUser;
  final _controller = AutoSuggestController<Product>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('Server-Side Search'),
      ),
      children: [
        _buildInfoCard(
          'Async Search with Loading State',
          'Searches are performed on the server with debouncing and caching.',
        ),
        const Gap(16),
        _buildProductSearch(),
        const Gap(32),
        _buildInfoCard(
          'User Search with Custom Loading',
          'Custom loading indicator while fetching results.',
        ),
        const Gap(16),
        _buildUserSearch(),
        const Gap(32),
        _buildInfoCard(
          'Search Statistics',
          'Track search performance and cache hits.',
        ),
        const Gap(16),
        _buildStatsCard(),
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

  Widget _buildProductSearch() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search Products',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Gap(8),
          FluentAutoSuggestBox<Product>(
            items: const [],
            autoSuggestController: _controller,
            enableCache: true,
            cacheMaxSize: 50,
            cacheDuration: const Duration(minutes: 10),
            debounceDelay: const Duration(milliseconds: 300),
            minSearchLength: 2,
            onNoResultsFound: (query) async {
              final results = await searchProducts(query);
              return results
                  .map((p) => FluentAutoSuggestBoxItem(
                        value: p,
                        label: p.name,
                        subtitle: Text('\$${p.price.toStringAsFixed(2)} - ${p.category}'),
                      ))
                  .toList();
            },
            onSelected: (item) {
              setState(() => _selectedProduct = item?.value);
            },
            onError: (error, stack) {
              displayInfoBar(
                context,
                builder: (context, close) {
                  return InfoBar(
                    title: const Text('Error'),
                    content: Text(error.toString()),
                    severity: InfoBarSeverity.error,
                    action: IconButton(
                      icon: const Icon(FluentIcons.clear),
                      onPressed: close,
                    ),
                  );
                },
              );
            },
            decoration: const InputDecoration(
              hintText: 'Search products (min 2 chars)...',
            ),
          ),
          const Gap(16),
          if (_selectedProduct != null)
            Card(
              backgroundColor: FluentTheme.of(context).accentColor.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedProduct!.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Gap(4),
                  Text(_selectedProduct!.description),
                  const Gap(8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: FluentTheme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '\$${_selectedProduct!.price.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const Gap(8),
                      Text(_selectedProduct!.category),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserSearch() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search Users',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Gap(8),
          FluentAutoSuggestBox<User>(
            items: const [],
            debounceDelay: const Duration(milliseconds: 200),
            onNoResultsFound: (query) async {
              final results = await searchUsers(query);
              return results
                  .map((u) => FluentAutoSuggestBoxItem(
                        value: u,
                        label: u.name,
                        subtitle: Text('${u.email} | ${u.department}'),
                      ))
                  .toList();
            },
            loadingBuilder: (context) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProgressRing(strokeWidth: 2),
                    Gap(12),
                    Text('Finding users...'),
                  ],
                ),
              );
            },
            onSelected: (item) {
              setState(() => _selectedUser = item?.value);
            },
            decoration: const InputDecoration(
              hintText: 'Search by name, email, or department...',
            ),
          ),
          const Gap(16),
          if (_selectedUser != null)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: FluentTheme.of(context).accentColor,
                child: Text(
                  _selectedUser!.avatar,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(_selectedUser!.name),
              subtitle: Text('${_selectedUser!.email}\n${_selectedUser!.department}'),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    final stats = _controller.getStats();

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Controller Statistics',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Button(
                child: const Text('Reset Stats'),
                onPressed: () {
                  _controller.resetMetrics();
                  setState(() {});
                },
              ),
            ],
          ),
          const Gap(16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildStatItem('Total Searches', stats['totalSearches'].toString()),
              _buildStatItem('Successful', stats['successfulSearches'].toString()),
              _buildStatItem('Failed', stats['failedSearches'].toString()),
              _buildStatItem(
                'Success Rate',
                '${((stats['successRate'] as double) * 100).toStringAsFixed(1)}%',
              ),
              _buildStatItem('Is Loading', stats['isLoading'].toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: FluentTheme.of(context).resources.dividerStrokeColorDefault,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: FluentTheme.of(context).accentColor,
            ),
          ),
          const Gap(4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
