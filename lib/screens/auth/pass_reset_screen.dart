<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <title>Swim 360 - Reset Password</title>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #2563eb; }
        
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-in { animation: fadeInUp 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .shadow-blueprint { box-shadow: inset 0 2px 4px 0 rgba(0, 0, 0, 0.05); }

        /* Strength Meter Transitions */
        #strength-bar { transition: width 0.4s ease, background-color 0.4s ease; }
    </style>
</head>
<body class="flex items-center justify-center min-h-screen p-6 no-scrollbar">

    <div class="w-full max-w-md bg-white p-8 md:p-10 rounded-[40px] shadow-2xl animate-in text-center relative">
        
        <div class="flex justify-center mb-6">
            <div class="w-16 h-16 bg-blue-50 rounded-[24px] flex items-center justify-center text-blue-600 shadow-inner">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-10 h-10" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                    <path d="M2 6c.6.5 1.2 1 2.5 1C5.8 7 7.2 6 8.5 6c1.3 0 2.7 1 4 1 1.3 0 2.7-1 4-1 1.3 0 2.7 1 3.5 1"></path>
                    <path d="M2 12c.6.5 1.2 1 2.5 1 1.3 0 2.7-1 4-1 1.3 0 2.7 1 4 1 1.3 0 2.7-1 4-1 1.3 0 2.7 1 3.5 1"></path>
                    <path d="M2 18c.6.5 1.2 1 2.5 1 1.3 0 2.7-1 4-1 1.3 0 2.7 1 4 1 1.3 0 2.7-1 4-1 1.3 0 2.7 1 3.5 1"></path>
                </svg>
            </div>
        </div>

        <h1 class="text-3xl font-black text-gray-900 tracking-tight leading-none italic uppercase">
            New Password
        </h1>
        <p class="text-[10px] font-black text-gray-400 uppercase tracking-[0.3em] mt-3 mb-8">
            Secure your credentials
        </p>

        <form id="reset-form" onsubmit="event.preventDefault(); handleFinalReset();" class="space-y-5 text-left">
            
            <div class="space-y-1.5">
                <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest ml-1">Account Email</label>
                <div class="p-4 bg-gray-50/50 border border-gray-100 rounded-2xl opacity-60">
                    <p class="text-sm font-bold text-gray-400">user@example.com</p>
                </div>
            </div>

            <div class="space-y-1.5">
                <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest ml-1">New Password</label>
                <div class="relative flex items-center group">
                    <svg xmlns="http://www.w3.org/2000/svg" class="absolute left-4 w-5 h-5 text-gray-300 group-focus-within:text-blue-600 transition-colors" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                    </svg>
                    <input type="password" id="new-pass" required placeholder="••••••••" oninput="updateStrength(this.value)"
                        class="w-full pl-12 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none shadow-blueprint transition-all">
                </div>
                
                <div class="pt-2 px-1">
                    <div class="flex justify-between items-center mb-1.5">
                        <span class="text-[8px] font-black text-gray-400 uppercase tracking-widest">Strength</span>
                        <span id="strength-text" class="text-[8px] font-black uppercase tracking-widest text-gray-300">None</span>
                    </div>
                    <div class="w-full h-1.5 bg-gray-100 rounded-full overflow-hidden">
                        <div id="strength-bar" class="h-full w-0 bg-gray-300 transition-all duration-500"></div>
                    </div>
                </div>
            </div>

            <div class="space-y-1.5">
                <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest ml-1">Confirm Password</label>
                <div class="relative flex items-center group">
                    <svg xmlns="http://www.w3.org/2000/svg" class="absolute left-4 w-5 h-5 text-gray-300 group-focus-within:text-blue-600 transition-colors" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                    </svg>
                    <input type="password" id="confirm-pass" required placeholder="••••••••" 
                        class="w-full pl-12 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none shadow-blueprint transition-all">
                </div>
            </div>

            <div class="pt-4">
                <button type="submit" class="w-full py-5 bg-blue-600 text-white rounded-[24px] font-black text-sm uppercase tracking-[0.2em] shadow-xl shadow-blue-600/20 active:scale-95 transition-all">
                    Reset Password
                </button>
            </div>
        </form>

        <button onclick="window.history.back()" class="mt-8 text-[10px] font-black text-blue-600 uppercase tracking-widest hover:underline underline-offset-4">
            Return to Sign in
        </button>

    </div>

    <div id="toast" class="fixed top-10 left-1/2 -translate-x-1/2 bg-gray-900 text-white px-8 py-4 rounded-full text-[10px] font-black shadow-2xl z-[100] hidden uppercase tracking-widest animate-bounce">
    </div>

    <script>
        function showToast(msg, isError = false) {
            const t = document.getElementById('toast');
            t.textContent = msg;
            t.className = `fixed top-10 left-1/2 -translate-x-1/2 px-8 py-4 rounded-full text-[10px] font-black shadow-2xl z-[100] uppercase animate-bounce ${isError ? 'bg-rose-600' : 'bg-gray-900'} text-white tracking-widest`;
            t.classList.remove('hidden');
            setTimeout(() => t.classList.add('hidden'), 3000);
        }

        function updateStrength(p) {
            const bar = document.getElementById('strength-bar');
            const text = document.getElementById('strength-text');
            
            let strength = 0;
            if (p.length >= 8) {
                if (/[a-zA-Z]/.test(p) && /[0-9]/.test(p) && /[A-Z]/.test(p) && /[^A-Za-z0-9]/.test(p)) strength = 3;
                else if (/[a-zA-Z]/.test(p) && /[0-9]/.test(p)) strength = 2;
                else strength = 1;
            } else if (p.length > 0) {
                strength = 1;
            }

            switch(strength) {
                case 3:
                    bar.style.width = '100%'; bar.style.backgroundColor = '#10b981';
                    text.textContent = 'Strong'; text.className = 'text-[8px] font-black uppercase tracking-widest text-emerald-500';
                    break;
                case 2:
                    bar.style.width = '66%'; bar.style.backgroundColor = '#facc15';
                    text.textContent = 'Fair'; text.className = 'text-[8px] font-black uppercase tracking-widest text-yellow-500';
                    break;
                case 1:
                    bar.style.width = '33%'; bar.style.backgroundColor = '#f43f5e';
                    text.textContent = 'Weak'; text.className = 'text-[8px] font-black uppercase tracking-widest text-rose-500';
                    break;
                default:
                    bar.style.width = '0%'; bar.style.backgroundColor = '#E2E8F0';
                    text.textContent = 'None'; text.className = 'text-[8px] font-black uppercase tracking-widest text-gray-300';
            }
        }

        function handleFinalReset() {
            const p1 = document.getElementById('new-pass').value;
            const p2 = document.getElementById('confirm-pass').value;
            const strength = document.getElementById('strength-text').textContent;

            if (p1 !== p2) {
                showToast("Passwords do not match", true);
                return;
            }
            if (strength === 'Weak' || strength === 'None') {
                showToast("Password too weak", true);
                return;
            }

            showToast("Password Reset Successful!");
            setTimeout(() => window.history.back(), 2000);
        }
    </script>
</body>
</html>