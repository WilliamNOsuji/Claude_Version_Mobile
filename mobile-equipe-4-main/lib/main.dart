// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobilelapincouvert/pages/cart_page.dart';
import 'package:mobilelapincouvert/pages/checkout_page.dart';
import 'package:mobilelapincouvert/pages/HomePage.dart';
import 'package:mobilelapincouvert/pages/loginPage.dart';
import 'package:mobilelapincouvert/pages/order_success_page.dart';
import 'package:mobilelapincouvert/pages/profilePage.dart';
import 'package:mobilelapincouvert/pages/profile_edit_Page.dart';
import 'package:mobilelapincouvert/pages/registerPage.dart';

import 'generated/l10n.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widgets is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const RegisterPage(),
      routes: {
        '/registerPage': (context) => const RegisterPage(),
        '/loginPage': (context) => const LoginPage(),
        '/homePage': (context) => const HomePage(),
        '/cartPage': (context) => const CartPage(),
        '/profileEditPage': (context) => const ProfileEditPage(),
        '/profilePage': (context) => const ProfilePage(),
        '/checkoutPage': (context) => const CheckoutPage()
      },
    );
  }
}

