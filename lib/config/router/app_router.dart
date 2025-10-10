import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spendwise_1/domain/entity/transaction.dart';
import 'package:spendwise_1/presentation/screens/account_screen.dart';
import 'package:spendwise_1/presentation/screens/home_screen.dart';
import 'package:spendwise_1/presentation/screens/register_screen.dart';
import 'package:spendwise_1/presentation/screens/transaction_screen.dart';
import 'package:spendwise_1/presentation/widgets/shared/navigation_bar_widget.dart';
import 'package:spendwise_1/presentation/widgets/transaction/transaction_detail.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
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
