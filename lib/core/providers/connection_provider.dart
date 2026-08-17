import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../models/operation_result.dart';
import '../services/api_service.dart';
import '../services/bluetooth_service.dart';

class ConnectionProvider extends ChangeNotifier {
  final ApiService _apiService;
  final BleService _bleService;

  ConnectionProvider({ApiService? apiService, BleService? bleService})
    : _apiService = apiService ?? ApiService.instance,
      _bleService = bleService ?? BleService() {
    _checkApiConnection();
  }

  bool _isApiConnected = false;
  bool _isBleConnected = false;
  String _bleDeviceName = 'Belum Terhubung';
  bool _isScanning = false;
  List<ScanResult> _scanResults = [];
  StreamSubscription<List<ScanResult>>? _scanSubscription;

  bool get isApiConnected => _isApiConnected;
  bool get isBleConnected => _isBleConnected;
  String get connectionText => _bleDeviceName;
  bool get isScanning => _isScanning;
  List<ScanResult> get scanResults => _scanResults;

  Future<void> _checkApiConnection() async {
    _isApiConnected = await _apiService.checkConnection();
    notifyListeners();
  }

  Future<void> startBleScan() async {
    _isScanning = true;
    _scanResults = [];
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

  Future<OperationResult<void>> sendPayload(
    Map<String, dynamic> payload,
  ) async {
    if (!_isBleConnected) {
      return OperationResult.failure(
        'Silakan hubungkan Bluetooth ke Panel P5 terlebih dahulu.',
      );
    }

    final bool bleSuccess = await _bleService.sendPayload(payload);

    unawaited(_apiService.sendDisplayConfig(payload));

    return bleSuccess
        ? OperationResult.success(
            null,
            'Berhasil mengirim ke P5 Panel via Bluetooth!',
          )
        : OperationResult.failure(
            'Gagal mengirim data. Pastikan dekat dengan panel.',
          );
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
  }
}
