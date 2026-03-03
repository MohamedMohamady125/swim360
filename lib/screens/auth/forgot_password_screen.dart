import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _statusMessage;
  bool _showStatus = false;
  late AnimationController _animationController;
  final List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Create staggered animations for 6 items (delay-0 through delay-5)
    for (int i = 0; i < 6; i++) {
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
    _emailController.dispose();
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

  Future<void> _handleReset() async {
    final email = _emailController.text.trim();

    if (!email.contains('@')) {
      _showToast('Invalid email address', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
      _showStatus = false;
    });

    // Simulate network delay (2 seconds)
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _showStatus = true;
        _statusMessage = 'A 6 digit code has been sent!';
      });
      _showToast('Reset code sent!');
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
          const SizedBox(height: 16),
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
      'FORGOT PASSWORD?',
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        "Don't worry, it happens to everyone. Enter your email and we'll send you a reset link.",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF9CA3AF),
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAnimatedItem(3, _buildEmailField()),
          const SizedBox(height: 24),
          _buildAnimatedItem(4, _buildStatusMessage()),
          const SizedBox(height: 24),
          _buildAnimatedItem(5, _buildSubmitButton()),
          const SizedBox(height: 40),
          _buildAnimatedItem(5, _buildBackButton()),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'EMAIL ADDRESS',
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
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              hintText: 'you@example.com',
              hintStyle: TextStyle(
                color: const Color(0xFFD1D5DB),
                fontWeight: FontWeight.w700,
              ),
              prefixIcon: const Icon(
                Icons.email_outlined,
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

  Widget _buildStatusMessage() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _showStatus ? null : 20,
      child: _showStatus
          ? Center(
              child: Text(
                _statusMessage?.toUpperCase() ?? '',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF10B981),
                  letterSpacing: 2.5,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : const SizedBox(height: 20),
    );
  }

  Widget _buildSubmitButton() {
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
        onPressed: _isLoading ? null : _handleReset,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          disabledBackgroundColor: const Color(0xFF2563EB).withOpacity(0.5),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6B7280)),
                ),
              )
            : Text(
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
