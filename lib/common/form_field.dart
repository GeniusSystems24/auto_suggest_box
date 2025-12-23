import 'package:fluent_ui/fluent_ui.dart';
import 'accent_color_extension.dart';

class ValidatorFormField<T> extends FormField<T> {
  ValidatorFormField({
    super.key,
    super.autovalidateMode,
    super.enabled,
    super.initialValue,
    super.onSaved,
    super.restorationId,
    String? Function()? validator,
    required Widget Function(
      BuildContext context,
      VoidCallback reset,
      bool hasError,
    )
    builder,
    Widget Function(String?)? errorBuilder,
    double? start,
    double? top,
    double? end,
    double? bottom,
    double? width,
    double? height,
  }) : super(
         validator: (c) => validator?.call(),
         builder: (field) {
           return Builder(
             builder: (context) {
               final theme = FluentTheme.of(context);
               return Stack(
                 children: [
                   builder(context, field.reset, field.hasError),
                   if (field.hasError)
                     PositionedDirectional(
                       end: end ?? 0,
                       top: top,
                       start: start,
                       bottom: bottom,
                       width: width ?? 35,
                       height: height ?? 35,
                       child: Tooltip(
                         message: field.errorText ?? "",
                         style: TooltipThemeData(
                           decoration: BoxDecoration(
                             color: Colors.red
                                 .backgroundButton(theme.brightness)
                                 .resolve({WidgetState.selected}),
                           ),
                           showDuration: Duration(milliseconds: 100),
                           waitDuration: Duration(milliseconds: 100),
                         ),
                         child: FilledButton(
                           focusNode: FocusNode(skipTraversal: true),
                           style: ButtonStyle(
                             backgroundColor: Colors.red.backgroundButton(
                               theme.brightness,
                             ),
                             padding: WidgetStatePropertyAll(EdgeInsets.zero),
                           ),
                           onPressed: () {
                             // var messenger = ScaffoldMessenger.of(context);
                             // messenger.clearSnackBars();
                             displayInfoBar(
                               context,
                               builder: (context, close) {
                                 return InfoBar(
                                   title: Text(field.errorText ?? ""),
                                   // content: const Text('A proper warning message of why the user can not do that :/'),
                                   action: IconButton(
                                     icon: const Icon(FluentIcons.clear),
                                     onPressed: close,
                                   ),
                                   severity: InfoBarSeverity.error,
                                 );
                               },
                             );
                           },
                           child: Icon(FluentIcons.error, color: Colors.white),
                         ),
                       ),
                     ),
                 ],
               );
             },
           );
         },
       );
}
