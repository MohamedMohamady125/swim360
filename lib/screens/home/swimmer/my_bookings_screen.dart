<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - My Bookings</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap');
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: #F8FAFC;
            -webkit-tap-highlight-color: transparent;
            color: #0f172a;
        }

        .premium-shadow {
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.03);
        }

        /* Digital Ticket Aesthetics */
        .ticket-card {
            background: white;
            position: relative;
            border-radius: 28px;
            transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            overflow: hidden;
        }

        .ticket-card:active {
            transform: scale(0.97);
        }

        /* Perforated holes on the sides */
        .ticket-card::before, .ticket-card::after {
            content: '';
            position: absolute;
            left: -12px;
            top: 68%;
            width: 24px;
            height: 24px;
            background-color: #F8FAFC;
            border-radius: 50%;
            z-index: 10;
        }

        .ticket-card::after {
            left: auto;
            right: -12px;
        }

        .ticket-divider {
            position: absolute;
            top: 72%;
            left: 24px;
            right: 24px;
            border-top: 2px dashed #f1f5f9;
        }

        /* Color-Coded Accents */
        .card-academy { border-top: 8px solid #2563eb; }
        .card-clinic { border-top: 8px solid #10b981; }
        .card-event { border-top: 8px solid #ef4444; }

        .bg-academy { background-color: #eff6ff; color: #1e40af; }
        .bg-clinic { background-color: #ecfdf5; color: #065f46; }
        .bg-event { background-color: #fef2f2; color: #991b1b; }

        /* Filter Chips */
        .filter-chip {
            padding: 10px 20px;
            border-radius: 16px;
            font-size: 0.85rem;
            font-weight: 800;
            white-space: nowrap;
            transition: all 0.2s;
            background: white;
            color: #94a3b8;
            border: 2px solid #f1f5f9;
        }

        .filter-chip.active {
            background: #0f172a;
            color: white;
            border-color: #0f172a;
            box-shadow: 0 10px 15px -3px rgba(15, 23, 42, 0.2);
        }

        .whatsapp-brand {
            background-color: #25D366;
            box-shadow: 0 10px 20px -5px rgba(37, 211, 102, 0.4);
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .animate-item {
            opacity: 0;
            animation: fadeInUp 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }

        .hide-scrollbar::-webkit-scrollbar { display: none; }
        .hide-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
    </style>
</head>
<body class="max-w-md mx-auto min-h-screen pb-20">

    <!-- Premium Header -->
    <header class="px-6 pt-12 pb-6 flex items-center justify-between sticky top-0 bg-white/90 backdrop-blur-xl z-30 border-b border-slate-50">
        <div class="flex items-center space-x-4">
            <button onclick="window.history.back()" class="p-2 -ml-2 hover:bg-slate-100 rounded-full transition text-slate-800">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15 19l-7-7 7-7"></path></svg>
            </button>
            <h1 class="text-2xl font-black text-slate-900 tracking-tight">My Bookings</h1>
        </div>
        <div class="w-10 h-10 rounded-full overflow-hidden border-2 border-blue-100 shadow-sm">
            <img src="https://placehold.co/100x100/2563eb/white?text=Y" alt="Profile">
        </div>
    </header>

    <!-- History/Upcoming Switcher -->
    <div class="px-6 mt-8 flex space-x-8">
        <button onclick="setTab('upcoming')" id="tab-upcoming" class="group pb-2 relative">
            <span class="text-xl font-black text-blue-600 transition-colors" id="text-upcoming">Upcoming</span>
            <div id="line-upcoming" class="absolute bottom-0 left-0 w-8 h-1.5 bg-blue-600 rounded-full transition-all"></div>
        </button>
        <button onclick="setTab('past')" id="tab-past" class="group pb-2 relative">
            <span class="text-xl font-black text-slate-300 transition-colors" id="text-past">History</span>
            <div id="line-past" class="absolute bottom-0 left-0 w-0 h-1.5 bg-blue-600 rounded-full transition-all"></div>
        </button>
    </div>

    <!-- Category Filters -->
    <div class="flex space-x-3 overflow-x-auto px-6 py-6 hide-scrollbar">
        <button onclick="setFilter('all')" class="filter-chip active" id="filter-all">All Bookings</button>
        <button onclick="setFilter('academy')" class="filter-chip" id="filter-academy">Academies</button>
        <button onclick="setFilter('clinic')" class="filter-chip" id="filter-clinic">Clinics</button>
        <button onclick="setFilter('event')" class="filter-chip" id="filter-event">Events</button>
    </div>

    <!-- Bookings List -->
    <main class="px-6 space-y-6" id="bookings-container">
        <!-- Rendered by JS -->
    </main>

    <!-- Bottom Sheet Modal -->
    <div id="modal-overlay" class="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm hidden flex items-end justify-center" onclick="closeModal()">
        <div id="modal-content" class="bg-white w-full max-w-md rounded-t-[40px] p-8 shadow-2xl transition-transform transform translate-y-full" onclick="event.stopPropagation()">
            <div class="w-12 h-1.5 bg-slate-100 rounded-full mx-auto mb-10"></div>
            <div id="modal-body" class="space-y-8">
                <!-- Content injected by JS -->
            </div>
        </div>
    </div>

    <script>
        const myBookings = [
            { id: 'b1', type: 'clinic', name: 'Physiotherapy Assessment', date: 'Mon, Oct 24', time: '4:00 PM', location: 'Olympic Aquatic Center', status: 'confirmed', provider: 'AquaHealth Recovery Clinic' },
            { id: 'b2', type: 'academy', name: 'Advanced Stroke Analysis', date: 'Wed, Oct 26', time: '10:30 AM', location: 'Family Park Academy', status: 'confirmed', provider: 'Elite Performance Academy' },
            { id: 'b3', type: 'event', name: 'National Junior Open', date: 'Sun, Nov 15', time: '9:00 AM', location: 'City Sports Arena', status: 'confirmed', provider: 'Regional Swim Federation' },
            { id: 'b4', type: 'clinic', name: 'Hydrotherapy Session', date: 'Sep 12', time: '5:00 PM', location: 'West Side Academy', status: 'completed', provider: 'Dynamic Rehab Specialists' },
            { id: 'b5', type: 'academy', name: 'Intermediate Squad', date: 'Fri, Nov 01', time: '5:00 PM', location: 'Training Center', status: 'confirmed', provider: 'Blue Wave Academy' }
        ];

        let currentTab = 'upcoming';
        let currentFilter = 'all';

        function setTab(tab) {
            currentTab = tab;
            const isUp = tab === 'upcoming';
            
            document.getElementById('text-upcoming').className = `text-xl font-black transition-colors ${isUp ? 'text-blue-600' : 'text-slate-300'}`;
            document.getElementById('text-past').className = `text-xl font-black transition-colors ${!isUp ? 'text-blue-600' : 'text-slate-300'}`;
            
            document.getElementById('line-upcoming').style.width = isUp ? '32px' : '0';
            document.getElementById('line-past').style.width = !isUp ? '32px' : '0';
            
            renderBookings();
        }

        function setFilter(filter) {
            currentFilter = filter;
            document.querySelectorAll('.filter-chip').forEach(chip => {
                chip.classList.toggle('active', chip.id === `filter-${filter}`);
            });
            renderBookings();
        }

        function renderBookings() {
            const container = document.getElementById('bookings-container');
            const filtered = myBookings.filter(b => {
                const tabMatch = currentTab === 'upcoming' ? b.status === 'confirmed' : b.status === 'completed';
                const filterMatch = currentFilter === 'all' || b.type === currentFilter;
                return tabMatch && filterMatch;
            });

            if (filtered.length === 0) {
                container.innerHTML = `
                    <div class="py-20 text-center opacity-30">
                        <svg class="w-16 h-16 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                        <p class="font-bold">Nothing found here</p>
                    </div>`;
                return;
            }

            container.innerHTML = filtered.map((booking, idx) => `
                <div class="ticket-card card-${booking.type} premium-shadow p-6 flex flex-col cursor-pointer animate-item" 
                     style="animation-delay: ${idx * 0.1}s"
                     onclick="openDetails('${booking.id}')">
                    
                    <div class="flex justify-between items-start mb-10">
                        <div class="space-y-1">
                            <span class="text-[10px] font-black px-2.5 py-1 rounded-lg uppercase tracking-widest bg-${booking.type}">${booking.type}</span>
                            <h3 class="text-xl font-black text-slate-900 mt-2">${booking.name}</h3>
                            <p class="text-xs font-bold text-slate-400 uppercase tracking-tight">${booking.provider}</p>
                        </div>
                        <div class="w-12 h-12 rounded-2xl bg-slate-50 flex items-center justify-center text-slate-400 group-hover:text-blue-600 transition-colors">
                             <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M13 7l5 5m0 0l-5 5m5-5H6"></path></svg>
                        </div>
                    </div>
                    
                    <div class="ticket-divider"></div>
                    
                    <div class="mt-14 flex items-center justify-between">
                        <div class="flex items-center space-x-6">
                            <div>
                                <p class="text-[9px] font-black text-slate-300 uppercase tracking-widest mb-0.5">Date</p>
                                <p class="text-sm font-black text-slate-800">${booking.date}</p>
                            </div>
                            <div class="w-px h-8 bg-slate-100"></div>
                            <div>
                                <p class="text-[9px] font-black text-slate-300 uppercase tracking-widest mb-0.5">Time</p>
                                <p class="text-sm font-black text-slate-800">${booking.time}</p>
                            </div>
                        </div>
                        <div class="flex items-center space-x-1 text-emerald-500">
                             <div class="w-2 h-2 bg-emerald-500 rounded-full animate-pulse"></div>
                             <span class="text-[10px] font-black uppercase tracking-tighter">${booking.status}</span>
                        </div>
                    </div>
                </div>
            `).join('');
        }

        function openDetails(id) {
            const booking = myBookings.find(b => b.id === id);
            const body = document.getElementById('modal-body');
            
            body.innerHTML = `
                <div class="space-y-1 text-center">
                    <span class="text-[10px] font-black px-3 py-1 rounded-full uppercase tracking-widest bg-${booking.type}">${booking.type}</span>
                    <h2 class="text-3xl font-black text-slate-900 leading-tight pt-2">${booking.name}</h2>
                    <p class="text-slate-500 font-bold text-sm">${booking.provider}</p>
                </div>

                <div class="grid grid-cols-1 gap-4">
                    <div class="p-6 bg-slate-50 rounded-3xl flex items-center space-x-5 border border-slate-100">
                        <div class="w-12 h-12 bg-white rounded-2xl flex items-center justify-center text-blue-500 shadow-sm">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                        </div>
                        <div>
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em]">My bookings-container</p>
                            <p class="text-lg font-black text-slate-800">${booking.date} at ${booking.time}</p>
                        </div>
                    </div>
                    <div class="p-6 bg-slate-50 rounded-3xl flex items-center space-x-5 border border-slate-100">
                        <div class="w-12 h-12 bg-white rounded-2xl flex items-center justify-center text-blue-500 shadow-sm">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.828 0l-4.243-4.243a8 8 0 1111.314 0z"></path></svg>
                        </div>
                        <div>
                            <p class="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em]">Location</p>
                            <p class="text-lg font-black text-slate-800">${booking.location}</p>
                        </div>
                    </div>
                </div>

                <div class="space-y-4 pt-4">
                    <a href="https://wa.me/1234567890" target="_blank" class="w-full py-5 whatsapp-brand text-white rounded-[24px] font-black flex items-center justify-center shadow-xl active:scale-95 transition-transform">
                        <svg class="w-6 h-6 mr-3" fill="currentColor" viewBox="0 0 24 24"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L0 24l6.335-1.662c1.883 1.027 3.909 1.564 5.968 1.564h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/></svg>
                        Chat with Support
                    </a>
                    <button onclick="closeModal()" class="w-full py-4 text-slate-400 font-bold hover:text-slate-600 transition-colors">
                        Close
                    </button>
                </div>
            `;

            const overlay = document.getElementById('modal-overlay');
            const content = document.getElementById('modal-content');
            
            overlay.classList.remove('hidden');
            setTimeout(() => {
                content.classList.remove('translate-y-full');
            }, 10);
        }

        function closeModal() {
            const overlay = document.getElementById('modal-overlay');
            const content = document.getElementById('modal-content');
            
            content.classList.add('translate-y-full');
            setTimeout(() => {
                overlay.classList.add('hidden');
            }, 400);
        }

        window.onload = renderBookings;
    </script>
</body>
</html>