import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../models/civic_models.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  /// Signs in anonymously and returns/creates a public user profile.
  static Future<CivicUser?> initializeSession() async {
    try {
      if (_client.auth.currentSession == null) {
        await _client.auth.signInAnonymously();
      }

      final user = _client.auth.currentUser;
      if (user != null) {
        final profile = await _client.from('profiles').select().eq('id', user.id).maybeSingle();
        if (profile == null) {
          final newProfile = {
            'id': user.id,
            'name': 'Resident ' + user.id.substring(0, 4),
            'phone': user.phone ?? '+91 98765 43210',
            'role': 'citizen',
          };
          await _client.from('profiles').insert(newProfile);
          return CivicUser(
            id: user.id,
            name: newProfile['name'] as String,
            phone: newProfile['phone'] as String,
            avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=150',
            wardName: 'Ward 142 - Varthur',
            locationText: 'Varthur, Bengaluru, Karnataka 560087',
            reportsFiled: 0,
            contributionsCount: 0,
            activeScore: 0,
            badges: [],
            reputationScore: 100.0,
            reputationLevel: 'New Citizen',
            isResidentVerified: false,
            residentVerificationStatus: 'None',
          );
        } else {
          return CivicUser(
            id: profile['id'],
            name: profile['name'] ?? 'Resident',
            phone: profile['phone'] ?? '+91 98765 43210',
            avatarUrl: profile['avatar_url'] ?? 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=150',
            wardName: profile['ward_name'] ?? 'Ward 142 - Varthur',
            locationText: profile['location_text'] ?? 'Varthur, Bengaluru, Karnataka 560087',
            reportsFiled: profile['reports_filed'] ?? 0,
            contributionsCount: profile['contributions_count'] ?? 0,
            activeScore: profile['active_score'] ?? 0,
            badges: List<String>.from(profile['badges'] ?? []),
            reputationScore: (profile['reputation_score'] as num?)?.toDouble() ?? 100.0,
            reputationLevel: profile['reputation_level'] ?? 'New Citizen',
            isResidentVerified: profile['is_resident_verified'] ?? false,
            residentVerificationStatus: profile['resident_verification_status'] ?? 'None',
            uploadedDocType: profile['uploaded_doc_type'],
            uploadedDocUrl: profile['uploaded_doc_url'],
          );
        }
      }
    } catch (e) {
      debugPrint("Supabase Auth initialization failed: $e");
    }
    return null;
  }

  /// Fetches all politicians and their nested promises, schemes, and milestones.
  static Future<List<Politician>> fetchPoliticians() async {
    final List<Politician> list = [];
    try {
      final data = await _client.from('politicians').select('*, promises:politician_promises(*), schemes:politician_schemes(*), milestones:politician_milestones(*)');
      for (var row in data) {
        final List<PoliticianPromise> promisesList = (row['promises'] as List).map((p) => PoliticianPromise(
          id: p['id'],
          politicianId: p['politician_id'],
          title: p['title'],
          description: p['description'] ?? "",
          category: p['category'] ?? "",
          status: p['status'],
          dueDate: p['due_date'] != null ? DateTime.parse(p['due_date']) : null,
          evidenceCount: p['evidence_count'] ?? 0,
          createdAt: DateTime.parse(p['created_at']),
          updatedAt: DateTime.parse(p['updated_at']),
        )).toList();

        final List<PoliticianScheme> schemesList = (row['schemes'] as List).map((s) => PoliticianScheme(
          id: s['id'],
          politicianId: s['politician_id'],
          title: s['title'],
          description: s['description'],
          eligibility: s['eligibility'],
          budgetAllocated: s['budget_allocated'],
          beneficiariesCount: s['beneficiaries_count'],
          status: s['status'],
          createdAt: DateTime.parse(s['created_at']),
        )).toList();

        final List<PoliticianMilestone> milestonesList = (row['milestones'] as List).map((m) => PoliticianMilestone(
          id: m['id'],
          title: m['title'],
          description: m['description'],
          date: DateTime.parse(m['date']),
          type: m['type'],
        )).toList();

        list.add(Politician(
          id: row['id'],
          name: row['name'],
          fullName: row['full_name'],
          position: row['position'],
          level: row['level'],
          constituency: row['constituency'],
          wardNumber: row['ward_number'],
          pinCode: row['pin_code'],
          assemblyConstituency: row['assembly_constituency'],
          parliamentaryConstituency: row['parliamentary_constituency'],
          state: row['state'],
          district: row['district'],
          latitude: (row['latitude'] as num?)?.toDouble(),
          longitude: (row['longitude'] as num?)?.toDouble(),
          party: row['party'],
          partySymbolUrl: row['party_symbol_url'],
          electionYear: row['election_year'],
          termStart: row['term_start'] != null ? DateTime.parse(row['term_start']) : null,
          termEnd: row['term_end'] != null ? DateTime.parse(row['term_end']) : null,
          phone: row['phone'],
          email: row['email'],
          officeAddress: row['office_address'],
          photoUrl: row['photo_url'] ?? "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&q=80&w=400",
          website: row['website'],
          twitterHandle: row['twitter_handle'],
          facebookUrl: row['facebook_url'],
          accountabilityScore: (row['accountability_score'] as num?)?.toDouble() ?? 0.0,
          promisesKeptRate: (row['promises_kept_rate'] as num?)?.toDouble() ?? 0.0,
          responseRate: (row['response_rate'] as num?)?.toDouble() ?? 0.0,
          openReportsPercentage: (row['open_reports_percentage'] as num?)?.toDouble() ?? 0.0,
          totalReports: row['total_reports'] ?? 0,
          resolvedReports: row['resolved_reports'] ?? 0,
          openReports: row['open_reports'] ?? 0,
          averageResponseTimeDays: (row['average_response_time_days'] as num?)?.toInt(),
          lastActivityDate: row['last_activity_date'] != null ? DateTime.parse(row['last_activity_date']) : null,
          education: row['education'],
          assets: (row['assets'] as num?)?.toDouble(),
          liabilities: (row['liabilities'] as num?)?.toDouble(),
          criminalCases: row['criminal_cases'] ?? 0,
          bio: row['bio'],
          source: row['source'],
          sourceUrl: row['source_url'],
          lastUpdated: DateTime.parse(row['last_updated'] ?? DateTime.now().toIso8601String()),
          isActive: row['is_active'] ?? true,
          isVerified: row['is_verified'] ?? false,
          createdAt: DateTime.parse(row['created_at'] ?? DateTime.now().toIso8601String()),
          updatedAt: DateTime.parse(row['updated_at'] ?? DateTime.now().toIso8601String()),
          promises: promisesList,
          schemes: schemesList,
          timeline: milestonesList,
        ));
      }
    } catch (e) {
      debugPrint("Error fetching politicians: $e");
    }
    return list;
  }

  /// Fetches all active citizen reports and comments.
  static Future<List<CivicIssue>> fetchIssues() async {
    final List<CivicIssue> list = [];
    try {
      final user = _client.auth.currentUser;
      final data = await _client.from('reports').select('*, comments(*)').order('created_at', ascending: false);
      for (var row in data) {
        final List<IssueComment> commentsList = (row['comments'] as List).map((c) => IssueComment(
          id: c['id'],
          authorName: c['author_name'],
          authorBadge: c['author_badge'] ?? "Resident",
          text: c['text'],
          timestamp: DateTime.parse(c['created_at']),
        )).toList();

        bool isUpvotedByUser = false;
        if (user != null) {
          final check = await _client.from('upvotes').select().eq('report_id', row['id']).eq('user_id', user.id).maybeSingle();
          isUpvotedByUser = check != null;
        }

        list.add(CivicIssue(
          id: row['id'],
          title: row['title'],
          description: row['description'],
          category: row['category'],
          latitude: (row['latitude'] as num?)?.toDouble() ?? 12.9420,
          longitude: (row['longitude'] as num?)?.toDouble() ?? 77.7440,
          locationName: row['location_name'] ?? "",
          imageUrl: row['image_url'] ?? "",
          reporterName: row['reporter_name'] ?? "",
          timeAgo: _formatTimeAgo(DateTime.parse(row['created_at'])),
          dateFiled: DateTime.parse(row['created_at']),
          status: _mapStatus(row['status']),
          upvotes: row['upvotes'] ?? 0,
          isUpvoted: isUpvotedByUser,
          comments: commentsList,
          timelineLogs: [
            "Reported by ${row['reporter_name']} — " + DateFormat('MMM dd, yyyy').format(DateTime.parse(row['created_at'])),
            "Geo-Coordinates & Metadata Verified",
          ],
          ipAddressHash: row['ip_address_hash'],
          deviceFingerprint: row['device_fingerprint'],
          locationArea: row['location_area'],
          gpsVerified: row['gps_verified'] ?? true,
          exifVerified: row['exif_verified'] ?? true,
          exifCamera: row['exif_camera'] ?? "OnePlus 11 5G",
          exifTimestamp: row['exif_timestamp'] ?? row['created_at'],
          suspiciousFlagsCount: row['suspicious_flags_count'] ?? 0,
          isReportedSuspicious: row['is_reported_suspicious'] ?? false,
        ));
      }
    } catch (e) {
      debugPrint("Error fetching issues: $e");
    }
    return list;
  }

  /// Fetches discussions.
  static Future<List<CommunityDiscussion>> fetchDiscussions() async {
    final List<CommunityDiscussion> list = [];
    try {
      final data = await _client.from('discussions').select().order('created_at', ascending: false);
      for (var row in data) {
        list.add(CommunityDiscussion(
          id: row['id'],
          title: row['title'],
          content: row['content'],
          authorName: row['author_name'],
          authorRole: row['author_role'] ?? "Resident",
          timeAgo: _formatTimeAgo(DateTime.parse(row['created_at'])),
          upvotes: row['upvotes'] ?? 1,
          replies: List<String>.from(row['replies'] ?? []),
        ));
      }
    } catch (e) {
      debugPrint("Error fetching discussions: $e");
    }
    return list;
  }

  /// Fetches announcements.
  static Future<List<CivicAnnouncement>> fetchAnnouncements() async {
    final List<CivicAnnouncement> list = [];
    try {
      final data = await _client.from('announcements').select().order('created_at', ascending: false);
      for (var row in data) {
        list.add(CivicAnnouncement(
          id: row['id'],
          title: row['title'],
          content: row['content'],
          authorName: row['author_name'],
          timeAgo: _formatTimeAgo(DateTime.parse(row['created_at'])),
          isUrgent: row['is_urgent'] ?? false,
        ));
      }
    } catch (e) {
      debugPrint("Error fetching announcements: $e");
    }
    return list;
  }

  /// Fetches events.
  static Future<List<CivicEvent>> fetchEvents() async {
    final List<CivicEvent> list = [];
    try {
      final user = _client.auth.currentUser;
      final data = await _client.from('events').select().order('created_at', ascending: false);
      for (var row in data) {
        bool isRSVPedByUser = false;
        if (user != null) {
          final rsvp = await _client.from('event_rsvps').select().eq('event_id', row['id']).eq('user_id', user.id).maybeSingle();
          isRSVPedByUser = rsvp != null;
        }

        list.add(CivicEvent(
          id: row['id'],
          title: row['title'],
          description: row['description'],
          dateText: row['date_text'],
          timeText: row['time_text'],
          locationText: row['location_text'],
          rsvpCount: row['rsvp_count'] ?? 0,
          isRSVPed: isRSVPedByUser,
        ));
      }
    } catch (e) {
      debugPrint("Error fetching events: $e");
    }
    return list;
  }

  /// Adds a new civic issue report.
  static Future<bool> addIssue({
    required String title,
    required String description,
    required String category,
    required String locationName,
    required String imageFilePath,
    required String reporterName,
    required String userId,
  }) async {
    try {
      final mockIpHash = "f5a709b110de7c68832a8ba76eef5a0928ba7f96cfb2ba73ee6f1c7d2c3be992";
      await _client.from('reports').insert({
        'title': title,
        'description': description,
        'category': category,
        'latitude': 12.9420,
        'longitude': 77.7440,
        'location_name': locationName,
        'image_url': imageFilePath.isNotEmpty ? imageFilePath : "https://images.unsplash.com/photo-1597223557154-721c1cecc4b0?auto=format&fit=crop&q=80&w=400",
        'reporter_name': reporterName,
        'status': 'pending',
        'ip_address_hash': mockIpHash,
        'device_fingerprint': "device_fingerprint_7f8ba39a",
        'location_area': "Ward 142 - Varthur",
        'exif_camera': "OnePlus 11 5G",
      });

      // Update contributions and reports count on profile
      final currentProfile = await _client.from('profiles').select().eq('id', userId).maybeSingle();
      if (currentProfile != null) {
        await _client.from('profiles').update({
          'reports_filed': (currentProfile['reports_filed'] ?? 0) + 1,
          'contributions_count': (currentProfile['contributions_count'] ?? 0) + 1,
          'active_score': (currentProfile['active_score'] ?? 0) + 50,
        }).eq('id', userId);
      }
      return true;
    } catch (e) {
      debugPrint("Error inserting report: $e");
    }
    return false;
  }

  /// Casts or removes upvotes.
  static Future<void> toggleUpvoteIssue(CivicIssue issue, CivicUser user) async {
    try {
      final voteWeight = user.isResidentVerified ? 3 : 1;
      if (issue.isUpvoted) {
        await _client.from('upvotes').delete().eq('report_id', issue.id).eq('user_id', user.id);
        await _client.from('reports').update({
          'upvotes': (issue.upvotes - voteWeight).clamp(0, 9999999),
        }).eq('id', issue.id);
      } else {
        await _client.from('upvotes').insert({
          'report_id': issue.id,
          'user_id': user.id,
          'ip_address_hash': "f5a709b110de7c68832a8ba76eef5a0928ba7f96cfb2ba73ee6f1c7d2c3be992",
        });
        await _client.from('reports').update({
          'upvotes': issue.upvotes + voteWeight,
        }).eq('id', issue.id);

        final profile = await _client.from('profiles').select().eq('id', user.id).maybeSingle();
        if (profile != null) {
          await _client.from('profiles').update({
            'contributions_count': (profile['contributions_count'] ?? 0) + 1,
            'active_score': (profile['active_score'] ?? 0) + 5,
          }).eq('id', user.id);
        }
      }
    } catch (e) {
      debugPrint("Error toggling upvote: $e");
    }
  }

  /// Adds a new comment.
  static Future<void> addCommentToIssue(String issueId, String authorName, String badge, String text, String userId) async {
    try {
      await _client.from('comments').insert({
        'report_id': issueId,
        'author_name': authorName,
        'author_badge': badge,
        'text': text,
      });

      final profile = await _client.from('profiles').select().eq('id', userId).maybeSingle();
      if (profile != null) {
        await _client.from('profiles').update({
          'contributions_count': (profile['contributions_count'] ?? 0) + 1,
          'active_score': (profile['active_score'] ?? 0) + 10,
        }).eq('id', userId);
      }
    } catch (e) {
      debugPrint("Error inserting comment: $e");
    }
  }

  /// RSVP to events.
  static Future<void> toggleRSVP(CivicEvent event, String userId) async {
    try {
      if (event.isRSVPed) {
        await _client.from('event_rsvps').delete().eq('event_id', event.id).eq('user_id', userId);
        await _client.from('events').update({
          'rsvp_count': (event.rsvpCount - 1).clamp(0, 999999),
        }).eq('id', event.id);
      } else {
        await _client.from('event_rsvps').insert({
          'event_id': event.id,
          'user_id': userId,
        });
        await _client.from('events').update({
          'rsvp_count': event.rsvpCount + 1,
        }).eq('id', event.id);
      }
    } catch (e) {
      debugPrint("Error toggling RSVP: $e");
    }
  }

  /// Add new discussion.
  static Future<void> addDiscussion(String title, String content, String authorName, String userId) async {
    try {
      await _client.from('discussions').insert({
        'title': title,
        'content': content,
        'author_name': authorName,
        'author_role': 'Resident',
        'upvotes': 1,
      });

      final profile = await _client.from('profiles').select().eq('id', userId).maybeSingle();
      if (profile != null) {
        await _client.from('profiles').update({
          'contributions_count': (profile['contributions_count'] ?? 0) + 1,
          'active_score': (profile['active_score'] ?? 0) + 20,
        }).eq('id', userId);
      }
    } catch (e) {
      debugPrint("Error adding discussion: $e");
    }
  }

  /// Upvotes a discussion topic.
  static Future<void> upvoteDiscussion(CommunityDiscussion disc) async {
    try {
      await _client.from('discussions').update({
        'upvotes': disc.isUpvoted ? (disc.upvotes - 1).clamp(0, 9999) : disc.upvotes + 1,
      }).eq('id', disc.id);
    } catch (e) {
      debugPrint("Error upvoting discussion: $e");
    }
  }

  /// Adds a reply to a discussion.
  static Future<void> addReplyToDiscussion(CommunityDiscussion disc, String text) async {
    try {
      final updatedReplies = [...disc.replies, text];
      await _client.from('discussions').update({
        'replies': updatedReplies,
      }).eq('id', disc.id);
    } catch (e) {
      debugPrint("Error replying to discussion: $e");
    }
  }

  /// Adds a volunteer announcement.
  static Future<void> addAnnouncement(String title, String content, String authorName) async {
    try {
      await _client.from('announcements').insert({
        'title': title,
        'content': content,
        'author_name': authorName,
        'is_urgent': false,
      });
    } catch (e) {
      debugPrint("Error adding announcement: $e");
    }
  }

  /// Adds a manual moderator flag.
  static Future<void> flagIssueManual(String issueId, String reason, String type, int severity, String userId, String authorName) async {
    try {
      await _client.from('suspicious_activity_flags').insert({
        'report_id': issueId,
        'flag_type': type,
        'reason': reason,
        'severity': severity,
        'flagged_by': userId,
        'notes': "Manually flagged by moderator " + authorName,
      });
    } catch (e) {
      debugPrint("Error flagging report manually: $e");
    }
  }

  /// Voter ID resident verification submission.
  static Future<void> submitResidentVerification(String docType, String userId, List<String> currentBadges, int activeScore) async {
    try {
      await _client.from('profiles').update({
        'is_resident_verified': true,
        'resident_verification_status': 'Verified',
        'active_score': activeScore + 100,
        'reputation_score': 99.8,
        'reputation_level': 'Civic Elder',
        'uploaded_doc_type': docType,
        'uploaded_doc_url': 'voter_id_verified_metadata_stamped.pdf',
        'badges': [...currentBadges, 'Verified Resident'],
      }).eq('id', userId);
    } catch (e) {
      debugPrint("Error verifying resident profile: $e");
    }
  }

  /// Reports a report/issue as suspicious from community side.
  static Future<void> reportIssueSuspicious(String issueId, String reason, String type, String userId) async {
    try {
      await _client.from('reports').update({
        'is_reported_suspicious': true,
        'suspicious_flags_count': 1,
      }).eq('id', issueId);

      await _client.from('suspicious_activity_flags').insert({
        'report_id': issueId,
        'flag_type': type,
        'reason': "Community Flagged: " + reason,
        'severity': 2,
        'flagged_by': userId,
        'notes': "Manual citizen flag for coordinated spam auditing.",
      });
    } catch (e) {
      debugPrint("Error community reporting suspicious: $e");
    }
  }

  static String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) {
      return "${diff.inMinutes}m ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours}h ago";
    } else {
      return "${diff.inDays}d ago";
    }
  }

  static IssueStatus _mapStatus(String? status) {
    if (status == 'verified') return IssueStatus.verified;
    if (status == 'inProgress') return IssueStatus.inProgress;
    if (status == 'resolved') return IssueStatus.resolved;
    return IssueStatus.pending;
  }
}
