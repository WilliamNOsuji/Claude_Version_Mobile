import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobilelapincouvert/dto/payment.dart';
import 'package:mobilelapincouvert/services/auth_service.dart';
import 'dart:html' as html;

class StripeWebService {
  static final StripeWebService _instance = StripeWebService._internal();
  factory StripeWebService() => _instance;
  StripeWebService._internal();

  final String baseUrl = kIsWeb ? "http://127.0.0.1:5180" : "http://10.0.2.2:5180";
  final Dio _dio = Dio();

  Future<String?> createCheckoutSession({
    required double amount,
    required String currency,
    required String address,
    required String phoneNum,
    required List<String> deviceTokens,
    required String successUrl,
    required String cancelUrl,
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

      // Create the request object using the CheckoutSessionRequest DTO
      final request = CheckoutSessionRequest(
          amount,
          currency.toUpperCase(), // Ensure currency is uppercase (CAD not cad)
          address,
          phoneNum,
          deviceTokens,
          successUrl,
          cancelUrl
      );

      print("Sending checkout session request with data: ${request.toJson()}");

      // Call API to create checkout session
      final response = await _dio.post(
        '$baseUrl/api/Stripe/CreateCheckoutSession',
        data: request.toJson(),
      );

      print("Response from server: ${response.data}");

      // Check if response contains checkout URL
      if (response.statusCode == 200) {
        if (response.data is Map) {
          // Look for url in different possible field names
          final url = response.data['url'] ??
              response.data['checkoutUrl'] ??
              response.data['id'];

          return url != null ? url.toString() : null;
        } else if (response.data is String) {
          return response.data;
        }
      }

      return null;
    } catch (e) {
      print('Error creating checkout session: $e');

      // Print more detailed error information if available
      if (e is DioException && e.response != null) {
        print('Response status: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      }

      return null;
    }
  }


  // Redirects to the Stripe checkout page
  void redirectToCheckout(String checkoutUrl) {
    if (checkoutUrl.isNotEmpty) {
      html.window.location.href = checkoutUrl;

      print('Hello');
    }
  }

  // Handle the session_id extraction from current URL
  String? getSessionIdFromCurrentUrl() {
    if (!kIsWeb) return null;

    try {
      final url = html.window.location.href;

      // Try different approaches to extract session_id

      // 1. From query parameters
      final uri = Uri.parse(url);
      String? sessionId = uri.queryParameters['session_id'];

      // 2. From hash fragment
      if (sessionId == null && uri.fragment.isNotEmpty) {
        final fragmentUri = Uri.parse(uri.fragment);
        if (fragmentUri.path == '/order-success') {
          sessionId = Uri.parse('?${fragmentUri.query}').queryParameters['session_id'];
        }
      }

      // 3. Using regex as fallback
      if (sessionId == null) {
        final regex = RegExp(r'session_id=([^&]+)');
        final match = regex.firstMatch(url);
        if (match != null && match.groupCount >= 1) {
          sessionId = match.group(1);
        }
      }

      return sessionId;
    } catch (e) {
      print('Error extracting session ID: $e');
      return null;
    }
  }

  // Verify payment session with backend
  Future<Map<String, dynamic>> verifyPaymentSession(String sessionId) async {
    try {
      // Get authentication token
      final token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      // Set authorization header
      _dio.options.headers['Authorization'] = 'Bearer $token';

      // Call API to verify payment
      final response = await _dio.get(
        '$baseUrl/api/Stripe/VerifyPayment/$sessionId',
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'message': 'Payment verification failed',
        };
      }
    } catch (e) {
      print('Error verifying payment: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
}