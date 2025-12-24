import 'package:auto_suggest_box/bloc/bloc.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show InputDecoration, Chip;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../data/sample_data.dart';

class CubitExamplePage extends StatefulWidget {
  const CubitExamplePage({super.key});

  @override
  State<CubitExamplePage> createState() => _CubitExamplePageState();
}

class _CubitExamplePageState extends State<CubitExamplePage> {
  // Create cubits - similar to smart_pagination approach
  late final AutoSuggestCubit<Product> _productsCubit;
  late final AutoSuggestCubit<User> _usersCubit;
  late final AutoSuggestCubit<Country> _countriesCubit;

  Product? _selectedProduct;
  User? _selectedUser;
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();

    // Products cubit with caching and retry
    _productsCubit = AutoSuggestCubit<Product>(
      provider: (query, {filters}) async {
        return await searchProducts(query);
      },
      config: const AutoSuggestConfig(
        debounceDelay: Duration(milliseconds: 300),
        dataAge: Duration(minutes: 15),
        maxCacheSize: 50,
        retryConfig: RetryConfig(
          maxRetries: 3,
          initialDelay: Duration(seconds: 1),
        ),
      ),
    );

    // Users cubit with shorter debounce
    _usersCubit = AutoSuggestCubit<User>(
      provider: (query, {filters}) async {
        return await searchUsers(query);
      },
      config: const AutoSuggestConfig(
        debounceDelay: Duration(milliseconds: 200),
        dataAge: Duration(minutes: 10),
        minSearchLength: 1,
      ),
    );

    // Countries cubit (fast local search simulation)
    _countriesCubit = AutoSuggestCubit<Country>(
      provider: (query, {filters}) async {
        return await searchCountries(query);
      },
      config: const AutoSuggestConfig(
        debounceDelay: Duration(milliseconds: 100),
        dataAge: Duration(hours: 1),
      ),
    );
  }

  @override
  void dispose() {
    _productsCubit.close();
    _usersCubit.close();
    _countriesCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Cubit State Management')),
      children: [
        _buildInfoCard(
          'BLoC/Cubit Pattern',
          'Using AutoSuggestCubit similar to smart_pagination for state management.',
        ),
        const Gap(16),
        _buildProductsExample(),
        const Gap(32),
        _buildInfoCard(
          'Direct BlocBuilder Usage',
          'Using BlocBuilder directly for custom UI control.',
        ),
        const Gap(16),
        _buildUsersExample(),
        const Gap(32),
        _buildInfoCard(
          'AutoSuggestBlocBuilder',
          'Using the convenience builder widget for exhaustive state handling.',
        ),
        const Gap(16),
        _buildCountriesExample(),
        const Gap(32),
        _buildStatsPanel(),
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

  Widget _buildProductsExample() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Products Search (BlocAutoSuggestBox)',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Gap(8),
          const Text(
            'Full-featured widget with built-in state handling.',
            style: TextStyle(fontSize: 12),
          ),
          const Gap(16),
          BlocAutoSuggestBox<Product>(
            cubit: _productsCubit,
            itemBuilder: (context, product, isSelected, onTap) {
              return ListTile.selectable(
                selected: isSelected,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: FluentTheme.of(context).accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(product.category),
                    color: FluentTheme.of(context).accentColor,
                  ),
                ),
                title: Text(product.name),
                subtitle: Text(
                  '${product.category} - \$${product.price.toStringAsFixed(2)}',
                ),
                onPressed: onTap,
              );
            },
            labelBuilder: (product) => product.name,
            onSelected: (product) {
              setState(() => _selectedProduct = product);
            },
            decoration: const InputDecoration(hintText: 'Search products...'),
            showStats: true,
          ),
          if (_selectedProduct != null) ...[
            const Gap(16),
            _buildSelectedProductCard(_selectedProduct!),
          ],
        ],
      ),
    );
  }

  Widget _buildUsersExample() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Users Search (Direct BlocBuilder)',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Gap(8),
          const Text(
            'Manual state handling with BlocBuilder for full control.',
            style: TextStyle(fontSize: 12),
          ),
          const Gap(16),
          _UserSearchField(
            cubit: _usersCubit,
            onSelected: (user) {
              setState(() => _selectedUser = user);
            },
          ),
          const Gap(16),
          BlocBuilder<AutoSuggestCubit<User>, AutoSuggestState<User>>(
            bloc: _usersCubit,
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: FluentTheme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: FluentTheme.of(
                      context,
                    ).resources.dividerStrokeColorDefault,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildStateIndicator(state),
                        const Gap(8),
                        Text(
                          'State: ${state.runtimeType.toString().replaceAll('<User>', '')}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const Gap(8),
                    _buildStateDetails(state),
                  ],
                ),
              );
            },
          ),
          if (_selectedUser != null) ...[
            const Gap(16),
            _buildSelectedUserCard(_selectedUser!),
          ],
        ],
      ),
    );
  }

  Widget _buildCountriesExample() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Countries Search (AutoSuggestBlocBuilder)',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Gap(8),
          const Text(
            'Using convenience builder for exhaustive pattern matching.',
            style: TextStyle(fontSize: 12),
          ),
          const Gap(16),
          _CountrySearchField(
            cubit: _countriesCubit,
            onSelected: (country) {
              setState(() => _selectedCountry = country);
            },
          ),
          const Gap(16),
          AutoSuggestBlocBuilder<Country>(
            cubit: _countriesCubit,
            onInitial: (context) => Container(
              padding: const EdgeInsets.all(16),
              child: const Row(
                children: [
                  Icon(FluentIcons.globe, size: 24),
                  Gap(12),
                  Text('Start typing to search countries...'),
                ],
              ),
            ),
            onLoading: (context, query, previousItems) => Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const ProgressRing(strokeWidth: 2),
                  const Gap(12),
                  Text('Searching for "$query"...'),
                ],
              ),
            ),
            onLoaded: (context, items, query) => Container(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: items
                    .take(5)
                    .map(
                      (c) => Chip(
                        label: Text('${c.flag} ${c.name}'),
                        onDeleted: () {
                          setState(() => _selectedCountry = c);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            onEmpty: (context, query) => Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(FluentIcons.emoji_neutral),
                  const Gap(12),
                  Text('No countries found for "$query"'),
                ],
              ),
            ),
            onError: (context, error, query, previousItems) => Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(FluentIcons.error, color: Colors.red),
                  const Gap(12),
                  Expanded(child: Text('Error: $error')),
                  Button(
                    child: const Text('Retry'),
                    onPressed: () => _countriesCubit.refresh(),
                  ),
                ],
              ),
            ),
          ),
          if (_selectedCountry != null) ...[
            const Gap(16),
            _buildSelectedCountryCard(_selectedCountry!),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsPanel() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cubit Statistics',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Button(
                child: const Text('Reset All'),
                onPressed: () {
                  _productsCubit.resetStats();
                  _usersCubit.resetStats();
                  _countriesCubit.resetStats();
                  setState(() {});
                },
              ),
            ],
          ),
          const Gap(16),
          Row(
            children: [
              Expanded(child: _buildCubitStats('Products', _productsCubit)),
              const Gap(16),
              Expanded(child: _buildCubitStats('Users', _usersCubit)),
              const Gap(16),
              Expanded(child: _buildCubitStats('Countries', _countriesCubit)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCubitStats<T>(String name, AutoSuggestCubit<T> cubit) {
    final stats = cubit.stats;
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Gap(8),
          _buildStatRow('Searches', stats['totalSearches'].toString()),
          _buildStatRow('Cache Hits', stats['cacheHits'].toString()),
          _buildStatRow('Cache Misses', stats['cacheMisses'].toString()),
          _buildStatRow(
            'Hit Rate',
            '${(stats['cacheHitRate'] * 100).toStringAsFixed(0)}%',
          ),
          _buildStatRow('Cache Size', stats['cacheSize'].toString()),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: FluentTheme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateIndicator(AutoSuggestState state) {
    final (color, icon) = switch (state) {
      AutoSuggestInitial() => (Colors.grey, FluentIcons.circle_fill),
      AutoSuggestLoading() => (Colors.blue, FluentIcons.progress_ring_dots),
      AutoSuggestLoaded() => (Colors.green, FluentIcons.check_mark),
      AutoSuggestEmpty() => (Colors.orange, FluentIcons.warning),
      AutoSuggestError() => (Colors.red, FluentIcons.error),
    };

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 14, color: color),
    );
  }

  Widget _buildStateDetails(AutoSuggestState<User> state) {
    return switch (state) {
      AutoSuggestInitial() => const Text('Ready to search'),
      AutoSuggestLoading(:final query) => Text('Searching: "$query"'),
      AutoSuggestLoaded(:final items, :final query, :final dataAge) => Text(
        'Found ${items.length} users for "$query"\n'
        'Data age: ${dataAge.inSeconds}s',
      ),
      AutoSuggestEmpty(:final query) => Text('No users match "$query"'),
      AutoSuggestError(:final error) => Text('Error: $error'),
    };
  }

  Widget _buildSelectedProductCard(Product product) {
    return Card(
      backgroundColor: FluentTheme.of(context).accentColor.withOpacity(0.1),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: FluentTheme.of(context).accentColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getCategoryIcon(product.category),
              color: Colors.white,
              size: 32,
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(product.description),
                const Gap(4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: FluentTheme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const Gap(8),
                    Text(product.category),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedUserCard(User user) {
    return Card(
      backgroundColor: FluentTheme.of(context).accentColor.withOpacity(0.1),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: FluentTheme.of(context).accentColor,
            child: Text(
              user.avatar,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(user.email),
                Text(user.department),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedCountryCard(Country country) {
    return Card(
      backgroundColor: FluentTheme.of(context).accentColor.withOpacity(0.1),
      child: Row(
        children: [
          Text(country.flag, style: const TextStyle(fontSize: 48)),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  country.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text('Code: ${country.code}'),
                Text('Continent: ${country.continent}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    return switch (category.toLowerCase()) {
      'electronics' => FluentIcons.devices2,
      'footwear' => FluentIcons.running,
      'clothing' => FluentIcons.shirt,
      'gaming' => FluentIcons.game,
      'home' => FluentIcons.home,
      _ => FluentIcons.product_catalog,
    };
  }
}

// Simple text field for user search
class _UserSearchField extends StatefulWidget {
  final AutoSuggestCubit<User> cubit;
  final void Function(User) onSelected;

  const _UserSearchField({required this.cubit, required this.onSelected});

  @override
  State<_UserSearchField> createState() => _UserSearchFieldState();
}

class _UserSearchFieldState extends State<_UserSearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextBox(
      controller: _controller,
      placeholder: 'Search users...',
      onChanged: (value) => widget.cubit.search(value),
      suffix: BlocBuilder<AutoSuggestCubit<User>, AutoSuggestState<User>>(
        bloc: widget.cubit,
        builder: (context, state) {
          if (state is AutoSuggestLoading) {
            return const Padding(
              padding: EdgeInsets.only(right: 8),
              child: ProgressRing(strokeWidth: 2),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// Simple text field for country search
class _CountrySearchField extends StatefulWidget {
  final AutoSuggestCubit<Country> cubit;
  final void Function(Country) onSelected;

  const _CountrySearchField({required this.cubit, required this.onSelected});

  @override
  State<_CountrySearchField> createState() => _CountrySearchFieldState();
}

class _CountrySearchFieldState extends State<_CountrySearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextBox(
      controller: _controller,
      placeholder: 'Search countries...',
      onChanged: (value) => widget.cubit.search(value),
      suffix: BlocBuilder<AutoSuggestCubit<Country>, AutoSuggestState<Country>>(
        bloc: widget.cubit,
        builder: (context, state) {
          if (state is AutoSuggestLoading) {
            return const Padding(
              padding: EdgeInsets.only(right: 8),
              child: ProgressRing(strokeWidth: 2),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
