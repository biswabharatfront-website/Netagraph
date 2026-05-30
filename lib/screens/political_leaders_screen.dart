import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/vanguard_theme.dart';

class PoliticalLeadersScreen extends StatefulWidget {
  const PoliticalLeadersScreen({super.key});

  @override
  State<PoliticalLeadersScreen> createState() => _PoliticalLeadersScreenState();
}

class _PoliticalLeadersScreenState extends State<PoliticalLeadersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final List<LeaderData> _allLeaders = [
    LeaderData(
      id: "leader_02",
      title: "Ward Councillor",
      name: "Mrs. Manjula Devi",
      ward: "Ward 142 - Varthur",
      party: "Independent Action Alliance",
      avatar: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=400",
      score: "78%",
      status: "Active",
      pinCode: "560087",
    ),
    LeaderData(
      id: "leader_01",
      title: "MLA (Legislative Assembly)",
      name: "Mr. Rajesh Varma",
      ward: "Varthur Constituency (Ward 142)",
      party: "Citizen Action Alliance (CAA)",
      avatar: "https://lh3.googleusercontent.com/aida-public/AB6AXuDRgINOzxmNicE51SkDFSF3iuAT_BqiYtKiYqHs3H85DaMVDpwoQ9MJJzx4EdWHcdtu7mjKJh04E813Txh_X1q4N-v3ZGw1fREqsvk0ByHBmYVGiPVsk7isXSx6-NweniyGP9crNqFWFCLIpMoVZ4MJeM3-3uSGeBfuV0S71DkV7d9f7rPjUvxDjMdtha6stNfhlfxhRciVkifR95S5VPJLPLvd-pZ-Wxf5CSmy27322oeaGb_LM7mghIC5yra1SvjzhtjkMKo-Gt7w",
      score: "68%",
      status: "Active",
      pinCode: "560087",
    ),
    LeaderData(
      id: "leader_03",
      title: "Member of Parliament (MP)",
      name: "Dr. Arvind Swamy",
      ward: "Bengaluru Central Lok Sabha",
      party: "Progressive Civic Coalition",
      avatar: "https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&q=80&w=400",
      score: "55%",
      status: "In Session",
      pinCode: "560001",
    ),
    LeaderData(
      id: "leader_04",
      title: "Chief Minister (CM)",
      name: "Mr. Siddaramaiah (Mock CM)",
      ward: "State of Karnataka",
      party: "National Democratic Union",
      avatar: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&q=80&w=400",
      score: "61%",
      status: "Assembly",
      pinCode: "560001",
    ),
    LeaderData(
      id: "leader_05",
      title: "Prime Minister (PM)",
      name: "Mr. Narendra Modi (Mock PM)",
      ward: "Republic of India",
      party: "People's Democratic Front",
      avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=400",
      score: "72%",
      status: "In Cabinet",
      pinCode: "110001",
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter leaders based on search input (name, party, constituency, or pincode)
    final filteredLeaders = _allLeaders.where((leader) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      return leader.pinCode.contains(query) ||
             leader.name.toLowerCase().contains(query) ||
             leader.ward.toLowerCase().contains(query) ||
             leader.party.toLowerCase().contains(query) ||
             leader.title.toLowerCase().contains(query);
    }).toList();

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
          'Constituency Directory',
          style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: VanguardTheme.onSurface),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Constituency Search Input (name, party, constituency, pincode)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: VanguardTheme.surfaceElevated,
                  borderRadius: VanguardTheme.borderMedium,
                  border: Border.all(color: VanguardTheme.primaryContainer.withOpacity(0.35)),
                  boxShadow: [
                    BoxShadow(
                      color: VanguardTheme.primaryContainer.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search by Name, Party, Area or Pincode...",
                    hintStyle: GoogleFonts.inter(color: VanguardTheme.slate, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: VanguardTheme.primaryContainer, size: 20),
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    suffixIcon: _searchQuery.isNotEmpty 
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: VanguardTheme.slate, size: 16),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = "";
                              });
                            },
                          )
                        : null,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // List View
            Expanded(
              child: filteredLeaders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_search, size: 48, color: VanguardTheme.slate.withOpacity(0.5)),
                          const SizedBox(height: 12),
                          Text(
                            'No politicians found matching query',
                            style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Try entering "Rajesh", "CAA", "Varthur" or "560087"',
                            style: GoogleFonts.inter(fontSize: 11, color: VanguardTheme.slate),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      itemCount: filteredLeaders.length + 1,
                      itemBuilder: (context, index) {
                        if (index == filteredLeaders.length) {
                          // Standard Attributions & Disclaimer Card
                          return Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
                            child: Container(
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
                          );
                        }

                        final leader = filteredLeaders[index];
                        final isLast = index == filteredLeaders.length - 1;
                        
                        return IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Timeline connector visual
                              Column(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: VanguardTheme.background,
                                      border: Border.all(color: VanguardTheme.primaryContainer, width: 3),
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: VanguardTheme.primaryContainer,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (!isLast)
                                    Expanded(
                                      child: Container(
                                        width: 2,
                                        color: VanguardTheme.slate.withOpacity(0.3),
                                      ),
                                    ),
                                ],
                              ),
                              
                              const SizedBox(width: 16),
                              
                              // Leader detailed box
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: VanguardTheme.surfaceElevated,
                                    borderRadius: VanguardTheme.borderMedium,
                                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: VanguardTheme.borderMedium,
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/politician_profile',
                                          arguments: leader.id,
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 22,
                                                  backgroundImage: NetworkImage(leader.avatar),
                                                ),
                                                const SizedBox(width: 14),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              leader.name,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: GoogleFonts.sora(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.bold,
                                                                color: VanguardTheme.onSurface,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: const EdgeInsets.only(left: 6),
                                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                            decoration: BoxDecoration(
                                                              color: VanguardTheme.primaryContainer.withOpacity(0.12),
                                                              borderRadius: BorderRadius.circular(4),
                                                            ),
                                                            child: Text(
                                                              leader.pinCode,
                                                              style: GoogleFonts.inter(fontSize: 8.5, fontWeight: FontWeight.bold, color: VanguardTheme.primaryContainer),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        leader.title,
                                                        style: GoogleFonts.inter(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold,
                                                          color: VanguardTheme.primaryContainer,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: VanguardTheme.success.withOpacity(0.12),
                                                    borderRadius: VanguardTheme.borderSmall,
                                                  ),
                                                  child: Text(
                                                    leader.score,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      color: VanguardTheme.success,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            
                                            const SizedBox(height: 12),
                                            
                                            // Metadata details
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    leader.ward,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.inter(fontSize: 11, color: VanguardTheme.slate),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  leader.party,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.inter(fontSize: 11, color: VanguardTheme.slate),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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

class LeaderData {
  final String id;
  final String title;
  final String name;
  final String ward;
  final String party;
  final String avatar;
  final String score;
  final String status;
  final String pinCode;

  LeaderData({
    required this.id,
    required this.title,
    required this.name,
    required this.ward,
    required this.party,
    required this.avatar,
    required this.score,
    required this.status,
    required this.pinCode,
  });
}
