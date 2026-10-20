import 'package:flutter/widgets.dart';

/// Goes back to the screen named [routeName], closing every screen above it
/// (so their audio players are disposed). If that screen is not in the
/// history, the history is unwound and [routeName] replaces it.
void backToRoute(BuildContext context, String routeName) {
  final navigator = Navigator.of(context);
  var found = false;
  navigator.popUntil((route) {
    if (route.settings.name == routeName) {
      found = true;
      return true;
    }
    return route.isFirst;
  });
  if (!found) navigator.pushReplacementNamed(routeName);
}

/// Returns to the previous screen, or opens [fallbackRoute] when there is none.
void goBack(BuildContext context, String fallbackRoute) {
  final navigator = Navigator.of(context);
  if (navigator.canPop()) {
    navigator.pop();
  } else {
    navigator.pushReplacementNamed(fallbackRoute);
  }
}
