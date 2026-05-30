import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../theme/vanguard_theme.dart';
import '../models/civic_models.dart';
import '../utils/map_styles.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  
  String _selectedCategory = "Roads";
  String _selectedSubCategory = "Potholes";
  String _mockImagePath = "";
  bool _isUploading = false;
  bool _locationLocked = true;

  final Map<String, List<String>> _subCategories = {
    "Roads": ["Potholes", "Broken Sidewalk", "Open Manhole", "Water Logging", "Missing Signage"],
    "Water": ["Pipe Leakage", "Contaminated Supply", "Low Pressure", "No Supply", "Water Stagnation"],
    "Waste Management": ["Overflowing Dustbin", "Illegal Dumping", "Dead Animal Removal", "No Door Collection"],
    "Electricity": ["Broken Streetlight", "Fallen Cables", "Power Fluctuations", "Transformers Sparking"],
    "Security": ["Dark Alleyway", "Suspicious Loitering", "Vandalism", "Stray Animal Menace"],
    "Other": ["Public Property Encroachment", "Illegal Banners", "Noise Disturbance", "Miscellaneous"]
  };

  final List<Map<String, dynamic>> _categories = [
    {"name": "Roads", "icon": Icons.add_road},
    {"name": "Water", "icon": Icons.water_drop},
    {"name": "Waste Management", "icon": Icons.delete_outline},
    {"name": "Electricity", "icon": Icons.lightbulb_outline},
    {"name": "Security", "icon": Icons.security},
    {"name": "Other", "icon": Icons.more_horiz},
  ];

  void _pickMockImage() {
    setState(() {
      _isUploading = true;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        _isUploading = false;
        // Mock a captured image from Varthur road
        _mockImagePath = "https://images.unsplash.com/photo-1515162305285-0293e4767cc2?auto=format&fit=crop&q=80&w=600";
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Geo-stamp locked! Latitude: 12.942, Longitude: 77.744.',
            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: VanguardTheme.success,
        ),
      );
    });
  }

  void _submitIssue() {
    if (_titleController.text.trim().isEmpty || _descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in the title and description fields.',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: VanguardTheme.actionGradientStart,
        ),
      );
      return;
    }

    final state = Provider.of<CivicState>(context, listen: false);
    
    // Add to state
    state.addIssue(
      title: _titleController.text,
      description: _descController.text,
      category: _selectedCategory,
      locationName: "Varthur Main Road, Bengaluru 560087",
      imageFilePath: _mockImagePath,
    );

    // Show beautiful success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: VanguardTheme.borderMedium),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: VanguardTheme.success.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified,
                    color: VanguardTheme.success,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Grievance Filed!',
                  style: GoogleFonts.sora(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: VanguardTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your issue has been logged, geo-stamped, and signed with your OTP certificate. It is now live in the constituency feed.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: VanguardTheme.slate,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Return home button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: VanguardTheme.actionGradient,
                      borderRadius: VanguardTheme.borderMedium,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Pop dialog
                        Navigator.pop(context); // Return to NavHub Tab list
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Text(
                        'View Timeline Board',
                        style: GoogleFonts.sora(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
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
          'Report Civic Issue',
          style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: VanguardTheme.onSurface),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo capture block
              Text(
                'VERIFIABLE IMAGE EVIDENCE',
                style: GoogleFonts.sora(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: VanguardTheme.slate,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickMockImage,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: VanguardTheme.surfaceElevated,
                    borderRadius: VanguardTheme.borderMedium,
                    border: Border.all(
                      color: _mockImagePath.isNotEmpty 
                        ? VanguardTheme.success.withOpacity(0.5) 
                        : Colors.white.withOpacity(0.06),
                      width: 1.5,
                    ),
                  ),
                  child: _isUploading
                    ? const Center(child: CircularProgressIndicator(color: VanguardTheme.primaryContainer))
                    : (_mockImagePath.isNotEmpty
                        ? ClipRRect(
                            borderRadius: VanguardTheme.borderMedium,
                            child: Image.network(_mockImagePath, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_enhance, color: VanguardTheme.slate, size: 36),
                              const SizedBox(height: 10),
                              Text(
                                'Capture PWD failure (Camera)',
                                style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.bold, color: VanguardTheme.onSurface),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Adds permanent UTC timestamp & GPS metadata.',
                                style: GoogleFonts.inter(fontSize: 11, color: VanguardTheme.slate),
                              ),
                            ],
                          )),
                ),
              ),

              const SizedBox(height: 24),

              // Category Selector
              Text(
                'SELECT REPORT CATEGORY',
                style: GoogleFonts.sora(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: VanguardTheme.slate,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSel = _selectedCategory == cat["name"];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat["name"];
                          _selectedSubCategory = _subCategories[cat["name"]]![0];
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: isSel ? VanguardTheme.primaryContainer : VanguardTheme.surfaceElevated,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isSel ? VanguardTheme.primaryContainer : Colors.white.withOpacity(0.06),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              cat["icon"],
                              color: isSel ? Colors.white : VanguardTheme.slate,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              cat["name"],
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                                color: isSel ? Colors.white : VanguardTheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Sub-Category Selector
              Text(
                'SELECT SUB-CATEGORY',
                style: GoogleFonts.sora(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: VanguardTheme.slate,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _subCategories[_selectedCategory]?.length ?? 0,
                  itemBuilder: (context, index) {
                    final sub = _subCategories[_selectedCategory]![index];
                    final isSel = _selectedSubCategory == sub;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSubCategory = sub;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        decoration: BoxDecoration(
                          color: isSel 
                              ? VanguardTheme.primaryContainer.withOpacity(0.15) 
                              : VanguardTheme.surfaceElevated,
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(
                            color: isSel 
                                ? VanguardTheme.primaryContainer 
                                : Colors.white.withOpacity(0.04),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            sub,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                              color: isSel ? VanguardTheme.primaryContainer : VanguardTheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Title Input
              Text(
                'GRIEVANCE HEADING',
                style: GoogleFonts.sora(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: VanguardTheme.slate,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _titleController,
                style: GoogleFonts.inter(color: VanguardTheme.onSurface, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'e.g. Deep waterlogging near lake bridge entrance...',
                ),
              ),

              const SizedBox(height: 24),

              // Description and Voice input
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'DETAILED COMPLAINT TIMELINE',
                    style: GoogleFonts.sora(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: VanguardTheme.slate,
                    ),
                  ),
                  // Mock Voice input trigger
                  GestureDetector(
                    onTap: () {
                      _descController.text = "Water clogging on 4th cross near public high school. Piles of plastic are blocking the drainage valve causing overflow onto roads.";
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Vocal translation complete!', style: GoogleFonts.inter(color: Colors.white)),
                          backgroundColor: VanguardTheme.success,
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.mic, color: VanguardTheme.primaryContainer, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Talk to Fill',
                          style: GoogleFonts.inter(fontSize: 11, color: VanguardTheme.primaryContainer, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descController,
                maxLines: 4,
                style: GoogleFonts.inter(color: VanguardTheme.onSurface, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'State dates, impact on traffic, safety issues, and previous official responses...',
                ),
              ),

              const SizedBox(height: 24),

              // Location confirmation map
              ClipRRect(
                borderRadius: VanguardTheme.borderMedium,
                child: SizedBox(
                  height: 120,
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(12.9420, 77.7440),
                      zoom: 15.5,
                    ),
                    markers: {
                      const Marker(
                        markerId: MarkerId('report_location'),
                        position: LatLng(12.9420, 77.7440),
                        infoWindow: InfoWindow(title: 'Report Location', snippet: 'Varthur, Bengaluru 560087'),
                      ),
                    },
                    onMapCreated: (controller) {
                      controller.setMapStyle(MapStyles.darkStyle);
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
                ),
              ),

              const SizedBox(height: 12),

              // Location status
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: VanguardTheme.surfaceElevated,
                  borderRadius: VanguardTheme.borderMedium,
                  border: Border.all(color: Colors.white.withOpacity(0.04)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: VanguardTheme.success, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GPS Location Bound',
                            style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.bold, color: VanguardTheme.onSurface),
                          ),
                          Text(
                            'Locked to Varthur, Bengaluru 560087',
                            style: GoogleFonts.inter(fontSize: 11, color: VanguardTheme.slate),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.lock, color: VanguardTheme.slate, size: 16),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Submission Button
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
                    onPressed: _submitIssue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: VanguardTheme.borderMedium,
                      ),
                    ),
                    child: Text(
                      'Submit Grievance with Sign-off',
                      style: GoogleFonts.sora(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
