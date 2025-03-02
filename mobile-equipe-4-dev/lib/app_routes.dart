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

// Web Pages
import 'package:mobilelapincouvert/web_interface/pages/web_home_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_login_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_register_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_orderHistory_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_available_orders_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_deliveries_list_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_order_success_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_chat_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_product_detail_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_checkout_page.dart';

// DTOs
import 'package:mobilelapincouvert/dto/auth.dart';
import 'package:mobilelapincouvert/dto/payment.dart';

import 'models/product_model.dart';

class AppRoutes {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    // Platform-specific route selection
    Widget selectPlatformPage(Widget mobilePage, Widget webPage) {
      return kIsWeb ? webPage : mobilePage;
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

      case '/productDetailPage':
        final product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (context) => selectPlatformPage(
            ProductDetailPage(product: product),
            WebProductDetailPage(product: product),
          ),
        );

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
            OrderSuccessPage(sessionId: sessionId),
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
}