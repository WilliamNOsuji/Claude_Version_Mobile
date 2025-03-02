import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'package:mobilelapincouvert/pages/HomePage.dart';
import 'package:mobilelapincouvert/pages/clientOrderPages/orderHistoryPage.dart';
import 'package:mobilelapincouvert/pages/clientProfilePages/profilePage.dart';

class WebCustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const WebCustomAppBar({
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: AppColors().green(),
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
                  color: AppColors().white(),
                  fontSize: 30,
                  fontFamily: GoogleFonts.satisfy().fontFamily,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Spacer(),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage( ),
                      ),
                    );
                  },
                  child: Text("Accueil",
                    style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,) ,)
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderHistoryPage(),
                      ),
                    );
                  },
                  child: Text("Commande",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,) ,)
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ),
                    );
                  },
                  child: Text("Mon Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,) ,)
              ),
            ),
            Spacer(),
          ],
        ),
      ),
      centerTitle: false,
      backgroundColor: AppColors().green(),
      automaticallyImplyLeading: false,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(4.0), // Height of the bottom line
        child: Container(
          margin: EdgeInsets.only(top: 12),
          color: Colors.grey.shade200, // Color of the line
          height: 1.0, // Thickness of the line
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.shopping_cart, color: AppColors().white(),), // Change to the icon you want for the drawer
          onPressed: () {
            Scaffold.of(context).openEndDrawer(); // Opens the end drawer
          },
        ),
        SizedBox(width: 24)
      ],
    );
  }

  // Required to satisfy the PreferredSizeWidget interface.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}