import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/dto/payment.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'package:mobilelapincouvert/pages/clientOrderPages/commandDetailsPage.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/services/chat_service.dart';
import 'package:mobilelapincouvert/web_interface/widgets/custom_app_bar.dart';

class WebDeliveriesListPage extends StatefulWidget {
  const WebDeliveriesListPage({Key? key}) : super(key: key);

  @override
  _WebDeliveriesListPageState createState() => _WebDeliveriesListPageState();
}

class _WebDeliveriesListPageState extends State<WebDeliveriesListPage> {
  List<Command> myDeliveries = [];
  bool isLoading = true;
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    fetchMyDeliveries();
  }

  Future<void> fetchMyDeliveries() async {
    try {
      setState(() => isLoading = true);
      var deliveries = await ApiService().getMyDeliveries();

      setState(() {
        myDeliveries = deliveries;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading deliveries: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> markAsDelivered(int commandId) async {
    try {
      await ApiService().commandDelivered(commandId);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Livraison effectuée avec succès"))
      );
      fetchMyDeliveries();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec: $e'))
      );
    }
  }

  Future<void> markCommandInProgress(int commandId) async {
    try {
      await ApiService().markCommandInProgress(commandId);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Livraison en cours"))
      );
      fetchMyDeliveries();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec: $e'))
      );
    }
  }

  Future<void> cancelDelivery(int commandId) async {
    bool confirmCancel = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Annuler la Livraison'),
        content: Text('Êtes-vous sûr de vouloir annuler cette livraison?'),
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
    ) ?? false;

    if (confirmCancel) {
      try {
        await ApiService().cancelADelivery(commandId);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Annulation réussie"))
        );
        fetchMyDeliveries();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Échec de l\'annulation: $e'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WebCustomAppBar(),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : buildBody(),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mes Livraisons",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 24),

          if (myDeliveries.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/animations/noOrderClient.json',
                      width: 240,
                      height: 240,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Vous n'avez aucune livraison en cours",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: myDeliveries.length,
                itemBuilder: (context, index) {
                  final delivery = myDeliveries[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Commande #${delivery.commandNumber}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${delivery.totalPrice.toStringAsFixed(2)} ${delivery.currency}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors().green(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.red.shade800, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Local: ${delivery.arrivalPoint}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.phone, color: Colors.blue.shade800, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Téléphone: ${delivery.clientPhoneNumber}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!delivery.isDelivered) ...[
                                ElevatedButton.icon(
                                  onPressed: () => markCommandInProgress(delivery.id),
                                  icon: Icon(Icons.play_arrow),
                                  label: Text('Commencer'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors().green(),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                ),
                                SizedBox(width: 12),
                                ElevatedButton.icon(
                                  onPressed: () => markAsDelivered(delivery.id),
                                  icon: Icon(Icons.check),
                                  label: Text('Livrer'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                ),
                                SizedBox(width: 12),
                                ElevatedButton.icon(
                                  onPressed: () => cancelDelivery(delivery.id),
                                  icon: Icon(Icons.cancel),
                                  label: Text('Annuler'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                ),
                              ] else ...[
                                Chip(
                                  label: Text(
                                    'Livraison effectuée',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: AppColors().green(),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}