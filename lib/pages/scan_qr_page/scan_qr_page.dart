import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ScanQRPage extends StatefulWidget {
  const ScanQRPage({super.key});

  @override
  State<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  final qrController = MobileScannerController();

  void onDetect(BarcodeCapture barcodeCapture) {
    final data = barcodeCapture.barcodes.firstOrNull;
    if (data != null && data.url != null) {
      qrController.stop();
      launchUrlString(data.url!.url!);
    }
  }

  @override
  void dispose() {
    qrController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Scan QR'),
        ),
        body: MobileScanner(
          placeholderBuilder: (_, __) => const Center(
            child: CircularProgressIndicator(),
          ),
          controller: qrController,
          errorBuilder: (_, e, __) => Center(
            child: Text(e.toString()),
          ),
          onDetect: onDetect,
        ),
      );
}
