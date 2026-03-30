<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <!DOCTYPE html>
  <html lang="en">

  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Grievance Platform | Portal</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Google Fonts: Plus Jakarta Sans for a premium feel -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap"
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
              brand: {
                50: '#f0f4fe',
                100: '#e4ebfd',
                500: '#3b82f6',
                600: '#2563eb',
                900: '#1e3a8a',
              },
              dark: {
                900: '#0f172a', /* slate-900 */
                800: '#1e293b', /* slate-800 */
              }
            },
            animation: {
              'blob': 'blob 7s infinite',
              'fade-in-up': 'fadeInUp 0.5s ease-out forwards',
            },
            keyframes: {
              blob: {
                '0%': { transform: 'translate(0px, 0px) scale(1)' },
                '33%': { transform: 'translate(30px, -50px) scale(1.1)' },
                '66%': { transform: 'translate(-20px, 20px) scale(0.9)' },
                '100%': { transform: 'translate(0px, 0px) scale(1)' },
              },
              fadeInUp: {
                '0%': { opacity: '0', transform: 'translateY(20px)' },
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
        overflow-x: hidden;
      }

      .glass-panel {
        background: rgba(30, 41, 59, 0.7);
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        border: 1px solid rgba(255, 255, 255, 0.08);
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
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
        background: rgba(15, 23, 42, 0.8);
      }

      /* Custom Scrollbar */
      ::-webkit-scrollbar {
        width: 8px;
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

      /* Loader */
      .loader {
        border: 2px solid rgba(255, 255, 255, 0.1);
        border-left-color: #ffffff;
        border-radius: 50%;
        width: 20px;
        height: 20px;
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

  <body class="min-h-screen relative flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">

    <!-- Animated Background Blobs -->
    <div class="fixed inset-0 w-full h-full overflow-hidden -z-10 pointer-events-none">
      <div
        class="absolute top-0 -left-4 w-72 h-72 bg-purple-500 rounded-full mix-blend-multiply filter blur-[128px] opacity-40 animate-blob">
      </div>
      <div
        class="absolute top-0 -right-4 w-72 h-72 bg-blue-500 rounded-full mix-blend-multiply filter blur-[128px] opacity-40 animate-blob animation-delay-2000">
      </div>
      <div
        class="absolute -bottom-8 left-20 w-72 h-72 bg-indigo-500 rounded-full mix-blend-multiply filter blur-[128px] opacity-40 animate-blob animation-delay-4000">
      </div>
    </div>

    <!-- Main Container -->
    <div class="max-w-6xl w-full grid grid-cols-1 lg:grid-cols-2 gap-8 items-center z-10">

      <!-- Left Side: Hero / Track Grievance -->
      <div class="flex flex-col space-y-8 animate-fade-in-up" style="animation-delay: 0.1s;">
        <div>
          <div
            class="inline-flex items-center px-3 py-1 rounded-full bg-blue-500/10 border border-blue-500/20 text-blue-400 text-sm font-semibold mb-6 shadow-[0_0_15px_rgba(59,130,246,0.15)]">
            <span class="w-2 h-2 rounded-full bg-blue-500 mr-2 animate-pulse"></span>
            Smart Grievance Platform
          </div>
          <h1
            class="text-5xl lg:text-6xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-white to-slate-400 tracking-tight mb-4">
            Resolve Issues.<br />
            <span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 to-indigo-500">Faster &
              Smarter.</span>
          </h1>
          <p class="text-slate-400 text-lg max-w-md mt-4 leading-relaxed">
            A unified, secure portal to submit, track, and resolve grievances with complete transparency.
          </p>
        </div>

        <!-- Public Grievance Tracking Card -->
                  <div class="flex flex-col space-y-3">
            <div class="relative w-full">
              <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <i class="fa-solid fa-hashtag text-slate-500"></i>
              </div>
              <input type="text" id="trackId" class="input-field w-full pl-10 pr-4 py-3 rounded-xl text-sm" placeholder="Grievance ID (e.g. 1)">
            </div>
            
            <div class="relative w-full">
              <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                <i class="fa-regular fa-envelope text-slate-500"></i>
              </div>
              <input type="email" id="trackEmail" class="input-field w-full pl-10 pr-4 py-3 rounded-xl text-sm" placeholder="Registered Email">
            </div>

            <button onclick="trackGrievance()" id="trackBtn"
              class="bg-slate-700 hover:bg-slate-600 text-white w-full py-3 rounded-xl font-medium transition duration-200 flex items-center justify-center shadow-lg shadow-slate-900/20">
              <span>View Status</span>
              <div id="trackLoader" class="loader ml-2 hidden"></div>
            </button>
          </div>
        

          <!-- Track Result Display -->
          <div id="trackResult" class="mt-4 hidden p-4 rounded-xl border border-slate-700 bg-slate-800/50">
            <!-- Dynamic content filled by JS -->
          </div>
        </div>
      </div>

      <!-- Right Side: Login Form -->
      <div
        class="glass-panel rounded-3xl p-8 sm:p-10 shadow-2xl animate-fade-in-up md:mx-auto w-full max-w-md lg:max-w-none"
        style="animation-delay: 0.2s;">
        <div class="text-center mb-8">
          <div
            class="w-16 h-16 bg-gradient-to-tr from-blue-600 to-purple-600 rounded-2xl mx-auto flex items-center justify-center mb-4 shadow-lg shadow-blue-500/30 transform rotate-3">
            <i class="fa-solid fa-lock text-2xl text-white -rotate-3"></i>
          </div>
          <h2 class="text-3xl font-bold mb-2">Welcome Back</h2>
          <p class="text-slate-400 text-sm">Sign in to your account to continue</p>
        </div>

        <!-- Custom Alerts -->
        <div id="alertBox" class="hidden mb-6 p-4 rounded-xl flex items-center text-sm font-medium border">
          <i id="alertIcon" class="mr-3 text-lg"></i>
          <span id="alertMessage"></span>
        </div>

        <form id="loginForm" onsubmit="event.preventDefault(); handleLogin();" class="space-y-5">
          <div>
            <label class="block text-sm font-medium text-slate-300 mb-1.5 ml-1">Email Address</label>
            <div class="relative">
              <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                <i class="fa-regular fa-envelope text-slate-500"></i>
              </div>
              <input type="email" id="email" required class="input-field w-full pl-11 pr-4 py-3.5 rounded-xl text-sm"
                placeholder="admin@example.com">
            </div>
          </div>

          <div>
            <label class="block text-sm font-medium text-slate-300 mb-1.5 ml-1">Password</label>
            <div class="relative">
              <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                <i class="fa-solid fa-shield-halved text-slate-500"></i>
              </div>
              <input type="password" id="password" required
                class="input-field w-full pl-11 pr-12 py-3.5 rounded-xl text-sm" placeholder="••••••••">
              <div
                class="absolute inset-y-0 right-0 pr-3 flex items-center cursor-pointer text-slate-400 hover:text-white transition"
                onclick="togglePassword()">
                <i id="eyeIcon" class="fa-regular fa-eye"></i>
              </div>
            </div>
          </div>

          <div class="flex items-center justify-between mt-2">
            <div class="flex items-center">
              <input id="remember" type="checkbox"
                class="w-4 h-4 rounded border-slate-600 text-blue-500 focus:ring-blue-500 bg-slate-800">
              <label for="remember" class="ml-2 text-sm text-slate-400">Remember me</label>
            </div>
            <a href="#" class="text-sm font-medium text-blue-400 hover:text-blue-300 transition w-fit">Forgot
              password?</a>
          </div>

          <button type="submit" id="loginBtn"
            class="w-full bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 text-white py-3.5 rounded-xl font-bold flex items-center justify-center transition-all duration-300 transform shadow-lg shadow-blue-500/25 group overflow-hidden relative">
            <span
              class="absolute w-0 h-0 transition-all duration-500 ease-out bg-white rounded-full group-hover:w-56 group-hover:h-56 opacity-10"></span>
            <span id="btnText" class="relative">Sign In to Dashboard</span>
            <i id="btnIcon"
              class="fa-solid fa-arrow-right ml-2 relative group-hover:translate-x-1 transition-transform"></i>
            <div id="btnLoader" class="loader hidden ml-2 relative"></div>
          </button>
        </form>

        <div class="mt-8 text-center border-t border-slate-700/50 pt-6">
          <p class="text-sm text-slate-400">
            Don't have an account?
            <a href="/register" class="text-blue-400 hover:text-blue-300 font-semibold transition ml-1">Create an
              account</a>
          </p>
        </div>
      </div>
        <!-- NEW SECTION: Public Resolution Feed (The Transparency Wall) -->
    <div class="max-w-6xl w-full z-10 mt-12 mb-16 px-4 animate-fade-in-up" style="animation-delay: 0.4s;">
      <div class="flex items-center justify-between mb-6">
        <h2 class="text-2xl font-extrabold text-white flex items-center tracking-tight">
          <i class="fa-solid fa-ribbon text-emerald-400 mr-3"></i> Transparency Wall
        </h2>
        <span class="text-sm text-slate-400 font-medium bg-slate-800/50 px-3 py-1 rounded-full border border-slate-700/50">Recently Resolved</span>
      </div>
      
      <!-- Container for dynamically injected AI cards -->
      <div id="feedContainer" class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Loader while fetching from Backend -->
        <div class="col-span-full flex justify-center py-12">
            <div class="loader opacity-50 border-emerald-500"></div>
        </div>
      </div>
    </div>
    

    <!-- API configuration & Scripts -->
    <script>
      // Use the API Gateway mapped to port 8085 as requested
      const API_GATEWAY_URL = 'http://localhost:8085';
      
      // Toggle Password Visibility
      function togglePassword() {
        const pwd = document.getElementById('password');
        const icon = document.getElementById('eyeIcon');
        if (pwd.type === 'password') {
          pwd.type = 'text';
          icon.className = 'fa-regular fa-eye-slash';
        } else {
          pwd.type = 'password';
          icon.className = 'fa-regular fa-eye';
        }
      }

      // Show Custom Alert
      function showAlert(type, message) {
        const box = document.getElementById('alertBox');
        const icon = document.getElementById('alertIcon');
        const msg = document.getElementById('alertMessage');

        box.className = 'mb-6 p-4 rounded-xl flex items-center text-sm font-medium border transition-all duration-300 transform translate-y-0 opacity-100';

        if (type === 'error') {
          box.classList.add('bg-red-500/10', 'border-red-500/30', 'text-red-400');
          icon.className = 'fa-solid fa-circle-exclamation mr-3 text-lg text-red-500';
        } else if (type === 'success') {
          box.classList.add('bg-emerald-500/10', 'border-emerald-500/30', 'text-emerald-400');
          icon.className = 'fa-solid fa-circle-check mr-3 text-lg text-emerald-500';
        }

        msg.textContent = message;
      }

      // Hide Alert
      function hideAlert() {
        const box = document.getElementById('alertBox');
        box.classList.add('hidden');
      }

      // Handle Login using AuthController via API Gateway
      async function handleLogin() {
        const email = document.getElementById('email').value.trim();
        const password = document.getElementById('password').value.trim();
        const btnText = document.getElementById('btnText');
        const btnLoader = document.getElementById('btnLoader');
        const btnIcon = document.getElementById('btnIcon');
        const btn = document.getElementById('loginBtn');

        if (!email || !password) return;

        hideAlert();

        // Set Loading state
        btn.disabled = true;
        btnText.textContent = 'Authenticating...';
        btnLoader.classList.remove('hidden');
        btnIcon.classList.add('hidden');
        btn.classList.add('opacity-80', 'cursor-not-allowed');

        try {
          // Fetching from API Gateway 8085 which routes to auth-service
          const response = await fetch(`\${API_GATEWAY_URL}/auth/login`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, password })
          });

          if (!response.ok) {
            throw new Error('Invalid email or password');
          }

          // Assuming JWT token is returned as plain text based on old jsp
          const token = await response.text();
          localStorage.setItem('token', token);
          localStorage.setItem('userEmail', email);

          // Decode JWT to get role
          let payload = {};
          try {
            payload = JSON.parse(atob(token.split('.')[1]));
          } catch (e) { console.error("Could not parse token"); }

          const roles = payload.roles || payload.role || [];

          showAlert('success', 'Login successful! Redirecting to dashboard...');

          // Redirect based on role
          setTimeout(() => {
            window.location.href = '/dashboard';
          }, 1500);

        } catch (err) {
          showAlert('error', err.message || 'Connection failed. Ensure API Gateway is running on :8085');
          // Reset Loading state
          btn.disabled = false;
          btnText.textContent = 'Sign In to Dashboard';
          btnLoader.classList.add('hidden');
          btnIcon.classList.remove('hidden');
          btn.classList.remove('opacity-80', 'cursor-not-allowed');
        }
      }

      // Handle Public Grievance Tracking using GrievanceController via API Gateway
      async function trackGrievance() {
    	  const trackId = document.getElementById('trackId').value.trim();
          const trackEmail = document.getElementById('trackEmail').value.trim();

        const trackResult = document.getElementById('trackResult');
        const trackBtn = document.getElementById('trackBtn');
        const trackLoader = document.getElementById('trackLoader');
		
        if (!trackId) {
          trackResult.innerHTML = '<p class="text-red-400 text-sm"><i class="fa-solid fa-triangle-exclamation mr-1"></i> Please enter a valid ID.</p>';
          trackResult.classList.remove('hidden');
          return;
        }

        // UI Loading state
        trackBtn.disabled = true;
        trackLoader.classList.remove('hidden');
        trackResult.classList.add('hidden');

        try {
          // Assuming GET /grievance/{id} is publicly accessible, or at least handles 401/404 gracefully
         const response = await fetch(`\${API_GATEWAY_URL}/grievance/track?id=\${trackId}&email=\${trackEmail}`, {
            method: 'GET',
            headers: { 'Content-Type': 'application/json' }
          });

          if (response.status === 401 || response.status === 403) {
            throw new Error('Authentication required to view this grievance.');
          }
          if (!response.ok) {
            throw new Error('Grievance not found.');
          }

          const data = await response.json();

          // Badge color based on status
          let statusColor = 'bg-slate-500';
          let statusText = data.status || 'UNKNOWN';
          if (statusText.toUpperCase() === 'OPEN') statusColor = 'bg-blue-500';
          else if (statusText.toUpperCase() === 'IN_PROGRESS') statusColor = 'bg-yellow-500';
          else if (statusText.toUpperCase() === 'RESOLVED') statusColor = 'bg-emerald-500';

          trackResult.innerHTML = `
                    <div class="flex justify-between items-start mb-2">
                        <h4 class="font-semibold text-white">#\${data.id} - \${data.title || 'Grievance Details'}</h4>
                        <span class="px-2 py-0.5 rounded text-xs font-bold text-white \${statusColor}">\${statusText}</span>
                    </div>
                    <p class="text-sm text-slate-300 mb-2">\${data.description || 'No description available.'}</p>
                    <div class="text-xs text-slate-500 flex justify-between">
                        <span><i class="fa-regular fa-clock mr-1"></i> \${data.createdAt ? new Date(data.createdAt).toLocaleDateString() : 'N/A'}</span>
                        <span class="text-blue-400">\${data.assignedTo ? '<i class="fa-solid fa-user-shield mr-1"></i> Assigned' : 'Unassigned'}</span>
                    </div>
                `;
          trackResult.classList.remove('hidden');

        } catch (err) {
        	 trackResult.innerHTML = `<p class="text-red-400 text-sm"><i class="fa-solid fa-circle-xmark mr-1"></i> \${err.message}</p>`;
             trackResult.classList.remove('hidden');
        } finally {
          trackBtn.disabled = false;
          trackLoader.classList.add('hidden');
        }
      }
      // Tell the browser to load the feed the millisecond the website opens
      document.addEventListener("DOMContentLoaded", fetchPublicFeed);

      async function fetchPublicFeed() {
          const container = document.getElementById('feedContainer');
          try {
              const res = await fetch(`\${API_GATEWAY_URL}/grievance/feed`);
              if (!res.ok) throw new Error("Failed to load feed");
              
              const grievances = await res.json();
              container.innerHTML = ''; // Delete the loading spinner
              
              if (grievances.length === 0) {
                  container.innerHTML = '<p class="text-slate-400 col-span-full text-center py-8">No public resolutions to display yet.</p>';
                  return;
              }
              
              // Sort by ID descending (newest first) and grab only the top 3!
              const recent = grievances.sort((a,b) => b.id - a.id).slice(0, 3);
              
              recent.forEach(g => {
                  // If the admin attached a Base64 Photo, build an image tag!
                  const imageHtml = g.attachmentUrl ? 
                      `<div class="h-40 w-full mt-4 rounded-xl bg-cover bg-center border border-slate-700/50" style="background-image: url('\${g.attachmentUrl}')"></div>` : '';
                      
                  // Build the stunning Tailwind Glass Card
                  const card = `
                  <div class="glass-panel p-6 rounded-2xl border-t border-emerald-500/20 hover:-translate-y-1 transition duration-300">
                      <div class="flex justify-between items-start mb-3">
                        <span class="text-emerald-400 font-bold text-xs uppercase tracking-wider bg-emerald-500/10 px-2 py-1 rounded"><i class="fa-solid fa-check-circle mr-1"></i> Resolved</span>
                        <span class="text-slate-500 text-xs font-bold">#\${g.id}</span>
                      </div>
                      <h3 class="font-bold text-white text-lg mb-2 truncate" title="\${g.title}">\${g.title}</h3>
                      <p class="text-slate-400 text-sm line-clamp-3 leading-relaxed">\${g.description}</p>
                      \${imageHtml}
                  </div>
                  `;
                  
                  // Inject it into our HTML grid!
                  container.innerHTML += card;
              });
              
          } catch(err) {
              container.innerHTML = '<p class="text-slate-500 col-span-full text-center py-4"><i class="fa-solid fa-server mr-2"></i> Feed temporarily unavailable.</p>';
          }
      }

    </script>
  </body>

  </html>