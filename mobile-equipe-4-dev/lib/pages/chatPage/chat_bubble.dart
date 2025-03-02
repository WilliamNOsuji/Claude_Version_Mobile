// lib/pages/chatPage/chat_bubble.dart
import 'package:flutter/material.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'package:mobilelapincouvert/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/chat_service.dart';
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

class _ChatBubbleState extends State<ChatBubble> with SingleTickerProviderStateMixin {
  final ChatService _chatService = ChatService();
  int _unreadCount = 0;
  bool _isDragging = false;
  Offset _position = Offset(20, 100); // Initial position
  late Size _screenSize;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // Setup animation
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _loadStoredPosition();
    _updateUnreadCount();

    // Set up a timer to refresh unread count periodically
    Future.delayed(Duration(seconds: 10), () {
      if (mounted) {
        _updateUnreadCount();
      }
    });
  }

  Future<void> _loadStoredPosition() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final double? x = prefs.getDouble('chat_bubble_${widget.commandId}_x');
      final double? y = prefs.getDouble('chat_bubble_${widget.commandId}_y');

      if (x != null && y != null) {
        setState(() {
          _position = Offset(x, y);
        });
      }

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error loading bubble position: $e');
      setState(() {
        _isInitialized = true;
      });
    }
  }

  Future<void> _savePosition() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('chat_bubble_${widget.commandId}_x', _position.dx);
      await prefs.setDouble('chat_bubble_${widget.commandId}_y', _position.dy);
    } catch (e) {
      print('Error saving bubble position: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenSize = MediaQuery.of(context).size;
    // Ensure bubble stays within screen bounds at startup
    if (_isInitialized) {
      _keepInBounds();
    }
  }

  void _keepInBounds() {
    setState(() {
      if (_position.dx < 0) _position = Offset(0, _position.dy);
      if (_position.dy < 0) _position = Offset(_position.dx, 0);
      if (_position.dx > _screenSize.width - 60) {
        _position = Offset(_screenSize.width - 60, _position.dy);
      }
      if (_position.dy > _screenSize.height - 60) {
        _position = Offset(_position.dx, _screenSize.height - 60);
      }
    });
  }

  Future<void> _updateUnreadCount() async {
    if (!mounted) return;

    try {
      final count = await _chatService.getUnreadMessagesCount(
        commandId: widget.commandId,
        userId: ApiService.clientId.toString(),
      );

      if (mounted) {
        setState(() {
          _unreadCount = count;
        });

        // Animate if there are unread messages
        if (count > 0 && !_animationController.isAnimating) {
          _animationController.repeat(reverse: true);
        } else if (count == 0 && _animationController.isAnimating) {
          _animationController.stop();
          _animationController.reset();
        }
      }
    } catch (e) {
      print('Error updating unread count: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return SizedBox.shrink(); // Don't show until position is loaded
    }

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

            // Keep bubble within screen bounds while dragging
            _keepInBounds();
          });
        },
        onPanEnd: (details) {
          setState(() {
            _isDragging = false;
          });
          _savePosition();
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
          ).then((_) {
            // Refresh unread count when returning from chat
            _updateUnreadCount();
          });
        },
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _unreadCount > 0 ? _pulseAnimation.value : 1.0,
              child: child,
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
      ),
    );
  }
}