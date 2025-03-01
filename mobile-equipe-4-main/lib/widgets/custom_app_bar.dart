import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? titleColor;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.centerTitle,
    this.backgroundColor,
    this.titleColor
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: titleColor),),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
    );
  }

  // Required to satisfy the PreferredSizeWidget interface.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}