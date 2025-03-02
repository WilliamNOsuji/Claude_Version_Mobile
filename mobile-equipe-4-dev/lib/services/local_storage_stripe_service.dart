import 'package:shared_preferences/shared_preferences.dart';

/// A service for handling local storage operations
class LocalStorageService {
  static const String _sessionIdKey = 'stripe_session_id';

  /// Saves the Stripe session ID to local storage
  static Future<void> saveSessionId(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionIdKey, sessionId);
  }

  /// Retrieves the Stripe session ID from local storage
  static Future<String?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionIdKey);
  }

  /// Clears the stored session ID
  static Future<void> clearSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionIdKey);
  }
}