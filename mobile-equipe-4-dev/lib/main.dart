import 'package:checkout_screen_ui/checkout_page/checkout_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mobilelapincouvert/pages/clientOrderPages/deliveryManInfoPage.dart';
import 'package:mobilelapincouvert/pages/deliverymanOrderPages/availableOrdersPage.dart';
import 'package:mobilelapincouvert/pages/clientOrderPages/orderHistoryPage.dart';
import 'package:mobilelapincouvert/pages/HomePage.dart';
import 'package:mobilelapincouvert/pages/authenticationPages/loginPage.dart';
import 'package:mobilelapincouvert/pages/authenticationPages/registerPage.dart';
import 'package:mobilelapincouvert/pages/paymentProcessPages/order_success_page.dart';
import 'package:mobilelapincouvert/pages/suggestion_page.dart';
import 'package:mobilelapincouvert/services/stripe_web_service.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_order_success_page.dart';
import 'package:mobilelapincouvert/web_interface/widgets/app_wrapper.dart';
import 'dto/auth.dart';
import 'dto/payment.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_orderHistory_page.dart';
import 'services/notifications_service.dart';
import 'generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const PK = "pk_test_51QprthRvxWgpsTY5AvdB6faISKonEZF1s228xll4s8UPmWOSSnTSM0FzlGmcww0v4tDDMZyIK3mCKcwuRKp0JQcb00mfF6yfWt";

// Global key for navigator to handle navigation from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Stripe for mobile platforms
  if (!kIsWeb) {
    Stripe.publishableKey = dotenv.env['PUBLIC_KEY'] ?? PK;
    Stripe.merchantIdentifier = 'info.cegepmontpetit.ca';
    await Stripe.instance.applySettings();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create the app with different routing setup based on platform
    Widget app = MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('fr', ''), // French, no country code
      ],
      title: 'Lapin Couvert',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // Handle dynamic routes with parameters
        if (settings.name != null && settings.name!.startsWith('/order-success')) {
          // Extract session ID from the route
          Uri uri = Uri.parse(settings.name!);
          final sessionId = uri.queryParameters['session_id'] ?? '';

          return MaterialPageRoute(
            builder: (context) => kIsWeb
                ? WebOrderSuccessPage(sessionId: sessionId)
                : OrderSuccessPage(sessionId: sessionId),
          );
        }

        // Regular routes
        switch (settings.name) {
          case '/':
          case '/homePage':
            return MaterialPageRoute(builder: (context) => const HomePage());
          case '/loginPage':
            return MaterialPageRoute(builder: (context) => const LoginPage());
          case '/registerPage':
            return MaterialPageRoute(builder: (context) => const RegisterPage());
          case '/deliveryManInfoPage':
            return MaterialPageRoute(builder: (context) => const DeliveryManInfoPage());
          case '/orderListPage':
            return MaterialPageRoute(builder: (context) => const OrderHistoryPage());
          case '/orderTrackingPage':
            return MaterialPageRoute(builder: (context) => const AvailableOrdersPage());
          case '/suggestionPage':
            return MaterialPageRoute(builder: (context) => const SuggestionPage());
          default:
            return MaterialPageRoute(builder: (context) => const HomePage());
        }
      },
      home: const LoginPage(),
    );

    // Wrap with our platform-specific wrapper
    return AppWrapper(child: app);
  }
}