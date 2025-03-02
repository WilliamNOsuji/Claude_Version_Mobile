import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/dto/auth.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/services/stripe_web_service.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_order_success_page.dart';
import 'package:mobilelapincouvert/widgets/custom_app_bar.dart';
import 'package:mobilelapincouvert/widgets/order_progress.dart';
import 'package:mobilelapincouvert/pages/paymentProcessPages/order_success_page.dart';
import '../../gestion_erreurs.dart';
import '../../models/colors.dart';

class WebCheckoutPage extends StatefulWidget {
  final List<CartProductDTO> listCartProducts;
  const WebCheckoutPage({super.key, required this.listCartProducts});

  @override
  _WebCheckoutPageState createState() => _WebCheckoutPageState();
}

GlobalKey<FormState> formkey = GlobalKey<FormState>();
TextEditingController name_controller = TextEditingController();
TextEditingController adress_controller = TextEditingController();
TextEditingController phoneNumber_controller = TextEditingController();
bool _isButtonDisabled = false;

class _WebCheckoutPageState extends State<WebCheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: Icon(Icons.fastfood, size: 20, color: AppColors().white(),),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Mes produits",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors().black()),
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
                    leading: SizedBox(height: 60,width: 60, child: Image.network(item.imageUrl, fit: BoxFit.contain,)),
                    title: Text(item.name),
                    subtitle: Row(
                      children: [
                        Row(
                          children: [
                            Text('Nbr: ', style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(item.quantity.toString())
                          ],
                        ),
                        Text('  |  '),
                        Row(
                          children: [
                            Text('Prix: ', style: TextStyle(fontWeight: FontWeight.bold),),
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
                              child: Icon(Icons.local_shipping, size: 20, color: AppColors().white(),),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Mes informations",
                              style:
                              TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors().black()),
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
                '\$${ApiService().calculateFinalTotal(widget.listCartProducts).toStringAsFixed(2)}', // Display totalAmount
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isButtonDisabled ? null : () async {
                if(formkey.currentState!.validate()) {
                  setState(() {
                    _isButtonDisabled = true; // Disable the button
                  });
                  try {
                    ApiService.address = adress_controller.text;
                    ApiService.phoneNum = phoneNumber_controller.text;

                    if (kIsWeb) {
                      await _handleWebPayment();
                    }
                  } finally {
                    setState(() {
                      _isButtonDisabled = false; // Re-enable the button
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

  Future<void> _handleWebPayment() async {
    try {
      // Validate cart products
      var validationResponse = await ApiService().validateCartProducts(context, widget.listCartProducts);

      if (validationResponse.toString() == "Le panier est valide") {
        // Store form data in ApiService
        ApiService.address = adress_controller.text;
        ApiService.phoneNum = phoneNumber_controller.text;

        // Get app base URL for success and cancel redirects
        final baseUrl = Uri.base.origin;

        // Create URLs with session_id parameter
        // Stripe will replace {CHECKOUT_SESSION_ID} with the actual session ID
        final successUrl = '$baseUrl/#/order-success?session_id={CHECKOUT_SESSION_ID}';
        final cancelUrl = '$baseUrl/#/homepage';

        // Get checkout session URL
        final checkoutUrl = await StripeWebService().createCheckoutSession(
          amount: ApiService().calculateFinalTotal(widget.listCartProducts),
          currency: ApiService.currency,
          address: ApiService.address,
          phoneNum: ApiService.phoneNum,
          deviceTokens: [],
          successUrl: successUrl,
          cancelUrl: cancelUrl,
        );

        if (checkoutUrl != null) {
          // Redirect to Stripe Checkout
          StripeWebService().redirectToCheckout(checkoutUrl);
          print("Redirecting to Stripe: $checkoutUrl");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create checkout session. Please try again.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(validationResponse.toString())),
        );
      }
    } catch (e) {
      print("Error in _handleWebPayment: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
    }
  }
}