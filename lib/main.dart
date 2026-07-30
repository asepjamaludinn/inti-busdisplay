import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'features/home/home_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => HomeProvider())],
        child: const SmartBusDisplayApp(),
      ),
    );
  });
}
