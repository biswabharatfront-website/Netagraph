import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/vanguard_theme.dart';
import '../models/civic_models.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CivicState>(context);
    final user = state.currentUser;

    return Scaffold(
      backgroundColor: VanguardTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'CITIZEN PROFILE',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: VanguardTheme.primaryContainer,
                ),
              ),
              const SizedBox(height: 16),

              // Main User Profile Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: VanguardTheme.surfaceElevated,
                  borderRadius: VanguardTheme.borderLarge,
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundImage: NetworkImage(user.avatarUrl),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: GoogleFonts.sora(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: VanguardTheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.phone,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: VanguardTheme.slate,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user.wardName,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: VanguardTheme.primaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    Divider(color: Colors.white.withOpacity(0.06)),
                    const SizedBox(height: 16),

                    // Stats row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildUserStat(user.reportsFiled.toString(), 'Reports Filed'),
                        _buildUserStat(user.contributionsCount.toString(), 'Contributions'),
                        _buildUserStat('${user.activeScore}', 'Active Score'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Level indicator
              Text(
                'CITIZEN LEVEL',
                style: GoogleFonts.sora(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: VanguardTheme.slate,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: VanguardTheme.surfaceElevated,
                  borderRadius: VanguardTheme.borderMedium,
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Level 4 - Civic Leader',
                          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: VanguardTheme.onSurface),
                        ),
                        Text(
                          '420 / 500 XP',
                          style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.bold, color: VanguardTheme.primaryContainer),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.84,
                        minHeight: 6,
                        backgroundColor: VanguardTheme.background,
                        valueColor: AlwaysStoppedAnimation(VanguardTheme.primaryContainer),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Reputation & Resident Verification Card
              Text(
                'REPUTATION & RESIDENT STATUS',
                style: GoogleFonts.sora(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: VanguardTheme.slate,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: VanguardTheme.surfaceElevated,
                  borderRadius: VanguardTheme.borderMedium,
                  border: Border.all(
                    color: user.isResidentVerified 
                        ? const Color(0xFF10B981).withOpacity(0.2)
                        : VanguardTheme.primaryContainer.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.verified_user,
                              color: user.isResidentVerified ? const Color(0xFF10B981) : VanguardTheme.primaryContainer,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.reputationLevel,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: VanguardTheme.onSurface,
                                  ),
                                ),
                                Text(
                                  '${user.reputationScore}% Trusted Reporter Score',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: VanguardTheme.slate,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: user.isResidentVerified 
                                ? const Color(0xFF10B981).withOpacity(0.1)
                                : Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: user.isResidentVerified ? const Color(0xFF10B981) : Colors.amber,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            user.isResidentVerified ? 'VERIFIED' : 'UNVERIFIED',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: user.isResidentVerified ? const Color(0xFF10B981) : Colors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (user.isResidentVerified) ...[
                      Row(
                        children: [
                          Icon(Icons.bolt, color: Colors.amber, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '3x Voting Power Active: Verified residents hold maximum civic weight in official BBMP/MLA reviews.',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: VanguardTheme.slate,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      const SizedBox(height: 4),
                      Text(
                        'Upload Voter ID / Ration Card to gain verified resident status, a verified badge, and 3x voting power to unlock priority civic review.',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: VanguardTheme.slate,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: VanguardTheme.primaryContainer,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: VanguardTheme.borderSmall,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        ),
                        icon: const Icon(Icons.upload_file, size: 16),
                        label: Text(
                          'Upload ID & Verify Status',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          _showResidentVerificationDialog(context, state);
                        },
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Badges Grid
              Text(
                'EARNED BADGES',
                style: GoogleFonts.sora(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: VanguardTheme.slate,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: user.badges.length,
                  itemBuilder: (context, index) {
                    final badge = user.badges[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: VanguardTheme.surfaceElevated,
                        borderRadius: VanguardTheme.borderMedium,
                        border: Border.all(color: VanguardTheme.primaryContainer.withOpacity(0.2)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.stars, color: VanguardTheme.primaryContainer, size: 24),
                          const SizedBox(height: 6),
                          Text(
                            badge,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: VanguardTheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Action list links
              Text(
                'ACCOUNT SETTINGS',
                style: GoogleFonts.sora(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: VanguardTheme.slate,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: VanguardTheme.surfaceElevated,
                  borderRadius: VanguardTheme.borderMedium,
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: Column(
                  children: [
                    _buildSettingsTile(Icons.map, 'Update Boundary Ward', 'Change your constituency settings.', () {
                      Navigator.pushNamed(context, '/ward_select');
                    }),
                    Divider(height: 1, color: Colors.white.withOpacity(0.06)),
                    _buildSettingsTile(Icons.verified_user, 'OTP Signature Logs', 'View signed digital verification certificates.', () {}),
                    Divider(height: 1, color: Colors.white.withOpacity(0.06)),
                    _buildSettingsTile(Icons.logout, 'Sign Out Account', 'Revoke local encryption tokens.', () {
                      // Navigate back to welcome page and clear stack
                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    }, isDanger: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserStat(String val, String label) {
    return Column(
      children: [
        Text(
          val,
          style: GoogleFonts.sora(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: VanguardTheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: VanguardTheme.slate,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, String sub, VoidCallback onTap, {bool isDanger = false}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDanger 
            ? VanguardTheme.actionGradientStart.withOpacity(0.1) 
            : VanguardTheme.slate.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon, 
          color: isDanger ? VanguardTheme.actionGradientStart : VanguardTheme.primaryContainer,
          size: 18,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.sora(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isDanger ? VanguardTheme.actionGradientStart : VanguardTheme.onSurface,
        ),
      ),
      subtitle: Text(
        sub,
        style: GoogleFonts.inter(fontSize: 11, color: VanguardTheme.slate),
      ),
      trailing: const Icon(Icons.chevron_right, color: VanguardTheme.slate, size: 16),
      onTap: onTap,
    );
  }

  void _showResidentVerificationDialog(BuildContext context, CivicState state) {
    String selectedDoc = 'Voter ID';
    bool uploading = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: VanguardTheme.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RESIDENT VERIFICATION',
                        style: GoogleFonts.sora(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: VanguardTheme.onSurface,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: VanguardTheme.slate, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Upload a verified document to link your physical address to Ward 142 - Varthur.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: VanguardTheme.slate,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Radio selections
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          value: 'Voter ID',
                          groupValue: selectedDoc,
                          title: Text('Voter ID', style: GoogleFonts.inter(fontSize: 13, color: Colors.white)),
                          activeColor: VanguardTheme.primaryContainer,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (val) {
                            setModalState(() {
                              selectedDoc = val!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          value: 'Ration Card',
                          groupValue: selectedDoc,
                          title: Text('Ration Card', style: GoogleFonts.inter(fontSize: 13, color: Colors.white)),
                          activeColor: VanguardTheme.primaryContainer,
                          contentPadding: EdgeInsets.zero,
                          onChanged: (val) {
                            setModalState(() {
                              selectedDoc = val!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  if (uploading) ...[
                    Column(
                      children: [
                        const LinearProgressIndicator(
                          color: VanguardTheme.primaryContainer,
                          backgroundColor: VanguardTheme.background,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Scanning credential layout & auditing EXIF metadata...',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: VanguardTheme.slate,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Upload Area Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: BoxDecoration(
                        color: VanguardTheme.background,
                        borderRadius: VanguardTheme.borderMedium,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.06),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.contact_mail, color: VanguardTheme.primaryContainer, size: 36),
                          const SizedBox(height: 8),
                          Text(
                            'Click to select Voter ID/Ration Card image',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: VanguardTheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Supports JPG, PNG or PDF up to 5MB',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: VanguardTheme.slate,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: VanguardTheme.primaryContainer,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: VanguardTheme.borderMedium,
                        ),
                      ),
                      onPressed: uploading ? null : () async {
                        setModalState(() {
                          uploading = true;
                        });
                        
                        // Wait for 1.8 seconds scanning simulation
                        await Future.delayed(const Duration(milliseconds: 1800));
                        
                        // Verify address & finalize
                        state.submitResidentVerification(selectedDoc);
                        
                        Navigator.pop(context);
                        
                        // Show native verification toast
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF10B981),
                            behavior: SnackBarBehavior.floating,
                            content: Row(
                              children: [
                                const Icon(Icons.verified, color: Colors.black),
                                const SizedBox(width: 8),
                                Text(
                                  'Resident verified successfully! 3x voting power active.',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Text(
                        uploading ? 'SCANNING ID...' : 'START VERIFICATION SCAN',
                        style: GoogleFonts.sora(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
