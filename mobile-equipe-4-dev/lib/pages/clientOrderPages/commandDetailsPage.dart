import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/web_interface/pages/clientOrderPages/web_commandDetailsPage.dart';
import '../../dto/payment.dart';
import '../../generated/l10n.dart'; // Assuming Command is defined here

class CommandDetailsPage extends StatelessWidget {
  final Command command;

  const CommandDetailsPage({Key? key, required this.command}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? WebCommandDetailsPage(command: command,) : Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).dtailsDeLaCommande),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.local_shipping, size: 100),
            SizedBox(height: 20),
            Text(
              '${S.of(context).numroDeCommandeCommandcommandnumber} ${command.commandNumber}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(

              '${S.of(context).status} ${command.isDelivered ? "${S.of(context).delivered}" : "${S.of(context).waiting}"}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '${S.of(context).NumeroDeTelephone} ${command.clientPhoneNumber}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '${S.of(context).arrivalTime} ${command.arrivalPoint}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '${S.of(context).totalPrice} ${command.totalPrice} ${command.currency}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '${S.of(context).ClientId} ${command.clientId}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),

            command.deliveryManId != null ?

                Container(
                  child: Column(
                    children: [
                      Text(
                        S.of(context).livreurInfo,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),

                      Text(
                        '${S.of(context).livreurID} ${command.deliveryManId ?? "${S.of(context).assignation}"}',
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