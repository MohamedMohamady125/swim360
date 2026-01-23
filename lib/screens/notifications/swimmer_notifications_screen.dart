<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - Notifications</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F8FAFC; color: #0F172A; }
        
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-in { animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        
        .no-scrollbar::-webkit-scrollbar { display: none; }
        
        .notif-card {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border-radius: 28px;
        }
        .notif-card:active { transform: scale(0.97); }
        
        /* Bottom Sheet Transition */
        .modal-sheet {
            transform: translateY(100%);
            transition: transform 0.5s cubic-bezier(0.32, 0.72, 0, 1);
        }
        .modal-overlay.active .modal-sheet { transform: translateY(0); }
        
        .unread-pulse {
            box-shadow: 0 0 0 0 rgba(37, 99, 235, 0.7);
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            70% { box-shadow: 0 0 0 10px rgba(37, 99, 235, 0); }
            100% { box-shadow: 0 0 0 0 rgba(37, 99, 235, 0); }
        }
    </style>
</head>
<body class="no-scrollbar">

    <div class="max-w-md mx-auto min-h-screen pb-10">
        <header class="px-6 pt-12 pb-6 flex items-center justify-between bg-white/90 backdrop-blur-xl border-b border-slate-50 sticky top-0 z-40">
            <div class="flex items-center space-x-4">
                <button onclick="window.history.back()" class="p-2.5 bg-slate-50 rounded-2xl text-slate-600 active:scale-90 transition-transform">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path d="M15 18l-6-6 6-6"/></svg>
                </button>
                <div>
                    <h1 class="text-2xl font-black text-slate-900 tracking-tight leading-none uppercase italic">Updates</h1>
                    <p id="unread-counter" class="text-[10px] font-black text-blue-600 uppercase tracking-widest mt-1.5">2 New Updates</p>
                </div>
            </div>
            <button onclick="markAllRead()" class="p-3 bg-blue-50 text-blue-600 rounded-2xl active:scale-95 transition-all">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path d="M20 6L9 17l-5-5M15 6l-6 6"/></svg>
            </button>
        </header>

        <main class="p-5">
            <div class="flex space-x-3 overflow-x-auto no-scrollbar pb-6" id="filter-container">
                <button onclick="setFilter('all')" class="filter-tab px-6 py-3 rounded-2xl text-[10px] font-black uppercase tracking-widest bg-slate-900 text-white shadow-xl shadow-slate-900/10 whitespace-nowrap">All</button>
                <button onclick="setFilter('unread')" class="filter-tab px-6 py-3 rounded-2xl text-[10px] font-black uppercase tracking-widest bg-white text-slate-400 border border-slate-100 whitespace-nowrap">Unread</button>
                <button onclick="setFilter('bookings')" class="filter-tab px-6 py-3 rounded-2xl text-[10px] font-black uppercase tracking-widest bg-white text-slate-400 border border-slate-100 whitespace-nowrap">Bookings</button>
                <button onclick="setFilter('orders')" class="filter-tab px-6 py-3 rounded-2xl text-[10px] font-black uppercase tracking-widest bg-white text-slate-400 border border-slate-100 whitespace-nowrap">Orders</button>
            </div>

            <div id="notif-list" class="space-y-4">
                </div>
        </main>
    </div>

    <div id="notif-overlay" class="modal-overlay fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm hidden flex items-end justify-center" onclick="closeNotif()">
        <div class="modal-sheet bg-white w-full max-w-sm rounded-t-[44px] p-8 shadow-2xl relative overflow-hidden" onclick="event.stopPropagation()">
            <div class="w-12 h-1.5 bg-slate-100 rounded-full mx-auto mb-10 shadow-inner"></div>
            
            <div id="modal-icon-bg" class="w-20 h-20 rounded-3xl flex items-center justify-center shadow-lg mb-8">
                </div>

            <div class="space-y-4 text-left">
                <p class="text-[10px] font-black text-blue-600 uppercase tracking-widest leading-none">Notification Detail</p>
                <h2 id="modal-title" class="text-3xl font-black text-slate-900 leading-tight uppercase italic tracking-tighter">Title</h2>
                <p id="modal-message" class="text-sm text-slate-500 font-medium leading-relaxed">Message goes here...</p>
                
                <div class="flex items-center space-x-2 text-[10px] font-black text-slate-300 uppercase tracking-widest pt-4">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>
                    <span id="modal-time">Received 2m ago</span>
                </div>
            </div>

            <div class="pt-10 space-y-4">
                <button onclick="closeNotif()" class="w-full py-5 bg-slate-900 text-white rounded-[24px] font-black text-xs uppercase tracking-[0.2em] shadow-xl active:scale-95 transition-all">View Related Activity</button>
                <button onclick="closeNotif()" class="w-full py-3 text-slate-400 font-black text-[10px] uppercase tracking-widest">Dismiss</button>
            </div>
        </div>
    </div>

    <script>
        const INITIAL_DATA = [
            { id: 'n1', type: 'order', title: 'Order Out for Delivery', message: 'Your Pro Racing Goggles are on the way! Estimated arrival by 6:00 PM today.', time: '2m ago', isRead: false, color: '#f97316', icon: '<path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"/><path d="m3.3 7 8.7 5 8.7-5"/><path d="M12 22V12"/>' },
            { id: 'n2', type: 'academy', title: 'Class Reminder', message: 'Friendly reminder: Your Intermediate Squad session starts in 2 hours.', time: '1h ago', isRead: false, color: '#2563eb', icon: '<path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3.33 3 8.67 3 12 0v-5"/>' },
            { id: 'n3', type: 'online', title: 'New Content', message: 'Coach Michael Thorne just uploaded "Week 4: Advanced Breathing".', time: '3h ago', isRead: true, color: '#7c3aed', icon: '<path d="m22 8-6 4 6 4V8Z"/><rect width="14" height="12" x="2" y="6" rx="2" ry="2"/>' },
            { id: 'n4', type: 'event', title: 'Result Published', message: 'The official times for the Regional Championship 2026 are now available.', time: 'Yesterday', isRead: true, color: '#e11d48', icon: '<path d="M6 9H4.5a2.5 2.5 0 0 1 0-5H6"/><path d="M18 9h1.5a2.5 2.5 0 0 0 0-5H18"/><path d="M4 22h16"/><path d="M10 14.66V17c0 .55-.47.98-.97 1.21C7.85 18.75 7 20.24 7 22"/><path d="M14 14.66V17c0 .55.47.98.97 1.21C16.15 18.75 17 20.24 17 22"/><path d="M18 2H6v7a6 6 0 0 0 12 0V2Z"/>' }
        ];

        let currentFilter = 'all';

        function renderNotifs() {
            const container = document.getElementById('notif-list');
            const unreadCounter = document.getElementById('unread-counter');
            
            const filtered = INITIAL_DATA.filter(n => {
                if (currentFilter === 'unread') return !n.isRead;
                if (currentFilter === 'orders') return n.type === 'order';
                if (currentFilter === 'bookings') return ['academy', 'clinic', 'event'].includes(n.type);
                return true;
            });

            const unreadCount = INITIAL_DATA.filter(n => !n.isRead).length;
            unreadCounter.innerText = unreadCount > 0 ? `${unreadCount} New Update${unreadCount > 1 ? 's' : ''}` : 'All caught up';

            container.innerHTML = filtered.map((n, index) => `
                <div onclick="openNotif('${n.id}')" class="notif-card p-5 bg-white border ${n.isRead ? 'border-slate-50 opacity-60' : 'border-blue-100 shadow-xl shadow-blue-600/5 ring-1 ring-blue-50'} flex items-start space-x-4 animate-in" style="animation-delay: ${index * 0.1}s">
                    <div class="relative flex-shrink-0">
                        <div class="w-12 h-12 rounded-2xl flex items-center justify-center" style="background-color: ${n.color}15; color: ${n.color}">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">${n.icon}</svg>
                        </div>
                        ${!n.isRead ? '<span class="absolute -top-1 -right-1 w-3.5 h-3.5 bg-blue-600 rounded-full border-2 border-white unread-pulse"></span>' : ''}
                    </div>
                    <div class="flex-grow min-w-0 text-left">
                        <div class="flex justify-between items-start">
                            <h3 class="text-sm font-black text-slate-900 leading-none uppercase italic tracking-tighter truncate">${n.title}</h3>
                            <span class="text-[8px] font-black text-slate-300 uppercase tracking-widest whitespace-nowrap ml-2">${n.time}</span>
                        </div>
                        <p class="text-[11px] mt-2 leading-relaxed text-slate-500 font-medium line-clamp-2">${n.message}</p>
                    </div>
                </div>
            `).join('');
        }

        function setFilter(f) {
            currentFilter = f;
            document.querySelectorAll('.filter-tab').forEach(btn => {
                const isActive = btn.innerText.toLowerCase() === f;
                btn.className = `filter-tab px-6 py-3 rounded-2xl text-[10px] font-black uppercase tracking-widest whitespace-nowrap transition-all ${isActive ? 'bg-slate-900 text-white shadow-xl' : 'bg-white text-slate-400 border border-slate-100'}`;
            });
            renderNotifs();
        }

        function openNotif(id) {
            const n = INITIAL_DATA.find(x => x.id === id);
            n.isRead = true;
            
            document.getElementById('modal-title').innerText = n.title;
            document.getElementById('modal-message').innerText = n.message;
            document.getElementById('modal-time').innerText = `Received ${n.time}`;
            
            const iconBg = document.getElementById('modal-icon-bg');
            iconBg.style.backgroundColor = `${n.color}15`;
            iconBg.style.color = n.color;
            iconBg.innerHTML = `<svg class="w-10 h-10" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">${n.icon}</svg>`;

            const overlay = document.getElementById('notif-overlay');
            overlay.classList.remove('hidden');
            overlay.classList.add('flex');
            setTimeout(() => overlay.classList.add('active'), 10);
            renderNotifs();
        }

        function closeNotif() {
            const overlay = document.getElementById('notif-overlay');
            overlay.classList.remove('active');
            setTimeout(() => {
                overlay.classList.remove('flex');
                overlay.classList.add('hidden');
            }, 500);
        }

        function markAllRead() {
            INITIAL_DATA.forEach(n => n.isRead = true);
            renderNotifs();
        }

        window.onload = renderNotifs;
    </script>
</body>
</html>