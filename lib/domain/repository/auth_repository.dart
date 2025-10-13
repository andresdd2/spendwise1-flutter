import 'package:spendwise_1/domain/entity/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser?> login(String email, String password);
  Future<AuthUser?> signup(String name, String email, String password);
  Future<void> logout();
  Future<String?> getCurrentUser();
}