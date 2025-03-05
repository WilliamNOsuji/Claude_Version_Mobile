import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/pages/HomePage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? titleColor;
  final bool? backPage;
  const CustomAppBar({
    super.key,
    required this.title,
    required this.centerTitle,
    this.backgroundColor,
    this.titleColor,
    this.backPage
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: titleColor,fontSize: 40),),
      ),
      centerTitle: false,
      backgroundColor: Colors.white,
      leading: backPage == null ? null : IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back_ios_new)),
      automaticallyImplyLeading: backPage == null ? false : backPage as bool ,
    );
  }

  // Required to satisfy the PreferredSizeWidget interface.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}