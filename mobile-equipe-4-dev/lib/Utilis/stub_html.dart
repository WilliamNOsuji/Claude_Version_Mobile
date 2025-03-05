// stub_html.dart
// This file provides stub implementations of web functionality for non-web platforms

// Create a stub WindowLocation class
class WindowLocation {
  String get href => '';
  String get origin => '';
  String get search => '';
  String get hash => '';

  // No-op implementation for setting href
  set href(String url) {}
}

// Create a stub Window class
class Window {
  // Return a WindowLocation object, not a string
  WindowLocation get location => WindowLocation();

  // Implement the open method
  void open(String url, String target) {
    // Do nothing on mobile
    print('Window.open() is not available on mobile platforms');
  }
}

// Expose a stub window object
final Window window = Window();