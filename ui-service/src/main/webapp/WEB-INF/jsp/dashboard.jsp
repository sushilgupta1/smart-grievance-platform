<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard | Smart Grievance Platform</title>
        <!-- Tailwind CSS -->
        <script src="https://cdn.tailwindcss.com"></script>
        <!-- Google Fonts: Plus Jakarta Sans -->
        <link
            href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap"
            rel="stylesheet">
        <!-- FontAwesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        fontFamily: {
                            sans: ['"Plus Jakarta Sans"', 'sans-serif'],
                        },
                        colors: {
                            dark: {
                                900: '#0f172a',
                                800: '#1e293b',
                                700: '#334155',
                            }
                        },
                        animation: {
                            'fade-in': 'fadeIn 0.3s ease-out forwards',
                        },
                        keyframes: {
                            fadeIn: {
                                '0%': { opacity: '0', transform: 'translateY(10px)' },
                                '100%': { opacity: '1', transform: 'translateY(0)' },
                            }
                        }
                    }
                }
            }
        </script>

        <style>
            body {
                background-color: #0f172a;
                color: #f8fafc;
            }

            .glass-panel {
                background: rgba(30, 41, 59, 0.7);
                backdrop-filter: blur(16px);
                -webkit-backdrop-filter: blur(16px);
                border: 1px solid rgba(255, 255, 255, 0.08);
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            }

            .input-field {
                background: rgba(15, 23, 42, 0.6);
                border: 1px solid rgba(255, 255, 255, 0.1);
                color: #f8fafc;
                transition: all 0.3s ease;
            }

            .input-field:focus {
                border-color: #3b82f6;
                box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.2);
                outline: none;
            }

            /* Custom Scrollbar */
            ::-webkit-scrollbar {
                width: 6px;
                height: 6px;
            }

            ::-webkit-scrollbar-track {
                background: #0f172a;
            }

            ::-webkit-scrollbar-thumb {
                background: #334155;
                border-radius: 4px;
            }

            ::-webkit-scrollbar-thumb:hover {
                background: #475569;
            }

            .status-badge {
                padding: 0.25rem 0.75rem;
                border-radius: 9999px;
                font-size: 0.75rem;
                font-weight: 700;
            }

            .status-open {
                background: rgba(59, 130, 246, 0.2);
                color: #60a5fa;
                border: 1px solid rgba(59, 130, 246, 0.3);
            }

            .status-inprogress {
                background: rgba(245, 158, 11, 0.2);
                color: #fbbf24;
                border: 1px solid rgba(245, 158, 11, 0.3);
            }

            .status-resolved {
                background: rgba(16, 185, 129, 0.2);
                color: #34d399;
                border: 1px solid rgba(16, 185, 129, 0.3);
            }

            /* Loader */
            .loader {
                border: 3px solid rgba(255, 255, 255, 0.1);
                border-left-color: #3b82f6;
                border-radius: 50%;
                width: 30px;
                height: 30px;
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }

                100% {
                    transform: rotate(360deg);
                }
            }
        </style>
    </head>

    <body class="h-screen flex overflow-hidden">

        <!-- Security Check Script (Runs Immediately) -->
        <script>
            const token = localStorage.getItem('token');
            if (!token) {
                window.location.href = '/login'; // Instantly redirect if unauthorized
            }

            // Decode JWT Payload safely
            function parseJwt(token) {
                try {
                    const base64Url = token.split('.')[1];
                    const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
                    const jsonPayload = decodeURIComponent(atob(base64).split('').map(function (c) {
                        return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
                    }).join(''));
                    return JSON.parse(jsonPayload);
                } catch (e) {
                    return null;
                }
            }

            const decoded = parseJwt(token);
            // If decoding failed or token is malformed, kick them out
            if (!decoded) {
                localStorage.removeItem('token');
                window.location.href = '/login';
            }

            const roles = decoded.roles || decoded.role || '';
            const isAdmin = roles.includes('ADMIN');
            const userEmail = decoded.sub || 'User';

        </script>

        <!-- Sidebar -->
        <aside class="w-64 glass-panel border-r border-slate-700/50 flex flex-col justify-between hidden md:flex z-50">
            <div>
                <div class="h-16 flex items-center px-6 border-b border-slate-700/50">
                    <i class="fa-solid fa-scale-balanced text-blue-500 text-xl mr-3"></i>
                    <span
                        class="font-bold text-lg tracking-tight bg-clip-text text-transparent bg-gradient-to-r from-white to-slate-400">SmartGrievance</span>
                </div>
                <div class="p-4 space-y-2" id="sidebarNav">
                    <!-- Nav links populated by JS -->
                </div>
            </div>
            <div class="p-4 border-t border-slate-700/50">
                <div class="flex items-center mb-4 px-2">
                    <div
                        class="w-8 h-8 rounded-full bg-gradient-to-tr from-blue-500 to-indigo-600 flex items-center justify-center text-sm font-bold shadow-lg shadow-blue-500/30">
                        <script>document.write(userEmail.charAt(0).toUpperCase())</script>
                    </div>
                    <div class="ml-3 overflow-hidden">
                        <p class="text-xs font-medium text-white truncate">
                            <script>document.write(userEmail)</script>
                        </p>
                        <p class="text-[10px] text-slate-400 font-bold uppercase tracking-wider" id="roleText"></p>
                    </div>
                </div>
                <button onclick="logout()"
                    class="w-full flex items-center justify-center px-4 py-2 text-sm text-red-400 hover:text-red-300 hover:bg-red-500/10 rounded-xl transition">
                    <i class="fa-solid fa-arrow-right-from-bracket mr-2"></i> Sign Out
                </button>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="flex-1 flex flex-col relative z-0 overflow-y-auto w-full">
            <!-- Mobile Header -->
            <header
                class="md:hidden glass-panel h-16 flex items-center justify-between px-4 sticky top-0 z-40 border-b border-slate-700/50">
                <div class="flex items-center">
                    <i class="fa-solid fa-scale-balanced text-blue-500 text-xl mr-3"></i>
                    <span class="font-bold">SmartGrievance</span>
                </div>
                <button onclick="logout()" class="text-sm text-red-400"><i class="fa-solid fa-power-off"></i></button>
            </header>

            <div class="flex-1 p-6 lg:p-10 max-w-7xl mx-auto w-full">

                <div class="mb-8 flex flex-col md:flex-row md:items-end justify-between">
                    <div>
                        <h1 class="text-3xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-white to-slate-300"
                            id="pageTitle">Dashboard</h1>
                        <p class="text-slate-400 mt-1 text-sm" id="pageSubtitle">Loading your workspace...</p>
                    </div>
                    <div id="headerActions" class="mt-4 md:mt-0">
                        <!-- Dynamic actions like "New Grievance" button -->
                    </div>
                </div>

                <!-- Custom Alerts -->
                <div id="alertBox"
                    class="hidden mb-6 p-4 rounded-xl flex items-center text-sm font-medium border transition-all duration-300 transform">
                    <i id="alertIcon" class="mr-3 text-lg"></i>
                    <span id="alertMessage"></span>
                    <button onclick="hideAlert()" class="ml-auto text-slate-400 hover:text-white"><i
                            class="fa-solid fa-xmark"></i></button>
                </div>

                <!-- Dynamic Workspace Content -->
                <div id="workspaceContent" class="animate-fade-in relative min-h-[300px]">
                    <div class="absolute inset-0 flex items-center justify-center">
                        <div class="loader"></div>
                    </div>
                </div>

            </div>
        </main>

        <!-- Modal for Admin Actions (Hidden by default) -->
        <div id="actionModal" class="fixed inset-0 z-50 hidden">
            <div class="absolute inset-0 bg-dark-900/80 backdrop-blur-sm" onclick="closeModal()"></div>
            <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-full max-w-md">
                <div class="glass-panel p-6 rounded-2xl shadow-2xl animate-fade-in">
                    <div class="flex justify-between items-center mb-4">
                        <h3 class="text-lg font-bold" id="modalTitle">Update Grievance</h3>
                        <button onclick="closeModal()" class="text-slate-400 hover:text-white"><i
                                class="fa-solid fa-xmark"></i></button>
                    </div>
                    <div id="modalBody">
                        <!-- Injected dynamically -->
                    </div>
                </div>
            </div>
        </div>


        <!-- Application Logic -->
        <script>
            const API_GATEWAY_URL = 'http://localhost:8085';

            // Initialize UI based on role
            document.getElementById('roleText').textContent = isAdmin ? 'Administrator' : 'User';

            function logout() {
                localStorage.removeItem('token');
                window.location.href = '/login';
            }

            // Render Sidebar
            const nav = document.getElementById('sidebarNav');
            if (isAdmin) {
                nav.innerHTML = `
                <a href="#" onclick="loadAdminView()" class="flex items-center px-4 py-3 bg-blue-500/10 text-blue-400 rounded-xl font-medium transition border border-blue-500/20">
                    <i class="fa-solid fa-layer-group w-5"></i> All Grievances
                </a>
            `;
            } else {
                nav.innerHTML = `
                <a href="#" onclick="loadUserView()" class="flex items-center px-4 py-3 bg-blue-500/10 text-blue-400 rounded-xl font-medium transition border border-blue-500/20">
                    <i class="fa-solid fa-clock-rotate-left w-5"></i> My Grievances
                </a>
                <a href="#" onclick="showNewGrievanceForm()" class="flex items-center px-4 py-3 text-slate-400 hover:text-white hover:bg-slate-800/50 rounded-xl font-medium transition cursor-pointer mt-1">
                    <i class="fa-solid fa-plus w-5"></i> File Grievance
                </a>
            `;
            }


            /* ================= ALERT SYSTEM ================= */
            function showAlert(type, message) {
                const box = document.getElementById('alertBox');
                const icon = document.getElementById('alertIcon');
                const msg = document.getElementById('alertMessage');
                box.classList.remove('hidden', 'bg-red-500/10', 'border-red-500/30', 'text-red-400', 'bg-emerald-500/10', 'border-emerald-500/30', 'text-emerald-400');

                if (type === 'error') {
                    box.classList.add('bg-red-500/10', 'border-red-500/30', 'text-red-400');
                    icon.className = 'fa-solid fa-circle-exclamation mr-3 text-lg';
                } else {
                    box.classList.add('bg-emerald-500/10', 'border-emerald-500/30', 'text-emerald-400');
                    icon.className = 'fa-solid fa-circle-check mr-3 text-lg';
                }
                msg.textContent = message;
            }

            function hideAlert() {
                document.getElementById('alertBox').classList.add('hidden');
            }


            /* ================= FETCH WRAPPER ================= */
            async function fetchWithAuth(url, options = {}) {
                const headers = { ...options.headers };
                headers['Authorization'] = `Bearer \${token}`;
                if (!headers['Content-Type'] && !(options.body instanceof FormData)) {
                    headers['Content-Type'] = 'application/json';
                }

                try {
                    const response = await fetch(url, { ...options, headers });
                    if (response.status === 401 || response.status === 403) {
                        logout(); // Auto-kick on invalid token
                        throw new Error("Session expired. Please log in again.");
                    }
                    return response;
                } catch (err) {
                    console.error("Fetch error:", err);
                    throw err;
                }
            }

            // Helper: Format Status Badge
            function getStatusBadge(status) {
                const s = (status || 'OPEN').toUpperCase();
                if (s === 'RESOLVED') return '<span class="status-badge status-resolved"><i class="fa-solid fa-check mr-1"></i> Resolved</span>';
                if (s === 'IN PROGRESS') return '<span class="status-badge status-inprogress"><i class="fa-solid fa-spinner fa-spin-pulse mr-1"></i> In Progress</span>';
                return '<span class="status-badge status-open"><i class="fa-solid fa-circle-dot mr-1"></i> Open</span>';
            }


            /* ================= USER LOGIC ================= */

            async function loadUserView() {
                document.getElementById('pageTitle').textContent = 'My Grievances';
                document.getElementById('pageSubtitle').textContent = 'Track and manage your submitted requests.';
                document.getElementById('headerActions').innerHTML = `
                <button onclick="showNewGrievanceForm()" class="bg-blue-600 hover:bg-blue-500 text-white px-5 py-2.5 rounded-xl font-medium shadow-lg shadow-blue-500/20 transition flex items-center">
                    <i class="fa-solid fa-plus mr-2"></i> New Grievance
                </button>
            `;

                renderLoader();
                try {
                    const res = await fetchWithAuth(`\${API_GATEWAY_URL}/grievance/my`);
                    if (!res.ok) throw new Error("Failed to load grievances.");
                    const data = await res.json();
                    renderGrievanceGrid(data, false);
                } catch (err) {
                    showAlert('error', err.message);
                    document.getElementById('workspaceContent').innerHTML = '<div class="text-center text-slate-500 py-10">Failed to load data.</div>';
                }
            }

            function showNewGrievanceForm() {
                hideAlert();
                document.getElementById('pageTitle').textContent = 'File a Grievance';
                document.getElementById('pageSubtitle').textContent = 'Submit a new issue to the administration.';
                document.getElementById('headerActions').innerHTML = `
                <button onclick="loadUserView()" class="glass-panel text-slate-300 hover:text-white px-5 py-2.5 rounded-xl font-medium transition flex items-center">
                    <i class="fa-solid fa-arrow-left mr-2"></i> Back to List
                </button>
            `;

                const formHtml = `
                <div class="glass-panel p-6 md:p-8 rounded-3xl max-w-3xl animate-fade-in shadow-xl mx-auto">
                    <form onsubmit="event.preventDefault(); submitGrievance();" class="space-y-6">
                        <div>
                            <label class="block text-sm font-medium text-slate-300 mb-2">Issue Title</label>
                            <input type="text" id="gTitle" required class="input-field w-full px-4 py-3 rounded-xl text-sm" placeholder="Brief summary of the issue">
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-slate-300 mb-2">Detailed Description</label>
                            <textarea id="gDesc" required rows="6" class="input-field w-full px-4 py-3 rounded-xl text-sm" placeholder="Provide all necessary details here..."></textarea>
                        </div>
                        <div class="flex justify-end pt-2">
                            <button type="submit" id="submitBtn" class="bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 text-white px-8 py-3 rounded-xl font-bold shadow-lg shadow-blue-500/25 transition">
                                Submit Grievance
                            </button>
                        </div>
                    </form>
                </div>
            `;
                document.getElementById('workspaceContent').innerHTML = formHtml;
            }

            async function submitGrievance() {
                const title = document.getElementById('gTitle').value.trim();
                const description = document.getElementById('gDesc').value.trim();
                const btn = document.getElementById('submitBtn');

                if (!title || !description) return;

                btn.disabled = true;
                btn.innerHTML = '<i class="fa-solid fa-circle-notch fa-spin mr-2"></i> Submitting...';

                try {
                    const res = await fetchWithAuth(`\${API_GATEWAY_URL}/grievance`, {
                        method: 'POST',
                        body: JSON.stringify({ title, description, status: "OPEN" })
                    });

                    if (!res.ok) throw new Error("Failed to submit.");

                    showAlert('success', 'Grievance submitted successfully!');
                    setTimeout(() => loadUserView(), 1500);
                } catch (err) {
                    showAlert('error', err.message);
                    btn.disabled = false;
                    btn.innerHTML = 'Submit Grievance';
                }
            }


            /* ================= ADMIN LOGIC ================= */

            async function loadAdminView() {
                document.getElementById('pageTitle').textContent = 'Global Grievances';
                document.getElementById('pageSubtitle').textContent = 'Manage, assign, and resolve user issues.';
                document.getElementById('headerActions').innerHTML = `
                <div class="glass-panel px-4 py-2 rounded-xl text-sm text-slate-300 flex items-center shadow-inner">
                    <i class="fa-solid fa-shield-halved text-blue-500 mr-2"></i> Admin Privileges Active
                </div>
            `;

                renderLoader();
                try {
                    const res = await fetchWithAuth(`\${API_GATEWAY_URL}/grievance/all`);
                    if (!res.ok) throw new Error("Failed to load global grievances.");
                    const data = await res.json();
                    renderGrievanceGrid(data, true);
                } catch (err) {
                    showAlert('error', err.message);
                    document.getElementById('workspaceContent').innerHTML = '<div class="text-center text-slate-500 py-10">Failed to load data. Ensure Admin roles are valid.</div>';
                }
            }


            /* ================= SHARED RENDERING LOGIC ================= */

            function renderLoader() {
                document.getElementById('workspaceContent').innerHTML = `
                <div class="h-64 flex flex-col items-center justify-center text-slate-500">
                    <div class="loader mb-4"></div>
                    <p class="text-sm">Loading data...</p>
                </div>
            `;
            }

            function renderGrievanceGrid(grievances, isAdminView) {
                if (!grievances || grievances.length === 0) {
                    document.getElementById('workspaceContent').innerHTML = `
                    <div class="glass-panel p-10 rounded-3xl text-center shadow-lg border-dashed">
                        <div class="w-16 h-16 bg-slate-800 rounded-full flex items-center justify-center mx-auto mb-4 text-slate-500 text-2xl">
                            <i class="fa-solid fa-inbox"></i>
                        </div>
                        <h3 class="text-white font-bold mb-1">No Grievances Found</h3>
                        <p class="text-slate-400 text-sm">Everything looks clean and quiet here.</p>
                    </div>
                `;
                    return;
                }

                // Sort by ID descending (newest first realistically)
                grievances.sort((a, b) => b.id - a.id);

                let html = '<div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6 animate-fade-in pb-10">';

                grievances.forEach(g => {
                    const isAssigned = !!g.assignedTo;
                    const assignedText = isAssigned ? g.assignedTo : '<span class="text-slate-500 italic">Unassigned</span>';

                    // Admin Actions Dropdown
                    let adminActionsHtml = '';
                    if (isAdminView) {
                        adminActionsHtml = `
                        <div class="mt-4 pt-4 border-t border-slate-700/50 flex space-x-2">
                            <button onclick="openAssignModal(\${g.id})" class="flex-1 bg-slate-800 hover:bg-slate-700 text-slate-300 py-2 rounded-lg text-xs font-bold transition border border-slate-700">
                                <i class="fa-solid fa-user-plus mr-1"></i> Assign
                            </button>
                            <button onclick="openStatusModal(\${g.id}, '\${g.status}')" class="flex-1 bg-blue-600/20 hover:bg-blue-600/30 text-blue-400 py-2 rounded-lg text-xs font-bold transition border border-blue-500/30">
                                <i class="fa-regular fa-pen-to-square mr-1"></i> Update
                            </button>
                        </div>
                    `;
                    }

                    html += `
                    <div class="glass-panel p-5 rounded-2xl flex flex-col">
                        <div class="flex justify-between items-start mb-3">
                            <span class="text-xs font-bold text-slate-500 bg-slate-900/50 px-2 py-1 rounded">#\${g.id}</span>
                            \${getStatusBadge(g.status)}
                        </div>
                        <h4 class="font-bold text-white mb-2 leading-tight">\${escapeHtml(g.title)}</h4>
                        <p class="text-sm text-slate-400 mb-4 line-clamp-3 flex-1">\${escapeHtml(g.description)}</p>
                        
                        <div class="space-y-2 text-xs text-slate-400 bg-slate-900/40 p-3 rounded-xl border border-white/5">
                            <div class="flex justify-between">
                                <span><i class="fa-regular fa-user mr-1.5 text-slate-500"></i> From:</span>
                                <span class="text-slate-300 truncate ml-2" title="\${g.userEmail || 'System'}">\${g.userEmail || 'System'}</span>
                            </div>
                            <div class="flex justify-between">
                                <span><i class="fa-solid fa-user-shield mr-1.5 text-slate-500"></i> Assigned:</span>
                                <span class="text-slate-300 truncate ml-2">\${assignedText}</span>
                            </div>
                        </div>

                        \${g.remarks ? (
                            '<div class="mt-3 text-xs bg-indigo-500/10 border border-indigo-500/20 text-indigo-200 p-2.5 rounded-lg flex items-start">' +
                                '<i class="fa-solid fa-comment-dots mt-0.5 mr-2 text-indigo-400"></i>' +
                                '<span>' + escapeHtml(g.remarks) + '</span>' +
                            '</div>'
                        ) : ''}

                        \${adminActionsHtml}
                    </div>
                `;
                });
                html += '</div>';

                document.getElementById('workspaceContent').innerHTML = html;
            }

            // Simple HTML Escaper
            function escapeHtml(unsafe) {
                if (!unsafe) return '';
                return unsafe
                    .replace(/&/g, "&amp;")
                    .replace(/</g, "&lt;")
                    .replace(/>/g, "&gt;")
                    .replace(/"/g, "&quot;")
                    .replace(/'/g, "&#039;");
            }


            /* ================= MODAL LOGIC (ADMIN) ================= */
            const modal = document.getElementById('actionModal');
            const modalTitle = document.getElementById('modalTitle');
            const modalBody = document.getElementById('modalBody');

            function closeModal() {
                modal.classList.add('hidden');
            }

            function openAssignModal(id) {
                modalTitle.textContent = `Assign Grievance #\${id}`;
                modalBody.innerHTML = `
                <div class="space-y-4">
                    <p class="text-sm text-slate-400 mb-2">Assign this grievance to an administrator. It defaults to yourself.</p>
                    <input type="email" id="assignTarget" value="\${userEmail}" class="input-field w-full px-4 py-3 rounded-xl text-sm" placeholder="admin@example.com">
                    <div class="flex justify-end gap-3 mt-4">
                        <button onclick="closeModal()" class="px-4 py-2 rounded-xl text-slate-400 hover:text-white transition text-sm font-medium">Cancel</button>
                        <button onclick="submitAssign(\${id})" class="bg-blue-600 hover:bg-blue-500 text-white px-5 py-2 rounded-xl font-bold shadow-lg shadow-blue-500/30 transition text-sm">Confirm Assign</button>
                    </div>
                </div>
            `;
                modal.classList.remove('hidden');
            }

            async function submitAssign(id) {
                const adminEmail = document.getElementById('assignTarget').value.trim();
                if (!adminEmail) return;

                try {
                    // PUT /grievance/assign/{id}?admin={adminEmail}
                    const res = await fetchWithAuth(`\${API_GATEWAY_URL}/grievance/assign/\${id}?admin=\${encodeURIComponent(adminEmail)}`, {
                        method: 'PUT'
                    });
                    if (!res.ok) throw new Error("Failed to assign");
                    closeModal();
                    loadAdminView();
                } catch (err) {
                    alert(err.message);
                }
            }

            function openStatusModal(id, currentStatus) {
                currentStatus = currentStatus || 'OPEN';
                modalTitle.textContent = `Update Status #\${id}`;
                modalBody.innerHTML = `
                <div class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-slate-300 mb-1.5">New Status</label>
                        <select id="newStatus" class="input-field w-full px-4 py-3 rounded-xl text-sm appearance-none">
                            <option value="OPEN" \${currentStatus === 'OPEN' ? 'selected' : ''}>Open</option>
                            <option value="IN PROGRESS" \${currentStatus === 'IN PROGRESS' ? 'selected' : ''}>In Progress</option>
                            <option value="RESOLVED" \${currentStatus === 'RESOLVED' ? 'selected' : ''}>Resolved</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-slate-300 mb-1.5">Admin Remarks</label>
                        <textarea id="adminRemarks" rows="3" class="input-field w-full px-4 py-3 rounded-xl text-sm" placeholder="Add resolution details or public notes here..."></textarea>
                    </div>
                    <div class="flex justify-end gap-3 mt-4">
                        <button onclick="closeModal()" class="px-4 py-2 rounded-xl text-slate-400 hover:text-white transition text-sm font-medium">Cancel</button>
                        <button onclick="submitStatus(\${id})" class="bg-blue-600 hover:bg-blue-500 text-white px-5 py-2 rounded-xl font-bold shadow-lg shadow-blue-500/30 transition text-sm">Save Update</button>
                    </div>
                </div>
            `;
                modal.classList.remove('hidden');
            }

            async function submitStatus(id) {
                const status = document.getElementById('newStatus').value;
                const remarks = document.getElementById('adminRemarks').value.trim();

                try {
                    // PUT /grievance/status/{id}?status={status}&remarks={remarks}
                    const res = await fetchWithAuth(`\${API_GATEWAY_URL}/grievance/status/\${id}?status=\${encodeURIComponent(status)}&remarks=\${encodeURIComponent(remarks)}`, {
                        method: 'PUT'
                    });
                    if (!res.ok) throw new Error("Failed to update status");
                    closeModal();
                    loadAdminView();
                } catch (err) {
                    alert(err.message);
                }
            }


            // INITIALIZATION KICK-OFF
            if (isAdmin) {
                loadAdminView();
            } else {
                loadUserView();
            }

        </script>
    </body>

    </html>