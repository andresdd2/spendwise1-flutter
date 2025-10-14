import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendwise_1/config/theme/app_palette.dart';
import 'package:spendwise_1/presentation/providers/auth/auth_provider.dart';
import 'package:spendwise_1/presentation/widgets/inputs/custom_text_form_field.dart';

class CustomLoginForm extends ConsumerStatefulWidget {
  const CustomLoginForm({super.key});

  @override
  ConsumerState<CustomLoginForm> createState() => _CustomLoginFormState();
}

class _CustomLoginFormState extends ConsumerState<CustomLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final success = await ref
            .read(authProvider.notifier)
            .login(_emailController.text.trim(), _passwordController.text);

        if (!mounted) return;

        if (success) {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('¡Bienvenido de nuevo!'),
              backgroundColor: AppPalette.cAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;

        String errorMessage = 'Error al iniciar sesión';

        if (e.toString().contains('Credenciales inválidas')) {
          errorMessage = 'Email o contraseña incorrectos';
        } else if (e.toString().contains('Error de conexión')) {
          errorMessage = 'No se pudo conectar al servidor';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            action: SnackBarAction(
              label: 'Reintentar',
              textColor: Colors.white,
              onPressed: _handleLogin,
            ),
          ),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppPalette.cText,
            ),
          ),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: 'correo@gmail.com',
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu email';
              }
              if (!value.contains('@')) {
                return 'Ingresa un email válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Contraseña',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppPalette.cText,
            ),
          ),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            hintText: 'password',
            textInputAction: TextInputAction.done,
            enabled: !_isLoading,
            onFieldSubmitted: (_) => _handleLogin(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu contraseña';
              }
              if (value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppPalette.cComponent3,
              ),
              onPressed: _isLoading
                  ? null
                  : () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppPalette.cAccent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppPalette.cAccent.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¿No tienes una cuenta? ',
                style: TextStyle(fontSize: 16, color: AppPalette.cText),
              ),
              TextButton(
                onPressed: _isLoading ? null : () => context.push('/signup'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Regístrate',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppPalette.cAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}