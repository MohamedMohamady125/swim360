import 'package:flutter/material.dart';

class PassResetScreen extends StatefulWidget {
  final String email;
  const PassResetScreen({Key? key, this.email = 'user@example.com'}) : super(key: key);

  @override
  State<PassResetScreen> createState() => _PassResetScreenState();
}

class _PassResetScreenState extends State<PassResetScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  String _message = '';
  Color _messageColor = Colors.transparent;
  double _strengthWidth = 0.0;
  Color _strengthColor = Colors.grey;
  String _strengthText = '';

  void _checkPasswordStrength(String password) {
    String strength = 'none';
    if (password.length < 8) {
      strength = 'weak';
    } else {
      final hasNumbers = RegExp(r'\d').hasMatch(password);
      final hasLetters = RegExp(r'[a-zA-Z]').hasMatch(password);
      final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
      final hasSymbols = RegExp(r'[!@#\$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]').hasMatch(password);
      if (hasLetters && hasNumbers && hasUppercase && hasSymbols) {
        strength = 'strong';
      } else if ((hasLetters && !hasNumbers && !hasSymbols) || (!hasLetters && hasNumbers && !hasSymbols)) {
        strength = 'weak';
      } else if ((hasLetters && hasNumbers) || hasUppercase) {
        strength = 'fair';
      } else {
        strength = 'weak';
      }
    }
    setState(() {
      switch (strength) {
        case 'strong':
          _strengthWidth = 1.0;
          _strengthColor = Colors.green[300]!;
          _strengthText = 'Strong';
          break;
        case 'fair':
          _strengthWidth = 0.66;
          _strengthColor = Colors.yellow[300]!;
          _strengthText = 'Fair';
          break;
        case 'weak':
          _strengthWidth = 0.33;
          _strengthColor = Colors.red[300]!;
          _strengthText = 'Weak';
          break;
        default:
          _strengthWidth = 0.0;
          _strengthColor = Colors.grey;
          _strengthText = '';
      }
    });
  }

  void _handleReset() async {
    setState(() {
      _message = '';
    });
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;
    if (newPassword.length < 8) {
      setState(() {
        _message = 'Password must be at least 8 characters long.';
        _messageColor = Colors.red[300]!;
      });
      return;
    }
    if (newPassword != confirmPassword) {
      setState(() {
        _message = 'Passwords do not match. Please try again.';
        _messageColor = Colors.red[300]!;
      });
      return;
    }
    if (_strengthText == 'Weak' || _strengthText == '') {
      setState(() {
        _message = 'Password is too weak. Please choose a stronger password.';
        _messageColor = Colors.red[300]!;
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _message = 'Password has been reset successfully!';
      _messageColor = Colors.green[300]!;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF24A1F1),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 384),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFF24A1F1),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Container(
                  width: 64,
                  height: 64,
                  margin: const EdgeInsets.only(bottom: 24),
                  child: const Icon(Icons.pool, size: 64, color: Colors.white),
                ),
                // Title
                const Text(
                  'Swim 360',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create your new password.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Email display (editable)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email Address',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: widget.email,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'you@example.com',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.email_outlined, color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // New Password
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'New Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: !_isNewPasswordVisible,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isNewPasswordVisible ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isNewPasswordVisible = !_isNewPasswordVisible;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onChanged: _checkPasswordStrength,
                    ),
                  ],
                ),
                // Password Strength Indicator
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: _strengthWidth,
                            child: Container(
                              decoration: BoxDecoration(
                                color: _strengthColor,
                                borderRadius: BorderRadius.circular(9999),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _strengthText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Confirm Password
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Confirm New Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
                // Message box
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    _message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _messageColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Reset Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleReset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF24A1F1),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 5,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.grey,
                            ),
                          )
                        : const Text(
                            'Reset Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
                // Return to Sign in link
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Return to Sign in',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
