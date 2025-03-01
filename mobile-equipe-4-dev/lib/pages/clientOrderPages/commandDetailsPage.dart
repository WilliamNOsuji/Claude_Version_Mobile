import 'package:flutter/material.dart';
import '../../dto/payment.dart'; // Assuming Command is defined here

class CommandDetailsPage extends StatelessWidget {
  final Command command;

  const CommandDetailsPage({Key? key, required this.command}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la Commande'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'command-${command.id}', // Même tag que dans CommandListPage
              child: Icon(Icons.local_shipping, size: 100), // Exemple d'icône
            ),
            SizedBox(height: 20),
            Text(
              'Numéro de Commande: ${command.commandNumber}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Statut: ${command.isDelivered ? "Livrée" : "En Attente"}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Numéro de Téléphone du Client: ${command.clientPhoneNumber}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Point d\'Arrivée: ${command.arrivalPoint}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Prix Total: ${command.totalPrice} ${command.currency}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'ID du Client: ${command.clientId}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),

            command.deliveryManId != null ?

                Container(
                  child: Column(
                    children: [
                      Text(
                        'Information du livreur',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),

                      Text(
                        'ID du Livreur: ${command.deliveryManId ?? "Non Assigné"}',
                        style: TextStyle(fontSize: 16),
                      ),

                    ],
                  ),
                ) : SizedBox()

          ],
        ),
      ),
    );
  }
}