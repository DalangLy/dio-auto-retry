import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class DioConnectivityRequestRetrier{
  final Dio dio;
  final Connectivity connectivity;

  DioConnectivityRequestRetrier({required this.dio, required this.connectivity});

  Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    late StreamSubscription streamSubscription;
    final responseCompleter = Completer<Response>();

    streamSubscription = connectivity.onConnectivityChanged.listen(
          (connectivityResult) {
        if (connectivityResult != ConnectivityResult.none) {
          streamSubscription.cancel();
          responseCompleter.complete(
            dio.request(
              requestOptions.path,
              cancelToken: requestOptions.cancelToken,
              data: requestOptions.data,
              onReceiveProgress: requestOptions.onReceiveProgress,
              onSendProgress: requestOptions.onSendProgress,
              queryParameters: requestOptions.queryParameters,
              options: Options(
                method: requestOptions.method,
                headers: requestOptions.headers,
                contentType: requestOptions.contentType,
                extra: requestOptions.extra,
                responseType: requestOptions.responseType,
                requestEncoder: requestOptions.requestEncoder,
                responseDecoder: requestOptions.responseDecoder,
                sendTimeout: requestOptions.sendTimeout,
                validateStatus: requestOptions.validateStatus,
                receiveTimeout: requestOptions.receiveTimeout,
                followRedirects: requestOptions.followRedirects,
                listFormat: requestOptions.listFormat,
                maxRedirects: requestOptions.maxRedirects,
                receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
              ),
            ),
          );
        }
      },
    );

    return responseCompleter.future;
  }
}