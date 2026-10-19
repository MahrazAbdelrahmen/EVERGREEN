import 'package:flutter/material.dart';

/// Drop-in replacement for the discontinued `floating_snackbar` package,
/// built on the framework's [ScaffoldMessenger].
// ignore: non_constant_identifier_names
void FloatingSnackBar({
  required String message,
  required BuildContext context,
  Color? textColor,
  TextStyle? textStyle,
  Duration duration = const Duration(milliseconds: 4000),
  Color? backgroundColor,
}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textStyle ?? TextStyle(color: textColor),
        ),
        duration: duration,
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
}
