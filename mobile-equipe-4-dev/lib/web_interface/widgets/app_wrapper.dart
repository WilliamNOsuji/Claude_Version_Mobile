// Main App Wrapper to handle platform differences
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../pages/web_chat_manager.dart';

class AppWrapper extends StatelessWidget {
  final Widget child;

  const AppWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // For web platforms, use WebChatManager to enable web chat experience
    if (kIsWeb) {
      return WebChatManager(child: child);
    }
    // For mobile platforms, just return the child directly
    return child;
  }
}