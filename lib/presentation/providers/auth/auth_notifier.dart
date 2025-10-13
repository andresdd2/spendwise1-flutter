import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/domain/repository/auth_repository.dart';
import 'package:spendwise_1/infrastructure/services/token_storage_service.dart';
import 'package:spendwise_1/presentation/providers/auth/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState(isAuthenticated: false)) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      final hasToken = await TokenStorageService.hasToken();
      final userEmail = await TokenStorageService.getEmail();

      if (hasToken && userEmail != null) {
        state = AuthState(
          isAuthenticated: true,
          userEmail: userEmail,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      final user = await _repository.login(email, password);

      if (user != null) {
        state = AuthState(
          isAuthenticated: true,
          userEmail: user.email,
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(isLoading: false);
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      final user = await _repository.signup(name, email, password);

      if (user != null) {
        state = AuthState(
          isAuthenticated: true,
          userEmail: user.email,
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(isLoading: false);
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthState(isAuthenticated: false);
  }

  Future<String?> getToken() async {
    return await TokenStorageService.getToken();
  }

  Future<void> refreshUserInfo() async {
    try {
      final username = await _repository.getCurrentUser();
      state = state.copyWith(username: username);
    } catch (e) {
      print('Error refrescando usuario: $e');
    }
  }
}
