import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/vanguard_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (index) => FocusNode());
  
  bool _otpSent = false;
  bool _isLoading = false;
  int _timerCount = 30;
  
  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (_timerCount > 0 && _otpSent) {
        setState(() {
          _timerCount--;
        });
        _startTimer();
      }
    });
  }

  void _sendOtp() {
    if (_phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a valid 10-digit phone number.',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: VanguardTheme.actionGradientStart,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _otpSent = true;
        _timerCount = 30;
      });
      _startTimer();
      _otpFocusNodes[0].requestFocus();
    });
  }

  void _verifyOtp() {
    setState(() {
      _isLoading = true;
    });

    // Simulate verification
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      
      // Navigate to permissions request
      Navigator.pushNamed(context, '/permissions');
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VanguardTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: VanguardTheme.onSurface),
          onPressed: () {
            if (_otpSent) {
              setState(() {
                _otpSent = false;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Visual Brand element
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: VanguardTheme.actionGradient,
                      borderRadius: VanguardTheme.borderSmall,
                    ),
                    child: const Icon(Icons.gavel, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Netagraph',
                    style: GoogleFonts.sora(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: VanguardTheme.onSurface,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              Text(
                _otpSent ? 'Enter OTP' : 'Let\'s Sign You In',
                style: GoogleFonts.sora(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: VanguardTheme.onSurface,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                _otpSent 
                  ? 'We have sent a verification code to +91 ${_phoneController.text}' 
                  : 'Enter your phone number to receive a secure one-time passcode for civic authentication.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  height: 1.5,
                  color: VanguardTheme.slate,
                ),
              ),
              
              const SizedBox(height: 40),

              if (!_otpSent) ...[
                // Phone number card
                Text(
                  'Mobile Number',
                  style: GoogleFonts.sora(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: VanguardTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  style: GoogleFonts.inter(fontSize: 16, color: VanguardTheme.onSurface, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    counterText: '',
                    prefixIcon: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: Colors.white.withOpacity(0.08))),
                      ),
                      child: Text(
                        '+91',
                        style: GoogleFonts.inter(
                          fontSize: 16, 
                          color: VanguardTheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    hintText: '98765 43210',
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Get OTP Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: VanguardTheme.actionGradient,
                      borderRadius: VanguardTheme.borderMedium,
                      boxShadow: VanguardTheme.buttonGlow,
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: VanguardTheme.borderMedium,
                        ),
                      ),
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Request Verification Code',
                            style: GoogleFonts.sora(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    Expanded(child: Divider(color: VanguardTheme.slate.withOpacity(0.2))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('OR', style: GoogleFonts.inter(fontSize: 12, color: VanguardTheme.slate)),
                    ),
                    Expanded(child: Divider(color: VanguardTheme.slate.withOpacity(0.2))),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Google sign in option
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white.withOpacity(0.08)),
                      shape: RoundedRectangleBorder(
                        borderRadius: VanguardTheme.borderMedium,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1024px-Google_%22G%22_logo.svg.png',
                          height: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Continue with Google',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: VanguardTheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // OTP entry fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      width: 48,
                      height: 58,
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _otpFocusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.bold, color: VanguardTheme.onSurface),
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: VanguardTheme.primaryContainer, width: 2.0),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            if (index < 5) {
                              _otpFocusNodes[index + 1].requestFocus();
                            } else {
                              _otpFocusNodes[index].unfocus();
                              _verifyOtp(); // Auto trigger verification
                            }
                          } else {
                            if (index > 0) {
                              _otpFocusNodes[index - 1].requestFocus();
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Resend OTP section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _timerCount > 0 
                        ? 'Resend OTP in 0:${_timerCount.toString().padLeft(2, '0')}' 
                        : 'Didn\'t receive code?',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: VanguardTheme.slate,
                      ),
                    ),
                    if (_timerCount == 0)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _timerCount = 30;
                          });
                          _startTimer();
                        },
                        child: Text(
                          'Resend Code',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: VanguardTheme.primaryContainer,
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: 48),
                
                // Verify button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: VanguardTheme.actionGradient,
                      borderRadius: VanguardTheme.borderMedium,
                      boxShadow: VanguardTheme.buttonGlow,
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: VanguardTheme.borderMedium,
                        ),
                      ),
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Verify & Authenticate',
                            style: GoogleFonts.sora(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
