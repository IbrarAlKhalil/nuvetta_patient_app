import 'package:flutter/material.dart';
// Using a simple network QR generator to avoid package API mismatch
import '../../../../core/security/totp_service.dart';

typedef OnTotpEnrolled = void Function(String secret);

class TotpEnrollWidget extends StatefulWidget {
  final String issuer;
  final String accountName;
  final OnTotpEnrolled onEnrolled;

  const TotpEnrollWidget({
    Key? key,
    required this.issuer,
    required this.accountName,
    required this.onEnrolled,
  }) : super(key: key);

  @override
  State<TotpEnrollWidget> createState() => _TotpEnrollWidgetState();
}

class _TotpEnrollWidgetState extends State<TotpEnrollWidget> {
  late String _secret;
  late String _otpAuthUri;
  final _codeController = TextEditingController();
  String? _status;

  @override
  void initState() {
    super.initState();
    _secret = TotpService.generateSecret();
    _otpAuthUri = TotpService.buildOtpAuthUri(
      secret: _secret,
      issuer: widget.issuer,
      accountName: widget.accountName,
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verify() {
    final code = _codeController.text.trim();
    final ok = TotpService.verifyCode(secret: _secret, code: code);
    setState(() {
      _status = ok ? 'Verified' : 'Invalid code';
    });
    if (ok) widget.onEnrolled(_secret);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Image.network(
            'https://api.qrserver.com/v1/create-qr-code/?data=${Uri.encodeComponent(_otpAuthUri)}&size=200x200',
            width: 200,
            height: 200,
          ),
        ),
        const SizedBox(height: 12),
            SelectableText('Secret: $_secret'),
        const SizedBox(height: 12),
        TextField(
          controller: _codeController,
          decoration: const InputDecoration(
            labelText: 'Enter code from authenticator',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: _verify, child: const Text('Verify & Enroll')),
        if (_status != null) ...[
          const SizedBox(height: 8),
          Text(_status!, style: TextStyle(color: _status == 'Verified' ? Colors.green : Colors.red)),
        ],
      ],
    );
  }
}
