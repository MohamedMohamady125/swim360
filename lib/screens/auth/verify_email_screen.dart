import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  String _code = '';
  bool _isVerifying = false;
  bool _isResending = false;
  String _message = '';
  Color _messageColor = Colors.transparent;

  void _resendCode() async {
    setState(() {
      _isResending = true;
      _message = '';
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isResending = false;
      _message = 'A new code has been sent.';
      _messageColor = Colors.green.shade300;
      _code = '';
    });
  }

  void _verifyCode() async {
    if (_code.length != 6 || !_code.contains(RegExp(r'^\d+$'))) {
      setState(() {
        _message = 'Please enter the complete 6-digit code.';
        _messageColor = Colors.red.shade300;
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _message = '';
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isVerifying = false;
      _message = 'Code verified successfully!';
      _messageColor = Colors.green.shade300;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF24A1F1),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo/Icon
                  const Icon(Icons.pool, size: 64, color: Colors.white),

                  const SizedBox(height: 16),

                  // Title
                  Text(
                    'Enter Reset Code',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'Enter the 6-digit code sent to your email.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // Pinput for code
                  Pinput(
                    length: 6,
                    onChanged: (value) => setState(() => _code = value),
                    defaultPinTheme: PinTheme(
                      height: 56,
                      width: 56,
                      textStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Resend code button
                  TextButton(
                    onPressed: _isResending ? null : _resendCode,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isResending ? 'Sending...' : 'Resend Code',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _isResending
                                ? Colors.grey.shade400
                                : Colors.white,
                          ),
                        ),
                        if (_isResending)
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Message feedback
                  AnimatedOpacity(
                    opacity: _message.isEmpty ? 0 : 1,
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _message,
                      style: TextStyle(
                        fontSize: 14,
                        color: _messageColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Verify button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF24A1F1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 6,
                    ),
                    onPressed: _isVerifying ? null : _verifyCode,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isVerifying ? 'Verifying...' : 'Verify Code',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_isVerifying)
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.grey,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Return to sign-in link
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Return to Sign in',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
