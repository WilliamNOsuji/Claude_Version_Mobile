import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/web_interface/widgets/drawerCart.dart';
import '../../Utilis/platform_route_helper.dart';

class WebCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? profileImageUrl;
  final String userName;

  const WebCustomAppBar({
    super.key,
    this.profileImageUrl,
    this.userName = "Utilisateur",
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen width to handle responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return AppBar(
      title: Row(
        children: [
          // Only show the logo and text if screen is large enough
          if (!isSmallScreen) ...[
            Lottie.asset(
              'assets/animations/rabbit_animation.json',
              height: 70,
              fit: BoxFit.cover,
            ),
            Container(
              margin: const EdgeInsets.only(top: 14),
              child: Text(
                'Lapin Couvert',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors().white(),
                  fontSize: isSmallScreen ? 24 : 30,
                  fontFamily: GoogleFonts.satisfy().fontFamily,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
          if (isSmallScreen)
            Text(
              'LC',
              style: TextStyle(
                color: AppColors().white(),
                fontSize: 24,
                fontFamily: GoogleFonts.satisfy().fontFamily,
                fontWeight: FontWeight.w500,
              ),
            ),
          const Spacer(),
        ],
      ),
      centerTitle: false,
      backgroundColor: AppColors().green(),
      automaticallyImplyLeading: false,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(
            Icons.menu_outlined,
            color: AppColors().white(),
            size: 28,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          tooltip: 'Menu',
        ),
      ),
      actions: [
        // Shopping cart icon
        IconButton(
          icon: Icon(
            Icons.shopping_cart,
            color: AppColors().white(),
            size: 26,
          ),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
          tooltip: 'Panier',
        ),
        // Profile picture
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: GestureDetector(
            onTap: () {
              // Navigate to profile page or show profile options
              Navigator.of(context).pushNamed('/profile');
            },
            child: CircleAvatar(
              backgroundColor: AppColors().white(),
              radius: 18,
              backgroundImage: profileImageUrl != null
                  ? NetworkImage(profileImageUrl!)
                  : null,
              child: profileImageUrl == null
                  ? Icon(
                Icons.person,
                color: AppColors().green(),
                size: 24,
              )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
