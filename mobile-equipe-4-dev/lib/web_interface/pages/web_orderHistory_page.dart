import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/dto/payment.dart';
import 'package:mobilelapincouvert/pages/clientOrderPages/commandDetailsPage.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/services/chat_service.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_orderHistory_page.dart';
import 'package:mobilelapincouvert/widgets/custom_app_bar.dart';
import 'package:mobilelapincouvert/widgets/navbarWidgets/navBarDelivery.dart';
import 'package:mobilelapincouvert/widgets/navbarWidgets/navBarNotDelivery.dart';

import 'Utilis/chat_manager.dart';

class WebOrderHistoryPage extends StatefulWidget {
  const WebOrderHistoryPage({super.key});

  @override
  State<WebOrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<WebOrderHistoryPage> {
  List<Command> listCommandes = [];
  bool _isLoading = true;
  final ChatService _chatService = ChatService();

  void fetchCommands() async {
    try {
      setState(() => _isLoading = true);
      listCommandes = await ApiService().getClientCommads();
      setState(() {
        _isLoading = false;
      });
    } catch(e) {
      print('Error fetching commands: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCommands();
  }

  @override
  Widget build(BuildContext context) {
    // For web, use the dedicated web implementation
    if (kIsWeb) {
      return WebOrderHistoryPage();
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Mes commandes',
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildPlatformSpecificBody(),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildPlatformSpecificBody() {
    // Use ChatManager to add appropriate chat functionality
    return ChatManager.addChatToClientOrderPage(buildBody(), listCommandes);
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
                  'assets/animations/noOrderClient.json',
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover,
                ),
                Text("Vous n'avez jamais commandé.",
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommandDetailsPage(command: commande),
          ),
        );
      },
      child: Hero(
        tag: commande.id,
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