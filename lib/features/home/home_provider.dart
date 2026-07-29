import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  String _selectedRoute = 'B2 • Bandung - Jakarta';
  bool _isPergi = true;

  String _animMode = 'Scroll Left';
  double _speed = 50;
  double _brightness = 80;
  double _fontSize = 16;

  String get selectedRoute => _selectedRoute;
  bool get isPergi => _isPergi;
  String get animMode => _animMode;
  double get speed => _speed;
  double get brightness => _brightness;
  double get fontSize => _fontSize;

  void setRoute(String route) {
    _selectedRoute = route;
    notifyListeners();
  }

  void setDirection(bool isPergi) {
    _isPergi = isPergi;
    notifyListeners();
  }

  void setAnimMode(String mode) {
    _animMode = mode;
    notifyListeners();
  }

  void setSpeed(double value) {
    _speed = value;
    notifyListeners();
  }

  void setBrightness(double value) {
    _brightness = value;
    notifyListeners();
  }

  void setFontSize(double value) {
    _fontSize = value;
    notifyListeners();
  }

  void sendPayloadToDevice(BuildContext context) {
    final payload = {
      "route": _selectedRoute,
      "direction": _isPergi ? "Pergi" : "Pulang",
      "animation": _animMode,
      "speed": _speed.toInt(),
      "brightness": _brightness.toInt(),
      "fontSize": _fontSize.toInt(),
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF22C55E),
        content: Text(
          'Payload Sent: $payload',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
