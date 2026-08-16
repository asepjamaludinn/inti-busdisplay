import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class DeviceIdentityService {
  static const _storage = FlutterSecureStorage();
  static const _keyDeviceId = 'device_id';
  static const _keyDeviceToken = 'device_token';

  Future<String> getOrCreateDeviceId() async {
    String? id = await _storage.read(key: _keyDeviceId);
    if (id == null) {
      id = const Uuid().v4();
      await _storage.write(key: _keyDeviceId, value: id);
    }
    return id;
  }

  Future<String?> getDeviceToken() => _storage.read(key: _keyDeviceToken);

  Future<void> saveDeviceToken(String token) =>
      _storage.write(key: _keyDeviceToken, value: token);

  Future<bool> isPaired() async {
    final token = await getDeviceToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearPairing() => _storage.delete(key: _keyDeviceToken);
}
