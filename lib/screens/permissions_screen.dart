import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/vanguard_theme.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _locationGranted = false;
  bool _cameraGranted = false;
  bool _notificationsGranted = false;

  void _togglePermission(String type) {
    setState(() {
      if (type == 'location') _locationGranted = !_locationGranted;
      if (type == 'camera') _cameraGranted = !_cameraGranted;
      if (type == 'notifications') _notificationsGranted = !_notificationsGranted;
    });
  }

  void _proceed() {
    // Alert the user if critical permissions aren't set
    if (!_locationGranted || !_cameraGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Location and Camera access are crucial to verify citizen evidence.',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: VanguardTheme.actionGradientStart,
          action: SnackBarAction(
            label: 'GRANT ALL',
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                _locationGranted = true;
                _cameraGranted = true;
                _notificationsGranted = true;
              });
            },
          ),
        ),
      );
      return;
    }

    Navigator.pushNamed(context, '/ward_select');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VanguardTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              // Top branding
              Text(
                'SYSTEM PERMISSIONS',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: VanguardTheme.primaryContainer,
                ),
              ),
              
              const SizedBox(height: 12),
              
              Text(
                'Empower Your Device',
                style: GoogleFonts.sora(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: VanguardTheme.onSurface,
                ),
              ),
              
              const SizedBox(height: 10),
              
              Text(
                'Netagraph flutter app is a decentralized reporting application. Your information is securely stored locally and only transmitted when you choose to log a verified grievance.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  height: 1.5,
                  color: VanguardTheme.slate,
                ),
              ),
              
              const Spacer(),

              // Granular permission switches
              _buildPermissionTile(
                title: 'Precise Location Access',
                description: 'Pins your GPS coordinates when capturing photos to prevent fake reporting and confirm ward boundaries.',
                icon: Icons.location_on_outlined,
                isEnabled: _locationGranted,
                onTap: () => _togglePermission('location'),
              ),
              
              const SizedBox(height: 16),
              
              _buildPermissionTile(
                title: 'Camera & Media Library',
                description: 'Used to take direct, immutable real-time photos of municipal failures and promise verification evidence.',
                icon: Icons.camera_alt_outlined,
                isEnabled: _cameraGranted,
                onTap: () => _togglePermission('camera'),
              ),
              
              const SizedBox(height: 16),
              
              _buildPermissionTile(
                title: 'Push Notifications',
                description: 'Alerts you instantly when your reported issue is verified, assigned to PWD, or resolved by your leader.',
                icon: Icons.notifications_none_outlined,
                isEnabled: _notificationsGranted,
                onTap: () => _togglePermission('notifications'),
              ),
              
              const Spacer(flex: 2),

              // Action buttons
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
                    onPressed: _proceed,
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
                          'Confirm & Proceed',
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
                ),
              ),
              
              const SizedBox(height: 14),
              
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/ward_select');
                  },
                  child: Text(
                    'Configure Later in Settings',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: VanguardTheme.slate,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionTile({
    required String title,
    required String description,
    required IconData icon,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: VanguardTheme.borderMedium,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: VanguardTheme.surfaceElevated,
          borderRadius: VanguardTheme.borderMedium,
          border: Border.all(
            color: isEnabled 
              ? VanguardTheme.primaryContainer.withOpacity(0.4) 
              : Colors.white.withOpacity(0.06),
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isEnabled 
                  ? VanguardTheme.primaryContainer.withOpacity(0.15) 
                  : VanguardTheme.surfaceBright.withOpacity(0.5),
                borderRadius: VanguardTheme.borderDefault,
              ),
              child: Icon(
                icon,
                color: isEnabled ? VanguardTheme.primaryContainer : VanguardTheme.slate,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.sora(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: VanguardTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      height: 1.4,
                      color: VanguardTheme.slate,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Custom Switch or Check Circle
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isEnabled ? VanguardTheme.primaryContainer : Colors.transparent,
                border: Border.all(
                  color: isEnabled ? VanguardTheme.primaryContainer : VanguardTheme.slate.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: isEnabled 
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
            ),
          ],
        ),
      ),
    );
  }
}
