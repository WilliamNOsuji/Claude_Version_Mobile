import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/dto/payment.dart';
import 'package:mobilelapincouvert/pages/HomePage.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/services/stripe_web_service.dart';
import 'package:dio/dio.dart';

import '../../services/api_service.dart';

class WebOrderSuccessPage extends StatefulWidget {
  final String sessionId;

  const WebOrderSuccessPage({super.key, required this.sessionId});

  @override
  _WebOrderSuccessPageState createState() => _WebOrderSuccessPageState();
}

class _WebOrderSuccessPageState extends State<WebOrderSuccessPage> {
  bool _isLoading = true;
  bool _paymentSuccessful = false;
  String _errorMessage = '';
  Command? _command;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _extractSessionIdAndVerify();
  }

  void _extractSessionIdAndVerify() {
    // Extract session_id from the URL if not provided in the constructor
    String sessionId = widget.sessionId;

    if (sessionId.isEmpty) {
      // Get the full URL including hash fragments
      final fullUrl = html.window.location.href;
      print("Full URL: $fullUrl");

      // Try multiple ways to extract the session ID

      // Method 1: Standard query parameter approach
      final uri = Uri.parse(fullUrl);
      final params = uri.queryParameters;
      sessionId = params['session_id'] ?? '';

      // Method 2: Check if session ID is in the URL path
      if (sessionId.isEmpty) {
        // Look for cs_test or cs_live pattern in the URL
        final regex = RegExp(r'(cs_test_[a-zA-Z0-9]+|cs_live_[a-zA-Z0-9]+)');
        final match = regex.firstMatch(fullUrl);
        if (match != null && match.group(0) != null) {
          sessionId = match.group(0)!;
        }
      }

      // Method 3: Check for hash fragment parameters
      if (sessionId.isEmpty) {
        final hashFragment = uri.fragment;
        if (hashFragment.isNotEmpty) {
          // Parse hash fragment as query string
          final hashParams = Uri.splitQueryString(hashFragment);
          sessionId = hashParams['session_id'] ?? '';
        }
      }

      print("Extracted session ID: $sessionId");
    }

    if (sessionId.isNotEmpty) {
      ApiService().verifyPaymentAndCreateCommand(sessionId);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _isLoading ? 'Processing...' : (_paymentSuccessful ? 'Success!' : 'Order Issue'),
        ),
        centerTitle: true,
        backgroundColor: _paymentSuccessful ? Colors.green : Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? _buildLoadingView()
          : (_paymentSuccessful ? _buildSuccessView() : _buildErrorView()),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.green),
          SizedBox(height: 24),
          Text(
            'Verifying your payment...',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/jumping_rabbit.json',
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 24),
          Text(
            'Thank You for Your Order!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Your delicious food is being prepared and will arrive soon.',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          if (_command != null)
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${_command!.commandNumber}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Amount: \$${_command!.totalPrice.toStringAsFixed(2)} ${_command!.currency}'),
                    Text('Delivery Address: ${_command!.arrivalPoint}'),
                    Text('Contact: ${_command!.clientPhoneNumber}'),
                  ],
                ),
              ),
            ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'Back to Home',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red),
            SizedBox(height: 24),
            Text(
              'Payment Verification Failed',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red[800],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              _errorMessage,
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                'Return to Home',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}