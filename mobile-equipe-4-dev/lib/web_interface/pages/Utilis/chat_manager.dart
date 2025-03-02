import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/dto/payment.dart';
import 'package:mobilelapincouvert/models/chat_message.dart';
import 'package:mobilelapincouvert/pages/chatPage/chat_bubble.dart';
import 'package:mobilelapincouvert/pages/chatPage/chat_page.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/services/chat_service.dart';

/// A utility class to manage chat functionality across platforms
class ChatManager {
  static final ChatService _chatService = ChatService();

  /// Add chat functionality to a delivery page
  /// This method returns the appropriate widget based on platform
  static Widget addChatToDeliveryPage(Widget originalPage, List<Command> commands) {
    // For web, the WebChatManager handles this
    if (kIsWeb) {
      return originalPage;
    }

    // For mobile, add chat bubbles manually
    return Stack(
      children: [
        originalPage,
        // Add chat bubbles for all in-progress deliveries
        ...commands
            .where((command) => command.isInProgress && !command.isDelivered)
            .map((command) => _buildChatBubbleForCommand(command))
            .toList(),
      ],
    );
  }

  /// Add chat functionality to a client order page
  /// This method returns the appropriate widget based on platform
  static Widget addChatToClientOrderPage(Widget originalPage, List<Command> commands) {
    // For web, the WebChatManager handles this
    if (kIsWeb) {
      return originalPage;
    }

    // For mobile, add chat bubbles manually
    return Stack(
      children: [
        originalPage,
        // Add chat bubbles for all in-progress deliveries
        ...commands
            .where((command) => command.isInProgress && !command.isDelivered)
            .map((command) => _buildChatBubbleForCommand(command))
            .toList(),
      ],
    );
  }

  /// Helper method to build a chat bubble for a specific command (mobile only)
  static Widget _buildChatBubbleForCommand(Command command) {
    return FutureBuilder<bool>(
      future: _chatService.isChatActive(command.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data == true) {

          // Determine if current user is delivery person
          final bool isDeliveryMan = command.deliveryManId == ApiService.clientId;
          final int otherUserId = isDeliveryMan ? command.clientId : command.deliveryManId ?? 0;
          final String otherUserName = isDeliveryMan ? "Client" : "Livreur";

          return ChatBubble(
            commandId: command.id,
            otherUserId: otherUserId,
            otherUserName: otherUserName,
            isDeliveryMan: isDeliveryMan,
          );
        }
        // Don't show bubble if chat isn't active
        return SizedBox.shrink();
      },
    );
  }

  /// Navigate to the chat page (mobile only)
  static void navigateToChatPage(BuildContext context, Command command) {
    if (kIsWeb) return; // No need to navigate on web

    final bool isDeliveryMan = command.deliveryManId == ApiService.clientId;
    final int otherUserId = isDeliveryMan ? command.clientId : command.deliveryManId ?? 0;
    final String otherUserName = isDeliveryMan ? "Client" : "Livreur";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          commandId: command.id,
          otherUserId: otherUserId,
          otherUserName: otherUserName,
          isDeliveryMan: isDeliveryMan,
        ),
      ),
    );
  }

  /// Initialize chat for a delivery
  static Future<void> initializeChatForDelivery(Command command) async {
    try {
      final chatService = ChatService();
      final clientId = command.clientId;
      final deliveryManId = command.deliveryManId ?? ApiService.clientId;

      await chatService.initializeChat(
        command.id,
        clientId,
        deliveryManId,
      );
    } catch (e) {
      print('Error initializing chat for delivery: $e');
    }
  }
}