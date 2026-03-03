import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  bool _isVerifying = false;
  bool _isResending = false;
  String? _statusMessage;
  bool _showStatus = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _handleResend() async {
    setState(() {
      _isResending = true;
      _showStatus = false;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isResending = false;
        _showStatus = true;
        _statusMessage = 'New code sent to your email!';
      });
    }
  }

  Future<void> _handleVerify() async {
    setState(() {
      _isVerifying = true;
      _showStatus = false;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isVerifying = false;
        _showStatus = true;
        _statusMessage = 'Success! Identity Confirmed.';
      });
    }
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _onOtpKeyEvent(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
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
          _buildIcon(),
          const SizedBox(height: 24),
          _buildTitle(),
          const SizedBox(height: 12),
          _buildSubtitle(),
          const SizedBox(height: 32),
          _buildOtpFields(),
          const SizedBox(height: 24),
          _buildResendButton(),
          const SizedBox(height: 32),
          _buildStatusMessage(),
          const SizedBox(height: 24),
          _buildVerifyButton(),
          const SizedBox(height: 32),
          _buildBackButton(),
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
      'RESET CODE',
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
      'CHECK YOUR EMAIL INBOX',
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: const Color(0xFF9CA3AF),
        letterSpacing: 2.0,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 48,
          height: 56,
          child: RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (event) => _onOtpKeyEvent(index, event),
            child: TextFormField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              maxLength: 1,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF111827),
              ),
              onChanged: (value) => _onOtpChanged(index, value),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF2563EB),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildResendButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: _isResending ? null : _handleResend,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isResending ? 'SENDING...' : 'RESEND CODE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: _isResending
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF2563EB),
                  letterSpacing: 2.5,
                ),
              ),
              if (_isResending) ...[
                const SizedBox(width: 8),
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                  ),
                ),
              ],
            ],
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

  Widget _buildVerifyButton() {
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
        onPressed: _isVerifying ? null : _handleVerify,
        style: ElevatedButton.styleFrom(
          backgroundColor: _showStatus
              ? const Color(0xFF10B981)
              : const Color(0xFF2563EB),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          disabledBackgroundColor: const Color(0xFF2563EB).withOpacity(0.5),
        ),
        child: _isVerifying
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                _showStatus ? 'VERIFIED!' : 'VERIFY CODE',
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
