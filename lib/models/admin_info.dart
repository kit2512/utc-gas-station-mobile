class AdminInfo {
  AdminInfo({
    required this.adminName,
    required this.money,
  });
  final String adminName;
  final int money;

  factory AdminInfo.fromJson(Map<String, dynamic> json) => AdminInfo(
    adminName: json['admin_name'],
    money: json['money'],
  );

  Map<String, dynamic> toJson() => {
    'admin_name': adminName,
    'money': money,
  };
}