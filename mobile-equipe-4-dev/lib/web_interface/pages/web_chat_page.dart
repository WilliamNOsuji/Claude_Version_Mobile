import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/models/chat_message.dart';
import 'package:mobilelapincouvert/services/chat_service.dart';
import 'package:mobilelapincouvert/services/api_service.dart';

class WebChatPage extends StatefulWidget {
  final int commandId;
  final int otherUserId;
  final String otherUserName;
  final bool isDeliveryMan;

  const WebChatPage({
    Key? key,
    required this.commandId,
    required this.otherUserId,
    required this.otherUserName,
    required this.isDeliveryMan,
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

  @override
  void initState() {
    super.initState();
    _setupChat();
  }

  void _setupChat() {
    _currentUserId = ApiService.clientId;
    _senderType = widget.isDeliveryMan ? SenderType.deliveryMan : SenderType.client;

    // Verify chat is initialized
    _chatService.initializeChat(
      widget.commandId,
      widget.isDeliveryMan ? widget.otherUserId : _currentUserId,
      widget.isDeliveryMan ? _currentUserId : widget.otherUserId,
    );
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.otherUserName}'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _showChatDetails,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _chatService.getMessagesStream(widget.commandId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == _currentUserId.toString();

                    return _buildMessageBubble(message, isMe);
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.content,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _showChatDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chat Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Command ID: ${widget.commandId}'),
            Text('Other User: ${widget.otherUserName}'),
            Text('User Role: ${widget.isDeliveryMan ? 'Delivery Man' : 'Client'}'),
          ],
        ),
        actions: [
          if (widget.isDeliveryMan)
            TextButton(
              onPressed: () async {
                // Mark command as delivered
                await ApiService().commandDelivered(widget.commandId);
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close chat page
              },
              child: Text('Mark Delivery Complete'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}