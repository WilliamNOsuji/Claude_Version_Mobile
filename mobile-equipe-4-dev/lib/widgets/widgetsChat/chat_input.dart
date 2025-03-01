// lib/widgets/chat/chat_input.dart
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobilelapincouvert/models/colors.dart';
import 'dart:io';

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

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  bool _showEmojiPicker = false;
  bool _isComposing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              // Camera button
              IconButton(
                icon: Icon(Icons.camera_alt, color: AppColors().gray()),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              // Gallery button
              IconButton(
                icon: Icon(Icons.photo, color: AppColors().gray()),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
              // Text input field
              Expanded(
                child: TextField(
                  controller: _controller,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (text) {
                    setState(() {
                      _isComposing = text.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
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
                  }
                },
              ),
              // Send button
              IconButton(
                icon: Icon(Icons.send, color: AppColors().green()),
                onPressed: _isComposing
                    ? () {
                  widget.onSendText(_controller.text.trim());
                  _controller.clear();
                  setState(() {
                    _isComposing = false;
                  });
                }
                    : null,
              ),
            ],
          ),
        ),
        // Emoji picker
        _showEmojiPicker
            ? SizedBox(
          height: 250,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              // If text field is empty, send as emoji message
              if (_controller.text.isEmpty) {
                widget.onSendEmoji(emoji.emoji);
              } else {
                // Otherwise append to text field
                _controller.text = _controller.text + emoji.emoji;
                _controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: _controller.text.length),
                );
                setState(() {
                  _isComposing = true;
                });
              }
            },
          ),
        )
            : SizedBox.shrink(),
      ],
    );
  }

  void _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      widget.onSendImage(File(pickedFile.path));
    }
  }
}