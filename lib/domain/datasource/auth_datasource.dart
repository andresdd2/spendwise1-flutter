abstract class AuthDatasource {
  Future<String?> login(String email, String password);
  Future<String?> signup(String name, String email, String password);
  Future<void> logout();
  Future<String?> getCurrentUser();
}