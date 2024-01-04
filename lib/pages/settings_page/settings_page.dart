import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:utc_gas_station/apis/api_services.dart';
import 'package:utc_gas_station/dependency_injection.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _hostController = TextEditingController();
  final prefs = getIt<SharedPreferences>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _hostController.text = getIt<ApiService>().baseUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Host',
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _hostController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'http://...'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter host';
                  }
                  try {
                    final uri = Uri.parse(value);
                    if (uri.scheme.isEmpty || uri.host.isEmpty) {
                      return 'Please enter valid host';
                    }
                  } catch (e) {
                    return 'Please enter valid host';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final value = _hostController.text;
                    if (!value.endsWith('/')) {
                      _hostController.text = '$value/';
                    }
                    prefs.setString('base_url', _hostController.text);
                    getIt<ApiService>().baseUrl = _hostController.text;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Saved'),
                      ),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
