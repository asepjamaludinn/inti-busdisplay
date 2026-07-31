import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../core/models/route_model.dart';
import '../../core/services/api_service.dart';
import '../../core/services/bluetooth_service.dart';

class HomeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final BleService _bleService = BleService();

  bool _isApiConnected = false;

  bool _isBleConnected = false;
  String _bleDeviceName = 'Belum Terhubung';
  bool _isScanning = false;
  List<ScanResult> _scanResults = [];

  StreamSubscription<List<ScanResult>>? _scanSubscription;

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
    _initData();
  }

  bool get isApiConnected => _isApiConnected;
  bool get isConnected => _isBleConnected;
  String get connectionText => _bleDeviceName;
  bool get isScanning => _isScanning;
  List<ScanResult> get scanResults => _scanResults;
  List<RouteModel> get routes => _routes;
  RouteModel get selectedRoute => _selectedRoute;
  bool get isPergi => _isPergi;
  String get animMode => _animMode;
  double get speed => _speed;
  double get brightness => _brightness;
  double get fontSize => _fontSize;

  Future<void> _initData() async {
    _isApiConnected = await _apiService.checkConnection();
    await loadRoutesFromServer();
  }

  Future<void> startBleScan() async {
    _isScanning = true;
    _scanResults.clear();
    notifyListeners();

    try {
      await _scanSubscription?.cancel();

      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        _scanResults = results
            .where((r) => r.device.platformName.isNotEmpty)
            .toList();
        notifyListeners();
      });

      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
    } catch (e) {
      debugPrint("Scan error: $e");
    } finally {
      await Future.delayed(const Duration(seconds: 4));
      _isScanning = false;
      notifyListeners();
    }
  }

  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      await _bleService.connectToDevice(device);
      _isBleConnected = true;
      _bleDeviceName = device.platformName;
      notifyListeners();
      return true;
    } catch (e) {
      _isBleConnected = false;
      notifyListeners();
      return false;
    }
  }

  void disconnectBle() {
    _bleService.disconnect();
    _isBleConnected = false;
    _bleDeviceName = 'Belum Terhubung';
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
    if (input.trim().isEmpty) return;

    try {
      String code = '';
      String origin = '';
      String destination = '';
      String routePart = input;

      if (input.contains('•')) {
        final parts = input.split('•');
        code = parts[0].trim();
        routePart = parts.sublist(1).join('•').trim();
      } else {
        String randomSuffix = DateTime.now().millisecondsSinceEpoch.toString();
        code = 'R-${randomSuffix.substring(randomSuffix.length - 3)}';
      }

      if (routePart.contains('-')) {
        final cities = routePart.split('-');
        origin = cities[0].trim();
        destination = cities.sublist(1).join('-').trim();
      } else {
        origin = routePart.trim();
        destination = 'Tujuan Bebas';
      }

      if (code.isEmpty) code = 'R-X';
      if (origin.isEmpty) origin = 'Asal';
      if (destination.isEmpty) destination = 'Tujuan';

      final newRoute = RouteModel(
        code: code,
        origin: origin,
        destination: destination,
      );

      if (!_routes.any((r) => r.code == newRoute.code)) {
        final savedRoute = await _apiService.addRoute(newRoute);

        if (savedRoute != null) {
          _routes.add(savedRoute);
          _selectedRoute = savedRoute;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint("Format rute gagal diproses: $e");
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
    if (!_isBleConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFF59E0B),
          content: const Text(
            'Silakan hubungkan Bluetooth ke Panel P5 terlebih dahulu.',
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    final payload = {
      "route": _selectedRoute.fullDisplayName,
      "direction": _isPergi ? "Pergi" : "Pulang",
      "animation": _animMode,
      "speed": _speed.toInt(),
      "brightness": _brightness.toInt(),
      "fontSize": _fontSize.toInt(),
    };

    final bool success = await _bleService.sendPayload(payload);

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
                ? 'Berhasil mengirim ke P5 Panel via Bluetooth!'
                : 'Gagal mengirim data. Pastikan dekat dengan panel.',
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
