import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runningtext_app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SmartBusDisplayApp());

    // Uji coba sederhana untuk memastikan aplikasi berjalan
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
