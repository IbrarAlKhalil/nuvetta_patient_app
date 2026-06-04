import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:nuveta_patient_app/core/security/totp_storage.dart';
import 'package:nuveta_patient_app/core/utils/validators.dart';
import 'package:nuveta_patient_app/features/auth/presentation/providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final combinedPhoneController = TextEditingController();
  final passwordController = TextEditingController();
  final _passwordFocus = FocusNode();
  bool _obscure = true;

  @override
  void dispose() {
    combinedPhoneController.dispose();
    passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen(authProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed: $error'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF0B3C5D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Card(
                  elevation: 18,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: SvgPicture.asset(
                              'assets/novetta_logo.svg',
                              height: 76,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Welcome Back',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sign in to continue with your phone and password',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(0.75),
                                ),
                          ),
                          const SizedBox(height: 28),
                          TextFormField(
                            controller: combinedPhoneController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.telephoneNumber],
                            onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.phone_outlined),
                              labelText: 'Phone Number',
                              hintText: '+1 555 123 4567',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter your phone number';
                              }
                              if (!Validators.isValidPhone(value.trim())) {
                                return 'Enter a valid phone number, e.g. +1 5551234567';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: passwordController,
                            focusNode: _passwordFocus,
                            obscureText: _obscure,
                            keyboardType: TextInputType.visiblePassword,
                            enableSuggestions: false,
                            autocorrect: false,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline),
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                            ),
                            onFieldSubmitted: (_) {
                              if (!authState.isLoading) {
                                _submit();
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: authState.isLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: authState.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'Continue',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => context.go('/forgot-password'),
                            child: const Text('Forgot password?'),
                          ),
                          const SizedBox(height: 4),
                          TextButton(
                            onPressed: () => context.go('/register'),
                            child: const Text(
                              "Don't have an account? Register",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final parsedPhone = Validators.parsePhoneNumber(combinedPhoneController.text.trim());
    if (parsedPhone == null) return;

    try {
      final requiresOtp = await ref.read(authProvider.notifier).loginWithPassword(
            parsedPhone['countryCode']!,
            parsedPhone['phone']!,
            passwordController.text,
          );

      if (!mounted) return;
      if (requiresOtp) {
        context.go('/verify-otp');
      } else {
        final localSecret = await TotpStorage.getSecret();
        if (localSecret != null) {
          context.go('/totp-verify');
        } else {
          context.go('/home');
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

}
