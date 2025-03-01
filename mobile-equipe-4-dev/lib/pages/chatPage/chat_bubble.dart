// lib/widgets/chat/chat_bubble.dart
import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'package:mobilelapincouvert/services/Chat/chat_service.dart';

import 'chat_page.dart';

class ChatBubble extends StatefulWidget {
  final int commandId;
  final int otherUserId;
  final String otherUserName;
  final bool isDeliveryMan;

  const ChatBubble({
    Key? key,
    required this.commandId,
    required this.otherUserId,
    required this.otherUserName,
    required this.isDeliveryMan,
  }) : super(key: key);

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final ChatService _chatService = ChatService();
  int _unreadCount = 0;
  bool _isDragging = false;
  Offset _position = Offset(20, 100); // Initial position
  late Size _screenSize;

  @override
  void initState() {
    super.initState();
    _updateUnreadCount();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.of(context).size;
  }

  Future<void> _updateUnreadCount() async {
    final count = await _chatService.getUnreadMessagesCount(
      commandId: widget.commandId,
      userId: widget.isDeliveryMan
          ? widget.otherUserId.toString()
          : widget.otherUserId.toString(),
    );

    if (mounted) {
      setState(() {
        _unreadCount = count;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanStart: (details) {
          setState(() {
            _isDragging = true;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            _position = Offset(
              _position.dx + details.delta.dx,
              _position.dy + details.delta.dy,
            );

            // Keep bubble within screen bounds
            if (_position.dx < 0) _position = Offset(0, _position.dy);
            if (_position.dy < 0) _position = Offset(_position.dx, 0);
            if (_position.dx > _screenSize.width - 60) {
              _position = Offset(_screenSize.width - 60, _position.dy);
            }
            if (_position.dy > _screenSize.height - 60) {
              _position = Offset(_position.dx, _screenSize.height - 60);
            }
          });
        },
        onPanEnd: (details) {
          setState(() {
            _isDragging = false;
          });
        },
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                commandId: widget.commandId,
                otherUserId: widget.otherUserId,
                otherUserName: widget.otherUserName,
                isDeliveryMan: widget.isDeliveryMan,
              ),
            ),
          );
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: _isDragging ? AppColors().green().withOpacity(0.8) : AppColors().green(),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.chat,
                color: Colors.white,
                size: 30,
              ),
              if (_unreadCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      _unreadCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}