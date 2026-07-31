import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  static const String serviceUuid = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  static const String characteristicUuid =
      "beb5483e-36e1-4688-b7f5-ea07361b26a8";

  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? targetCharacteristic;

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect(autoConnect: false);
      connectedDevice = device;

      if (Platform.isAndroid) {
        await device.requestMtu(512);
      }

      List<BluetoothService> services = await device.discoverServices();
      for (var service in services) {
        if (service.uuid.toString() == serviceUuid) {
          for (var characteristic in service.characteristics) {
            if (characteristic.uuid.toString() == characteristicUuid) {
              targetCharacteristic = characteristic;
              debugPrint('Karakteristik BLE ditemukan siap untuk ditulisi.');
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Gagal terhubung ke BLE: $e');
      rethrow;
    }
  }

  void disconnect() {
    connectedDevice?.disconnect();
    connectedDevice = null;
    targetCharacteristic = null;
  }

  Future<bool> sendPayload(Map<String, dynamic> payload) async {
    if (targetCharacteristic == null || connectedDevice == null) {
      debugPrint('BLE belum terhubung atau karakteristik tidak ditemukan.');
      return false;
    }

    try {
      final String jsonString = jsonEncode(payload);
      final List<int> bytes = utf8.encode(jsonString);

      await targetCharacteristic!.write(bytes, withoutResponse: false);
      return true;
    } catch (e) {
      debugPrint('Gagal mengirim data via BLE: $e');
      return false;
    }
  }
}
