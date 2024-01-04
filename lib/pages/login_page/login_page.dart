import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:utc_gas_station/apis/api_services.dart';
import 'package:utc_gas_station/dependency_injection.dart';
import 'package:utc_gas_station/helpers/exception_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _hidePassword = false;
  String _username = '';
  int? _password;

  String? errorMessage;

  bool get formValid => _username.isNotEmpty && _password != null;

  final ApiService apiService = getIt<ApiService>();

  FormzSubmissionStatus _status = FormzSubmissionStatus.initial;

  void _login() async {
    setState(() {
      _status = FormzSubmissionStatus.inProgress;
    });
    final failureOrResponse = await apiService.login(username: _username, password: _password!);
    failureOrResponse.fold(
        (l) => {
              setState(() {
                _status = FormzSubmissionStatus.failure;
                errorMessage = getErrorMessage(l);
              })
            }, (_) {
      setState(() {
        _status = FormzSubmissionStatus.success;
      });
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Please login to continue'),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
                onChanged: (value) {
                  setState(() {
                    _username = value;
                  });
                },
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _password = int.tryParse(value);
                  });
                },
                keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
                obscureText: _hidePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _hidePassword = !_hidePassword;
                      });
                    },
                    icon: Icon(
                      _hidePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              if (_status.isFailure)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    errorMessage ?? '',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              const SizedBox(height: 16.0),
              _status.isInProgress
                  ? const CircularProgressIndicator.adaptive()
                  : ElevatedButton(
                      onPressed: formValid ? _login : null,
                      child: const Text(
                        'Login',
                      ),
                    ),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pushNamed('/settings'),
                child: const Text('Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
