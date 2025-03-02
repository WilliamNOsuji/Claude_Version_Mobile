import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/models/chat_message.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/services/chat_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mobilelapincouvert/web_interface/pages/web_chat_overlay.dart';

/// A widget that wraps the app for web-specific chat implementation
class WebChatManager extends StatefulWidget {
  final Widget child;

  const WebChatManager({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<WebChatManager> createState() => _WebChatManagerState();
}

class _WebChatManagerState extends State<WebChatManager> {
  final ChatService _chatService = ChatService();
  List<Map<String, dynamic>> _activeChats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActiveChats();
  }

  Future<void> _loadActiveChats() async {
    setState(() => _isLoading = true);

    try {
      if (ApiService.clientId != null) {
        // Listen to active chats stream for real-time updates
        _chatService.getUserActiveChatsStream(ApiService.clientId).listen((chats) async {
          List<Map<String, dynamic>> chatData = [];

          for (var chat in chats) {
            // Determine if current user is delivery man or client
            final bool isDeliveryMan = chat.deliveryManId == ApiService.clientId;
            final int otherUserId = isDeliveryMan ? chat.clientId : chat.deliveryManId;

            // Get user details - in a real app, you would fetch user info
            String otherUserName = isDeliveryMan ? "Client" : "Delivery Person";

            // Try to get command details
            try {
              final command = await ApiService().getCommandById(chat.commandId);
              if (command != null) {
                otherUserName = isDeliveryMan
                    ? "Client #${command.clientId}"
                    : "Delivery #${command.deliveryManId}";
              }
            } catch (e) {
              print('Error loading command details: $e');
            }

            chatData.add({
              'commandId': chat.commandId,
              'otherUserId': otherUserId,
              'otherUserName': otherUserName,
              'isDeliveryMan': isDeliveryMan,
            });
          }

          if (mounted) {
            setState(() {
              _activeChats = chatData;
              _isLoading = false;
            });
          }
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error loading active chats: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        // Show loading indicator while fetching chats
        if (_isLoading && kIsWeb && ApiService.clientId != null)
          Positioned(
            right: 20,
            bottom: 20,
            child: CircularProgressIndicator(),
          ),

        // Add all active chat overlays
        if (!_isLoading && kIsWeb)
          ..._buildChatOverlays(),
      ],
    );
  }

  List<Widget> _buildChatOverlays() {
    List<Widget> overlays = [];

    // Calculate positioning for multiple chat windows
    double rightOffset = 20.0;

    for (int i = 0; i < _activeChats.length; i++) {
      final chat = _activeChats[i];

      overlays.add(
        Positioned(
          right: rightOffset + (i * 80), // Offset each chat window
          bottom: 20,
          child: WebChatOverlay(
            commandId: chat['commandId'],
            otherUserId: chat['otherUserId'],
            otherUserName: chat['otherUserName'],
            isDeliveryMan: chat['isDeliveryMan'],
          ),
        ),
      );
    }

    return overlays;
  }
}