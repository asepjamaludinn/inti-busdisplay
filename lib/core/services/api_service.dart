import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/route_model.dart';

class ApiService {
  static final String serverIp = dotenv.env['BACKEND_IP'] ?? '127.0.0.1';
  static final String port = dotenv.env['BACKEND_PORT'] ?? '3000';

  static final String baseUrl = 'http://$serverIp:$port/api';

  String get currentIp => serverIp;

  Future<bool> checkConnection() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/display/status'))
          .timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendDisplayConfig(Map<String, dynamic> payload) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/display/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<RouteModel>> fetchRoutes() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/routes'))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> data = body['data'];
        return data.map((json) => RouteModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching routes: $e');
    }
    return [];
  }

  Future<RouteModel?> addRoute(RouteModel route) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/routes'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(route.toJson()),
      );
      if (response.statusCode == 201) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return RouteModel.fromJson(body['data']);
      }
    } catch (e) {
      debugPrint('Error adding route: $e');
    }
    return null;
  }

  Future<bool> deleteRoute(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/routes/$id'));
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error deleting route: $e');
      return false;
    }
  }

  Future<bool> savePreset(String name, Map<String, dynamic> payload) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/display/presets'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'payload': payload}),
      );
      return response.statusCode == 201;
    } catch (e) {
      debugPrint('Error saving preset: $e');
      return false;
    }
  }

  Future<List<dynamic>> fetchPresets() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/display/presets'))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return body['data'] ?? [];
      }
    } catch (e) {
      debugPrint('Error fetching presets: $e');
    }
    return [];
  }
}
