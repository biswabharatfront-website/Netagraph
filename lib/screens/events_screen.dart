import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/vanguard_theme.dart';
import '../models/civic_models.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CivicState>(context);
    final selectedWard = state.selectedWard.isNotEmpty 
        ? state.selectedWard.split(" - ").last.replaceAll(" (Bengaluru)", "") 
        : "Varthur";

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
          'Civic Assemblies & Drives',
          style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.bold, color: VanguardTheme.onSurface),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CONSTITUENCY CALENDAR',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: VanguardTheme.primaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Upcoming in $selectedWard',
                    style: GoogleFonts.sora(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: VanguardTheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Open meetings with your MLA Rajesh Varma, Councillor, and volunteer preservation cleanup teams.',
                    style: GoogleFonts.inter(fontSize: 13, color: VanguardTheme.slate, height: 1.4),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 10),

            // Events List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: state.events.length,
                itemBuilder: (context, index) {
                  final ev = state.events[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
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
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: VanguardTheme.primaryContainer.withOpacity(0.12),
                                borderRadius: VanguardTheme.borderSmall,
                              ),
                              child: Text(
                                ev.dateText,
                                style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: VanguardTheme.primaryContainer),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: VanguardTheme.slate.withOpacity(0.12),
                                borderRadius: VanguardTheme.borderSmall,
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.people, size: 12, color: VanguardTheme.slate),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${ev.rsvpCount} RSVP',
                                    style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: VanguardTheme.slate),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        
                        const SizedBox(height: 14),
                        
                        Text(
                          ev.title,
                          style: GoogleFonts.sora(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: VanguardTheme.onSurface,
                          ),
                        ),
                        
                        const SizedBox(height: 6),
                        
                        Text(
                          ev.description,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            height: 1.4,
                            color: VanguardTheme.onSurface.withOpacity(0.85),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Venue details
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 14, color: VanguardTheme.slate),
                            const SizedBox(width: 6),
                            Text(
                              ev.timeText,
                              style: GoogleFonts.inter(fontSize: 12, color: VanguardTheme.slate),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.pin_drop_outlined, size: 14, color: VanguardTheme.slate),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                ev.locationText,
                                style: GoogleFonts.inter(fontSize: 12, color: VanguardTheme.slate),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        Divider(color: Colors.white.withOpacity(0.06)),
                        const SizedBox(height: 12),

                        // Action RSVP
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ev.isRSVPed ? 'You are scheduled to attend!' : 'Will you be attending?',
                              style: GoogleFonts.inter(
                                fontSize: 11, 
                                color: ev.isRSVPed ? VanguardTheme.success : VanguardTheme.slate,
                                fontWeight: ev.isRSVPed ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                state.toggleRSVP(ev.id);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                                      ev.isRSVPed ? 'GOING' : 'ATTEND',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
