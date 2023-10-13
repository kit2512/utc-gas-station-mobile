import 'package:utc_gas_station/dependency_injection.dart';
import 'package:utc_gas_station/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:utc_gas_station/pages/login_page/login_page.dart';
import 'package:utc_gas_station/pages/scan_qr_page/scan_qr_page.dart';

import 'pages/manual_page/manual_page.dart';

void main() {
  setupDependencies();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/scan-qr': (context) => const ScanQRPage(),
        '/manual': (context) => const ManualPage(),
      },
    );
}
