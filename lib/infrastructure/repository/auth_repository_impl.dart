import 'package:spendwise_1/domain/datasource/auth_datasource.dart';
import 'package:spendwise_1/domain/entity/auth_user.dart';
import 'package:spendwise_1/domain/repository/auth_repository.dart';
import 'package:spendwise_1/infrastructure/services/token_storage_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Future<AuthUser?> login(String email, String password) async {
    try {
      final token = await _datasource.login(email, password);

      if (token != null) {
        await TokenStorageService.saveToken(token);
        await TokenStorageService.saveEmail(email);

        return AuthUser(email: email, token: token);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthUser?> signup(String name, String email, String password) async {
    try {
      final token = await _datasource.signup(name, email, password);

      if (token != null) {
        await TokenStorageService.saveToken(token);
        await TokenStorageService.saveEmail(email);

        return AuthUser(email: email, token: token);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> getCurrentUser() async {
    try {
      final username = await _datasource.getCurrentUser();
      if (username != null) {
        await TokenStorageService.saveName(username);
      }
      return username;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _datasource.logout();
    await TokenStorageService.clearAll();
  }
}
