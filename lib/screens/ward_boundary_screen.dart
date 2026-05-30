import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../theme/vanguard_theme.dart';
import '../models/civic_models.dart';
import '../utils/map_styles.dart';

class WardBoundaryScreen extends StatefulWidget {
  const WardBoundaryScreen({super.key});

  @override
  State<WardBoundaryScreen> createState() => _WardBoundaryScreenState();
}

class _WardBoundaryScreenState extends State<WardBoundaryScreen> {
  GoogleMapController? _mapController;

  // Approximate Varthur ward boundary polygon (real coordinates)
  static const List<LatLng> _varthurBoundary = [
    LatLng(12.9580, 77.7350),
    LatLng(12.9610, 77.7420),
    LatLng(12.9590, 77.7530),
    LatLng(12.9550, 77.7570),
    LatLng(12.9480, 77.7560),
    LatLng(12.9420, 77.7520),
    LatLng(12.9400, 77.7450),
    LatLng(12.9410, 77.7380),
    LatLng(12.9450, 77.7340),
    LatLng(12.9520, 77.7320),
  ];

  static const LatLng _wardCenter = LatLng(12.9500, 77.7440);
  static const LatLng _userLocation = LatLng(12.9485, 77.7455);

  Set<Polygon> get _polygons => {
    Polygon(
      polygonId: const PolygonId('varthur_boundary'),
      points: _varthurBoundary,
      fillColor: VanguardTheme.primaryContainer.withOpacity(0.15),
      strokeColor: VanguardTheme.primaryContainer,
      strokeWidth: 3,
    ),
  };

  Set<Marker> get _markers => {
    Marker(
      markerId: const MarkerId('user_location'),
      position: _userLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: const InfoWindow(title: 'Your Location', snippet: 'Varthur, Bengaluru'),
    ),
  };

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CivicState>(context);
    final selectedWardName = state.selectedWard.isNotEmpty 
        ? state.selectedWard 
        : "Ward 142 - Varthur (Bengaluru)";

    // Seeding mock politician info
    final mla = state.politicians[0];

    return Scaffold(
      backgroundColor: VanguardTheme.background,
      body: Stack(
        children: [
          // Real Google Map with ward boundary polygon
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: _wardCenter,
                zoom: 14.5,
              ),
              polygons: _polygons,
              markers: _markers,
              onMapCreated: (controller) {
                _mapController = controller;
                controller.setMapStyle(MapStyles.darkStyle);
              },
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
            ),
          ),
          
          // Back button and header
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircleAvatar(
                  backgroundColor: VanguardTheme.surfaceElevated.withOpacity(0.9),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: VanguardTheme.onSurface),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
          ),

          // Sliding Bottom Information Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: VanguardTheme.surfaceElevated,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pull pill
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: VanguardTheme.slate.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  
                  // Ward name badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: VanguardTheme.primaryContainer.withOpacity(0.15),
                      borderRadius: VanguardTheme.borderSmall,
                    ),
                    child: Text(
                      selectedWardName.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: VanguardTheme.primaryContainer,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Text(
                    'Ward Boundary Locked',
                    style: GoogleFonts.sora(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: VanguardTheme.onSurface,
                    ),
                  ),
                  
                  const SizedBox(height: 6),
                  
                  Text(
                    'Verification coordinates registered. Your account is authorized to report issues directly within this boundary.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: VanguardTheme.slate,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Stats Grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem('72.4K', 'Electors'),
                      _buildStatItem('14.8 km²', 'Area Scale'),
                      _buildStatItem('42 Active', 'Civic Cases'),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Politician Quick Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: VanguardTheme.background,
                      borderRadius: VanguardTheme.borderMedium,
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(mla.photoUrl),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mla.name,
                                style: GoogleFonts.sora(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: VanguardTheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Local Representative (MLA)',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: VanguardTheme.slate,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: VanguardTheme.surfaceElevated,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.contact_mail_outlined,
                            color: VanguardTheme.primaryContainer,
                            size: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Primary Action Button
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
                        onPressed: () {
                          Navigator.pushNamed(context, '/loading');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: VanguardTheme.borderMedium,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Enter Ward Hub',
                              style: GoogleFonts.sora(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.login, color: Colors.white, size: 20),
                          ],
                        ),
                      ),
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

  Widget _buildStatItem(String val, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          val,
          style: GoogleFonts.sora(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: VanguardTheme.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: VanguardTheme.slate,
          ),
        ),
      ],
    );
  }
}
