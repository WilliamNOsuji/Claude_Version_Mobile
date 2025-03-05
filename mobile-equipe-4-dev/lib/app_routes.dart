import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Mobile Pages
import 'package:mobilelapincouvert/pages/HomePage.dart';
import 'package:mobilelapincouvert/pages/authenticationPages/loginPage.dart';
import 'package:mobilelapincouvert/pages/authenticationPages/registerPage.dart';
import 'package:mobilelapincouvert/pages/clientOrderPages/deliveryManInfoPage.dart';
import 'package:mobilelapincouvert/pages/clientOrderPages/orderHistoryPage.dart';
import 'package:mobilelapincouvert/pages/deliverymanOrderPages/availableOrdersPage.dart';
import 'package:mobilelapincouvert/pages/deliverymanOrderPages/deliveriesListPage.dart';
import 'package:mobilelapincouvert/pages/paymentProcessPages/cart_page.dart';
import 'package:mobilelapincouvert/pages/paymentProcessPages/checkout_page.dart';
import 'package:mobilelapincouvert/pages/paymentProcessPages/order_success_page.dart';
import 'package:mobilelapincouvert/pages/suggestion_page.dart';
import 'package:mobilelapincouvert/pages/ProductDetailPage.dart';
import 'package:mobilelapincouvert/pages/clientProfilePages/profilePage.dart';
import 'package:mobilelapincouvert/pages/clientProfilePages/profile_edit_Page.dart';
import 'package:mobilelapincouvert/web_interface/pages/clientOrderPages/web_orderHistory_page.dart';

// Web Pages
import 'package:mobilelapincouvert/web_interface/pages/web_home_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_login_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_register_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_available_orders_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_deliveries_list_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_order_success_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_chat_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_product_detail_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_checkout_page.dart';

// DTOs
import 'package:mobilelapincouvert/dto/auth.dart';
import 'package:mobilelapincouvert/dto/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppRoutes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    // Platform-specific route selection
    Widget selectPlatformPage(Widget mobilePage, Widget webPage) {
      return kIsWeb ? webPage : mobilePage;
    }

    // Special handling for order-success route
    if (settings.name == '/order-success') {
      return _handleOrderSuccessRoute(settings);
    }

    switch (settings.name) {
      case '/':
      case '/homePage':
        return MaterialPageRoute(
          builder: (context) => selectPlatformPage(
            const HomePage(),
            WebHomePage(),
          ),
        );

      case '/loginPage':
        return MaterialPageRoute(
          builder: (context) => selectPlatformPage(
            const LoginPage(),
            WebLoginPage(),
          ),
        );

      case '/registerPage':
        return MaterialPageRoute(
          builder: (context) => selectPlatformPage(
            const RegisterPage(),
            WebRegisterPage(),
          ),
        );

      case '/deliveryManInfoPage':
        return MaterialPageRoute(
          builder: (context) => const DeliveryManInfoPage(),
        );

      case '/orderListPage':
        return MaterialPageRoute(
          builder: (context) => selectPlatformPage(
            const OrderHistoryPage(),
            WebOrderHistoryPage(),
          ),
        );

      case '/orderTrackingPage':
        return MaterialPageRoute(
          builder: (context) => selectPlatformPage(
            const AvailableOrdersPage(),
            WebAvailableOrdersPage(),
          ),
        );

      case '/deliveriesListPage':
        return MaterialPageRoute(
          builder: (context) => selectPlatformPage(
            DeliveriesListPage(),
            WebDeliveriesListPage(),
          ),
        );

      case '/suggestionPage':
        return MaterialPageRoute(
          builder: (context) => const SuggestionPage(),
        );

      //case '/productDetailPage':
      //  final product = settings.arguments as Product;
      //  return MaterialPageRoute(
      //    builder: (context) => selectPlatformPage(
      //      ProductDetailPage(product: product),
      //      WebProductDetailPage(product: product),
      //    ),
      //  );

      case '/profilePage':
        return MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        );

      case '/profileEditPage':
        final profile = settings.arguments as ProfileDTO;
        return MaterialPageRoute(
          builder: (context) => ProfileEditPage(profile: profile),
        );

      case '/cartPage':
        final cartProducts = settings.arguments as List<CartProductDTO>;
        return MaterialPageRoute(
          builder: (context) => selectPlatformPage(
            CartPage(CardProducts: cartProducts),
            CartPage(CardProducts: cartProducts), // Web version TBD
          ),
        );

      case '/checkoutPage':
        final cartProducts = settings.arguments as List<CartProductDTO>;
        return MaterialPageRoute(
          builder: (context) => selectPlatformPage(
            CheckoutPage(listCartProducts: cartProducts),
            WebCheckoutPage(listCartProducts: cartProducts),
          ),
        );

      case '/order-success':
        final sessionId = (settings.arguments as Map<String, dynamic>?)?['sessionId'] ?? '';
        return MaterialPageRoute(
          builder: (context) => selectPlatformPage(
            OrderSuccessPage(sessionId: '',),
            WebOrderSuccessPage(sessionId: sessionId),
          ),
        );

      case '/web-chat':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => WebChatPage(
            commandId: args['commandId'],
            otherUserId: args['otherUserId'],
            otherUserName: args['otherUserName'],
            isDeliveryMan: args['isDeliveryMan'] ?? false,
            clientId: args['clientId'], // Pass through optional explicit client ID
            deliveryManId: args['deliveryManId'], // Pass through optional explicit delivery person ID
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => selectPlatformPage(
            const HomePage(),
            WebHomePage(),
          ),
        );
    }
  }

  // Special handler for order success page
  static Route<dynamic>? _handleOrderSuccessRoute(RouteSettings settings) {
    // Get session ID from route arguments if available
    String sessionId = '';

    // Try to get sessionId from arguments
    if (settings.arguments != null) {
      if (settings.arguments is Map<String, dynamic>) {
        sessionId = (settings.arguments as Map<String, dynamic>)['sessionId'] ?? '';
      } else if (settings.arguments is String) {
        sessionId = settings.arguments as String;
      }
    }

    // If no sessionId in arguments, check if coming from URL and stored in shared prefs
    if (sessionId.isEmpty && kIsWeb) {
      try {
        final prefs = SharedPreferences.getInstance();
        //sessionId = prefs.getString('payment_session_id') ?? '';
      } catch (e) {
        print('Error getting stored session ID: $e');
      }
    }

    // If we're on web and still don't have a sessionId, try to extract from URL
    if (sessionId.isEmpty && kIsWeb) {
      try {
        final uri = Uri.parse(Uri.base.toString());
        if (uri.queryParameters.containsKey('session_id')) {
          sessionId = uri.queryParameters['session_id']!;
        } else if (uri.fragment.contains('session_id=')) {
          final parts = uri.fragment.split('session_id=');
          if (parts.length > 1) {
            sessionId = parts[1].split('&')[0];
          }
        }
      } catch (e) {
        print('Error extracting session ID from URL: $e');
      }
    }

    return MaterialPageRoute(
      builder: (context) => kIsWeb
          ? WebOrderSuccessPage(sessionId: sessionId)
          : OrderSuccessPage(sessionId: sessionId),
    );
  }
}