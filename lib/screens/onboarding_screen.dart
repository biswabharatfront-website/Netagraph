import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/vanguard_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingData> _slides = [
    OnboardingData(
      icon: Icons.verified_user_outlined,
      title: "Verifiable Evidence",
      description: "No more rumors or claims. Netagraph runs on geo-stamped photos, OTP-verified citizen signatures, and expert volunteer audits to ensure every complaint is bulletproof.",
      image: "https://images.unsplash.com/photo-1541872703-74c5e44368f9?auto=format&fit=crop&q=80&w=600",
    ),
    OnboardingData(
      icon: Icons.account_tree_outlined,
      title: "Hyperlocal to Parliament",
      description: "From your local ward Councillor and MLA to your Member of Parliament, Chief Minister, and PM. Track accountability scorecards and timeline promises all in one place.",
      image: "https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?auto=format&fit=crop&q=80&w=600",
    ),
    OnboardingData(
      icon: Icons.auto_awesome_outlined,
      title: "Collective Escalation",
      description: "If an issue remains unresolved, Netagraph automatically escalates it by filing public RTI requests and registering complaints directly on the official central CPGRAMS portal.",
      image: "https://images.unsplash.com/photo-1457369804613-52c61a468e7d?auto=format&fit=crop&q=80&w=600",
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VanguardTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              // Top Header Row with Skip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: VanguardTheme.primaryContainer,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Vanguard Civic',
                        style: GoogleFonts.sora(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: VanguardTheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      'Skip',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: VanguardTheme.slate,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),

              // Page Swiper Content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Card with shadow and visual content
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: VanguardTheme.surfaceElevated,
                              borderRadius: VanguardTheme.borderLarge,
                              border: Border.all(color: Colors.white.withOpacity(0.08)),
                            ),
                            child: ClipRRect(
                              borderRadius: VanguardTheme.borderLarge,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.network(
                                      slide.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            VanguardTheme.surfaceElevated.withOpacity(0.7),
                                            VanguardTheme.surfaceElevated,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 24,
                                    left: 20,
                                    right: 20,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: VanguardTheme.primaryContainer.withOpacity(0.2),
                                            borderRadius: VanguardTheme.borderMedium,
                                            border: Border.all(color: VanguardTheme.primaryContainer.withOpacity(0.4)),
                                          ),
                                          child: Icon(
                                            slide.icon,
                                            color: VanguardTheme.primaryContainer,
                                            size: 32,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            slide.title,
                                            style: GoogleFonts.sora(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: VanguardTheme.onSurface,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Text Description block
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            slide.description,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              height: 1.5,
                              color: VanguardTheme.onSurface.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 32),

              // Page Indicators & Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Indicators
                  Row(
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        width: _currentIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _currentIndex == index 
                              ? VanguardTheme.primaryContainer 
                              : VanguardTheme.slate.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                  
                  // Action buttons
                  _currentIndex == _slides.length - 1
                      ? Container(
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: VanguardTheme.actionGradient,
                            borderRadius: VanguardTheme.borderMedium,
                            boxShadow: VanguardTheme.buttonGlow,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: VanguardTheme.borderMedium,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Get Started',
                                  style: GoogleFonts.sora(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          height: 52,
                          width: 52,
                          decoration: const BoxDecoration(
                            color: VanguardTheme.surfaceElevated,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                            icon: const Icon(Icons.arrow_forward, color: VanguardTheme.primaryContainer),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingData {
  final IconData icon;
  final String title;
  final String description;
  final String image;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
    required this.image,
  });
}
