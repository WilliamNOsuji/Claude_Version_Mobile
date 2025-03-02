import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/pages/HomePage.dart';
import 'package:mobilelapincouvert/pages/authenticationPages/loginPage.dart';
import 'package:mobilelapincouvert/pages/authenticationPages/registerPage.dart';
import 'package:mobilelapincouvert/pages/clientOrderPages/orderHistoryPage.dart';
import 'package:mobilelapincouvert/pages/clientProfilePages/profilePage.dart';
import 'package:mobilelapincouvert/pages/deliverymanOrderPages/availableOrdersPage.dart';
import 'package:mobilelapincouvert/pages/deliverymanOrderPages/deliveriesListPage.dart';
import 'package:mobilelapincouvert/pages/paymentProcessPages/cart_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_checkout_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_home_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_login_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_orderHistory_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_register_page.dart';

import '../web_deliveries_list_page.dart';

/// A helper class to navigate to the appropriate page based on platform
class PlatformRouter {

  /// Navigate to the home page
  static void navigateToHome(BuildContext context, {Object? arguments}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => kIsWeb
            ? WebHomePage()
            : HomePage(),
        settings: RouteSettings(arguments: arguments),
      ),
    );
  }

  /// Navigate to the login page
  static void navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => kIsWeb
            ? WebLoginPage()
            : LoginPage(),
      ),
    );
  }

  /// Navigate to the register page
  static void navigateToRegister(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => kIsWeb
            ? WebRegisterPage()
            : RegisterPage(),
      ),
    );
  }

  /// Navigate to the order history page
  static void navigateToOrderHistory(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => kIsWeb
            ? WebOrderHistoryPage()
            : OrderHistoryPage(),
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

   /// Navigate to the cart page
  //static void navigateToCart(BuildContext context, List cartProducts) {
  //  Navigator.pushReplacement(
  //    context,
  //    MaterialPageRoute(
  //      builder: (context) => CartPage(CardProducts: cartProducts),
  //    ),
  //  );
  //}
//
  ///// Navigate to the checkout page
  //static void navigateToCheckout(BuildContext context, List cartProducts) {
  //  Navigator.push(
  //    context,
  //    MaterialPageRoute(
  //      builder: (context) => kIsWeb
  //          ? WebCheckoutPage(listCartProducts: cartProducts)
  //          : CheckoutPage(listCartProducts: cartProducts),
  //    ),
  //  );
  //}

  /// Navigate to the deliveries list page
  static void navigateToDeliveriesList(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => kIsWeb
            ? WebDeliveriesListPage()
            : DeliveriesListPage(),
      ),
    );
  }

  /// Navigate to the available orders page
  static void navigateToAvailableOrders(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AvailableOrdersPage(),
      ),
    );
  }
}