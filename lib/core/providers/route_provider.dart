import 'package:flutter/foundation.dart';
import '../models/operation_result.dart';
import '../models/route_model.dart';
import '../repositories/route_repository.dart';

class RouteProvider extends ChangeNotifier {
  final RouteRepository _routeRepository;

  RouteProvider({RouteRepository? routeRepository})
    : _routeRepository = routeRepository ?? RouteRepository() {
    _loadRoutes();
  }

  List<RouteModel> _routes = [
    RouteModel(code: 'B1', origin: 'Bandung', destination: 'Garut'),
    RouteModel(code: 'B2', origin: 'Bandung', destination: 'Jakarta'),
  ];
  late RouteModel _selectedRoute = _routes.first;
  bool _isPergi = true;

  List<RouteModel> get routes => _routes;
  RouteModel get selectedRoute => _selectedRoute;
  bool get isPergi => _isPergi;

  Future<void> _loadRoutes() async {
    final serverRoutes = await _routeRepository.fetchRoutes();
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

  void setDirection(bool isPergi) {
    _isPergi = isPergi;
    notifyListeners();
  }

  Future<OperationResult<RouteModel>> addRoute({
    required String code,
    required String origin,
    required String destination,
  }) async {
    final trimmedCode = code.trim();
    final trimmedOrigin = origin.trim();
    final trimmedDestination = destination.trim();

    if (trimmedCode.isEmpty ||
        trimmedOrigin.isEmpty ||
        trimmedDestination.isEmpty) {
      return OperationResult.failure(
        'Kode, asal, dan tujuan rute wajib diisi.',
      );
    }

    final isDuplicateCode = _routes.any(
      (r) => r.code.toLowerCase() == trimmedCode.toLowerCase(),
    );
    if (isDuplicateCode) {
      return OperationResult.failure(
        'Kode rute "$trimmedCode" sudah terdaftar.',
      );
    }

    final isDuplicateRouteName = _routes.any(
      (r) =>
          (r.origin.toLowerCase() == trimmedOrigin.toLowerCase() &&
              r.destination.toLowerCase() ==
                  trimmedDestination.toLowerCase()) ||
          (r.origin.toLowerCase() == trimmedDestination.toLowerCase() &&
              r.destination.toLowerCase() == trimmedOrigin.toLowerCase()),
    );
    if (isDuplicateRouteName) {
      return OperationResult.failure(
        'Rute "$trimmedOrigin - $trimmedDestination" sudah terdaftar (arah sebaliknya '
        'sudah ada, gunakan toggle Pergi/Pulang).',
      );
    }

    final newRoute = RouteModel(
      code: trimmedCode,
      origin: trimmedOrigin,
      destination: trimmedDestination,
    );

    final result = await _routeRepository.addRoute(newRoute);

    if (result.success && result.data != null) {
      _routes.add(result.data!);
      _selectedRoute = result.data!;
      notifyListeners();
    }

    return result;
  }

  Future<OperationResult<void>> deleteRoute(RouteModel route) async {
    if (_routes.length <= 1) {
      return OperationResult.failure('Minimal harus ada 1 rute tersisa!');
    }

    if (route.id != null) {
      final result = await _routeRepository.deleteRoute(route.id!);
      if (!result.success) {
        return result;
      }
    }

    _routes.remove(route);
    if (_selectedRoute == route) {
      _selectedRoute = _routes.first;
    }
    notifyListeners();
    return OperationResult.success(null, 'Rute berhasil dihapus.');
  }

  void applyRouteFromPayload(Map<String, dynamic> payload) {
    final routeName = payload['route'] as String?;
    if (routeName != null) {
      _selectedRoute = _routes.firstWhere(
        (r) => r.fullDisplayName == routeName,
        orElse: () => _routes.first,
      );
    }
    _isPergi = payload['direction'] == 'Pergi';
    notifyListeners();
  }

  void resetSelection() {
    if (_routes.isNotEmpty) _selectedRoute = _routes.first;
    _isPergi = true;
    notifyListeners();
  }
}
