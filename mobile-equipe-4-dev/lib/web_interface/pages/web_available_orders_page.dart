import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/dto/payment.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/web_interface/pages/web_deliveries_list_page.dart';
import 'package:mobilelapincouvert/web_interface/widgets/custom_app_bar.dart';

class WebAvailableOrdersPage extends StatefulWidget {
  const WebAvailableOrdersPage({super.key});

  @override
  State<WebAvailableOrdersPage> createState() => _WebAvailableOrdersPageState();
}

class _WebAvailableOrdersPageState extends State<WebAvailableOrdersPage> {
  List<Command> availableCommands = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchAvailableCommands();
  }

  Future<void> fetchAvailableCommands() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      var commands = await ApiService().getAllAvailableCommands();

      if (mounted) {
        setState(() {
          availableCommands = commands;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load available orders: $e';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load orders: $e')),
        );
      }
    }
  }

  Future<void> assignDelivery(int commandId) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Assign the delivery
      await ApiService().assignADelivery(commandId);

      // Close the loading dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Delivery assigned successfully")),
      );

      // Refresh the list of available commands
      fetchAvailableCommands();
    } catch (e) {
      // Close the loading dialog if it's open
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to assign delivery: $e')),
      );
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
            "Available Orders",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 24),

          Expanded(
            child: availableCommands.isNotEmpty
                ? _buildOrdersList()
                : _buildEmptyState(),
          ),

          SizedBox(height: 24),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WebDeliveriesListPage()),
              );
            },
            icon: Icon(Icons.assignment),
            label: Text('View My Deliveries'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors().green(),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
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
            onPressed: fetchAvailableCommands,
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
            "No orders available for delivery",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Check back later for new orders",
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

  Widget _buildOrdersList() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.5,
      ),
      itemCount: availableCommands.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(availableCommands[index]);
      },
    );
  }

  Widget _buildOrderCard(Command command) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${command.commandNumber}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors().black(),
                  ),
                ),
                Chip(
                  label: Text(
                    'Available',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.green,
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Delivery Address: ${command.arrivalPoint}',
              style: TextStyle(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Text(
              'Phone: ${command.clientPhoneNumber}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'Total: ${command.totalPrice.toStringAsFixed(2)} ${command.currency}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors().green(),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => assignDelivery(command.id),
                  child: Text('Assign to Me'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors().black(),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}