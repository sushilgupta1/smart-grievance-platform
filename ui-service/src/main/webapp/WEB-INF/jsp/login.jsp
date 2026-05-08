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
      <div class="absolute top-0 -left-4 w-72 h-72 bg-purple-500 rounded-full mix-blend-multiply filter blur-[128px] opacity-40 animate-blob"></div>
      <div class="absolute top-0 -right-4 w-72 h-72 bg-blue-500 rounded-full mix-blend-multiply filter blur-[128px] opacity-40 animate-blob animation-delay-2000"></div>
      <div class="absolute -bottom-8 left-20 w-72 h-72 bg-indigo-500 rounded-full mix-blend-multiply filter blur-[128px] opacity-40 animate-blob animation-delay-4000"></div>
    </div>

    <!-- STICKY NAVBAR -->
    <nav class="w-full fixed top-0 z-50 glass-panel border-b border-slate-700/50 backdrop-blur-xl transition-all duration-300 shadow-xl shadow-dark-900/50">
        <div class="w-full max-w-[1400px] mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
            <div class="flex items-center cursor-pointer">
                <i class="fa-solid fa-scale-balanced text-blue-500 text-2xl mr-3"></i>
                <span class="font-bold text-xl tracking-tight text-white hidden sm:block">SmartGrievance</span>
            </div>
            <div class="flex items-center space-x-4">
                <!-- Javascript Trigger to open the Login popup! -->
                <button onclick="document.getElementById('authModal').classList.remove('hidden')" class="bg-blue-600 hover:bg-blue-500 text-white px-5 py-2.5 rounded-full font-bold shadow-lg shadow-blue-500/30 transition text-sm flex items-center border border-blue-400/50">
                    <i class="fa-solid fa-user-plus mr-2"></i> File Complaint / Login
                </button>
            </div>
        </div>
    </nav>

    <!-- NEW: RESPONSIVE TWITTER-STYLE 2-COLUMN STRUCTURE -->
    <div class="flex flex-col lg:flex-row w-full min-h-screen pt-16">
        
        <!-- ZONE 1: LEFT SIDEBAR (Sticky on Laptops) -->
        <div class="w-full lg:w-1/3 lg:fixed lg:h-[calc(100vh-4rem)] px-6 md:px-10 pt-8 pb-10 border-r border-slate-700/30 overflow-y-auto z-10">
            <div class="flex flex-col space-y-8 animate-fade-in-up" style="animation-delay: 0.1s;">
              <div>
                <div class="inline-flex items-center px-3 py-1 rounded-full bg-blue-500/10 border border-blue-500/20 text-blue-400 text-sm font-semibold mb-6 shadow-[0_0_15px_rgba(59,130,246,0.15)]">
                  <span class="w-2 h-2 rounded-full bg-blue-500 mr-2 animate-pulse"></span>
                  Smart Grievance Platform
                </div>
                <h1 class="text-5xl lg:text-5xl xl:text-6xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-white to-slate-400 tracking-tight mb-4">
                  Resolve Issues.<br />
                  <span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 to-indigo-500">Faster & Smarter.</span>
                </h1>
                <p class="text-slate-400 text-lg max-w-sm mt-4 leading-relaxed">
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
<div id="trackResult" class="mt-4 hidden p-4 rounded-xl border border-slate-700 bg-slate-800/50 max-h-64 overflow-y-auto custom-scroll">
                <!-- Dynamic content filled by JS -->
              </div>
            </div>
        </div>

        <!-- ZONE 2: RIGHT MAIN FEED (Infinite Scrolling) -->
        <div class="w-full lg:w-2/3 lg:ml-[33.333333%] px-6 md:px-10 lg:px-16 pt-8 pb-32 z-10">
            <div class="animate-fade-in-up" style="animation-delay: 0.4s;">
              <div class="flex items-center justify-between mb-6 border-b border-slate-700/50 pb-4 mt-8 lg:mt-0">
                <h2 class="text-2xl font-extrabold text-white flex items-center tracking-tight">
                  <i class="fa-solid fa-ribbon text-emerald-400 mr-3"></i> Transparency Wall
                </h2>
                <span class="text-sm text-slate-400 font-medium bg-slate-800/50 px-3 py-1 rounded-full border border-slate-700/50 hidden sm:block">Recently Resolved</span>
              </div>
              
              <!-- Container for dynamically injected AI cards -->
              <div id="feedContainer" class="flex flex-col max-w-3xl mx-auto w-full gap-8">
                <!-- Loader while fetching from Backend -->
                <div class="col-span-full flex justify-center py-12">
                    <div class="loader opacity-50 border-emerald-500"></div>
                </div>
              </div>
            </div>
        </div>

    </div>

    <!-- ZONE 3: THE HIDDEN AUTHENTICATION POPUP MODAL -->
    <div id="authModal" class="hidden fixed inset-0 z-[100] flex items-center justify-center bg-dark-900/80 backdrop-blur-sm p-4 animate-fade-in-up">
        
        <!-- Right Side: Login Form -->
        <div class="glass-panel relative rounded-3xl p-8 sm:p-10 shadow-2xl md:mx-auto w-full max-w-[400px]">
            <button onclick="document.getElementById('authModal').classList.add('hidden')" class="absolute top-4 right-4 text-slate-400 hover:text-white text-xl transition bg-slate-800/50 hover:bg-slate-700 w-8 h-8 rounded-full flex items-center justify-center">
                <i class="fa-solid fa-xmark"></i>
            </button>
            <div class="text-center mb-8 mt-2">
              <div
                class="w-16 h-16 bg-gradient-to-tr from-blue-600 to-purple-600 rounded-2xl mx-auto flex items-center justify-center mb-4 shadow-lg shadow-blue-500/30 transform flex-shrink-0">
                <i class="fa-solid fa-lock text-2xl text-white"></i>
              </div>
              <h2 class="text-2xl font-bold mb-2">Welcome Back</h2>
              <p class="text-slate-400 text-xs">Sign in to your account to continue</p>
            </div>

            <!-- Custom Alerts -->
            <div id="alertBox" class="hidden mb-6 p-4 rounded-xl flex items-center text-sm font-medium border">
              <i id="alertIcon" class="mr-3 text-lg"></i>
              <span id="alertMessage"></span>
            </div>

            <form id="loginForm" onsubmit="event.preventDefault(); handleLogin();" class="space-y-4">
              <div>
                <label class="block text-sm font-medium text-slate-300 mb-1.5 ml-1">Email Address</label>
                <div class="relative">
                  <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                    <i class="fa-regular fa-envelope text-slate-500"></i>
                  </div>
                  <input type="email" id="email" required class="input-field w-full pl-11 pr-4 py-3 rounded-xl text-sm"
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
                    class="input-field w-full pl-11 pr-12 py-3 rounded-xl text-sm" placeholder="••••••••">
                  <div
                    class="absolute inset-y-0 right-0 pr-3 flex items-center cursor-pointer text-slate-400 hover:text-white transition"
                    onclick="togglePassword()">
                    <i id="eyeIcon" class="fa-regular fa-eye"></i>
                  </div>
                </div>
              </div>

              <div class="flex items-center justify-between mt-2 mb-2">
                <div class="flex items-center">
                  <input id="remember" type="checkbox"
                    class="w-4 h-4 rounded border-slate-600 text-blue-500 focus:ring-blue-500 bg-slate-800">
                  <label for="remember" class="ml-2 text-xs text-slate-400">Remember me</label>
                </div>
                <a href="#" onclick="showForgotPassword()" class="text-xs font-medium text-blue-400 hover:text-blue-300 transition w-fit">Forgot
                  password?</a>
              </div>

              <button type="submit" id="loginBtn"
                class="w-full bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 text-white py-3 rounded-xl font-bold flex items-center justify-center transition-all duration-300 transform shadow-lg shadow-blue-500/25 group overflow-hidden relative mt-4">
                <span id="btnText" class="relative">Sign In to Dashboard</span>
                <i id="btnIcon" class="fa-solid fa-arrow-right ml-2 relative group-hover:translate-x-1 transition-transform"></i>
                <div id="btnLoader" class="loader hidden ml-2 relative"></div>
              </button>
            </form>

            <!-- FORGOT PASSWORD FORM (Hidden by default) -->
            <form id="forgotPasswordForm" onsubmit="event.preventDefault(); handleForgotPassword();" class="hidden space-y-4">
              <div class="text-center mb-6">
                 <h3 class="text-xl font-bold text-white mb-2">Reset Password</h3>
                 <p class="text-xs text-slate-400">Enter your email and we'll generate a reset token.</p>
              </div>
              <div>
                <label class="block text-sm font-medium text-slate-300 mb-1.5 ml-1">Registered Email Address</label>
                <div class="relative">
                  <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                    <i class="fa-regular fa-envelope text-slate-500"></i>
                  </div>
                  <input type="email" id="forgotEmail" required class="input-field w-full pl-11 pr-4 py-3 rounded-xl text-sm" placeholder="admin@example.com">
                </div>
              </div>
              <button type="submit" id="forgotBtn" class="w-full bg-slate-700 hover:bg-slate-600 text-white py-3 rounded-xl font-bold flex items-center justify-center transition-all mt-4 border border-slate-600">
                <span id="forgotBtnText">Send Reset Token</span>
                <div id="forgotBtnLoader" class="loader hidden ml-2"></div>
              </button>
              <div class="text-center mt-4">
                 <a href="#" onclick="showLogin()" class="text-xs text-slate-400 hover:text-white"><i class="fa-solid fa-arrow-left mr-1"></i> Back to Login</a>
              </div>
            </form>

            <!-- RESET PASSWORD FORM (Hidden by default) -->
            <form id="resetPasswordForm" onsubmit="event.preventDefault(); handleResetPassword();" class="hidden space-y-4">
              <div class="text-center mb-6">
                 <h3 class="text-xl font-bold text-white mb-2">Create New Password</h3>
                 <p class="text-xs text-slate-400">Enter the 6-digit token from your console.</p>
              </div>
              
              <div>
                <label class="block text-sm font-medium text-slate-300 mb-1.5 ml-1 text-center">6-Digit Target Token</label>
                <input type="text" id="resetToken" required maxlength="6" pattern="[0-9]{6}" class="input-field w-full py-3 rounded-xl text-center text-xl tracking-[0.5em] font-bold font-mono" placeholder="••••••">
              </div>

              <div>
                <label class="block text-sm font-medium text-slate-300 mb-1.5 ml-1">New Password</label>
                <div class="relative">
                  <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                    <i class="fa-solid fa-shield-halved text-slate-500"></i>
                  </div>
                  <input type="password" id="newPassword" required class="input-field w-full pl-11 pr-4 py-3 rounded-xl text-sm" placeholder="••••••••">
                </div>
              </div>

              <button type="submit" id="resetBtn" class="w-full bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-500 hover:to-teal-500 text-white py-3 rounded-xl font-bold flex items-center justify-center transition-all mt-4">
                <span id="resetBtnText">Confirm Password Reset</span>
                <div id="resetBtnLoader" class="loader hidden ml-2"></div>
              </button>
            </form>

            <div class="mt-6 text-center border-t border-slate-700/50 pt-4">
              <p class="text-xs text-slate-400">
                Don't have an account?
                <a href="/register" class="text-blue-400 hover:text-blue-300 font-semibold transition ml-1">Create an
                  account</a>
              </p>
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
            let errorMsg = "Invalid email or password";
            try {
                const errorJson = await response.json();
                if (errorJson.customErrorCode) {
                    errorMsg = `[\${errorJson.customErrorCode}] \${errorJson.message}`;
                } else if (errorJson.message) {
                    errorMsg = errorJson.message;
                }
            } catch (e) {
                // Fallback
            }
            throw new Error(errorMsg);
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

      // UI Toggles
      function showForgotPassword() {
        hideAlert();
        document.getElementById('loginForm').classList.add('hidden');
        document.getElementById('resetPasswordForm').classList.add('hidden');
        document.getElementById('forgotPasswordForm').classList.remove('hidden');
      }

      function showLogin() {
        hideAlert();
        document.getElementById('forgotPasswordForm').classList.add('hidden');
        document.getElementById('resetPasswordForm').classList.add('hidden');
        document.getElementById('loginForm').classList.remove('hidden');
      }

      // Request Password Reset Token
      async function handleForgotPassword() {
        const email = document.getElementById('forgotEmail').value.trim();
        const btnText = document.getElementById('forgotBtnText');
        const btnLoader = document.getElementById('forgotBtnLoader');
        const btn = document.getElementById('forgotBtn');

        if(!email) return;
        hideAlert();
        btn.disabled = true;
        btnText.textContent = 'Generating...';
        btnLoader.classList.remove('hidden');

        try {
          const response = await fetch(`\${API_GATEWAY_URL}/auth/forgot-password`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email: email })
          });

          if (!response.ok) {
            const errText = await response.text();
            throw new Error(errText || 'Error generating token');
          }

          showAlert('success', 'Token Generated! Check IDE Console.');
          
          // Switch to Reset Form
          document.getElementById('forgotPasswordForm').classList.add('hidden');
          document.getElementById('resetPasswordForm').classList.remove('hidden');

        } catch (err) {
          showAlert('error', err.message);
        } finally {
          btn.disabled = false;
          btnText.textContent = 'Send Reset Token';
          btnLoader.classList.add('hidden');
        }
      }

      // Submit New Password
      async function handleResetPassword() {
        const email = document.getElementById('forgotEmail').value.trim();
        const token = document.getElementById('resetToken').value.trim();
        const newPassword = document.getElementById('newPassword').value.trim();
        
        const btnText = document.getElementById('resetBtnText');
        const btnLoader = document.getElementById('resetBtnLoader');
        const btn = document.getElementById('resetBtn');

        if(!token || !newPassword) return;
        hideAlert();
        btn.disabled = true;
        btnText.textContent = 'Resetting...';
        btnLoader.classList.remove('hidden');

        try {
          const response = await fetch(`\${API_GATEWAY_URL}/auth/reset-password`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email: email, token: token, newPassword: newPassword })
          });

          if (!response.ok) {
            const errText = await response.text();
            throw new Error(errText || 'Invalid token');
          }

          showAlert('success', 'Password updated successfully! Please Login.');
          setTimeout(() => showLogin(), 2000);

        } catch (err) {
          showAlert('error', err.message);
        } finally {
          btn.disabled = false;
          btnText.textContent = 'Confirm Password Reset';
          btnLoader.classList.add('hidden');
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
              
             
              // Increase it from 3 to 10 so people can scroll through the town's history!
              const recent = grievances.sort((a,b) => b.id - a.id).slice(0, 10);
              
              recent.forEach(g => {
                  // If no pictures exist, we inject beautiful placeholder backgrounds!
                  const beforeImg = g.attachmentUrl ? 
                      `<div class="h-64 w-full bg-cover bg-center" style="background-image: url('\${API_GATEWAY_URL}\${g.attachmentUrl}')"></div>` : 
                      `<div class="h-64 w-full bg-slate-800 flex items-center justify-center border-r border-slate-700/50"><i class="fa-solid fa-camera-slash text-5xl text-slate-700"></i></div>`;
                      
                  const afterImg = g.resolvedAttachmentUrl ? 
                      `<div class="h-64 w-full bg-cover bg-center" style="background-image: url('\${API_GATEWAY_URL}\${g.resolvedAttachmentUrl}')"></div>` : 
                      `<div class="h-64 w-full bg-emerald-900/40 flex items-center justify-center flex-col text-emerald-500/50 relative overflow-hidden"><i class="fa-solid fa-check-double text-5xl mb-3"></i><span class="font-bold tracking-widest uppercase text-xs">Work Confirmed</span><div class="absolute inset-0 bg-emerald-500/10 blur-3xl"></div></div>`;
                  
                  // Construct the Officer's Tweet box (only renders if they typed a publicPR description)
                  const tweetHtml = g.publicPostDescription ? `
                      <div class="bg-indigo-500/10 border border-indigo-500/20 p-5 rounded-2xl mb-5 relative overflow-hidden shadow-inner">
                          <div class="absolute -right-6 -top-6 text-indigo-500/10"><i class="fa-solid fa-quote-right text-8xl"></i></div>
                          <p class="text-indigo-200 text-sm font-medium relative z-10 leading-relaxed"><i class="fa-solid fa-bullhorn mr-3 text-indigo-400"></i>\${g.publicPostDescription}</p>
                      </div>` : '';

                  const card = `
                  <div class="glass-panel p-6 sm:p-8 rounded-[2rem] border-t border-emerald-500/20 shadow-2xl hover:shadow-emerald-500/10 transition duration-500 group">
                      <div class="flex justify-between items-center mb-6">
                          <div class="flex items-center">
                              <div class="w-12 h-12 rounded-full bg-emerald-500/20 flex items-center justify-center text-emerald-400 mr-4 border border-emerald-500/30 shadow-lg shadow-emerald-500/20">
                                  <i class="fa-solid fa-shield-halved text-lg"></i>
                              </div>
                              <div>
                                  <h4 class="font-bold text-white text-lg leading-tight tracking-tight">Civic Administration</h4>
                                  <span class="text-xs text-slate-400 bg-slate-800/50 px-2 py-0.5 rounded-full border border-slate-700/50">Official Public Record</span>
                              </div>
                          </div>
                      </div>

                      \${tweetHtml}

                      <!-- Split Screen Images (The Wow Factor) -->
                      <div class="flex flex-col sm:flex-row rounded-2xl overflow-hidden border border-slate-700/50 mb-5 shadow-2xl relative">
                          <div class="flex-1 relative group/img">
                              <span class="absolute top-4 left-4 bg-slate-900/80 text-white text-[10px] uppercase tracking-widest px-3 py-1.5 rounded-lg font-bold backdrop-blur-md z-10 border border-white/10 shadow-lg">Before</span>
                              <div class="transition duration-700 group-hover/img:scale-105">\${beforeImg}</div>
                          </div>
                          <!-- The Divider Graphic -->
                          <div class="hidden sm:flex absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 w-10 h-10 bg-slate-800 rounded-full border-4 border-slate-900 z-20 items-center justify-center shadow-2xl">
                              <i class="fa-solid fa-arrows-left-right text-slate-400 text-xs"></i>
                          </div>
                          <div class="flex-1 relative group/img border-t sm:border-t-0 sm:border-l border-slate-700/50">
                              <span class="absolute top-4 right-4 bg-emerald-600/90 text-white text-[10px] uppercase tracking-widest px-3 py-1.5 rounded-lg font-bold backdrop-blur-md z-10 border border-white/20 shadow-lg shadow-emerald-500/30">After</span>
                              <div class="transition duration-700 group-hover/img:scale-105">\${afterImg}</div>
                          </div>
                      </div>

                      <!-- Context Box -->
                      <div class="bg-slate-900/40 p-5 rounded-2xl border border-white/5">
                          <h4 class="text-white font-bold text-sm mb-2 opacity-90">\${g.title}</h4>
                          <p class="text-slate-400 text-xs sm:text-sm line-clamp-3 leading-relaxed">\${g.description}</p>
                      </div>
                  </div>
                  `;
                  
                  container.innerHTML += card;
              });

              
          } catch(err) {
              container.innerHTML = '<p class="text-slate-500 col-span-full text-center py-4"><i class="fa-solid fa-server mr-2"></i> Feed temporarily unavailable.</p>';
          }
      }

    </script>
  </body>

  </html>