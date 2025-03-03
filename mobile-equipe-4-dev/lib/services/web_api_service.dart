
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mobilelapincouvert/dto/vote.dart';

import '../dto/auth.dart';
import '../dto/payment.dart';
import '../gestion_erreurs.dart';
import '../models/product_model.dart';
import '../pages/clientOrderPages/orderHistoryPage.dart';
import '../pages/paymentProcessPages/order_success_page.dart';
import 'chat_service.dart';
import 'auth_service.dart';
import 'local_storage_stripe_service.dart';

import 'dart:html' as html;

//Web
const String BaseUrl = kIsWeb ? "http://127.0.0.1:5180" : "http://10.0.2.2:5180";

// Mobile
//const String BaseUrl= "http://10.0.2.2:5180";

// Deployed
//const String BaseUrl ="https://api-lapincouvert-hke0a0a6cjg5c3gh.canadacentral-01.azurewebsites.net";

class WebApiService {
  static var clientId = null;
  static double subTotal = 0;
  static double finalAmount = 0;
  static String address = '';
  static String phoneNum = '';
  static String  currency = "cad";
  static int CartItemCount = 0;
  static bool isDelivery = false;
  static bool isActive = false;


  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: BaseUrl,
      //baseUrl: BaseUrlDeployed,
      //baseUrl: BaseUrlDeployed,
      connectTimeout: const Duration(seconds: 100),
      receiveTimeout: const Duration(seconds: 100),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // Add interceptors for logging or adding headers
  ApiService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await AuthService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  Future<String> validateCartProducts(BuildContext context, List<CartProductDTO> cartProducts) async {

    try {
      List<Map<String, dynamic>> jsonList = cartProducts.map((product) => product.toJson()).toList();

      var response = await _dio.post('/api/Cart/ValidateCartProduct', data: jsonList);
      if (response.statusCode == 200) {
        return response.toString();
      } else {
        throw Exception('Failed to load products');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    }

  }

  Future<void> processWebPayment(BuildContext context, List<CartProductDTO> cartProducts) async {
    try {
      // Step 1: Validate cart products
      var validationResponse = await validateCartProducts(context, cartProducts);

      if (validationResponse.toString() == "Le panier est valide") {
        // Step 2: Create a Stripe checkout session
        String? token = await FirebaseMessaging.instance.getToken();
        List<String> tokens = token != null ? [token] : [];

        CommandDTO commandDTO = CommandDTO(
            address,
            currency,
            finalAmount,
            phoneNum,
            tokens
        );

        // Create a checkout session
        var sessionResponse = await _dio.post(
          '/api/Stripe/CreateCheckoutSession',
          data: commandDTO.toJson(),
        );

        if (sessionResponse.statusCode == 200) {
          // Get checkout URL from response
          final sessionId = sessionResponse.data['id'];
          final checkoutUrl = sessionResponse.data['url'];

          // Open the checkout URL in a new tab
          if (kIsWeb) {
            html.window.open(checkoutUrl, '_blank');
          }
          // Store the session ID for later verification
          // You can save this to local storage or pass it to the success page
          LocalStorageService.saveSessionId(sessionId);
        }
      }
    } catch (e) {
      print("Web payment initialization error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initialize payment: $e')),
      );
    }
  }

  Future<String?> createCheckoutSession({
    required double amount,
    required String currency,
    required String address,
    required String phoneNum,
    required List<String> deviceTokens,
    String? successUrl,
    String? cancelUrl,
  }) async {
    try {
      // Get auth token
      final token = await AuthService.getToken();
      if (token == null) {
        print("Authentication token not found");
        return null;
      }

      // Set authorization header
      _dio.options.headers['Authorization'] = 'Bearer $token';

      // Default URLs if not provided
      successUrl ??= '${html.window.location.origin}/web-order-success';
      cancelUrl ??= html.window.location.origin;

      // Create the request object
      final request = CheckoutSessionRequest(
          amount,
          currency.toUpperCase(),
          address,
          phoneNum,
          deviceTokens,
          successUrl,
          cancelUrl
      );

      final response = await _dio.post(
        '/api/Stripe/CreateCheckoutSession',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return response.data['checkoutUrl'];
      }

      return null;
    } catch (e) {
      print('Error creating checkout session: $e');
      return null;
    }
  }

  // Add comprehensive error logging
  Future<dynamic> verifyPaymentSession(String sessionId) async {
    try {
      final token = await AuthService.getToken();

      _dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await _dio.get(
        '/api/Stripe/VerifyCheckoutSession/$sessionId',
      );

      if (response.statusCode == 200) {
        return response.data;
      }

      return null;
    } catch (e) {
      print('Payment verification error: $e');
      rethrow;
    }
  }

  // Redirects to the Stripe checkout page
  void redirectToCheckout(String checkoutUrl) {
    if (checkoutUrl.isNotEmpty) {
      html.window.location.href = checkoutUrl;

      print('Hello');
    }
  }

  String ifEmptyExtractUrl(String sessionId){
    if (sessionId.isEmpty) {
      final url = html.window.location.href;
      print("Extracting session ID from URL: $url");

      // Try to extract session_id from search parameters
      final searchParams = html.window.location.search;
      if (searchParams!.isNotEmpty) {
        final searchUri = Uri.parse(searchParams);
        sessionId = searchUri.queryParameters['session_id'] ?? '';
      }

      // If not found in search, try the hash fragment
      if (sessionId.isEmpty) {
        final hash = html.window.location.hash;
        if (hash.isNotEmpty && hash.contains('session_id=')) {
          final hashParts = hash.split('session_id=');
          if (hashParts.length > 1) {
            sessionId = hashParts[1].split('&')[0];
          }
        }
      }
    }
    return sessionId;
  }
}

