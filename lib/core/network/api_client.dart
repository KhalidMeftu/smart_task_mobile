import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.8.126:8000/api',
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
  ));

  ApiClient() {
    _initializeAuthToken();
  }

  Future<void> _initializeAuthToken() async {
    final token = await getAuthToken();
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<void> setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Response> get(String path) async {
    try {
      final token = await getAuthToken();
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }
      return await _dio.get(path);
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
   // try {
      _dio.interceptors.add(PrettyDioLogger());

    final token = await getAuthToken();
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }
      print("EDITING TASK");
      print(path);
      print(data.toString());
      return await _dio.post(path, data: data);
    //} catch (e) {
    //  throw Exception("Error posting data: $e");
    //}
  }

  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    try {
      final token = await getAuthToken();
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }
      return await _dio.put(path, data: data);
    } catch (e) {
      throw Exception("Error updating data: $e");
    }
  }

  Future<Response> delete(String path) async {
    try {
      final token = await getAuthToken();
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }
      return await _dio.delete(path);
    } catch (e) {
      throw Exception("Error deleting data: $e");
    }
  }
}
