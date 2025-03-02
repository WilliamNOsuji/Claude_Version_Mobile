import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

class WebUrlUtils {
  /// Gets all query parameters from the current URL
  static Map<String, String> getQueryParameters() {
    if (!kIsWeb) return {};

    final uri = Uri.parse(html.window.location.href);
    return uri.queryParameters;
  }

  /// Gets a specific query parameter from the current URL
  static String? getQueryParameter(String paramName) {
    if (!kIsWeb) return null;

    final uri = Uri.parse(html.window.location.href);
    return uri.queryParameters[paramName];
  }

  /// Gets the session ID from the URL (specifically for Stripe redirects)
  static String? getStripeSessionId() {
    return getQueryParameter('session_id');
  }

  /// Opens a URL in a new tab or the current tab
  static void openUrl(String url, {String target = '_blank'}) {
    if (!kIsWeb) return;

    html.window.open(url, target);
  }

  /// Redirects to a URL in the current tab
  static void redirectTo(String url) {
    if (!kIsWeb) return;

    html.window.location.href = url;
  }
}