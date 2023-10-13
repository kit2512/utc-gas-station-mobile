import 'package:utc_gas_station/data/datasources/employee_datasource.dart';

class EmployeeRepository {
  EmployeeRepository({
    required this.employeeDatasource,
  });

  final EmployeeDataSource employeeDatasource;
}
