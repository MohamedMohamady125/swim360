import 'package:flutter/material.dart';

class PassResetScreen extends StatefulWidget {
  const PassResetScreen({Key? key}) : super(key: key);

  @override
  State<PassResetScreen> createState() => _PassResetScreenState();
}

class _PassResetScreenState extends State<PassResetScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int _passwordStrength = 0; // 0=None, 1=Weak, 2=Fair, 3=Strong
  String _strengthText = 'None';
  Color _strengthColor = const Color(0xFFE2E8F0);
  Color _strengthTextColor = const Color(0xFFD1D5DB);

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showToast(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: isError ? const Color(0xFFE11D48) : const Color(0xFF111827),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _updatePasswordStrength(String password) {
    setState(() {
      if (password.length >= 8) {
        final hasLetters = RegExp(r'[a-zA-Z]').hasMatch(password);
        final hasNumbers = RegExp(r'[0-9]').hasMatch(password);
        final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
        final hasSymbols = RegExp(r'[^A-Za-z0-9]').hasMatch(password);

        if (hasLetters && hasNumbers && hasUppercase && hasSymbols) {
          _passwordStrength = 3; // Strong
          _strengthText = 'Strong';
          _strengthColor = const Color(0xFF10B981);
          _strengthTextColor = const Color(0xFF10B981);
        } else if (hasLetters && hasNumbers) {
          _passwordStrength = 2; // Fair
          _strengthText = 'Fair';
          _strengthColor = const Color(0xFFFACC15);
          _strengthTextColor = const Color(0xFFFACC15);
        } else {
          _passwordStrength = 1; // Weak
          _strengthText = 'Weak';
          _strengthColor = const Color(0xFFF43F5E);
          _strengthTextColor = const Color(0xFFF43F5E);
        }
      } else if (password.isNotEmpty) {
        _passwordStrength = 1;
        _strengthText = 'Weak';
        _strengthColor = const Color(0xFFF43F5E);
        _strengthTextColor = const Color(0xFFF43F5E);
      } else {
        _passwordStrength = 0;
        _strengthText = 'None';
        _strengthColor = const Color(0xFFE2E8F0);
        _strengthTextColor = const Color(0xFFD1D5DB);
      }
    });
  }

  void _handleReset() {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      _showToast('Passwords do not match', isError: true);
      return;
    }

    if (_strengthText == 'Weak' || _strengthText == 'None') {
      _showToast('Password too weak', isError: true);
      return;
    }

    _showToast('Password Reset Successful!');
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2563EB),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 448),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
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
          _buildIcon(),
          const SizedBox(height: 24),
          _buildTitle(),
          const SizedBox(height: 12),
          _buildSubtitle(),
          const SizedBox(height: 32),
          _buildForm(),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
            spreadRadius: 0,
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: const Icon(
        Icons.waves,
        color: Color(0xFF2563EB),
        size: 40,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'NEW PASSWORD',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w900,
        color: const Color(0xFF111827),
        letterSpacing: -0.5,
        fontStyle: FontStyle.italic,
        height: 1.0,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'SECURE YOUR CREDENTIALS',
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: const Color(0xFF9CA3AF),
        letterSpacing: 3.0,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDisabledEmailField(),
          const SizedBox(height: 20),
          _buildPasswordFieldWithStrength(),
          const SizedBox(height: 20),
          _buildConfirmPasswordField(),
          const SizedBox(height: 16),
          _buildResetButton(),
          const SizedBox(height: 32),
          _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildDisabledEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            'ACCOUNT EMAIL',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF9CA3AF),
              letterSpacing: 2.5,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB).withOpacity(0.5),
            border: Border.all(color: const Color(0xFFF3F4F6)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'user@example.com',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordFieldWithStrength() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            'NEW PASSWORD',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF9CA3AF),
              letterSpacing: 2.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
                spreadRadius: 0,
                blurStyle: BlurStyle.inner,
              ),
            ],
          ),
          child: TextFormField(
            controller: _newPasswordController,
            obscureText: true,
            onChanged: _updatePasswordStrength,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: TextStyle(
                color: const Color(0xFFD1D5DB),
                fontWeight: FontWeight.w700,
              ),
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: Color(0xFFD1D5DB),
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF2563EB),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'STRENGTH',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF9CA3AF),
                      letterSpacing: 2.5,
                    ),
                  ),
                  Text(
                    _strengthText.toUpperCase(),
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      color: _strengthTextColor,
                      letterSpacing: 2.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: AnimatedFractionallySizedBox(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  widthFactor: _passwordStrength == 0 ? 0 :
                             _passwordStrength == 1 ? 0.33 :
                             _passwordStrength == 2 ? 0.66 : 1.0,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _strengthColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            'CONFIRM PASSWORD',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF9CA3AF),
              letterSpacing: 2.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
                spreadRadius: 0,
                blurStyle: BlurStyle.inner,
              ),
            ],
          ),
          child: TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: TextStyle(
                color: const Color(0xFFD1D5DB),
                fontWeight: FontWeight.w700,
              ),
              prefixIcon: const Icon(
                Icons.shield_outlined,
                color: Color(0xFFD1D5DB),
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF2563EB),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResetButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _handleReset,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
        child: Text(
          'RESET PASSWORD',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.8,
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text(
        'RETURN TO SIGN IN',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF2563EB),
          letterSpacing: 2.5,
          decoration: TextDecoration.underline,
          decorationColor: const Color(0xFF2563EB),
        ),
      ),
    );
  }
}
