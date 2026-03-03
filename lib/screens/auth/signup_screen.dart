import 'package:flutter/material.dart';
import 'package:swim360/screens/home/main_navigation.dart';
import 'package:swim360/core/services/auth_service.dart';
import 'package:swim360/core/models/auth/signup_request.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  late AnimationController _animationController;
  final List<Animation<double>> _animations = [];
  bool _isLoading = false;

  int _passwordStrength = 0; // 0=None, 1=Weak, 2=Fair, 3=Strong
  String _strengthText = 'None';
  Color _strengthColor = const Color(0xFFE2E8F0);
  Color _strengthTextColor = const Color(0xFFD1D5DB);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // Create staggered animations for 9 items (delay-0 through delay-8)
    for (int i = 0; i < 9; i++) {
      _animations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              i * 0.1,
              0.6 + (i * 0.1),
              curve: Curves.easeOutCubic,
            ),
          ),
        ),
      );
    }

    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
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
        final hasNumbers = RegExp(r'\d').hasMatch(password);
        final hasLetters = RegExp(r'[a-zA-Z]').hasMatch(password);
        final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
        final hasSymbols = RegExp(r'[!@#$%^&*()_+\-=\[\]{};:\\|,.<>\/?]').hasMatch(password);

        if (hasLetters && hasNumbers && hasUppercase && hasSymbols) {
          _passwordStrength = 3; // Strong
          _strengthText = 'Strong';
          _strengthColor = const Color(0xFF10B981);
          _strengthTextColor = const Color(0xFF10B981);
        } else if ((hasLetters && hasNumbers) || hasUppercase) {
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

  Future<void> _handleSignup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.split(RegExp(r'\s+')).length < 2) {
      _showToast('Enter First & Last Name', isError: true);
      return;
    }

    if (password != confirmPassword) {
      _showToast('Passwords do not match', isError: true);
      return;
    }

    if (_strengthText == 'Weak' || _strengthText == 'None') {
      _showToast('Password is too weak', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = SignupRequest(
        email: email,
        password: password,
        fullName: name,
      );

      final response = await _authService.signup(request);

      if (!mounted) return;

      if (response.success) {
        _showToast('Account Created Successfully!');

        // Navigate to main app
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainNavigation()),
        );
      } else {
        _showToast(response.error ?? 'Signup failed. Please try again.', isError: true);
      }
    } catch (e) {
      if (mounted) {
        _showToast('An error occurred: ${e.toString()}', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
          _buildAnimatedItem(0, _buildIcon()),
          const SizedBox(height: 24),
          _buildAnimatedItem(1, _buildTitle()),
          const SizedBox(height: 12),
          _buildAnimatedItem(2, _buildSubtitle()),
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
      'CREATE ACCOUNT',
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
      'JOIN THE SWIM 360 COMMUNITY',
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: const Color(0xFF9CA3AF),
        letterSpacing: 2.0,
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
          _buildAnimatedItem(3, _buildTextField(
            controller: _nameController,
            label: 'FULL NAME',
            hint: 'John Doe',
            icon: Icons.person_outline,
            textCapitalization: TextCapitalization.words,
          )),
          const SizedBox(height: 20),
          _buildAnimatedItem(4, _buildTextField(
            controller: _emailController,
            label: 'EMAIL ADDRESS',
            hint: 'you@example.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          )),
          const SizedBox(height: 20),
          _buildAnimatedItem(5, _buildPasswordFieldWithStrength()),
          const SizedBox(height: 20),
          _buildAnimatedItem(6, _buildTextField(
            controller: _confirmPasswordController,
            label: 'CONFIRM PASSWORD',
            hint: '••••••••',
            icon: Icons.shield_outlined,
            obscureText: true,
          )),
          const SizedBox(height: 16),
          _buildAnimatedItem(7, _buildSignupButton()),
          const SizedBox(height: 40),
          _buildAnimatedItem(8, _buildLoginPrompt()),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
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
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: const Color(0xFFD1D5DB),
                fontWeight: FontWeight.w700,
              ),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFFD1D5DB),
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

  Widget _buildPasswordFieldWithStrength() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            'PASSWORD',
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
            controller: _passwordController,
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
                    'SECURITY LEVEL',
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

  Widget _buildSignupButton() {
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
        onPressed: _isLoading ? null : _handleSignup,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'CREATE ACCOUNT',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.8,
                ),
              ),
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'ALREADY HAVE AN ACCOUNT? ',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF9CA3AF),
            letterSpacing: 2.5,
            height: 1.0,
          ),
        ),
        GestureDetector(
          onTap: () {
            // Navigate back to login
            Navigator.of(context).pop();
          },
          child: Text(
            'SIGN IN',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF2563EB),
              letterSpacing: 2.5,
              decoration: TextDecoration.underline,
              decorationColor: const Color(0xFF2563EB),
              height: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedItem(int index, Widget child) {
    return FadeTransition(
      opacity: _animations[index],
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(_animations[index]),
        child: child,
      ),
    );
  }
}
