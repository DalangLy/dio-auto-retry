import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_auto_retry/get_data.dart';
import 'package:dio_auto_retry/interceptor/dio_interceptor_config.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void init() {
  sl.registerFactory(
    () => GetData(dio: sl()),
  );

  /** External **/
  sl.registerLazySingleton(
    () => DioWithInterceptor(
      dio: Dio(),
      connectivity: sl(),
    ).setUp(),
  );
  sl.registerLazySingleton(() => Connectivity());
}
