import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/vanguard_theme.dart';
import '../models/civic_models.dart';

class ReportsTab extends StatefulWidget {
  const ReportsTab({super.key});

  @override
  State<ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends State<ReportsTab> {
  String _activeCategory = "All";
  String _activeStatus = "All"; // "All", "Pending", "In Progress", "Resolved"

  final List<String> _categories = ["All", "Roads", "Water", "Waste Management", "Electricity", "Other"];
  final List<String> _statuses = ["All", "Pending", "In Progress", "Resolved"];

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CivicState>(context);
    final selectedWard = state.selectedWard.isNotEmpty 
        ? state.selectedWard.split(" - ").last.replaceAll(" (Bengaluru)", "") 
        : "Varthur";

    // Filtering issues dynamically
    List<CivicIssue> filteredIssues = state.issues.where((issue) {
      final matchesCategory = _activeCategory == "All" || issue.category == _activeCategory;
      
      bool matchesStatus = true;
      if (_activeStatus != "All") {
        if (_activeStatus == "Pending") matchesStatus = issue.status == IssueStatus.pending;
        if (_activeStatus == "In Progress") matchesStatus = issue.status == IssueStatus.inProgress;
        if (_activeStatus == "Resolved") matchesStatus = issue.status == IssueStatus.resolved;
      }

      return matchesCategory && matchesStatus;
    }).toList();

    return Scaffold(
      backgroundColor: VanguardTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'REPORTS & TRACKING HUB',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: VanguardTheme.primaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$selectedWard Grievances',
                    style: GoogleFonts.sora(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: VanguardTheme.onSurface,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 18),

              // Categories Horizontal List Selector
              SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSel = _activeCategory == cat;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _activeCategory = cat;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSel ? VanguardTheme.primaryContainer : VanguardTheme.surfaceElevated,
                          borderRadius: VanguardTheme.borderDefault,
                          border: Border.all(
                            color: isSel ? VanguardTheme.primaryContainer : Colors.white.withOpacity(0.04),
                          ),
                        ),
                        child: Text(
                          cat,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                            color: isSel ? Colors.white : VanguardTheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              // Statuses row selectors
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  _statuses.length,
                  (index) {
                    final status = _statuses[index];
                    final isSel = _activeStatus == status;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _activeStatus = status;
                          });
                        },
                        child: Container(
                          height: 36,
                          margin: EdgeInsets.only(
                            right: index < _statuses.length - 1 ? 6.0 : 0.0,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isSel ? VanguardTheme.primaryContainer : Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: Text(
                            status,
                            style: GoogleFonts.sora(
                              fontSize: 12,
                              fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                              color: isSel ? VanguardTheme.onSurface : VanguardTheme.slate,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Reports Feed
              Expanded(
                child: filteredIssues.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        itemCount: filteredIssues.length,
                        itemBuilder: (context, index) {
                          final issue = filteredIssues[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
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
                                    Row(
                                      children: [
                                        const Icon(Icons.person_outline, size: 14, color: VanguardTheme.slate),
                                        const SizedBox(width: 4),
                                        Text(
                                          issue.reporterName,
                                          style: GoogleFonts.inter(fontSize: 12, color: VanguardTheme.slate),
                                        ),
                                      ],
                                    ),
                                    _buildStatusChip(issue.status),
                                  ],
                                ),
                                
                                const SizedBox(height: 12),

                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context, 
                                      '/issue_details',
                                      arguments: issue.id,
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        issue.title,
                                        style: GoogleFonts.sora(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: VanguardTheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        issue.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          height: 1.4,
                                          color: VanguardTheme.onSurface.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const SizedBox(height: 12),

                                Row(
                                  children: [
                                    const Icon(Icons.pin_drop_outlined, size: 14, color: VanguardTheme.slate),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        issue.locationName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(fontSize: 12, color: VanguardTheme.slate),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 14),
                                Divider(color: Colors.white.withOpacity(0.06)),
                                const SizedBox(height: 8),

                                // Timeline and actions row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      issue.timeAgo,
                                      style: GoogleFonts.inter(fontSize: 11, color: VanguardTheme.slate),
                                    ),
                                    
                                    // Escalates / Upvote count trigger
                                    InkWell(
                                      onTap: () {
                                        state.toggleUpvoteIssue(issue.id);
                                      },
                                      borderRadius: VanguardTheme.borderSmall,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: issue.isUpvoted 
                                            ? VanguardTheme.actionGradientStart.withOpacity(0.15) 
                                            : VanguardTheme.background,
                                          borderRadius: VanguardTheme.borderSmall,
                                          border: Border.all(
                                            color: issue.isUpvoted 
                                              ? VanguardTheme.actionGradientStart.withOpacity(0.5) 
                                              : Colors.white.withOpacity(0.08),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.arrow_upward, 
                                              size: 14, 
                                              color: issue.isUpvoted ? VanguardTheme.actionGradientStart : VanguardTheme.slate,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              '${issue.upvotes} Escalates',
                                              style: GoogleFonts.inter(
                                                fontSize: 11, 
                                                fontWeight: FontWeight.bold,
                                                color: issue.isUpvoted ? VanguardTheme.actionGradientStart : VanguardTheme.slate,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_turned_in_outlined, color: VanguardTheme.slate, size: 48),
            const SizedBox(height: 16),
            Text(
              'No Reports match filters',
              style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: VanguardTheme.onSurface),
            ),
            const SizedBox(height: 6),
            Text(
              'Try swapping tabs or checking another category in the list above.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: VanguardTheme.slate),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(IssueStatus status) {
    Color col;
    String txt;
    if (status == IssueStatus.pending) {
      col = VanguardTheme.slate;
      txt = "Pending";
    } else if (status == IssueStatus.verified) {
      col = VanguardTheme.primary;
      txt = "Verified";
    } else if (status == IssueStatus.inProgress) {
      col = VanguardTheme.primaryContainer;
      txt = "In Progress";
    } else {
      col = VanguardTheme.success;
      txt = "Resolved";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: col.withOpacity(0.12),
        borderRadius: VanguardTheme.borderSmall,
      ),
      child: Text(
        txt.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: col,
        ),
      ),
    );
  }
}
