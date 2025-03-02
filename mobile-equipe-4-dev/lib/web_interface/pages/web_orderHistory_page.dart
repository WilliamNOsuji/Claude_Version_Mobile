import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobilelapincouvert/dto/payment.dart';
import 'package:mobilelapincouvert/pages/clientOrderPages/commandDetailsPage.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/web_interface/widgets/custom_app_bar.dart';

class WebOrderHistoryPage extends StatefulWidget {
  const WebOrderHistoryPage({super.key});

  @override
  _WebOrderHistoryPageState createState() => _WebOrderHistoryPageState();
}

class _WebOrderHistoryPageState extends State<WebOrderHistoryPage> {
  List<Command> listCommandes = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchCommands();
  }

  void fetchCommands() async {
    try {
      setState(() => _isLoading = true);
      listCommandes = await ApiService().getClientCommads();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching commands: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load orders. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WebCustomAppBar(),
      backgroundColor: Colors.white,
      body: _isLoading
          ? _buildLoadingView()
          : _errorMessage.isNotEmpty
          ? _buildErrorView()
          : _buildOrdersList(),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: CircularProgressIndicator(),
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
            _errorMessage,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: fetchCommands,
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "My Orders",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 24),

          if (listCommandes.isEmpty)
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
                      "You don't have any orders yet",
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
                itemCount: listCommandes.length,
                itemBuilder: (context, index) {
                  return _buildOrderCard(listCommandes[index]);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Command command) {
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
                  'Order #${command.commandNumber}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(command),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red.shade800, size: 20),
                SizedBox(width: 8),
                Text(
                  'Delivery Address: ${command.arrivalPoint}',
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
                  'Phone: ${command.clientPhoneNumber}',
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
                  'Total: ${command.totalPrice.toStringAsFixed(2)} ${command.currency}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (command.deliveryManId != null) ...[
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.delivery_dining, color: Colors.purple.shade800, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Delivery Person ID: ${command.deliveryManId}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(Command command) {
    Color chipColor;
    String statusText;

    if (command.isDelivered) {
      chipColor = Colors.green;
      statusText = 'Delivered';
    } else if (command.isInProgress) {
      chipColor = Colors.orange;
      statusText = 'In Progress';
    } else if (command.deliveryManId != null) {
      chipColor = Colors.blue;
      statusText = 'Assigned';
    } else {
      chipColor = Colors.grey;
      statusText = 'Pending';
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