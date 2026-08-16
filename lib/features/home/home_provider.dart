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

  String? _loadedPresetId;
  String? _loadedPresetName;

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
  String? get loadedPresetId => _loadedPresetId;
  String? get loadedPresetName => _loadedPresetName;
  bool get hasLoadedPreset => _loadedPresetId != null;

  Future<void> _initData() async {
    _isApiConnected = await _apiService.checkConnection();
    await loadRoutesFromServer();
  }

  void _showFeedback(
    BuildContext context, {
    required String message,
    required Color color,
  }) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
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

  Future<void> addRoute(BuildContext context, String input) async {
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

      final isDuplicateCode = _routes.any(
        (r) => r.code.toLowerCase() == code.toLowerCase(),
      );
      if (isDuplicateCode) {
        if (context.mounted) {
          _showFeedback(
            context,
            message: 'Kode rute "$code" sudah terdaftar.',
            color: const Color(0xFFF59E0B),
          );
        }
        return;
      }

      final isDuplicateRouteName = _routes.any(
        (r) =>
            (r.origin.toLowerCase() == origin.toLowerCase() &&
                r.destination.toLowerCase() == destination.toLowerCase()) ||
            (r.origin.toLowerCase() == destination.toLowerCase() &&
                r.destination.toLowerCase() == origin.toLowerCase()),
      );
      if (isDuplicateRouteName) {
        if (context.mounted) {
          _showFeedback(
            context,
            message:
                'Rute "$origin - $destination" sudah terdaftar (arah sebaliknya '
                'sudah ada, gunakan toggle Pergi/Pulang).',
            color: const Color(0xFFF59E0B),
          );
        }
        return;
      }

      final newRoute = RouteModel(
        code: code,
        origin: origin,
        destination: destination,
      );

      final result = await _apiService.addRoute(newRoute);

      if (result.success && result.data != null) {
        _routes.add(result.data!);
        _selectedRoute = result.data!;
        notifyListeners();
      } else if (context.mounted) {
        _showFeedback(
          context,
          message: result.message ?? 'Gagal menambahkan rute.',
          color: const Color(0xFFEF4444),
        );
      }
    } catch (e) {
      debugPrint("Format rute gagal diproses: $e");
      if (context.mounted) {
        _showFeedback(
          context,
          message: 'Format rute tidak valid.',
          color: const Color(0xFFEF4444),
        );
      }
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

  void resetToDefault(BuildContext context) {
    if (_routes.isNotEmpty) _selectedRoute = _routes.first;
    _isPergi = true;
    _animMode = 'Scroll Left';
    _speed = 50;
    _brightness = 80;
    _fontSize = 16;
    _loadedPresetId = null;
    _loadedPresetName = null;

    notifyListeners();

    _showFeedback(
      context,
      message: 'Pengaturan berhasil direset ke default.',
      color: const Color(0xFF22C55E),
    );
  }

  Map<String, dynamic> _buildPayload() {
    return {
      "route": _selectedRoute.fullDisplayName,
      "direction": _isPergi ? "Pergi" : "Pulang",
      "animation": _animMode,
      "speed": _speed.toInt(),
      "brightness": _brightness.toInt(),
      "fontSize": _fontSize.toInt(),
    };
  }

  Future<ApiResult<void>> saveCurrentPreset(String presetName) async {
    return await _apiService.savePreset(presetName, _buildPayload());
  }

  Future<void> overwriteLoadedPreset(BuildContext context) async {
    if (_loadedPresetId == null) {
      _showFeedback(
        context,
        message: 'Tidak ada preset yang sedang dimuat untuk ditimpa.',
        color: const Color(0xFFF59E0B),
      );
      return;
    }

    final result = await _apiService.updatePreset(
      _loadedPresetId!,
      _loadedPresetName ?? 'Preset',
      _buildPayload(),
    );

    if (context.mounted) {
      _showFeedback(
        context,
        message:
            result.message ??
            (result.success
                ? 'Preset "${_loadedPresetName ?? ''}" berhasil ditimpa dengan pengaturan saat ini.'
                : 'Gagal menimpa preset.'),
        color: result.success
            ? const Color(0xFF22C55E)
            : const Color(0xFFEF4444),
      );
    }
  }

  Future<void> overwritePreset(
    BuildContext context,
    String presetId,
    String presetName,
  ) async {
    final result = await _apiService.updatePreset(
      presetId,
      presetName,
      _buildPayload(),
    );

    if (context.mounted) {
      _showFeedback(
        context,
        message:
            result.message ??
            (result.success
                ? 'Preset "$presetName" berhasil ditimpa dengan pengaturan saat ini.'
                : 'Gagal menimpa preset.'),
        color: result.success
            ? const Color(0xFF22C55E)
            : const Color(0xFFEF4444),
      );
    }
  }

  Future<List<dynamic>> getSavedPresets() async {
    return await _apiService.fetchPresets();
  }

  void applyPreset(
    BuildContext context,
    Map<String, dynamic> payload, {
    String? presetId,
    String? presetName,
  }) {
    try {
      final routeName = payload['route'] as String?;
      if (routeName != null) {
        _selectedRoute = _routes.firstWhere(
          (r) => r.fullDisplayName == routeName,
          orElse: () => _routes.first,
        );
      }
      _isPergi = payload['direction'] == 'Pergi';
      _animMode = payload['animation'] ?? 'Static';
      _speed = (payload['speed'] as num?)?.toDouble() ?? 50.0;
      _brightness = (payload['brightness'] as num?)?.toDouble() ?? 80.0;
      _fontSize = (payload['fontSize'] as num?)?.toDouble() ?? 16.0;
      _loadedPresetId = presetId;
      _loadedPresetName = presetName;

      notifyListeners();

      _showFeedback(
        context,
        message: presetName != null && presetName.isNotEmpty
            ? 'Preset "$presetName" berhasil diterapkan.'
            : 'Preset berhasil diterapkan.',
        color: const Color(0xFF22C55E),
      );
    } catch (e) {
      debugPrint('Gagal memuat preset: $e');
      _showFeedback(
        context,
        message: 'Gagal menerapkan preset. Format data tidak valid.',
        color: const Color(0xFFEF4444),
      );
    }
  }

  Future<void> sendPayloadToDevice(BuildContext context) async {
    if (!_isBleConnected) {
      _showFeedback(
        context,
        message: 'Silakan hubungkan Bluetooth ke Panel P5 terlebih dahulu.',
        color: const Color(0xFFF59E0B),
      );
      return;
    }

    final payload = _buildPayload();

    final bool bleSuccess = await _bleService.sendPayload(payload);

    unawaited(_apiService.sendDisplayConfig(payload));

    if (context.mounted) {
      _showFeedback(
        context,
        message: bleSuccess
            ? 'Berhasil mengirim ke P5 Panel via Bluetooth!'
            : 'Gagal mengirim data. Pastikan dekat dengan panel.',
        color: bleSuccess ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
      );
    }
  }
}
