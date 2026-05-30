import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/vanguard_theme.dart';
import '../models/civic_models.dart';
import 'issue_details_screen.dart';

class AdminFlagsScreen extends StatefulWidget {
  const AdminFlagsScreen({super.key});

  @override
  State<AdminFlagsScreen> createState() => _AdminFlagsScreenState();
}

class _AdminFlagsScreenState extends State<AdminFlagsScreen> {
  int _activeFilterTab = 0; // 0 = All, 1 = Pending, 2 = High Severity

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  Color _getSeverityColor(int severity) {
    switch (severity) {
      case 3:
        return const Color(0xFFEF4444); // Crimson High
      case 2:
        return const Color(0xFFF97316); // Amber Medium
      case 1:
        return const Color(0xFFEAB308); // Yellow Low
      default:
        return VanguardTheme.slate;
    }
  }

  String _getSeverityLabel(int severity) {
    switch (severity) {
      case 3:
        return "HIGH SEVERITY";
      case 2:
        return "MEDIUM SEVERITY";
      case 1:
        return "LOW SEVERITY";
      default:
        return "UNKNOWN";
    }
  }

  String _getFlagTypeLabel(String type) {
    switch (type) {
      case 'ip_burst':
        return "COORDINATED IP BURST";
      case 'geo_burst':
        return "GEOGRAPHIC BURST";
      case 'text_similarity':
        return "TEXT SIMILARITY ALERT";
      case 'coordinated':
        return "COORDINATED ATTACK";
      default:
        return type.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CivicState>(context);
    
    // Filter flags list
    final List<SuspiciousActivityFlag> filteredFlags = state.suspiciousFlags.where((flag) {
      if (_activeFilterTab == 1) {
        return flag.status == 'Pending';
      } else if (_activeFilterTab == 2) {
        return flag.severity == 3;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: VanguardTheme.background,
      appBar: AppBar(
        backgroundColor: VanguardTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: VanguardTheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'ADMIN FLAGS CONSOLE',
          style: GoogleFonts.sora(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: VanguardTheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.security, color: VanguardTheme.primaryContainer),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header stats panel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COORDINATED ACTIVITY MONITOR',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: VanguardTheme.slate,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Audit flagged activities submitted in your locked ward zone.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: VanguardTheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Horizontal Filter bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(0, "All Activities (${state.suspiciousFlags.length})"),
                    const SizedBox(width: 8),
                    _buildFilterChip(1, "Pending (${state.suspiciousFlags.where((f) => f.status == 'Pending').length})"),
                    const SizedBox(width: 8),
                    _buildFilterChip(2, "High Severity (${state.suspiciousFlags.where((f) => f.severity == 3).length})"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Main Flags scrollable list
            Expanded(
              child: filteredFlags.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shield_outlined, size: 48, color: VanguardTheme.slate.withOpacity(0.5)),
                          const SizedBox(height: 12),
                          Text(
                            'No flagged activities match this query.',
                            style: GoogleFonts.inter(color: VanguardTheme.slate, fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      itemCount: filteredFlags.length,
                      itemBuilder: (context, index) {
                        final flag = filteredFlags[index];
                        // Retrieve targeted issue details
                        final issueIndex = state.issues.indexWhere((i) => i.id == flag.reportId);
                        final targetIssue = issueIndex != -1 ? state.issues[issueIndex] : null;

                        return _buildFlagCard(flag, targetIssue, state);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final isSelected = _activeFilterTab == index;
    return GestureDetector(
      onTap: () => setState(() => _activeFilterTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? VanguardTheme.primaryContainer : VanguardTheme.surfaceElevated,
          borderRadius: VanguardTheme.borderMedium,
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.06),
          ),
          boxShadow: isSelected ? VanguardTheme.buttonGlow : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.sora(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : VanguardTheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildFlagCard(SuspiciousActivityFlag flag, CivicIssue? issue, CivicState state) {
    final severityColor = _getSeverityColor(flag.severity);
    final isPending = flag.status == 'Pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VanguardTheme.surfaceElevated,
        borderRadius: VanguardTheme.borderMedium,
        border: Border.all(
          color: isPending ? severityColor.withOpacity(0.2) : Colors.white.withOpacity(0.04),
          width: isPending ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Flag Type and Severity Label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _getSeverityLabel(flag.severity),
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: severityColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                _formatDate(flag.createdAt),
                style: GoogleFonts.inter(fontSize: 11, color: VanguardTheme.slate),
              )
            ],
          ),

          const SizedBox(height: 10),

          // Flag Title Type
          Text(
            _getFlagTypeLabel(flag.flagType),
            style: GoogleFonts.sora(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: VanguardTheme.onSurface,
            ),
          ),

          const SizedBox(height: 8),

          // Flag Description reason
          Text(
            flag.reason,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: VanguardTheme.onSurface.withOpacity(0.8),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 14),

          // Linked Issue reference container
          if (issue != null) ...[
            InkWell(
              onTap: () {
                // Navigate directly to issue details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IssueDetailsScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: VanguardTheme.background.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withOpacity(0.04)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.campaign, size: 20, color: VanguardTheme.primaryContainer),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Target Report:',
                            style: GoogleFonts.inter(fontSize: 10, color: VanguardTheme.slate),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            issue.title,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: VanguardTheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 16, color: VanguardTheme.slate),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],

          // System / IP audit metadata (Simulating privacy hashing outputs)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.01),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white.withOpacity(0.02)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hashed IP Range:',
                      style: GoogleFonts.inter(fontSize: 10, color: VanguardTheme.slate),
                    ),
                    Text(
                      issue?.ipAddressHash != null 
                          ? "${issue!.ipAddressHash!.substring(0, 16)}..." 
                          : "f5a709b110de7c68...",
                      style: GoogleFonts.inter(fontSize: 10, color: VanguardTheme.slate, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Device ID:',
                      style: GoogleFonts.inter(fontSize: 10, color: VanguardTheme.slate),
                    ),
                    Text(
                      issue?.deviceFingerprint ?? "fingerprint_web_emulator_448",
                      style: GoogleFonts.inter(fontSize: 10, color: VanguardTheme.slate, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Actions Row (Banning, Confirming, Dismissing)
          Row(
            children: [
              if (isPending) ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      state.confirmFlag(flag.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Flag successfully confirmed.'),
                          backgroundColor: VanguardTheme.success,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VanguardTheme.success.withOpacity(0.12),
                      foregroundColor: VanguardTheme.success,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: VanguardTheme.success, width: 1),
                      ),
                    ),
                    child: Text(
                      'Confirm',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      state.dismissFlag(flag.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Flag successfully dismissed.'),
                          backgroundColor: VanguardTheme.slate,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.04),
                      foregroundColor: VanguardTheme.onSurface,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.white.withOpacity(0.08), width: 1),
                      ),
                    ),
                    child: Text(
                      'Dismiss',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              
              // Ban User Button
              ElevatedButton(
                onPressed: () {
                  state.banUser(issue?.reporterName ?? "");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reporter ${issue?.reporterName ?? "User"} banned successfully.'),
                      backgroundColor: const Color(0xFFEF4444),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444).withOpacity(0.12),
                  foregroundColor: const Color(0xFFEF4444),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFFEF4444), width: 1),
                  ),
                ),
                child: Text(
                  'Ban User',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              
              if (!isPending) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: flag.status == 'Confirmed' 
                        ? VanguardTheme.success.withOpacity(0.12)
                        : VanguardTheme.slate.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    flag.status.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: flag.status == 'Confirmed' ? VanguardTheme.success : VanguardTheme.slate,
                    ),
                  ),
                ),
              ],
            ],
          )
        ],
      ),
    );
  }
}
