import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/dto/payment.dart';
import 'package:mobilelapincouvert/pages/deliverymanOrderPages/availableOrdersPage.dart';
import 'package:mobilelapincouvert/widgets/navbarWidgets/navBarDelivery.dart';

import '../../services/api_service.dart';

class AvailableDeliveryDetailPage extends StatefulWidget {
  final Command order;
  const AvailableDeliveryDetailPage({super.key, required this.order});

  @override
  State<AvailableDeliveryDetailPage> createState() => _AvailableDeliveryDetailPageState();
}

class _AvailableDeliveryDetailPageState extends State<AvailableDeliveryDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.order.id,
              child: Material(
                color: Colors.transparent,
                child: Text(
                  'Order ID: ${widget.order.commandNumber}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Status : '),
                Text(widget.order.deliveryManId == null ? 'Status: En attente d\'un livreur' : 'Status: En cours de livraison', style: TextStyle(color: widget.order.deliveryManId == null ? Colors.orange : Colors.blue),),
              ],
            ),
            Text( 'Prix total: ${widget.order.totalPrice.toStringAsFixed(2)}'),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await assignDelivery(widget.order.id); // Assuming Command has an 'id' field
              },
              child: Text('Assign'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ApiService.isDelivery ? navBarFloatingYesDelivery(context, 2, setState) : null,
    );
  }

  Future<void> assignDelivery(int commandId) async {
    try {
      var result = await ApiService().assignADelivery(commandId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Assigned Success")), // Show success message
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AvailableOrdersPage(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to assign delivery: $e')),
      );
    }
  }
}
