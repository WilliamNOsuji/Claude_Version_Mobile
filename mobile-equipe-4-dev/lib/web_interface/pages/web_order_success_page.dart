import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/dto/payment.dart';
import 'package:mobilelapincouvert/pages/HomePage.dart';
import 'package:mobilelapincouvert/services/api_service.dart';

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

  @override
  void initState() {
    super.initState();
    _extractSessionIdAndVerify();

    // Print debugging information
    _printDebugInfo();
  }

  void _printDebugInfo() {
    // Print URL and parameters for debugging
    print("Current URL: ${html.window.location.href}");
    print("URL Path: ${html.window.location.pathname}");
    print("URL Search: ${html.window.location.search}");
    print("URL Hash: ${html.window.location.hash}");

    // Print API endpoints for reference
    ApiService().printApiEndpoints();
  }

  void _extractSessionIdAndVerify() {
    // Extract session_id from the URL if not provided in the constructor
    String sessionId = widget.sessionId;

    if (sessionId.isEmpty) {
      // Get the full URL
      final url = html.window.location.href;
      print("Full URL for session extraction: $url");

      // Try to extract session_id from search parameters
      final searchParams = html.window.location.search;
      if (searchParams!.isNotEmpty) {
        final searchUri = Uri.parse(searchParams!);
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

      // Try a regex approach as last resort
      if (sessionId.isEmpty) {
        final regex = RegExp(r'session_id=([^&]+)');
        final match = regex.firstMatch(url);
        if (match != null && match.groupCount >= 1) {
          sessionId = match.group(1) ?? '';
        }
      }
    }

    print("Extracted session ID: $sessionId");

    // If we have a session ID, verify the payment
    if (sessionId.isNotEmpty) {
      // Call the API to verify payment
      _verifyPayment(sessionId);
    } else {
      // No session ID found
      setState(() {
        _isLoading = false;
        _errorMessage = 'No session ID found in URL';
      });
    }
  }

  Future<void> _verifyPayment(String sessionId) async {
    try {
      print("Verifying payment with session ID: $sessionId");

      // Call the API service to verify the payment
      await ApiService().verifyPaymentAndCreateCommand(sessionId);

      // If verification successful, update the state
      setState(() {
        _isLoading = false;
        _paymentSuccessful = true;
      });
    } catch (e) {
      print("Payment verification error: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = 'Payment verification failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _isLoading ? 'Processing Payment...' :
          (_paymentSuccessful ? 'Payment Successful!' : 'Payment Issue'),
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