import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_auto_retry/interceptor/custom_interceptors.dart';
import 'package:dio_auto_retry/interceptor/dio_connectivity_request_retrier.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String text;
  late bool isLoading;

  late Dio dio;

  late Connectivity connectivity;

  @override
  void initState() {
    super.initState();

    dio = Dio();
    text = 'Press the button 👇';
    isLoading = false;
    connectivity = Connectivity();

    dio.interceptors.add(CustomInterceptors(requestRetrier: DioConnectivityRequestRetrier(dio: dio, connectivity: connectivity)));

    // dio.interceptors.add(InterceptorsWrapper(
    //     onRequest:(options, handler){
    //       // Do something before request is sent
    //       return handler.next(options); //continue
    //       // If you want to resolve the request with some custom data，
    //       // you can resolve a `Response` object eg: return `dio.resolve(response)`.
    //       // If you want to reject the request with a error message,
    //       // you can reject a `DioError` object eg: return `dio.reject(dioError)`
    //     },
    //     onResponse:(response,handler) {
    //       // Do something with response data
    //       //print('response ${response.data}');
    //       return handler.next(response); // continue
    //       // If you want to reject the request with a error message,
    //       // you can reject a `DioError` object eg: return `dio.reject(dioError)`
    //     },
    //     onError: (DioError e, handler) async {
    //       // Do something with response error
    //       try{
    //         return handler.resolve(await DioConnectivityRequestRetrier(
    //           dio: dio,
    //           connectivity: connectivity,
    //         ).scheduleRequestRetry(e.requestOptions));
    //       }
    //       catch(ex){
    //         return  handler.next(e);//continue
    //       }
    //       // If you want to resolve the request with some custom data，
    //       // you can resolve a `Response` object eg: return `dio.resolve(response)`.
    //     }
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(isLoading)
                CircularProgressIndicator()
              else
                Text(text),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final Response response = await dio.get('https://jsonplaceholder.typicode.com/posts/1');
                  if(response.statusCode == 200){
                    setState(() {
                      text = response.data['body'];
                      isLoading = false;
                    });
                  }
                },
                child: Text('Get'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
