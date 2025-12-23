import 'package:auto_suggest_box/auto_suggest/auto_suggest.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'auto_suggest_advanced.dart';

/// Comprehensive examples using Fluent UI components
///
/// This file demonstrates advanced usage of AdvancedSearchDialog with:
/// - Full Fluent UI integration
/// - Real-world scenarios
/// - Advanced customization
/// - Multiple view modes
/// - Complex data structures

// ============================================================================
// Example 1: Product Search with Fluent UI Components
// ============================================================================

class ProductSearchExample extends StatefulWidget {
  const ProductSearchExample({super.key});

  @override
  State<ProductSearchExample> createState() => _ProductSearchExampleState();
}

class _ProductSearchExampleState extends State<ProductSearchExample> {
  Product? selectedProduct;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Search Example',
              style: FluentTheme.of(context).typography.subtitle,
            ),
            const SizedBox(height: 16),

            // // Search Button with Flyout
            // Flyout(
            //   content: (context) => FlyoutContent(
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text('Search Options', style: FluentTheme.of(context).typography.bodyStrong),
            //         const SizedBox(height: 8),
            //         Button(
            //           onPressed: () => _openProductSearch(context),
            //           child: const Text('Advanced Search'),
            //         ),
            //       ],
            //     ),
            //   ),
            //   child: (context) => Button(
            //     onPressed: () => _openProductSearch(context),
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         const Icon(FluentIcons.search, size: 16),
            //         const SizedBox(width: 8),
            //         const Text('Search Products'),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(height: 16),

            // Display selected product
            if (selectedProduct != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              _buildProductCard(selectedProduct!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    final theme = FluentTheme.of(context);

    return Expander(
      header: Row(
        children: [
          Icon(FluentIcons.product, color: theme.accentColor),
          const SizedBox(width: 12),
          Text(product.name, style: theme.typography.bodyStrong),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('SKU', product.sku),
            _buildInfoRow('Category', product.category),
            _buildInfoRow('Price', '\$${product.price.toStringAsFixed(2)}'),
            _buildInfoRow('Stock', '${product.stock} units'),
            const SizedBox(height: 12),
            ProgressBar(value: product.stock / 100),
            const SizedBox(height: 4),
            Text(
              'Stock Level: ${product.stock}%',
              style: theme.typography.caption,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}

// ============================================================================
// Example 2: Employee Directory with Tabs and Navigation
// ============================================================================

class EmployeeDirectoryExample extends StatefulWidget {
  const EmployeeDirectoryExample({super.key});

  @override
  State<EmployeeDirectoryExample> createState() =>
      _EmployeeDirectoryExampleState();
}

class _EmployeeDirectoryExampleState extends State<EmployeeDirectoryExample> {
  int currentIndex = 0;
  Employee? selectedEmployee;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        title: const Text('Employee Directory'),
        actions: CommandBar(
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.search),
              label: const Text('Search'),
              onPressed: () => _openEmployeeSearch(context),
            ),
            CommandBarButton(
              icon: const Icon(FluentIcons.add),
              label: const Text('Add'),
              onPressed: () {},
            ),
          ],
        ),
      ),
      pane: NavigationPane(
        selected: currentIndex,
        onChanged: (index) => setState(() => currentIndex = index),
        displayMode: PaneDisplayMode.compact,
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.people),
            title: const Text('All Employees'),
            body: _buildEmployeeList(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.org),
            title: const Text('Departments'),
            body: _buildDepartmentView(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.recent),
            title: const Text('Recent'),
            body: _buildRecentView(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeList() {
    if (selectedEmployee == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(FluentIcons.search, size: 64),
            const SizedBox(height: 16),
            const Text('Click search to find employees'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => _openEmployeeSearch(context),
              child: const Text('Search Employees'),
            ),
          ],
        ),
      );
    }

    return _buildEmployeeDetails(selectedEmployee!);
  }

  Widget _buildDepartmentView() {
    final departments = ['Engineering', 'Sales', 'Marketing', 'HR', 'Finance'];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: departments.map((dept) {
        return Expander(
          header: Text(dept),
          content: Padding(
            padding: const EdgeInsets.all(12),
            child: Text('$dept department employees'),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentView() {
    return const Center(child: Text('Recently viewed employees'));
  }

  Widget _buildEmployeeDetails(Employee employee) {
    final theme = FluentTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.accentColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    employee.name.substring(0, 2).toUpperCase(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: theme.accentColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(employee.name, style: theme.typography.title),
                    const SizedBox(height: 4),
                    Text(employee.position, style: theme.typography.subtitle),
                    const SizedBox(height: 4),
                    Text(employee.department, style: theme.typography.caption),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          TabView(
            tabs: [
              Tab(
                icon: const Icon(FluentIcons.contact_info),
                text: const Text('Contact'),
                body: _buildContactTab(employee),
              ),
              Tab(
                icon: const Icon(FluentIcons.office_logo),
                text: const Text('Department'),
                body: _buildDepartmentTab(employee),
              ),
              Tab(
                icon: const Icon(FluentIcons.date_time),
                text: const Text('Schedule'),
                body: _buildScheduleTab(employee),
              ),
            ],
            currentIndex: 0,
          ),
        ],
      ),
    );
  }

  Widget _buildContactTab(Employee employee) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(FluentIcons.mail),
            title: const Text('Email'),
            subtitle: Text(employee.email),
          ),
          ListTile(
            leading: const Icon(FluentIcons.phone),
            title: const Text('Phone'),
            subtitle: Text(employee.phone),
          ),
          ListTile(
            leading: const Icon(FluentIcons.location),
            title: const Text('Location'),
            subtitle: Text(employee.location),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentTab(Employee employee) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Department: ${employee.department}'),
          const SizedBox(height: 8),
          Text('Position: ${employee.position}'),
          const SizedBox(height: 8),
          Text('Employee ID: ${employee.id}'),
        ],
      ),
    );
  }

  Widget _buildScheduleTab(Employee employee) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text('Schedule information'),
    );
  }

  Future<void> _openEmployeeSearch(BuildContext context) async {
    final result = await AdvancedSearchDialog.show<Employee>(
      context: context,
      items: _getEmployeeItems(),
      onSearch: _searchEmployees,
      config: AdvancedSearchConfig(
        title: '👥 Employee Directory',
        searchHint: 'Search by name, email, or department...',
        theme: AdvancedSearchTheme(
          primaryColor: FluentTheme.of(context).accentColor,
          spacing: 16,
        ),
        icons: const AdvancedSearchIcons(
          search: FluentIcons.search_and_apps,
          clear: FluentIcons.clear,
          close: FluentIcons.chrome_close,
        ),
        viewMode: AdvancedSearchViewMode.list,
        showStats: true,
      ),
      itemBuilder: _buildEmployeeItem,
    );

    if (result != null && mounted) {
      setState(() {
        selectedEmployee = result;
      });
    }
  }

  Widget _buildEmployeeItem(
    BuildContext context,
    FluentAutoSuggestBoxItem<Employee> item,
  ) {
    final theme = FluentTheme.of(context);
    final employee = item.value;

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: theme.accentColor.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              employee.name.substring(0, 2).toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.accentColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(employee.name, style: theme.typography.bodyStrong),
              const SizedBox(height: 4),
              Text(employee.position, style: theme.typography.caption),
              Text(employee.department, style: theme.typography.caption),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(FluentIcons.mail, size: 16, color: theme.accentColor),
            const SizedBox(height: 4),
            Text(employee.email, style: theme.typography.caption),
          ],
        ),
      ],
    );
  }

  List<FluentAutoSuggestBoxItem<Employee>> _getEmployeeItems() {
    final employees = [
      Employee(
        'EMP001',
        'John Smith',
        'john.smith@company.com',
        '+1 234-567-8901',
        'Senior Developer',
        'Engineering',
        'Building A, Floor 3',
      ),
      Employee(
        'EMP002',
        'Sarah Johnson',
        'sarah.j@company.com',
        '+1 234-567-8902',
        'Product Manager',
        'Product',
        'Building B, Floor 2',
      ),
      Employee(
        'EMP003',
        'Mike Wilson',
        'mike.w@company.com',
        '+1 234-567-8903',
        'Sales Director',
        'Sales',
        'Building A, Floor 1',
      ),
      Employee(
        'EMP004',
        'Emily Brown',
        'emily.b@company.com',
        '+1 234-567-8904',
        'HR Manager',
        'HR',
        'Building C, Floor 1',
      ),
      Employee(
        'EMP005',
        'David Lee',
        'david.l@company.com',
        '+1 234-567-8905',
        'Marketing Lead',
        'Marketing',
        'Building B, Floor 3',
      ),
    ];

    return employees
        .map(
          (e) => FluentAutoSuggestBoxItem(
            value: e,
            label: e.name,
            subtitle: Text('${e.position} • ${e.department}'),
          ),
        )
        .toList();
  }

  Future<List<FluentAutoSuggestBoxItem<Employee>>> _searchEmployees(
    String query,
    Map<String, dynamic> filters,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return _getEmployeeItems().where((item) {
      final emp = item.value;
      final searchLower = query.toLowerCase();
      return emp.name.toLowerCase().contains(searchLower) ||
          emp.email.toLowerCase().contains(searchLower) ||
          emp.department.toLowerCase().contains(searchLower) ||
          emp.position.toLowerCase().contains(searchLower);
    }).toList();
  }
}

// ============================================================================
// Example 3: Document Manager with TreeView
// ============================================================================

class DocumentManagerExample extends StatefulWidget {
  const DocumentManagerExample({super.key});

  @override
  State<DocumentManagerExample> createState() => _DocumentManagerExampleState();
}

class _DocumentManagerExampleState extends State<DocumentManagerExample> {
  Document? selectedDocument;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: const Text('Document Manager'),
        commandBar: CommandBar(
          primaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.search),
              label: const Text('Search'),
              onPressed: () => _openDocumentSearch(context),
            ),
            CommandBarButton(
              icon: const Icon(FluentIcons.upload),
              label: const Text('Upload'),
              onPressed: () {},
            ),
            CommandBarButton(
              icon: const Icon(FluentIcons.folder_open),
              label: const Text('Browse'),
              onPressed: () {},
            ),
          ],
        ),
      ),
      content: selectedDocument == null
          ? _buildEmptyState()
          : _buildDocumentView(selectedDocument!),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(FluentIcons.document_search, size: 80),
          const SizedBox(height: 16),
          Text(
            'No document selected',
            style: FluentTheme.of(context).typography.subtitle,
          ),
          const SizedBox(height: 8),
          const Text('Search for documents to view details'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => _openDocumentSearch(context),
            child: const Text('Search Documents'),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentView(Document doc) {
    final theme = FluentTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getDocIcon(doc.type),
                        size: 48,
                        color: theme.accentColor,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc.name, style: theme.typography.title),
                            const SizedBox(height: 4),
                            Text(doc.type, style: theme.typography.caption),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(FluentIcons.download),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(FluentIcons.share),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildDocInfoGrid(doc),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expander(
            header: const Text('Document Details'),
            content: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Size: ${doc.size}'),
                  Text('Created: ${doc.createdDate}'),
                  Text('Modified: ${doc.modifiedDate}'),
                  Text('Path: ${doc.path}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocInfoGrid(Document doc) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildInfoChip('Author', doc.author),
        _buildInfoChip('Size', doc.size),
        _buildInfoChip('Created', doc.createdDate),
        _buildInfoChip('Status', doc.status),
      ],
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).cardColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: FluentTheme.of(context).resources.dividerStrokeColorDefault,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: FluentTheme.of(context).typography.caption),
          const SizedBox(height: 4),
          Text(value, style: FluentTheme.of(context).typography.bodyStrong),
        ],
      ),
    );
  }

  IconData _getDocIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return FluentIcons.pdf;
      case 'word':
        return FluentIcons.document;
      case 'excel':
        return FluentIcons.excel_document;
      case 'powerpoint':
        return FluentIcons.power_point_document;
      case 'image':
        return FluentIcons.photo2;
      default:
        return FluentIcons.document;
    }
  }

  Future<void> _openDocumentSearch(BuildContext context) async {
    final result = await AdvancedSearchDialog.show<Document>(
      context: context,
      items: _getDocumentItems(),
      onSearch: _searchDocuments,
      config: AdvancedSearchConfig(
        title: '📄 Document Search',
        searchHint: 'Search by name, type, or author...',
        theme: AdvancedSearchTheme(
          primaryColor: FluentTheme.of(context).accentColor,
          borderRadius: BorderRadius.circular(10),
          spacing: 20,
        ),
        layout: const AdvancedSearchLayout(
          gridCrossAxisCount: 4,
          gridChildAspectRatio: 0.9,
        ),
        toolbarActions: [
          AdvancedSearchAction(
            icon: FluentIcons.sort,
            tooltip: 'Sort by',
            onPressed: () {},
          ),
          AdvancedSearchAction(
            icon: FluentIcons.filter,
            tooltip: 'Filter',
            onPressed: () {},
          ),
        ],
        viewMode: AdvancedSearchViewMode.grid,
      ),
      itemCardBuilder: _buildDocumentCard,
    );

    if (result != null && mounted) {
      setState(() {
        selectedDocument = result;
      });
    }
  }

  Widget _buildDocumentCard(
    BuildContext context,
    FluentAutoSuggestBoxItem<Document> item,
    bool isSelected,
  ) {
    final theme = FluentTheme.of(context);
    final doc = item.value;

    return Card(
      backgroundColor: isSelected
          ? theme.accentColor.withValues(alpha: 0.1)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getDocIcon(doc.type),
              size: 48,
              color: isSelected ? theme.accentColor : theme.iconTheme.color,
            ),
            const SizedBox(height: 12),
            Text(
              doc.name,
              style: theme.typography.body,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(doc.type, style: theme.typography.caption),
            const SizedBox(height: 4),
            Text(
              doc.size,
              style: TextStyle(fontSize: 12, color: theme.accentColor),
            ),
          ],
        ),
      ),
    );
  }

  List<FluentAutoSuggestBoxItem<Document>> _getDocumentItems() {
    final documents = [
      Document(
        'Report Q4 2024.pdf',
        'PDF',
        '2.5 MB',
        'John Doe',
        '/documents/reports/',
        '2024-01-15',
        '2024-01-20',
        'Final',
      ),
      Document(
        'Presentation.pptx',
        'PowerPoint',
        '5.2 MB',
        'Sarah Smith',
        '/documents/presentations/',
        '2024-01-10',
        '2024-01-18',
        'Draft',
      ),
      Document(
        'Budget.xlsx',
        'Excel',
        '1.8 MB',
        'Mike Johnson',
        '/documents/finance/',
        '2024-01-05',
        '2024-01-12',
        'Final',
      ),
      Document(
        'Proposal.docx',
        'Word',
        '850 KB',
        'Emily Brown',
        '/documents/proposals/',
        '2024-01-08',
        '2024-01-15',
        'Review',
      ),
      Document(
        'Logo.png',
        'Image',
        '450 KB',
        'Design Team',
        '/documents/assets/',
        '2024-01-01',
        '2024-01-01',
        'Final',
      ),
    ];

    return documents
        .map(
          (d) => FluentAutoSuggestBoxItem(
            value: d,
            label: d.name,
            subtitle: Text('${d.type} • ${d.size} • ${d.author}'),
          ),
        )
        .toList();
  }

  Future<List<FluentAutoSuggestBoxItem<Document>>> _searchDocuments(
    String query,
    Map<String, dynamic> filters,
  ) async {
    await Future.delayed(const Duration(milliseconds: 250));

    return _getDocumentItems().where((item) {
      final doc = item.value;
      final searchLower = query.toLowerCase();
      return doc.name.toLowerCase().contains(searchLower) ||
          doc.type.toLowerCase().contains(searchLower) ||
          doc.author.toLowerCase().contains(searchLower);
    }).toList();
  }
}

// ============================================================================
// Data Models
// ============================================================================

class Product {
  final String name;
  final String sku;
  final String category;
  final double price;
  final int stock;

  Product(this.name, this.sku, this.category, this.price, this.stock);
}

class Employee {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String position;
  final String department;
  final String location;

  Employee(
    this.id,
    this.name,
    this.email,
    this.phone,
    this.position,
    this.department,
    this.location,
  );
}

class Document {
  final String name;
  final String type;
  final String size;
  final String author;
  final String path;
  final String createdDate;
  final String modifiedDate;
  final String status;

  Document(
    this.name,
    this.type,
    this.size,
    this.author,
    this.path,
    this.createdDate,
    this.modifiedDate,
    this.status,
  );
}

// ============================================================================
// Main Demo Page
// ============================================================================

class FluentAdvancedSearchDemos extends StatefulWidget {
  const FluentAdvancedSearchDemos({super.key});

  @override
  State<FluentAdvancedSearchDemos> createState() =>
      _FluentAdvancedSearchDemosState();
}

class _FluentAdvancedSearchDemosState extends State<FluentAdvancedSearchDemos> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: const NavigationAppBar(title: Text('Advanced Search Examples')),
      pane: NavigationPane(
        selected: selectedIndex,
        onChanged: (index) => setState(() => selectedIndex = index),
        displayMode: PaneDisplayMode.open,
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.product_catalog),
            title: const Text('Product Search'),
            body: const ProductSearchExample(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.people),
            title: const Text('Employee Directory'),
            body: const EmployeeDirectoryExample(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.document_management),
            title: const Text('Document Manager'),
            body: const DocumentManagerExample(),
          ),
        ],
        footerItems: [
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Settings'),
            body: const Center(child: Text('Settings')),
          ),
        ],
      ),
    );
  }
}
