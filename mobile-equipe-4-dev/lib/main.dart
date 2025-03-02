import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';

// Import the new AppRoutes
import 'app_routes.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'pages/authenticationPages/loginPage.dart';

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
      initialRoute: '/',
      onGenerateRoute: AppRoutes.generateRoute,
      home: const LoginPage(),
    );
  }
}