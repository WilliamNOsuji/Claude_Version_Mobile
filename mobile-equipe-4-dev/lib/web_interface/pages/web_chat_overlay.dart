import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobilelapincouvert/models/chat_message.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:mobilelapincouvert/services/chat_service.dart';

class WebChatOverlay extends StatefulWidget {
  final int commandId;
  final int otherUserId;
  final String otherUserName;
  final bool isDeliveryMan;

  const WebChatOverlay({
    Key? key,
    required this.commandId,
    required this.otherUserId,
    required this.otherUserName,
    required this.isDeliveryMan,
  }) : super(key: key);

  @override
  State<WebChatOverlay> createState() => _WebChatOverlayState();
}

class _WebChatOverlayState extends State<WebChatOverlay> with SingleTickerProviderStateMixin {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _animationController;
  late Animation<double> _heightAnimation;

  bool _isExpanded = false;
  bool _isLoading = true;
  int _unreadCount = 0;
  late int _currentUserId;
  late SenderType _senderType;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _heightAnimation = Tween<double>(
      begin: 60, // Height of collapsed chat header
      end: 400, // Height of expanded chat window
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _setupChat();
    _updateUnreadCount();
  }

  Future<void> _setupChat() async {
    setState(() => _isLoading = true);

    // Set current user ID
    _currentUserId = ApiService.clientId;
    _senderType = widget.isDeliveryMan ? SenderType.deliveryMan : SenderType.client;

    // Ensure chat is initialized
    try {
      final clientId = widget.isDeliveryMan ? widget.otherUserId : _currentUserId;
      final deliveryManId = widget.isDeliveryMan ? _currentUserId : widget.otherUserId;

      await _chatService.initializeChat(
          widget.commandId,
          clientId,
          deliveryManId
      );
    } catch (e) {
      print('Error initializing chat: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _updateUnreadCount() async {
    try {
      final count = await _chatService.getUnreadMessagesCount(
        commandId: widget.commandId,
        userId: _currentUserId.toString(),
      );

      if (mounted) {
        setState(() {
          _unreadCount = count;
        });
      }
    } catch (e) {
      print('Error getting unread count: $e');
    }
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
        // Mark messages as read when expanding
        _updateUnreadCount();
      } else {
        _animationController.reverse();
      }
    });
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

    // Scroll to bottom after sending message
    Future.delayed(Duration(milliseconds: 300), () {
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
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: _heightAnimation,
        builder: (context, child) {
          return Container(
            width: 320,
            height: _heightAnimation.value,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Chat header
                GestureDetector(
                  onTap: _toggleExpanded,
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors().green(),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: _isExpanded ? Radius.zero : Radius.circular(12),
                        bottomRight: _isExpanded ? Radius.zero : Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 16,
                          child: Text(
                            widget.otherUserName.isNotEmpty
                                ? widget.otherUserName[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: AppColors().green(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.otherUserName,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (_unreadCount > 0 && !_isExpanded)
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              _unreadCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        SizedBox(width: 8),
                        Icon(
                          _isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),

                // Display chat content only when expanded
                if (_isExpanded) _buildExpandedContent()
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Expanded(
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Messages section
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _chatService.getMessagesStream(widget.commandId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final messages = snapshot.data!;

                // Auto-scroll to bottom on new messages
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == _currentUserId.toString();

                    // Mark as read
                    if (!isMe && !message.isRead) {
                      _chatService.markAsRead(
                        commandId: widget.commandId,
                        messageId: message.id,
                      );
                    }

                    return _buildMessageItem(message, isMe);
                  },
                );
              },
            ),
          ),

          // Input section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors().green(),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message, bool isMe) {
    // System message
    if (message.senderId == 'system') {
      return Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 6),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message.content,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    // User message
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: isMe ? 50 : 0,
          right: isMe ? 0 : 50,
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white70 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent(ChatMessage message) {
    switch (message.messageType) {
      case MessageType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            message.content,
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[300],
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
                height: 150,
                width: double.infinity,
                color: Colors.grey[300],
                child: Icon(Icons.error, color: Colors.red),
              );
            },
          ),
        );

      case MessageType.emoji:
        return Text(
          message.content,
          style: TextStyle(fontSize: 30),
        );

      case MessageType.text:
      default:
        return Text(
          message.content,
          style: TextStyle(
            color: message.senderId == _currentUserId.toString() ? Colors.white : Colors.black87,
          ),
        );
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(time.year, time.month, time.day);

    if (messageDay == today) {
      // Today, show only time
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (messageDay == today.subtract(Duration(days: 1))) {
      // Yesterday
      return 'Yesterday ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      // Other days, show date and time
      return '${time.day}/${time.month} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}