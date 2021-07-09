import 'package:dio/dio.dart';

class GetData{
  final Dio dio;

  GetData({required this.dio});

  Future<String> fetchApi() async {
    final Response response = await dio.get('https://jsonplaceholder.typicode.com/posts/1');
    if(response.statusCode == 200){
      return response.data['body'];
    }
    throw Exception();
  }
}