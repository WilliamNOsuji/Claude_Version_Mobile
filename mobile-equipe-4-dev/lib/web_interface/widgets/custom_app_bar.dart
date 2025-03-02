import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/web_interface/widgets/drawerCart.dart';
import '../pages/Utilis/platform_route_helper.dart';

class WebCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WebCustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: AppColors().green(),
      title: _buildTitle(),
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
          icon: Icon(Icons.shopping_cart, color: AppColors().white()), // Change to the icon you want for the drawer
          onPressed: () {
            Scaffold.of(context).openEndDrawer(); // Opens the end drawer
          },
        ),
        SizedBox(width: 24)
      ],
    );
  }

  Widget _buildTitle() {
    return Builder(
        builder: (context) {
          return Row(
            children: [
              Lottie.asset(
                'assets/animations/rabbit_animation.json', // Path to your Lottie JSON file
                height: 70,
                fit: BoxFit.cover,
              ),
              Container(
                margin: EdgeInsets.only(top: 14),
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

              // Home button
              _buildNavButton(
                title: "Home",
                onPressed: (context) => WebNavigationHandler.navigateToHome(context),
              ),

              // Conditional navigation based on user role
              if (ApiService.isDelivery) ...[
                // Delivery person navigation options
                _buildNavButton(
                  title: "Available Orders",
                  onPressed: (context) => WebNavigationHandler.navigateToAvailableOrders(context),
                ),
                _buildNavButton(
                  title: "My Deliveries",
                  onPressed: (context) => WebNavigationHandler.navigateToDeliveriesList(context),
                ),
              ] else ...[
                // Regular user navigation options
                _buildNavButton(
                  title: "My Orders",
                  onPressed: (context) => WebNavigationHandler.navigateToOrderHistory(context),
                ),
              ],

              // Profile button (for all users)
              _buildNavButton(
                title: "Profile",
                onPressed: (context) => WebNavigationHandler.navigateToProfile(context),
              ),

              Spacer(),
            ],
          );
        }
    );
  }

  Widget _buildNavButton({
    required String title,
    required Function(BuildContext) onPressed
  }) {
    return Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextButton(
                onPressed: () => onPressed(context),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                )
            ),
          );
        }
    );
  }

  // Required to satisfy the PreferredSizeWidget interface.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}