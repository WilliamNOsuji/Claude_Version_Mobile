import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mobilelapincouvert/pages/HomePage.dart';
import 'package:mobilelapincouvert/pages/clientOrderPages/orderHistoryPage.dart';
import 'package:mobilelapincouvert/pages/clientProfilePages/profilePage.dart';
import 'package:mobilelapincouvert/pages/deliverymanOrderPages/availableOrdersPage.dart';
import 'package:mobilelapincouvert/pages/deliverymanOrderPages/deliveriesListPage.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_home_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_orderHistory_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_available_orders_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_deliveries_list_page.dart';

/// A utility class to handle navigation in the web interface
class WebNavigationHandler {
  /// Navigate to the home page based on platform
  static void navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => kIsWeb ? WebHomePage() : HomePage(),
      ),
    );
  }

  /// Navigate to the order history page based on platform
  static void navigateToOrderHistory(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => kIsWeb ? WebOrderHistoryPage() : OrderHistoryPage(),
      ),
    );
  }

  /// Navigate to the available orders page based on platform
  static void navigateToAvailableOrders(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => kIsWeb ? WebAvailableOrdersPage() : AvailableOrdersPage(),
      ),
    );
  }

  /// Navigate to the deliveries list page based on platform
  static void navigateToDeliveriesList(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => kIsWeb ? WebDeliveriesListPage() : DeliveriesListPage(),
      ),
    );
  }

  /// Navigate to the profile page
  static void navigateToProfile(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(),
      ),
    );
  }

  /// Navigate to the appropriate page based on the user's role and the selected tab
  static void navigateToTab(BuildContext context, int index) {
    if (ApiService.isDelivery) {
      // Delivery person navigation
      switch (index) {
        case 0:
          navigateToHome(context);
          break;
        case 1:
        // Cart functionality
          break;
        case 2:
          navigateToAvailableOrders(context);
          break;
        case 3:
          navigateToOrderHistory(context);
          break;
        case 4:
          navigateToProfile(context);
          break;
      }
    } else {
      // Regular user navigation
      switch (index) {
        case 0:
          navigateToHome(context);
          break;
        case 1:
        // Cart functionality
          break;
        case 2:
          navigateToOrderHistory(context);
          break;
        case 3:
          navigateToProfile(context);
          break;
      }
    }
  }
}