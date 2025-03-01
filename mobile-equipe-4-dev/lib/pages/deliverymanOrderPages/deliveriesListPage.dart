import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import '../../dto/payment.dart';
import '../../services/Chat/chat_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/navbarWidgets/navBarDelivery.dart';
import '../../widgets/navbarWidgets/navBarNotDelivery.dart';
import '../chatPage/chat_bubble.dart';
import '../clientOrderPages/commandDetailsPage.dart';
import 'availableOrdersPage.dart';

class DeliveriesListPage extends StatefulWidget {
  @override
  _DeliveriesListPageState createState() => _DeliveriesListPageState();
}

class _DeliveriesListPageState extends State<DeliveriesListPage> {
  List<Command> myDeliveries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMyDeliveries();
  }

  Future<void> fetchMyDeliveries() async {
    try {
      var deliveries = await ApiService().getMyDeliveries();
      setState(() {
        myDeliveries = deliveries;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec du chargement des livraisons: $e')),
      );
    }
  }

  Future<void> markAsDelivered(int commandId) async {
    try {
      await ApiService().commandDelivered(commandId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Livraison effectuée avec succès")), // Afficher un message de succès
      );
      // Actualiser la liste des livraisons après avoir marqué comme livré
      fetchMyDeliveries();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la marque comme livré: $e')),
      );
    }
  }

  Future<void> markCommandInProgress(int commandId) async {
    try {
      await ApiService().markCommandInProgress(commandId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Livraison est a effectuer")), // Afficher un message de succès
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la marque comme en etat de progress: $e')),
      );
    }
  }

  Future<void> cancelDelivery(int commandId) async {
    bool confirmCancel = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Annuler la Livraison'),
        content: Text('Êtes-vous sûr de vouloir annuler cette livraison ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Non'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Oui'),
          ),
        ],
      ),
    );

    if (confirmCancel == true) {
      try {
        await ApiService().cancelADelivery(commandId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Annulation réussie")),
        );
        fetchMyDeliveries();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec de l\'annulation de la livraison: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Mes livraisons",
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : buildBody(),
    );
  }

  Widget buildBody() {
    return Stack(
      children:[ SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              itemCount: myDeliveries.length,
              shrinkWrap: true, // Assure que la ListView ne prend pas plus d'espace que nécessaire
              physics: NeverScrollableScrollPhysics(), // Désactive le défilement de la ListView
              itemBuilder: (context, index) {
                var delivery = myDeliveries[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Hero(
                      tag: 'command-${delivery.id}',
                      child: Icon(Icons.local_shipping, size: 40),
                    ),
                    title: Text('Commande #${delivery.commandNumber}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Statut: ${delivery.isDelivered ? "Livrée" : "En Attente"}'),
                        Text('Point d\'Arrivée: ${delivery.arrivalPoint}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        // Conditionally render the "Livrer" and "Annuler" buttons
                        if (!delivery.isDelivered) ...[

                          ElevatedButton(
                            onPressed: () {
                              markCommandInProgress(delivery.id);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            child: Text('Commencer'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              markAsDelivered(delivery.id);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            child: Text('Livrer'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              cancelDelivery(delivery.id);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            child: Text('Annuler'),
                          ),
                        ],
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommandDetailsPage(command: delivery),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
        Align(
            alignment: Alignment.bottomCenter,
            child: !ApiService.isDelivery ?
            SizedBox() :
            navBarFloatingYesDelivery(context, 2, setState))
    ]);
  }


}

extension DeliveriesListPageChatExtension on _DeliveriesListPageState {
  // New method to build the page with chat bubble
  Widget buildBodyWithChat() {
    // Keep the original body
    Widget originalBody = buildBody();

    // Add floating chat bubbles for in-progress deliveries
    return Stack(
      children: [
        originalBody,
        // Add chat bubbles for all in-progress deliveries
        ...myDeliveries
            .where((command) => command.isInProgress && !command.isDelivered)
            .map((command) => _buildChatBubbleForCommand(command))
            .toList(),
      ],
    );
  }

  // Helper method to build a chat bubble for a specific command
  Widget _buildChatBubbleForCommand(Command command) {
    // Check if chat is active before displaying bubble
    return FutureBuilder<bool>(
      future: ChatService().isChatActive(command.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data == true) {
          return ChatBubble(
            commandId: command.id,
            otherUserId: command.clientId,
            otherUserName: "Client", // Get client name if available
            isDeliveryMan: true, // This is delivery person view
          );
        }
        // Don't show bubble if chat isn't active
        return SizedBox.shrink();
      },
    );
  }

  // Override the build method in the original page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Mes livraisons",
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: buildBodyWithChat(),
      backgroundColor: Colors.white,
    );
  }
}