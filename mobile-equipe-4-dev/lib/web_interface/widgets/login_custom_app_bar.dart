import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'package:mobilelapincouvert/pages/HomePage.dart';

class WebLoginCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? titleColor;
  final bool? backPage;
  const WebLoginCustomAppBar({
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
        child: Row(
          children: [
            Lottie.asset(
              'assets/animations/rabbit_animation.json', // Path to your Lottie JSON file
              height: 70,
              fit: BoxFit.cover,
            ),
            Container(
              margin: EdgeInsets.only(top:14),
              child: Text(
                'Lapin Couvert',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors().green(),
                  fontSize: 30,
                  fontFamily: GoogleFonts.satisfy().fontFamily,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

          ],
        ),
      ),
      centerTitle: false,
      backgroundColor: Colors.white,
      leading: backPage == null ? null : IconButton(onPressed: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomePage())
        );
      }, icon: Icon(Icons.arrow_back_ios_new)),
      automaticallyImplyLeading: backPage == null ? false : backPage as bool ,
    );
  }

  // Required to satisfy the PreferredSizeWidget interface.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}