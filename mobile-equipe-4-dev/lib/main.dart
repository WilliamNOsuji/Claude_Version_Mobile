// lib/main.dart (Modified)

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mobilelapincouvert/pages/clientOrderPages/deliveryManInfoPage.dart';
import 'package:mobilelapincouvert/pages/clientProfilePages/profilePage.dart';
import 'package:mobilelapincouvert/pages/deliverymanOrderPages/availableOrdersPage.dart';
import 'package:mobilelapincouvert/pages/clientOrderPages/orderHistoryPage.dart';
import 'package:mobilelapincouvert/pages/HomePage.dart';
import 'package:mobilelapincouvert/pages/authenticationPages/loginPage.dart';
import 'package:mobilelapincouvert/pages/authenticationPages/registerPage.dart';
import 'package:mobilelapincouvert/pages/suggestion_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/clientOrderPages/web_orderHistory_page.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_profile_page.dart';
import 'services/notifications_service.dart';
import 'generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import the new AppRoutes
import 'app_routes.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'pages/authenticationPages/loginPage.dart';
import 'services/auth_service.dart';

const PK = "pk_test_51QprthRvxWgpsTY5AvdB6faISKonEZF1s228xll4s8UPmWOSSnTSM0FzlGmcww0v4tDDMZyIK3mCKcwuRKp0JQcb00mfF6yfWt";

// Global key for navigator to handle navigation from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _isLoggedIn = false;
  String? _initialRoute;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }


  /**
   * The source of the issue for the chekout is here nigga
   */
  // Check for payment return and authentication status
  Future<void> _initializeApp() async {
    if (kIsWeb) {
      // Check if returning from a payment
      final uri = Uri.parse(Uri.base.toString());
      // Check for order-success in path or hash
      if (uri.toString().contains('order-success') ||
          (uri.fragment.isNotEmpty && uri.fragment.contains('order-success'))) {

        // If we're returning from payment, go to order success page
        _initialRoute = '/order-success';

        // Parse session ID - extract from URI (could be in path or fragment)
        String? sessionId;
        if (uri.queryParameters.containsKey('session_id')) {
          sessionId = uri.queryParameters['session_id'];
        } else if (uri.fragment.contains('session_id=')) {
          final parts = uri.fragment.split('session_id=');
          if (parts.length > 1) {
            sessionId = parts[1].split('&')[0];
          }
        }

        // Store sessionId for the success page
        if (sessionId != null && sessionId.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('payment_session_id', sessionId);
        }
      }
    }
    else {
      // On mobile, we want to start with the login page by default
      _initialRoute = '/loginPage';
    }

    // Check authentication status
    final token = await AuthService.getToken();
    setState(() {
      _isLoggedIn = token != null;

      // Only override _initialRoute with home page if user is logged in
      // AND we're not already handling a specific route (like order-success)
      if (_isLoggedIn && _initialRoute == null) {
        _initialRoute = '/';
      } else if (!_isLoggedIn && (_initialRoute == null || _initialRoute == '/')) {
        // Ensure we direct to login if not logged in
        _initialRoute = '/loginPage';
      }

      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while checking auth status
    if (!_initialized) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
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
      initialRoute: _initialRoute ?? '/loginPage',
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}