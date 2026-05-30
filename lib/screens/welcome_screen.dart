import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/vanguard_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // High-Impact Atmospheric Urban Dusk Background
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1519501025264-65ba15a82390?auto=format&fit=crop&q=80&w=1000',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF070E1C),
              ),
            ),
          ),
          
          // Custom Gradient Overlay for visual excellence & dark contrast
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: VanguardTheme.darkHeroGradient,
              ),
            ),
          ),
          
          // Header content
          SafeArea(
            child: Column(
              children: [
                // Top Header Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: VanguardTheme.radiusXLarge, 
                    vertical: VanguardTheme.radiusDefault,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu, color: VanguardTheme.onSurface),
                      ),
                      // Netagram Title in Sora Font
                      Text(
                        'NETAGRAM',
                        style: GoogleFonts.sora(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.0,
                          color: VanguardTheme.primaryContainer,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.notifications_outlined, color: VanguardTheme.onSurface),
                          ),
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: VanguardTheme.surfaceBright,
                            child: Icon(Icons.person, color: VanguardTheme.onSurface, size: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Centered Tagline
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Text(
                        'Track Promises.\nReport Reality.\nDemand Delivery.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sora(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                          letterSpacing: -1.0,
                          color: VanguardTheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(flex: 2),
                
                // Bottom Interactions Area
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Community Pulse Glassmorphic Card
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: VanguardTheme.surfaceElevated.withOpacity(0.85),
                          borderRadius: VanguardTheme.borderMedium,
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: VanguardTheme.actionGradientStart.withOpacity(0.15),
                                borderRadius: VanguardTheme.borderDefault,
                              ),
                              child: const Icon(
                                Icons.campaign,
                                color: VanguardTheme.actionGradientStart,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Community Impact',
                                    style: GoogleFonts.sora(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: VanguardTheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Join 12,400 citizens holding public offices accountable today.',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: VanguardTheme.slate,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Get Started Gradient Button
                      Container(
                        width: double.infinity,
                        height: 58,
                        decoration: BoxDecoration(
                          gradient: VanguardTheme.actionGradient,
                          borderRadius: VanguardTheme.borderMedium,
                          boxShadow: VanguardTheme.buttonGlow,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/onboarding');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: VanguardTheme.borderMedium,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Get Started',
                                style: GoogleFonts.sora(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 14),
                      
                      // Sign In Outline Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: VanguardTheme.slate.withOpacity(0.3), width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: VanguardTheme.borderMedium,
                            ),
                          ),
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: VanguardTheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Privacy Policy & Terms Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Privacy Policy',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: VanguardTheme.slate,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.circle, size: 4, color: VanguardTheme.slate),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Terms of Service',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: VanguardTheme.slate,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Accent bottom glow line
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 4,
              decoration: const BoxDecoration(
                gradient: VanguardTheme.actionGradient,
              ),
            ),
          )
        ],
      ),
    );
  }
}
