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
        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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
            const isAdmin = roles.includes('ADMIN') || roles.includes('SUPERADMIN');
            const isOfficer = roles.includes('OFFICER');
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

                <!-- Admin Real-Time Analytics Dashboard -->
                <div id="analyticsBoard" class="hidden mb-6 animate-fade-in">
                    <!-- KPI Row -->
                    <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-4">
                        <div class="glass-panel p-4 rounded-xl border border-blue-500/20 shadow-lg shadow-blue-500/5 relative overflow-hidden">
                            <div class="absolute top-0 right-0 p-4 opacity-10"><i class="fa-solid fa-layer-group text-4xl text-blue-500"></i></div>
                            <p class="text-[10px] font-bold text-slate-400 uppercase tracking-widest mb-1">Total Volume</p>
                            <h2 class="text-3xl font-black text-white" id="kpiTotal">0</h2>
                        </div>
                        <div class="glass-panel p-4 rounded-xl border border-emerald-500/20 shadow-lg shadow-emerald-500/5 relative overflow-hidden">
                            <div class="absolute top-0 right-0 p-4 opacity-10"><i class="fa-solid fa-check text-4xl text-emerald-500"></i></div>
                            <p class="text-[10px] font-bold text-slate-400 uppercase tracking-widest mb-1">Resolved</p>
                            <h2 class="text-3xl font-black text-emerald-400" id="kpiResolved">0</h2>
                        </div>
                        <div class="glass-panel p-4 rounded-xl border border-fuchsia-500/20 shadow-lg shadow-fuchsia-500/5 relative overflow-hidden">
                            <div class="absolute top-0 right-0 p-4 opacity-10"><i class="fa-solid fa-rotate-left text-4xl text-fuchsia-500"></i></div>
                            <p class="text-[10px] font-bold text-slate-400 uppercase tracking-widest mb-1">Disputed</p>
                            <h2 class="text-3xl font-black text-fuchsia-400" id="kpiDisputed">0</h2>
                        </div>
                        <div class="glass-panel p-4 rounded-xl border border-red-500/20 shadow-lg shadow-red-500/10 relative overflow-hidden group">
                            <div class="absolute top-0 right-0 p-4 opacity-10 transition-transform group-hover:scale-110"><i class="fa-solid fa-skull-crossbones text-4xl text-red-500"></i></div>
                            <p class="text-[10px] font-bold text-slate-400 uppercase tracking-widest mb-1">SLA Breaches</p>
                            <h2 class="text-3xl font-black text-red-500 animate-pulse" id="kpiBreached">0</h2>
                        </div>
                    </div>
                    <!-- Chart Row -->
                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
                        <div class="glass-panel p-4 rounded-xl border border-slate-700/50 relative">
                            <h4 class="text-[10px] font-bold text-slate-400 uppercase tracking-widest mb-3 absolute top-4 left-4"><i class="fa-solid fa-chart-pie text-blue-400 mr-2"></i>Status Distribution</h4>
                            <div class="h-48 w-full flex justify-center mt-6"><canvas id="statusChart"></canvas></div>
                        </div>
                        <div class="glass-panel p-4 rounded-xl border border-slate-700/50 relative">
                            <h4 class="text-[10px] font-bold text-slate-400 uppercase tracking-widest mb-3 absolute top-4 left-4"><i class="fa-solid fa-chart-bar text-indigo-400 mr-2"></i>Department Workload</h4>
                            <div class="h-48 w-full mt-6"><canvas id="categoryChart"></canvas></div>
                        </div>
                    </div>
                </div>

                <!-- The Real-Time Filter Console (Phase 6) -->
                <div id="filterConsole" class="hidden glass-panel p-4 rounded-xl mb-6 shadow-md border border-slate-700/50 bg-slate-800/20">
                    <div class="flex flex-col md:flex-row gap-4 items-center">
                        <div class="text-xs font-bold text-slate-400 uppercase tracking-widest w-full md:w-auto"><i class="fa-solid fa-filter mr-1"></i> Filter Grid:</div>
                        <select id="filterStatus" onchange="applyFilters()" class="input-field px-4 py-2 rounded-lg text-sm flex-1 w-full outline-none border border-slate-700">
                            <option value="ALL">All Statuses</option>
                            <option value="OPEN">Open Only</option>
                            <option value="IN PROGRESS">In Progress</option>
                            <option value="RESOLVED">Resolved</option>
                            <option value="REOPENED">Disputed / Re-Opened</option>
                            <option value="ESCALATED_SLA_BREACH">SLA Breach (Escalated)</option>
                        </select>
                        <select id="filterCategory" onchange="applyFilters()" class="input-field px-4 py-2 rounded-lg text-sm flex-1 w-full outline-none border border-slate-700">
                            <option value="ALL">All Categories</option>
                            <option value="Water">Water</option>
                            <option value="Electricity">Electricity</option>
                            <option value="Roads">Roads</option>
                            <option value="Sanitation">Sanitation</option>
                            <option value="Public Safety">Public Safety</option>
                            <option value="Other">Other</option>
                        </select>
                        <select id="filterPriority" onchange="applyFilters()" class="input-field px-4 py-2 rounded-lg text-sm flex-1 w-full outline-none border border-slate-700">
                            <option value="ALL">All Priorities</option>
                            <option value="HIGH">High (Lvl 8-10)</option>
                            <option value="MED">Medium (Lvl 5-7)</option>
                            <option value="LOW">Low (Lvl 1-4)</option>
                        </select>
                    </div>
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

        <!-- Reassignment Reason Modal -->
        <div id="reassignModal" class="fixed inset-0 z-[60] hidden">
            <div class="absolute inset-0 bg-dark-900/90 backdrop-blur-md" onclick="closeReassignModal()"></div>
            <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-full max-w-sm">
                <div class="glass-panel p-6 rounded-2xl shadow-2xl border border-orange-500/30 animate-fade-in relative overflow-hidden">
                    <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-orange-500 to-red-500"></div>
                    <h3 class="text-lg font-bold text-white mb-2"><i class="fa-solid fa-person-walking-arrow-right text-orange-400 mr-2"></i> Release Ticket</h3>
                    <p class="text-xs text-slate-400 mb-4">Please specify a mandatory reason why you cannot complete this assigned ticket.</p>
                    
                    <textarea id="reassignReasonTxt" rows="3" class="input-field w-full px-4 py-3 rounded-xl text-sm border-orange-500/20 focus:border-orange-500 mb-4" placeholder="E.g., Require advanced technical team, Currently on leave, Not my jurisdiction..."></textarea>
                    
                    <div class="flex justify-end gap-3">
                        <button onclick="closeReassignModal()" class="px-4 py-2 text-sm text-slate-400 hover:text-white transition">Cancel</button>
                        <button id="confirmReassignBtn" class="bg-gradient-to-r from-orange-600 to-red-600 hover:from-orange-500 hover:to-red-500 text-white px-5 py-2 rounded-xl font-bold text-sm shadow-lg shadow-orange-500/20 transition">Submit Request</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Citizen Dispute Modal -->
        <div id="disputeModal" class="fixed inset-0 z-[60] hidden">
            <div class="absolute inset-0 bg-dark-900/90 backdrop-blur-md" onclick="closeDisputeModal()"></div>
            <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-full max-w-sm">
                <div class="glass-panel p-6 rounded-2xl shadow-2xl border border-fuchsia-500/30 animate-fade-in relative overflow-hidden">
                    <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-fuchsia-500 to-purple-600"></div>
                    <h3 class="text-lg font-bold text-white mb-2"><i class="fa-solid fa-triangle-exclamation text-fuchsia-400 mr-2"></i> Dispute Resolution</h3>
                    <p class="text-xs text-slate-400 mb-4">Please specify exactly why you are unsatisfied with the resolution. This will immediately alert the administration.</p>
                    
                    <textarea id="disputeReasonTxt" rows="3" class="input-field w-full px-4 py-3 rounded-xl text-sm border-fuchsia-500/20 focus:border-fuchsia-500 mb-4" placeholder="E.g., The pothole was only partially filled..."></textarea>
                    
                    <div class="flex justify-end gap-3">
                        <button onclick="closeDisputeModal()" class="px-4 py-2 text-sm text-slate-400 hover:text-white transition">Cancel</button>
                        <button id="confirmDisputeBtn" class="bg-gradient-to-r from-fuchsia-600 to-purple-600 hover:from-fuchsia-500 hover:to-purple-500 text-white px-5 py-2 rounded-xl font-bold text-sm shadow-lg shadow-fuchsia-500/20 transition">Open Dispute</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Fullscreen Image Lightbox -->
        <div id="imageLightbox" class="fixed inset-0 z-[100] hidden flex items-center justify-center p-4">
            <div class="absolute inset-0 bg-black/95 backdrop-blur-lg" onclick="closeLightbox()"></div>
            <button onclick="closeLightbox()" class="absolute top-6 right-8 text-white/50 hover:text-white text-4xl transition z-10"><i class="fa-solid fa-xmark"></i></button>
            <img id="lightboxImg" src="" class="max-w-full max-h-[90vh] object-contain relative z-10 rounded-lg shadow-2xl border border-slate-700/50 animate-fade-in" />
        </div>

        <!-- Application Logic -->
        <script>
            const API_GATEWAY_URL = 'http://localhost:8085';
            let currentBase64Image = "";

            // Initialize UI based on role
            let displayRole = 'User';
            if(isAdmin) displayRole = 'Administrator';
            else if(isOfficer) displayRole = 'Field Officer';
            
            document.getElementById('roleText').textContent = displayRole;
            // Base64 Image Encoder
            
            let allGrievancesArray = []; // Used for ultra-fast UI filtering
            
            function applyFilters() {
                if(!allGrievancesArray) return;
                const status = document.getElementById('filterStatus').value;
                const category = document.getElementById('filterCategory').value;
                const priority = document.getElementById('filterPriority').value;
                
                let filtered = allGrievancesArray.filter(g => {
                    let matchStatus = status === 'ALL' || (g.status && g.status.toUpperCase() === status);
                    let matchCategory = category === 'ALL' || (g.category && g.category.toUpperCase() === category.toUpperCase());
                    
                    let matchPriority = true;
                    const p = g.priorityScore || 1;
                    if(priority === 'HIGH') matchPriority = p >= 8;
                    else if(priority === 'MED') matchPriority = (p >= 5 && p < 8);
                    else if(priority === 'LOW') matchPriority = p < 5;
                    
                    return matchStatus && matchCategory && matchPriority;
                });
                renderGrievanceGrid(filtered, isAdmin || isOfficer);
            }
            function handleImageUpload(event) {
                const file = event.target.files[0];
                if (file) {
                    // Safety Guard: Stop them from uploading a 20MB 4K photo which would lag the database!
                    if (file.size > 2 * 1024 * 1024) { 
                        showAlert('error', 'Image is too large. Please select an image under 2MB.');
                        event.target.value = ""; // Clear the input
                        currentBase64Image = "";
                        return;
                    }

                    const reader = new FileReader();
                    reader.onloadend = function() {
                        currentBase64Image = reader.result; // This converts the image to the giant text string!
                        showAlert('success', 'Image attached and encoded successfully!');
                    };
                    reader.readAsDataURL(file);
                } else {
                    currentBase64Image = "";
                }
            }

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
                <a href="#" onclick="showOfficerForm()" class="flex items-center px-4 py-3 text-emerald-400 hover:text-emerald-300 hover:bg-emerald-500/10 rounded-xl font-medium transition cursor-pointer mt-1">
                    <i class="fa-solid fa-user-plus w-5"></i> Promote Officer
                </a>
            `;
            } else if (isOfficer) {
                nav.innerHTML = `
                <a href="#" onclick="loadOfficerView()" class="flex items-center px-4 py-3 bg-indigo-500/10 text-indigo-400 rounded-xl font-medium transition border border-indigo-500/20">
                    <i class="fa-solid fa-briefcase w-5"></i> My Assignments
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
                if (s === 'ESCALATED_SLA_BREACH' || s === 'ESCALATES_SLA_BREACH') return '<span class="status-badge bg-red-500/20 text-red-500 border border-red-500/50 shadow-[0_0_15px_rgba(239,68,68,0.5)] px-3 animate-pulse"><i class="fa-solid fa-skull-crossbones mr-1"></i> SLA Breach: Escalated</span>';
                if (s === 'REOPENED') return '<span class="status-badge bg-fuchsia-500/20 text-fuchsia-400 border border-fuchsia-500/30 shadow-lg shadow-fuchsia-500/20 px-3"><i class="fa-solid fa-rotate-left mr-1"></i> Disputed / Re-Opened</span>';
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
                document.getElementById('filterConsole').classList.remove('hidden');
                document.getElementById('analyticsBoard').classList.add('hidden');
                
                try {
                    const res = await fetchWithAuth(`\${API_GATEWAY_URL}/grievance/my`);
                    if (!res.ok) throw new Error("Failed to load grievances.");
                    allGrievancesArray = await res.json();
                    applyFilters();
                } catch (err) {
                    showAlert('error', err.message);
                    document.getElementById('workspaceContent').innerHTML = '<div class="text-center text-slate-500 py-10">Failed to load data.</div>';
                }
            }

            function showNewGrievanceForm() {
                hideAlert();
                document.getElementById('filterConsole').classList.add('hidden');
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
                        <!-- GPS Location Builder -->
                        <div>
                            <label class="block text-sm font-medium text-slate-300 mb-2">Issue Location (GPS)</label>
                            <div class="flex gap-2">
                                <input type="text" id="gLocation" class="input-field w-full px-4 py-3 rounded-xl text-sm" placeholder="Click the button to fetch coordinates ->">
                                <button type="button" onclick="fetchGPS()" class="bg-slate-700 hover:bg-slate-600 text-slate-300 px-4 py-3 rounded-xl transition flex items-center justify-center shadow-inner" title="Get Current Location">
                                    <i class="fa-solid fa-location-crosshairs"></i>
                                </button>
                            </div>
                        </div>

                        <!-- Photo/Proof Attachment -->
                        <div>
                        <label class="block text-sm font-medium text-slate-300 mb-2">Upload Photo Proof</label>
                        <input type="file" id="gPhoto" accept="image/*" onchange="handleImageUpload(event)" class="input-field w-full px-4 py-3 rounded-xl text-sm file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-500/20 file:text-blue-400 hover:file:bg-blue-500/30">
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
                const locationCoordinates = document.getElementById('gLocation').value.trim();

                if (!title || !description) return;

                btn.disabled = true;
                btn.innerHTML = '<i class="fa-solid fa-circle-notch fa-spin mr-2"></i> Submitting...';

                try {
                    const res = await fetchWithAuth(`\${API_GATEWAY_URL}/grievance`, {
                        method: 'POST',
                        body: JSON.stringify({ 
                            title: title, 
                            description: description, 
                            status: "OPEN",
                            locationCoordinates: locationCoordinates,
                            attachmentUrl: currentBase64Image
                        })
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
                document.getElementById('filterConsole').classList.remove('hidden');
                document.getElementById('analyticsBoard').classList.remove('hidden');

                renderLoader();
                try {
                    const res = await fetchWithAuth(`\${API_GATEWAY_URL}/grievance/all`);
                    if (!res.ok) throw new Error("Failed to load global grievances.");
                    allGrievancesArray = await res.json();
                    applyFilters();
                    
                    // Trigger Mayor Analytics
                    setTimeout(() => renderAnalytics(allGrievancesArray), 100);
                } catch (err) {
                    showAlert('error', err.message);
                    document.getElementById('workspaceContent').innerHTML = '<div class="text-center text-slate-500 py-10">Failed to load data. Ensure Admin roles are valid.</div>';
                }
            }

            async function loadOfficerView() {
                document.getElementById('pageTitle').textContent = 'My Assignments';
                document.getElementById('pageSubtitle').textContent = 'Grievances dynamically dispatched to you by the AI Router.';
                document.getElementById('headerActions').innerHTML = `
                <div class="glass-panel px-4 py-2 rounded-xl text-sm text-indigo-300 flex items-center shadow-inner border-indigo-500/20">
                    <i class="fa-solid fa-user-tie text-indigo-400 mr-2"></i> Official Field Agent
                </div>
            `;
                document.getElementById('filterConsole').classList.remove('hidden');
                document.getElementById('analyticsBoard').classList.add('hidden');

                renderLoader();
                try {
                    const res = await fetchWithAuth(`\${API_GATEWAY_URL}/grievance/assigned`);
                    if (!res.ok) throw new Error("Failed to load assignments.");
                    allGrievancesArray = await res.json();
                    applyFilters();
                } catch (err) {
                    showAlert('error', err.message);
                    document.getElementById('workspaceContent').innerHTML = '<div class="text-center text-slate-500 py-10">Failed to load task list.</div>';
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
                        <div class="w-16 h-16 bg-slate-800 rounded-full flex items-center justify-center mx-auto mb-4 text-slate-500 text-2xl"><i class="fa-solid fa-inbox"></i></div>
                        <h3 class="text-white font-bold mb-1">No Grievances Found</h3>
                        <p class="text-slate-400 text-sm">Everything looks clean and quiet here.</p>
                    </div>`;
                    return;
                }

                grievances.sort((a, b) => b.id - a.id);
                let html = '<div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6 animate-fade-in pb-10">';

                grievances.forEach(g => {
                    const isAssigned = !!g.assignedTo;
                    const assignedText = isAssigned ? g.assignedTo : '<span class="text-slate-500 italic">Unassigned</span>';

                    // === AI DYNAMIC COLOR BADGE LOGIC ===
                    let priorityHtml = '';
                    if (g.priorityScore) {
                        let pColor = "bg-emerald-500/20 text-emerald-400 border-emerald-500/30";
                        if (g.priorityScore >= 8) pColor = "bg-red-500/20 text-red-400 border-red-500/50 shadow-lg shadow-red-500/20";
                        else if (g.priorityScore >= 5) pColor = "bg-yellow-500/20 text-yellow-400 border-yellow-500/30";
                        
                        priorityHtml = `<span class="px-2 py-1 rounded text-[10px] uppercase tracking-wider font-extrabold border \${pColor} transition-transform hover:scale-105">Lvl \${g.priorityScore} Prio</span>`;
                    }

                    // Notice how we removed the clunky Assign/Resolve buttons and made the entire card clickable!
                    html += `
                    <div onclick='openDetailsModal(\${JSON.stringify(g).replace(/'/g, "&#39;")})' class="glass-panel p-5 rounded-2xl flex flex-col cursor-pointer hover:border-blue-500/50 hover:shadow-lg hover:shadow-blue-500/10 transition-all duration-300 group relative">
                        <!-- Floating Badges Top Right -->
                        <div class="absolute -top-3 right-4 flex space-x-2 shadow-lg shadow-dark-900 border border-slate-700/50 rounded bg-dark-900 z-10">
                           \${priorityHtml}
                           \${g.category ? `<span class="px-2 py-1 rounded text-[10px] uppercase tracking-wider font-bold bg-indigo-500/20 text-indigo-400 border border-indigo-500/30">\${escapeHtml(g.category)}</span>` : ''}
                        </div>

                        <div class="flex justify-between items-start mb-3 pt-2">
                            <span class="text-xs font-bold text-slate-500 bg-slate-900/50 px-2 py-1 rounded">#\${g.id}</span>
                            \${getStatusBadge(g.status)}
                        </div>
                        <h4 class="font-bold text-white mb-2 leading-tight group-hover:text-blue-400 transition">\${escapeHtml(g.title)}</h4>
                        <p class="text-sm text-slate-400 mb-4 line-clamp-3 flex-1">\${escapeHtml(g.description)}</p>
                        
                        <div class="space-y-2 text-xs text-slate-400 bg-slate-900/40 p-3 rounded-xl border border-white/5">
                            <div class="flex justify-between">
                                <span><i class="fa-solid fa-user-shield mr-1.5 text-slate-500"></i> Assigned:</span>
                                <span class="text-slate-300 truncate ml-2">\${assignedText}</span>
                            </div>
                        </div>
                    </div>`;
                });
                document.getElementById('workspaceContent').innerHTML = html + '</div>';
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

            // 🚨 NEW UNIFIED MASTER MODAL
            function openDetailsModal(grievanceJson) {
                const g = typeof grievanceJson === 'string' ? JSON.parse(grievanceJson) : grievanceJson;
                currentBase64Image = "";

                document.getElementById('modalTitle').innerHTML = `
                    <div class="flex items-center gap-3">
                        Grievance #\${g.id} 
                        \${getStatusBadge(g.status)}
                        <span class="text-sm font-normal text-slate-400">\${g.category ? escapeHtml(g.category) : 'Uncategorized'}</span>
                    </div>
                `;

                const photoHtml = g.attachmentUrl ? `
                    <div class="mb-4">
                        <label class="block text-[10px] font-bold text-slate-400 mb-1 uppercase tracking-widest text-center">Citizen Uploaded Proof</label>
                        <div onclick="openLightbox('\${g.attachmentUrl}')" class="h-48 w-full rounded-xl bg-cover bg-center border border-slate-700 shadow-inner cursor-pointer hover:opacity-80 transition" style="background-image: url('\${g.attachmentUrl}')" title="Click to expand"></div>
                    </div>` : `<div class="mb-4 text-xs font-semibold text-slate-500 bg-slate-800/50 p-3 rounded-lg border border-slate-700 border-dashed text-center"><i class="fa-solid fa-image-slash mb-1 text-lg"></i><br/>No Photo Attached</div>`;

                // If user is Admin or Officer, they get the Action tools at the bottom!
                let actionControlsHtml = '';
                if (isAdmin || isOfficer) {
                    let assignBlock = isAdmin ? `
                            <div>
                                <label class="block text-xs font-medium text-slate-400 mb-1">Assign Officer Email</label>
                                <div class="flex">
                                    <input type="email" id="assignTarget" value="\${g.assignedTo || userEmail}" class="input-field w-full px-3 py-2 rounded-l-lg text-[10px]" placeholder="admin@example.com">
                                    <button onclick="submitAssign(\${g.id})" class="bg-blue-600 hover:bg-blue-500 text-white px-3 py-2 rounded-r-lg font-bold shadow-lg"><i class="fa-solid fa-user-plus"></i></button>
                                </div>
                            </div>` : `
                            <div>
                                <label class="block text-xs font-medium text-slate-400 mb-1">Status Override</label>
                                <button onclick="requestReassignment(\${g.id})" class="bg-orange-500/20 hover:bg-orange-500/30 border border-orange-500/50 text-orange-400 text-[10px] w-full py-2.5 rounded-lg font-bold transition flex items-center justify-center tracking-wider uppercase"><i class="fa-solid fa-person-walking-arrow-right mr-2"></i> Request Reassignment</button>
                            </div>
                    `;

                    actionControlsHtml = `
                    <div class="mt-6 border-t border-slate-700/50 pt-5 space-y-4 bg-slate-900/40 -mx-6 -mb-6 p-6 rounded-b-2xl">
                        <h4 class="text-xs font-bold text-blue-400 uppercase tracking-widest"><i class="fa-solid fa-bolt mr-1"></i> \${isAdmin ? 'Admin' : 'Officer'} Action Console</h4>
                        
                        <div class="grid grid-cols-2 gap-4 flex-wrap items-end">
                            \${assignBlock}
                            <div>
                                <label class="block text-xs font-medium text-slate-400 mb-1">Current Status</label>
                                <select id="newStatus" class="input-field w-full px-3 py-2 rounded-lg text-xs appearance-none">
                                    <option value="OPEN" \${g.status === 'OPEN' ? 'selected' : ''}>Open</option>
                                    <option value="IN PROGRESS" \${g.status === 'IN PROGRESS' ? 'selected' : ''}>In Progress</option>
                                    <option value="ESCALATED_SLA_BREACH" \${g.status === 'ESCALATED_SLA_BREACH' ? 'selected' : ''}>SLA Breach / Escalate</option>
                                    <option value="RESOLVED" \${g.status === 'RESOLVED' ? 'selected' : ''}>Resolved</option>
                                    <option value="REOPENED" \${g.status === 'REOPENED' ? 'selected' : ''}>Re-Opened</option>
                                </select>
                            </div>
                        </div>

                        <div>
                            <label class="block text-xs font-bold text-slate-400 mb-1"><i class="fa-solid fa-lock mr-1"></i> Internal Officer Remarks</label>
                            <textarea id="adminRemarks" rows="2" class="input-field w-full px-3 py-2 rounded-lg text-xs" placeholder="Private case notes... (\${g.remarks ? 'Existing text will be replaced if edited' : 'Visible only to admins'})">\${g.remarks || ''}</textarea>
                        </div>
                        
                        <div>
                            <label class="block text-xs font-bold text-blue-400 mb-1"><i class="fa-solid fa-envelope mr-1"></i> Direct Message to Citizen</label>
                            <textarea id="citizenMsg" rows="2" class="input-field w-full px-3 py-2 rounded-lg text-xs border-blue-500/30" placeholder="Personalized response directly to the filer... (\${g.citizenMessage ? 'Existing text will be replaced' : 'Only sent to them'})">\${g.citizenMessage || ''}</textarea>
                        </div>

                        <div>
                            <label class="block text-xs font-bold text-emerald-400 mb-1"><i class="fa-solid fa-earth-americas mr-1"></i> Resolution Tweet (Public View)</label>
                            <textarea id="publicTweet" rows="2" class="input-field w-full px-3 py-2 rounded-lg text-xs border-emerald-500/30 font-medium" placeholder="E.g. The administration has successfully resolved this issue.">\${g.publicPostDescription || ''}</textarea>
                        </div>
                        
                        <div class="flex justify-between items-end mt-2">
                            <div class="flex-1 mr-4 overflow-hidden hidden sm:block">
                                <label class="block text-[10px] font-bold text-slate-400 mb-1 uppercase tracking-widest">Attach Rectified Photo</label>
                                <input type="file" accept="image/*" onchange="handleImageUpload(event)" class="text-xs file:mr-2 file:py-1 file:px-3 file:rounded-full file:border-0 file:bg-emerald-500/20 file:text-emerald-400 file:cursor-pointer w-[150px]">
                            </div>
                            <button onclick="submitStatus(\${g.id})" class="bg-gradient-to-r from-emerald-600 to-emerald-500 text-white py-2 px-6 rounded-xl font-bold transition shadow-lg shadow-emerald-500/20 text-sm whitespace-nowrap">
                                <i class="fa-solid fa-check-double mr-1"></i> Update Log
                            </button>
                        </div>
                    </div>`;
                }

                document.getElementById('modalBody').innerHTML = `
                <div class="max-h-[75vh] overflow-y-auto pr-2 custom-scroll">
                    \${photoHtml}
                    <div class="space-y-4 text-sm px-1">
                        <p class="text-slate-200"><strong class="text-slate-400 block text-xs uppercase tracking-wider mb-1">Description</strong></p>
                        <p class="text-slate-300 text-sm italic bg-slate-800/50 p-4 rounded-xl border border-slate-700 leading-relaxed max-h-48 overflow-y-auto custom-scroll">\${escapeHtml(g.description)}</p>
                        
                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-2">
                            <p class="text-slate-300"><strong class="text-slate-500 block text-xs uppercase tracking-widest mb-1"><i class="fa-solid fa-location-crosshairs mr-1"></i> GPS Coords</strong> <a href="https://maps.google.com/?q=\${g.locationCoordinates}" target="_blank" class="text-blue-400 hover:text-blue-300 underline font-medium">\${escapeHtml(g.locationCoordinates) || 'Unregistered'}</a></p>
                            <p class="text-slate-300"><strong class="text-slate-500 block text-xs uppercase tracking-widest mb-1"><i class="fa-solid fa-envelope mr-1"></i> User Base</strong> \${escapeHtml(g.userEmail)}</p>
                        </div>
                        
                        <div class="inline-flex items-center text-emerald-400 bg-emerald-500/10 px-4 py-2.5 rounded-xl border border-emerald-500/20 shadow-inner">
                            <i class="fa-solid fa-phone-volume text-lg mr-3"></i>
                            <div>
                                <span class="text-[10px] font-bold text-emerald-500/80 uppercase tracking-widest block leading-tight">Emergency Contact</span>
                                <span class="font-bold tracking-wider">\${escapeHtml(g.userMobile) || 'Not Provided'}</span>
                            </div>
                        </div>

                        \${g.citizenMessage ? `<div class="bg-blue-500/10 border border-blue-500/20 text-blue-300 p-4 rounded-xl text-sm mt-3 shadow-inner"><i class="fa-solid fa-envelope-open-text mb-2 text-blue-400 text-lg"></i><div><span class="text-[10px] font-bold text-blue-400 uppercase tracking-widest block mb-1">Direct Message from Administration</span><p class="leading-relaxed">\${escapeHtml(g.citizenMessage)}</p></div></div>` : ''}

                        \${g.publicPostDescription ? `<div class="bg-emerald-500/10 border border-emerald-500/20 text-emerald-300 p-3 rounded-xl flex items-start text-xs mt-3"><i class="fa-solid fa-reply-all mt-0.5 mr-2 text-emerald-400"></i><div><span class="text-[9px] font-bold text-emerald-400 uppercase tracking-widest block mb-0.5">Official Public Feed Statement</span>\${escapeHtml(g.publicPostDescription)}</div></div>` : ''}
                        
                        \${g.resolvedAttachmentUrl ? `<div class="mt-3"><label class="block text-[10px] font-bold text-emerald-400 mb-1 uppercase tracking-widest text-center"><i class="fa-solid fa-camera-retro mr-1"></i> Official Rectified Proof</label><div onclick="openLightbox('\${g.resolvedAttachmentUrl}')" class="h-48 w-full rounded-xl bg-cover bg-center border border-emerald-500/30 shadow-lg shadow-emerald-500/10 cursor-pointer hover:opacity-80 transition" style="background-image: url('\${g.resolvedAttachmentUrl}')" title="Click to expand"></div></div>` : ''}

                        \${((isAdmin || isOfficer) && g.remarks) ? `<div class="bg-indigo-500/10 border border-indigo-500/20 text-indigo-300 p-3 rounded-xl flex items-start text-xs mt-3"><i class="fa-solid fa-lock mt-0.5 mr-2 text-indigo-400"></i><div><span class="text-[9px] font-bold text-indigo-400 uppercase tracking-widest block mb-0.5">Internal Remarks</span>\${escapeHtml(g.remarks)}</div></div>` : ''}
                    </div>
                    
                    \${(userEmail === g.userEmail && g.status === 'RESOLVED') ? 
                        (g.reopenCount >= 1 ? `
                        <div class="mt-4 pt-4 border-t border-slate-700/50 flex justify-end">
                            <div class="text-xs bg-slate-800/80 text-slate-500 border border-slate-700 px-4 py-2 rounded-lg font-bold flex items-center shadow-inner cursor-not-allowed">
                                <i class="fa-solid fa-lock mr-2"></i> Dispute Limit Exhausted
                            </div>
                        </div>` : `
                        <div class="mt-4 pt-4 border-t border-slate-700/50 flex justify-end">
                            <button onclick="reopenTicket(\${g.id})" class="text-xs bg-fuchsia-500/10 hover:bg-fuchsia-500/20 text-fuchsia-400 border border-fuchsia-500/30 px-4 py-2 rounded-lg font-bold transition flex items-center shadow-lg shadow-fuchsia-500/10">
                                <i class="fa-solid fa-triangle-exclamation mr-2"></i> Not Satisfied? Dispute & Re-Open Ticket
                            </button>
                        </div>`) : ''}

                    \${actionControlsHtml}
                </div>`;
                
                document.getElementById('actionModal').classList.remove('hidden');
            }


            async function submitStatus(id) {
                const status = document.getElementById('newStatus').value;
                const remarksElem = document.getElementById('adminRemarks');
                const remarks = remarksElem ? remarksElem.value.trim() : "Automated System: Processed via Master Console";
                const publicTweet = document.getElementById('publicTweet').value.trim();
                const citizenMsg = document.getElementById('citizenMsg').value.trim();

                try {
                    // Send the secure JSON payload instead of cramped URL parameters
                    const payload = {
                        status: status,
                        remarks: remarks,
                        citizenMessage: citizenMsg,
                        publicPostDescription: publicTweet,
                        resolveAttachmentUrl: currentBase64Image
                    };

                    const res = await fetchWithAuth(`\${API_GATEWAY_URL}/grievance/\${id}/status`, {
                        method: 'PUT',
                        body: JSON.stringify(payload)
                    });
                    
                    if (!res.ok) throw new Error("Failed to update status");
                    
                    showAlert('success', 'Status & Civic Tweet published successfully!');
                    closeModal();
                    if(isOfficer) loadOfficerView();
                    else loadAdminView();
                } catch (err) {
                    alert(err.message);
                }
            }
            
            let activeReassignId = null;

            function requestReassignment(id) {
                activeReassignId = id;
                document.getElementById('reassignReasonTxt').value = '';
                document.getElementById('reassignModal').classList.remove('hidden');
            }

            function closeReassignModal() {
                activeReassignId = null;
                document.getElementById('reassignModal').classList.add('hidden');
            }

            document.getElementById('confirmReassignBtn').addEventListener('click', async () => {
                const reason = document.getElementById('reassignReasonTxt').value.trim();
                if (!reason) {
                    showAlert('error', 'A justification reason is strictly required!');
                    return;
                }

                const btn = document.getElementById('confirmReassignBtn');
                btn.disabled = true;
                btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin mr-2"></i> Submitting...';

                try {
                    // Call the dedicated Reassignment Endpoint
                    const res = await fetchWithAuth(`\${API_GATEWAY_URL}/grievance/\${activeReassignId}/reassign?reason=\${encodeURIComponent(reason)}`, { method: 'PUT' });
                    if(!res.ok) throw new Error("Failed to request reassignment");
                    
                    showAlert('success', 'Ticket successfully released back to the Dispatcher queue!');
                    closeReassignModal();
                    closeModal(); // Close master background modal too
                    loadOfficerView();
                } catch(e) { 
                    showAlert('error', e.message);
                } finally {
                    btn.disabled = false;
                    btn.innerHTML = 'Submit Request';
                }
            });

            let activeDisputeId = null;

            function reopenTicket(id) {
                activeDisputeId = id;
                document.getElementById('disputeReasonTxt').value = '';
                document.getElementById('disputeModal').classList.remove('hidden');
            }

            function closeDisputeModal() {
                activeDisputeId = null;
                document.getElementById('disputeModal').classList.add('hidden');
            }

            document.getElementById('confirmDisputeBtn').addEventListener('click', async () => {
                const reason = document.getElementById('disputeReasonTxt').value.trim();
                if (!reason) {
                    showAlert('error', 'Please provide a reason to raise a formal dispute!');
                    return;
                }

                const btn = document.getElementById('confirmDisputeBtn');
                btn.disabled = true;
                btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin mr-2"></i> Opening...';

                try {
                    const res = await fetchWithAuth(`\${API_GATEWAY_URL}/grievance/\${activeDisputeId}/reopen?reason=\${encodeURIComponent(reason)}`, { method: 'PUT' });
                    if(!res.ok) throw new Error("Failed to re-open ticket! Make sure your API is updated.");
                    
                    showAlert('success', 'Dispute raised! Your ticket has been instantly Re-Opened for the SuperAdmin.');
                    closeDisputeModal();
                    closeModal(); // Close master background modal too
                    loadUserView();
                } catch(err) {
                    showAlert('error', err.message);
                } finally {
                    btn.disabled = false;
                    btn.innerHTML = 'Open Dispute';
                }
            });

            /* ================= LIGHTBOX IMAGE ENGINE ================= */
            function openLightbox(base64str) {
                if(!base64str) return;
                document.getElementById('lightboxImg').src = base64str;
                document.getElementById('imageLightbox').classList.remove('hidden');
            }

            function closeLightbox() {
                document.getElementById('imageLightbox').classList.add('hidden');
                setTimeout(() => { document.getElementById('lightboxImg').src = ''; }, 300);
            }

            /* ================= MAYOR ANALYTICS ENGINE (CHART.JS) ================= */
            let chartStatus = null;
            let chartCategory = null;

            function renderAnalytics(data) {
                if (!data || data.length === 0) return;

                // 1. Calculate KPIs safely checking typo permutations
                let total = data.length;
                let resolved = 0;
                let disputed = 0;
                let breached = 0;

                const categoryCount = {};
                const statusCount = {};

                data.forEach(g => {
                    const s = (g.status || 'OPEN').toUpperCase();
                    if (s === 'RESOLVED') resolved++;
                    if (s === 'REOPENED') disputed++;
                    if (s === 'ESCALATED_SLA_BREACH' || s === 'ESCALATES_SLA_BREACH') breached++;

                    // Count Statuses for Pie Chart
                    const cleanStatus = s === 'ESCALATES_SLA_BREACH' ? 'ESCALATED_SLA_BREACH' : s;
                    statusCount[cleanStatus] = (statusCount[cleanStatus] || 0) + 1;

                    // Count Categories for Bar Chart
                    const cat = g.category || 'Other';
                    categoryCount[cat] = (categoryCount[cat] || 0) + 1;
                });

                // Update DOM KPIs
                document.getElementById('kpiTotal').innerText = total;
                document.getElementById('kpiResolved').innerText = resolved;
                document.getElementById('kpiDisputed').innerText = disputed;
                document.getElementById('kpiBreached').innerText = breached;

                // 2. Render Status Doughnut Chart
                const ctxStatus = document.getElementById('statusChart').getContext('2d');
                if(chartStatus) chartStatus.destroy();
                
                chartStatus = new Chart(ctxStatus, {
                    type: 'doughnut',
                    data: {
                        labels: Object.keys(statusCount),
                        datasets: [{
                            data: Object.values(statusCount),
                            backgroundColor: ['#60a5fa', '#34d399', '#f472b6', '#ef4444', '#fbbf24', '#a78bfa'],
                            borderWidth: 0,
                            hoverOffset: 4
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { position: 'right', labels: { color: '#94a3b8', font: { size: 10 } } }
                        },
                        cutout: '70%'
                    }
                });

                // 3. Render Department Workload Bar Chart
                const ctxCategory = document.getElementById('categoryChart').getContext('2d');
                if(chartCategory) chartCategory.destroy();

                chartCategory = new Chart(ctxCategory, {
                    type: 'bar',
                    data: {
                        labels: Object.keys(categoryCount),
                        datasets: [{
                            label: 'Total Tickets',
                            data: Object.values(categoryCount),
                            backgroundColor: '#818cf8',
                            borderRadius: 4
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { display: false } },
                        scales: {
                            y: { display: false },
                            x: { grid: { display: false, drawBorder: false }, ticks: { color: '#94a3b8', font: { size: 10 } } }
                        }
                    }
                });
            }

            function showOfficerForm() {
                hideAlert();
                document.getElementById('filterConsole').classList.add('hidden');
                document.getElementById('pageTitle').textContent = 'Promote Officer';
                document.getElementById('pageSubtitle').textContent = 'Assign citizens to internal Department roles securely.';
                document.getElementById('headerActions').innerHTML = `
                <button onclick="loadAdminView()" class="glass-panel text-slate-300 hover:text-white px-5 py-2.5 rounded-xl font-medium transition flex items-center">
                    <i class="fa-solid fa-arrow-left mr-2"></i> Back to Dashboard
                </button>`;

                const formHtml = `
                <div class="glass-panel p-6 md:p-8 rounded-3xl max-w-lg shadow-xl mx-auto border border-emerald-500/30">
                    <form onsubmit="event.preventDefault(); submitPromotion();" class="space-y-6">
                        <div>
                            <label class="block text-sm font-bold text-slate-300 mb-2 tracking-wide">Citizen Email Identity</label>
                            <input type="email" id="proEmail" required class="input-field w-full px-4 py-3 rounded-xl text-sm" placeholder="user@gmail.com">
                        </div>
                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label class="block text-sm font-bold text-slate-300 mb-2 tracking-wide">Privilege Role</label>
                                <select id="proRole" class="input-field w-full px-4 py-3 rounded-xl text-sm border-blue-500/30">
                                    <option value="OFFICER">OFFICER</option>
                                    <option value="SUPERADMIN">SUPERADMIN</option>
                                    <option value="USER">USER (Demote)</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-bold text-slate-300 mb-2 tracking-wide">Department</label>
                                <select id="proDept" class="input-field w-full px-4 py-3 rounded-xl text-sm border-emerald-500/30">
                                    <option value="Water">Water</option>
                                    <option value="Electricity">Electricity</option>
                                    <option value="Roads">Roads</option>
                                    <option value="Sanitation">Sanitation</option>
                                    <option value="Security">Public Safety</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                        </div>
                        <div class="pt-4">
                            <button type="submit" id="proBtn" class="w-full bg-gradient-to-r from-emerald-600 to-teal-500 hover:from-emerald-500 hover:to-teal-400 text-white px-8 py-4 rounded-xl font-extrabold shadow-lg shadow-emerald-500/25 transition text-lg tracking-wider">
                                <i class="fa-solid fa-fingerprint mr-2"></i> Provision Account
                            </button>
                        </div>
                    </form>
                </div>
                `;
                document.getElementById('workspaceContent').innerHTML = formHtml;
            }

            async function submitPromotion() {
                const email = document.getElementById('proEmail').value.trim();
                const role = document.getElementById('proRole').value;
                const dept = document.getElementById('proDept').value;
                const btn = document.getElementById('proBtn');
                
                btn.disabled = true;
                btn.innerHTML = '<i class="fa-solid fa-circle-notch fa-spin mr-2"></i> Promoting...';
                
                try {
                    const res = await fetchWithAuth(`\${API_GATEWAY_URL}/auth/promote`, {
                        method: 'PUT',
                        body: JSON.stringify({ email: email, role: role, department: dept })
                    });
                    if(!res.ok) throw new Error("Failed to promote user! Verify email is correct.");
                    showAlert('success', 'User successfully provisioned to ' + dept + ' ' + role);
                    setTimeout(() => loadAdminView(), 2000);
                } catch(err) {
                    showAlert('error', err.message);
                    btn.disabled = false;
                    btn.innerHTML = 'Provision Account';
                }
            }

            // INITIALIZATION KICK-OFF
            if (isAdmin) {
                loadAdminView();
            } else if(isOfficer) {
                loadOfficerView();
            } else {
                loadUserView();
            }
            function fetchGPS() {
                const locInput = document.getElementById('gLocation');
                locInput.value = "Detecting location...";
                
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(
                        (position) => {
                            const lat = position.coords.latitude.toFixed(5);
                            const lng = position.coords.longitude.toFixed(5);
                            locInput.value = lat + ", " + lng; // Formats to "28.7041, 77.1025"
                            showAlert('success', 'GPS Coordinates pinned!');
                        }, 
                        (error) => {
                            locInput.value = "";
                            showAlert('error', 'Please allow location access in your browser.');
                        }
                    );
                } else {
                    showAlert('error', 'Geolocation is not supported by this browser.');
                }
            }
          

        </script>
    </body>

    </html>