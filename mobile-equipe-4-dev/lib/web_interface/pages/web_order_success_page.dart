// lib/web_interface/pages/web_order_success_page.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/dto/payment.dart';
import 'package:mobilelapincouvert/pages/HomePage.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/services/web_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;

class WebOrderSuccessPage extends StatefulWidget {
  final String sessionId;

  const WebOrderSuccessPage({super.key, required this.sessionId});

  @override
  _WebOrderSuccessPageState createState() => _WebOrderSuccessPageState();
}

class _WebOrderSuccessPageState extends State<WebOrderSuccessPage> {
  bool _isLoading = true;
  bool _paymentSuccessful = false;
  bool _isAlreadyProcessed = false;
  String _errorMessage = '';
  Command? _command;
  String _sessionId = '';

  @override
  void initState() {
    super.initState();
    if(kIsWeb){
      _extractSessionIdAndVerify();
    }
  }

  Future<void> _extractSessionIdAndVerify() async {
    try {
      // First check if we have a sessionId passed to the widget
      String sessionId = widget.sessionId;

      // If empty, check if we have a stored session ID from the app initialization
      if (sessionId.isEmpty) {
        final prefs = await SharedPreferences.getInstance();
        sessionId = prefs.getString('payment_session_id') ?? '';

        // Clear the stored session ID to prevent reuse
        if (sessionId.isNotEmpty) {
          await prefs.remove('payment_session_id');
        }
      }

      // If still empty, try to extract from URL
      sessionId = WebApiService().ifEmptyExtractUrl(sessionId);

      setState(() {
        _sessionId = sessionId;
      });

      print("Final session ID: $sessionId");

      // If we have a session ID, check if it's already been processed
      if (sessionId.isNotEmpty) {
        // Check if this session has already been processed
        final prefs = await SharedPreferences.getInstance();
        final processedSessions = prefs.getStringList('processed_payment_sessions') ?? [];

        if (processedSessions.contains(sessionId)) {
          // This session has already been processed
          print("Session already processed: $sessionId");

          setState(() {
            _isLoading = false;
            _paymentSuccessful = true;
            _isAlreadyProcessed = true;
          });

          // Remove the session_id from URL (to prevent refreshes creating duplicates)
          if (kIsWeb) {
            _replaceUrlWithoutSessionId();
          }
        } else {
          await _verifyPayment(sessionId);
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No session ID found. Unable to verify payment.';
        });
      }
    } catch (e) {
      print("Error in session ID extraction: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error processing payment: $e';
      });
    }
  }

  void _replaceUrlWithoutSessionId() {
    try {
      final uri = html.window.location.href;
      final uriObj = Uri.parse(uri);
      final queryParams = Map<String, String>.from(uriObj.queryParameters);
      queryParams.remove('session_id');

      final newUri = Uri(
        scheme: uriObj.scheme,
        host: uriObj.host,
        port: uriObj.port,
        path: uriObj.path,
        queryParameters: queryParams.isEmpty ? null : queryParams,
        fragment: uriObj.fragment,
      );

      html.window.history.replaceState({}, '', newUri.toString());
    } catch (e) {
      print("Error replacing URL: $e");
    }
  }

  Future<void> _verifyPayment(String sessionId) async {
    try {
      print("Verifying payment with session ID: $sessionId");

      // Call the API service to verify the payment and create command
      final command = await ApiService().verifyPaymentAndCreateCommand(sessionId);

      // Store this session ID as processed
      if (command != null) {
        final prefs = await SharedPreferences.getInstance();
        final processedSessions = prefs.getStringList('processed_payment_sessions') ?? [];
        if (!processedSessions.contains(sessionId)) {
          processedSessions.add(sessionId);
          await prefs.setStringList('processed_payment_sessions', processedSessions);
        }
      }

      // Remove the session_id from URL
      if (kIsWeb) {
        _replaceUrlWithoutSessionId();
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
          _paymentSuccessful = true;
          _command = command;
        });
      }
    } catch (e) {
      print("Payment verification error: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Payment verification failed: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _isLoading ? 'Processing Payment...' :
          (_paymentSuccessful ? 'Payment Successful!' : 'Payment Status'),
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
          if (_sessionId.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Session ID: $_sessionId',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
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
            _isAlreadyProcessed
                ? 'Your order was already processed. We\'re preparing your delicious food!'
                : 'Your order has been processed successfully. We\'re preparing your delicious food!',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),

          // Order details if available
          if (_command != null) ...[
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    _buildOrderDetailRow('Order Number', '${_command!.commandNumber}'),
                    _buildOrderDetailRow('Delivery Address', _command!.arrivalPoint),
                    _buildOrderDetailRow('Total', '${_command!.totalPrice} ${_command!.currency}'),
                    _buildOrderDetailRow('Contact Phone', _command!.clientPhoneNumber),
                  ],
                ),
              ),
            ),
          ],

          if (_isAlreadyProcessed && _command == null) ...[
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'This order has already been processed. For order details, please check your order history or contact customer support.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

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
              'Continue Shopping',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label + ':',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
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
              'Payment Verification Issue',
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
            if (_sessionId.isNotEmpty) ...[
              Text(
                'Session ID: $_sessionId',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 16),
            ],
            ElevatedButton(
              onPressed: () {
                if (_sessionId.isNotEmpty) {
                  _verifyPayment(_sessionId);
                } else {
                  _extractSessionIdAndVerify();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Try Again'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Return to Home'),
            ),
          ],
        ),
      ),
    );
  }
}