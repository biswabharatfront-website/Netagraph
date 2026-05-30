import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/vanguard_theme.dart';

class ChatMessage {
  final String sender;
  final String? avatar;
  final String text;
  final String time;
  final bool incoming;

  ChatMessage({
    required this.sender,
    this.avatar,
    required this.text,
    required this.time,
    required this.incoming,
  });
}

class ChatThread {
  final String id;
  final String title;
  final String subtitle;
  final IconData? icon;
  final bool isDm;
  final String? avatar;
  final List<ChatMessage> messages;

  ChatThread({
    required this.id,
    required this.title,
    required this.subtitle,
    this.icon,
    this.isDm = false,
    this.avatar,
    required this.messages,
  });
}

class CommunityChatScreen extends StatefulWidget {
  const CommunityChatScreen({super.key});

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  String _activeTab = 'channels'; // 'channels' or 'dms'
  String _activeThreadId = 'channel-general';
  bool _isMobileChatOpen = false; // For mobile responsive back/forth
  
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  bool _isTyping = false;
  String _typingText = '';
  
  // In-memory chat database matching community_chat/code.html
  late Map<String, ChatThread> _chatDatabase;

  @override
  void initState() {
    super.initState();
    
    _chatDatabase = {
      'channel-general': ChatThread(
        id: 'channel-general',
        title: '#ward-142-general',
        subtitle: 'Ward General Chat',
        icon: Icons.tag,
        messages: [
          ChatMessage(
            sender: 'Priya Sharma',
            avatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=100',
            text: 'Hello everyone! MLA Rajesh Varma has just confirmed the new cleanup assembly this weekend!',
            time: '10:04 AM',
            incoming: true,
          ),
          ChatMessage(
            sender: 'Ramesh K.',
            text: 'That is great news, Priya. Hope we get the garbage dump cleared near Varthur main market.',
            time: '10:07 AM',
            incoming: true,
          ),
          ChatMessage(
            sender: 'Basar Sen',
            text: 'The water leakage issue near the junction has finally been resolved today. Big thanks to the volunteers!',
            time: '10:10 AM',
            incoming: false,
          ),
        ],
      ),
      'channel-waste': ChatThread(
        id: 'channel-waste',
        title: '#garbage-clearance',
        subtitle: 'Garbage Clearance Drive',
        icon: Icons.delete_sweep,
        messages: [
          ChatMessage(
            sender: 'Priya Sharma',
            avatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=100',
            text: 'Welcome to the Garbage Clearance channel! We are organizing the drive this Saturday at 8:00 AM.',
            time: 'Yesterday',
            incoming: true,
          ),
          ChatMessage(
            sender: 'Priya Sharma',
            avatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=100',
            text: 'Cleanliness drive RSVP is up on the community dashboard. Please invite your neighbors.',
            time: 'Yesterday',
            incoming: true,
          ),
        ],
      ),
      'channel-pipeline': ChatThread(
        id: 'channel-pipeline',
        title: '#civic-pipeline',
        subtitle: 'Civic Pipeline discussions',
        icon: Icons.timeline,
        messages: [
          ChatMessage(
            sender: 'Ramesh K.',
            text: 'Welcome! In this channel we track promise fulfillment status and civic budget logs.',
            time: '2 Days ago',
            incoming: true,
          ),
          ChatMessage(
            sender: 'Ramesh K.',
            text: '4 projects synced this week. Let me know if there are discrepancies.',
            time: '5h ago',
            incoming: true,
          ),
        ],
      ),
      'dm-rajesh': ChatThread(
        id: 'dm-rajesh',
        title: 'MLA Rajesh Varma',
        subtitle: 'Official Representative',
        isDm: true,
        avatar: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDRgINOzxmNicE51SkDFSF3iuAT_BqiYtKiYqHs3H85DaMVDpwoQ9MJJzx4EdWHcdtu7mjKJh04E813Txh_X1q4N-v3ZGw1fREqsvk0ByHBmYVGiPVsk7isXSx6-NweniyGP9crNqFWFCLIpMoVZ4MJeM3-3uSGeBfuV0S71DkV7d9f7rPjUvxDjMdtha6stNfhlfxhRciVkifR95S5VPJLPLvd-pZ-Wxf5CSmy27322oeaGb_LM7mghIC5yra1SvjzhtjkMKo-Gt7w',
        messages: [
          ChatMessage(
            sender: 'Basar Sen',
            text: 'Respected MLA Rajesh Varma, I have filed a water leak report for Ward 142. It has been waterlogged for 3 days.',
            time: '11:40 AM',
            incoming: false,
          ),
          ChatMessage(
            sender: 'MLA Rajesh Varma',
            avatar: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDRgINOzxmNicE51SkDFSF3iuAT_BqiYtKiYqHs3H85DaMVDpwoQ9MJJzx4EdWHcdtu7mjKJh04E813Txh_X1q4N-v3ZGw1fREqsvk0ByHBmYVGiPVsk7isXSx6-NweniyGP9crNqFWFCLIpMoVZ4MJeM3-3uSGeBfuV0S71DkV7d9f7rPjUvxDjMdtha6stNfhlfxhRciVkifR95S5VPJLPLvd-pZ-Wxf5CSmy27322oeaGb_LM7mghIC5yra1SvjzhtjkMKo-Gt7w',
            text: 'Namaste Basar, I have received your water complaint. I have instructed the local PWD engineer to visit the site immediately. We are tracking this closely.',
            time: 'Just now',
            incoming: true,
          ),
        ],
      ),
      'dm-priya': ChatThread(
        id: 'dm-priya',
        title: 'Priya Sharma',
        subtitle: 'Community Manager',
        isDm: true,
        avatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=100',
        messages: [
          ChatMessage(
            sender: 'Priya Sharma',
            avatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=100',
            text: 'Hi Basar! Thanks for the feedback on the loading screen flow, it works perfectly now.',
            time: 'Yesterday',
            incoming: true,
          ),
          ChatMessage(
            sender: 'Basar Sen',
            text: 'Always happy to support the community, Priya!',
            time: 'Yesterday',
            incoming: false,
          ),
        ],
      ),
    };
    
    // Auto-scroll to bottom on startup
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    setState(() {
      _chatDatabase[_activeThreadId]!.messages.add(
        ChatMessage(
          sender: 'Basar Sen',
          text: text,
          time: timeStr,
          incoming: false,
        ),
      );
      _messageController.clear();
    });

    _scrollToBottom();
    _triggerAutoReply();
  }

  void _triggerAutoReply() {
    String responderName = "Community Voice";
    String? responderAvatar;
    String responseText = "Thanks for sharing this! Let's escalate this together.";

    if (_activeThreadId == 'channel-general') {
      responderName = "Priya Sharma";
      responderAvatar = "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=100";
      responseText = "Yes Basar, absolutely. Let's make sure it gets verified by other ward members too!";
    } else if (_activeThreadId == 'channel-waste') {
      responderName = "Priya Sharma";
      responderAvatar = "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=100";
      responseText = "Perfect! See you at Saturday's drive. Don't forget to RSVP on the Events tab.";
    } else if (_activeThreadId == 'dm-rajesh') {
      responderName = "MLA Rajesh Varma";
      responderAvatar = "https://lh3.googleusercontent.com/aida-public/AB6AXuDRgINOzxmNicE51SkDFSF3iuAT_BqiYtKiYqHs3H85DaMVDpwoQ9MJJzx4EdWHcdtu7mjKJh04E813Txh_X1q4N-v3ZGw1fREqsvk0ByHBmYVGiPVsk7isXSx6-NweniyGP9crNqFWFCLIpMoVZ4MJeM3-3uSGeBfuV0S71DkV7d9f7rPjUvxDjMdtha6stNfhlfxhRciVkifR95S5VPJLPLvd-pZ-Wxf5CSmy27322oeaGb_LM7mghIC5yra1SvjzhtjkMKo-Gt7w";
      responseText = "I will request the municipal commissioner's daily ledger file for Ward 142. We want 100% accountability on water projects.";
    } else if (_activeThreadId == 'dm-priya') {
      responderName = "Priya Sharma";
      responderAvatar = "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=100";
      responseText = "Great! I've pinned the main action checklist items to the explore page.";
    }

    // Delay 500ms before typing indicator appears
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _isTyping = true;
        _typingText = "$responderName is typing...";
      });
      _scrollToBottom();

      // Delay 1500ms before actual reply is added
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (!mounted) return;
        final replyNow = DateTime.now();
        final replyTimeStr = "${replyNow.hour.toString().padLeft(2, '0')}:${replyNow.minute.toString().padLeft(2, '0')}";

        setState(() {
          _isTyping = false;
          _chatDatabase[_activeThreadId]!.messages.add(
            ChatMessage(
              sender: responderName,
              avatar: responderAvatar,
              text: responseText,
              time: replyTimeStr,
              incoming: true,
            ),
          );
        });
        _scrollToBottom();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VanguardTheme.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLargeScreen = constraints.maxWidth >= 600;
          
          if (isLargeScreen) {
            // Tablet/Desktop Split Layout
            return Row(
              children: [
                SizedBox(
                  width: 320,
                  child: _buildSidebar(),
                ),
                VerticalDivider(width: 1, color: Colors.white.withOpacity(0.08)),
                Expanded(
                  child: _buildChatCanvas(false),
                ),
              ],
            );
          } else {
            // Mobile Single-Panel Layout with dynamic slide
            return _isMobileChatOpen 
                ? _buildChatCanvas(true)
                : _buildSidebar();
          }
        },
      ),
    );
  }

  // PANEL 1: SIDEBAR (Thread lists)
  Widget _buildSidebar() {
    final filteredThreads = _chatDatabase.values.where((thread) {
      if (_activeTab == 'channels') {
        return !thread.isDm;
      } else {
        return thread.isDm;
      }
    }).toList();

    return Scaffold(
      backgroundColor: VanguardTheme.background,
      appBar: AppBar(
        backgroundColor: VanguardTheme.background,
        elevation: 0,
        leading: _isMobileChatOpen 
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: VanguardTheme.primaryContainer),
                onPressed: () => Navigator.pop(context),
              ),
        title: Text(
          'Community Chat',
          style: GoogleFonts.sora(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: VanguardTheme.onSurface,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              height: 40,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: VanguardTheme.surfaceElevated,
                borderRadius: VanguardTheme.borderMedium,
                border: Border.all(color: Colors.white.withOpacity(0.04)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTabButton('channels', 'Channels'),
                  ),
                  Expanded(
                    child: _buildTabButton('dms', 'Direct'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: VanguardTheme.surfaceContainerHigh,
                borderRadius: VanguardTheme.borderMedium,
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: TextField(
                style: GoogleFonts.inter(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search chats...',
                  hintStyle: GoogleFonts.inter(color: VanguardTheme.slate.withOpacity(0.7), fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: VanguardTheme.slate, size: 18),
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          
          // Thread List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: filteredThreads.length,
              itemBuilder: (context, index) {
                final thread = filteredThreads[index];
                final isSelected = thread.id == _activeThreadId;
                
                final lastMsg = thread.messages.isNotEmpty 
                    ? thread.messages.last 
                    : null;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _activeThreadId = thread.id;
                        _isMobileChatOpen = true;
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                    },
                    borderRadius: VanguardTheme.borderMedium,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? VanguardTheme.surfaceElevated.withOpacity(0.6) 
                            : Colors.transparent,
                        borderRadius: VanguardTheme.borderMedium,
                        border: Border.all(
                          color: isSelected 
                              ? VanguardTheme.primaryContainer.withOpacity(0.2) 
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Avatar Icon
                          _buildAvatar(thread),
                          const SizedBox(width: 12),
                          // Detail text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              thread.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.inter(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: VanguardTheme.onSurface,
                                              ),
                                            ),
                                          ),
                                          if (thread.isDm && thread.id == 'dm-rajesh')
                                            const Padding(
                                              padding: EdgeInsets.only(left: 4.0),
                                              child: Icon(Icons.verified, color: VanguardTheme.success, size: 14),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      lastMsg?.time ?? '',
                                      style: GoogleFonts.inter(fontSize: 10, color: VanguardTheme.slate),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  lastMsg != null 
                                      ? "${lastMsg.sender.split(' ').first}: ${lastMsg.text}" 
                                      : thread.subtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: isSelected ? VanguardTheme.onSurface.withOpacity(0.7) : VanguardTheme.slate,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String tab, String label) {
    final isActive = _activeTab == tab;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTab = tab;
        });
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? VanguardTheme.surfaceContainerHigh : Colors.transparent,
          borderRadius: VanguardTheme.borderMedium,
        ),
        child: Text(
          label,
          style: GoogleFonts.sora(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive ? VanguardTheme.primaryContainer : VanguardTheme.slate,
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(ChatThread thread) {
    if (thread.isDm) {
      return Stack(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(thread.avatar ?? ''),
            backgroundColor: VanguardTheme.surfaceContainerHigh,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: VanguardTheme.success,
                shape: BoxShape.circle,
                border: Border.all(color: VanguardTheme.background, width: 2),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: VanguardTheme.primaryContainer.withOpacity(0.12),
          borderRadius: VanguardTheme.borderMedium,
          border: Border.all(color: VanguardTheme.primaryContainer.withOpacity(0.3)),
        ),
        child: Icon(
          thread.icon ?? Icons.tag,
          color: VanguardTheme.primaryContainer,
          size: 20,
        ),
      );
    }
  }

  // PANEL 2: CHAT CANVAS
  Widget _buildChatCanvas(bool showBackButton) {
    final activeThread = _chatDatabase[_activeThreadId]!;

    return Scaffold(
      backgroundColor: VanguardTheme.background,
      appBar: AppBar(
        backgroundColor: VanguardTheme.surfaceElevated,
        elevation: 0,
        leading: showBackButton 
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: VanguardTheme.primaryContainer),
                onPressed: () {
                  setState(() {
                    _isMobileChatOpen = false;
                  });
                },
              )
            : null,
        title: Row(
          children: [
            if (!activeThread.isDm)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: VanguardTheme.primaryContainer.withOpacity(0.1),
                  borderRadius: VanguardTheme.borderMedium,
                ),
                child: Icon(activeThread.icon, color: VanguardTheme.primaryContainer, size: 18),
              )
            else
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(activeThread.avatar ?? ''),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        activeThread.title,
                        style: GoogleFonts.sora(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: VanguardTheme.onSurface,
                        ),
                      ),
                      if (activeThread.isDm && activeThread.id == 'dm-rajesh')
                        const Padding(
                          padding: EdgeInsets.only(left: 4.0),
                          child: Icon(Icons.verified, color: VanguardTheme.success, size: 14),
                        ),
                    ],
                  ),
                  Text(
                    activeThread.subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: VanguardTheme.slate,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: VanguardTheme.slate, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: VanguardTheme.slate, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: activeThread.messages.length,
              itemBuilder: (context, index) {
                final msg = activeThread.messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),
          
          // Typing Indicator
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 8, top: 4),
              child: Row(
                children: [
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(VanguardTheme.primaryContainer),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _typingText,
                    style: GoogleFonts.inter(fontSize: 11, color: VanguardTheme.slate),
                  ),
                ],
              ),
            ),

          // Message input bar
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: msg.incoming 
            ? MainAxisAlignment.start 
            : MainAxisAlignment.end,
        children: [
          if (msg.incoming) ...[
            if (msg.avatar != null)
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(msg.avatar!),
              )
            else
              CircleAvatar(
                radius: 16,
                backgroundColor: VanguardTheme.surfaceContainerHigh,
                child: Text(
                  msg.sender.substring(0, 2).toUpperCase(),
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: VanguardTheme.slate),
                ),
              ),
            const SizedBox(width: 8),
          ],
          
          Column(
            crossAxisAlignment: msg.incoming 
                ? CrossAxisAlignment.start 
                : CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    msg.sender,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: VanguardTheme.slate,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    msg.time,
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      color: VanguardTheme.slate.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              
              // Bubble with glassmorphism or gradient
              Container(
                constraints: const BoxConstraints(maxWidth: 260),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: msg.incoming ? null : VanguardTheme.actionGradient,
                  color: msg.incoming ? VanguardTheme.surfaceElevated : null,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: msg.incoming ? const Radius.circular(2) : const Radius.circular(16),
                    bottomRight: msg.incoming ? const Radius.circular(16) : const Radius.circular(2),
                  ),
                  border: msg.incoming 
                      ? Border.all(color: Colors.white.withOpacity(0.05)) 
                      : null,
                ),
                child: Text(
                  msg.text,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: VanguardTheme.surfaceElevated,
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: VanguardTheme.slate, size: 22),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.photo_camera_outlined, color: VanguardTheme.slate, size: 22),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: VanguardTheme.surfaceContainerHigh,
                  borderRadius: VanguardTheme.borderLarge,
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: _messageController,
                          style: GoogleFonts.inter(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Type message...',
                            hintStyle: GoogleFonts.inter(color: VanguardTheme.slate.withOpacity(0.5), fontSize: 13),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: VanguardTheme.primaryContainer, size: 18),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
