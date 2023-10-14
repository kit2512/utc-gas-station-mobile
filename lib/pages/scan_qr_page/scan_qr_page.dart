import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:utc_gas_station/apis/api_services.dart';
import 'package:utc_gas_station/blocs/info_cubit/info_cubit.dart';
import 'package:utc_gas_station/dependency_injection.dart';

class ScanQRPage extends StatefulWidget {
  const ScanQRPage({super.key});

  @override
  State<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  final qrController = MobileScannerController();

  void onDetect(BarcodeCapture barcodeCapture) {
    final data = barcodeCapture.barcodes.firstOrNull;
    if (data != null && data.rawValue != null) {
      qrController.stop();
      showDialog<bool?>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ProcessDialog(
          payload: data.rawValue!,
        ),
      ).then((value) {
        if (value == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Success"),
              backgroundColor: Colors.green,
            ),
          );
          getIt<InfoCubit>().getInfo();
          Navigator.of(context).pop();
        } else if (value == false){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Invalid QR"),
              backgroundColor: Colors.red,
            ),
          );
          qrController.start();
        } else {
          qrController.start();
        }
      });
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

class ProcessDialog extends StatefulWidget {
  const ProcessDialog({
    super.key,
    required this.payload,
  });

  final String payload;

  @override
  State<ProcessDialog> createState() => _ProcessDialogState();
}

class _ProcessDialogState extends State<ProcessDialog> {

  @override
  void initState() {
    checkQr();
    super.initState();
  }
  final ApiService apiService = getIt<ApiService>();

  void checkQr() async {
    final failureOrResponse = await apiService.checkQR(widget.payload);
    failureOrResponse.fold(
      (l) {
        Navigator.of(context).pop(false);
      },
      (r) {
        Navigator.of(context).pop(true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text('Processing...'),
      content: CircularProgressIndicator.adaptive(),
    );
  }
}
