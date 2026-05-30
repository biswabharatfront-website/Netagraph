import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../theme/vanguard_theme.dart';
import '../models/civic_models.dart';
import '../utils/map_styles.dart';

class WardSelectScreen extends StatefulWidget {
  const WardSelectScreen({super.key});

  @override
  State<WardSelectScreen> createState() => _WardSelectScreenState();
}

class _WardSelectScreenState extends State<WardSelectScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLocating = false;
  String _searchQuery = "";
  GoogleMapController? _mapController;

  // Ward data with approximate centre coordinates
  final List<Map<String, dynamic>> _wardsData = [
    {"name": "Ward 142 - Varthur (Bengaluru)", "lat": 12.9516, "lng": 77.7460},
    {"name": "Ward 143 - Bellandur (Bengaluru)", "lat": 12.9258, "lng": 77.6688},
    {"name": "Ward 149 - HSR Layout (Bengaluru)", "lat": 12.9116, "lng": 77.6389},
    {"name": "Ward 150 - Kadugodi (Bengaluru)", "lat": 12.9910, "lng": 77.7630},
    {"name": "Ward 84 - Indiranagar (Bengaluru)", "lat": 12.9784, "lng": 77.6408},
    {"name": "Ward 112 - Domlur (Bengaluru)", "lat": 12.9609, "lng": 77.6387},
    {"name": "Ward 54 - Malleshwaram (Bengaluru)", "lat": 13.0035, "lng": 77.5710},
  ];

  Set<Marker> _markers = {};

  List<String> get _wards => _wardsData.map((w) => w["name"] as String).toList();

  List<Map<String, dynamic>> get _filteredWards {
    if (_searchQuery.isEmpty) return _wardsData;
    return _wardsData
        .where((ward) => (ward["name"] as String).toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _animateToWard(double lat, double lng, String wardName) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 14.5),
      ),
    );
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected_ward'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: wardName),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        ),
      };
    });
  }

  void _detectLocation() {
    setState(() {
      _isLocating = true;
    });

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() {
        _isLocating = false;
      });
      // Pre-select Ward 142 - Varthur (matches Rajesh Varma)
      final state = Provider.of<CivicState>(context, listen: false);
      state.setWard("Ward 142 - Varthur (Bengaluru)");

      // Animate map to Varthur
      _animateToWard(12.9516, 77.7460, "Ward 142 - Varthur");
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'GPS lock successful! Detected: Ward 142 - Varthur',
            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: VanguardTheme.success,
        ),
      );
      
      Navigator.pushNamed(context, '/ward_boundary');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CivicState>(context);

    return Scaffold(
      backgroundColor: VanguardTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: VanguardTheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'YOUR CONSTITUENCY',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: VanguardTheme.primaryContainer,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Select Your Ward',
                style: GoogleFonts.sora(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: VanguardTheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Accountability is local. Pinpoint your municipal ward to connect with your specific Councillor, MLA, and community feed.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  height: 1.4,
                  color: VanguardTheme.slate,
                ),
              ),
              
              const SizedBox(height: 20),

              // Interactive Google Map
              ClipRRect(
                borderRadius: VanguardTheme.borderMedium,
                child: SizedBox(
                  height: 180,
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(12.9716, 77.5946), // Bengaluru centre
                      zoom: 11.0,
                    ),
                    markers: _markers,
                    onMapCreated: (controller) {
                      _mapController = controller;
                      controller.setMapStyle(MapStyles.darkStyle);
                    },
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    mapToolbarEnabled: false,
                    compassEnabled: false,
                    liteModeEnabled: false,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Location Auto-detector card
              InkWell(
                onTap: _isLocating ? null : _detectLocation,
                borderRadius: VanguardTheme.borderMedium,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: VanguardTheme.surfaceElevated,
                    borderRadius: VanguardTheme.borderMedium,
                    border: Border.all(
                      color: _isLocating 
                        ? VanguardTheme.primaryContainer 
                        : Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isLocating 
                            ? VanguardTheme.primaryContainer.withOpacity(0.15)
                            : VanguardTheme.primaryContainer.withOpacity(0.08),
                          borderRadius: VanguardTheme.borderDefault,
                        ),
                        child: _isLocating 
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: VanguardTheme.primaryContainer, strokeWidth: 2),
                            )
                          : const Icon(Icons.my_location, color: VanguardTheme.primaryContainer, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isLocating ? 'Pinpointing GPS Location...' : 'Detect My Ward Automatically',
                              style: GoogleFonts.sora(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: VanguardTheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isLocating ? 'Locking coordinates via satellite...' : 'Uses your phone\'s location service.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: VanguardTheme.slate,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: Divider(color: VanguardTheme.slate.withOpacity(0.2))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR SEARCH BY AREA', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: VanguardTheme.slate)),
                  ),
                  Expanded(child: Divider(color: VanguardTheme.slate.withOpacity(0.2))),
                ],
              ),
              
              const SizedBox(height: 16),

              // Search box
              TextField(
                controller: _searchController,
                style: GoogleFonts.inter(color: VanguardTheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Search by area name or pincode (e.g. Varthur)',
                  prefixIcon: const Icon(Icons.search, color: VanguardTheme.slate),
                  suffixIcon: _searchQuery.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.close, color: VanguardTheme.slate),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = "";
                          });
                        },
                      )
                    : null,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              
              const SizedBox(height: 12),

              // Listed Wards
              Expanded(
                child: _filteredWards.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_off_outlined, color: VanguardTheme.slate, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            'No Wards Found',
                            style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: VanguardTheme.onSurface),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try searching another key term like Bengaluru.',
                            style: GoogleFonts.inter(fontSize: 13, color: VanguardTheme.slate),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredWards.length,
                      itemBuilder: (context, index) {
                        final wardData = _filteredWards[index];
                        final wardName = wardData["name"] as String;
                        final isSelected = state.selectedWard == wardName;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: VanguardTheme.surfaceElevated,
                            borderRadius: VanguardTheme.borderMedium,
                            border: Border.all(
                              color: isSelected 
                                ? VanguardTheme.primaryContainer 
                                : Colors.white.withOpacity(0.04),
                            ),
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.map_outlined, 
                              color: isSelected ? VanguardTheme.primaryContainer : VanguardTheme.slate,
                            ),
                            title: Text(
                              wardName,
                              style: GoogleFonts.inter(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: VanguardTheme.onSurface,
                              ),
                            ),
                            trailing: isSelected 
                              ? const Icon(Icons.check_circle, color: VanguardTheme.primaryContainer)
                              : const Icon(Icons.chevron_right, color: VanguardTheme.slate),
                            onTap: () {
                              state.setWard(wardName);
                              _animateToWard(
                                wardData["lat"] as double,
                                wardData["lng"] as double,
                                wardName,
                              );
                              Navigator.pushNamed(context, '/ward_boundary');
                            },
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
}
