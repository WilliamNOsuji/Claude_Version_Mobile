import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/dto/payment.dart';
import 'package:mobilelapincouvert/pages/deliverymanOrderPages/availableOrdersPage.dart';
import 'package:mobilelapincouvert/widgets/navbarWidgets/navBarDelivery.dart';

import '../../generated/l10n.dart';
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
        title: Text(S.of(context).orderDetails),
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
                  '${S.of(context).orderID} ${widget.order.commandNumber}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(S.of(context).orderID),
                Text(widget.order.deliveryManId == null ? S.of(context).statusEnAttenteDunLivreur : S.of(context).statusEnCoursDeLivraison, style: TextStyle(color: widget.order.deliveryManId == null ? Colors.orange : Colors.blue),),
              ],
            ),
            Text( '${S.of(context).totalPrice} ${widget.order.totalPrice.toStringAsFixed(2)}'),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await assignDelivery(widget.order.id); // Assuming Command has an 'id' field
              },
              child: Text(S.of(context).assign),
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
        SnackBar(content: Text(S.of(context).assignedSuccess)), // Show success message
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AvailableOrdersPage(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${S.of(context).failedassignDelivery} $e')),
      );
    }
  }
}

extension AvailableDeliveryDetailPageChatExtension on _AvailableDeliveryDetailPageState {
  // Enhanced method to handle assignment and chat initialization
  Future<void> assignDeliveryWithChat(int commandId) async {
    try {
      // First assign the delivery
      var result = await ApiService().assignADelivery(commandId);

      // Then mark it as in progress to initialize chat
      await ApiService().markCommandInProgress(commandId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Assigned Successfully. Chat is now available.")),
      );

      // Navigate as usual
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

  // We need to modify the button press handler
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
            // Original UI elements...

            ElevatedButton(
              onPressed: () async {
                // Use our new enhanced method instead
                await assignDeliveryWithChat(widget.order.id);
              },
              child: Text('Assign & Start Chat'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ApiService.isDelivery ? navBarFloatingYesDelivery(context, 2, setState) : null,
    );
  }
}