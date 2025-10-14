import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendwise_1/domain/entity/transaction.dart';
import 'package:spendwise_1/presentation/providers/auth/auth_provider.dart';
import 'package:spendwise_1/presentation/providers/auth/auth_state.dart';
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

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(this._ref) {
    _ref.listen<AuthState>(authProvider, (previous, next) {
      if (previous?.isAuthenticated != next.isAuthenticated) {
        notifyListeners();
      }
    });
  }

  final Ref _ref;
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _GoRouterRefreshStream(ref);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    refreshListenable: notifier,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isAuthenticated = authState.isAuthenticated;
      final isLoading = authState.isLoading;
      final location = state.matchedLocation;

      const publicRoutes = ['/onboarding', '/welcome', '/login', '/signup'];
      final isPublicRoute = publicRoutes.contains(location);

      if (isLoading) {
        return null;
      }

      if (isAuthenticated && isPublicRoute) {
        return '/home';
      }

      if (!isAuthenticated && !isPublicRoute) {
        return '/onboarding';
      }

      return null;
    },
    routes: [
      
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/welcome',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const WelcomeScreen()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const LoginScreen()),
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const SignupScreen()),
      ),

    
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) {
          return NoTransitionPage(
            child: AppShell(navigationShell: navigationShell),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transaction-screen',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const TransactionScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account-screen',
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const AccountScreen(),
                ),
              ),
            ],
          ),
        ],
      ),

    
      GoRoute(
        path: '/register-screen',
        pageBuilder: (context, state) {
          final transaction = state.extra as Transaction?;
          return MaterialPage(
            key: state.pageKey,
            child: RegisterScreen(transactionToEdit: transaction),
          );
        },
      ),
      GoRoute(
        path: '/transaction-detail',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final transaction = state.extra as Transaction;
          return MaterialPage(
            key: state.pageKey,
            child: TransactionDetail(transaction: transaction),
          );
        },
      ),
    ],


    initialLocation: '/onboarding',

    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
});


class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const AppShell({super.key, required this.navigationShell});

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
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