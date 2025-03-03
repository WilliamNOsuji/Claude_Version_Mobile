import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/models/chat_message.dart';
import 'package:mobilelapincouvert/services/chat_service.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'package:intl/intl.dart';

class WebChatPage extends StatefulWidget {
  final int commandId;
  final int otherUserId;
  final String otherUserName;
  final bool isDeliveryMan;
  final int? clientId; // Explicit client ID if available
  final int? deliveryManId; // Explicit delivery person ID if available

  const WebChatPage({
    Key? key,
    required this.commandId,
    required this.otherUserId,
    required this.otherUserName,
    required this.isDeliveryMan,
    this.clientId, // Optional parameter
    this.deliveryManId, // Optional parameter
  }) : super(key: key);

  @override
  _WebChatPageState createState() => _WebChatPageState();
}

class _WebChatPageState extends State<WebChatPage> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late int _currentUserId;
  late SenderType _senderType;
  bool _isChatActive = true;
  bool _isInitializing = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  // Updated _initializeChat method in WebChatPage class

  // Updated final initialization method for WebChatPage

  // Updated _initializeChat method in WebChatPage class

  Future<void> _initializeChat() async {
    try {
      setState(() => _isInitializing = true);

      // Make sure currentUserId is always an integer
      // This is the issue - sometimes ApiService.clientId can be null for clients
      if (ApiService.clientId == null) {
        print("Warning: ApiService.clientId is null, attempting to recover...");

        // Try to extract the client ID from the arguments if it wasn't set in ApiService
        // For a client, the currentUserId should be their own ID (otherUserId when isDeliveryMan is false)
        _currentUserId = widget.isDeliveryMan ? ApiService.clientId ?? 0 : widget.otherUserId;
      } else {
        _currentUserId = ApiService.clientId;
      }

      // Double check we have a valid ID
      if (_currentUserId <= 0) {
        throw Exception("Invalid user ID. Please log in again.");
      }

      // Set sender type based on role
      _senderType = widget.isDeliveryMan ? SenderType.deliveryMan : SenderType.client;

      // Check if chat is active
      bool isActive = await _chatService.isChatActive(widget.commandId);

      if (!isActive) {
        // For chat initialization, determine client and delivery person IDs
        final int clientId = widget.isDeliveryMan ? widget.otherUserId : _currentUserId;
        final int deliveryManId = widget.isDeliveryMan ? _currentUserId : widget.otherUserId;

        print("Initializing chat with: commandId=${widget.commandId}, clientId=$clientId, deliveryManId=$deliveryManId");

        // Initialize the chat if it's not active
        await _chatService.initializeChat(
          widget.commandId,
          clientId,
          deliveryManId,
        );
      }

      // Update state
      setState(() {
        _isChatActive = true;
        _isInitializing = false;
      });

      // Scroll to bottom after messages load
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      print('Error initializing chat: $e');
      setState(() {
        _isInitializing = false;
        _errorMessage = 'Failed to initialize chat: $e';
      });
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _chatService.sendTextMessage(
      commandId: widget.commandId,
      senderId: _currentUserId.toString(),
      senderType: _senderType,
      text: text,
    );

    _messageController.clear();
    _scrollToBottom();
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
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Chat with ${widget.otherUserName}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  'Order #${widget.commandId}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            tooltip: 'Chat Info',
            onPressed: _showChatInfo,
          ),
        ],
      ),
      body: _isInitializing
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? _buildErrorView()
          : _buildChatView(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Error',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _initializeChat,
            child: Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors().green(),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatView() {
    return Column(
      children: [
        // Chat messages
        Expanded(
          child: StreamBuilder<List<ChatMessage>>(
            stream: _chatService.getMessagesStream(widget.commandId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 48),
                        SizedBox(height: 16),
                        Text(
                          'Error loading messages',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No messages yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Start the conversation!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Sort messages by timestamp
              final messages = snapshot.data!;

              // Scroll to bottom after build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom();
              });

              return ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];

                  // Mark message as read if it's not from current user
                  if (message.senderId != _currentUserId.toString() && !message.isRead) {
                    _chatService.markAsRead(
                      commandId: widget.commandId,
                      messageId: message.id,
                    );
                  }

                  // Handle system messages differently
                  if (message.senderId == "system") {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          message.content,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    );
                  }

                  return _buildMessageBubble(message);
                },
              );
            },
          ),
        ),

        // Message input
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Emoji button
              IconButton(
                icon: Icon(Icons.emoji_emotions_outlined),
                color: AppColors().gray(),
                onPressed: () {
                  // Show emoji picker
                  // This would need a more complex implementation for web
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Emoji picker not yet implemented for web')),
                  );
                },
              ),
              // Text field
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              SizedBox(width: 8),
              // Send button
              Container(
                decoration: BoxDecoration(
                  color: AppColors().green(),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.white,
                  onPressed: _sendMessage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final bool isMe = message.senderId == _currentUserId.toString();
    final messageTime = DateFormat('HH:mm').format(message.timestamp);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isMe ? AppColors().green() : Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Message content
              _buildMessageContent(message),

              // Timestamp
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    messageTime,
                    style: TextStyle(
                      fontSize: 10,
                      color: isMe ? Colors.white.withOpacity(0.7) : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent(ChatMessage message) {
    final bool isMe = message.senderId == _currentUserId.toString();

    switch (message.messageType) {
      case MessageType.text:
        return Text(
          message.content,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        );

      case MessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                message.content,
                fit: BoxFit.cover,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return child;
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    width: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 150,
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red),
                        SizedBox(height: 8),
                        Text('Failed to load image'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );

      case MessageType.emoji:
        return Text(
          message.content,
          style: TextStyle(fontSize: 40),
        );

      default:
        return Text(
          'Unsupported message type',
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
            fontStyle: FontStyle.italic,
          ),
        );
    }
  }

  void _showChatInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chat Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Order ID', '#${widget.commandId}'),
            _buildInfoRow(
                widget.isDeliveryMan ? 'Client ID' : 'Delivery Person ID',
                '#${widget.otherUserId}'
            ),
            _buildInfoRow(
                'You are',
                widget.isDeliveryMan ? 'Delivery Person' : 'Client'
            ),
            SizedBox(height: 16),
            Text(
              'Note: This chat will be terminated when the order is marked as delivered.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          if (widget.isDeliveryMan)
            TextButton(
              onPressed: () async {
                // Mark command as delivered
                Navigator.pop(context);

                // Show confirmation dialog
                bool confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Confirm Delivery'),
                    content: Text(
                        'Are you sure you want to mark this order as delivered? '
                            'This will end the chat session.'
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Confirm'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors().green(),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ) ?? false;

                if (confirm) {
                  try {
                    await ApiService().commandDelivered(widget.commandId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Order marked as delivered')),
                    );
                    Navigator.pop(context); // Close chat page
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to mark as delivered: $e')),
                    );
                  }
                }
              },
              child: Text('Mark as Delivered'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}