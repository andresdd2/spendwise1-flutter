import 'package:dio/dio.dart';
import 'package:spendwise_1/domain/datasource/auth_datasource.dart';
import 'package:spendwise_1/infrastructure/dio/dio_client.dart';

class AuthDatasourceImpl implements AuthDatasource {
  final Dio _dio;

  final Dio _authDio;

  AuthDatasourceImpl()
    : _dio = DioClient.instance,
      _authDio = Dio(
        BaseOptions(
          baseUrl: DioClient.instance.options.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

  @override
  Future<String?> login(String email, String password) async {
    try {
      final response = await _authDio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['access_token'] as String?;
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Credenciales inválidas');
      }
      throw Exception('Error de conexión: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<String?> signup(String name, String email, String password) async {
    try {
      final response = await _authDio.post(
        '/auth/signup',
        data: {'username': name, 'email': email, 'password': password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return await login(email, password);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception('El email ya está registrado');
      }
      if (e.response?.statusCode == 400) {
        throw Exception('Datos inválidos. Verifica la información.');
      }
      throw Exception('Error de conexión: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<String?> getCurrentUser() async {
    try {
      final response = await _dio.get('/auth/me');

      if (response.statusCode == 200) {
        return response.data['username'] as String?;
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('No autorizado');
      }
      throw Exception('Error al obtener usuario: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<void> logout() async {
    return;
  }
}