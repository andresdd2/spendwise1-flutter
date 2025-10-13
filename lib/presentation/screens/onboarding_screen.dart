import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Controla tus Gastos',
      description:
          'Registra y visualiza todos tus ingresos y gastos de manera sencilla',
      icon: Icons.wallet_outlined,
    ),
    OnboardingPage(
      title: 'Análisis Detallado',
      description:
          'Obtén gráficos y reportes detallados de tus finanzas personales',
      icon: Icons.analytics_outlined,
    ),
    OnboardingPage(
      title: 'Alcanza tus Metas',
      description: 'Establece presupuestos y alcanza tus objetivos financieros',
      icon: Icons.trending_up_outlined,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.cBackground,

      // ---- CONTENIDO ----
      body: SafeArea(
        child: Column(
          children: [
            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => _buildPage(_pages[index]),
              ),
            ),

            // Dots + (opcional) Saltar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, _buildDot),
                  ),
                  const SizedBox(height: 8),
                  Opacity(
                    opacity: _currentPage < _pages.length - 1 ? 1 : 0,
                    child: IgnorePointer(
                      ignoring: _currentPage == _pages.length - 1,
                      child: TextButton(
                        onPressed: () => context.go('/welcome'),
                        child: Text(
                          'Saltar',
                          style: TextStyle(
                            color: AppPalette.cText.withOpacity(0.6),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ---- BOTÓN FIJO ABAJO ----
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(24),
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_currentPage == _pages.length - 1) {
                context.go('/welcome');
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.cAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Text(
              _currentPage == _pages.length - 1 ? 'Comenzar' : 'Siguiente',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppPalette.cAccent.withAlpha(1),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 100, color: AppPalette.cAccent),
          ),
          const SizedBox(height: 48),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppPalette.cText,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppPalette.grisClaro,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 50),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? AppPalette.cAccent
            : AppPalette.cText.withAlpha(3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
  });
}