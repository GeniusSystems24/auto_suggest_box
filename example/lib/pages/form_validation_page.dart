import 'package:fluent_ui/fluent_ui.dart';
import 'package:auto_suggest_box/auto_suggest/auto_suggest.dart';
import 'package:flutter/material.dart' show InputDecoration;
import 'package:gap/gap.dart';

import '../data/sample_data.dart';

class FormValidationPage extends StatefulWidget {
  const FormValidationPage({super.key});

  @override
  State<FormValidationPage> createState() => _FormValidationPageState();
}

class _FormValidationPageState extends State<FormValidationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCountry;
  String? _selectedProduct;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('Form Validation'),
      ),
      children: [
        _buildInfoCard(
          'Form with Validation',
          'AutoSuggestBox integrated with Flutter Form validation.',
        ),
        const Gap(16),
        _buildForm(),
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

  Widget _buildForm() {
    return Card(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registration Form',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Gap(24),

            // Name field
            const Text('Full Name *'),
            const Gap(8),
            TextFormBox(
              controller: _nameController,
              placeholder: 'Enter your full name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                if (value.length < 3) {
                  return 'Name must be at least 3 characters';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const Gap(16),

            // Email field
            const Text('Email *'),
            const Gap(8),
            TextFormBox(
              controller: _emailController,
              placeholder: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const Gap(16),

            // Country AutoSuggest with validation
            const Text('Country *'),
            const Gap(8),
            FluentAutoSuggestBox<Country>.form(
              items: sampleCountries
                  .map((c) => FluentAutoSuggestBoxItem(
                        value: c,
                        label: '${c.flag} ${c.name}',
                        subtitle: Text(c.continent),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a country';
                }
                final isValidCountry = sampleCountries.any(
                  (c) => '${c.flag} ${c.name}' == value,
                );
                if (!isValidCountry) {
                  return 'Please select a valid country from the list';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onSelected: (item) {
                setState(() => _selectedCountry = item?.value.name);
              },
              decoration: const InputDecoration(
                hintText: 'Select your country...',
              ),
            ),
            const Gap(16),

            // Product AutoSuggest with validation
            const Text('Preferred Product *'),
            const Gap(8),
            FluentAutoSuggestBox<Product>.form(
              items: sampleProducts
                  .map((p) => FluentAutoSuggestBoxItem(
                        value: p,
                        label: p.name,
                        subtitle: Text('\$${p.price.toStringAsFixed(2)}'),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a product';
                }
                final isValidProduct = sampleProducts.any((p) => p.name == value);
                if (!isValidProduct) {
                  return 'Please select a valid product from the list';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onSelected: (item) {
                setState(() => _selectedProduct = item?.value.name);
              },
              decoration: const InputDecoration(
                hintText: 'Select a product...',
              ),
            ),
            const Gap(24),

            // Submit button
            Row(
              children: [
                FilledButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      displayInfoBar(
                        context,
                        builder: (context, close) {
                          return InfoBar(
                            title: const Text('Form Submitted!'),
                            content: Text(
                              'Name: ${_nameController.text}\n'
                              'Email: ${_emailController.text}\n'
                              'Country: $_selectedCountry\n'
                              'Product: $_selectedProduct',
                            ),
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
                ),
                const Gap(12),
                Button(
                  child: const Text('Reset'),
                  onPressed: () {
                    _formKey.currentState!.reset();
                    _nameController.clear();
                    _emailController.clear();
                    setState(() {
                      _selectedCountry = null;
                      _selectedProduct = null;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
