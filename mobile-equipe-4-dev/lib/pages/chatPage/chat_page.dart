// lib/pages/chat/chat_page.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/models/chat_message.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/services/auth_service.dart';
import 'package:mobilelapincouvert/services/Chat/chat_service.dart';
import 'package:mobilelapincouvert/models/colors.dart';

import '../../widgets/widgetsChat/chat_input.dart';
import '../../widgets/widgetsChat/chat_message_item.dart';

class ChatPage extends StatefulWidget {
  final int commandId;
  final int otherUserId; // ID of the client or delivery person
  final String otherUserName; // Name of the client or delivery person
  final bool isDeliveryMan; // Whether current user is delivery man

  const ChatPage({
    Key? key,
    required this.commandId,
    required this.otherUserId,
    required this.otherUserName,
    required this.isDeliveryMan,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();
  final ScrollController _scrollController = ScrollController();
  late int _currentUserId;
  late SenderType _senderType;

  @override
  void initState() {
    super.initState();
    _setupChat();
  }

  Future<void> _setupChat() async {
    _currentUserId = ApiService.clientId;
    _senderType = widget.isDeliveryMan ? SenderType.deliveryMan : SenderType.client;
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors().green(),
              child: Text(
                widget.otherUserName.isNotEmpty
                    ? widget.otherUserName[0].toUpperCase()
                    : '?',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.otherUserName,
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  widget.isDeliveryMan ? 'Client' : 'Livreur',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              // Show dialog with delivery details
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Détails de la commande'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Commande #${widget.commandId}'),
                      SizedBox(height: 8),
                      // Add more delivery details as needed
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Fermer'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _chatService.getMessagesStream(widget.commandId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erreur: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'Aucun message. Commencez la conversation!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final messages = snapshot.data!;

                // Scroll to bottom after build
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ChatMessageItem(
                      message: message,
                      currentUserId: _currentUserId.toString(),
                      onReact: (reaction) {
                        _chatService.addReaction(
                          commandId: widget.commandId,
                          messageId: message.id,
                          userId: _currentUserId.toString(),
                          reaction: reaction,
                        );
                      },
                      onRemoveReaction: () {
                        _chatService.removeReaction(
                          commandId: widget.commandId,
                          messageId: message.id,
                          userId: _currentUserId.toString(),
                        );
                      },
                      onMarkAsRead: () {
                        _chatService.markAsRead(
                          commandId: widget.commandId,
                          messageId: message.id,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          // Chat input
          ChatInput(
            onSendText: (text) {
              _chatService.sendTextMessage(
                commandId: widget.commandId,
                senderId: _currentUserId.toString(),
                senderType: _senderType,
                text: text,
              );
            },
            onSendEmoji: (emoji) {
              _chatService.sendEmojiMessage(
                commandId: widget.commandId,
                senderId: _currentUserId.toString(),
                senderType: _senderType,
                emoji: emoji,
              );
            },
            onSendImage: (File imageFile) {
              _chatService.sendImageMessage(
                commandId: widget.commandId,
                senderId: _currentUserId.toString(),
                senderType: _senderType,
                imageFile: imageFile,
              );
            },
          ),
        ],
      ),
    );
  }
}

