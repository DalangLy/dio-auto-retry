import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_auto_retry/interceptor/custom_interceptors.dart';
import 'package:dio_auto_retry/interceptor/dio_connectivity_request_retrier.dart';

class DioWithInterceptor{
  final Dio dio;
  final Connectivity connectivity;

  DioWithInterceptor({required this.dio, required this.connectivity});
  Dio setUp(){
    dio.interceptors.add(CustomInterceptors(requestRetrier: DioConnectivityRequestRetrier(connectivity: connectivity, dio: dio,),),);
    return dio;
  }
}