// ignore_for_file: unused_import

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/widgets/navbarWidgets/navBarDelivery.dart';
import 'package:mobilelapincouvert/widgets/navbarWidgets/navBarNotDelivery.dart';
import '../../generated/l10n.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_app_bar.dart';

class DeliveryManInfoPage extends StatefulWidget {
  const DeliveryManInfoPage({super.key});

  @override
  State<DeliveryManInfoPage> createState() => _DeliveryManInfoPageState();
}

class _DeliveryManInfoPageState extends State<DeliveryManInfoPage> {
  bool _showStatusText = false;
  void _toggleStatus() {
    setState(() {
      _showStatusText = true;
    });
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showStatusText = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: S.of(context).livreurInfo, centerTitle: true),
      body: buildBody(),
      bottomNavigationBar: ApiService.isDelivery ? navBarFloatingYesDelivery(context, 2, setState) : navBarFloatingNoDelivery(context, 2, setState),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      child: Column(
        children: [
          // Line between page and AppBar
          const Divider(
            color: Color(0xFFCFCFCF),
            indent: 20,
            endIndent: 20,
          ),

          // Space
          const SizedBox(height: 20),

          SizedBox(
            height: 220,
            width: 220,
            child: Stack(
              children: [
                // Picture
                CircleAvatar(
                  radius: 150,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: AssetImage('assets/images/deliveryRabbit.jpg'),
                ),
                // Change picture button
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: InkWell(
                    onTap: () {
                      //TODO: Pull up status text
                      _toggleStatus();
                    },
                    child: CircleAvatar(
                      backgroundColor: Color(0xFFFFFFFF),
                      radius: 25,
                      child: CircleAvatar(
                        backgroundColor: Color(0xFF4CAF50),
                        radius: 22,
                      ),
                    ),
                  ),
                ),
                if (_showStatusText)
                  Positioned(
                    bottom: 56,
                    right: 0,
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        S.of(context).disponible,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Space
          const SizedBox(height: 20),

          // Basic Information Section
          const Text(
            "John Doe", // Username
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.star, color: Colors.amber, size: 24),
              Icon(Icons.star, color: Colors.amber, size: 24),
              Icon(Icons.star, color: Colors.amber, size: 24),
              Icon(Icons.star, color: Colors.amber, size: 24),
              Icon(Icons.star_half, color: Colors.amber, size: 24),
              SizedBox(width: 8),
              Text(
                "4.5", // Rating
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),

          // Space before the card
          const SizedBox(height: 20),

          // Improved Additional Details Card
          Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Detailed status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade400),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Disponible pour livraison. Dernière activité il y a 5 minutes.",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(
                    color: Color(0xFFCFCFCF),
                    indent: 35,
                    endIndent: 35,
                  ),
                  const SizedBox(height: 11),
                  // Phone number
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.green.shade400),
                      const SizedBox(width: 12),
                      const Text(
                        "+1 (438) 123-4567",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(
                    color: Color(0xFFCFCFCF),
                    indent: 35,
                    endIndent: 35,
                  ),
                  const SizedBox(height: 15),
                  // Bio
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.person, color: Colors.orange.shade400),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Bio: John est un professionnel de la livraison dévoué depuis plus de 5 ans, garantissant que chaque colis est livré en toute sécurité et à temps. Son engagement envers un excellent service client est inégalé.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Space
          const SizedBox(height: 20),

          // Back button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF159315),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
            onPressed: () {
              //TODO: Retour à la commande
            },
            child: Text(
              'Retour',
              style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF)),
            ),
          ),

          const SizedBox(height: 20),

          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Powered by ',
                  style: TextStyle(fontSize: 10),
                ),
                Image.asset(
                  'assets/images/adeptinfo_badge.png',
                  height: 25,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
