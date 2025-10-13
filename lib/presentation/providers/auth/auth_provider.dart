import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise_1/infrastructure/datasource/auth_datasource_impl.dart';
import 'package:spendwise_1/infrastructure/repository/auth_repository_impl.dart';
import 'package:spendwise_1/presentation/providers/auth/auth_notifier.dart';
import 'package:spendwise_1/presentation/providers/auth/auth_state.dart';

final authDatasourceProvider = Provider((ref) {
  return AuthDatasourceImpl();
});

final authRepositoryProvider = Provider((ref) {
  final datasource = ref.watch(authDatasourceProvider);
  return AuthRepositoryImpl(datasource);
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});