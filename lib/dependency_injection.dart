import 'package:utc_gas_station/config/dio_config.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() async {
  getIt.registerLazySingleton<DioClient>(DioClient.new);
}
