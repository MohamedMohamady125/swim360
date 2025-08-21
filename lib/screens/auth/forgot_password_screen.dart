import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();

  late AnimationController _cardController;
  late Animation<double> _cardAnimation;
  late AnimationController _itemsController;
  late List<Animation<double>> _itemAnimations;

  bool _isLoading = false;
  String _message = '';
  Color _messageColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _cardController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _itemsController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));

    _cardAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOut),
    );

    _itemAnimations = List.generate(6, (index) {
      final start = (index * 0.15);
      final end = math.min(start + 0.4, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _itemsController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });
  }

  void _startAnimations() {
    _cardController.forward();
    _itemsController.forward();
  }

  void _showMessage(String message, {bool success = false}) {
    setState(() {
      _message = message;
      _messageColor = success ? Colors.green[300]! : Colors.red[300]!;
    });
  }

  void _handleReset() {
    final email = _emailController.text.trim();

    // Clear previous message
    setState(() {
      _message = '';
    });

    if (!email.contains('@') || !email.contains('.')) {
      _showMessage('Please enter a valid email address.', success: false);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate network request
    Future.delayed(const Duration(seconds: 2), () {
      _showMessage(
        'A 6 digit code has been sent to your email.',
        success: true,
      );

      // Reset button state after short delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    });
  }

  Widget _buildAnimatedItem(Widget child, int index) {
    return AnimatedBuilder(
      animation: _itemAnimations[index],
      builder: (_, __) => Transform.translate(
        offset: Offset(0, 20 * (1 - _itemAnimations[index].value)),
        child: Opacity(
          opacity: _itemAnimations[index].value,
          child: child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cardController.dispose();
    _itemsController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: AnimatedBuilder(
              animation: _cardAnimation,
              builder: (_, child) => Transform.translate(
                offset: Offset(0, 20 * (1 - _cardAnimation.value)),
                child: Opacity(opacity: _cardAnimation.value, child: child),
              ),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 384),
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
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
                  children: [
                    _buildAnimatedItem(
                      const Icon(Icons.pool, size: 64, color: Colors.white),
                      0,
                    ),
                    const SizedBox(height: 16),
                    _buildAnimatedItem(
                      const Text(
                        'Forgot your password?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      1,
                    ),
                    const SizedBox(height: 8),
                    _buildAnimatedItem(
                      const Text(
                        "Don't worry, it happens to everyone. Enter your email and we'll send you a reset link.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      2,
                    ),
                    const SizedBox(height: 24),
                    _buildAnimatedItem(
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
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'you@example.com',
                              prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.white, width: 2),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                      3,
                    ),
                    const SizedBox(height: 16),
                    // Message feedback box
                    _buildAnimatedItem(
                      Text(
                        _message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _messageColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      4,
                    ),
                    const SizedBox(height: 16),
                    _buildAnimatedItem(
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
                      5,
                    ),
                    const SizedBox(height: 24),
                    _buildAnimatedItem(
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Return to Sign in',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
