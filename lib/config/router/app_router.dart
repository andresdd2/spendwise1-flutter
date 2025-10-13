import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendwise_1/domain/entity/transaction.dart';
import 'package:spendwise_1/presentation/providers/auth/auth_provider.dart';
import 'package:spendwise_1/presentation/screens/account_screen.dart';
import 'package:spendwise_1/presentation/screens/home_screen.dart';
import 'package:spendwise_1/presentation/screens/login_screen.dart';
import 'package:spendwise_1/presentation/screens/onboarding_screen.dart';
import 'package:spendwise_1/presentation/screens/register_screen.dart';
import 'package:spendwise_1/presentation/screens/signup_screen.dart';
import 'package:spendwise_1/presentation/screens/transaction_screen.dart';
import 'package:spendwise_1/presentation/screens/welcome_screen.dart';
import 'package:spendwise_1/presentation/widgets/shared/navigation_bar_widget.dart';
import 'package:spendwise_1/presentation/widgets/transaction/transaction_detail.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

// Provider del router que depende del estado de autenticación
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final isAuthenticated = authState.isAuthenticated;

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/onboarding',
    // Usa refreshListenable para que el router reaccione a cambios de auth
    refreshListenable: _AuthStateNotifier(ref),
    redirect: (context, state) {
      final currentPath = state.matchedLocation;

      // Rutas públicas que no requieren autenticación
      const publicRoutes = ['/onboarding', '/welcome', '/login', '/signup'];

      final isPublicRoute = publicRoutes.contains(currentPath);

      // Si está autenticado y está en una ruta pública, redirigir a home
      if (isAuthenticated && isPublicRoute) {
        return '/home';
      }

      // Si NO está autenticado y NO está en una ruta pública, redirigir a onboarding
      if (!isAuthenticated && !isPublicRoute) {
        return '/onboarding';
      }

      // Permitir el acceso
      return null;
    },
    routes: [
      // Rutas de autenticación (públicas)
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(path: '/login', 
        builder: (context, state) => const LoginScreen()
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),

      // Rutas protegidas (requieren autenticación)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transaction-screen',
                builder: (context, state) => const TransactionScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account-screen',
                builder: (context, state) => const AccountScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/register-screen',
        builder: (context, state) {
          final transaction = state.extra as Transaction?;
          return RegisterScreen(transactionToEdit: transaction);
        },
      ),
      GoRoute(
        path: '/transaction-detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final transaction = state.extra as Transaction;
          return TransactionDetail(transaction: transaction);
        },
      ),
    ],
  );
});

class _AuthStateNotifier extends ChangeNotifier {
  final Ref _ref;

  _AuthStateNotifier(this._ref) {
    _ref.listen(authProvider, (previous, next) {
      if (previous?.isAuthenticated != next.isAuthenticated) {
        notifyListeners();
      }
    });
  }
}

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const AppShell({super.key, required this.navigationShell});

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBarWidget(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }
}