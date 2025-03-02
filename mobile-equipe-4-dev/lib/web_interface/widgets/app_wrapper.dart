// Main App Wrapper to handle platform differences
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../pages/web_chat_manager.dart';

class AppWrapper extends StatelessWidget {
  final Widget child;

  const AppWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Wrap with Directionality to ensure RTL/LTR context is available
    return Directionality(
      textDirection: TextDirection.ltr, // Default to left-to-right
      child: kIsWeb
          ? WebChatManager(child: child)
          : child,
    );
  }
}