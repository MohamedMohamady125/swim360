<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <title>Swim 360 - Dashboard</title>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F3F4F6; color: #1F2937; }
        
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .view-animate { animation: fadeInUp 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        
        @keyframes notifyPulse {
            0% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.4); opacity: 0.7; }
            100% { transform: scale(1); opacity: 1; }
        }
        .notify-dot { animation: notifyPulse 2s infinite ease-in-out; }

        .no-scrollbar::-webkit-scrollbar { display: none; }
    </style>
</head>
<body class="flex flex-col min-h-screen no-scrollbar overflow-x-hidden">

    <header class="sticky top-0 z-50 bg-white/90 backdrop-blur-xl border-b border-gray-100 px-6 py-5 flex items-center justify-between">
        <button onclick="clearNotifications()" class="relative w-12 h-12 bg-amber-400 rounded-2xl flex items-center justify-center text-white shadow-lg shadow-amber-200/40 transition-all active:scale-90">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
            </svg>
            <span id="notif-dot" class="absolute -top-1 -right-1 w-4 h-4 bg-rose-500 rounded-full border-2 border-white notify-dot transition-all duration-300"></span>
        </button>

        <div class="flex flex-col items-center">
            <h2 class="text-xl font-black text-gray-900 uppercase italic tracking-tighter leading-none">Swim 360</h2>
            <div class="w-8 h-1 bg-blue-600 rounded-full mt-1 opacity-20"></div>
        </div>

        <div class="flex items-center space-x-3">
            <button class="w-12 h-12 bg-slate-100 rounded-2xl flex items-center justify-center text-slate-500 shadow-inner active:scale-90">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="3"></circle>
                    <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                </svg>
            </button>
            
            <div class="w-12 h-12 rounded-2xl overflow-hidden border-2 border-white shadow-lg active:scale-90 transition-all bg-gray-200">
                <img src="https://images.unsplash.com/photo-1530549387631-f535c7658f8c?w=100&h=100&fit=crop&q=80" alt="Profile" class="w-full h-full object-cover">
            </div>
        </div>
    </header>

    <main class="flex-grow p-6 pt-8" id="main-content">
        <div class="bg-white p-8 rounded-[40px] shadow-sm border border-gray-50 text-left view-animate">
            <h1 class="text-4xl font-black text-blue-600 uppercase italic tracking-tighter leading-none">Dashboard</h1>
            <p class="text-gray-400 text-[10px] font-black uppercase tracking-[0.2em] mt-3 italic">Interface Loaded</p>
            <p class="mt-8 text-sm font-bold text-gray-500 leading-relaxed">
                Tap the yellow notification bell to clear the active unread state.
            </p>
        </div>
    </main>

    <nav class="sticky bottom-0 bg-white border-t border-gray-100 px-6 py-4 flex justify-between items-center rounded-t-[32px] shadow-2xl z-50">
        <button class="flex flex-col items-center space-y-1 text-blue-600">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
            <span class="text-[10px] font-black uppercase tracking-widest">Home</span>
        </button>
        <button class="flex flex-col items-center space-y-1 text-gray-400"><svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg><span class="text-[10px] font-black uppercase tracking-widest">Profile</span></button>
    </nav>

    <script>
        let unreadCount = 5;

        function clearNotifications() {
            unreadCount = 0;
            const dot = document.getElementById('notif-dot');
            dot.style.opacity = '0';
            dot.style.transform = 'scale(0)';
            setTimeout(() => dot.classList.add('hidden'), 300);
            console.log("Notifications Cleared");
        }
    </script>
</body>
</html>