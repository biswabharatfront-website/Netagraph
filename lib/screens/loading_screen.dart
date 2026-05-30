import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/vanguard_theme.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  int _stepIndex = 0;
  Timer? _stepTimer;
  Timer? _navigationTimer;

  final List<String> _loadingSteps = [
    "Pinpointing ward boundary limits...",
    "Connecting community chat boards...",
    "Syncing active citizen grievance timelines...",
    "Securing local encryption keys..."
  ];

  final List<bool> _stepsCompleted = [false, false, false, false];

  @override
  void initState() {
    super.initState();
    _startLoadingCycle();
  }

  void _startLoadingCycle() {
    _stepTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (!mounted) return;
      setState(() {
        if (_stepIndex < _loadingSteps.length) {
          _stepsCompleted[_stepIndex] = true;
          _stepIndex++;
        } else {
          _stepTimer?.cancel();
        }
      });
    });

    _navigationTimer = Timer(const Duration(milliseconds: 2700), () {
      if (!mounted) return;
      // Push to main navigation hub and clear navigation stack so back button doesn't reload
      Navigator.pushNamedAndRemoveUntil(context, '/hub', (route) => false);
    });
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VanguardTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Pulsing double ring loaders
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: VanguardTheme.primaryContainer.withOpacity(0.15),
                        width: 12,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: CircularProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation<Color>(VanguardTheme.primaryContainer),
                      strokeWidth: 4,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: VanguardTheme.actionGradient,
                    ),
                    child: const Icon(Icons.security, color: Colors.white, size: 20),
                  ),
                ],
              ),
              
              const SizedBox(height: 48),
              
              Text(
                'Syncing Netagraph Hub',
                style: GoogleFonts.sora(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: VanguardTheme.onSurface,
                ),
              ),
              
              const SizedBox(height: 6),
              
              Text(
                'Authorizing secure decentralized ledger...',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: VanguardTheme.slate,
                ),
              ),
              
              const Spacer(),

              // Checklist elements
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: VanguardTheme.surfaceElevated,
                  borderRadius: VanguardTheme.borderMedium,
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: Column(
                  children: List.generate(
                    _loadingSteps.length,
                    (index) {
                      final isDone = _stepsCompleted[index];
                      final isCurrent = _stepIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDone ? VanguardTheme.success : Colors.transparent,
                                border: Border.all(
                                  color: isDone 
                                    ? VanguardTheme.success 
                                    : (isCurrent ? VanguardTheme.primaryContainer : VanguardTheme.slate.withOpacity(0.3)),
                                  width: 2,
                                ),
                              ),
                              child: isDone
                                ? const Icon(Icons.check, size: 12, color: Colors.black)
                                : (isCurrent 
                                    ? const Padding(
                                        padding: EdgeInsets.all(3.0),
                                        child: CircularProgressIndicator(strokeWidth: 1.5, valueColor: AlwaysStoppedAnimation(VanguardTheme.primaryContainer)),
                                      )
                                    : null),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                _loadingSteps[index],
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                  color: isDone 
                                    ? VanguardTheme.onSurface 
                                    : (isCurrent ? VanguardTheme.onSurface : VanguardTheme.slate),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
