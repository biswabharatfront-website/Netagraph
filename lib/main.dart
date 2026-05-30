import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Theme imports
import 'theme/vanguard_theme.dart';

// State and Database Models import
import 'models/civic_models.dart';

// Onboarding and Auth Screen imports
import 'screens/welcome_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/permissions_screen.dart';

// Ward boundaries and map settings imports
import 'screens/ward_select_screen.dart';
import 'screens/ward_boundary_screen.dart';
import 'screens/loading_screen.dart';

// Central tab shell and dashboards imports
import 'screens/nav_hub.dart';
import 'screens/politician_screen.dart';
import 'screens/political_leaders_screen.dart';
import 'screens/report_issue_screen.dart';
import 'screens/issue_details_screen.dart';
import 'screens/events_screen.dart';
import 'screens/add_announcement.dart';
import 'screens/add_discussion.dart';
import 'screens/community_chat_screen.dart';
import 'config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => CivicState(),
      child: const NetagraphApp(),
    ),
  );
}

class NetagraphApp extends StatelessWidget {
  const NetagraphApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netagraph - Citizen Voice Portal',
      theme: VanguardTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // Auth and Onboarding Sequence
        '/': (context) => const WelcomeScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/permissions': (context) => const PermissionsScreen(),
        
        // Local Ward selections
        '/ward_select': (context) => const WardSelectScreen(),
        '/ward_boundary': (context) => const WardBoundaryScreen(),
        '/loading': (context) => const LoadingScreen(),
        
        // Navigation core shell and tabs
        '/hub': (context) => const NavHub(),
        
        // Deeper audit dashboards and forms
        '/politician_profile': (context) => const PoliticianScreen(),
        '/leaders_list': (context) => const PoliticalLeadersScreen(),
        '/report_issue': (context) => const ReportIssueScreen(),
        '/issue_details': (context) => const IssueDetailsScreen(),
        '/events_screen': (context) => const EventsScreen(),
        '/add_announcement': (context) => const AddAnnouncementScreen(),
        '/add_discussion': (context) => const AddDiscussionScreen(),
        '/community_chat': (context) => const CommunityChatScreen(),
      },
    );
  }
}
