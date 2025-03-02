import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/dto/payment.dart';
import 'package:mobilelapincouvert/pages/clientOrderPages/commandDetailsPage.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/web_interface/widgets/custom_app_bar.dart';
import 'package:mobilelapincouvert/widgets/navbarWidgets/navBarDelivery.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/navbarWidgets/navBarNotDelivery.dart';

class WebOrderHistoryPage extends StatefulWidget {
  const WebOrderHistoryPage({super.key});

  @override
  State<WebOrderHistoryPage> createState() => _WebOrderHistoryPageState();
}

List<Command> listCommandes = [];

class _WebOrderHistoryPageState extends State<WebOrderHistoryPage> {
  void fetchCommands() async {
    listCommandes = await ApiService().getClientCommads();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCommands();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WebCustomAppBar(),
      body: buildBody(),
      backgroundColor: Colors.white,
    );
  }

  Widget buildBody() {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: listCommandes.length > 0
            ? ListView.builder(
          itemCount: listCommandes.length,
          itemBuilder: (context, index) {
            return _buildCardCommande(listCommandes[index], context);
          },
        )
            : Column(

          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Vos commandes",style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter'),),
            ),
            Center(child:
            Column(


              children: [
                Lottie.asset(
                  'assets/animations/noOrderClient.json', // Path to your Lottie JSON file
                  width: 300, // Adjust size as needed
                  fit: BoxFit.cover,
                ),
                Text("Vous n'avez jamais commandé.",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),),
              ],
            )),
          ],
        ),
      ),
    ]);
  }

  Widget _buildCardCommande(Command commande, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Naviguer vers la page détaillée de la commande avec l'animation Hero
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommandDetailsPage(command: commande),
          ),
        );
      },
      child: Hero(
        tag: commande.id, // Tag unique pour la transition Hero
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.only(bottom: 15),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID Commande: ${commande.commandNumber}',
                      style:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          'status: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text(
                          commande.deliveryManId == null
                              ? 'En attente d\'un livreur'
                              : 'En cours de livraison',
                          style: TextStyle(
                            color: commande.deliveryManId == null
                                ? Colors.orange
                                : Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "Local : " + commande.arrivalPoint.toString(),
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            color: Colors.grey[600], size: 14),
                        SizedBox(width: 5),
                        Text(
                          'Fontion à vénir',
                          style:
                          TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Livreur: N/A',
                      style: TextStyle(color: Colors.grey[800], fontSize: 12),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Total: ${commande.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
