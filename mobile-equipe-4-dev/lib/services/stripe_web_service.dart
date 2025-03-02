import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/dto/payment.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/services/auth_service.dart';
import 'dart:html' as html;

import '../dto/auth.dart';

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

      // Create command DTO for the API
      CommandDTO commandDTO = CommandDTO(
          address,
          currency,
          amount,
          phoneNum,
          deviceTokens
      );

      // Add success and cancel URLs to the request
      final data = {
        ...commandDTO.toJson(),
        'successUrl': successUrl,
        'cancelUrl': cancelUrl,
      };

      print("Sending request to create checkout session: $data");

      // Call API to create checkout session
      final response = await _dio.post(
        '$baseUrl/api/Stripe/CreateCheckoutSession',
        data: data,
      );

      print("Response from server: ${response.data}");

      // Check if response contains checkout URL
      if (response.statusCode == 200) {
        // Try to get checkoutUrl from different possible response formats
        String? checkoutUrl;

        if (response.data is Map) {
          // Check different possible field names
          if (response.data['checkoutUrl'] != null) {
            checkoutUrl = response.data['checkoutUrl'];
          } else if (response.data['url'] != null) {
            checkoutUrl = response.data['url'];
          }
        }

        if (checkoutUrl != null) {
          return checkoutUrl;
        } else {
          print("Checkout URL not found in response: ${response.data}");
          return null;
        }
      } else {
        print("Error response status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print('Error creating checkout session: $e');
      return null;
    }
  }

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

      if (response.statusCode == 200 &&
          response.data['paymentStatus'] == 'paid') {

        // Extract command data
        final commandData = response.data['orderDetails'];
        Command command = Command(
          commandData['id'],
          commandData['commandNumber'],
          commandData['clientPhoneNumber'],
          commandData['arrivalPoint'],
          commandData['totalPrice'],
          commandData['currency'],
          commandData['isDelivered'],
          commandData['isInProgress'],
          commandData['clientId'],
          commandData['deliveryManId'],
        );

        return {
          'status': 'success',
          'command': command,
        };
      } else {
        return {
          'status': 'error',
          'message': 'Payment verification failed. Status: ${response.data['paymentStatus']}',
        };
      }
    } catch (e) {
      print('Error verifying payment: $e');
      return {
        'status': 'error',
        'message': e.toString(),
      };
    }
  }

  Future<String?> _getDeviceToken() async {
    // For web, we don't have Firebase messaging token in the same way as mobile
    // You can implement web push notifications registration here if needed
    return null;
  }

  // Redirects to the Stripe checkout page
  void redirectToCheckout(String checkoutUrl) {
    html.window.location.href = checkoutUrl;
  }
}