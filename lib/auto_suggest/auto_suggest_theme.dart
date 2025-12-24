import 'package:flutter/material.dart';

/// Design system type for FluentAutoSuggestBox
enum AutoSuggestDesignSystem {
  /// Use Fluent UI components (FluentTextField, FluentTextFormField)
  fluent,

  /// Use Material Design components (TextField, TextFormField)
  material,
}

/// Theme extension for customizing FluentAutoSuggestBox appearance
///
/// Use this to customize the visual appearance of the auto suggest box
/// without modifying the widget directly.
///
/// Example usage:
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     extensions: [
///       FluentAutoSuggestThemeData(
///         designSystem: AutoSuggestDesignSystem.material,
///         textFieldDecoration: InputDecoration(
///           border: OutlineInputBorder(),
///           filled: true,
///         ),
///         overlayBackgroundColor: Colors.white,
///         overlayBorderRadius: 8.0,
///       ),
///     ],
///   ),
/// )
/// ```
class FluentAutoSuggestThemeData extends ThemeExtension<FluentAutoSuggestThemeData> {
  const FluentAutoSuggestThemeData({
    this.designSystem = AutoSuggestDesignSystem.fluent,
    // Text field theming
    this.textFieldDecoration,
    this.textFieldStyle,
    this.textFieldCursorColor,
    this.textFieldCursorWidth,
    this.textFieldCursorHeight,
    this.textFieldCursorRadius,
    this.textFieldFillColor,
    this.textFieldBorderRadius,
    // Overlay theming
    this.overlayBackgroundColor,
    this.overlayCardColor,
    this.overlayBorderRadius,
    this.overlayShadows,
    this.overlayElevation,
    // Item theming
    this.itemBackgroundColor,
    this.itemSelectedBackgroundColor,
    this.itemHoverBackgroundColor,
    this.itemTextStyle,
    this.itemSelectedTextStyle,
    this.itemSubtitleTextStyle,
    this.itemPadding,
    this.itemHeight,
    // Loading state theming
    this.loadingIndicatorColor,
    this.loadingTextStyle,
    // No results theming
    this.noResultsTextStyle,
    this.noResultsSubtitleTextStyle,
    this.noResultsIcon,
    this.noResultsIconColor,
    // General theming
    this.iconColor,
    this.clearButtonColor,
    this.dropdownIconColor,
  });

  /// The design system to use for input components
  final AutoSuggestDesignSystem designSystem;

  // Text field theming
  /// Custom decoration for the text field (Material only)
  final InputDecoration? textFieldDecoration;

  /// Text style for the input
  final TextStyle? textFieldStyle;

  /// Cursor color
  final Color? textFieldCursorColor;

  /// Cursor width
  final double? textFieldCursorWidth;

  /// Cursor height
  final double? textFieldCursorHeight;

  /// Cursor radius
  final Radius? textFieldCursorRadius;

  /// Fill color for the text field
  final Color? textFieldFillColor;

  /// Border radius for the text field
  final double? textFieldBorderRadius;

  // Overlay theming
  /// Background color of the overlay
  final Color? overlayBackgroundColor;

  /// Card color inside the overlay
  final Color? overlayCardColor;

  /// Border radius of the overlay
  final double? overlayBorderRadius;

  /// Custom shadows for the overlay
  final List<BoxShadow>? overlayShadows;

  /// Elevation for the overlay (Material style)
  final double? overlayElevation;

  // Item theming
  /// Background color for items
  final Color? itemBackgroundColor;

  /// Background color for selected items
  final Color? itemSelectedBackgroundColor;

  /// Background color for hovered items
  final Color? itemHoverBackgroundColor;

  /// Text style for item labels
  final TextStyle? itemTextStyle;

  /// Text style for selected item labels
  final TextStyle? itemSelectedTextStyle;

  /// Text style for item subtitles
  final TextStyle? itemSubtitleTextStyle;

  /// Padding for items
  final EdgeInsetsGeometry? itemPadding;

  /// Height of each item
  final double? itemHeight;

  // Loading state theming
  /// Color of the loading indicator
  final Color? loadingIndicatorColor;

  /// Text style for loading message
  final TextStyle? loadingTextStyle;

  // No results theming
  /// Text style for "no results" message
  final TextStyle? noResultsTextStyle;

  /// Text style for "no results" subtitle
  final TextStyle? noResultsSubtitleTextStyle;

  /// Custom icon for no results state
  final IconData? noResultsIcon;

  /// Color for the no results icon
  final Color? noResultsIconColor;

  // General theming
  /// Default icon color
  final Color? iconColor;

  /// Clear button color
  final Color? clearButtonColor;

  /// Dropdown icon color
  final Color? dropdownIconColor;

  @override
  FluentAutoSuggestThemeData copyWith({
    AutoSuggestDesignSystem? designSystem,
    InputDecoration? textFieldDecoration,
    TextStyle? textFieldStyle,
    Color? textFieldCursorColor,
    double? textFieldCursorWidth,
    double? textFieldCursorHeight,
    Radius? textFieldCursorRadius,
    Color? textFieldFillColor,
    double? textFieldBorderRadius,
    Color? overlayBackgroundColor,
    Color? overlayCardColor,
    double? overlayBorderRadius,
    List<BoxShadow>? overlayShadows,
    double? overlayElevation,
    Color? itemBackgroundColor,
    Color? itemSelectedBackgroundColor,
    Color? itemHoverBackgroundColor,
    TextStyle? itemTextStyle,
    TextStyle? itemSelectedTextStyle,
    TextStyle? itemSubtitleTextStyle,
    EdgeInsetsGeometry? itemPadding,
    double? itemHeight,
    Color? loadingIndicatorColor,
    TextStyle? loadingTextStyle,
    TextStyle? noResultsTextStyle,
    TextStyle? noResultsSubtitleTextStyle,
    IconData? noResultsIcon,
    Color? noResultsIconColor,
    Color? iconColor,
    Color? clearButtonColor,
    Color? dropdownIconColor,
  }) {
    return FluentAutoSuggestThemeData(
      designSystem: designSystem ?? this.designSystem,
      textFieldDecoration: textFieldDecoration ?? this.textFieldDecoration,
      textFieldStyle: textFieldStyle ?? this.textFieldStyle,
      textFieldCursorColor: textFieldCursorColor ?? this.textFieldCursorColor,
      textFieldCursorWidth: textFieldCursorWidth ?? this.textFieldCursorWidth,
      textFieldCursorHeight: textFieldCursorHeight ?? this.textFieldCursorHeight,
      textFieldCursorRadius: textFieldCursorRadius ?? this.textFieldCursorRadius,
      textFieldFillColor: textFieldFillColor ?? this.textFieldFillColor,
      textFieldBorderRadius: textFieldBorderRadius ?? this.textFieldBorderRadius,
      overlayBackgroundColor: overlayBackgroundColor ?? this.overlayBackgroundColor,
      overlayCardColor: overlayCardColor ?? this.overlayCardColor,
      overlayBorderRadius: overlayBorderRadius ?? this.overlayBorderRadius,
      overlayShadows: overlayShadows ?? this.overlayShadows,
      overlayElevation: overlayElevation ?? this.overlayElevation,
      itemBackgroundColor: itemBackgroundColor ?? this.itemBackgroundColor,
      itemSelectedBackgroundColor: itemSelectedBackgroundColor ?? this.itemSelectedBackgroundColor,
      itemHoverBackgroundColor: itemHoverBackgroundColor ?? this.itemHoverBackgroundColor,
      itemTextStyle: itemTextStyle ?? this.itemTextStyle,
      itemSelectedTextStyle: itemSelectedTextStyle ?? this.itemSelectedTextStyle,
      itemSubtitleTextStyle: itemSubtitleTextStyle ?? this.itemSubtitleTextStyle,
      itemPadding: itemPadding ?? this.itemPadding,
      itemHeight: itemHeight ?? this.itemHeight,
      loadingIndicatorColor: loadingIndicatorColor ?? this.loadingIndicatorColor,
      loadingTextStyle: loadingTextStyle ?? this.loadingTextStyle,
      noResultsTextStyle: noResultsTextStyle ?? this.noResultsTextStyle,
      noResultsSubtitleTextStyle: noResultsSubtitleTextStyle ?? this.noResultsSubtitleTextStyle,
      noResultsIcon: noResultsIcon ?? this.noResultsIcon,
      noResultsIconColor: noResultsIconColor ?? this.noResultsIconColor,
      iconColor: iconColor ?? this.iconColor,
      clearButtonColor: clearButtonColor ?? this.clearButtonColor,
      dropdownIconColor: dropdownIconColor ?? this.dropdownIconColor,
    );
  }

  @override
  FluentAutoSuggestThemeData lerp(ThemeExtension<FluentAutoSuggestThemeData>? other, double t) {
    if (other is! FluentAutoSuggestThemeData) {
      return this;
    }

    return FluentAutoSuggestThemeData(
      designSystem: t < 0.5 ? designSystem : other.designSystem,
      textFieldDecoration: t < 0.5 ? textFieldDecoration : other.textFieldDecoration,
      textFieldStyle: TextStyle.lerp(textFieldStyle, other.textFieldStyle, t),
      textFieldCursorColor: Color.lerp(textFieldCursorColor, other.textFieldCursorColor, t),
      textFieldCursorWidth: _lerpDouble(textFieldCursorWidth, other.textFieldCursorWidth, t),
      textFieldCursorHeight: _lerpDouble(textFieldCursorHeight, other.textFieldCursorHeight, t),
      textFieldCursorRadius: Radius.lerp(textFieldCursorRadius, other.textFieldCursorRadius, t),
      textFieldFillColor: Color.lerp(textFieldFillColor, other.textFieldFillColor, t),
      textFieldBorderRadius: _lerpDouble(textFieldBorderRadius, other.textFieldBorderRadius, t),
      overlayBackgroundColor: Color.lerp(overlayBackgroundColor, other.overlayBackgroundColor, t),
      overlayCardColor: Color.lerp(overlayCardColor, other.overlayCardColor, t),
      overlayBorderRadius: _lerpDouble(overlayBorderRadius, other.overlayBorderRadius, t),
      overlayShadows: t < 0.5 ? overlayShadows : other.overlayShadows,
      overlayElevation: _lerpDouble(overlayElevation, other.overlayElevation, t),
      itemBackgroundColor: Color.lerp(itemBackgroundColor, other.itemBackgroundColor, t),
      itemSelectedBackgroundColor: Color.lerp(itemSelectedBackgroundColor, other.itemSelectedBackgroundColor, t),
      itemHoverBackgroundColor: Color.lerp(itemHoverBackgroundColor, other.itemHoverBackgroundColor, t),
      itemTextStyle: TextStyle.lerp(itemTextStyle, other.itemTextStyle, t),
      itemSelectedTextStyle: TextStyle.lerp(itemSelectedTextStyle, other.itemSelectedTextStyle, t),
      itemSubtitleTextStyle: TextStyle.lerp(itemSubtitleTextStyle, other.itemSubtitleTextStyle, t),
      itemPadding: EdgeInsetsGeometry.lerp(itemPadding, other.itemPadding, t),
      itemHeight: _lerpDouble(itemHeight, other.itemHeight, t),
      loadingIndicatorColor: Color.lerp(loadingIndicatorColor, other.loadingIndicatorColor, t),
      loadingTextStyle: TextStyle.lerp(loadingTextStyle, other.loadingTextStyle, t),
      noResultsTextStyle: TextStyle.lerp(noResultsTextStyle, other.noResultsTextStyle, t),
      noResultsSubtitleTextStyle: TextStyle.lerp(noResultsSubtitleTextStyle, other.noResultsSubtitleTextStyle, t),
      noResultsIcon: t < 0.5 ? noResultsIcon : other.noResultsIcon,
      noResultsIconColor: Color.lerp(noResultsIconColor, other.noResultsIconColor, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      clearButtonColor: Color.lerp(clearButtonColor, other.clearButtonColor, t),
      dropdownIconColor: Color.lerp(dropdownIconColor, other.dropdownIconColor, t),
    );
  }

  static double? _lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) return null;
    a ??= 0.0;
    b ??= 0.0;
    return a + (b - a) * t;
  }

  /// Default light theme
  static FluentAutoSuggestThemeData light() {
    return FluentAutoSuggestThemeData(
      designSystem: AutoSuggestDesignSystem.fluent,
      overlayBackgroundColor: Colors.white.withOpacity(0.95),
      overlayCardColor: Colors.white,
      overlayBorderRadius: 4.0,
      itemSelectedBackgroundColor: Colors.blue.withOpacity(0.1),
      itemHoverBackgroundColor: Colors.grey.withOpacity(0.1),
      loadingIndicatorColor: Colors.blue,
      iconColor: Colors.grey[600],
      clearButtonColor: Colors.grey[500],
      dropdownIconColor: Colors.grey[600],
    );
  }

  /// Default dark theme
  static FluentAutoSuggestThemeData dark() {
    return FluentAutoSuggestThemeData(
      designSystem: AutoSuggestDesignSystem.fluent,
      overlayBackgroundColor: const Color(0xFF2D2D2D).withOpacity(0.95),
      overlayCardColor: const Color(0xFF2D2D2D),
      overlayBorderRadius: 4.0,
      itemSelectedBackgroundColor: Colors.blue.withOpacity(0.2),
      itemHoverBackgroundColor: Colors.white.withOpacity(0.1),
      loadingIndicatorColor: Colors.blue[300],
      iconColor: Colors.grey[400],
      clearButtonColor: Colors.grey[500],
      dropdownIconColor: Colors.grey[400],
    );
  }

  /// Material theme preset
  static FluentAutoSuggestThemeData material({bool isDark = false}) {
    return FluentAutoSuggestThemeData(
      designSystem: AutoSuggestDesignSystem.material,
      textFieldDecoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      overlayBorderRadius: 8.0,
      overlayElevation: 8.0,
      itemHeight: 48.0,
      itemPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ).copyWith(
      overlayBackgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
      overlayCardColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
      itemSelectedBackgroundColor: isDark
          ? Colors.blue.withOpacity(0.3)
          : Colors.blue.withOpacity(0.1),
    );
  }
}
