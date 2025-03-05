import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/dto/payment.dart';
import 'package:mobilelapincouvert/pages/HomePage.dart';

import '../../generated/l10n.dart';
import '../../widgets/custom_app_bar.dart';

class OrderSuccessPage extends StatefulWidget {
  final String sessionId;

  const OrderSuccessPage({super.key, required this.sessionId});

  @override
  _OrderSuccessPageState createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> {
  Command? _command;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    //if(kIsWeb){
    //  _verifyPayment();
    //}
  }

  //Future<void> _verifyPayment() async {
  //  try {
  //    final stripeWebService = StripeWebService();
  //    final command = await stripeWebService.verifyPaymentSession(widget.sessionId);
//
  //    if (mounted) {
  //      setState(() {
  //        _command = command as Command?;
  //        _isLoading = false;
  //      });
  //    }
  //  } catch (e) {
  //    if (mounted) {
  //      setState(() {
  //        _errorMessage = 'Failed to verify payment. Please contact support.';
  //        _isLoading = false;
  //      });
  //    }
  //  }
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).succs, centerTitle: true, backgroundColor: Colors.green, titleColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).thankYouForYourOrder,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              S.of(context).yourDeliciousFoodIsBeingPreparedAndWillArriveSoon,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
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
                S.of(context).backToHome,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            _buildDetailRow('Order Number', _command?.commandNumber.toString() ?? 'N/A'),
            _buildDetailRow('Total Price', '\$${_command?.totalPrice.toStringAsFixed(2) ?? 'N/A'}'),
            _buildDetailRow('Currency', _command?.currency ?? 'N/A'),
            _buildDetailRow('Delivery Address', _command?.arrivalPoint ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}