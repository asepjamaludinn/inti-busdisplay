import 'package:flutter/material.dart';
import '../../core/models/route_model.dart';
import '../../core/services/api_service.dart';

class HomeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isConnected = false;
  String _serverIp = 'Menghubungkan...';

  List<RouteModel> _routes = [
    RouteModel(code: 'B1', origin: 'Bandung', destination: 'Garut'),
    RouteModel(code: 'B2', origin: 'Bandung', destination: 'Jakarta'),
  ];
  late RouteModel _selectedRoute;

  bool _isPergi = true;
  String _animMode = 'Scroll Left';
  double _speed = 50;
  double _brightness = 80;
  double _fontSize = 16;

  HomeProvider() {
    _selectedRoute = _routes.first;
    _serverIp = _apiService.currentIp;
    _initData();
  }

  bool get isConnected => _isConnected;
  String get serverIp => _serverIp;
  List<RouteModel> get routes => _routes;
  RouteModel get selectedRoute => _selectedRoute;
  bool get isPergi => _isPergi;
  String get animMode => _animMode;
  double get speed => _speed;
  double get brightness => _brightness;
  double get fontSize => _fontSize;

  Future<void> _initData() async {
    await refreshConnectionStatus();
    await loadRoutesFromServer();
  }

  Future<void> refreshConnectionStatus() async {
    _isConnected = await _apiService.checkConnection();
    notifyListeners();
  }

  Future<void> loadRoutesFromServer() async {
    final serverRoutes = await _apiService.fetchRoutes();
    if (serverRoutes.isNotEmpty) {
      _routes = serverRoutes;
      _selectedRoute = _routes.first;
      notifyListeners();
    }
  }

  void setRoute(RouteModel route) {
    _selectedRoute = route;
    notifyListeners();
  }

  Future<void> addRoute(String input) async {
    try {
      final parts = input.split('•');
      if (parts.length == 2) {
        final code = parts[0].trim();
        final cities = parts[1].split('-');
        if (cities.length >= 2) {
          final newRoute = RouteModel(
            code: code,
            origin: cities[0].trim(),
            destination: cities[1].trim(),
          );

          if (!_routes.any((r) => r.code == newRoute.code)) {
            final savedRoute = await _apiService.addRoute(newRoute);

            if (savedRoute != null) {
              _routes.add(savedRoute);
              _selectedRoute = savedRoute;
              notifyListeners();
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Format rute tidak valid");
    }
  }

  Future<void> deleteRoute(RouteModel route) async {
    if (_routes.length > 1) {
      if (route.id != null) {
        final success = await _apiService.deleteRoute(route.id!);
        if (success) {
          _routes.remove(route);
          if (_selectedRoute == route) {
            _selectedRoute = _routes.first;
          }
          notifyListeners();
        }
      } else {
        _routes.remove(route);
        if (_selectedRoute == route) {
          _selectedRoute = _routes.first;
        }
        notifyListeners();
      }
    }
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

  Future<void> sendPayloadToDevice(BuildContext context) async {
    final payload = {
      "route": _selectedRoute.fullDisplayName,
      "direction": _isPergi ? "Pergi" : "Pulang",
      "animation": _animMode,
      "speed": _speed.toInt(),
      "brightness": _brightness.toInt(),
      "fontSize": _fontSize.toInt(),
    };

    final bool success = await _apiService.sendDisplayConfig(payload);

    _isConnected = success;
    notifyListeners();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: success
              ? const Color(0xFF22C55E)
              : const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Text(
            success
                ? 'Berhasil mengirim ke P5 Panel!'
                : 'Gagal terhubung ke Backend.',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }
}
