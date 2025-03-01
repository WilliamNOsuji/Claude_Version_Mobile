import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/dto/payment.dart';
import 'package:mobilelapincouvert/pages/clientOrderPages/commandDetailsPage.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/widgets/navbarWidgets/navBarDelivery.dart';
import '../../services/Chat/chat_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/navbarWidgets/navBarNotDelivery.dart';
import '../chatPage/chat_bubble.dart';
import '../deliverymanOrderPages/availableDeliveryDetailPage.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

List<Command> listCommandes = [];

class _OrderHistoryPageState extends State<OrderHistoryPage> {
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
      appBar: CustomAppBar(
        title: 'Mes commandes',
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child:
                  Column(
                    children: [
                      Lottie.asset(
                        'assets/animations/noOrderClient.json', // Path to your Lottie JSON file
                        width: 160, // Adjust size as needed
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                      Text("Vous n'avez jamais commandé.",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),),
                    ],
                  )),
                ],
              ),
      ),
      Align(
          alignment: Alignment.bottomCenter,
          child: !ApiService.isDelivery ?
          navBarFloatingNoDelivery(context, 2, setState) :
          navBarFloatingYesDelivery(context, 3, setState))
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

extension OrderHistoryPageChatExtension on _OrderHistoryPageState {
  // New method to build the page with chat bubble
  Widget buildBodyWithChat() {
    // Keep the original body
    Widget originalBody = buildBody();

    // Add floating chat bubbles for in-progress deliveries
    return Stack(
      children: [
        originalBody,
        // Add chat bubbles for all in-progress deliveries
        ...listCommandes
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
            otherUserId: command.deliveryManId ?? 0,
            otherUserName: "Livreur", // Replace with actual name if available
            isDeliveryMan: false, // This is client view
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
        title: 'Mes commandes',
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: buildBodyWithChat(),
      backgroundColor: Colors.white,
    );
  }
}
