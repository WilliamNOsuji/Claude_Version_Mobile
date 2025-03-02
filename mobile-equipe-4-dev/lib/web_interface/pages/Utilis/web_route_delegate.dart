import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:mobilelapincouvert/pages/HomePage.dart';
import 'package:mobilelapincouvert/pages/paymentProcessPages/order_success_page.dart';
import 'package:mobilelapincouvert/services/stripe_web_service.dart';

class WebRouterDelegate extends RouterDelegate<RouteConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteConfiguration> {

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  String _currentLocation = '/';
  String _sessionId = '';

  WebRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    if (kIsWeb) {
      // Listen for location changes in the browser
      html.window.onPopState.listen((_) {
        _parseCurrentLocation();
        notifyListeners();
      });

      // Parse initial location
      _parseCurrentLocation();
    }
  }

  void _parseCurrentLocation() {
    try {
      // Get current hash fragment
      final fragment = html.window.location.hash;

      if (fragment.startsWith('#')) {
        String path = fragment.substring(1);

        // Extract path and query parameters
        if (path.contains('?')) {
          final parts = path.split('?');
          _currentLocation = parts[0];

          // Parse query parameters
          final queryString = parts[1];
          final queryParams = Uri.splitQueryString(queryString);
          _sessionId = queryParams['session_id'] ?? '';
        } else {
          _currentLocation = path;
          _sessionId = '';
        }
      } else {
        _currentLocation = '/';
        _sessionId = '';
      }

      print('Current location: $_currentLocation, Session ID: $_sessionId');
    } catch (e) {
      print('Error parsing location: $e');
      _currentLocation = '/';
      _sessionId = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        // Home page is always in the stack
        MaterialPage(
          key: ValueKey('HomePage'),
          child: HomePage(),
        ),

        // Add other pages based on the current location
        if (_currentLocation == '/order-success')
          MaterialPage(
            key: ValueKey('OrderSuccessPage'),
            child: OrderSuccessPage(sessionId: _sessionId),
          ),

        // Add more routes as needed
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // Handle pop navigation
        if (_currentLocation != '/') {
          _currentLocation = '/';
          _sessionId = '';
          notifyListeners();
        }

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RouteConfiguration configuration) async {
    _currentLocation = configuration.location;
    _sessionId = configuration.sessionId;
    notifyListeners();
  }
}

class RouteConfiguration {
  final String location;
  final String sessionId;

  RouteConfiguration({
    required this.location,
    this.sessionId = '',
  });
}

// Information parser for the router
class WebRouteInformationParser extends RouteInformationParser<RouteConfiguration> {
  @override
  Future<RouteConfiguration> parseRouteInformation(RouteInformation routeInformation) async {
    final location = routeInformation.uri.path;

    // Check if it has session_id parameter
    String sessionId = '';
    if (routeInformation.uri.queryParameters.containsKey('session_id')) {
      sessionId = routeInformation.uri.queryParameters['session_id']!;
    }

    return RouteConfiguration(
      location: location,
      sessionId: sessionId,
    );
  }

  @override
  RouteInformation? restoreRouteInformation(RouteConfiguration configuration) {
    if (configuration.sessionId.isNotEmpty) {
      return RouteInformation(
        uri: Uri.parse('${configuration.location}?session_id=${configuration.sessionId}'),
      );
    }

    return RouteInformation(
      uri: Uri.parse(configuration.location),
    );
  }
}