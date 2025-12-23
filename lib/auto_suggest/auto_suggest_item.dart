part of 'auto_suggest.dart';

const double kDefaultItemHeight = 50.0;

/// Represents a single item in the auto suggest box
class FluentAutoSuggestBoxItem<T> {
  FluentAutoSuggestBoxItem({
    required this.value,
    required this.label,
    this.child,
    this.subtitle,
    this.onFocusChange,
    this.onSelected,
    this.semanticLabel,
    this.enabled = true,
  });

  final T value;
  final String label;
  final Widget? child;
  final Widget? subtitle;
  final ValueChanged<bool>? onFocusChange;
  final VoidCallback? onSelected;
  final String? semanticLabel;
  final bool enabled;

  bool _selected = false;
  bool get isSelected => _selected;
  set isSelected(bool selected) {
    if (_selected != selected) {
      _selected = selected;
      onFocusChange?.call(selected);
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FluentAutoSuggestBoxItem && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

/// Widget for displaying an auto suggest box item with animation
class AutoSuggestItemTile extends StatefulWidget {
  const AutoSuggestItemTile({
    super.key,
    required this.title,
    this.subtitle,
    this.selected = false,
    this.onSelected,
    this.semanticLabel,
    this.enabled = true,
  });

  final Widget title;
  final Widget? subtitle;
  final VoidCallback? onSelected;
  final bool selected;
  final String? semanticLabel;
  final bool enabled;

  @override
  State<AutoSuggestItemTile> createState() => _AutoSuggestItemTileState();
}

class _AutoSuggestItemTileState extends State<AutoSuggestItemTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 125),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.75,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 4),
      child: ListTile.selectable(
        title: FadeTransition(opacity: _fadeAnimation, child: widget.title),
        subtitle: widget.subtitle == null
            ? null
            : FadeTransition(
                opacity: _fadeAnimation,
                child: DefaultTextStyle(
                  style: (theme.textTheme.bodySmall ?? const TextStyle())
                      .copyWith(color: theme.colorScheme.outline),
                  child: widget.subtitle!,
                ),
              ),
        selected: widget.selected,
        onPressed: widget.enabled ? widget.onSelected : null,
      ),
    );
  }
}

/// Builder for creating custom item widgets
typedef ItemBuilder<T> =
    Widget Function(BuildContext context, FluentAutoSuggestBoxItem<T> item);

/// Default item builder
Widget defaultItemBuilder<T>(
  BuildContext context,
  FluentAutoSuggestBoxItem<T> item,
  bool selected,
  VoidCallback? onTap,
) {
  final theme = Theme.of(context);

  return AutoSuggestItemTile(
    title: DefaultTextStyle.merge(
      style: item.enabled
          ? const TextStyle(fontSize: 14)
          : TextStyle(color: theme.colorScheme.outline),
      child:
          item.child ??
          Tooltip(
            message: item.label,
            child: Text(item.label, overflow: TextOverflow.ellipsis),
          ),
    ),
    subtitle: item.subtitle,
    semanticLabel: item.semanticLabel ?? item.label,
    selected: selected,
    onSelected: onTap,
    enabled: item.enabled,
  );
}
