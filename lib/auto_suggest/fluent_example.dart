import 'package:flutter/material.dart';

import 'auto_suggest.dart';

/// Fluent Design styled examples inspired by modern UI patterns

// ============================================================================
// Fluent Design Theme Configuration
// ============================================================================

class FluentThemeConfig {
  // Colors inspired by the images
  static const primaryColor = Color(0xFF0078D4);
  static const secondaryColor = Color(0xFF005A9E);
  static const successColor = Color(0xFF107C10);
  static const warningColor = Color(0xFFFFB900);
  static const errorColor = Color(0xFFE81123);

  static const cardBackground = Color(0xFFFFFFFF);
  static const pageBackground = Color(0xFFF3F3F3);
  static const dividerColor = Color(0xFFE1E1E1);

  static const textPrimary = Color(0xFF323130);
  static const textSecondary = Color(0xFF605E5C);
  static const textTertiary = Color(0xFF8A8886);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(primary: primaryColor, secondary: secondaryColor, surface: cardBackground, error: errorColor),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: dividerColor, width: 1),
        ),
        color: cardBackground,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      scaffoldBackgroundColor: pageBackground,
      dividerColor: dividerColor,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: textPrimary,
        titleTextStyle: TextStyle(color: textPrimary, fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ============================================================================
// Example 1: Employee Attendance Search (Inspired by Image 1)
// ============================================================================

class EmployeeAttendanceExample extends StatefulWidget {
  const EmployeeAttendanceExample({super.key});

  @override
  State<EmployeeAttendanceExample> createState() => _EmployeeAttendanceExampleState();
}

class _EmployeeAttendanceExampleState extends State<EmployeeAttendanceExample> {
  final employees = [
    Employee(
      id: '39468846',
      name: 'Bagus Fikri',
      location: 'Jl. Jendral Sudirman...',
      clockIn: '10:02 AM',
      clockOut: '07:00 PM',
      duration: '8h 58m',
      overtime: '2h 12m',
      status: EmployeeStatus.present,
    ),
    Employee(
      id: '54634543',
      name: 'Indizein',
      location: 'Jl. Ahmad Yani No...',
      clockIn: '09:30 AM',
      clockOut: '07:12 PM',
      duration: '9h 18m',
      overtime: '-',
      status: EmployeeStatus.present,
    ),
    Employee(
      id: '82473837',
      name: 'Mufti Hidayat',
      location: 'Jl. Diponegoro No...',
      clockIn: '09:24 AM',
      clockOut: '05:00 PM',
      duration: '7h 36m',
      overtime: '-',
      status: EmployeeStatus.present,
    ),
    Employee(
      id: '39468846',
      name: 'Fauzan Ardiansyah',
      location: 'Jl. Basuki Rahmat...',
      clockIn: '08:56 AM',
      clockOut: '05:01 PM',
      duration: '10h 12m',
      overtime: '-',
      status: EmployeeStatus.present,
    ),
    Employee(
      id: '92884744',
      name: 'Raihan Fikri',
      location: 'Jl. Raya Bogor Km...',
      clockIn: '08:56 AM',
      clockOut: '07:00 PM',
      duration: '10h 12m',
      overtime: '-',
      status: EmployeeStatus.present,
    ),
  ];

  Employee? selectedEmployee;

  @override
  Widget build(BuildContext context) {
    final items = employees
        .map(
          (e) => FluentAutoSuggestBoxItem<Employee>(
            value: e,
            label: e.name,
            subtitle: Text('ID: ${e.id} • ${e.location}', style: TextStyle(fontSize: 12, color: FluentThemeConfig.textTertiary)),
          ),
        )
        .toList();

    return Scaffold(
      backgroundColor: FluentThemeConfig.pageBackground,
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Text('Monday, 15 October', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.download, size: 18),
                  label: Text('Attendance Report'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FluentThemeConfig.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          Container(
            padding: EdgeInsets.all(24),
            color: Colors.white,
            child: Row(
              children: [
                _buildSummaryCard('Present Summary', [
                  _SummaryItem('On time', '265', '+12', Colors.green),
                  _SummaryItem('Late clock-in', '62', '-6', Colors.orange),
                  _SummaryItem('Early clock-in', '224', '-6', Colors.blue),
                ]),
                SizedBox(width: 16),
                _buildSummaryCard('Not Present Summary', [
                  _SummaryItem('Absent', '42', '+12', Colors.red),
                  _SummaryItem('No clock-in', '36', '-6', Colors.grey),
                  _SummaryItem('No clock-out', '0', '0', Colors.grey),
                ]),
                SizedBox(width: 16),
                _buildSummaryCard('Away Summary', [
                  _SummaryItem('Day off', '0', '-2', Colors.purple),
                  _SummaryItem('Time off', '0', '-6', Colors.indigo),
                ]),
              ],
            ),
          ),

          // Search Bar
          Container(
            padding: EdgeInsets.all(24),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FluentAutoSuggestBox<Employee>(
                    items: items,
                    decoration: InputDecoration(
                      hintText: 'Search employee',
                      prefixIcon: Icon(Icons.search, size: 20),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onSelected: (item) {
                      if (item != null) {
                        setState(() {
                          selectedEmployee = item.value;
                        });
                      }
                    },
                    itemBuilder: (context, item) {
                      return ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          backgroundColor: FluentThemeConfig.primaryColor,
                          child: Text(item.value.name[0], style: TextStyle(color: Colors.white)),
                        ),
                        title: Text(item.value.name),
                        subtitle: item.subtitle,
                      );
                    },
                  ),
                ),
                SizedBox(width: 12),
                _buildFilterButton('Date Range', Icons.calendar_today),
                SizedBox(width: 12),
                _buildFilterButton('Advanced Filter', Icons.filter_list),
              ],
            ),
          ),

          // Employee Table
          Expanded(
            child: Container(
              margin: EdgeInsets.all(24),
              child: Card(
                child: Column(
                  children: [
                    _buildTableHeader(),
                    Expanded(
                      child: ListView.separated(
                        itemCount: employees.length,
                        separatorBuilder: (_, __) => Divider(height: 1),
                        itemBuilder: (context, index) {
                          return _buildEmployeeRow(employees[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, List<_SummaryItem> items) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: FluentThemeConfig.primaryColor),
                  SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: FluentThemeConfig.textPrimary),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: items.map((item) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.label, style: TextStyle(fontSize: 12, color: FluentThemeConfig.textSecondary)),
                      SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item.value,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: FluentThemeConfig.textPrimary),
                          ),
                          SizedBox(width: 4),
                          Text(item.change, style: TextStyle(fontSize: 12, color: item.changeColor)),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, IconData icon) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: FluentThemeConfig.textPrimary,
        side: BorderSide(color: FluentThemeConfig.dividerColor),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: FluentThemeConfig.pageBackground,
        border: Border(bottom: BorderSide(color: FluentThemeConfig.dividerColor)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Employee Name',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: FluentThemeConfig.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              'Clock-in & Out',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: FluentThemeConfig.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              'Overtime',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: FluentThemeConfig.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              'Location',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: FluentThemeConfig.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              'Note',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: FluentThemeConfig.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeRow(Employee employee) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: FluentThemeConfig.primaryColor.withValues(alpha: 0.1),
                  child: Text(
                    employee.name[0],
                    style: TextStyle(color: FluentThemeConfig.primaryColor, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: FluentThemeConfig.textPrimary),
                    ),
                    Text(employee.id, style: TextStyle(fontSize: 12, color: FluentThemeConfig.textTertiary)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.login, size: 12, color: Colors.green),
                    SizedBox(width: 4),
                    Text(
                      employee.clockIn,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.green),
                    ),
                    SizedBox(width: 8),
                    Text(employee.duration, style: TextStyle(fontSize: 12, color: FluentThemeConfig.textTertiary)),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.logout, size: 12, color: Colors.orange),
                    SizedBox(width: 4),
                    Text(
                      employee.clockOut,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.orange),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              employee.overtime,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: employee.overtime != '-' ? FluentThemeConfig.primaryColor : FluentThemeConfig.textTertiary,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Icon(Icons.location_on, size: 14, color: FluentThemeConfig.primaryColor),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    employee.location,
                    style: TextStyle(fontSize: 13, color: FluentThemeConfig.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              'Discussed mutual...',
              style: TextStyle(fontSize: 13, color: FluentThemeConfig.textSecondary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem {
  final String label;
  final String value;
  final String change;
  final Color changeColor;

  _SummaryItem(this.label, this.value, this.change, this.changeColor);
}

// ============================================================================
// Example 2: Invoice Management (Inspired by Image 2)
// ============================================================================

class InvoiceManagementExample extends StatefulWidget {
  const InvoiceManagementExample({super.key});

  @override
  State<InvoiceManagementExample> createState() => _InvoiceManagementExampleState();
}

class _InvoiceManagementExampleState extends State<InvoiceManagementExample> {
  final invoices = [
    Invoice(id: 'C-100432', client: 'Adamas Bryan Tiktok VT', amount: 298, status: InvoiceStatus.draft, date: 'December 20, 2024'),
    Invoice(id: 'C-100433', client: 'Adamas Bryan Tiktok VT', amount: 321, status: InvoiceStatus.inProgress, date: 'December 20, 2024'),
    Invoice(id: 'B-100293', client: 'Adamas Bryan Tiktok VT', amount: 108, status: InvoiceStatus.approved, date: 'December 20, 2024'),
    Invoice(id: 'C-100193', client: 'Adamas Bryan Tiktok VT', amount: 237, status: InvoiceStatus.overdue, date: 'December 20, 2024'),
  ];

  Invoice? selectedInvoice;

  @override
  Widget build(BuildContext context) {
    final items = invoices
        .map(
          (inv) => FluentAutoSuggestBoxItem<Invoice>(
            value: inv,
            label: '${inv.id} - ${inv.client}',
            subtitle: Text('\$${inv.amount} • ${inv.date}', style: TextStyle(fontSize: 12, color: FluentThemeConfig.textTertiary)),
          ),
        )
        .toList();

    return Scaffold(
      backgroundColor: FluentThemeConfig.pageBackground,
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 280,
            color: Colors.white,
            child: Column(children: [_buildSidebarHeader(), _buildSidebarMenu()]),
          ),

          // Invoice List
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildInvoiceListHeader(items),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: invoices.length,
                      itemBuilder: (context, index) {
                        return _buildInvoiceCard(invoices[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Invoice Details
          Expanded(
            flex: 3,
            child: selectedInvoice != null
                ? _buildInvoiceDetails(selectedInvoice!)
                : Center(
                    child: Text('Select an invoice to view details', style: TextStyle(color: FluentThemeConfig.textTertiary)),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: FluentThemeConfig.primaryColor, borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.ac_unit, color: Colors.white, size: 24),
          ),
          SizedBox(width: 12),
          Text(
            'Athenz',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: FluentThemeConfig.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarMenu() {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12),
        children: [
          _buildMenuSection('MENU'),
          _buildMenuItem(Icons.home_outlined, 'Home', false),
          _buildMenuItem(Icons.inventory_2_outlined, 'Products', false),
          _buildMenuItem(Icons.people_outline, 'Customer', false),
          _buildMenuItem(Icons.local_offer_outlined, 'Promotions', false),
          _buildMenuItem(Icons.receipt_long, 'Invoice', true),
          _buildMenuItem(Icons.analytics_outlined, 'Sales', false),
          _buildMenuItem(Icons.settings_outlined, 'Settings', false),
          SizedBox(height: 24),
          _buildMenuSection('QUICK ACCESS'),
          _buildMenuItem(Icons.campaign_outlined, 'PR Planning', false),
          _buildMenuItem(Icons.auto_awesome_outlined, 'Marketing', false),
          _buildMenuItem(Icons.work_outline, 'Project', false),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 12, top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: FluentThemeConfig.textTertiary, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, bool selected) {
    return Container(
      margin: EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: selected ? FluentThemeConfig.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, size: 20, color: selected ? FluentThemeConfig.primaryColor : FluentThemeConfig.textSecondary),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: selected ? FluentThemeConfig.primaryColor : FluentThemeConfig.textPrimary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceListHeader(List<FluentAutoSuggestBoxItem<Invoice>> items) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: FluentThemeConfig.dividerColor)),
      ),
      child: Row(
        children: [
          Text(
            'Invoices',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: FluentThemeConfig.textPrimary),
          ),
          SizedBox(width: 24),
          Expanded(
            child: FluentAutoSuggestBox<Invoice>(
              items: items,
              decoration: InputDecoration(
                hintText: 'All invoice',
                suffixIcon: Icon(Icons.arrow_drop_down, size: 20),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onSelected: (item) {
                if (item != null) {
                  setState(() {
                    selectedInvoice = item.value;
                  });
                }
              },
            ),
          ),
          SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: FluentThemeConfig.primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: Icon(Icons.add, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceCard(Invoice invoice) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedInvoice = invoice;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildStatusBadge(invoice.status),
                        Spacer(),
                        Text(
                          '\$${invoice.amount}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: FluentThemeConfig.textPrimary),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      invoice.client,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: FluentThemeConfig.textPrimary),
                    ),
                    SizedBox(height: 4),
                    Text('${invoice.id} | ${invoice.date}', style: TextStyle(fontSize: 12, color: FluentThemeConfig.textTertiary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(InvoiceStatus status) {
    Color color;
    String label;

    switch (status) {
      case InvoiceStatus.draft:
        color = FluentThemeConfig.textTertiary;
        label = 'Draft';
        break;
      case InvoiceStatus.inProgress:
        color = FluentThemeConfig.primaryColor;
        label = 'In Progress';
        break;
      case InvoiceStatus.approved:
        color = FluentThemeConfig.successColor;
        label = 'Approved';
        break;
      case InvoiceStatus.overdue:
        color = FluentThemeConfig.errorColor;
        label = 'Overdue';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  Widget _buildInvoiceDetails(Invoice invoice) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedInvoice = null;
                  });
                },
              ),
              SizedBox(width: 12),
              Text(
                'Create Invoice',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: FluentThemeConfig.textPrimary),
              ),
            ],
          ),
          SizedBox(height: 32),
          Expanded(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invoice Details',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: FluentThemeConfig.textPrimary),
                      ),
                      SizedBox(height: 24),
                      _buildFormField('Invoice ID', invoice.id),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildFormField('Date Issue', '02/05/24')),
                          SizedBox(width: 16),
                          Expanded(child: _buildFormField('Payment Date', '09/05/24')),
                        ],
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Item Number 1',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: FluentThemeConfig.textPrimary),
                      ),
                      SizedBox(height: 16),
                      _buildFormField('Item Name', '3 Minutes Tiktok Video Review'),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildFormField('Amount', '\$1000')),
                          SizedBox(width: 16),
                          Expanded(child: _buildFormField('Taxes', 'VAT 10%')),
                        ],
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Displayed Information',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: FluentThemeConfig.textPrimary),
                      ),
                      SizedBox(height: 16),
                      _buildFormField('Company name or VAT-ID', 'FR Management'),
                      SizedBox(height: 16),
                      _buildFormField('Email', 'charleclerc@gmail.com'),
                      SizedBox(height: 16),
                      _buildFormField('Phone Number', '+62 813 0011 0022'),
                      SizedBox(height: 16),
                      _buildFormField('IBAN Number', 'PL22 1140 1240 1450 2222 0000 1607'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: FluentThemeConfig.textSecondary),
        ),
        SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
        ),
      ],
    );
  }
}

// ============================================================================
// Models
// ============================================================================

enum EmployeeStatus { present, absent, late }

class Employee {
  final String id;
  final String name;
  final String location;
  final String clockIn;
  final String clockOut;
  final String duration;
  final String overtime;
  final EmployeeStatus status;

  Employee({
    required this.id,
    required this.name,
    required this.location,
    required this.clockIn,
    required this.clockOut,
    required this.duration,
    required this.overtime,
    required this.status,
  });
}

enum InvoiceStatus { draft, inProgress, approved, overdue }

class Invoice {
  final String id;
  final String client;
  final double amount;
  final InvoiceStatus status;
  final String date;

  Invoice({required this.id, required this.client, required this.amount, required this.status, required this.date});
}

// ============================================================================
// Demo App
// ============================================================================

class FluentExamplesApp extends StatelessWidget {
  const FluentExamplesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluent AutoSuggest Examples',
      theme: FluentThemeConfig.theme,
      home: const FluentExamplesHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FluentExamplesHome extends StatefulWidget {
  const FluentExamplesHome({super.key});

  @override
  State<FluentExamplesHome> createState() => _FluentExamplesHomeState();
}

class _FluentExamplesHomeState extends State<FluentExamplesHome> {
  int _selectedIndex = 0;

  final _examples = [('Employee Attendance', EmployeeAttendanceExample()), ('Invoice Management', InvoiceManagementExample())];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: Colors.white,
            selectedIconTheme: IconThemeData(color: FluentThemeConfig.primaryColor),
            selectedLabelTextStyle: TextStyle(color: FluentThemeConfig.primaryColor, fontWeight: FontWeight.w600),
            destinations: _examples.map((example) {
              return NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text(example.$1),
              );
            }).toList(),
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(child: _examples[_selectedIndex].$2),
        ],
      ),
    );
  }
}
