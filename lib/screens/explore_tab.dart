import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../theme/vanguard_theme.dart';
import '../models/civic_models.dart';
import '../utils/map_styles.dart';

class ExploreTab extends StatelessWidget {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CivicState>(context);
    final mla = state.politicians[0];
    final selectedWard = state.selectedWard.isNotEmpty 
        ? state.selectedWard.split(" - ").last.replaceAll(" (Bengaluru)", "") 
        : "Varthur";

    return Scaffold(
      backgroundColor: VanguardTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CIVIC INTELLIGENCE HUB',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: VanguardTheme.primaryContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: VanguardTheme.primaryContainer, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            selectedWard,
                            style: GoogleFonts.sora(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: VanguardTheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/leaders_list');
                        },
                        icon: const Icon(Icons.supervised_user_circle_outlined, color: VanguardTheme.onSurface),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/hub');
                        },
                        child: CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(state.currentUser.avatarUrl),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              
              const SizedBox(height: 24),

              // Politician Profile Card
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/politician_profile');
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: VanguardTheme.surfaceElevated,
                    borderRadius: VanguardTheme.borderMedium,
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(mla.photoUrl),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      mla.name,
                                      style: GoogleFonts.sora(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: VanguardTheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(Icons.verified, color: VanguardTheme.primaryContainer, size: 16),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  mla.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: VanguardTheme.slate,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: VanguardTheme.success.withOpacity(0.12),
                              borderRadius: VanguardTheme.borderSmall,
                            ),
                            child: Text(
                              '${(mla.approvalRate * 100).toInt()}% APP',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: VanguardTheme.success,
                              ),
                            ),
                          )
                        ],
                      ),
                      
                      const SizedBox(height: 14),
                      Divider(color: Colors.white.withOpacity(0.06)),
                      const SizedBox(height: 10),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Click to audit promises & track logs',
                            style: GoogleFonts.inter(fontSize: 12, color: VanguardTheme.slate),
                          ),
                          const Icon(Icons.arrow_right_alt, color: VanguardTheme.primaryContainer, size: 20),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Promises compliance dashboard
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PROMISE TRACKER',
                    style: GoogleFonts.sora(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: VanguardTheme.slate,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/politician_profile');
                    },
                    child: Text(
                      'All 5 Core Promises',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: VanguardTheme.primaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: VanguardTheme.surfaceElevated,
                  borderRadius: VanguardTheme.borderMedium,
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: Column(
                  children: mla.promiseProgress.entries.take(3).map((entry) {
                    final double progress = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  entry.key,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: VanguardTheme.onSurface,
                                  ),
                                ),
                              ),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: GoogleFonts.sora(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: progress > 0.5 ? VanguardTheme.primaryContainer : VanguardTheme.slate,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: VanguardTheme.background,
                              valueColor: AlwaysStoppedAnimation(
                                progress > 0.5 ? VanguardTheme.primaryContainer : VanguardTheme.slate,
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // Interactive map boundary container
              Text(
                'WARD INCIDENT MAP',
                style: GoogleFonts.sora(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: VanguardTheme.slate,
                ),
              ),
              
              const SizedBox(height: 12),

              ClipRRect(
                borderRadius: VanguardTheme.borderMedium,
                child: SizedBox(
                  height: 180,
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: const CameraPosition(
                          target: LatLng(12.9428, 77.7471),
                          zoom: 14.0,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('issue_001'),
                            position: const LatLng(12.9428, 77.7471),
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                            infoWindow: const InfoWindow(title: 'Severe Potholes'),
                            onTap: () {
                              Navigator.pushNamed(context, '/issue_details', arguments: 'issue_001');
                            },
                          ),
                          Marker(
                            markerId: const MarkerId('issue_002'),
                            position: const LatLng(12.9395, 77.7412),
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                            infoWindow: const InfoWindow(title: 'Broken Streetlight'),
                            onTap: () {
                              Navigator.pushNamed(context, '/issue_details', arguments: 'issue_002');
                            },
                          ),
                          Marker(
                            markerId: const MarkerId('issue_003'),
                            position: const LatLng(12.9451, 77.7505),
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                            infoWindow: const InfoWindow(title: 'Garbage Dump'),
                            onTap: () {
                              Navigator.pushNamed(context, '/issue_details', arguments: 'issue_003');
                            },
                          ),
                        },
                        onMapCreated: (controller) {
                          controller.setMapStyle(MapStyles.darkStyle);
                        },
                        onTap: (_) {
                          Navigator.pushNamed(context, '/ward_boundary');
                        },
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        mapToolbarEnabled: false,
                        compassEnabled: false,
                        scrollGesturesEnabled: false,
                        zoomGesturesEnabled: false,
                        rotateGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                      ),

                      // Map indicator tag
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: VanguardTheme.borderSmall,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.pin_drop, color: VanguardTheme.primaryContainer, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                '3 Active Reports pinned',
                                style: GoogleFonts.inter(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Live active cases feed
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'RECENT CONSTITUENCY REPORTS',
                    style: GoogleFonts.sora(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: VanguardTheme.slate,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to index 2 (Reports Tab) in the NavHub or just show simple transition
                      Navigator.pushNamed(context, '/hub');
                    },
                    child: Text(
                      'View Board',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: VanguardTheme.primaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),

              // Feed list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.issues.take(2).length,
                itemBuilder: (context, index) {
                  final issue = state.issues[index];
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: VanguardTheme.slate.withOpacity(0.12),
                                borderRadius: VanguardTheme.borderSmall,
                              ),
                              child: Text(
                                issue.category.toUpperCase(),
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: VanguardTheme.slate,
                                ),
                              ),
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
                          child: Text(
                            issue.title,
                            style: GoogleFonts.sora(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: VanguardTheme.onSurface,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 4),
                        
                        Text(
                          issue.locationName,
                          style: GoogleFonts.inter(fontSize: 12, color: VanguardTheme.slate),
                        ),
                        
                        const SizedBox(height: 14),
                        Divider(color: Colors.white.withOpacity(0.06)),
                        const SizedBox(height: 8),

                        // Action Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              issue.timeAgo,
                              style: GoogleFonts.inter(fontSize: 12, color: VanguardTheme.slate),
                            ),
                            
                            // Escalation / Upvote Button
                            InkWell(
                              onTap: () {
                                state.toggleUpvoteIssue(issue.id);
                              },
                              borderRadius: VanguardTheme.borderSmall,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                                    const SizedBox(width: 4),
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
              
              const SizedBox(height: 40), // Spacer bottom FAB safearea
            ],
          ),
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
