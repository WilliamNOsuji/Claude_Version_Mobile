import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/web_interface/widgets/custom_app_bar.dart';

import '../../../dto/payment.dart';

class WebCommandDetailsPage extends StatelessWidget {
  final Command command;

  const WebCommandDetailsPage({Key? key, required this.command}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildDetailText(String label, dynamic value, {double fontSize = 18, bool isBold = false}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20), // Increased padding for better separation
        child: Text(
          '$label $value',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87, // Darker text for better contrast
          ),
        ),
      );
    }

    Widget _buildSubSectionTitle(String title) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 22, // Slightly larger title for sub-sections
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: WebCustomAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                alignment: Alignment.topLeft,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Détail de la commande",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter'),
                    ),
                    SizedBox(
                      height: 50,
                    ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Ensure left alignment for readability
            children: [
              // Hero section with icon
              Hero(
                tag: 'command-${command.id}',
                child: Icon(Icons.local_shipping, size: 120), // Increased icon size for visibility
              ),
              SizedBox(height: 30), // Increased spacing for better visual separation

              // Command details section
              _buildDetailText('Numéro de Commande:', command.commandNumber, fontSize: 24, isBold: true),
              _buildDetailText('Statut:', command.isDelivered ? 'Livrée' : 'En Attente', fontSize: 18),
              _buildDetailText('Numéro de Téléphone du Client:', command.clientPhoneNumber, fontSize: 18),
              _buildDetailText('Point d\'Arrivée:', command.arrivalPoint, fontSize: 18),
              _buildDetailText('Prix Total:', '${command.totalPrice} ${command.currency}', fontSize: 18),
              _buildDetailText('ID du Client:', command.clientId, fontSize: 18),

              // Conditional delivery man section
              if (command.deliveryManId != null) ...[
                SizedBox(height: 30), // Extra spacing before this section
                _buildSubSectionTitle('Information du livreur'),
                _buildDetailText('ID du Livreur:', command.deliveryManId ?? "Non Assigné", fontSize: 18),
              ],
            ],
          )
                  ],
                ),
              ),
            )


          ],
        ),
      ),
    );

  }
}