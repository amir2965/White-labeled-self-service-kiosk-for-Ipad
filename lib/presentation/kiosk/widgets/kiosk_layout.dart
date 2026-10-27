import 'package:flutter/widgets.dart';

/// Screens narrower than this (for example the embedded web demo) get slimmer
/// sidebars so the product area keeps enough room. Regular tablets are unaffected.
bool isCompactKiosk(BuildContext context) =>
    MediaQuery.of(context).size.width < 1100;

double kioskCategoryRailWidth(BuildContext context) =>
    isCompactKiosk(context) ? 168 : 220;

double kioskCartWidth(BuildContext context, [double wide = 360]) =>
    isCompactKiosk(context) ? (wide < 300 ? wide : 300) : wide;
