import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/pages/deliverymanOrderPages/availableDeliveryDetailPage.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import '../../dto/payment.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/navbarWidgets/navBarDelivery.dart';
import '../../widgets/navbarWidgets/navBarNotDelivery.dart';
import 'deliveriesListPage.dart';

class AvailableOrdersPage extends StatefulWidget {
  const AvailableOrdersPage({super.key});

  @override
  State<AvailableOrdersPage> createState() => _AvailableOrdersPageState();
}

class _AvailableOrdersPageState extends State<AvailableOrdersPage> {
  List<Command> availableCommands = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAvailableCommands();
  }

  Future<void> fetchAvailableCommands() async {
    try {
      var commands = await ApiService().getAllAvailableCommands();
      setState(() {
        availableCommands = commands;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec du chargement des commandes: $e')),
      );
    }
  }

  Future<void> assignDelivery(int commandId) async {
    try {
      var result = await ApiService().assignADelivery(commandId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Livraison assignée avec succès")), // Afficher un message de succès
      );
      // Actualiser la liste des commandes disponibles après l'assignation
      fetchAvailableCommands();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de l\'assignation de la livraison: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Suivi des Commandes', centerTitle: true),
      backgroundColor: Colors.white,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Stack(children: [
      SingleChildScrollView(
        child: Column(
          children: [
            !(availableCommands.length <= 0)
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: availableCommands.length,
                    itemBuilder: (context, index) {
                      var command = availableCommands[index];
                      return Card(
                          child: ListTile(
                              title: Text(
                                  'Commande #${command.commandNumber}'), // Numéro de commande
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Livreur: ${command.deliveryManId ?? "Non Assigné"}'), // ID du livreur
                                  Text(
                                      'Point d\'Arrivée: ${command.arrivalPoint}'), // Point d'arrivée
                                ],
                              ),
                              trailing: ElevatedButton(
                                onPressed: () async {
                                  await assignDelivery(
                                      command.id); // Assigner la livraison
                                },
                                child: Text('Assigner'),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AvailableDeliveryDetailPage(order: command),
                                  ),
                                );
                              }));
                    },
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Column(
                        children: [
                          Lottie.asset(
                            'assets/animations/noOrderClient.json', // Path to your Lottie JSON file
                            width: 160, // Adjust size as needed
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            "Personne n'a commandé.",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeliveriesListPage()),
                );
              },
              child: Text('Voir Mes Livraisons'),
            ),
          ],
        ),
      ),
      Align(
          alignment: Alignment.bottomCenter,
          child: !ApiService.isDelivery
              ? SizedBox()
              : navBarFloatingYesDelivery(context, 2, setState))
    ]);
  }
}
