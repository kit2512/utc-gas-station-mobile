import 'package:utc_gas_station/apis/api_services.dart';
import 'package:utc_gas_station/blocs/info_cubit/info_cubit.dart';
import 'package:utc_gas_station/config/dio_config.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() async {
  getIt.registerLazySingleton<DioClient>(DioClient.new);
  getIt.registerLazySingleton(() => ApiService(getIt<DioClient>()));
  getIt.registerLazySingleton(() => InfoCubit(apiService: getIt<ApiService>()));

}
