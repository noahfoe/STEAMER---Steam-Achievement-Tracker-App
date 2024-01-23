import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:steam_achievement_tracker/services/utils/colors.dart';

/// Creates a custom AppBar.
///
/// The [text] parameter is the text to display in the AppBar.
///
/// The [actions] parameter is the IconButton to display in the AppBar.
PreferredSizeWidget myAppBar({
  required String title,
  List<Widget>? actions,
  Widget? leading,
  bool automaticallyImplyLeading = true,
}) {
  return AppBar(
    automaticallyImplyLeading: automaticallyImplyLeading,
    leading: leading,
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: KColors.logoColor,
      ),
    ),
    iconTheme: const IconThemeData(
      color: KColors.logoColor,
    ),
    elevation: 5,
    actions: actions,
    centerTitle: true,
    backgroundColor: KColors.primaryColor,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );
}
