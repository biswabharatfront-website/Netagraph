// ==========================================================================
// NETAGRAPH COMMAND PORTAL INTERACTIVE CORE LOGIC
// ==========================================================================

const supabaseUrl = 'https://zvcaisaagjvsbtkptezc.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp2Y2Fpc2FhZ2p2c2J0a3B0ZXpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAxMzY0MjgsImV4cCI6MjA5NTcxMjQyOH0.KIFDuH61hwFHXdhWb-61yN1BGH-s-BISwGK4X_FxyE0';

let supabase = null;
let isBypassMode = false;
let activeTab = 'overview';

// In-Memory Fallbacks for Developer Bypass Mode
let mockFlags = [
    {
        id: "flag_001",
        report_id: "issue_001",
        flag_type: "ip_burst",
        reason: "IP Range Burst: 6 reports submitted from the same hashed IP address in the last 2 hours.",
        severity: 3,
        status: "Pending",
        notes: "System Auto-Trigger: High frequency IP correlation.",
        created_at: new Date(Date.now() - 45 * 60 * 1000).toISOString()
    },
    {
        id: "flag_002",
        report_id: "issue_002",
        flag_type: "text_similarity",
        reason: "Text Similarity Alert: Found recent duplicate report matching title/description with >82% similarity index.",
        severity: 1,
        status: "Pending",
        notes: "System Auto-Trigger: Word similarity matches resolved issue 003.",
        created_at: new Date(Date.now() - 75 * 60 * 1000).toISOString()
    }
];

let mockReports = [
    {
        id: "issue_001",
        title: "Severe Potholes & Waterlogging",
        description: "Severe crater-sized potholes are causing massive traffic gridlocks and minor accidents right at the entrance of Varthur Main Road.",
        category: "Roads",
        location_name: "Varthur Main Road, near Shell Petrol Station",
        image_url: "https://images.unsplash.com/photo-1597223557154-721c1cecc4b0?auto=format&fit=crop&q=80&w=400",
        reporter_name: "Ananya Hegde",
        status: "inProgress",
        upvotes: 247,
        created_at: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString(),
        gps_verified: true,
        exif_verified: true
    },
    {
        id: "issue_002",
        title: "Broken Streetlight Junction",
        description: "Three consecutive poles at the intersection of 4th Cross and Vinayaka layout are completely dead for the past 2 weeks.",
        category: "Electricity",
        location_name: "Vinayaka Layout, 4th Cross Junction",
        image_url: "https://images.unsplash.com/photo-1506546332852-c6f393836d59?auto=format&fit=crop&q=80&w=400",
        reporter_name: "Vikram Malhotra",
        status: "pending",
        upvotes: 89,
        created_at: new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString(),
        gps_verified: true,
        exif_verified: false
    },
    {
        id: "issue_003",
        title: "Garbage Dump in Front of Park",
        description: "Huge piles of solid plastic and organic waste are dumped right next to the Children's Park gate.",
        category: "Waste Management",
        location_name: "Varthur Lake Public Park Entrance",
        image_url: "https://images.unsplash.com/photo-1611284446314-60a58ac0deb9?auto=format&fit=crop&q=80&w=400",
        reporter_name: "Kavitha R.",
        status: "resolved",
        upvotes: 312,
        created_at: new Date(Date.now() - 48 * 60 * 60 * 1000).toISOString(),
        gps_verified: true,
        exif_verified: true
    }
];

let mockPoliticians = [
    {
        id: "leader_01",
        name: "Rajesh Varma",
        position: "MLA (Mahadevapura)",
        party: "Citizen Action Alliance (CAA)",
        photo_url: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=400",
        accountability_score: 68.0,
        promises_kept_rate: 68.0,
        response_rate: 92.0,
        total_reports: 255,
        resolved_reports: 219,
        open_reports: 36
    },
    {
        id: "leader_02",
        name: "Manjula Devi",
        position: "Ward Councillor (Ward 142)",
        party: "Independent Action Alliance",
        photo_url: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&q=80&w=400",
        accountability_score: 78.0,
        promises_kept_rate: 78.0,
        response_rate: 95.0,
        total_reports: 124,
        resolved_reports: 114,
        open_reports: 10
    }
];

// Initialize application on DOM content load
document.addEventListener('DOMContentLoaded', () => {
    // Attempt initialization of Supabase client
    try {
        supabase = supabase.createClient(supabaseUrl, supabaseKey);
    } catch (e) {
        console.warn("Could not load Supabase client (likely offline or script blocked). Fallback to bypass mode.");
    }

    bindEvents();
    updateDateTime();
});

function updateDateTime() {
    const timeElement = document.getElementById('current-time');
    if (timeElement) {
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        timeElement.textContent = new Date().toLocaleDateString('en-US', options);
    }
}

// ==========================================================================
// DOM & LOGIN INTERACTIVE EVENTS BINDING
// ==========================================================================

function bindEvents() {
    // Login Form Submission
    const loginForm = document.getElementById('login-form');
    if (loginForm) {
        loginForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value.trim();
            const btnLogin = document.getElementById('btn-login');
            
            btnLogin.classList.add('loading');
            btnLogin.disabled = true;

            const success = await handleSecureLogin(email, password);
            
            btnLogin.classList.remove('loading');
            btnLogin.disabled = false;

            if (success) {
                showDashboard();
            } else {
                showLoginError("Access denied. Admin or Moderator privileges required.");
            }
        });
    }

    // Developer Test Bypass Button
    const btnBypass = document.getElementById('btn-bypass');
    if (btnBypass) {
        btnBypass.addEventListener('click', () => {
            isBypassMode = true;
            document.getElementById('user-name').textContent = "Developer Preview";
            document.getElementById('user-role').textContent = "Moderator Sandbox";
            document.getElementById('user-avatar').src = "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&q=80&w=150";
            showDashboard();
        });
    }

    // Logout Button
    const btnLogout = document.getElementById('btn-logout');
    if (btnLogout) {
        btnLogout.addEventListener('click', () => {
            handleLogout();
        });
    }

    // Sidebar navigation tabs toggle
    const navItems = document.querySelectorAll('.nav-item');
    navItems.forEach(item => {
        item.addEventListener('click', () => {
            const target = item.getAttribute('data-target');
            switchTab(target);
        });
    });

    // Filtering controls
    document.getElementById('grievance-search').addEventListener('input', renderGrievanceTab);
    document.getElementById('filter-category').addEventListener('change', renderGrievanceTab);
    document.getElementById('filter-status').addEventListener('change', renderGrievanceTab);

    // Audit Dispatch submission
    document.getElementById('audit-dispatch-form').addEventListener('submit', handleAuditDispatch);
    
    // Scorecard edit submission
    document.getElementById('scorecard-edit-form').addEventListener('submit', handleScorecardSave);
}

// ==========================================================================
// SECURE LOGIN & AUTH PIPELINE
// ==========================================================================

async function handleSecureLogin(email, password) {
    if (!supabase) return false;
    try {
        const { data, error } = await supabase.auth.signInWithPassword({ email, password });
        if (error || !data.user) return false;

        // Fetch user profile role from custom profiles database table
        const { data: profile, error: pError } = await supabase
            .from('profiles')
            .select('name, role, avatar_url')
            .eq('id', data.user.id)
            .maybeSingle();

        if (pError || !profile || (profile.role !== 'admin' && profile.role !== 'moderator')) {
            await supabase.auth.signOut();
            return false;
        }

        // Hydrate Admin Details in Sidebar
        document.getElementById('user-name').textContent = profile.name ?? 'Moderator';
        document.getElementById('user-role').textContent = profile.role === 'admin' ? 'Lead Auditor' : 'Moderator';
        if (profile.avatar_url) {
            document.getElementById('user-avatar').src = profile.avatar_url;
        }
        return true;
    } catch (e) {
        console.error("Login attempt error:", e);
    }
    return false;
}

function handleLogout() {
    if (supabase && !isBypassMode) {
        supabase.auth.signOut();
    }
    isBypassMode = false;
    document.getElementById('dashboard-container').style.display = 'none';
    document.getElementById('login-container').style.display = 'flex';
}

function showDashboard() {
    document.getElementById('login-container').style.display = 'none';
    document.getElementById('dashboard-container').style.display = 'grid';
    switchTab('overview');
}

function showLoginError(msg) {
    const errorBanner = document.getElementById('login-error');
    const errorMessage = document.getElementById('error-message');
    errorMessage.textContent = msg;
    errorBanner.style.display = 'flex';
    setTimeout(() => {
        errorBanner.style.display = 'none';
    }, 4000);
}

// ==========================================================================
// SIDEBAR TABS CONTROL & DATA HYDRATION
// ==========================================================================

async function switchTab(tabName) {
    activeTab = tabName;
    
    // Toggle active classes in navigation items
    const navItems = document.querySelectorAll('.nav-item');
    navItems.forEach(item => {
        item.classList.remove('active');
        if (item.getAttribute('data-target') === tabName) {
            item.classList.add('active');
        }
    });

    // Toggle active classes in panels
    const panels = document.querySelectorAll('.dashboard-panel');
    panels.forEach(panel => {
        panel.classList.remove('active');
        if (panel.id === `panel-${tabName}`) {
            panel.classList.add('active');
        }
    });

    // Hydrate tab content
    await hydrateData();
}

async function hydrateData() {
    let reports = [];
    let flags = [];
    let politicians = [];

    if (isBypassMode) {
        reports = mockReports;
        flags = mockFlags;
        politicians = mockPoliticians;
    } else {
        if (!supabase) return;
        try {
            const { data: rData } = await supabase.from('reports').select('*').order('created_at', { ascending: false });
            const { data: fData } = await supabase.from('suspicious_activity_flags').select('*').order('created_at', { ascending: false });
            const { data: pData } = await supabase.from('politicians').select('*');
            reports = rData ?? [];
            flags = fData ?? [];
            politicians = pData ?? [];
        } catch (e) {
            console.error("Supabase hydration error: ", e);
        }
    }

    // Hydrate stat numbers
    const pendingFlags = flags.filter(f => f.status === 'Pending').length;
    document.getElementById('stat-pending-flags').textContent = pendingFlags;
    document.getElementById('badge-flags-count').textContent = pendingFlags;
    document.getElementById('stat-resolved-reports').textContent = reports.filter(r => r.status === 'resolved').length;
    document.getElementById('stat-active-reports').textContent = reports.filter(r => r.status !== 'resolved').length;
    
    const mla = politicians.find(p => p.name.includes("Rajesh") || p.position.includes("MLA"));
    if (mla) {
        document.getElementById('stat-mla-score').textContent = mla.accountability_score + "%";
    }

    // Execute panel specific rendering
    if (activeTab === 'overview') {
        renderOverviewTab(reports, flags);
    } else if (activeTab === 'flags') {
        renderFlagsTab(reports, flags);
    } else if (activeTab === 'grievances') {
        renderGrievanceTab(reports);
    } else if (activeTab === 'politicians') {
        renderPoliticiansTab(politicians);
    }
}

// ==========================================================================
// TAB SPECIFIC RENDERERS
// ==========================================================================

function renderOverviewTab(reports, flags) {
    const tbody = document.getElementById('tbody-recent-grievances');
    tbody.innerHTML = '';

    const recent = reports.slice(0, 5);
    if (recent.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" class="text-center empty-state">No citizen reports registered yet.</td></tr>';
        return;
    }

    recent.forEach(r => {
        const isVerified = r.gps_verified && r.exif_verified;
        tbody.innerHTML += `
            <tr>
                <td>#${r.id.substring(0, 8)}</td>
                <td>
                    <div class="table-details">
                        <h4>${r.title}</h4>
                        <p>${r.location_name}</p>
                    </div>
                </td>
                <td><span class="badge badge-info">${r.category}</span></td>
                <td><span class="badge ${getStatusClass(r.status)}">${r.status.toUpperCase()}</span></td>
                <td>
                    <span class="material-icons" style="color: ${isVerified ? 'var(--success)' : 'var(--warning)'}; font-size: 18px;">
                        ${isVerified ? 'verified' : 'help_outline'}
                    </span>
                </td>
                <td>
                    <button class="btn btn-secondary btn-small" onclick="openAuditDrawer('${r.id}')">Audit</button>
                </td>
            </tr>
        `;
    });

    // Hydrate latest security logs
    const logList = document.getElementById('list-security-logs');
    logList.innerHTML = '';
    const pendingIncidents = flags.filter(f => f.status === 'Pending').slice(0, 4);
    
    if (pendingIncidents.length === 0) {
        logList.innerHTML = '<li class="empty-state">No pending security incidents flagged.</li>';
        return;
    }

    pendingIncidents.forEach(f => {
        logList.innerHTML += `
            <li class="security-log-item">
                <span class="material-icons log-indicator ${f.severity === 3 ? 'log-red' : 'log-orange'}">
                    ${f.severity === 3 ? 'error' : 'warning'}
                </span>
                <div class="log-details">
                    <h4>${f.flag_type.toUpperCase()} ALERT</h4>
                    <p>${f.reason}</p>
                </div>
            </li>
        `;
    });
}

function renderFlagsTab(reports, flags) {
    const grid = document.getElementById('flags-grid');
    grid.innerHTML = '';

    const pending = flags.filter(f => f.status === 'Pending');
    if (pending.length === 0) {
        grid.innerHTML = `
            <div class="empty-state-large glass-card">
                <span class="material-icons md-48" style="color: var(--success);">verified_user</span>
                <h3>Secure Security Ledger</h3>
                <p>No reports currently flagged for coordinated spam or text similarity overlaps.</p>
            </div>
        `;
        return;
    }

    pending.forEach(f => {
        const rep = reports.find(r => r.id === f.report_id);
        const title = rep ? rep.title : 'Incident #' + f.report_id.substring(0, 8);
        grid.innerHTML += `
            <div class="flag-card glass-card">
                <div class="flag-header">
                    <div>
                        <h3>${title}</h3>
                        <p>Severity Score: ${f.severity}/3</p>
                    </div>
                    <span class="badge ${f.severity === 3 ? 'badge-danger' : 'badge-warning'}">${f.flag_type.toUpperCase()}</span>
                </div>
                <div class="flag-body">
                    <div class="flag-reason-box">
                        <strong>Alert Log:</strong> ${f.reason}
                    </div>
                    <p style="font-size: 11px; color: var(--slate);">Flagged: ${new Date(f.created_at).toLocaleString()}</p>
                </div>
                <div class="flag-actions">
                    <button class="btn btn-primary" onclick="resolveFlag('${f.id}', 'Confirmed')">Confirm</button>
                    <button class="btn btn-secondary" onclick="resolveFlag('${f.id}', 'Dismissed')">Dismiss</button>
                </div>
            </div>
        `;
    });
}

async function renderGrievanceTab(customReports) {
    let reports = customReports;
    if (!reports || reports.type === 'input' || reports.type === 'change') {
        // Triggered by search/filter inputs, fetch the latest list
        if (isBypassMode) {
            reports = mockReports;
        } else {
            if (!supabase) return;
            const { data } = await supabase.from('reports').select('*').order('created_at', { ascending: false });
            reports = data ?? [];
        }
    }

    const searchInput = document.getElementById('grievance-search').value.toLowerCase();
    const filterCat = document.getElementById('filter-category').value;
    const filterStat = document.getElementById('filter-status').value;

    const tbody = document.getElementById('tbody-all-grievances');
    tbody.innerHTML = '';

    const filtered = reports.filter(r => {
        const matchesSearch = r.title.toLowerCase().includes(searchInput) || 
                              r.description.toLowerCase().includes(searchInput) || 
                              r.id.toLowerCase().includes(searchInput);
        const matchesCat = filterCat === 'All' || r.category === filterCat;
        const matchesStat = filterStat === 'All' || r.status === filterStat;
        return matchesSearch && matchesCat && matchesStat;
    });

    if (filtered.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" class="text-center empty-state">No matching grievances found in secure ledger.</td></tr>';
        return;
    }

    filtered.forEach(r => {
        tbody.innerHTML += `
            <tr>
                <td><img src="${r.image_url}" class="table-thumbnail"></td>
                <td>
                    <div class="table-details">
                        <h4>${r.title}</h4>
                        <p>${r.description.substring(0, 60)}...</p>
                    </div>
                </td>
                <td><span class="badge badge-info">${r.category}</span></td>
                <td>${new Date(r.created_at).toLocaleDateString()}</td>
                <td><span class="badge ${getStatusClass(r.status)}">${r.status.toUpperCase()}</span></td>
                <td>
                    <button class="btn btn-secondary btn-small" onclick="openAuditDrawer('${r.id}')">Audit Ticket</button>
                </td>
            </tr>
        `;
    });
}

function renderPoliticiansTab(politicians) {
    const grid = document.getElementById('politicians-grid');
    grid.innerHTML = '';

    if (politicians.length === 0) {
        grid.innerHTML = '<div class="empty-state">No politicians synced.</div>';
        return;
    }

    politicians.forEach(p => {
        grid.innerHTML += `
            <div class="politician-card glass-card">
                <img src="${p.photo_url}" alt="${p.name}" class="leader-avatar-large">
                <h3>${p.name}</h3>
                <p>${p.position}</p>
                <p style="color: var(--primary); font-weight: bold; font-size: 12px; margin-top: 4px;">${p.party}</p>
                
                <div class="leader-stats-grid">
                    <div class="leader-stat-item">
                        <span class="leader-stat-num">${p.accountability_score}%</span>
                        <span class="leader-stat-lbl">Accountability</span>
                    </div>
                    <div class="leader-stat-item">
                        <span class="leader-stat-num">${p.resolved_reports}</span>
                        <span class="leader-stat-lbl">Resolved Tickets</span>
                    </div>
                </div>
                <button class="btn btn-outline btn-full btn-small" onclick="openScorecardDrawer('${p.id}')">Modify Scorecard</button>
            </div>
        `;
    });
}

function getStatusClass(status) {
    if (status === 'pending') return 'badge-warning';
    if (status === 'verified') return 'badge-info';
    if (status === 'inProgress') return 'badge-warning';
    return 'badge-success';
}

// ==========================================================================
// FLAGS MODERATION & USER SUSPENSIONS
// ==========================================================================

async function resolveFlag(flagId, action) {
    if (isBypassMode) {
        const index = mockFlags.indexWhere(f => f.id === flagId);
        if (index !== -1) {
            mockFlags[index].status = action;
        }
    } else {
        if (!supabase) return;
        try {
            await supabase.from('suspicious_activity_flags').update({ status: action }).eq('id', flagId);
        } catch (e) {
            console.error("Flag action error:", e);
        }
    }
    await hydrateData();
}

// ==========================================================================
// INTERACTIVE DRAWERS MODALS TOGGLE
// ==========================================================================

async function openAuditDrawer(reportId) {
    let report = null;
    if (isBypassMode) {
        report = mockReports.find(r => r.id === reportId);
    } else {
        if (!supabase) return;
        const { data } = await supabase.from('reports').select('*').eq('id', reportId).maybeSingle();
        report = data;
    }

    if (!report) return;

    // Hydrate form & details
    document.getElementById('audit-report-id').value = report.id;
    document.getElementById('audit-report-img').src = report.image_url;
    document.getElementById('audit-report-title').textContent = report.title;
    document.getElementById('audit-report-desc').textContent = report.description;
    document.getElementById('audit-report-cat').textContent = report.category;
    document.getElementById('audit-report-user').textContent = report.reporter_name;
    document.getElementById('audit-report-loc').textContent = report.location_name;
    document.getElementById('audit-report-date').textContent = new Date(report.created_at).toLocaleDateString();
    
    document.getElementById('audit-status').value = report.status;
    document.getElementById('audit-dept').value = report.department ?? '';
    document.getElementById('audit-note').value = '';

    // Ledger ticks
    document.getElementById('tick-gps').className = `material-icons ${report.gps_verified ? 'tick-green' : 'log-orange'}`;
    document.getElementById('tick-gps').textContent = report.gps_verified ? 'check_circle' : 'warning';
    
    document.getElementById('tick-exif').className = `material-icons ${report.exif_verified ? 'tick-green' : 'log-orange'}`;
    document.getElementById('tick-exif').textContent = report.exif_verified ? 'check_circle' : 'warning';

    document.getElementById('drawer-audit').classList.add('active');
}

async function handleAuditDispatch(e) {
    e.preventDefault();
    const reportId = document.getElementById('audit-report-id').value;
    const status = document.getElementById('audit-status').value;
    const department = document.getElementById('audit-dept').value.trim();
    const note = document.getElementById('audit-note').value.trim();

    if (isBypassMode) {
        const index = mockReports.indexWhere(r => r.id === reportId);
        if (index !== -1) {
            mockReports[index].status = status;
            mockReports[index].department = department;
        }
    } else {
        if (!supabase) return;
        try {
            await supabase.from('reports').update({ status, location_area: department }).eq('id', reportId);
            
            // Insert official comment note
            if (note.length > 0) {
                await supabase.from('comments').insert({
                    report_id: reportId,
                    author_name: document.getElementById('user-name').textContent + " (Moderator)",
                    author_badge: "Official",
                    text: `[${department.toUpperCase()}] ${note}`
                });
            }
        } catch (err) {
            console.error("Grievance audit update error:", err);
        }
    }

    closeDrawer('drawer-audit');
    await hydrateData();
}

async function openScorecardDrawer(politicianId) {
    let politician = null;
    if (isBypassMode) {
        politician = mockPoliticians.find(p => p.id === politicianId);
    } else {
        if (!supabase) return;
        const { data } = await supabase.from('politicians').select('*').eq('id', politicianId).maybeSingle();
        politician = data;
    }

    if (!politician) return;

    // Hydrate form
    document.getElementById('score-leader-id').value = politician.id;
    document.getElementById('score-leader-img').src = politician.photo_url;
    document.getElementById('score-leader-name').textContent = politician.name;
    document.getElementById('score-leader-pos').textContent = politician.position;

    document.getElementById('score-accountability').value = politician.accountability_score;
    document.getElementById('score-promises').value = politician.promises_kept_rate;
    document.getElementById('score-response').value = politician.response_rate;
    document.getElementById('score-total').value = politician.total_reports;
    document.getElementById('score-resolved').value = politician.resolved_reports;

    document.getElementById('drawer-politician').classList.add('active');
}

async function handleScorecardSave(e) {
    e.preventDefault();
    const id = document.getElementById('score-leader-id').value;
    const accountability_score = parseFloat(document.getElementById('score-accountability').value);
    const promises_kept_rate = parseFloat(document.getElementById('score-promises').value);
    const response_rate = parseFloat(document.getElementById('score-response').value);
    const total_reports = parseInt(document.getElementById('score-total').value);
    const resolved_reports = parseInt(document.getElementById('score-resolved').value);
    const open_reports = Math.max(0, total_reports - resolved_reports);

    if (isBypassMode) {
        const index = mockPoliticians.indexWhere(p => p.id === id);
        if (index !== -1) {
            mockPoliticians[index].accountability_score = accountability_score;
            mockPoliticians[index].promises_kept_rate = promises_kept_rate;
            mockPoliticians[index].response_rate = response_rate;
            mockPoliticians[index].total_reports = total_reports;
            mockPoliticians[index].resolved_reports = resolved_reports;
            mockPoliticians[index].open_reports = open_reports;
        }
    } else {
        if (!supabase) return;
        try {
            await supabase.from('politicians').update({
                accountability_score,
                promises_kept_rate,
                response_rate,
                total_reports,
                resolved_reports,
                open_reports
            }).eq('id', id);
        } catch (err) {
            console.error("Scorecard save error: ", err);
        }
    }

    closeDrawer('drawer-politician');
    await hydrateData();
}

function closeDrawer(drawerId) {
    document.getElementById(drawerId).classList.remove('active');
}

// Array compatibility polyfill for older browsers
if (!Array.prototype.indexWhere) {
    Array.prototype.indexWhere = function(predicate) {
        for (let i = 0; i < this.length; i++) {
            if (predicate(this[i])) return i;
        }
        return -1;
    };
}
