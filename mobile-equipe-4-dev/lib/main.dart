import 'package:checkout_screen_ui/checkout_page/checkout_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:html' as html; // Add this import for web
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
import 'dto/auth.dart';
import 'dto/payment.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_orderHistory_page.dart';
import 'services/notifications_service.dart';
import 'generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const PK = "pk_test_51QprthRvxWgpsTY5AvdB6faISKonEZF1s228xll4s8UPmWOSSnTSM0FzlGmcww0v4tDDMZyIK3mCKcwuRKp0JQcb00mfF6yfWt";

// TODO #17.1 : Déclaration du navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    FirebaseFirestore.setLoggingEnabled(true);
  }


  /* Initialisation of Stripe */
  // Charger les variables d'environnement du fichier .env
  await dotenv.load(fileName: ".env");

  // Vérifiez que la clé publique est bien chargée
  print('PUBLIC_KEY: ${dotenv.env['PUBLIC_KEY']}'); // Debugging

  if(!kIsWeb){
    // Assigner la clé publique (Publishable Key) de Stripe
    Stripe.publishableKey = dotenv.env['PUBLIC_KEY']!;

    // Assigner un identifiant de marchand (nécessaire pour iOS)
    Stripe.merchantIdentifier = 'info.cegepmontpetit.ca';

    // Appliquer les configurations Stripe
    await Stripe.instance.applySettings();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


// TODO #9 Transformer le widget en Stateful.
// Truc : Mettre son curseur sur le nom de la classe, puis appuyer sur Alt+Entrée.
//        Choisir "Convert to StatefulWidget"
class _MyAppState extends State<MyApp> {
  // This widgets is the root of your application.

  @override
  void initState() {
    super.initState();
    // TODO #10 : Mettre en place les de notifications
    setupFirebaseMessaging();
  }

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('fr', ''), // Spanish, no country code
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
      // TODO #17.2 : Assignation du navigator key
      //navigatorKey: navigatorKey,
      routes: {
        '/registerPage': (context) => const RegisterPage(),
        '/loginPage': (context) => const LoginPage(),
        '/homePage': (context) => const HomePage(),
        '/deliveryManInfoPage': (context) => const DeliveryManInfoPage(),
        '/orderListPage': (context) => const OrderHistoryPage(),
        '/orderTrackingPage': (context) => const AvailableOrdersPage(),
        '/suggestionPage': (context) => const SuggestionPage(),
      },
      // For web, use hash-based URL strategy
      // Update this part in your onGenerateRoute method in main.dart

      onGenerateRoute: kIsWeb ? (settings) {
        print("Generating route for: ${settings.name}");

        // Extract the full URL for debugging
        final fullUrl = html.window.location.href;
        print("Full URL: $fullUrl");

        // Parse the URL to handle Stripe redirects
        if (settings.name == '/order-success' || fullUrl.contains('order-success')) {
          print("Handling order success route");

          // We'll extract the session ID in the WebOrderSuccessPage
          return MaterialPageRoute(
            builder: (context) => const WebOrderSuccessPage(sessionId: ''),
          );
        } else if (settings.name == '/payment-cancelled' || fullUrl.contains('payment-cancelled')) {
          // Handle the case when payment was cancelled
          print("Handling payment cancelled route");
          return MaterialPageRoute(
            builder: (context) => HomePage(),
          );
        } else if (settings.name == '/homepage' || fullUrl.contains('homepage')) {
          // Handle redirects back to the homepage
          print("Handling homepage route");
          return MaterialPageRoute(
            builder: (context) => HomePage(),
          );
        }

        // For other routes, use the normal route generation
        return null;
      } : null,
    );

    return app;
  }
}