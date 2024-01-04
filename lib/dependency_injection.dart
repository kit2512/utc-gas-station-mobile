import 'package:shared_preferences/shared_preferences.dart';
import 'package:utc_gas_station/apis/api_services.dart';
import 'package:utc_gas_station/blocs/info_cubit/info_cubit.dart';
import 'package:utc_gas_station/config/dio_config.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => prefs);
  final dioClient = DioClient();
  dioClient.baseUrl = prefs.getString('base_url') ?? '';
  getIt.registerLazySingleton<DioClient>(() => dioClient);
  getIt.registerLazySingleton(() => ApiService(getIt<DioClient>()));
  getIt.registerLazySingleton(() => InfoCubit(apiService: getIt<ApiService>()));
}
