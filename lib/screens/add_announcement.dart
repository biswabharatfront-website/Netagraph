import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/vanguard_theme.dart';
import '../models/civic_models.dart';

class AddAnnouncementScreen extends StatefulWidget {
  const AddAnnouncementScreen({super.key});

  @override
  State<AddAnnouncementScreen> createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isUrgent = false;

  void _submitAnnouncement() {
    if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please complete both fields.', style: GoogleFonts.inter(color: Colors.white)),
          backgroundColor: VanguardTheme.actionGradientStart,
        ),
      );
      return;
    }

    final state = Provider.of<CivicState>(context, listen: false);
    state.addAnnouncement(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      isUrgent: _isUrgent,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Announcement published to Ward Bulletin.', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: VanguardTheme.success,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'Post Official Bulletin',
          style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: VanguardTheme.onSurface),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WARD CITIZEN ANNOUNCEMENT',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: VanguardTheme.primaryContainer,
                ),
              ),
              const SizedBox(height: 12),
              
              Text(
                'Publish an Update',
                style: GoogleFonts.sora(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: VanguardTheme.onSurface,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Only verified civic volunteers and ward officers can post notices to minimize noise. Keep notifications factual.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: VanguardTheme.slate,
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 36),

              Text(
                'ANNOUNCEMENT HEADING',
                style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.bold, color: VanguardTheme.slate),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _titleController,
                style: GoogleFonts.inter(color: VanguardTheme.onSurface, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'e.g. Ward Open Grievance Session timings updated...',
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'DETAILED METADATA CONTENT',
                style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.bold, color: VanguardTheme.slate),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contentController,
                maxLines: 5,
                style: GoogleFonts.inter(color: VanguardTheme.onSurface, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'List dates, timing grids, locations, contact references...',
                ),
              ),

              const SizedBox(height: 20),

              // Urgent checkbox
              CheckboxListTile(
                value: _isUrgent,
                onChanged: (val) {
                  setState(() {
                    _isUrgent = val ?? false;
                  });
                },
                title: Text(
                  'Mark Announcement as URGENT',
                  style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.bold, color: VanguardTheme.onSurface),
                ),
                subtitle: Text(
                  'Pins this card to the top with a vibrant orange notification overlay.',
                  style: GoogleFonts.inter(fontSize: 11, color: VanguardTheme.slate),
                ),
                activeColor: VanguardTheme.actionGradientStart,
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: 40),

              // Action button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: VanguardTheme.actionGradient,
                    borderRadius: VanguardTheme.borderMedium,
                    boxShadow: VanguardTheme.buttonGlow,
                  ),
                  child: ElevatedButton(
                    onPressed: _submitAnnouncement,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: VanguardTheme.borderMedium,
                      ),
                    ),
                    child: Text(
                      'Publish Ward Announcement',
                      style: GoogleFonts.sora(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
