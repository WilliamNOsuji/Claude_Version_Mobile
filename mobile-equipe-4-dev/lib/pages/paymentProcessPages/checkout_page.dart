// lib/pages/paymentProcessPages/checkout_page.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/dto/auth.dart';
import 'package:mobilelapincouvert/dto/payment.dart';
import 'package:mobilelapincouvert/pages/paymentProcessPages/order_success_page.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/widgets/custom_app_bar.dart';
import 'package:mobilelapincouvert/widgets/order_progress.dart';
import '../../gestion_erreurs.dart';
import '../../models/colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../web_interface/pages/web_checkout_page.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartProductDTO> listCartProducts;
  const CheckoutPage({super.key, required this.listCartProducts});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

GlobalKey<FormState> formkey = GlobalKey<FormState>();
TextEditingController name_controller = TextEditingController();
TextEditingController adress_controller = TextEditingController();
TextEditingController phoneNumber_controller = TextEditingController();
bool _isButtonDisabled = false;

class _CheckoutPageState extends State<CheckoutPage> {
  //final StripeWebService _stripeWebService = StripeWebService();

  @override
  void initState() {
    super.initState();

    // Check for Stripe payment return (web only)
    //if (kIsWeb) {
    //  WidgetsBinding.instance.addPostFrameCallback((_) {
    //    _checkStripePaymentReturn();
    //  });
    //}
  }

  //void _checkStripePaymentReturn() {
  //  if (!kIsWeb) return;
//
  //  // Get current URL including hash fragment
  //  final uri = Uri.parse(Uri.base.toString());
  //  final path = uri.fragment; // Get the fragment part after #
//
  //  if (path.startsWith('/order-success')) {
  //    // Extract session ID from query parameters
  //    final queryParams = Uri.parse(path).queryParameters;
  //    final sessionId = queryParams['session_id'];
//
  //    if (sessionId != null) {
  //      _handleSuccessfulPayment(sessionId);
  //    }
  //  } else if (path.startsWith('/checkout')) {
  //    // Handle cancelled payment case
  //    final queryParams = Uri.parse(path).queryParameters;
  //    if (queryParams['canceled'] == 'true') {
  //      ScaffoldMessenger.of(context).showSnackBar(
  //        SnackBar(content: Text('Payment was cancelled')),
  //      );
  //    }
  //  }
  //}

  //Future<void> _handleSuccessfulPayment(String sessionId) async {
  //  // Show loading indicator
  //  showDialog(
  //    context: context,
  //    barrierDismissible: false,
  //    builder: (context) => Center(child: CircularProgressIndicator()),
  //  );
//
  //  // Verify payment with backend
  //  final command = await _stripeWebService.verifyPaymentSession(sessionId);
//
  //  // Close loading dialog
  //  Navigator.pop(context);
//
  //  if (command != null) {
  //    // Navigate to success page
  //    Navigator.pushReplacement(
  //      context,
  //      MaterialPageRoute(
  //        builder: (context) => OrderSuccessPage(sessionId: "",),
  //      ),
  //    );
  //  } else {
  //    // Show error
  //    ScaffoldMessenger.of(context).showSnackBar(
  //      SnackBar(content: Text('Could not verify payment. Please contact support.')),
  //    );
  //  }
  //}

  @override
  Widget build(BuildContext context) {

    return kIsWeb ? WebCheckoutPage(listCartProducts: widget.listCartProducts) : Scaffold(
      appBar: CustomAppBar(title: 'Vérification', centerTitle: true),
      backgroundColor: Colors.white,
      bottomNavigationBar: bottomButton(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              children: [
                OrderProgress(activeStep: 2),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors().red(),
                      child: Icon(Icons.fastfood, size: 20, color: AppColors().white()),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Mes produits",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors().black()),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Divider(),
                ExpansionTile(
                  title: Text(
                    "${widget.listCartProducts.length} produits",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  children: widget.listCartProducts.map((item) => ListTile(
                    leading: SizedBox(height: 60, width: 60, child: Image.network(item.imageUrl, fit: BoxFit.contain)),
                    title: Text(item.name),
                    subtitle: Row(
                      children: [
                        Row(
                          children: [
                            Text('Nbr: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(item.quantity.toString())
                          ],
                        ),
                        Text('  |  '),
                        Row(
                          children: [
                            Text('Prix: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('${(item.quantity * item.prix).toStringAsFixed(2)} \$')
                          ],
                        )
                      ],
                    ),
                  )).toList(),
                ),
                SizedBox(height: 32.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors().green(),
                              child: Icon(Icons.local_shipping, size: 20, color: AppColors().white()),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Mes informations",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors().black()),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: 12),
                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: name_controller,
                            validator: (value) => errorNomComplet(context, name_controller.text),
                            maxLength: 16,
                            decoration: InputDecoration(
                              hintText: 'Nom complet',
                              label: Text('Nom complet'),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors().gray(),
                                      width: 1.0
                                  )
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: adress_controller,
                            validator: (value) => errorLocal(context, adress_controller.text),
                            maxLength: 16,
                            decoration: InputDecoration(
                              hintText: 'D-0601',
                              label: Text('Local'),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors().gray(),
                                      width: 1.0
                                  )
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: phoneNumber_controller,
                            validator: (value) => errorPhone(context, phoneNumber_controller.text),
                            maxLength: 16,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: '(000) - 000 - 0000',
                              label: Text('Télephone'),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors().gray(),
                                      width: 1.0
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
    );
  }

  Widget bottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sous-total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                '\$${ApiService().calculateFinalTotal(widget.listCartProducts).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isButtonDisabled ? null : () async {
                if (formkey.currentState!.validate()) {
                  setState(() {
                    _isButtonDisabled = true;
                  });

                  try {
                    ApiService.address = adress_controller.text;
                    ApiService.phoneNum = phoneNumber_controller.text;

                    await ApiService().PaiementRequest(context, widget.listCartProducts);
                  } finally {
                    setState(() {
                      _isButtonDisabled = false;
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors().black(),
              ),
              child: Text(
                'Paiement',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}