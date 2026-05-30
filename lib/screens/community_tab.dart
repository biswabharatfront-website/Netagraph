import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/vanguard_theme.dart';
import '../models/civic_models.dart';

class CommunityTab extends StatefulWidget {
  const CommunityTab({super.key});

  @override
  State<CommunityTab> createState() => _CommunityTabState();
}

class _CommunityTabState extends State<CommunityTab> {
  int _activePanelIndex = 0; // 0 = Discussions, 1 = Announcements, 2 = Events

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CivicState>(context);
    final selectedWard = state.selectedWard.isNotEmpty 
        ? state.selectedWard.split(" - ").last.replaceAll(" (Bengaluru)", "") 
        : "Varthur";

    return Scaffold(
      backgroundColor: VanguardTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ward header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'COMMUNITY BOARD',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: VanguardTheme.primaryContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$selectedWard Circle',
                        style: GoogleFonts.sora(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: VanguardTheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Create announcement/discussion selector button
                      IconButton(
                        onPressed: () {
                          if (_activePanelIndex == 1) {
                            Navigator.pushNamed(context, '/add_announcement');
                          } else {
                            Navigator.pushNamed(context, '/add_discussion');
                          }
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: VanguardTheme.primaryContainer.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: VanguardTheme.primaryContainer, size: 20),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pushNamed(context, '/community_chat'),
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: VanguardTheme.primaryContainer.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.forum_outlined, color: VanguardTheme.primaryContainer, size: 20),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pushNamed(context, '/events_screen'),
                        icon: const Icon(Icons.calendar_today_outlined, color: VanguardTheme.onSurface, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 20),

              // Segmented panel toggles
              Container(
                height: 46,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: VanguardTheme.surfaceElevated,
                  borderRadius: VanguardTheme.borderMedium,
                  border: Border.all(color: Colors.white.withOpacity(0.04)),
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildPanelToggle(0, 'Discussions')),
                    Expanded(child: _buildPanelToggle(1, 'Announce')),
                    Expanded(child: _buildPanelToggle(2, 'Events')),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Dynamic Panels
              Expanded(
                child: IndexedStack(
                  index: _activePanelIndex,
                  children: [
                    _buildDiscussionsPanel(context, state),
                    _buildAnnouncementsPanel(context, state),
                    _buildEventsPanel(context, state),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPanelToggle(int index, String label) {
    final isActive = _activePanelIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activePanelIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? VanguardTheme.surfaceContainerHigh : Colors.transparent,
          borderRadius: VanguardTheme.borderDefault,
        ),
        child: Text(
          label,
          style: GoogleFonts.sora(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? VanguardTheme.onSurface : VanguardTheme.slate,
          ),
        ),
      ),
    );
  }

  // PANEL 1: Discussions View
  Widget _buildDiscussionsPanel(BuildContext context, CivicState state) {
    return state.discussions.isEmpty
        ? _buildEmptyState('No Discussions Started', 'Be the first to raise a civic query in Varthur.', Icons.forum_outlined)
        : ListView.builder(
            itemCount: state.discussions.length,
            itemBuilder: (context, index) {
              final thread = state.discussions[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
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
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: VanguardTheme.primaryContainer.withOpacity(0.1),
                          child: const Icon(Icons.person, size: 12, color: VanguardTheme.primaryContainer),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          thread.authorName,
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: VanguardTheme.onSurface),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: VanguardTheme.primaryContainer.withOpacity(0.12),
                            borderRadius: VanguardTheme.borderSmall,
                          ),
                          child: Text(
                            thread.authorRole.toUpperCase(),
                            style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: VanguardTheme.primaryContainer),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          thread.timeAgo,
                          style: GoogleFonts.inter(fontSize: 11, color: VanguardTheme.slate),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      thread.title,
                      style: GoogleFonts.sora(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: VanguardTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      thread.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        height: 1.4,
                        color: VanguardTheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.white.withOpacity(0.06)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Upvotes
                        GestureDetector(
                          onTap: () {
                            state.upvoteDiscussion(thread.id);
                          },
                          child: Row(
                            children: [
                              Icon(
                                thread.isUpvoted ? Icons.thumb_up : Icons.thumb_up_off_alt,
                                size: 16,
                                color: thread.isUpvoted ? VanguardTheme.primaryContainer : VanguardTheme.slate,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${thread.upvotes} Agree',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: thread.isUpvoted ? VanguardTheme.primaryContainer : VanguardTheme.slate,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Replies indicator
                        Row(
                          children: [
                            const Icon(Icons.mode_comment_outlined, size: 16, color: VanguardTheme.slate),
                            const SizedBox(width: 6),
                            Text(
                              '${thread.replies.length} Replies',
                              style: GoogleFonts.inter(fontSize: 12, color: VanguardTheme.slate),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
  }

  // PANEL 2: Announcements View
  Widget _buildAnnouncementsPanel(BuildContext context, CivicState state) {
    return state.announcements.isEmpty
        ? _buildEmptyState('No Official Bulletins', 'Everything is running smoothly in Varthur.', Icons.campaign_outlined)
        : ListView.builder(
            itemCount: state.announcements.length,
            itemBuilder: (context, index) {
              final ann = state.announcements[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: VanguardTheme.surfaceElevated,
                  borderRadius: VanguardTheme.borderMedium,
                  border: Border.all(
                    color: ann.isUrgent 
                      ? VanguardTheme.actionGradientStart.withOpacity(0.4) 
                      : Colors.white.withOpacity(0.06),
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
                            const Icon(Icons.shield, color: VanguardTheme.primaryContainer, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              ann.authorName,
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: VanguardTheme.primaryContainer),
                            ),
                          ],
                        ),
                        if (ann.isUrgent)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: VanguardTheme.actionGradientStart.withOpacity(0.15),
                              borderRadius: VanguardTheme.borderSmall,
                            ),
                            child: Text(
                              'URGENT',
                              style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: VanguardTheme.actionGradientStart),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      ann.title,
                      style: GoogleFonts.sora(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: VanguardTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ann.content,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        height: 1.4,
                        color: VanguardTheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        ann.timeAgo,
                        style: GoogleFonts.inter(fontSize: 11, color: VanguardTheme.slate),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }

  // PANEL 3: Events View
  Widget _buildEventsPanel(BuildContext context, CivicState state) {
    return state.events.isEmpty
        ? _buildEmptyState('No Public Assemblies Scheduled', 'Grievance drives will be posted soon.', Icons.calendar_today_outlined)
        : ListView.builder(
            itemCount: state.events.length,
            itemBuilder: (context, index) {
              final ev = state.events[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            ev.title,
                            style: GoogleFonts.sora(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: VanguardTheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: VanguardTheme.primaryContainer.withOpacity(0.12),
                            borderRadius: VanguardTheme.borderSmall,
                          ),
                          child: Text(
                            ev.dateText,
                            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: VanguardTheme.primaryContainer),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ev.description,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        height: 1.4,
                        color: VanguardTheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 14),
                    
                    // Venue & Time details
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: VanguardTheme.slate),
                        const SizedBox(width: 6),
                        Text(
                          ev.timeText,
                          style: GoogleFonts.inter(fontSize: 12, color: VanguardTheme.slate),
                        ),
                        const SizedBox(width: 14),
                        const Icon(Icons.pin_drop_outlined, size: 14, color: VanguardTheme.slate),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            ev.locationText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(fontSize: 12, color: VanguardTheme.slate),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 14),
                    Divider(color: Colors.white.withOpacity(0.06)),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${ev.rsvpCount} Attending',
                          style: GoogleFonts.inter(fontSize: 12, color: VanguardTheme.slate),
                        ),
                        
                        // RSVP Button
                        GestureDetector(
                          onTap: () {
                            state.toggleRSVP(ev.id);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: ev.isRSVPed ? VanguardTheme.success : Colors.transparent,
                              borderRadius: VanguardTheme.borderSmall,
                              border: Border.all(
                                color: ev.isRSVPed ? VanguardTheme.success : VanguardTheme.primaryContainer,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  ev.isRSVPed ? Icons.check : Icons.star_border,
                                  size: 14,
                                  color: ev.isRSVPed ? Colors.black : VanguardTheme.primaryContainer,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  ev.isRSVPed ? 'Going!' : 'RSVP',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: ev.isRSVPed ? Colors.black : VanguardTheme.primaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
  }

  Widget _buildEmptyState(String title, String desc, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: VanguardTheme.slate, size: 48),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: VanguardTheme.onSurface),
            ),
            const SizedBox(height: 6),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: VanguardTheme.slate),
            ),
          ],
        ),
      ),
    );
  }
}
