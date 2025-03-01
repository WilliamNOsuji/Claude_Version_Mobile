// lib/widgets/chat/chat_message_item.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobilelapincouvert/models/chat_message.dart';
import 'package:mobilelapincouvert/models/colors.dart';

class ChatMessageItem extends StatelessWidget {
  final ChatMessage message;
  final String currentUserId;
  final Function(String reaction) onReact;
  final Function() onRemoveReaction;
  final Function() onMarkAsRead;

  const ChatMessageItem({
    Key? key,
    required this.message,
    required this.currentUserId,
    required this.onReact,
    required this.onRemoveReaction,
    required this.onMarkAsRead,
  }) : super(key: key);

  bool get isCurrentUser => message.senderId == currentUserId;

  @override
  Widget build(BuildContext context) {
    // Mark message as read if it's not from current user and not read yet
    if (!isCurrentUser && !message.isRead) {
      onMarkAsRead();
    }

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Card(
          color: isCurrentUser ? AppColors().green() : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 1,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: _buildMessageContent(context),
              ),
              // Timestamp at the bottom-right
              Positioned(
                right: 8,
                bottom: 4,
                child: Text(
                  DateFormat('HH:mm').format(message.timestamp),
                  style: TextStyle(
                    fontSize: 10,
                    color: isCurrentUser ? Colors.white70 : Colors.grey[500],
                  ),
                ),
              ),
              // Reactions overlay
              if (message.reactions.isNotEmpty)
                Positioned(
                  bottom: -8,
                  right: isCurrentUser ? null : 8,
                  left: isCurrentUser ? 8 : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 3,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: message.reactions.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(entry.value, style: TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    switch (message.messageType) {
      case MessageType.text:
        return GestureDetector(
          onLongPress: _showReactionMenu,
          child: Text(
            message.content,
            style: TextStyle(
              color: isCurrentUser ? Colors.white : Colors.black87,
              fontSize: 16,
            ),
          ),
        );

      case MessageType.image:
        return GestureDetector(
          onLongPress: _showReactionMenu,
          onTap: () => _showFullScreenImage(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  message.content,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.error, color: Colors.red),
                    );
                  },
                ),
              ),
            ],
          ),
        );

      case MessageType.emoji:
        return GestureDetector(
          onLongPress: _showReactionMenu,
          child: Text(
            message.content,
            style: TextStyle(fontSize: 40),
          ),
        );

      default:
        return Text('Unsupported message type');
    }
  }

  void _showReactionMenu() {
    final BuildContext? context =
    (message.messageType == MessageType.image)
        ? null
        : null; // Get context from builder

    if (context == null) return;

    // Check if current user already has a reaction
    final currentUserReaction = message.reactions[currentUserId];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 120,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'React to message:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildReactionButton('👍', context),
                  _buildReactionButton('❤️', context),
                  _buildReactionButton('😂', context),
                  _buildReactionButton('😮', context),
                  _buildReactionButton('😢', context),
                  if (currentUserReaction != null)
                    InkWell(
                      onTap: () {
                        onRemoveReaction();
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            Text('Remove', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReactionButton(String emoji, BuildContext context) {
    return InkWell(
      onTap: () {
        onReact(emoji);
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          emoji,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 3,
              child: Image.network(
                message.content,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

