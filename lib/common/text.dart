import 'dart:ui';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FluentTextField extends StatelessWidget {
  const FluentTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlignVertical,
    this.showCursor,
    this.smartDashesType,
    this.smartQuotesType,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    this.onEditingComplete,
    this.inputFormatters,
    this.cursorHeight,
    this.cursorColor,
    this.keyboardAppearance,
    this.enableInteractiveSelection,
    this.selectionControls,
    this.scrollPhysics,
    this.autofillHints,
    this.scrollController,
    this.restorationId,
    this.maxLengthEnforcement,
    this.decoration,
    this.highlightColor,
    this.unfocusedColor,
    this.contextMenuBuilder,
    this.magnifierConfiguration,
    this.spellCheckConfiguration,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.readOnly = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.expands = false,
    this.padding = kTextBoxPadding,
    this.enabled = true,
    this.cursorWidth = 2.0,
    this.cursorRadius = const Radius.circular(2.0),
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.clipBehavior = Clip.antiAlias,
    this.prefixMode = OverlayVisibilityMode.always,
    this.suffixMode = OverlayVisibilityMode.always,
    this.dragStartBehavior = DragStartBehavior.start,
    this.selectionHeightStyle = BoxHeightStyle.tight,
    this.selectionWidthStyle = BoxWidthStyle.tight,
    this.enableIMEPersonalizedLearning = true,
    this.stylusHandwritingEnabled = true,
    this.boxDecoration,
    this.onSubmitted,
  });

  final InputDecoration? decoration;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final bool? showCursor;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final EdgeInsetsGeometry padding;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function()? onEditingComplete;

  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final ScrollController? scrollController;
  final Clip clipBehavior;
  final OverlayVisibilityMode prefixMode;
  final OverlayVisibilityMode suffixMode;
  final DragStartBehavior dragStartBehavior;
  final String? restorationId;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final BoxHeightStyle selectionHeightStyle;
  final BoxWidthStyle selectionWidthStyle;
  final WidgetStateProperty<BoxDecoration>? boxDecoration;
  final bool enableIMEPersonalizedLearning;
  final bool stylusHandwritingEnabled;
  final Color? highlightColor;
  final Color? unfocusedColor;
  final Widget Function(BuildContext, EditableTextState)? contextMenuBuilder;
  final TextMagnifierConfiguration? magnifierConfiguration;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final box = TextBox(
      onSubmitted: onSubmitted,
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      style: style,
      strutStyle: strutStyle,
      textDirection: textDirection,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      autofocus: autofocus,
      readOnly: readOnly,
      showCursor: showCursor,
      obscuringCharacter: obscuringCharacter,
      obscureText: obscureText,
      autocorrect: autocorrect,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      enableSuggestions: enableSuggestions,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      maxLength: maxLength,
      padding: padding,
      onChanged: onChanged,
      onTap: onTap,
      onTapOutside: onTapOutside,
      onEditingComplete: onEditingComplete,
      inputFormatters: inputFormatters,
      enabled: enabled,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      keyboardAppearance: keyboardAppearance,
      scrollPadding: scrollPadding,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      scrollPhysics: scrollPhysics,
      autofillHints: autofillHints,
      placeholder: decoration?.hintText,
      placeholderStyle: (decoration?.hintStyle ?? TextStyle()).copyWith(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      scrollController: scrollController,
      clipBehavior: clipBehavior,
      prefix: decoration?.prefix,
      prefixMode: prefixMode,
      suffix: decoration?.suffix,
      suffixMode: suffixMode,
      dragStartBehavior: dragStartBehavior,
      restorationId: restorationId,
      maxLengthEnforcement: maxLengthEnforcement,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      decoration: boxDecoration,
      enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
      stylusHandwritingEnabled: stylusHandwritingEnabled,
      highlightColor: highlightColor,
      unfocusedColor: unfocusedColor,
      contextMenuBuilder: contextMenuBuilder,
      magnifierConfiguration: magnifierConfiguration,
      spellCheckConfiguration: spellCheckConfiguration,
    );

    if (decoration != null) {
      return InputDecorator(
        decoration: InputDecoration(
          filled: false,
          border: InputBorder.none,
          contentPadding: decoration!.contentPadding,
          prefixIcon: decoration!.prefixIcon,
          suffixIcon: decoration!.suffixIcon,
          label: decoration!.label,
          labelText: decoration!.labelText,
          helper: decoration!.helper,
          helperText: decoration!.helperText,
          helperMaxLines: decoration!.helperMaxLines,
          helperStyle: decoration!.helperStyle,
          counter: decoration!.counter,
          counterText: decoration!.counterText,
          counterStyle: decoration!.counterStyle,
          icon: decoration!.icon,
          focusColor: decoration!.focusColor,
          hoverColor: decoration!.hoverColor,
        ),
        child: box,
      );
    }
    return box;
  }
}
