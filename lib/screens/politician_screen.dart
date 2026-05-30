import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/vanguard_theme.dart';
import '../models/civic_models.dart';

class PoliticianScreen extends StatefulWidget {
  const PoliticianScreen({super.key});

  @override
  State<PoliticianScreen> createState() => _PoliticianScreenState();
}

class _PoliticianScreenState extends State<PoliticianScreen> {
  int _activeProfileTab = 0; // 0 = Promises, 1 = Transparency, 2 = Timeline, 3 = Schemes
  int _activePromiseTab = 0; // 0 = Ongoing, 1 = Resolved
  final Set<String> _expandedPromiseIds = {};
  final Set<String> _expandedSchemeIds = {};

  String _formatCurrency(double? value) {
    if (value == null) return "N/A";
    if (value >= 10000000) {
      return "₹${(value / 10000000).toStringAsFixed(2)} Crores";
    } else if (value >= 100000) {
      return "₹${(value / 100000).toStringAsFixed(2)} Lakhs";
    } else {
      return "₹${value.toStringAsFixed(0)}";
    }
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return VanguardTheme.success;
      case 'In Progress':
        return const Color(0xFFF97316); // Brand Orange
      case 'Stalled':
        return const Color(0xFFE11D48); // Coral / Deep Rose
      case 'Broken':
        return Colors.redAccent;
      default:
        return VanguardTheme.slate;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Delivered':
        return Icons.check_circle;
      case 'In Progress':
        return Icons.hourglass_bottom;
      case 'Stalled':
        return Icons.pause_circle_filled;
      case 'Broken':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  Color _getMilestoneColor(String type) {
    switch (type) {
      case 'term_start':
        return Colors.blueAccent;
      case 'promise_completed':
        return VanguardTheme.success;
      case 'townhall':
        return const Color(0xFFF97316); // Brand Orange
      case 'achievement':
        return Colors.purpleAccent;
      case 'future_milestone':
        return Colors.cyanAccent;
      default:
        return VanguardTheme.slate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CivicState>(context);
    final String? passedId = ModalRoute.of(context)?.settings.arguments as String?;
    final index = passedId != null ? state.politicians.indexWhere((p) => p.id == passedId) : 0;
    final mla = index != -1 ? state.politicians[index] : state.politicians[0];

    return Scaffold(
      backgroundColor: VanguardTheme.background,
      body: Stack(
        children: [
          // Hero cover image with elegant dark overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 240,
            child: Container(
              color: const Color(0xFF131B2A),
              child: Opacity(
                opacity: 0.15,
                child: Image.network(
                  'https://images.unsplash.com/photo-1540910419892-4a36d2c3266c?auto=format&fit=crop&q=80&w=1000',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 240,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, VanguardTheme.background],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Scrollable page content
          Positioned.fill(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom App Bar Navigation
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: VanguardTheme.onSurface),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          'AUDIT PORTFOLIO',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: VanguardTheme.slate,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.share, color: VanguardTheme.onSurface),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),

                    // Politician Headshot & Bio Metadata Card
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 54,
                            backgroundColor: VanguardTheme.primaryContainer,
                            child: CircleAvatar(
                              radius: 51,
                              backgroundImage: NetworkImage(mla.photoUrl),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                mla.name,
                                style: GoogleFonts.sora(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: VanguardTheme.onSurface,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.verified, color: VanguardTheme.primaryContainer, size: 20),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            mla.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: VanguardTheme.slate,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: VanguardTheme.primaryContainer.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              mla.party,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: VanguardTheme.primaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Contact Action Grid Bar
                    Row(
                      children: [
                        Expanded(
                          child: _buildContactButton(
                            Icons.call, 'Call Office', () {}
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildContactButton(
                            Icons.email_outlined, 'Email', () {}
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildContactButton(
                            Icons.chat_bubble_outline, 'WhatsApp', () {}
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Compliance Scorecard Card Summary
                    Text(
                      'COMPLIANCE SCORECARD',
                      style: GoogleFonts.sora(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: VanguardTheme.slate,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: VanguardTheme.surfaceElevated,
                        borderRadius: VanguardTheme.borderMedium,
                        border: Border.all(color: Colors.white.withOpacity(0.06)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${(mla.approvalRate * 100).toInt()}%',
                                style: GoogleFonts.sora(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: VanguardTheme.primaryContainer,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Overall Audit Grade',
                                      style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold, color: VanguardTheme.onSurface),
                                    ),
                                    Text(
                                      'Refined index mapped to verified campaign timelines.',
                                      style: GoogleFonts.inter(fontSize: 11, color: VanguardTheme.slate),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Divider(color: Colors.white.withOpacity(0.06)),
                          const SizedBox(height: 16),
                          
                          // Dynamic linear progress bars by category
                          ...mla.promiseProgress.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          entry.key,
                                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: VanguardTheme.onSurface),
                                        ),
                                      ),
                                      Text(
                                        '${(entry.value * 100).toInt()}%',
                                        style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.bold, color: VanguardTheme.primaryContainer),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: entry.value,
                                      minHeight: 5,
                                      backgroundColor: VanguardTheme.background,
                                      valueColor: const AlwaysStoppedAnimation(VanguardTheme.primaryContainer),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Custom Horizontal Scrolling Tabs
                    _buildCustomTabBar(),

                    const SizedBox(height: 24),

                    // Swappable Tab Views
                    _buildActiveTabContent(mla),

                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: VanguardTheme.surfaceElevated.withOpacity(0.5),
                        borderRadius: VanguardTheme.borderMedium,
                        border: Border.all(color: Colors.white.withOpacity(0.04)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.info_outline, size: 14, color: VanguardTheme.primaryContainer),
                              const SizedBox(width: 8),
                              Text(
                                'DATA SOURCE & DISCLAIMER',
                                style: GoogleFonts.sora(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  color: VanguardTheme.primaryContainer,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Information is compiled from public sources. Users should verify latest updates.',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: VanguardTheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Attribution: Data sourced from MyNeta.info / ADR, PRS India, ECI',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              color: VanguardTheme.slate,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCustomTabBar() {
    final tabs = ['Promises', 'Transparency', 'Timeline', 'Schemes'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final idx = entry.key;
          final name = entry.value;
          final isSelected = _activeProfileTab == idx;
          return GestureDetector(
            onTap: () => setState(() => _activeProfileTab = idx),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected 
                    ? VanguardTheme.primaryContainer 
                    : VanguardTheme.surfaceElevated,
                borderRadius: VanguardTheme.borderMedium,
                border: Border.all(
                  color: isSelected 
                      ? Colors.transparent 
                      : Colors.white.withOpacity(0.06),
                ),
                boxShadow: isSelected ? VanguardTheme.buttonGlow : null,
              ),
              child: Text(
                name,
                style: GoogleFonts.sora(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : VanguardTheme.onSurface,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActiveTabContent(Politician mla) {
    switch (_activeProfileTab) {
      case 0:
        return _buildPromisesTab(mla);
      case 1:
        return _buildTransparencyTab(mla);
      case 2:
        return _buildTimelineTab(mla);
      case 3:
        return _buildSchemesTab(mla);
      default:
        return const SizedBox.shrink();
    }
  }

  // TAB 0: Promises Tab with Expandable Cards
  Widget _buildPromisesTab(Politician mla) {
    final list = _activePromiseTab == 0 
        ? mla.promises.where((p) => p.status != 'Delivered').toList()
        : mla.promises.where((p) => p.status == 'Delivered').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildPromiseToggleChip(0, 'Ongoing Campaigns (${mla.promises.where((p) => p.status != 'Delivered').length})'),
            const SizedBox(width: 8),
            _buildPromiseToggleChip(1, 'Resolved (${mla.promises.where((p) => p.status == 'Delivered').length})'),
          ],
        ),
        const SizedBox(height: 16),
        if (list.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Text(
                'No campaign promises in this state.',
                style: GoogleFonts.inter(color: VanguardTheme.slate, fontSize: 13),
              ),
            ),
          )
        else
          ...list.map((promise) => _buildPromiseCard(promise)).toList(),
      ],
    );
  }

  Widget _buildPromiseToggleChip(int tabIdx, String label) {
    final isSelected = _activePromiseTab == tabIdx;
    return GestureDetector(
      onTap: () => setState(() => _activePromiseTab = tabIdx),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.08) : Colors.transparent,
          borderRadius: VanguardTheme.borderMedium,
          border: Border.all(
            color: isSelected ? Colors.white.withOpacity(0.12) : Colors.white.withOpacity(0.04),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? VanguardTheme.onSurface : VanguardTheme.slate,
          ),
        ),
      ),
    );
  }

  Widget _buildPromiseCard(PoliticianPromise promise) {
    final isExpanded = _expandedPromiseIds.contains(promise.id);
    final statusColor = _getStatusColor(promise.status);
    final statusIcon = _getStatusIcon(promise.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: VanguardTheme.surfaceElevated,
        borderRadius: VanguardTheme.borderMedium,
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: PageStorageKey(promise.id),
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              if (expanded) {
                _expandedPromiseIds.add(promise.id);
              } else {
                _expandedPromiseIds.remove(promise.id);
              }
            });
          },
          leading: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, size: 16, color: statusColor),
          ),
          title: Text(
            promise.title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: VanguardTheme.onSurface,
              height: 1.4,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    promise.status,
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    promise.category,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: VanguardTheme.slate,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          trailing: Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: VanguardTheme.slate,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.white.withOpacity(0.06), height: 16),
                  Text(
                    promise.description.isNotEmpty 
                        ? promise.description 
                        : "No detailed descriptive summary has been documented for this campaign promise yet.",
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: VanguardTheme.onSurface.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: VanguardTheme.primaryContainer),
                          const SizedBox(width: 6),
                          Text(
                            promise.dueDate != null 
                                ? "Target: ${_formatDate(promise.dueDate!)}" 
                                : "No due date set",
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: VanguardTheme.primaryContainer,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.white.withOpacity(0.04)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.folder_shared_outlined, size: 12, color: VanguardTheme.success),
                            const SizedBox(width: 6),
                            Text(
                              "${promise.evidenceCount} Citizen Audits",
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: VanguardTheme.success,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // TAB 1: Transparency & Bio
  Widget _buildTransparencyTab(Politician mla) {
    final assetLiabilitiesRatio = (mla.assets != null && mla.assets! > 0 && mla.liabilities != null)
        ? (mla.liabilities! / mla.assets!)
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Biography Card
        Text(
          'BIOGRAPHY',
          style: GoogleFonts.sora(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: VanguardTheme.slate,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: VanguardTheme.surfaceElevated,
            borderRadius: VanguardTheme.borderMedium,
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: Text(
            mla.bio ?? "Biography not provided.",
            style: GoogleFonts.inter(
              fontSize: 13,
              color: VanguardTheme.onSurface.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Financial Disclosures
        Text(
          'FINANCIAL COMPLIANCE DECLARATIONS',
          style: GoogleFonts.sora(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: VanguardTheme.slate,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: VanguardTheme.surfaceElevated,
            borderRadius: VanguardTheme.borderMedium,
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Declared Assets',
                        style: GoogleFonts.inter(fontSize: 11, color: VanguardTheme.slate),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatCurrency(mla.assets),
                        style: GoogleFonts.sora(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: VanguardTheme.primaryContainer,
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Liabilities',
                        style: GoogleFonts.inter(fontSize: 11, color: VanguardTheme.slate),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatCurrency(mla.liabilities),
                        style: GoogleFonts.sora(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 6,
                  color: VanguardTheme.background,
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: assetLiabilitiesRatio.clamp(0.02, 1.0),
                    child: Container(
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Liabilities comprise ${(assetLiabilitiesRatio * 100).toStringAsFixed(1)}% of total declared assets.',
                style: GoogleFonts.inter(fontSize: 10.5, color: VanguardTheme.slate),
              )
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Education & Legal Records
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VERIFIED EDUCATION',
                    style: GoogleFonts.sora(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: VanguardTheme.slate,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    height: 120,
                    decoration: BoxDecoration(
                      color: VanguardTheme.surfaceElevated,
                      borderRadius: VanguardTheme.borderMedium,
                      border: Border.all(color: Colors.white.withOpacity(0.04)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.school, size: 20, color: VanguardTheme.primaryContainer),
                        const SizedBox(height: 10),
                        Text(
                          mla.education ?? "Not declared",
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: VanguardTheme.onSurface,
                            height: 1.3,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LEGAL HISTORY',
                    style: GoogleFonts.sora(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: VanguardTheme.slate,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    height: 120,
                    decoration: BoxDecoration(
                      color: mla.criminalCases == 0 
                          ? const Color(0xFF22C55E).withOpacity(0.08) 
                          : Colors.redAccent.withOpacity(0.08),
                      borderRadius: VanguardTheme.borderMedium,
                      border: Border.all(
                        color: mla.criminalCases == 0 
                            ? const Color(0xFF22C55E).withOpacity(0.2) 
                            : Colors.redAccent.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          mla.criminalCases == 0 ? Icons.gavel : Icons.warning_amber_rounded,
                          size: 20,
                          color: mla.criminalCases == 0 ? const Color(0xFF22C55E) : Colors.redAccent,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          mla.criminalCases == 0 
                              ? 'Fully Disclosed Clean Record' 
                              : '${mla.criminalCases} Pending Criminal Cases',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: mla.criminalCases == 0 ? const Color(0xFF22C55E) : Colors.redAccent,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  // TAB 2: Constituency Timeline widget
  Widget _buildTimelineTab(Politician mla) {
    if (mla.timeline.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            'No milestones tracked on the profile yet.',
            style: GoogleFonts.inter(color: VanguardTheme.slate, fontSize: 13),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OFFICIAL PERFORMANCE TIMELINE',
          style: GoogleFonts.sora(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: VanguardTheme.slate,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mla.timeline.length,
          itemBuilder: (context, index) {
            final milestone = mla.timeline[index];
            final isLast = index == mla.timeline.length - 1;
            final itemColor = _getMilestoneColor(milestone.type);

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Milestone timeline tracks
                  Column(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: itemColor.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: itemColor,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          milestone.icon ?? Icons.circle,
                          size: 11,
                          color: itemColor,
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  
                  // Milestone detailed info
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  milestone.title,
                                  style: GoogleFonts.sora(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: VanguardTheme.onSurface,
                                  ),
                                ),
                              ),
                              Text(
                                _formatDate(milestone.date),
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: VanguardTheme.primaryContainer,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            milestone.description,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: VanguardTheme.slate,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // TAB 3: Ward Schemes Tab
  Widget _buildSchemesTab(Politician mla) {
    if (mla.schemes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            'No active civic schemes configured.',
            style: GoogleFonts.inter(color: VanguardTheme.slate, fontSize: 13),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CONSTITUENCY WELFARE SCHEMES',
          style: GoogleFonts.sora(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: VanguardTheme.slate,
          ),
        ),
        const SizedBox(height: 16),
        ...mla.schemes.map((scheme) => _buildSchemeCard(scheme)).toList(),
      ],
    );
  }

  Widget _buildSchemeCard(PoliticianScheme scheme) {
    final isExpanded = _expandedSchemeIds.contains(scheme.id);
    final isActive = scheme.status == 'Active';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: VanguardTheme.surfaceElevated,
        borderRadius: VanguardTheme.borderMedium,
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: PageStorageKey(scheme.id),
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              if (expanded) {
                _expandedSchemeIds.add(scheme.id);
              } else {
                _expandedSchemeIds.remove(scheme.id);
              }
            });
          },
          title: Text(
            scheme.title,
            style: GoogleFonts.sora(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: VanguardTheme.onSurface,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isActive 
                        ? const Color(0xFF22C55E).withOpacity(0.12) 
                        : VanguardTheme.slate.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    scheme.status,
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: isActive ? const Color(0xFF22C55E) : VanguardTheme.slate,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Launched: ${_formatDate(scheme.createdAt)}",
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: VanguardTheme.slate,
                  ),
                )
              ],
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.white.withOpacity(0.06), height: 16),
                  Text(
                    scheme.description,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: VanguardTheme.onSurface.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  
                  // Grid stats of schemes
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.02),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.white.withOpacity(0.02)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Budget Allocation',
                                style: GoogleFonts.inter(fontSize: 10, color: VanguardTheme.slate),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                scheme.budgetAllocated,
                                style: GoogleFonts.sora(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: VanguardTheme.primaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.02),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.white.withOpacity(0.02)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Target Beneficiaries',
                                style: GoogleFonts.inter(fontSize: 10, color: VanguardTheme.slate),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                scheme.beneficiariesCount,
                                style: GoogleFonts.sora(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: VanguardTheme.success,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Eligibility detailed checklist
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: VanguardTheme.background.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white.withOpacity(0.04)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.assignment_ind_outlined, size: 12, color: VanguardTheme.primaryContainer),
                            const SizedBox(width: 6),
                            Text(
                              'ELIGIBILITY CRITERIA',
                              style: GoogleFonts.sora(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: VanguardTheme.primaryContainer,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          scheme.eligibility,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: VanguardTheme.slate,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: VanguardTheme.borderMedium,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: VanguardTheme.surfaceElevated,
          borderRadius: VanguardTheme.borderMedium,
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          children: [
            Icon(icon, color: VanguardTheme.primaryContainer, size: 20),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: VanguardTheme.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
