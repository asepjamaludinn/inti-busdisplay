import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../models/operation_result.dart';
import '../services/api_service.dart';
import '../services/bluetooth_service.dart';
import '../services/device_identity_service.dart';

class ConnectionProvider extends ChangeNotifier {
  final ApiService _apiService;
  final BleService _bleService;
  final DeviceIdentityService _deviceIdentity;

  ConnectionProvider({
    ApiService? apiService,
    BleService? bleService,
    DeviceIdentityService? deviceIdentity,
    @visibleForTesting bool debugInitiallyConnected = false,
  }) : _apiService = apiService ?? ApiService.instance,
       _bleService = bleService ?? BleService(),
       _deviceIdentity = deviceIdentity ?? DeviceIdentityService(),
       _isBleConnected = debugInitiallyConnected;

  bool _isBleConnected;
  String _bleDeviceName = 'Belum Terhubung';
  bool _isScanning = false;
  List<ScanResult> _scanResults = [];
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  bool _lastApiSyncFailed = false;

  bool get isBleConnected => _isBleConnected;
  String get connectionText => _bleDeviceName;
  bool get isScanning => _isScanning;
  List<ScanResult> get scanResults => _scanResults;
  bool get lastApiSyncFailed => _lastApiSyncFailed;

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

    final bleKey = await _deviceIdentity.getBleKey();
    final deviceToken = await _deviceIdentity.getDeviceToken();

    final bool bleSuccess = await _bleService.sendPayload(
      payload,
      bleKey: bleKey,
      deviceToken: deviceToken,
    );

    if (!bleSuccess) {
      return OperationResult.failure(
        'Gagal mengirim data. Pastikan dekat dengan panel dan device sudah '
        'dipasangkan (bleKey tersedia).',
      );
    }

    bool apiSynced = true;
    try {
      final apiResult = await _apiService.sendDisplayConfig(payload);
      apiSynced = apiResult.success;
      if (!apiSynced) {
        debugPrint(
          'Sinkronisasi API gagal setelah BLE sukses: ${apiResult.message}',
        );
      }
    } catch (e) {
      apiSynced = false;
      debugPrint('Error saat sinkronisasi API setelah BLE sukses: $e');
    }

    _lastApiSyncFailed = !apiSynced;
    notifyListeners();

    return OperationResult.success(
      null,
      apiSynced
          ? 'Berhasil mengirim ke P5 Panel via Bluetooth!'
          : 'Berhasil mengirim ke panel via Bluetooth, tapi gagal sinkron '
                'ke server. Data di server mungkin tidak sesuai kondisi panel.',
    );
  }

  void acknowledgeApiSyncFailure() {
    if (!_lastApiSyncFailed) return;
    _lastApiSyncFailed = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
  }
}
