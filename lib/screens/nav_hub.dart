import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/vanguard_theme.dart';
import 'explore_tab.dart';
import 'community_tab.dart';
import 'reports_tab.dart';
import 'profile_tab.dart';

class NavHub extends StatefulWidget {
  const NavHub({super.key});

  @override
  State<NavHub> createState() => _NavHubState();
}

class _NavHubState extends State<NavHub> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const ExploreTab(),
    const CommunityTab(),
    const ReportsTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VanguardTheme.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      
      // Megaphone/Report FAB with brand gradient glow
      floatingActionButton: _currentIndex != 3 // Hide on profile tab
          ? Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: VanguardTheme.actionGradient,
                boxShadow: VanguardTheme.buttonGlow,
              ),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/report_issue');
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: const Icon(Icons.campaign, color: Colors.white, size: 28),
              ),
            )
          : null,
      
      // Premium bottom tab navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.08)),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: VanguardTheme.surfaceElevated,
          selectedItemColor: VanguardTheme.primaryContainer,
          unselectedItemColor: VanguardTheme.slate,
          selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.normal),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Community',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
