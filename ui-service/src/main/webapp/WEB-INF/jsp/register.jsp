<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Smart Grievance Platform | Create Account</title>
        <!-- Tailwind CSS -->
        <script src="https://cdn.tailwindcss.com"></script>
        <!-- Google Fonts: Plus Jakarta Sans for a premium feel -->
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

            <!-- Left Side: Hero / Feature List -->
            <div class="flex flex-col space-y-8 animate-fade-in-up" style="animation-delay: 0.1s;">
                <div>
                    <div
                        class="inline-flex items-center px-3 py-1 rounded-full bg-blue-500/10 border border-blue-500/20 text-blue-400 text-sm font-semibold mb-6 shadow-[0_0_15px_rgba(59,130,246,0.15)]">
                        <span class="w-2 h-2 rounded-full bg-blue-500 mr-2 animate-pulse"></span>
                        Join the Platform
                    </div>
                    <h1
                        class="text-5xl lg:text-6xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-white to-slate-400 tracking-tight mb-4">
                        Make a Difference.<br />
                        <span class="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 to-indigo-500">Fast &
                            Transparent.</span>
                    </h1>
                    <p class="text-slate-400 text-lg max-w-md mt-4 leading-relaxed">
                        Create an account to submit issues, track progress, and communicate effectively with our
                        administrators.
                    </p>
                </div>

                <div class="space-y-4">
                    <div class="flex items-start">
                        <div
                            class="flex-shrink-0 h-10 w-10 rounded-xl bg-blue-500/20 flex items-center justify-center text-blue-400 border border-blue-500/20">
                            <i class="fa-solid fa-rocket"></i>
                        </div>
                        <div class="ml-4">
                            <h4 class="text-md font-bold text-white">Quick Onboarding</h4>
                            <p class="text-sm text-slate-400 mt-1">Get up and running in under a minute with minimal
                                details.</p>
                        </div>
                    </div>

                    <div class="flex items-start">
                        <div
                            class="flex-shrink-0 h-10 w-10 rounded-xl bg-emerald-500/20 flex items-center justify-center text-emerald-400 border border-emerald-500/20">
                            <i class="fa-solid fa-shield-halved"></i>
                        </div>
                        <div class="ml-4">
                            <h4 class="text-md font-bold text-white">Bank-Grade Security</h4>
                            <p class="text-sm text-slate-400 mt-1">Your data is secured through robust JWT and encrypted
                                vaults.</p>
                        </div>
                    </div>

                    <div class="flex items-start">
                        <div
                            class="flex-shrink-0 h-10 w-10 rounded-xl bg-purple-500/20 flex items-center justify-center text-purple-400 border border-purple-500/20">
                            <i class="fa-regular fa-bell"></i>
                        </div>
                        <div class="ml-4">
                            <h4 class="text-md font-bold text-white">Instant Notifications</h4>
                            <p class="text-sm text-slate-400 mt-1">You're always in the loop regarding your grievance
                                status.</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Side: Register Form -->
            <div class="glass-panel rounded-3xl p-8 sm:p-10 shadow-2xl animate-fade-in-up md:mx-auto w-full max-w-md lg:max-w-none"
                style="animation-delay: 0.2s;">
                <div class="text-center mb-8">
                    <div
                        class="w-16 h-16 bg-gradient-to-tr from-indigo-600 to-purple-600 rounded-2xl mx-auto flex items-center justify-center mb-4 shadow-lg shadow-indigo-500/30 transform rotate-3">
                        <i class="fa-solid fa-user-plus text-2xl text-white -rotate-3"></i>
                    </div>
                    <h2 class="text-3xl font-bold mb-2">Create an Account</h2>
                    <p class="text-slate-400 text-sm">Fill in your details to get started</p>
                </div>

                <!-- Custom Alerts -->
                <div id="alertBox" class="hidden mb-6 p-4 rounded-xl flex items-center text-sm font-medium border">
                    <i id="alertIcon" class="mr-3 text-lg"></i>
                    <span id="alertMessage"></span>
                </div>

                <form id="registerForm" onsubmit="event.preventDefault(); handleRegister();" class="space-y-5">
                    <div>
                        <label class="block text-sm font-medium text-slate-300 mb-1.5 ml-1">Full Name</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                                <i class="fa-regular fa-user text-slate-500"></i>
                            </div>
                            <input type="text" id="username" required
                                class="input-field w-full pl-11 pr-4 py-3.5 rounded-xl text-sm" placeholder="John Doe">
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-300 mb-1.5 ml-1">Email Address</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                                <i class="fa-regular fa-envelope text-slate-500"></i>
                            </div>
                            <input type="email" id="email" required
                                class="input-field w-full pl-11 pr-4 py-3.5 rounded-xl text-sm"
                                placeholder="johndoe@example.com">
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-300 mb-1.5 ml-1">Mobile Number</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                                <i class="fa-solid fa-phone text-slate-500"></i>
                            </div>
                            <input type="tel" id="mobileNumber" required minlength="10" maxlength="15" pattern="[0-9]*"
                                class="input-field w-full pl-11 pr-4 py-3.5 rounded-xl text-sm"
                                placeholder="9876543210">
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
                            <div class="absolute inset-y-0 right-0 pr-3 flex items-center cursor-pointer text-slate-400 hover:text-white transition"
                                onclick="togglePassword()">
                                <i id="eyeIcon" class="fa-regular fa-eye"></i>
                            </div>
                        </div>
                    </div>

                    <div class="flex items-center mt-2 pb-2">
                        <input id="terms" type="checkbox" required
                            class="w-4 h-4 rounded border-slate-600 text-blue-500 focus:ring-blue-500 bg-slate-800">
                        <label for="terms" class="ml-2 text-sm text-slate-400">
                            I agree to the <a href="#" class="text-blue-400 hover:text-blue-300">Terms of Service</a> &
                            <a href="#" class="text-blue-400 hover:text-blue-300">Privacy Policy</a>.
                        </label>
                    </div>

                    <button type="submit" id="registerBtn"
                        class="w-full bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-500 hover:to-indigo-500 text-white py-3.5 rounded-xl font-bold flex items-center justify-center transition-all duration-300 transform shadow-lg shadow-blue-500/25 group overflow-hidden relative">
                        <span
                            class="absolute w-0 h-0 transition-all duration-500 ease-out bg-white rounded-full group-hover:w-56 group-hover:h-56 opacity-10"></span>
                        <span id="btnText" class="relative">Sign Up</span>
                        <i id="btnIcon"
                            class="fa-solid fa-arrow-right ml-2 relative group-hover:translate-x-1 transition-transform"></i>
                        <div id="btnLoader" class="loader hidden ml-2 relative"></div>
                    </button>
                </form>

                <!-- OTP Verification Form (Hidden by Default) -->
                <form id="otpForm" onsubmit="event.preventDefault(); handleOtpVerify();" class="hidden space-y-5">
                    <div class="bg-blue-500/10 border border-blue-500/20 rounded-xl p-4 text-center mb-2">
                        <i class="fa-solid fa-envelope-circle-check text-blue-400 text-3xl mb-2"></i>
                        <h3 class="text-white font-bold text-lg">Verify Your Email</h3>
                        <p class="text-sm text-slate-400 mt-1">We emailed you a 6-digit confirmation code.</p>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-300 mb-1.5 ml-1 text-center">Enter OTP Code</label>
                        <input type="text" id="otpCode" required maxlength="6" pattern="[0-9]{6}"
                            class="input-field w-full py-4 rounded-xl text-center text-2xl tracking-[1em] font-bold font-mono" placeholder="••••••">
                    </div>

                    <button type="submit" id="verifyBtn"
                        class="w-full bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-500 hover:to-teal-500 text-white py-3.5 rounded-xl font-bold flex items-center justify-center transition-all duration-300 transform shadow-lg shadow-emerald-500/25 group overflow-hidden relative">
                        <span id="verifyBtnText" class="relative">Verify Account</span>
                        <i id="verifyBtnIcon" class="fa-solid fa-check ml-2 relative group-hover:scale-110 transition-transform"></i>
                        <div id="verifyBtnLoader" class="loader hidden ml-2 relative"></div>
                    </button>
                </form>

                <div class="mt-8 text-center border-t border-slate-700/50 pt-6">
                    <p class="text-sm text-slate-400">
                        Already have an account?
                        <a href="/login" class="text-blue-400 hover:text-blue-300 font-semibold transition ml-1">Sign in
                            here</a>
                    </p>
                </div>
            </div>
        </div>

        <!-- API configuration & Scripts -->
        <script>
            // API Gateway URL
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

            // Handle Registration using AuthController via API Gateway
            async function handleRegister() {
                const username = document.getElementById('username').value.trim();
                const email = document.getElementById('email').value.trim();
                const mobileNumber = document.getElementById('mobileNumber').value.trim();
                const password = document.getElementById('password').value.trim();
                const btnText = document.getElementById('btnText');
                const btnLoader = document.getElementById('btnLoader');
                const btnIcon = document.getElementById('btnIcon');
                const btn = document.getElementById('registerBtn');

                if (!username || !email || !mobileNumber || !password) return;

                hideAlert();

                // Set Loading state
                btn.disabled = true;
                btnText.textContent = 'Creating Account...';
                btnLoader.classList.remove('hidden');
                btnIcon.classList.add('hidden');
                btn.classList.add('opacity-80', 'cursor-not-allowed');

                try {
                    // Fetching from API Gateway 8085 which routes to auth-service
                    const response = await fetch(`\${API_GATEWAY_URL}/auth/register`, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ username, email, mobileNumber, password })
                    });

                    if (!response.ok) {
                        const errText = await response.text();
                        if (errText.includes('Duplicate entry')) {
                            if (errText.includes(mobileNumber)) {
                                throw new Error('This mobile number is already registered.');
                            } else if (errText.includes(email)) {
                                throw new Error('This email address is already registered.');
                            } else {
                                throw new Error('A user with these details already exists.');
                            }
                        }
                        throw new Error(errText || 'Registration failed');
                    }

                    const responseText = await response.text();
                    showAlert('success', 'Registration Authorized. Awaiting Email Verification.');

                    // Hide Register, Show OTP
                    document.getElementById('registerForm').classList.add('hidden');
                    document.getElementById('otpForm').classList.remove('hidden');
                    
                    // Temporarily store email for OTP verification
                    window.pendingRegistrationEmail = email;

                } catch (err) {
                    showAlert('error', err.message || 'Connection failed. Ensure API Gateway is running on :8085');
                    // Reset Loading state
                    btn.disabled = false;
                    btnText.textContent = 'Sign Up';
                    btnLoader.classList.add('hidden');
                    btnIcon.classList.remove('hidden');
                    btn.classList.remove('opacity-80', 'cursor-not-allowed');
                }
            }

            // Handle OTP Verification
            async function handleOtpVerify() {
                const otpCode = document.getElementById('otpCode').value.trim();
                const btnText = document.getElementById('verifyBtnText');
                const btnLoader = document.getElementById('verifyBtnLoader');
                const btnIcon = document.getElementById('verifyBtnIcon');
                const btn = document.getElementById('verifyBtn');

                if (!otpCode || otpCode.length !== 6) return;

                hideAlert();
                btn.disabled = true;
                btnText.textContent = 'Verifying...';
                btnLoader.classList.remove('hidden');
                btnIcon.classList.add('hidden');
                btn.classList.add('opacity-80', 'cursor-not-allowed');

                try {
                    const response = await fetch(`\${API_GATEWAY_URL}/auth/verify-registration`, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ 
                            email: window.pendingRegistrationEmail, 
                            otp: otpCode 
                        })
                    });

                    if (!response.ok) {
                        const errText = await response.text();
                        throw new Error(errText || 'Invalid OTP Code');
                    }

                    showAlert('success', 'Account Verified! Redirecting to login...');
                    
                    setTimeout(() => {
                        window.location.href = '/login';
                    }, 2000);

                } catch (err) {
                    showAlert('error', err.message);
                    btn.disabled = false;
                    btnText.textContent = 'Verify Account';
                    btnLoader.classList.add('hidden');
                    btnIcon.classList.remove('hidden');
                    btn.classList.remove('opacity-80', 'cursor-not-allowed');
                }
            }
        </script>
    </body>

    </html>