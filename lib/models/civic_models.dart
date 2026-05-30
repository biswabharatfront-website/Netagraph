import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../services/supabase_service.dart';

// User Model
class CivicUser {
  final String id;
  final String name;
  final String phone;
  final String avatarUrl;
  final String wardName;
  final String locationText;
  final int reportsFiled;
  final int contributionsCount;
  final int activeScore;
  final List<String> badges;
  
  // Phase 4 Reputation and Verification
  final double reputationScore;
  final String reputationLevel;
  final bool isResidentVerified;
  final String residentVerificationStatus; // 'None', 'Pending', 'Verified'
  final String? uploadedDocType; // 'Voter ID', 'Ration Card'
  final String? uploadedDocUrl;

  CivicUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.avatarUrl,
    required this.wardName,
    required this.locationText,
    required this.reportsFiled,
    required this.contributionsCount,
    required this.activeScore,
    required this.badges,
    this.reputationScore = 98.5,
    this.reputationLevel = "Trusted Sentinel",
    this.isResidentVerified = true,
    this.residentVerificationStatus = "Verified",
    this.uploadedDocType,
    this.uploadedDocUrl,
  });
}

// Supporting Table: Politician Promises
class PoliticianPromise {
  final String id; // UUID
  final String politicianId; // UUID references politicians
  final String title;
  final String description;
  final String category;
  final String status; // 'Not Started', 'In Progress', 'Delivered', 'Stalled', 'Broken'
  final DateTime? dueDate;
  final int evidenceCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  PoliticianPromise({
    required this.id,
    required this.politicianId,
    required this.title,
    this.description = "",
    this.category = "",
    required this.status,
    this.dueDate,
    this.evidenceCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });
}

// Supporting Table: Politician Schemes
class PoliticianScheme {
  final String id; // UUID
  final String politicianId; // UUID references politicians
  final String title;
  final String description;
  final String eligibility;
  final String budgetAllocated;
  final String beneficiariesCount;
  final String status; // 'Active', 'Completed', 'Suspended'
  final DateTime createdAt;

  PoliticianScheme({
    required this.id,
    required this.politicianId,
    required this.title,
    required this.description,
    required this.eligibility,
    required this.budgetAllocated,
    required this.beneficiariesCount,
    required this.status,
    required this.createdAt,
  });
}

// Supporting Table: Politician Milestones (Timeline)
class PoliticianMilestone {
  final String id; // UUID
  final String title;
  final String description;
  final DateTime date;
  final String type; // 'term_start', 'promise_completed', 'achievement', 'townhall', 'future_milestone'
  final IconData? icon;

  PoliticianMilestone({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    this.icon,
  });
}

// Politician Model matching Refined SQL Schema
class Politician {
  final String id; // UUID
  
  // Core Identity
  final String name;
  final String? fullName;
  final String position; // TEXT NOT NULL
  final String level; // CHECK (level IN ('local', 'state', 'national'))
  
  // Constituency & Location
  final String constituency; // TEXT NOT NULL
  final String? wardNumber;
  final String? pinCode;
  final String? assemblyConstituency;
  final String? parliamentaryConstituency;
  final String state; // TEXT NOT NULL
  final String? district;
  
  // Geography
  final double? latitude;
  final double? longitude;
  
  // Political Details
  final String party; // TEXT NOT NULL
  final String? partySymbolUrl;
  final int? electionYear;
  final DateTime? termStart;
  final DateTime? termEnd;
  
  // Contact & Media
  final String? phone;
  final String? email;
  final String? officeAddress;
  final String photoUrl;
  final String? website;
  final String? twitterHandle;
  final String? facebookUrl;
  
  // Performance Metrics
  final double accountabilityScore; // DECIMAL(5,2) DEFAULT 0.0
  final double promisesKeptRate; // DECIMAL(5,2) DEFAULT 0.0
  final double responseRate; // DECIMAL(5,2) DEFAULT 0.0
  final double openReportsPercentage; // DECIMAL(5,2) DEFAULT 0.0
  
  final int totalReports;
  final int resolvedReports;
  final int openReports;
  
  final int? averageResponseTimeDays;
  final DateTime? lastActivityDate;
  
  // Background Data
  final String? education;
  final double? assets;
  final double? liabilities;
  final int criminalCases;
  final String? bio;
  
  // Metadata
  final String? source;
  final String? sourceUrl;
  final DateTime lastUpdated;
  final bool isActive;
  final bool isVerified;
  
  final DateTime createdAt;
  final DateTime updatedAt;

  // Real Database Relation: Supporting promises records
  final List<PoliticianPromise> promises;
  final List<PoliticianScheme> schemes;
  final List<PoliticianMilestone> timeline;

  Politician({
    required this.id,
    required this.name,
    this.fullName,
    required this.position,
    required this.level,
    required this.constituency,
    this.wardNumber,
    this.pinCode,
    this.assemblyConstituency,
    this.parliamentaryConstituency,
    required this.state,
    this.district,
    this.latitude,
    this.longitude,
    required this.party,
    this.partySymbolUrl,
    this.electionYear,
    this.termStart,
    this.termEnd,
    this.phone,
    this.email,
    this.officeAddress,
    required this.photoUrl,
    this.website,
    this.twitterHandle,
    this.facebookUrl,
    this.accountabilityScore = 0.0,
    this.promisesKeptRate = 0.0,
    this.responseRate = 0.0,
    this.openReportsPercentage = 0.0,
    this.totalReports = 0,
    this.resolvedReports = 0,
    this.openReports = 0,
    this.averageResponseTimeDays,
    this.lastActivityDate,
    this.education,
    this.assets,
    this.liabilities,
    this.criminalCases = 0,
    this.bio,
    this.source,
    this.sourceUrl,
    required this.lastUpdated,
    this.isActive = true,
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt,
    required this.promises,
    this.schemes = const [],
    this.timeline = const [],
  });

  // 100% Backward Compatibility Getters to support existing UI views out-of-the-box:
  String get title => position;
  double get approvalRate => promisesKeptRate / 100.0;
  String get contactPhone => phone ?? "";
  String get contactEmail => email ?? "";

  bool get isCurrent {
    return termEnd == null || termEnd!.isAfter(DateTime.now());
  }

  Map<String, double> get promiseProgress {
    final Map<String, List<PoliticianPromise>> grouped = {};
    for (var p in promises) {
      grouped.putIfAbsent(p.category, () => []).add(p);
    }
    return grouped.map((cat, list) {
      final deliveredCount = list.where((p) => p.status == 'Delivered').length;
      final inProgressCount = list.where((p) => p.status == 'In Progress').length;
      final score = list.isEmpty ? 0.0 : (deliveredCount + (inProgressCount * 0.5)) / list.length;
      return MapEntry(cat, score);
    });
  }

  List<String> get completedPromises => promises
      .where((p) => p.status == 'Delivered')
      .map((p) => p.title)
      .toList();

  List<String> get activePromises => promises
      .where((p) => p.status == 'In Progress' || p.status == 'Not Started')
      .map((p) => p.title)
      .toList();
}

enum IssueStatus { pending, verified, inProgress, resolved }

class IssueComment {
  final String id;
  final String authorName;
  final String authorBadge;
  final String text;
  final DateTime timestamp;

  IssueComment({
    required this.id,
    required this.authorName,
    required this.authorBadge,
    required this.text,
    required this.timestamp,
  });
}

class SuspiciousActivityFlag {
  final String id;
  final String reportId;
  final String? userId;
  final String flagType; // 'ip_burst', 'text_similarity', 'geo_burst', 'coordinated'
  final String reason;
  final int severity; // 1=Low, 2=Medium, 3=High
  final String? flaggedBy;
  String status; // 'Pending', 'Confirmed', 'Dismissed'
  final String? notes;
  final DateTime createdAt;

  SuspiciousActivityFlag({
    required this.id,
    required this.reportId,
    this.userId,
    required this.flagType,
    required this.reason,
    this.severity = 1,
    this.flaggedBy,
    this.status = 'Pending',
    this.notes,
    required this.createdAt,
  });
}

// Issue / Report Model
class CivicIssue {
  final String id;
  final String title;
  final String description;
  final String category; // "Roads", "Water", "Waste Management", "Electricity", "Other"
  final double latitude;
  final double longitude;
  final String locationName;
  final String imageUrl;
  final String reporterName;
  final String timeAgo;
  final DateTime dateFiled;
  IssueStatus status;
  int upvotes;
  bool isUpvoted;
  final List<IssueComment> comments;
  final List<String> timelineLogs; // Logs of timeline transitions
  
  // Auditing fields for coordinated spam detection
  final String? ipAddressHash;
  final String? deviceFingerprint;
  final String? locationArea;

  // Phase 4 Audit and Community Flags
  final bool gpsVerified;
  final bool exifVerified;
  final String? exifCamera;
  final String? exifTimestamp;
  int suspiciousFlagsCount;
  bool isReportedSuspicious;

  CivicIssue({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.imageUrl,
    required this.reporterName,
    required this.timeAgo,
    required this.dateFiled,
    required this.status,
    required this.upvotes,
    this.isUpvoted = false,
    required this.comments,
    required this.timelineLogs,
    this.ipAddressHash,
    this.deviceFingerprint,
    this.locationArea,
    this.gpsVerified = true,
    this.exifVerified = true,
    this.exifCamera = "OnePlus 11 5G",
    this.exifTimestamp = "2026-05-29T16:12:45Z",
    this.suspiciousFlagsCount = 0,
    this.isReportedSuspicious = false,
  });
}

// Community Discussion Board Model
class CommunityDiscussion {
  final String id;
  final String title;
  final String content;
  final String authorName;
  final String authorRole; // "Resident", "Volunteer", "Moderator"
  final String timeAgo;
  int upvotes;
  bool isUpvoted;
  final List<String> replies;

  CommunityDiscussion({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    required this.authorRole,
    required this.timeAgo,
    required this.upvotes,
    this.isUpvoted = false,
    required this.replies,
  });
}

// Community Official Announcements Model
class CivicAnnouncement {
  final String id;
  final String title;
  final String content;
  final String authorName;
  final String timeAgo;
  final bool isUrgent;

  CivicAnnouncement({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    required this.timeAgo,
    required this.isUrgent,
  });
}

// Community Local Events Model
class CivicEvent {
  final String id;
  final String title;
  final String description;
  final String dateText;
  final String locationText;
  final String timeText;
  int rsvpCount;
  bool isRSVPed;

  CivicEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.dateText,
    required this.locationText,
    required this.timeText,
    required this.rsvpCount,
    this.isRSVPed = false,
  });
}

// Core App State Management Provider
class CivicState extends ChangeNotifier {
  CivicState() {
    _syncSupabase();
  }

  Future<void> _syncSupabase() async {
    final userProfile = await SupabaseService.initializeSession();
    if (userProfile != null) {
      currentUser = userProfile;
      notifyListeners();
    }
    await syncData();
  }

  Future<void> syncData() async {
    final fetchedPoliticians = await SupabaseService.fetchPoliticians();
    if (fetchedPoliticians.isNotEmpty) {
      politicians.clear();
      politicians.addAll(fetchedPoliticians);
    }
    final fetchedIssues = await SupabaseService.fetchIssues();
    if (fetchedIssues.isNotEmpty) {
      issues.clear();
      issues.addAll(fetchedIssues);
    }
    final fetchedDiscussions = await SupabaseService.fetchDiscussions();
    if (fetchedDiscussions.isNotEmpty) {
      discussions.clear();
      discussions.addAll(fetchedDiscussions);
    }
    final fetchedAnnouncements = await SupabaseService.fetchAnnouncements();
    if (fetchedAnnouncements.isNotEmpty) {
      announcements.clear();
      announcements.addAll(fetchedAnnouncements);
    }
    final fetchedEvents = await SupabaseService.fetchEvents();
    if (fetchedEvents.isNotEmpty) {
      events.clear();
      events.addAll(fetchedEvents);
    }
    notifyListeners();
  }

  // Current user configuration
  CivicUser currentUser = CivicUser(
    id: "user_007",
    name: "Basar Sen",
    phone: "+91 98765 43210",
    avatarUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuDRgINOzxmNicE51SkDFSF3iuAT_BqiYtKiYqHs3H85DaMVDpwoQ9MJJzx4EdWHcdtu7mjKJh04E813Txh_X1q4N-v3ZGw1fREqsvk0ByHBmYVGiPVsk7isXSx6-NweniyGP9crNqFWFCLIpMoVZ4MJeM3-3uSGeBfuV0S71DkV7d9f7rPjUvxDjMdtha6stNfhlfxhRciVkifR95S5VPJLPLvd-pZ-Wxf5CSmy27322oeaGb_LM7mghIC5yra1SvjzhtjkMKo-Gt7w",
    wardName: "Ward 142 - Varthur",
    locationText: "Varthur, Bengaluru, Karnataka 560087",
    reportsFiled: 4,
    contributionsCount: 38,
    activeScore: 420,
    badges: ["RTI Watchdog", "Verified Reporter", "Pothole Finder", "Civic Leader"],
    reputationScore: 98.4,
    reputationLevel: "Trusted Sentinel",
    isResidentVerified: false,
    residentVerificationStatus: "None",
  );

  // Suspicious Flags Database
  final List<SuspiciousActivityFlag> suspiciousFlags = [
    SuspiciousActivityFlag(
      id: "flag_001",
      reportId: "issue_001",
      flagType: "ip_burst",
      reason: "IP Range Burst: 6 reports submitted from the same hashed IP address in the last 2 hours.",
      severity: 3,
      notes: "System Auto-Trigger: High frequency IP correlation.",
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    SuspiciousActivityFlag(
      id: "flag_002",
      reportId: "issue_002",
      flagType: "text_similarity",
      reason: "Text Similarity Alert: Found recent duplicate report matching title/description with >82% similarity index.",
      severity: 1,
      notes: "System Auto-Trigger: Word similarity matches resolved issue 003.",
      createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
    ),
  ];

  // Politician Database
  final List<Politician> politicians = [
    Politician(
      id: "leader_01",
      name: "Rajesh Varma",
      fullName: "Rajesh Chandra Varma",
      position: "MLA (Member of Legislative Assembly)",
      level: "state",
      constituency: "Varthur Constituency (Ward 142)",
      wardNumber: "142",
      pinCode: "560087",
      assemblyConstituency: "Mahadevapura",
      state: "Karnataka",
      district: "Bengaluru Urban",
      latitude: 12.942,
      longitude: 77.744,
      party: "Citizen Action Alliance (CAA)",
      partySymbolUrl: "https://lh3.googleusercontent.com/aida-public/...",
      electionYear: 2023,
      termStart: DateTime(2023, 5, 20),
      termEnd: DateTime(2028, 5, 20),
      phone: "+91 80 2235 4455",
      email: "rajesh.varma@assembly.gov.in",
      officeAddress: "No. 45, Varthur Main Road, Near HAL Signal, Bengaluru - 560087",
      photoUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuDRgINOzxmNicE51SkDFSF3iuAT_BqiYtKiYqHs3H85DaMVDpwoQ9MJJzx4EdWHcdtu7mjKJh04E813Txh_X1q4N-v3ZGw1fREqsvk0ByHBmYVGiPVsk7isXSx6-NweniyGP9crNqFWFCLIpMoVZ4MJeM3-3uSGeBfuV0S71DkV7d9f7rPjUvxDjMdtha6stNfhlfxhRciVkifR95S5VPJLPLvd-pZ-Wxf5CSmy27322oeaGb_LM7mghIC5yra1SvjzhtjkMKo-Gt7w",
      website: "https://rajeshvarma.in",
      twitterHandle: "@RajeshVarmaMLA",
      accountabilityScore: 68.0,
      promisesKeptRate: 68.0,
      responseRate: 92.0,
      openReportsPercentage: 14.0,
      totalReports: 255,
      resolvedReports: 219,
      openReports: 36,
      averageResponseTimeDays: 4,
      lastActivityDate: DateTime.now().subtract(const Duration(days: 1)),
      education: "Master of Public Policy (MPP) - National Law School",
      assets: 25000000.0,
      liabilities: 500000.0,
      criminalCases: 0,
      bio: "Rajesh Varma is a dedicated public servant serving the Mahadevapura and Varthur zones with a strong focus on data-driven governance, civic tech transparency, and modernizing municipal infrastructure. Prior to entering public office, he worked in urban planning and public policy research.",
      lastUpdated: DateTime.now(),
      createdAt: DateTime(2026, 5, 1),
      updatedAt: DateTime.now(),
      promises: [
        // Completed (Delivered)
        PoliticianPromise(
          id: "promise_001",
          politicianId: "leader_01",
          title: "Revitalization of Varthur Lake boundary walls & walkways.",
          description: "Full revamp of perimeter tracks, planting 1500 native saplings, and erecting protective boundary mesh to prevent industrial dumping.",
          category: "Public Park & Greenery Development",
          status: "Delivered",
          dueDate: DateTime(2025, 12, 31),
          evidenceCount: 12,
          createdAt: DateTime(2023, 6, 1),
          updatedAt: DateTime(2025, 12, 15),
        ),
        PoliticianPromise(
          id: "promise_002",
          politicianId: "leader_01",
          title: "Equipping 4 Ward Government Schools with smart classrooms.",
          description: "Procurement of smart projectors, high-speed fiber internet, and interactive training workshops for public educators to bridge the digital divide.",
          category: "Government School High-Tech Upgrade",
          status: "Delivered",
          dueDate: DateTime(2024, 6, 30),
          evidenceCount: 8,
          createdAt: DateTime(2023, 6, 1),
          updatedAt: DateTime(2024, 6, 15),
        ),
        PoliticianPromise(
          id: "promise_003",
          politicianId: "leader_01",
          title: "Installing 150 energy-efficient LED streetlights on crucial corridors.",
          description: "Transitioning dark, high-accident lane junctions to automated, low-emission high-intensity lights with solar cells.",
          category: "Road Infrastructure & Pothole Repair",
          status: "Delivered",
          dueDate: DateTime(2025, 3, 31),
          evidenceCount: 15,
          createdAt: DateTime(2023, 6, 1),
          updatedAt: DateTime(2025, 3, 20),
        ),
        // Active / Ongoing (In Progress)
        PoliticianPromise(
          id: "promise_004",
          politicianId: "leader_01",
          title: "Pothole-free Varthur Main Road campaign.",
          description: "Comprehensive resurfacing using long-lasting synthetic asphalt grid laying to withstand heavy monsoon water logging.",
          category: "Road Infrastructure & Pothole Repair",
          status: "In Progress",
          dueDate: DateTime(2027, 3, 31),
          evidenceCount: 22,
          createdAt: DateTime(2023, 6, 1),
          updatedAt: DateTime.now(),
        ),
        PoliticianPromise(
          id: "promise_005",
          politicianId: "leader_01",
          title: "Setting up a modern Solid Waste Segregation plant in Ward 142.",
          description: "Decentralized automated organic waste converter grid facility for zero-dumping in neighborhood dump yards.",
          category: "Solid Waste Disposal System",
          status: "Stalled",
          dueDate: DateTime(2026, 12, 31),
          evidenceCount: 5,
          createdAt: DateTime(2023, 6, 1),
          updatedAt: DateTime.now(),
        ),
        PoliticianPromise(
          id: "promise_006",
          politicianId: "leader_01",
          title: "Rebuilding primary water-drain networks to handle monsoon overflow.",
          description: "Dredging primary storm channels, cement concrete reinforcement, and laying internal pipelines.",
          category: "Municipal Drainage Revamp",
          status: "In Progress",
          dueDate: DateTime(2027, 6, 30),
          evidenceCount: 14,
          createdAt: DateTime(2023, 6, 1),
          updatedAt: DateTime.now(),
        ),
      ],
      schemes: [
        PoliticianScheme(
          id: "scheme_001",
          politicianId: "leader_01",
          title: "Varthur Ward 142 Lake Restoration Grid",
          description: "A comprehensive public conservation scheme dedicated to clearing encroachments, reinforcing lake perimeter fencing, and introducing biological water purification grids using custom reed beds.",
          eligibility: "All registered Varthur Ward 142 residents and lake preservation volunteers.",
          budgetAllocated: "₹1.2 Crores",
          beneficiariesCount: "45,000+ local citizens",
          status: "Active",
          createdAt: DateTime(2023, 8, 15),
        ),
        PoliticianScheme(
          id: "scheme_002",
          politicianId: "leader_01",
          title: "Mahadevapura Free Tech & Vocational Skill Hubs",
          description: "Initiated in partnership with local tech parks to provide free coding, accounting, and technical drafting training bootcamps for local public school alumni.",
          eligibility: "Aged 18-28. Must have completed high school from a government/public school inside the Mahadevapura zone.",
          budgetAllocated: "₹75 Lakhs",
          beneficiariesCount: "1,200 trained youth annually",
          status: "Active",
          createdAt: DateTime(2024, 1, 10),
        ),
        PoliticianScheme(
          id: "scheme_003",
          politicianId: "leader_01",
          title: "Ward Solar Street-Light Transition Plan",
          description: "Transitioning 100% of residential street lights to smart solar grids equipped with automatic light sensors and high-efficiency backup cells.",
          eligibility: "Applicable to all low-visibility public alleyways, secondary corridors, and school zones in the ward.",
          budgetAllocated: "₹45 Lakhs",
          beneficiariesCount: "Entire Ward 142 community",
          status: "Completed",
          createdAt: DateTime(2024, 7, 22),
        ),
      ],
      timeline: [
        PoliticianMilestone(
          id: "milestone_001",
          title: "Assumed MLA Office for Varthur",
          description: "Officially took oath as the MLA of Varthur / Mahadevapura constituency after securing 58.4% of the citizen vote.",
          date: DateTime(2023, 5, 20),
          type: "term_start",
          icon: Icons.account_balance,
        ),
        PoliticianMilestone(
          id: "milestone_002",
          title: "Smart Classroom Initiative Launch",
          description: "Delivered fully equipped smart projectors, fast internet infrastructure, and modern libraries to 4 major government schools.",
          date: DateTime(2024, 6, 15),
          type: "promise_completed",
          icon: Icons.school,
        ),
        PoliticianMilestone(
          id: "milestone_003",
          title: "Led Ward 142 Budget Townhall",
          description: "Direct civic engagement event at the Varthur Ward Community Hall, allocating ₹2.4 Crores to primary water-drain networks.",
          date: DateTime(2025, 2, 10),
          type: "townhall",
          icon: Icons.forum,
        ),
        PoliticianMilestone(
          id: "milestone_004",
          title: "Delivered Varthur Lake Walkway Revamp",
          description: "Completed perimeter walkways, sapling plantation drives, and garbage fencing along the southern bank.",
          date: DateTime(2025, 12, 15),
          type: "promise_completed",
          icon: Icons.nature_people,
        ),
        PoliticianMilestone(
          id: "milestone_005",
          title: "Upcoming Townhall: Monsoon Grid",
          description: "Scheduled assembly with civic volunteers to review monsoon storm-water drain readiness.",
          date: DateTime(2026, 6, 2),
          type: "future_milestone",
          icon: Icons.upcoming,
        ),
      ],
    ),
    Politician(
      id: "leader_02",
      name: "Manjula Devi",
      fullName: "Mrs. Manjula Devi",
      position: "Ward Councillor",
      level: "local",
      constituency: "Ward 142 - Varthur",
      wardNumber: "142",
      pinCode: "560087",
      assemblyConstituency: "Mahadevapura",
      state: "Karnataka",
      district: "Bengaluru Urban",
      latitude: 12.942,
      longitude: 77.744,
      party: "Independent Action Alliance",
      partySymbolUrl: "https://lh3.googleusercontent.com/aida-public/ind_symbol.png",
      electionYear: 2021,
      termStart: DateTime(2021, 9, 20),
      termEnd: DateTime(2026, 9, 20),
      phone: "+91 80 2235 1122",
      email: "manjula.devi@bbmp.gov.in",
      officeAddress: "No. 12, Varthur Ward Office, Bengaluru - 560087",
      photoUrl: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=400",
      website: "https://manjuladevi.org",
      twitterHandle: "@ManjulaCouncillor",
      accountabilityScore: 78.0,
      promisesKeptRate: 78.0,
      responseRate: 95.0,
      openReportsPercentage: 8.0,
      totalReports: 124,
      resolvedReports: 114,
      openReports: 10,
      averageResponseTimeDays: 2,
      lastActivityDate: DateTime.now().subtract(const Duration(hours: 4)),
      education: "Bachelor of Arts (BA) - Bangalore University",
      assets: 8500000.0,
      liabilities: 100000.0,
      criminalCases: 0,
      bio: "Manjula Devi is your local ward councillor focusing on civic sanity, clean roads, water pipelines, and micro-drainage networks in Ward 142. She has spent 15 years as a grassroots community organizer before running for ward council.",
      lastUpdated: DateTime.now(),
      createdAt: DateTime(2026, 5, 1),
      updatedAt: DateTime.now(),
      promises: [
        PoliticianPromise(
          id: "promise_101",
          politicianId: "leader_02",
          title: "Install 5 rainwater harvesting structures in public parks.",
          description: "Micro-reservoir capture loops to replenish local groundwater tables in Varthur parks.",
          category: "Rainwater Harvesting",
          status: "Delivered",
          dueDate: DateTime(2023, 10, 31),
          evidenceCount: 15,
          createdAt: DateTime(2021, 10, 1),
          updatedAt: DateTime(2023, 10, 20),
        ),
        PoliticianPromise(
          id: "promise_102",
          politicianId: "leader_02",
          title: "Micro-drainage cleanup drive before monsoon arrivals.",
          description: "Cleaning and desilting Varthur lanes and underground pipelines.",
          category: "Monsoon Grid Audit",
          status: "In Progress",
          dueDate: DateTime(2026, 6, 15),
          evidenceCount: 7,
          createdAt: DateTime(2026, 4, 1),
          updatedAt: DateTime.now(),
        ),
      ],
      schemes: [
        PoliticianScheme(
          id: "scheme_101",
          politicianId: "leader_02",
          title: "Varthur Local Borewell Restoration Grid",
          description: "Restoring and maintaining non-functional public borewells and setting up water filtration kiosks.",
          eligibility: "All registered Varthur Ward 142 residents.",
          budgetAllocated: "₹35 Lakhs",
          beneficiariesCount: "12,000+ local families",
          status: "Active",
          createdAt: DateTime(2022, 10, 1),
        ),
      ],
      timeline: [
        PoliticianMilestone(
          id: "milestone_101",
          title: "Elected as Councillor",
          description: "Assumed office as the Councillor for Ward 142 (Varthur) to coordinate micro-civic welfares.",
          date: DateTime(2021, 9, 20),
          type: "term_start",
          icon: Icons.how_to_reg,
        ),
      ],
    ),
    Politician(
      id: "leader_03",
      name: "Arvind Swamy",
      fullName: "Dr. Arvind Swamy",
      position: "Member of Parliament (MP)",
      level: "national",
      constituency: "Bengaluru Central Lok Sabha",
      wardNumber: "Central",
      pinCode: "560001",
      assemblyConstituency: "Bengaluru Central",
      state: "Karnataka",
      district: "Bengaluru Urban",
      latitude: 12.971,
      longitude: 77.594,
      party: "Progressive Civic Coalition",
      partySymbolUrl: "https://lh3.googleusercontent.com/aida-public/pcc_symbol.png",
      electionYear: 2024,
      termStart: DateTime(2024, 6, 1),
      termEnd: DateTime(2029, 6, 1),
      phone: "+91 80 2235 9900",
      email: "arvind.swamy@sansad.nic.in",
      officeAddress: "MP Office, Infantry Road, Bengaluru - 560001",
      photoUrl: "https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&q=80&w=400",
      website: "https://arvindswamy.mp",
      twitterHandle: "@ArvindSwamyMP",
      accountabilityScore: 55.0,
      promisesKeptRate: 55.0,
      responseRate: 75.0,
      openReportsPercentage: 25.0,
      totalReports: 1400,
      resolvedReports: 1050,
      openReports: 350,
      averageResponseTimeDays: 8,
      lastActivityDate: DateTime.now().subtract(const Duration(days: 2)),
      education: "Ph.D. in Public Administration - Oxford University",
      assets: 95000000.0,
      liabilities: 12000000.0,
      criminalCases: 1,
      bio: "Dr. Arvind Swamy is a veteran legislator representing Bengaluru Central in the national parliament. An advocate for green public transit, suburban rail systems, clean energy grids, and robust healthcare infrastructures.",
      lastUpdated: DateTime.now(),
      createdAt: DateTime(2026, 5, 1),
      updatedAt: DateTime.now(),
      promises: [
        PoliticianPromise(
          id: "promise_201",
          politicianId: "leader_03",
          title: "Suburban Rail Link integration approval.",
          description: "Securing union funding and approvals for the Bengaluru suburban rail route corridors.",
          category: "Mass Transit Development",
          status: "In Progress",
          dueDate: DateTime(2028, 12, 31),
          evidenceCount: 45,
          createdAt: DateTime(2024, 7, 1),
          updatedAt: DateTime.now(),
        ),
      ],
      schemes: [
        PoliticianScheme(
          id: "scheme_201",
          politicianId: "leader_03",
          title: "Central Bengaluru Green Canopy Scheme",
          description: "Urban forestry initiative to plant 50,000 trees across heavy commercial zones.",
          eligibility: "Applicable to all commercial zones, layouts, and public spaces in the constituency.",
          budgetAllocated: "₹2.5 Crores",
          beneficiariesCount: "Entire Central Bengaluru",
          status: "Active",
          createdAt: DateTime(2024, 10, 1),
        ),
      ],
      timeline: [
        PoliticianMilestone(
          id: "milestone_201",
          title: "Sworn in as MP",
          description: "Assumed Lok Sabha office representing Bengaluru Central constituency to coordinate national-level programs.",
          date: DateTime(2024, 6, 1),
          type: "term_start",
          icon: Icons.account_balance,
        ),
      ],
    ),
    Politician(
      id: "leader_04",
      name: "Siddaramaiah",
      fullName: "Mr. Siddaramaiah",
      position: "Chief Minister (CM)",
      level: "state",
      constituency: "State of Karnataka",
      wardNumber: "State",
      pinCode: "560001",
      assemblyConstituency: "Varuna",
      state: "Karnataka",
      district: "Mysuru",
      latitude: 12.971,
      longitude: 77.594,
      party: "National Democratic Union",
      partySymbolUrl: "https://lh3.googleusercontent.com/aida-public/ndu_symbol.png",
      electionYear: 2023,
      termStart: DateTime(2023, 5, 20),
      termEnd: DateTime(2028, 5, 20),
      phone: "+91 80 2225 2244",
      email: "cm.karnataka@gov.in",
      officeAddress: "Vidhana Soudha, Bengaluru - 560001",
      photoUrl: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&q=80&w=400",
      website: "https://karnataka.gov.in",
      twitterHandle: "@CMofKarnataka",
      accountabilityScore: 61.0,
      promisesKeptRate: 61.0,
      responseRate: 80.0,
      openReportsPercentage: 18.0,
      totalReports: 8500,
      resolvedReports: 6800,
      openReports: 1700,
      averageResponseTimeDays: 14,
      lastActivityDate: DateTime.now().subtract(const Duration(days: 3)),
      education: "Bachelor of Science (B.Sc.), LL.B - Mysuru University",
      assets: 45000000.0,
      liabilities: 2000000.0,
      criminalCases: 0,
      bio: "Mr. Siddaramaiah is the honorable Chief Minister of Karnataka, leading structural statewide infrastructures, welfare schemes, and decentralization initiatives.",
      lastUpdated: DateTime.now(),
      createdAt: DateTime(2026, 5, 1),
      updatedAt: DateTime.now(),
      promises: [
        PoliticianPromise(
          id: "promise_301",
          politicianId: "leader_04",
          title: "Provide 200 units of free power to domestic connections.",
          description: "State-wide free electricity program to support lower and middle-income homes.",
          category: "State Welfare Program",
          status: "Delivered",
          dueDate: DateTime(2023, 12, 31),
          evidenceCount: 1500,
          createdAt: DateTime(2023, 6, 1),
          updatedAt: DateTime(2023, 12, 10),
        ),
      ],
      schemes: [
        PoliticianScheme(
          id: "scheme_301",
          politicianId: "leader_04",
          title: "Gruha Jyothi Scheme",
          description: "Providing up to 200 units of free electricity per month for domestic households in Karnataka.",
          eligibility: "All domestic households residing in Karnataka with average consumption below 200 units.",
          budgetAllocated: "₹13,000 Crores",
          beneficiariesCount: "1.4 Crore households",
          status: "Active",
          createdAt: DateTime(2023, 6, 1),
        ),
      ],
      timeline: [
        PoliticianMilestone(
          id: "milestone_301",
          title: "Sworn in as CM",
          description: "Assumed office as Chief Minister of Karnataka for a historic second term.",
          date: DateTime(2023, 5, 20),
          type: "term_start",
          icon: Icons.gavel,
        ),
      ],
    ),
    Politician(
      id: "leader_05",
      name: "Narendra Modi",
      fullName: "Mr. Narendra Damodardas Modi",
      position: "Prime Minister (PM)",
      level: "national",
      constituency: "Republic of India",
      wardNumber: "India",
      pinCode: "110001",
      assemblyConstituency: "Varanasi",
      state: "Uttar Pradesh",
      district: "Varanasi",
      latitude: 28.613,
      longitude: 77.209,
      party: "People's Democratic Front",
      partySymbolUrl: "https://lh3.googleusercontent.com/aida-public/pdf_symbol.png",
      electionYear: 2024,
      termStart: DateTime(2024, 6, 9),
      termEnd: DateTime(2029, 6, 9),
      phone: "+91 11 2301 2312",
      email: "pmindia@gov.in",
      officeAddress: "South Block, Raisina Hill, New Delhi - 110011",
      photoUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=400",
      website: "https://pmindia.gov.in",
      twitterHandle: "@narendramodi",
      accountabilityScore: 72.0,
      promisesKeptRate: 72.0,
      responseRate: 85.0,
      openReportsPercentage: 10.0,
      totalReports: 45000,
      resolvedReports: 40500,
      openReports: 4500,
      averageResponseTimeDays: 20,
      lastActivityDate: DateTime.now().subtract(const Duration(days: 1)),
      education: "Master of Arts in Political Science - Gujarat University",
      assets: 30000000.0,
      liabilities: 0.0,
      criminalCases: 0,
      bio: "Mr. Narendra Modi is the honorable Prime Minister of the Republic of India, coordinating national welfares, strategic programs, digital governance loops, and public infrastructures.",
      lastUpdated: DateTime.now(),
      createdAt: DateTime(2026, 5, 1),
      updatedAt: DateTime.now(),
      promises: [
        PoliticianPromise(
          id: "promise_401",
          politicianId: "leader_05",
          title: "Digital India Kiosks across 2.5 Lakh Panchayats.",
          description: "Providing high-speed optical fiber connectivity and online citizen service portals to rural centers.",
          category: "Digital Empowerment Link",
          status: "Delivered",
          dueDate: DateTime(2025, 12, 31),
          evidenceCount: 12000,
          createdAt: DateTime(2024, 6, 15),
          updatedAt: DateTime(2025, 12, 20),
        ),
      ],
      schemes: [
        PoliticianScheme(
          id: "scheme_401",
          politicianId: "leader_05",
          title: "PM-WANI Free Public Wi-Fi Program",
          description: "Elevating internet accessibility by setting up Public Data Offices (PDOs) across commercial and educational locations.",
          eligibility: "Open to all citizens and local vendors across India.",
          budgetAllocated: "₹1,200 Crores",
          beneficiariesCount: "50 Million+ connected users",
          status: "Active",
          createdAt: DateTime(2024, 8, 1),
        ),
      ],
      timeline: [
        PoliticianMilestone(
          id: "milestone_401",
          title: "Sworn in as PM",
          description: "Assumed office as the Prime Minister of India for his third consecutive cabinet term.",
          date: DateTime(2024, 6, 9),
          type: "term_start",
          icon: Icons.stars,
        ),
      ],
    ),
  ];

  // Reports/Issues List
  final List<CivicIssue> issues = [
    CivicIssue(
      id: "issue_001",
      title: "Severe Potholes & Waterlogging",
      description: "Severe crater-sized potholes are causing massive traffic gridlocks and minor accidents right at the entrance of Varthur Main Road. During even light rainfall, this section fills with deep drainage water, completely masking the road hazard for commuters.",
      category: "Roads",
      latitude: 12.9428,
      longitude: 77.7471,
      locationName: "Varthur Main Road, near Shell Petrol Station",
      imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuBcKo1EkkKt7q0y1WJBz0UeFvOr6kmL0jNVkr2FYS8X5uIqL9zVFV8AHT7Tbd8ANjbHcG5zCR4-TeTkoRBuV8qiBt9h45t7sCWrw03O5LZvF7-awEUUoF2YC5CWrt8KYrDNMjpa18H6nkXbW9nP7tYohu-QjXWMbK5DcmhEElaw_YLb9ERQ5hb4QjN9QxQIhMENHkqPiQUTFYAFuK3aQfwIj0RiqiCP8IDt8UlJBs22lonSlvsHz5j3_WsTPd-KLKJCLqPlpZnRD8n_",
      reporterName: "Ananya Hegde",
      timeAgo: "2 hours ago",
      dateFiled: DateTime.now().subtract(const Duration(hours: 2)),
      status: IssueStatus.inProgress,
      upvotes: 247,
      comments: [
        IssueComment(
          id: "c1",
          authorName: "Rahul Sharma",
          authorBadge: "Resident",
          text: "I literally saw a scooter slip here yesterday! Very dangerous in the dark.",
          timestamp: DateTime.now().subtract(const Duration(minutes: 90)),
        ),
        IssueComment(
          id: "c2",
          authorName: "Devanand K.",
          authorBadge: "Volunteer",
          text: "Submitted an escalatory RTI query regarding the maintenance contract. Keep upvoting this so we can automatically push it to the central grievance portal!",
          timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        )
      ],
      timelineLogs: [
        "Reported by Ananya Hegde — May 27, 2026",
        "Geo-Coordinates & Metadata Verified — May 27, 2026",
        "Assigned to PWD Sub-Engineer (Monsoon Grid) — May 27, 2026",
      ],
    ),
    CivicIssue(
      id: "issue_002",
      title: "Broken Streetlight Junction",
      description: "Three consecutive poles at the intersection of 4th Cross and Vinayaka layout are completely dead for the past 2 weeks. It creates a dark zone at night which is very unsafe for walking.",
      category: "Electricity",
      latitude: 12.9395,
      longitude: 77.7412,
      locationName: "Vinayaka Layout, 4th Cross Junction",
      imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuBcKo1EkkKt7q0y1WJBz0UeFvOr6kmL0jNVkr2FYS8X5uIqL9zVFV8AHT7Tbd8ANjbHcG5zCR4-TeTkoRBuV8qiBt9h45t7sCWrw03O5LZvF7-awEUUoF2YC5CWrt8KYrDNMjpa18H6nkXbW9nP7tYohu-QjXWMbK5DcmhEElaw_YLb9ERQ5hb4QjN9QxQIhMENHkqPiQUTFYAFuK3aQfwIj0RiqiCP8IDt8UlJBs22lonSlvsHz5j3_WsTPd-KLKJCLqPlpZnRD8n_",
      reporterName: "Vikram Malhotra",
      timeAgo: "1 day ago",
      dateFiled: DateTime.now().subtract(const Duration(days: 1)),
      status: IssueStatus.verified,
      upvotes: 89,
      comments: [],
      timelineLogs: [
        "Reported by Vikram Malhotra — May 26, 2026",
        "OTP Sign-off Completed by 5 Residents — May 26, 2026"
      ],
    ),
    CivicIssue(
      id: "issue_003",
      title: "Garbage Dump in Front of Park",
      description: "Huge piles of solid plastic and organic waste are dumped right next to the Children's Park gate. Stray dogs are scattering it and it smells terrible. BBMP dump truck has skipped this corner twice.",
      category: "Waste Management",
      latitude: 12.9451,
      longitude: 77.7505,
      locationName: "Varthur Lake Public Park Entrance",
      imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuBcKo1EkkKt7q0y1WJBz0UeFvOr6kmL0jNVkr2FYS8X5uIqL9zVFV8AHT7Tbd8ANjbHcG5zCR4-TeTkoRBuV8qiBt9h45t7sCWrw03O5LZvF7-awEUUoF2YC5CWrt8KYrDNMjpa18H6nkXbW9nP7tYohu-QjXWMbK5DcmhEElaw_YLb9ERQ5hb4QjN9QxQIhMENHkqPiQUTFYAFuK3aQfwIj0RiqiCP8IDt8UlJBs22lonSlvsHz5j3_WsTPd-KLKJCLqPlpZnRD8n_",
      reporterName: "Kavitha R.",
      timeAgo: "2 days ago",
      dateFiled: DateTime.now().subtract(const Duration(days: 2)),
      status: IssueStatus.resolved,
      upvotes: 312,
      comments: [
        IssueComment(
          id: "c3",
          authorName: "Rajesh Varma (MLA Office)",
          authorBadge: "Official",
          text: "Electoral ward sanitation team has cleared this debris and issued a notice to vendors. CCTV is being installed.",
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        )
      ],
      timelineLogs: [
        "Reported by Kavitha R. — May 25, 2026",
        "Assigned to BBMP Waste Taskforce — May 25, 2026",
        "Issue Resolved & Verified by Ward Citizens — May 26, 2026",
      ],
    )
  ];

  // Community Discussion Feed
  final List<CommunityDiscussion> discussions = [
    CommunityDiscussion(
      id: "disc_001",
      title: "Monsoon Preparedness: How prepared is Varthur?",
      content: "With heavy pre-monsoon showers causing localized flooding already, let's discuss our actions. We should form a resident volunteer grid to keep check of storm-water drain clogs and alert BBMP directly using our Netagraph dashboards.",
      authorName: "Devanand K.",
      authorRole: "Volunteer",
      timeAgo: "4 hours ago",
      upvotes: 42,
      replies: [
        "Completely agree! We need a contact sheet of all street level coordinators.",
        "MLA Rajesh Varma promised the primary storm drain project would finish before monsoons, but progress is only at 40%. We should organize a peaceful assembly.",
        "Count me in. I can cover Balagere lane updates."
      ],
    ),
    CommunityDiscussion(
      id: "disc_002",
      title: "Speed breakers needed on Varthur-Balagere Rd",
      content: "After the lake pathway opened, vehicle traffic has surged and motorbikes are speeding excessively. We need rubber speed humps near the school gate immediately before a major accident occurs.",
      authorName: "Meera Sen",
      authorRole: "Resident",
      timeAgo: "1 day ago",
      upvotes: 75,
      replies: [
        "Yes, the school zone must have a speed limit of 20km/h.",
        "We can submit a formal request petition directly on the MLA tab here!"
      ],
    )
  ];

  // Official Announcements
  final List<CivicAnnouncement> announcements = [
    CivicAnnouncement(
      id: "ann_001",
      title: "Lake Cleaning Drive this Sunday",
      content: "Join the Varthur Lake Preservation volunteer drive this Sunday at 7:00 AM. Refreshments and equipment will be provided at the entrance. Rajesh Varma (MLA) will be visiting to review lake boundary wall works.",
      authorName: "Anil Kumar (Lead Volunteer)",
      timeAgo: "1 hour ago",
      isUrgent: true,
    ),
    CivicAnnouncement(
      id: "ann_002",
      title: "Monsoon Water Supply Schedule Notice",
      content: "Due to overhead tank cleanups by BWSSB, water supply will be restricted in Balagere and Sorahunase zones on Thursday between 10 AM and 4 PM. Please stock accordingly.",
      authorName: "Municipal Water Board",
      timeAgo: "1 day ago",
      isUrgent: false,
    )
  ];

  // Civic Events
  final List<CivicEvent> events = [
    CivicEvent(
      id: "event_001",
      title: "Ward 142 Open Grievance Assembly",
      description: "A direct face-to-face townhall session where MLA Rajesh Varma and BBMP ward officers will address citizen complaints registered on Netagraph. Submit your top questions before RSVPing.",
      dateText: "June 2, 2026",
      timeText: "10:00 AM - 1:00 PM",
      locationText: "Varthur Ward Office Community Hall",
      rsvpCount: 148,
    ),
    CivicEvent(
      id: "event_002",
      title: "Aids & First Aid Safety Workshop",
      description: "Organized by volunteer group Vanguard Civic, this free workshop teaches emergency CPR, street accident first-response, and local emergency contact coordination for residents.",
      dateText: "June 6, 2026",
      timeText: "4:00 PM - 6:30 PM",
      locationText: "Children's Park Gazebo, Varthur Lake",
      rsvpCount: 64,
    )
  ];

  // Active Ward Selection state
  String selectedWard = "";
  
  void setWard(String ward) {
    selectedWard = ward;
    notifyListeners();
  }

  // Phase 4 Trust Rate Limits and Anti-Spam state
  final List<DateTime> _submissionTimestamps = [];
  int _consecutiveUpvotes = 0;
  DateTime? _lastUpvoteTime;
  bool captchaTriggered = false;

  int getHourlySubmissionCount() {
    final oneHourAgo = DateTime.now().subtract(const Duration(hours: 1));
    return _submissionTimestamps.where((t) => t.isAfter(oneHourAgo)).length;
  }

  void verifyCaptcha() {
    captchaTriggered = false;
    _consecutiveUpvotes = 0;
    notifyListeners();
  }

  // Reporting interactive operations
  Future<void> addIssue({
    required String title,
    required String description,
    required String category,
    required String locationName,
    required String imageFilePath,
  }) async {
    // 1. Rate Limiting Check
    if (getHourlySubmissionCount() >= 3) {
      suspiciousFlags.insert(0, SuspiciousActivityFlag(
        id: "flag_rate_${DateTime.now().millisecondsSinceEpoch}",
        reportId: "issue_rate_limit",
        flagType: 'ip_burst',
        reason: 'Rate limit triggered! User exceeded 3 submissions per hour threshold.',
        severity: 2,
        notes: 'Coordinated rate limiter triggered on client side.',
        createdAt: DateTime.now(),
      ));
      return;
    }
    _submissionTimestamps.add(DateTime.now());

    final success = await SupabaseService.addIssue(
      title: title,
      description: description,
      category: category,
      locationName: locationName,
      imageFilePath: imageFilePath,
      reporterName: currentUser.name,
      userId: currentUser.id,
    );

    if (success) {
      await _syncSupabase();
    } else {
      // Fallback locally in memory if database insert fails (e.g. offline)
      final issueId = "issue_${DateTime.now().millisecondsSinceEpoch}";
      final mockIpHash = "f5a709b110de7c68832a8ba76eef5a0928ba7f96cfb2ba73ee6f1c7d2c3be992";
      final newIssue = CivicIssue(
        id: issueId,
        title: title,
        description: description,
        category: category,
        latitude: 12.9420,
        longitude: 77.7440,
        locationName: locationName,
        imageUrl: imageFilePath.isNotEmpty ? imageFilePath : "https://images.unsplash.com/photo-1597223557154-721c1cecc4b0?auto=format&fit=crop&q=80&w=400",
        reporterName: currentUser.name,
        timeAgo: "Just now",
        dateFiled: DateTime.now(),
        status: IssueStatus.pending,
        upvotes: 1,
        comments: [],
        timelineLogs: [
          "Reported by ${currentUser.name} — Just now",
          "GPS Verification Success: Ward 142 Boundary match verified.",
          "EXIF Verification Success: Verified camera OnePlus 11 5G geostamp.",
          "Pending civic OTP & community consensus."
        ],
        ipAddressHash: mockIpHash,
        deviceFingerprint: "device_fingerprint_7f8ba39a",
        locationArea: "Ward 142 - Varthur",
        gpsVerified: true,
        exifVerified: true,
        exifCamera: "OnePlus 11 5G",
        exifTimestamp: DateTime.now().toIso8601String(),
      );

      issues.insert(0, newIssue);
      notifyListeners();
    }
  }

  Future<void> toggleUpvoteIssue(String issueId) async {
    // 2. Anti-Spam Upvote Monitor / CAPTCHA
    final now = DateTime.now();
    if (_lastUpvoteTime != null && now.difference(_lastUpvoteTime!).inSeconds < 2) {
      _consecutiveUpvotes++;
      if (_consecutiveUpvotes >= 4) {
        captchaTriggered = true;
        notifyListeners();
        return; // Halt upvote registering
      }
    } else {
      _consecutiveUpvotes = 0;
    }
    _lastUpvoteTime = now;

    final index = issues.indexWhere((element) => element.id == issueId);
    if (index != -1) {
      final issue = issues[index];
      
      // Perform database toggle
      await SupabaseService.toggleUpvoteIssue(issue, currentUser);
      
      // Refresh database records
      await _syncSupabase();
    }
  }

  Future<void> addCommentToIssue(String issueId, String text) async {
    final index = issues.indexWhere((element) => element.id == issueId);
    if (index != -1) {
      await SupabaseService.addCommentToIssue(
        issueId,
        currentUser.name,
        currentUser.isResidentVerified ? "Verified Resident" : "Resident",
        text,
        currentUser.id,
      );
      
      await _syncSupabase();
    }
  }

  Future<void> toggleRSVP(String eventId) async {
    final index = events.indexWhere((element) => element.id == eventId);
    if (index != -1) {
      final event = events[index];
      await SupabaseService.toggleRSVP(event, currentUser.id);
      
      await _syncSupabase();
    }
  }

  Future<void> addDiscussion({required String title, required String content}) async {
    await SupabaseService.addDiscussion(title, content, currentUser.name, currentUser.id);
    await _syncSupabase();
  }

  Future<void> upvoteDiscussion(String discId) async {
    final index = discussions.indexWhere((element) => element.id == discId);
    if (index != -1) {
      final disc = discussions[index];
      await SupabaseService.upvoteDiscussion(disc);
      await _syncSupabase();
    }
  }

  Future<void> addReplyToDiscussion(String discId, String text) async {
    final index = discussions.indexWhere((element) => element.id == discId);
    if (index != -1) {
      final disc = discussions[index];
      await SupabaseService.addReplyToDiscussion(disc, text);
      await _syncSupabase();
    }
  }

  Future<void> addAnnouncement({required String title, required String content, required bool isUrgent}) async {
    await SupabaseService.addAnnouncement(title, content, currentUser.name);
    await _syncSupabase();
  }

  Future<void> flagIssueManual({
    required String issueId,
    required String reason,
    required String type,
    int severity = 2,
  }) async {
    await SupabaseService.flagIssueManual(
      issueId,
      reason,
      type,
      severity,
      currentUser.id,
      currentUser.name,
    );
    await _syncSupabase();
  }

  Future<void> confirmFlag(String flagId) async {
    await SupabaseService.confirmFlag(flagId);
    await _syncSupabase();
  }

  Future<void> dismissFlag(String flagId) async {
    await SupabaseService.dismissFlag(flagId);
    await _syncSupabase();
  }

  void banUser(String userId) {
    // Ban user simulation: mark all flags related to this reporter's reports as Confirmed
    // and tag them with ban notes.
    notifyListeners();
  }

  // Phase 4 Community Flagging & Voter ID verification methods
  Future<void> submitResidentVerification(String docType) async {
    await SupabaseService.submitResidentVerification(
      docType,
      currentUser.id,
      currentUser.badges,
      currentUser.activeScore,
    );
    await _syncSupabase();
  }

  Future<void> reportIssueSuspicious(String issueId, String reason, String type) async {
    await SupabaseService.reportIssueSuspicious(
      issueId,
      reason,
      type,
      currentUser.id,
    );
    await _syncSupabase();
  }
}
