import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/vanguard_theme.dart';
import '../models/civic_models.dart';

class AddDiscussionScreen extends StatefulWidget {
  const AddDiscussionScreen({super.key});

  @override
  State<AddDiscussionScreen> createState() => _AddDiscussionScreenState();
}

class _AddDiscussionScreenState extends State<AddDiscussionScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _submitDiscussion() {
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
    state.addDiscussion(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Discussion thread created successfully!', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
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
          'Start Discussion',
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
                'COMMUNITY INITIATED TOPIC',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: VanguardTheme.primaryContainer,
                ),
              ),
              const SizedBox(height: 12),
              
              Text(
                'Raise a Topic',
                style: GoogleFonts.sora(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: VanguardTheme.onSurface,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Have a suggestion or constructive criticism regarding Ward 142? Put it up here to coordinate consensus actions.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: VanguardTheme.slate,
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 36),

              Text(
                'DISCUSSION TITLE',
                style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.bold, color: VanguardTheme.slate),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _titleController,
                style: GoogleFonts.inter(color: VanguardTheme.onSurface, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'e.g. Safety concerns regarding lake walkway lighting...',
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'TOPIC PARAGRAPHS',
                style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.bold, color: VanguardTheme.slate),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contentController,
                maxLines: 6,
                style: GoogleFonts.inter(color: VanguardTheme.onSurface, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Present facts, suggest alternatives, and ask community residents for support...',
                ),
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
                    onPressed: _submitDiscussion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: VanguardTheme.borderMedium,
                      ),
                    ),
                    child: Text(
                      'Launch Discussion',
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
