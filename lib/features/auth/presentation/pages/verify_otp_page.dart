import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../presentation/providers/auth_provider.dart';

class VerifyOtpPage extends ConsumerStatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  ConsumerState<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends ConsumerState<VerifyOtpPage> {
  final _formKey = GlobalKey<FormState>();
  final pinController = TextEditingController();
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _secondsRemaining = 60;
    _canResend = false;
    Future.delayed(const Duration(seconds: 1), _updateCountdown);
  }

  void _updateCountdown() {
    if (_secondsRemaining > 0) {
      setState(() {
        _secondsRemaining--;
      });
      Future.delayed(const Duration(seconds: 1), _updateCountdown);
    } else {
      setState(() {
        _canResend = true;
      });
    }
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    final pendingPhone = authNotifier.loginPhone ?? authNotifier.registrationPhone;
    final pendingCountryCode =
        authNotifier.loginCountryCode ?? authNotifier.registrationCountryCode;
    final isLoginFlow = authNotifier.loginCountryCode != null && authNotifier.loginPhone != null;
    final hasResendSession = authNotifier.loginSessionId != null || authNotifier.registrationId != null;

    ref.listen(authProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null && context.mounted) {
            context.go('/home');
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('OTP verification failed: $error'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    });

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: Theme.of(context).textTheme.headlineSmall,
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.primary),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: colorScheme.primary, width: 2),
      borderRadius: BorderRadius.circular(12),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: colorScheme.primary.withOpacity(0.1),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(isLoginFlow ? 'Verify Login' : 'Verify Account'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Verify Your ${isLoginFlow ? 'Login' : 'Account'}',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          pendingPhone != null
                              ? 'Enter the 6-digit code sent to $pendingCountryCode$pendingPhone'
                              : 'Enter the 6-digit code sent to your phone',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 28),
                        // OTP Input with Pinput
                        Text(
                          'Enter Verification Code',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Pinput(
                          controller: pinController,
                          length: 6,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                          showCursor: true,
                          onCompleted: (pin) async {
                            await _verifyOtp();
                          },
                          onChanged: (value) {
                            // Auto-verify when 6 digits are entered
                            if (value.length == 6) {
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                _verifyOtp,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 28),
                        // Verify Button
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: authState.isLoading ? null : _verifyOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: authState.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Verify OTP',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Resend OTP Section
                        Center(
                          child: hasResendSession
                              ? _canResend
                                  ? TextButton(
                                      onPressed: _resendOtp,
                                      child: const Text('Resend OTP'),
                                    )
                                  : Text(
                                      'Resend in $_secondsRemaining seconds',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: Colors.grey),
                                    )
                              : Text(
                                  'Cannot resend OTP: no active session',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.red),
                                ),
                        ),
                        const SizedBox(height: 16),
                        // Back Button
                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text(isLoginFlow ? 'Back to login' : 'Back to register'),
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
    );
  }

  Future<void> _verifyOtp() async {
    if (pinController.text.isEmpty || pinController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a 6-digit OTP'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final authNotifier = ref.read(authProvider.notifier);
      final isLoginFlow = authNotifier.loginSessionId != null;

      if (isLoginFlow) {
        await authNotifier.verifyLoginOtp(pinController.text);
      } else {
        await authNotifier.verifyRegisterOtp(pinController.text);
      }
    } catch (e) {
      pinController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;

    try {
      final authNotifier = ref.read(authProvider.notifier);
      final isLoginFlow = authNotifier.loginSessionId != null;

      if (isLoginFlow) {
        await authNotifier.resendLoginOtp();
      } else {
        await authNotifier.resendRegisterOtp();
      }

      _startCountdown();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP has been resent'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to resend OTP: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
