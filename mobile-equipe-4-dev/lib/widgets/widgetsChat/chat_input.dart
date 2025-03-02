// lib/widgets/widgetsChat/chat_input.dart
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'dart:io';
import 'dart:math' as math;

class ChatInput extends StatefulWidget {
  final Function(String) onSendText;
  final Function(String) onSendEmoji;
  final Function(File) onSendImage;

  const ChatInput({
    Key? key,
    required this.onSendText,
    required this.onSendEmoji,
    required this.onSendImage,
  }) : super(key: key);

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showEmojiPicker = false;
  bool _isComposing = false;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChange);

    // Initialize animation controller for the send button
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  void _onTextChanged() {
    setState(() {
      _isComposing = _controller.text.trim().isNotEmpty;
    });

    if (_isComposing && !_animController.isCompleted) {
      _animController.forward();
    } else if (!_isComposing && _animController.isCompleted) {
      _animController.reverse();
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && _showEmojiPicker) {
      setState(() {
        _showEmojiPicker = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input Bar
        Container(
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Camera/Gallery button with popup menu
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: AppColors().gray()),
                onPressed: _showAttachmentOptions,
              ),

              // Text input field
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  ),
                  maxLines: null, // Allow multiline input
                  textInputAction: TextInputAction.newline,
                ),
              ),

              // Emoji button
              IconButton(
                icon: Icon(
                  _showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions,
                  color: AppColors().gray(),
                ),
                onPressed: () {
                  setState(() {
                    _showEmojiPicker = !_showEmojiPicker;
                  });
                  // Hide keyboard when showing emoji picker
                  if (_showEmojiPicker) {
                    FocusScope.of(context).unfocus();
                  } else {
                    FocusScope.of(context).requestFocus(_focusNode);
                  }
                },
              ),

              // Animated Send button
              AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animController.value * math.pi * 2,
                    child: AnimatedOpacity(
                      opacity: _isComposing ? 1.0 : 0.5,
                      duration: Duration(milliseconds: 200),
                      child: IconButton(
                        icon: Icon(Icons.send, color: AppColors().green()),
                        onPressed: _isComposing ? _handleSubmitted : null,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // Emoji Picker
        // Emoji Picker
        if (_showEmojiPicker)
          SizedBox(
            height: 250,
            child: EmojiPicker(
              textEditingController: _controller, // Pass controller directly
              onEmojiSelected: (emoji, category) {
                // If text field is empty, send as emoji message
                if (_controller.text.isEmpty) {
                  widget.onSendEmoji(emoji.toString());
                }
                // The text controller will be updated automatically
              },
            ),
          ),
      ],
    );
  }

  void _handleSubmitted() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendText(text);
      _controller.clear();
      setState(() {
        _isComposing = false;
      });
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 150,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAttachmentOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  color: Colors.pink,
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                _buildAttachmentOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  color: Colors.purple,
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  void _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        widget.onSendImage(File(pickedFile.path));
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image')),
      );
    }
  }
}