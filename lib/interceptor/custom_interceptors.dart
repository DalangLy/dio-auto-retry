import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_auto_retry/interceptor/dio_connectivity_request_retrier.dart';
class CustomInterceptors extends Interceptor {
  final DioConnectivityRequestRetrier requestRetrier;

  CustomInterceptors({required this.requestRetrier});

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if(_shouldRetry(err)){
      try{
        return handler.resolve(await requestRetrier.scheduleRequestRetry(err.requestOptions));
      }
      catch(ex){
        return  handler.next(err);//continue
      }
    }
    // print('Dalang ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    return super.onError(err, handler);
  }

  bool _shouldRetry(DioError err) {
    return err.type == DioErrorType.other &&
        err.error != null &&
        err.error is SocketException;
  }
}