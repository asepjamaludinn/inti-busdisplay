import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'core/providers/connection_provider.dart';
import 'core/providers/display_settings_provider.dart';
import 'core/providers/preset_provider.dart';
import 'core/providers/route_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ConnectionProvider()),
          ChangeNotifierProvider(create: (_) => RouteProvider()),
          ChangeNotifierProvider(create: (_) => DisplaySettingsProvider()),
          ChangeNotifierProvider(create: (_) => PresetProvider()),
        ],
        child: const SmartBusDisplayApp(),
      ),
    );
  });
}
