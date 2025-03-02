import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/dto/payment.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/web_interface/widgets/custom_app_bar.dart';

class WebDeliveriesListPage extends StatefulWidget {
  const WebDeliveriesListPage({Key? key}) : super(key: key);

  @override
  _WebDeliveriesListPageState createState() => _WebDeliveriesListPageState();
}

class _WebDeliveriesListPageState extends State<WebDeliveriesListPage> {
  List<Command> myDeliveries = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchMyDeliveries();
  }

  Future<void> fetchMyDeliveries() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      var deliveries = await ApiService().getMyDeliveries();

      if (mounted) {
        setState(() {
          myDeliveries = deliveries;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load deliveries: $e';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load deliveries: $e')),
        );
      }
    }
  }

  Future<void> markAsDelivered(int commandId) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Mark command as delivered
      await ApiService().commandDelivered(commandId);

      // Close the loading dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Delivery completed successfully")),
      );

      // Refresh the list of deliveries
      fetchMyDeliveries();
    } catch (e) {
      // Close the loading dialog if it's open
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark as delivered: $e')),
      );
    }
  }

  Future<void> markCommandInProgress(int commandId) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Mark command as in progress
      await ApiService().markCommandInProgress(commandId);

      // Close the loading dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Delivery started")),
      );

      // Refresh the list of deliveries
      fetchMyDeliveries();
    } catch (e) {
      // Close the loading dialog if it's open
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start delivery: $e')),
      );
    }
  }

  Future<void> cancelDelivery(int commandId) async {
    // Ask for confirmation before cancelling
    bool confirmCancel = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Delivery'),
        content: Text('Are you sure you want to cancel this delivery?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Yes'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    ) ?? false;

    if (confirmCancel) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Cancel the delivery
        await ApiService().cancelADelivery(commandId);

        // Close the loading dialog
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Delivery cancelled")),
        );

        // Refresh the list of deliveries
        fetchMyDeliveries();
      } catch (e) {
        // Close the loading dialog if it's open
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to cancel delivery: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WebCustomAppBar(),
      backgroundColor: Colors.white,
      body: _buildBody(),
      endDrawer: Drawer(), // Add your cart drawer here
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return _buildErrorView();
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "My Deliveries",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 24),

          Expanded(
            child: myDeliveries.isNotEmpty
                ? _buildDeliveriesList()
                : _buildEmptyState(),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 70, color: Colors.red[300]),
          SizedBox(height: 16),
          Text(
            errorMessage,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: fetchMyDeliveries,
            child: Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors().green(),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
            "You don't have any active deliveries",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Start by accepting available orders",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveriesList() {
    return ListView.builder(
      itemCount: myDeliveries.length,
      itemBuilder: (context, index) {
        return _buildDeliveryCard(myDeliveries[index]);
      },
    );
  }

  Widget _buildDeliveryCard(Command delivery) {
    return Card(
      elevation: 3,
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
                  'Order #${delivery.commandNumber}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(delivery),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red.shade800, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Delivery Address: ${delivery.arrivalPoint}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.blue.shade800, size: 20),
                SizedBox(width: 8),
                Text(
                  'Phone: ${delivery.clientPhoneNumber}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.attach_money, color: Colors.green.shade800, size: 20),
                SizedBox(width: 8),
                Text(
                  'Total: ${delivery.totalPrice.toStringAsFixed(2)} ${delivery.currency}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Action buttons - only show if not delivered
            if (!delivery.isDelivered)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Start delivery button
                  ElevatedButton.icon(
                    onPressed: () => markCommandInProgress(delivery.id),
                    icon: Icon(Icons.play_arrow),
                    label: Text('Start'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors().green(),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                  SizedBox(width: 12),

                  // Mark as delivered button
                  ElevatedButton.icon(
                    onPressed: () => markAsDelivered(delivery.id),
                    icon: Icon(Icons.check),
                    label: Text('Complete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                  SizedBox(width: 12),

                  // Cancel button
                  ElevatedButton.icon(
                    onPressed: () => cancelDelivery(delivery.id),
                    icon: Icon(Icons.cancel),
                    label: Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(Command delivery) {
    Color chipColor;
    String statusText;

    if (delivery.isDelivered) {
      chipColor = Colors.green;
      statusText = 'Delivered';
    } else if (delivery.isInProgress) {
      chipColor = Colors.orange;
      statusText = 'In Progress';
    } else {
      chipColor = Colors.blue;
      statusText = 'Assigned';
    }

    return Chip(
      label: Text(
        statusText,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: chipColor,
    );
  }
}