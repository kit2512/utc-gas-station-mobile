import 'package:utc_gas_station/data/models/checkin_history.dart';
import 'package:utc_gas_station/data/models/room.dart';
import 'package:utc_gas_station/data/models/user_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employee.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Employee {
  Employee({
    required this.id,
    required this.userId,
    required this.userInfo,
    required this.checkinHistory,
    required this.allowedRooms,
  });

  final int id;
  final int userId;
  final UserInfo userInfo;
  final List<CheckinHistory> checkinHistory;
  final List<Room> allowedRooms;

  factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}
