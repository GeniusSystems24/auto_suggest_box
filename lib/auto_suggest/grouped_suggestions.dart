import 'package:flutter/material.dart' hide Card, ListTile, Divider, Tooltip, IconButton, Colors, DividerThemeData;
import 'package:fluent_ui/fluent_ui.dart';

import 'auto_suggest_item.dart';

/// Represents a group of suggestion items
class SuggestionGroup<T> {
  const SuggestionGroup({
    required this.title,
    required this.items,
    this.icon,
    this.subtitle,
    this.isExpanded = true,
    this.showItemCount = true,
    this.headerBuilder,
    this.dividerBuilder,
  });

  /// The title of the group
  final String title;

  /// The items in this group
  final List<FluentAutoSuggestBoxItem<T>> items;

  /// Optional icon for the group header
  final IconData? icon;

  /// Optional subtitle for the group header
  final String? subtitle;

  /// Whether the group is initially expanded
  final bool isExpanded;

  /// Whether to show item count in the header
  final bool showItemCount;

  /// Custom builder for the group header
  final Widget Function(BuildContext context, SuggestionGroup<T> group, bool isExpanded, VoidCallback onToggle)? headerBuilder;

  /// Custom builder for divider between groups
  final Widget Function(BuildContext context)? dividerBuilder;

  /// Get the total number of items in this group
  int get itemCount => items.length;

  /// Create a copy with modified properties
  SuggestionGroup<T> copyWith({
    String? title,
    List<FluentAutoSuggestBoxItem<T>>? items,
    IconData? icon,
    String? subtitle,
    bool? isExpanded,
    bool? showItemCount,
    Widget Function(BuildContext, SuggestionGroup<T>, bool, VoidCallback)? headerBuilder,
    Widget Function(BuildContext)? dividerBuilder,
  }) {
    return SuggestionGroup<T>(
      title: title ?? this.title,
      items: items ?? this.items,
      icon: icon ?? this.icon,
      subtitle: subtitle ?? this.subtitle,
      isExpanded: isExpanded ?? this.isExpanded,
      showItemCount: showItemCount ?? this.showItemCount,
      headerBuilder: headerBuilder ?? this.headerBuilder,
      dividerBuilder: dividerBuilder ?? this.dividerBuilder,
    );
  }
}

/// Configuration for grouped suggestions display
class GroupedSuggestionsConfig {
  const GroupedSuggestionsConfig({
    this.showGroupHeaders = true,
    this.collapsible = true,
    this.showDividers = true,
    this.stickyHeaders = false,
    this.headerPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.headerBackgroundColor,
    this.headerTextStyle,
    this.headerIconSize = 16.0,
    this.dividerColor,
    this.dividerIndent = 12.0,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  /// Whether to show group headers
  final bool showGroupHeaders;

  /// Whether groups can be collapsed
  final bool collapsible;

  /// Whether to show dividers between groups
  final bool showDividers;

  /// Whether headers should be sticky when scrolling
  final bool stickyHeaders;

  /// Padding for group headers
  final EdgeInsetsGeometry headerPadding;

  /// Background color for group headers
  final Color? headerBackgroundColor;

  /// Text style for group headers
  final TextStyle? headerTextStyle;

  /// Size of the icon in group headers
  final double headerIconSize;

  /// Color for dividers between groups
  final Color? dividerColor;

  /// Indent for dividers
  final double dividerIndent;

  /// Animation duration for expand/collapse
  final Duration animationDuration;
}

/// Widget for displaying grouped suggestions
class GroupedSuggestionsOverlay<T> extends StatefulWidget {
  const GroupedSuggestionsOverlay({
    super.key,
    required this.groups,
    required this.onSelected,
    this.config = const GroupedSuggestionsConfig(),
    this.selectedItem,
    this.itemBuilder,
    this.maxHeight = 380.0,
    this.emptyBuilder,
  });

  /// The groups to display
  final List<SuggestionGroup<T>> groups;

  /// Callback when an item is selected
  final ValueChanged<FluentAutoSuggestBoxItem<T>> onSelected;

  /// Configuration for the display
  final GroupedSuggestionsConfig config;

  /// Currently selected item
  final FluentAutoSuggestBoxItem<T>? selectedItem;

  /// Custom builder for items
  final ItemBuilder<T>? itemBuilder;

  /// Maximum height of the overlay
  final double maxHeight;

  /// Builder for empty state
  final WidgetBuilder? emptyBuilder;

  @override
  State<GroupedSuggestionsOverlay<T>> createState() => _GroupedSuggestionsOverlayState<T>();
}

class _GroupedSuggestionsOverlayState<T> extends State<GroupedSuggestionsOverlay<T>> {
  late Map<String, bool> _expandedState;

  @override
  void initState() {
    super.initState();
    _expandedState = {
      for (final group in widget.groups) group.title: group.isExpanded,
    };
  }

  @override
  void didUpdateWidget(GroupedSuggestionsOverlay<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Add new groups to expanded state
    for (final group in widget.groups) {
      if (!_expandedState.containsKey(group.title)) {
        _expandedState[group.title] = group.isExpanded;
      }
    }
  }

  void _toggleGroup(String title) {
    if (widget.config.collapsible) {
      setState(() {
        _expandedState[title] = !(_expandedState[title] ?? true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.groups.isEmpty || widget.groups.every((g) => g.items.isEmpty)) {
      return widget.emptyBuilder?.call(context) ?? _buildEmptyState(context);
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: widget.maxHeight),
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: _calculateItemCount(),
        itemBuilder: _buildItem,
      ),
    );
  }

  int _calculateItemCount() {
    int count = 0;
    for (int i = 0; i < widget.groups.length; i++) {
      final group = widget.groups[i];
      if (widget.config.showGroupHeaders) {
        count++; // Header
      }
      if (_expandedState[group.title] ?? true) {
        count += group.items.length;
      }
      if (widget.config.showDividers && i < widget.groups.length - 1) {
        count++; // Divider
      }
    }
    return count;
  }

  Widget _buildItem(BuildContext context, int index) {
    int currentIndex = 0;

    for (int groupIndex = 0; groupIndex < widget.groups.length; groupIndex++) {
      final group = widget.groups[groupIndex];
      final isExpanded = _expandedState[group.title] ?? true;

      // Check if this is a header
      if (widget.config.showGroupHeaders) {
        if (currentIndex == index) {
          return _buildGroupHeader(context, group, isExpanded);
        }
        currentIndex++;
      }

      // Check if this is an item in the group
      if (isExpanded) {
        for (int itemIndex = 0; itemIndex < group.items.length; itemIndex++) {
          if (currentIndex == index) {
            return _buildGroupItem(context, group.items[itemIndex]);
          }
          currentIndex++;
        }
      }

      // Check if this is a divider
      if (widget.config.showDividers && groupIndex < widget.groups.length - 1) {
        if (currentIndex == index) {
          return _buildDivider(context, group);
        }
        currentIndex++;
      }
    }

    return const SizedBox.shrink();
  }

  Widget _buildGroupHeader(BuildContext context, SuggestionGroup<T> group, bool isExpanded) {
    if (group.headerBuilder != null) {
      return group.headerBuilder!(context, group, isExpanded, () => _toggleGroup(group.title));
    }

    final theme = FluentTheme.of(context);
    final config = widget.config;

    return Container(
      padding: config.headerPadding,
      color: config.headerBackgroundColor ?? theme.scaffoldBackgroundColor.withOpacity(0.9),
      child: InkWell(
        onTap: config.collapsible ? () => _toggleGroup(group.title) : null,
        child: Row(
          children: [
            if (group.icon != null) ...[
              Icon(group.icon, size: config.headerIconSize),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    group.title,
                    style: config.headerTextStyle ?? theme.typography.bodyStrong,
                  ),
                  if (group.subtitle != null)
                    Text(
                      group.subtitle!,
                      style: theme.typography.caption,
                    ),
                ],
              ),
            ),
            if (group.showItemCount)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${group.itemCount}',
                  style: theme.typography.caption?.copyWith(
                    color: theme.accentColor,
                  ),
                ),
              ),
            if (config.collapsible) ...[
              const SizedBox(width: 8),
              AnimatedRotation(
                duration: config.animationDuration,
                turns: isExpanded ? 0.5 : 0,
                child: Icon(
                  FluentIcons.chevron_down,
                  size: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGroupItem(BuildContext context, FluentAutoSuggestBoxItem<T> item) {
    final isSelected = widget.selectedItem == item;

    if (widget.itemBuilder != null) {
      return widget.itemBuilder!(context, item);
    }

    return defaultItemBuilder<T>(
      context,
      item,
      isSelected,
      item.enabled ? () => widget.onSelected(item) : null,
    );
  }

  Widget _buildDivider(BuildContext context, SuggestionGroup<T> group) {
    if (group.dividerBuilder != null) {
      return group.dividerBuilder!(context);
    }

    return Divider(
      style: DividerThemeData(
        decoration: BoxDecoration(
          color: widget.config.dividerColor,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = FluentTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            FluentIcons.search,
            size: 48,
            color: theme.accentColor.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'No suggestions',
            style: theme.typography.subtitle,
          ),
        ],
      ),
    );
  }
}

/// Helper function to group items by a key
List<SuggestionGroup<T>> groupItemsBy<T, K>(
  List<FluentAutoSuggestBoxItem<T>> items,
  K Function(FluentAutoSuggestBoxItem<T> item) keySelector, {
  String Function(K key)? titleBuilder,
  IconData Function(K key)? iconBuilder,
  int Function(K a, K b)? sortGroups,
}) {
  final Map<K, List<FluentAutoSuggestBoxItem<T>>> grouped = {};

  for (final item in items) {
    final key = keySelector(item);
    grouped.putIfAbsent(key, () => []).add(item);
  }

  var keys = grouped.keys.toList();
  if (sortGroups != null) {
    keys.sort(sortGroups);
  }

  return keys.map((key) {
    return SuggestionGroup<T>(
      title: titleBuilder?.call(key) ?? key.toString(),
      items: grouped[key]!,
      icon: iconBuilder?.call(key),
    );
  }).toList();
}

/// Helper function to group items alphabetically by label
List<SuggestionGroup<T>> groupItemsAlphabetically<T>(
  List<FluentAutoSuggestBoxItem<T>> items, {
  bool includeNumbers = true,
  String numbersGroupTitle = '#',
}) {
  return groupItemsBy<T, String>(
    items,
    (item) {
      final firstChar = item.label.isNotEmpty ? item.label[0].toUpperCase() : '';
      if (RegExp(r'[A-Z]').hasMatch(firstChar)) {
        return firstChar;
      }
      return includeNumbers ? numbersGroupTitle : '';
    },
    sortGroups: (a, b) {
      if (a == numbersGroupTitle) return -1;
      if (b == numbersGroupTitle) return 1;
      return a.compareTo(b);
    },
  );
}
