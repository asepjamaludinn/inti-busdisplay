import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'core/providers/connection_provider.dart';
import 'core/providers/display_settings_provider.dart';
import 'core/providers/preset_provider.dart';
import 'core/providers/route_provider.dart';
import 'core/services/api_service.dart';
import 'core/repositories/route_repository.dart';
import 'core/repositories/preset_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    final apiService = ApiService.instance;

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ConnectionProvider(apiService: apiService),
          ),
          ChangeNotifierProvider(
            create: (_) => RouteProvider(
              routeRepository: RouteRepository(apiService: apiService),
            ),
          ),
          ChangeNotifierProvider(create: (_) => DisplaySettingsProvider()),
          ChangeNotifierProvider(
            create: (_) => PresetProvider(
              presetRepository: PresetRepository(apiService: apiService),
            ),
          ),
        ],
        child: const SmartBusDisplayApp(),
      ),
    );
  });
}
