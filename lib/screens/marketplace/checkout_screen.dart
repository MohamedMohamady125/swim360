import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  String? _selectedPaymentMethod;
  bool _showCardForm = false;
  bool _showSuccess = false;
  double _sliderPosition = 0.0;
  late AnimationController _successAnimationController;

  @override
  void initState() {
    super.initState();
    _successAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    _addressController.dispose();
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _successAnimationController.dispose();
    super.dispose();
  }

  bool get _canCheckout => _cityController.text.isNotEmpty && _addressController.text.isNotEmpty && _selectedPaymentMethod != null;

  String get _cardType {
    final number = _cardNumberController.text.replaceAll(' ', '');
    if (number.startsWith('4')) return 'VISA';
    if (number.startsWith('5')) return 'MASTERCARD';
    return 'CARD';
  }

  void _completePayment() {
    setState(() => _showSuccess = true);
    _successAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _showSuccess ? const Color(0xFF2563EB) : const Color(0xFFF8FAFC),
      body: _showSuccess ? _buildSuccessOverlay() : _buildCheckoutContent(),
    );
  }

  Widget _buildCheckoutContent() {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildDeliverySection(),
                  const SizedBox(height: 24),
                  _buildPaymentSection(),
                  const SizedBox(height: 24),
                  _buildPricingSection(),
                  const SizedBox(height: 32),
                  _buildSliderToPay(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, size: 24),
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CHECKOUT', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -1.0)),
                  Text('COMPLETE PURCHASE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                ],
              ),
            ],
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: const Color(0xFF2563EB).withOpacity(0.3), blurRadius: 15)],
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFF2563EB), size: 16),
              SizedBox(width: 8),
              Text('DELIVERY ADDRESS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFF1F5F9), width: 4),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, color: Color(0xFF9CA3AF), size: 48),
                  SizedBox(height: 8),
                  Text('Map Preview', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('CITY / REGION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(16),
            ),
            hint: const Text('Select City', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF))),
            items: ['New Cairo', 'Maadi', 'Zamalek', 'Alexandria', '6th of October'].map((city) {
              return DropdownMenuItem(value: city, child: Text(city, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)));
            }).toList(),
            onChanged: (value) => setState(() => _cityController.text = value ?? ''),
          ),
          const SizedBox(height: 16),
          const Text('DETAILED ADDRESS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
          const SizedBox(height: 6),
          TextField(
            controller: _addressController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Bldg. No, Street, Apartment...',
              hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            onChanged: (value) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.credit_card, color: Color(0xFF2563EB), size: 16),
                  SizedBox(width: 8),
                  Text('PAYMENT METHOD', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
                ],
              ),
              InkWell(
                onTap: () => setState(() => _showCardForm = !_showCardForm),
                child: Text(_showCardForm ? 'CANCEL' : '+ NEW CARD', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF2563EB), letterSpacing: 2.5)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_showCardForm) _buildCardForm() else _buildPaymentOptions(),
        ],
      ),
    );
  }

  Widget _buildCardForm() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 180,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: _cardType == 'VISA'
                ? const LinearGradient(colors: [Color(0xFF1a1f71), Color(0xFF2b3a8c)])
                : _cardType == 'MASTERCARD'
                    ? const LinearGradient(colors: [Color(0xFFeb001b), Color(0xFFff5f00)])
                    : const LinearGradient(colors: [Color(0xFF1e293b), Color(0xFF334155)]),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFffd700), Color(0xFFeab308)]),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  Text(_cardType, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, fontStyle: FontStyle.italic)),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                _cardNumberController.text.isEmpty ? '•••• •••• •••• ••••' : _cardNumberController.text,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white, letterSpacing: 2.0, fontFamily: 'monospace'),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CARD HOLDER', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: Colors.white.withOpacity(0.6))),
                        const SizedBox(height: 2),
                        Text(
                          _cardNameController.text.isEmpty ? 'YOUR NAME' : _cardNameController.text.toUpperCase(),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('EXPIRY', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: Colors.white.withOpacity(0.6))),
                      const SizedBox(height: 2),
                      Text(
                        _expiryController.text.isEmpty ? 'MM/YY' : _expiryController.text,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _cardNumberController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Card Number',
            filled: true,
            fillColor: Color(0xFFF9FAFB),
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
            contentPadding: EdgeInsets.all(16),
          ),
          onChanged: (value) {
            final cleaned = value.replaceAll(' ', '');
            final formatted = cleaned.replaceAllMapped(RegExp(r'.{1,4}'), (match) => '${match.group(0)} ').trim();
            if (formatted != value) {
              _cardNumberController.value = _cardNumberController.value.copyWith(
                text: formatted,
                selection: TextSelection.collapsed(offset: formatted.length),
              );
            }
            setState(() {});
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _cardNameController,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            hintText: 'Full Name',
            filled: true,
            fillColor: Color(0xFFF9FAFB),
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
            contentPadding: EdgeInsets.all(16),
          ),
          onChanged: (value) => setState(() {}),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _expiryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'MM/YY',
                  filled: true,
                  fillColor: Color(0xFFF9FAFB),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.all(16),
                ),
                onChanged: (value) {
                  final cleaned = value.replaceAll('/', '');
                  if (cleaned.length > 2) {
                    final formatted = '${cleaned.substring(0, 2)}/${cleaned.substring(2, cleaned.length > 4 ? 4 : cleaned.length)}';
                    if (formatted != value) {
                      _expiryController.value = _expiryController.value.copyWith(
                        text: formatted,
                        selection: TextSelection.collapsed(offset: formatted.length),
                      );
                    }
                  }
                  setState(() {});
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _cvvController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 3,
                decoration: const InputDecoration(
                  hintText: 'CVV',
                  filled: true,
                  fillColor: Color(0xFFF9FAFB),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.all(16),
                  counterText: '',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: _cardNumberController.text.replaceAll(' ', '').length >= 16
              ? () {
                  setState(() {
                    _selectedPaymentMethod = 'new-card';
                    _showCardForm = false;
                  });
                }
              : null,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _cardNumberController.text.replaceAll(' ', '').length >= 16 ? const Color(0xFF2563EB) : const Color(0xFF111827),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15)],
            ),
            child: Text(
              'SAVE & SELECT CARD',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: _cardNumberController.text.replaceAll(' ', '').length >= 16 ? Colors.white : Colors.white.withOpacity(0.4),
                letterSpacing: 2.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOptions() {
    return Column(
      children: [
        _buildPaymentOption('visa-primary', 'VISA', 'Visa •••• 4242', 'SAVED'),
        const SizedBox(height: 12),
        _buildPaymentOption('cash', 'CASH', 'Cash on Delivery', 'PAY AT DOOR'),
      ],
    );
  }

  Widget _buildPaymentOption(String id, String type, String label, String sublabel) {
    final isSelected = _selectedPaymentMethod == id;
    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF9FAFB),
          border: Border.all(color: isSelected ? const Color(0xFF2563EB) : Colors.transparent, width: 2),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: type == 'CASH'
                  ? const Icon(Icons.attach_money, color: Color(0xFF9CA3AF), size: 24)
                  : Text(type, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF1e40af), fontStyle: FontStyle.italic)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(sublabel, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF93C5FD), letterSpacing: 2.5)),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE5E7EB), width: 2),
              ),
              child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 12) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TOTAL PRICE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF9CA3AF), letterSpacing: 2.5)),
              SizedBox(height: 4),
              Text('\$75.49', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1.5)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              border: Border.all(color: const Color(0xFFD1FAE5)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield, color: Color(0xFF10B981), size: 16),
                SizedBox(width: 8),
                Text('SECURE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF10B981), letterSpacing: 2.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderToPay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxSlide = constraints.maxWidth - 76;
        return GestureDetector(
          onHorizontalDragUpdate: _canCheckout
              ? (details) {
                  setState(() {
                    _sliderPosition = (_sliderPosition + details.delta.dx).clamp(0.0, maxSlide);
                  });
                }
              : null,
          onHorizontalDragEnd: _canCheckout
              ? (details) {
                  if (_sliderPosition >= maxSlide * 0.9) {
                    _completePayment();
                  } else {
                    setState(() => _sliderPosition = 0);
                  }
                }
              : null,
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: _canCheckout ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(36),
            ),
            child: Stack(
              children: [
                Center(
                  child: Opacity(
                    opacity: _canCheckout ? (1 - (_sliderPosition / maxSlide)).clamp(0.0, 1.0) : 0.4,
                    child: Text(
                      'SLIDE TO PAY',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: _canCheckout ? Colors.white.withOpacity(0.6) : const Color(0xFF94A3B8),
                        letterSpacing: 2.5,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  left: 6 + _sliderPosition,
                  top: 6,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                    ),
                    child: const Icon(Icons.arrow_forward, color: Color(0xFF2563EB), size: 24),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuccessOverlay() {
    return Center(
      child: ScaleTransition(
        scale: CurvedAnimation(parent: _successAnimationController, curve: Curves.elasticOut),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 144,
              height: 144,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(48),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30)],
              ),
              child: const Icon(Icons.check_circle_outline, color: Colors.white, size: 80),
            ),
            const SizedBox(height: 40),
            const Text(
              'CONFIRMED!!',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                letterSpacing: -2.0,
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFF93C5FD),
                decorationThickness: 4,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'YOUR GEAR IS AT THE STARTING BLOCK',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: const Color(0xFFDCEEFE).withOpacity(0.8),
                letterSpacing: 4.0,
              ),
            ),
            const SizedBox(height: 48),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20)],
                ),
                child: const Text('BACK TO HOME', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF2563EB), letterSpacing: 2.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
