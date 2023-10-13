import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _hidePassword = false;
  String _username = '';
  String _password = '';

  bool get formValid => _username.isNotEmpty && _password.isNotEmpty;

  FormzSubmissionStatus _status = FormzSubmissionStatus.initial;

  void _login() async {
    setState(() {
      _status = FormzSubmissionStatus.inProgress;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _status = FormzSubmissionStatus.success;
    });
    Navigator.of(context).pushReplacementNamed('/home');
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
                    _password = value;
                  });
                },
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
              _status.isInProgress
                  ? const CircularProgressIndicator.adaptive()
                  : ElevatedButton(
                      onPressed: formValid ? _login : null,
                      child: const Text('Login'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
