<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <title>Swim 360 - Verify Code</title>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #2563eb; }
        
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-in { animation: fadeInUp 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        
        /* OTP Input focus handling */
        .otp-input:focus {
            background-color: #f0f9ff;
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        /* Spinner */
        .spinner {
            border: 2px solid rgba(255, 255, 255, 0.3);
            width: 16px; height: 16px;
            border-radius: 50%;
            border-left-color: white;
            animation: spin 1s linear infinite;
        }
        .spinner-blue { border-left-color: #2563eb; border-top-color: rgba(37,99,235,0.1); }
        @keyframes spin { to { transform: rotate(360deg); } }
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
            Reset Code
        </h1>
        <p class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] mt-3 mb-8">
            Check your email inbox
        </p>

        <div class="flex justify-between gap-2 mb-6" id="otp-group">
            <input type="text" maxlength="1" class="otp-input w-12 h-14 text-center text-xl font-black text-gray-900 bg-gray-50 border-none rounded-xl shadow-inner outline-none transition-all">
            <input type="text" maxlength="1" class="otp-input w-12 h-14 text-center text-xl font-black text-gray-900 bg-gray-50 border-none rounded-xl shadow-inner outline-none transition-all">
            <input type="text" maxlength="1" class="otp-input w-12 h-14 text-center text-xl font-black text-gray-900 bg-gray-50 border-none rounded-xl shadow-inner outline-none transition-all">
            <input type="text" maxlength="1" class="otp-input w-12 h-14 text-center text-xl font-black text-gray-900 bg-gray-50 border-none rounded-xl shadow-inner outline-none transition-all">
            <input type="text" maxlength="1" class="otp-input w-12 h-14 text-center text-xl font-black text-gray-900 bg-gray-50 border-none rounded-xl shadow-inner outline-none transition-all">
            <input type="text" maxlength="1" class="otp-input w-12 h-14 text-center text-xl font-black text-gray-900 bg-gray-50 border-none rounded-xl shadow-inner outline-none transition-all">
        </div>

        <div class="mb-8">
            <button id="resend-btn" onclick="handleResend()" class="group inline-flex items-center text-[10px] font-black text-gray-400 uppercase tracking-widest hover:text-blue-600 transition-colors">
                <span id="resend-text">Resend Code</span>
                <div id="resend-spinner" class="ml-2 hidden"><div class="spinner spinner-blue !w-3 !h-3"></div></div>
            </button>
        </div>

        <div id="status-msg" class="min-h-[20px] mb-6 hidden">
            <p class="text-[10px] font-black uppercase tracking-widest text-emerald-500"></p>
        </div>

        <button id="verify-btn" onclick="handleVerify()" class="w-full py-5 bg-blue-600 text-white rounded-[24px] font-black text-sm uppercase tracking-[0.2em] shadow-xl shadow-blue-600/20 active:scale-95 transition-all flex justify-center items-center">
            <span id="verify-text">Verify Code</span>
            <div id="verify-spinner" class="hidden"><div class="spinner"></div></div>
        </button>

        <button onclick="window.history.back()" class="mt-8 text-[10px] font-black text-blue-600 uppercase tracking-widest hover:underline underline-offset-4">
            Return to Sign in
        </button>

    </div>

    <script>
        // OTP Auto-focus logic
        const inputs = document.querySelectorAll('.otp-input');
        inputs.forEach((input, index) => {
            input.oninput = (e) => {
                if (e.target.value && index < inputs.length - 1) inputs[index + 1].focus();
            };
            input.onkeydown = (e) => {
                if (e.key === 'Backspace' && !e.target.value && index > 0) inputs[index - 1].focus();
            };
        });

        function handleResend() {
            const text = document.getElementById('resend-text');
            const spinner = document.getElementById('resend-spinner');
            const status = document.getElementById('status-msg');

            text.textContent = "Sending...";
            spinner.classList.remove('hidden');
            
            setTimeout(() => {
                text.textContent = "Resend Code";
                spinner.classList.add('hidden');
                status.classList.remove('hidden');
                status.querySelector('p').textContent = "New code sent to your email!";
            }, 2000);
        }

        function handleVerify() {
            const btnText = document.getElementById('verify-text');
            const spinner = document.getElementById('verify-spinner');
            const btn = document.getElementById('verify-btn');
            const status = document.getElementById('status-msg');

            btnText.classList.add('hidden');
            spinner.classList.remove('hidden');
            btn.classList.add('opacity-50', 'pointer-events-none');

            setTimeout(() => {
                spinner.classList.add('hidden');
                btnText.classList.remove('hidden');
                btnText.textContent = "Verified!";
                btn.classList.remove('opacity-50', 'pointer-events-none');
                btn.classList.replace('bg-blue-600', 'bg-emerald-500');
                
                status.classList.remove('hidden');
                status.querySelector('p').textContent = "Success! Identity Confirmed.";
                status.querySelector('p').className = "text-[10px] font-black uppercase tracking-widest text-emerald-500";
            }, 2000);
        }
    </script>
</body>
</html>