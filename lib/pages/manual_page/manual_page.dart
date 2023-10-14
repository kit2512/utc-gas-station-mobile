import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:utc_gas_station/apis/api_services.dart';
import 'package:utc_gas_station/blocs/info_cubit/info_cubit.dart';
import 'package:utc_gas_station/dependency_injection.dart';
import 'package:utc_gas_station/enums/manual_mode.dart';

class ManualPage extends StatefulWidget {
  const ManualPage({super.key});

  @override
  State<ManualPage> createState() => _ManualPageState();
}

class _ManualPageState extends State<ManualPage> {
  ManualMode _mode = ManualMode.auto;

  double _amount = 0;
  FormzSubmissionStatus _status = FormzSubmissionStatus.initial;

  bool get formValid {
    if (_mode == ManualMode.auto) {
      return true;
    }
    return _amount > 0;
  }

  final ApiService apiService = getIt<ApiService>();

  void _setAmount(String value) {
    try {
      final amount = double.parse(value);
      setState(() {
        _amount = amount;
      });
    } catch (e) {
      setState(() {
        _amount = 0;
      });
    }
  }

  void _submit() async {
    setState(() {
      _status = FormzSubmissionStatus.inProgress;
    });
    final failureOrResponse = await apiService.updateSystem(
      isAuto: _mode == ManualMode.auto,
      manual: _amount.toInt(),
    );
    failureOrResponse.fold((l) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to update system"),
          backgroundColor: Colors.red,
        ),
      );
    }, (r) {
      setState(() {
        _status = FormzSubmissionStatus.success;
      });
      getIt<InfoCubit>().getInfo();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Submitted'),
        ),
      );
      Navigator.of(context).pop();
    });
  }

  void _setMode(ManualMode? mode) {
    if (mode != null) {
      setState(
        () {
          _mode = mode;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mode', style: TextStyle(fontSize: 18.0)),
            RadioListTile<ManualMode>.adaptive(
              title: const Text('Auto'),
              value: ManualMode.auto,
              groupValue: _mode,
              onChanged: _setMode,
            ),
            RadioListTile<ManualMode>.adaptive(
              title: const Text('Manual'),
              value: ManualMode.manual,
              groupValue: _mode,
              onChanged: _setMode,
            ),
            if (_mode == ManualMode.manual)
              TextFormField(
                enabled: !_status.isInProgress,
                onChanged: _setAmount,
                decoration: const InputDecoration(
                  labelText: 'Enter amount',
                ),
                keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
              ),
            const SizedBox(height: 16.0),
            _status.isInProgress
                ? const CircularProgressIndicator.adaptive()
                : ElevatedButton(
                    onPressed: formValid ? _submit : null,
                    child: const Text('Submit'),
                  ),
          ],
        ),
      ),
    );
  }
}
