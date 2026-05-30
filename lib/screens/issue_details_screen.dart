import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/vanguard_theme.dart';
import '../models/civic_models.dart';

class IssueDetailsScreen extends StatefulWidget {
  const IssueDetailsScreen({super.key});

  @override
  State<IssueDetailsScreen> createState() => _IssueDetailsScreenState();
}

class _IssueDetailsScreenState extends State<IssueDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();

  void _postComment(CivicState state, String issueId) {
    if (_commentController.text.trim().isEmpty) return;
    state.addCommentToIssue(issueId, _commentController.text.trim());
    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  void _showFlagDialog(BuildContext context, CivicState state, String issueId) {
    String selectedType = 'coordinated';
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                'FLAG SUSPICIOUS REPORT',
                style: GoogleFonts.sora(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: VanguardTheme.onSurface,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flag this report for coordinated spam or political voter manipulation.',
                      style: GoogleFonts.inter(fontSize: 12, color: VanguardTheme.slate),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'SUSPICIOUS ACTIVITY TYPE',
                      style: GoogleFonts.sora(fontSize: 10, fontWeight: FontWeight.bold, color: VanguardTheme.slate),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: VanguardTheme.surfaceContainerHigh,
                        borderRadius: VanguardTheme.borderDefault,
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedType,
                          dropdownColor: VanguardTheme.surfaceElevated,
                          isExpanded: true,
                          style: GoogleFonts.inter(fontSize: 13, color: VanguardTheme.onSurface),
                          items: const [
                            DropdownMenuItem(value: 'ip_burst', child: Text('IP Burst / Multiple Reports')),
                            DropdownMenuItem(value: 'text_similarity', child: Text('Duplicate / Copy-Paste Spam')),
                            DropdownMenuItem(value: 'geo_burst', child: Text('Geo Burst / Spatial Spam')),
                            DropdownMenuItem(value: 'coordinated', child: Text('Coordinated Upvote Attack')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() => selectedType = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'REASON / EVIDENCE DETAILS',
                      style: GoogleFonts.sora(fontSize: 10, fontWeight: FontWeight.bold, color: VanguardTheme.slate),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: reasonController,
                      maxLines: 3,
                      style: GoogleFonts.inter(fontSize: 13, color: VanguardTheme.onSurface),
                      decoration: const InputDecoration(
                        hintText: 'Enter investigative notes or reasons for flagging this report...',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(color: VanguardTheme.slate, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (reasonController.text.trim().isEmpty) return;
                    state.flagIssueManual(
                      issueId: issueId,
                      reason: reasonController.text.trim(),
                      type: selectedType,
                      severity: selectedType == 'coordinated' || selectedType == 'ip_burst' ? 3 : 2,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Report successfully flagged for review.'),
                        backgroundColor: Color(0xFFEF4444),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Flag Report',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCommunityFlagDialog(BuildContext context, CivicState state, String issueId) {
    final TextEditingController reasonController = TextEditingController();
    String selectedType = 'coordinated';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                'COMMUNITY SUSPICIOUS REPORT',
                style: GoogleFonts.sora(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: VanguardTheme.onSurface,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tell us why you believe this report is suspicious, duplicate, or contains coordinated votings.',
                    style: GoogleFonts.inter(fontSize: 11, color: VanguardTheme.slate),
                  ),
                  const SizedBox(height: 12),
                  DropdownButton<String>(
                    value: selectedType,
                    dropdownColor: VanguardTheme.surfaceElevated,
                    isExpanded: true,
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.white),
                    items: const [
                      DropdownMenuItem(value: 'coordinated', child: Text('Coordinated voter astroturfing')),
                      DropdownMenuItem(value: 'text_similarity', child: Text('Duplicate / copy spam')),
                      DropdownMenuItem(value: 'geo_burst', child: Text('Spoofed locations')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedType = val);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: reasonController,
                    maxLines: 2,
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Enter reason for this suspicious flag audit...',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: GoogleFonts.inter(color: VanguardTheme.slate)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  onPressed: () {
                    if (reasonController.text.trim().isEmpty) return;
                    state.reportIssueSuspicious(
                      issueId,
                      reasonController.text.trim(),
                      selectedType,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thank you. Civic safety team has logged this community report.'),
                        backgroundColor: Colors.amber,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text('File Audit Alert', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCaptchaDialog(BuildContext context, CivicState state) {
    int cap1 = 3 + (DateTime.now().second % 7);
    int cap2 = 2 + (DateTime.now().millisecond % 5);
    int answer = cap1 + cap2;
    final TextEditingController captchaController = TextEditingController();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.security, color: VanguardTheme.primaryContainer),
              const SizedBox(width: 8),
              Text(
                'BOT COUNTER CAPTCHA',
                style: GoogleFonts.sora(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: VanguardTheme.onSurface,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'High-velocity upvoting signature detected. Please solve the security puzzle to verify you are human.',
                style: GoogleFonts.inter(fontSize: 11, color: VanguardTheme.slate),
              ),
              const SizedBox(height: 16),
              Text(
                'What is $cap1 + $cap2?',
                style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.bold, color: VanguardTheme.onSurface),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: captchaController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter answer...',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final input = int.tryParse(captchaController.text.trim());
                if (input == answer) {
                  state.verifyCaptcha();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Verification success! Bot-limit cleared.'),
                      backgroundColor: Color(0xFF10B981),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Incorrect CAPTCHA answer. Try again.'),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: VanguardTheme.primaryContainer,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Verify & Continue',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lookup argument passed (issueId)
    final issueId = ModalRoute.of(context)!.settings.arguments as String? ?? "issue_001";
    final state = Provider.of<CivicState>(context);
    
    // Find the issue
    final issueIndex = state.issues.indexWhere((element) => element.id == issueId);
    if (issueIndex == -1) {
      return Scaffold(
        backgroundColor: VanguardTheme.background,
        body: Center(child: Text('Grievance not found', style: GoogleFonts.sora(color: Colors.white))),
      );
    }
    
    final issue = state.issues[issueIndex];

    if (state.captchaTriggered) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCaptchaDialog(context, state);
      });
    }

    return Scaffold(
      backgroundColor: VanguardTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: VanguardTheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Timeline Tracking',
          style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: VanguardTheme.onSurface),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.outlined_flag, color: Color(0xFFEF4444)),
            tooltip: 'Flag suspicious report',
            onPressed: () {
              _showFlagDialog(context, state, issue.id);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Visual Header Image
                    ClipRRect(
                      borderRadius: VanguardTheme.borderMedium,
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        color: VanguardTheme.surfaceBright,
                        child: Image.network(
                          issue.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                              const Icon(Icons.broken_image, size: 48, color: VanguardTheme.slate),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Metadata tags
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: VanguardTheme.primaryContainer.withOpacity(0.12),
                            borderRadius: VanguardTheme.borderSmall,
                          ),
                          child: Text(
                            issue.category.toUpperCase(),
                            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: VanguardTheme.primaryContainer),
                          ),
                        ),
                        _buildStatusChip(issue.status),
                      ],
                    ),
                    
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (issue.gpsVerified)
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.12),
                              borderRadius: VanguardTheme.borderSmall,
                              border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.gps_fixed, size: 10, color: Color(0xFF10B981)),
                                const SizedBox(width: 4),
                                Text(
                                  "GPS BOUNDARY VERIFIED",
                                  style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: const Color(0xFF10B981)),
                                ),
                              ],
                            ),
                          ),
                        if (issue.exifVerified)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.12),
                              borderRadius: VanguardTheme.borderSmall,
                              border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.photo_camera, size: 10, color: Color(0xFF10B981)),
                                const SizedBox(width: 4),
                                Text(
                                  "EXIF TIMESTAMP VERIFIED",
                                  style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: const Color(0xFF10B981)),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Text(
                      issue.title,
                      style: GoogleFonts.sora(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: VanguardTheme.onSurface,
                      ),
                    ),
                    
                    const SizedBox(height: 6),
                    
                    Text(
                      issue.locationName,
                      style: GoogleFonts.inter(fontSize: 13, color: VanguardTheme.slate),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Text(
                      issue.description,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.5,
                        color: VanguardTheme.onSurface.withOpacity(0.85),
                      ),
                    ),

                    const SizedBox(height: 24),
                    
                    // Escalation agree panel
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: VanguardTheme.surfaceElevated,
                        borderRadius: VanguardTheme.borderMedium,
                        border: Border.all(color: Colors.white.withOpacity(0.06)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${issue.upvotes} Citizens Mobilized',
                                  style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold, color: VanguardTheme.onSurface),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'At 250 escalates, Netagram auto-triggers CPGRAMS dispatch.',
                                  style: GoogleFonts.inter(fontSize: 11, color: VanguardTheme.slate),
                                ),
                              ],
                            ),
                          ),
                          
                          // Escalate trigger
                          GestureDetector(
                            onTap: () {
                              state.toggleUpvoteIssue(issue.id);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: issue.isUpvoted ? VanguardTheme.actionGradient : null,
                                color: issue.isUpvoted ? null : VanguardTheme.background,
                                borderRadius: VanguardTheme.borderMedium,
                                border: Border.all(
                                  color: issue.isUpvoted ? Colors.transparent : VanguardTheme.primaryContainer,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_upward, 
                                    size: 16, 
                                    color: issue.isUpvoted ? Colors.white : VanguardTheme.primaryContainer,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    issue.isUpvoted ? 'AGREED' : 'AGREE',
                                    style: GoogleFonts.inter(
                                      fontSize: 12, 
                                      fontWeight: FontWeight.bold,
                                      color: issue.isUpvoted ? Colors.white : VanguardTheme.primaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Vertical tracking timeline
                    Text(
                      'RESOLVING TIMELINE',
                      style: GoogleFonts.sora(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: VanguardTheme.slate,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildTimelineStep("Grievance Lodged", "Registered with encrypted citizen signature.", true),
                    _buildTimelineStep("OTP Consensus Secured", "Verified locally by 3 adjacent citizens.", issue.status != IssueStatus.pending),
                    _buildTimelineStep("Municipal Assignment", "Assigned to PWD Sub-Engineer (Grid 142).", issue.status == IssueStatus.inProgress || issue.status == IssueStatus.resolved),
                    _buildTimelineStep("Grievance Resolved", "Sanitation work completed and verified by citizens.", issue.status == IssueStatus.resolved, isLast: true),

                    const SizedBox(height: 28),

                    // Verifiable details
                    Text(
                      'LEDGER VERIFICATION',
                      style: GoogleFonts.sora(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: VanguardTheme.slate,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: VanguardTheme.surfaceElevated,
                        borderRadius: VanguardTheme.borderMedium,
                        border: Border.all(color: Colors.white.withOpacity(0.06)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Digital Signature: BBMP-GRID142-SIG-X092',
                            style: GoogleFonts.inter(fontSize: 11, color: VanguardTheme.primaryContainer, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Timestamp: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(issue.dateFiled)} UTC\nCoordinates: ${issue.latitude}, ${issue.longitude}\nAuthor: ${issue.reporterName} (OTP Checked)',
                            style: GoogleFonts.inter(fontSize: 12, color: VanguardTheme.slate, height: 1.4),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Community discussion timeline
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'COMMUNITY FEEDBACK (${issue.comments.length})',
                          style: GoogleFonts.sora(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            color: VanguardTheme.slate,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            _showCommunityFlagDialog(context, state, issue.id);
                          },
                          icon: const Icon(Icons.report_problem, size: 12, color: Colors.amber),
                          label: Text(
                            'Report as Suspicious',
                            style: GoogleFonts.inter(fontSize: 10, color: Colors.amber, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Comments list
                    issue.comments.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            'No citizen comments yet. Write one below to coordinate action!',
                            style: GoogleFonts.inter(fontSize: 12, color: VanguardTheme.slate, fontStyle: FontStyle.italic),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: issue.comments.length,
                          itemBuilder: (context, index) {
                            final comment = issue.comments[index];
                            final isOfficial = comment.authorBadge == "Official";
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isOfficial ? VanguardTheme.surfaceBright.withOpacity(0.4) : VanguardTheme.surfaceElevated,
                                borderRadius: VanguardTheme.borderDefault,
                                border: Border.all(
                                  color: isOfficial 
                                    ? VanguardTheme.primaryContainer.withOpacity(0.2) 
                                    : Colors.white.withOpacity(0.04),
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
                                          Text(
                                            comment.authorName,
                                            style: GoogleFonts.inter(
                                              fontSize: 12, 
                                              fontWeight: FontWeight.bold, 
                                              color: isOfficial ? VanguardTheme.primaryContainer : VanguardTheme.onSurface,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                            decoration: BoxDecoration(
                                              color: (isOfficial ? VanguardTheme.primaryContainer : VanguardTheme.slate).withOpacity(0.12),
                                              borderRadius: VanguardTheme.borderSmall,
                                            ),
                                            child: Text(
                                              comment.authorBadge.toUpperCase(),
                                              style: GoogleFonts.inter(
                                                fontSize: 8, 
                                                fontWeight: FontWeight.bold, 
                                                color: isOfficial ? VanguardTheme.primaryContainer : VanguardTheme.slate,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        'Just now',
                                        style: GoogleFonts.inter(fontSize: 10, color: VanguardTheme.slate),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    comment.text,
                                    style: GoogleFonts.inter(fontSize: 13, color: VanguardTheme.onSurface.withOpacity(0.9), height: 1.3),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            
            // Bottom comment input box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: VanguardTheme.surfaceElevated,
                border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: GoogleFonts.inter(color: VanguardTheme.onSurface, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Share verification update or query PWD...',
                        hintStyle: GoogleFonts.inter(fontSize: 13, color: VanguardTheme.slate),
                        filled: true,
                        fillColor: VanguardTheme.background,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: VanguardTheme.borderDefault,
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: VanguardTheme.primaryContainer,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 18),
                      onPressed: () => _postComment(state, issue.id),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep(String label, String description, bool isCompleted, {bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? VanguardTheme.success : Colors.transparent,
                  border: Border.all(
                    color: isCompleted ? VanguardTheme.success : VanguardTheme.slate.withOpacity(0.5),
                    width: 2.0,
                  ),
                ),
                child: isCompleted
                  ? const Icon(Icons.check, size: 12, color: Colors.black)
                  : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? VanguardTheme.success : VanguardTheme.slate.withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.sora(
                      fontSize: 13, 
                      fontWeight: FontWeight.bold, 
                      color: isCompleted ? VanguardTheme.onSurface : VanguardTheme.slate,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 11, 
                      color: VanguardTheme.slate,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
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
