<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <title>Swim 360 - Forgot Password</title>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #2563eb; }
        
        /* Standardized Entrance Animations */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-item { opacity: 0; animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .delay-0 { animation-delay: 0.1s; }
        .delay-1 { animation-delay: 0.2s; }
        .delay-2 { animation-delay: 0.3s; }
        .delay-3 { animation-delay: 0.4s; }
        .delay-4 { animation-delay: 0.5s; }
        .delay-5 { animation-delay: 0.6s; }

        .no-scrollbar::-webkit-scrollbar { display: none; }
        .shadow-blueprint { box-shadow: inset 0 2px 4px 0 rgba(0, 0, 0, 0.05); }

        /* Spinner for Loading State */
        .spinner {
            border: 2px solid rgba(0, 0, 0, 0.1);
            width: 20px; height: 20px;
            border-radius: 50%;
            border-left-color: #4b5563;
            animation: spin 1s linear infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
    </style>
</head>
<body class="flex items-center justify-center min-h-screen p-6 no-scrollbar">

    <div class="w-full max-w-md bg-white p-8 md:p-10 rounded-[40px] shadow-2xl animate-item text-center relative">
        
        <div class="animate-item delay-0 flex justify-center mb-6">
            <div class="w-16 h-16 bg-blue-50 rounded-[24px] flex items-center justify-center text-blue-600 shadow-inner">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-10 h-10" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                    <path d="M2 6c.6.5 1.2 1 2.5 1C5.8 7 7.2 6 8.5 6c1.3 0 2.7 1 4 1 1.3 0 2.7-1 4-1 1.3 0 2.7 1 3.5 1"></path>
                    <path d="M2 12c.6.5 1.2 1 2.5 1 1.3 0 2.7-1 4-1 1.3 0 2.7 1 4 1 1.3 0 2.7-1 4-1 1.3 0 2.7 1 3.5 1"></path>
                    <path d="M2 18c.6.5 1.2 1 2.5 1 1.3 0 2.7-1 4-1 1.3 0 2.7 1 4 1 1.3 0 2.7-1 4-1 1.3 0 2.7 1 3.5 1"></path>
                </svg>
            </div>
        </div>

        <h1 class="animate-item delay-1 text-3xl font-black text-gray-900 tracking-tight leading-none italic uppercase">
            Forgot Password?
        </h1>

        <p class="animate-item delay-2 text-xs font-bold text-gray-400 leading-relaxed px-4 mt-4 mb-8">
            Don't worry, it happens to everyone. Enter your email and we'll send you a reset link.
        </p>

        <form id="reset-form" onsubmit="event.preventDefault(); handleReset();" class="space-y-6 text-left">
            
            <div class="animate-item delay-3 space-y-2">
                <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest ml-1">Email Address</label>
                <div class="relative flex items-center group">
                    <svg xmlns="http://www.w3.org/2000/svg" class="absolute left-4 w-5 h-5 text-gray-300 group-focus-within:text-blue-600 transition-colors" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                        <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                        <polyline points="22,6 12,13 2,6"></polyline>
                    </svg>
                    <input id="email-input" type="email" required placeholder="you@example.com" 
                        class="w-full pl-12 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none shadow-blueprint transition-all">
                </div>
            </div>

            <div id="status-msg" class="animate-item delay-4 min-h-[20px] text-center hidden">
                <p class="text-[10px] font-black uppercase tracking-widest"></p>
            </div>

            <div class="animate-item delay-5">
                <button id="submit-btn" type="submit" class="w-full py-5 bg-blue-600 text-white rounded-[24px] font-black text-sm uppercase tracking-[0.2em] shadow-xl shadow-blue-600/20 active:scale-95 transition-all flex justify-center items-center">
                    <span id="btn-text">Reset Password</span>
                    <div id="btn-loader" class="hidden"><div class="spinner"></div></div>
                </button>
            </div>
        </form>

        <button onclick="window.history.back()" class="animate-item delay-5 mt-10 text-[10px] font-black text-blue-600 uppercase tracking-widest hover:underline underline-offset-4">
            Return to Sign in
        </button>

    </div>

    <div id="toast" class="fixed top-10 left-1/2 -translate-x-1/2 bg-gray-900 text-white px-8 py-4 rounded-full text-[10px] font-black shadow-2xl z-[100] hidden uppercase tracking-widest animate-bounce">
    </div>

    <script>
        function showToast(msg, isError = false) {
            const t = document.getElementById('toast');
            t.textContent = msg;
            t.className = `fixed top-10 left-1/2 -translate-x-1/2 px-8 py-4 rounded-full text-[10px] font-black shadow-2xl z-[100] uppercase tracking-widest animate-bounce ${isError ? 'bg-rose-600' : 'bg-gray-900'} text-white`;
            t.classList.remove('hidden');
            setTimeout(() => t.classList.add('hidden'), 3000);
        }

        function handleReset() {
            const email = document.getElementById('email-input').value;
            const btnText = document.getElementById('btn-text');
            const btnLoader = document.getElementById('btn-loader');
            const submitBtn = document.getElementById('submit-btn');
            const statusMsg = document.getElementById('status-msg');

            if (!email.includes('@')) {
                showToast("Invalid email address", true);
                return;
            }

            // Start Loading (matches Flutter _isLoading)
            btnText.classList.add('hidden');
            btnLoader.classList.remove('hidden');
            submitBtn.classList.add('opacity-50', 'pointer-events-none');

            // Simulate Network Delay (2 seconds)
            setTimeout(() => {
                btnLoader.classList.add('hidden');
                btnText.classList.remove('hidden');
                submitBtn.classList.remove('opacity-50', 'pointer-events-none');
                
                // Show Success
                statusMsg.classList.remove('hidden');
                statusMsg.querySelector('p').textContent = "A 6 digit code has been sent!";
                statusMsg.querySelector('p').className = "text-[10px] font-black uppercase tracking-widest text-emerald-500";
                
                showToast("Reset code sent!");
            }, 2000);
        }
    </script>
</body>
</html>