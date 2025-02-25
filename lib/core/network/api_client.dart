import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final String baseUrl;
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ApiClient({required this.baseUrl}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 180),
      receiveTimeout: const Duration(seconds: 180),
    ));
    _dio.interceptors.add(PrettyDioLogger());
    _initializeAuthToken();
  }

  Future<void> _initializeAuthToken() async {
    final token = await getAuthToken();
    if (token != null) {
      _setAuthHeader(token);
    }
  }

  void _setAuthHeader(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<void> setAuthToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
    _setAuthHeader(token);
  }

  Future<void> setUserID(String userId) async {
    await _secureStorage.write(key: 'user_id', value: userId);
  }

  Future<String?> getUserID() async {
    String? savedUserID = await _secureStorage.read(key: 'user_id');
    return savedUserID;
  }

  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  Future<void> clearAuthToken() async {
    await _secureStorage.delete(key: 'auth_token');
    _dio.options.headers.remove('Authorization');
  }

  Future<Response> get(String path) async => _performRequest(() => _dio.get(path));

  Future<Response> post(String path, {Map<String, dynamic>? data}) async =>
      _performRequest(() => _dio.post(path, data: data));

  Future<Response> put(String path, {Map<String, dynamic>? data}) async =>
      _performRequest(() => _dio.put(path, data: data));

  Future<Response> delete(String path) async =>
      _performRequest(() => _dio.delete(path));

  Future<Response> _performRequest(Future<Response> Function() request) async {
    try {
      return await request();
    } catch (e) {
      throw Exception("Network error: $e");
    }
  }
}
