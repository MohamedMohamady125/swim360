<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - My Programs</title>
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

        /* Program Card Styling */
        .program-card {
            background: white;
            border-radius: 28px;
            transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            overflow: hidden;
            border: 1px solid #f1f5f9;
        }

        .program-card:active {
            transform: scale(0.97);
        }

        /* Progress Bar */
        .progress-container {
            height: 8px;
            background-color: #f1f5f9;
            border-radius: 99px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            border-radius: 99px;
            transition: width 1s ease-out;
        }

        .fill-academy { background: linear-gradient(90deg, #3b82f6, #2563eb); }
        .fill-coach { background: linear-gradient(90deg, #8b5cf6, #7c3aed); }

        /* Category Accents */
        .accent-academy { border-top: 6px solid #2563eb; }
        .accent-coach { border-top: 6px solid #8b5cf6; }

        /* Tab Switcher */
        .tab-indicator {
            height: 3px;
            width: 24px;
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(15px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .animate-item {
            opacity: 0;
            animation: fadeInUp 0.5s ease-out forwards;
        }

        .hide-scrollbar::-webkit-scrollbar { display: none; }
        .hide-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }

        .modal-sheet {
            transition: transform 0.4s cubic-bezier(0.32, 0.72, 0, 1);
        }
        
        .whatsapp-green {
            background-color: #25D366;
        }

        /* Session Item Styling */
        .session-item {
            border-left: 3px solid #e2e8f0;
            position: relative;
            padding-left: 20px;
        }
        .session-item.completed { border-color: #10b981; }
        .session-item.upcoming { border-color: #3b82f6; }
        
        .session-dot {
            position: absolute;
            left: -7px;
            top: 4px;
            width: 11px;
            height: 11px;
            border-radius: 50%;
            background: white;
            border: 2px solid #cbd5e1;
        }
        .session-item.completed .session-dot { border-color: #10b981; background: #10b981; }
        .session-item.upcoming .session-dot { border-color: #3b82f6; }
    </style>
</head>
<body class="max-w-md mx-auto min-h-screen pb-12">

    <!-- Header Section -->
    <header class="px-6 pt-12 pb-6 flex items-center justify-between sticky top-0 bg-white/90 backdrop-blur-xl z-30 border-b border-slate-50">
        <div class="flex items-center space-x-4">
            <button onclick="window.history.back()" class="p-2 -ml-2 hover:bg-slate-100 rounded-full transition text-slate-800">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15 19l-7-7 7-7"></path></svg>
            </button>
            <h1 class="text-2xl font-black text-slate-900 tracking-tight">My Programs</h1>
        </div>
        <div class="w-10 h-10 rounded-full overflow-hidden border-2 border-blue-50 shadow-sm">
            <img src="https://placehold.co/100x100/2563eb/white?text=Y" alt="Profile">
        </div>
    </header>

    <!-- Content Tabs -->
    <div class="px-6 mt-8 flex space-x-8">
        <button onclick="switchTab('active')" id="tab-active" class="group pb-2 relative">
            <span class="text-xl font-black text-blue-600 transition-colors" id="text-active">Active</span>
            <div id="line-active" class="tab-indicator absolute bottom-0 left-0 bg-blue-600 w-8"></div>
        </button>
        <button onclick="switchTab('past')" id="tab-past" class="group pb-2 relative">
            <span class="text-xl font-black text-slate-300 transition-colors" id="text-past">Past</span>
            <div id="line-past" class="tab-indicator absolute bottom-0 left-0 bg-blue-600 w-0"></div>
        </button>
    </div>

    <!-- Programs Listing -->
    <main class="px-6 mt-8 space-y-6" id="programs-container">
        <!-- Rendered by JS -->
    </main>

    <!-- Details Modal (Bottom Sheet Style) -->
    <div id="modal-overlay" class="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm hidden flex items-end justify-center" onclick="closeModal()">
        <div id="modal-content" class="bg-white w-full max-w-md rounded-t-[40px] p-8 shadow-2xl modal-sheet translate-y-full" onclick="event.stopPropagation()">
            <div class="w-12 h-1.5 bg-slate-100 rounded-full mx-auto mb-10"></div>
            <div id="modal-body" class="space-y-8 pb-8">
                <!-- Content injected by JS -->
            </div>
        </div>
    </div>

    <script>
        const myPrograms = [
            { 
                id: 'p1', 
                type: 'academy', 
                name: 'Intermediate Stroke Squad', 
                provider: 'Elite Performance Academy', 
                schedule: 'Mon / Wed • 5:00 PM',
                endDate: 'Dec 20, 2025',
                sessionsCount: 12,
                completedSessions: 8,
                status: 'active',
                description: 'Focused on refining butterfly and breaststroke technique with video analysis.',
                sessions: [
                    { date: 'Oct 06', day: 'Mon', time: '5:00 PM', status: 'completed' },
                    { date: 'Oct 08', day: 'Wed', time: '5:00 PM', status: 'completed' },
                    { date: 'Oct 13', day: 'Mon', time: '5:00 PM', status: 'completed' },
                    { date: 'Oct 15', day: 'Wed', time: '5:00 PM', status: 'completed' },
                    { date: 'Oct 20', day: 'Mon', time: '5:00 PM', status: 'completed' },
                    { date: 'Oct 22', day: 'Wed', time: '5:00 PM', status: 'completed' },
                    { date: 'Oct 27', day: 'Mon', time: '5:00 PM', status: 'completed' },
                    { date: 'Oct 29', day: 'Wed', time: '5:00 PM', status: 'completed' },
                    { date: 'Nov 03', day: 'Mon', time: '5:00 PM', status: 'upcoming' },
                    { date: 'Nov 05', day: 'Wed', time: '5:00 PM', status: 'upcoming' },
                    { date: 'Nov 10', day: 'Mon', time: '5:00 PM', status: 'upcoming' },
                    { date: 'Nov 12', day: 'Wed', time: '5:00 PM', status: 'upcoming' }
                ]
            },
            { 
                id: 'p2', 
                type: 'coach', 
                name: 'Private Endurance Prep', 
                provider: 'Coach David Miller', 
                schedule: 'Fridays • 7:00 AM',
                endDate: 'Nov 15, 2025',
                sessionsCount: 8,
                completedSessions: 3,
                status: 'active',
                description: 'Personalized training for open water distance events and pacing strategies.',
                sessions: [
                    { date: 'Oct 03', day: 'Fri', time: '7:00 AM', status: 'completed' },
                    { date: 'Oct 10', day: 'Fri', time: '7:00 AM', status: 'completed' },
                    { date: 'Oct 17', day: 'Fri', time: '7:00 AM', status: 'completed' },
                    { date: 'Oct 24', day: 'Fri', time: '7:00 AM', status: 'upcoming' },
                    { date: 'Oct 31', day: 'Fri', time: '7:00 AM', status: 'upcoming' },
                    { date: 'Nov 07', day: 'Fri', time: '7:00 AM', status: 'upcoming' },
                    { date: 'Nov 14', day: 'Fri', time: '7:00 AM', status: 'upcoming' },
                    { date: 'Nov 21', day: 'Fri', time: '7:00 AM', status: 'upcoming' }
                ]
            },
            { 
                id: 'p3', 
                type: 'academy', 
                name: 'Foundation Level 1', 
                provider: 'Blue Wave Academy', 
                schedule: 'Completed',
                endDate: 'Aug 12, 2025',
                sessionsCount: 10,
                completedSessions: 10,
                status: 'past',
                description: 'Basic safety skills, breathing coordination, and foundational freestyle.',
                sessions: [] // Example of past program
            }
        ];

        let currentTab = 'active';

        function switchTab(tab) {
            currentTab = tab;
            const isActive = tab === 'active';
            
            document.getElementById('text-active').className = `text-xl font-black transition-colors ${isActive ? 'text-blue-600' : 'text-slate-300'}`;
            document.getElementById('text-past').className = `text-xl font-black transition-colors ${!isActive ? 'text-blue-600' : 'text-slate-300'}`;
            
            document.getElementById('line-active').style.width = isActive ? '32px' : '0';
            document.getElementById('line-past').style.width = !isActive ? '32px' : '0';
            
            renderPrograms();
        }

        function renderPrograms() {
            const container = document.getElementById('programs-container');
            const filtered = myPrograms.filter(p => p.status === currentTab);

            if (filtered.length === 0) {
                container.innerHTML = `
                    <div class="py-20 text-center opacity-30">
                        <svg class="w-16 h-16 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                        <p class="font-bold">No programs found</p>
                    </div>`;
                return;
            }

            container.innerHTML = filtered.map((program, idx) => {
                const progress = (program.completedSessions / program.sessionsCount) * 100;
                
                return `
                    <div class="program-card accent-${program.type} premium-shadow p-6 animate-item" 
                         style="animation-delay: ${idx * 0.1}s"
                         onclick="openDetails('${program.id}')">
                        
                        <div class="flex justify-between items-start mb-6">
                            <div class="space-y-1">
                                <span class="text-[10px] font-black px-2 py-0.5 rounded-lg uppercase tracking-widest ${program.type === 'academy' ? 'bg-blue-50 text-blue-600' : 'bg-purple-50 text-purple-600'}">
                                    ${program.type}
                                </span>
                                <h3 class="text-xl font-black text-slate-900 mt-2">${program.name}</h3>
                                <p class="text-xs font-bold text-slate-400 uppercase tracking-tight">${program.provider}</p>
                            </div>
                            <div class="w-10 h-10 rounded-2xl bg-slate-50 flex items-center justify-center text-slate-300">
                                 <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 5l7 7-7 7"></path></svg>
                            </div>
                        </div>

                        <!-- Progress Section -->
                        <div class="space-y-3">
                            <div class="flex justify-between items-end">
                                <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Progress</p>
                                <p class="text-xs font-black text-slate-800">${program.completedSessions} / ${program.sessionsCount} Sessions</p>
                            </div>
                            <div class="progress-container">
                                <div class="progress-fill fill-${program.type}" style="width: ${progress}%"></div>
                            </div>
                        </div>

                        <div class="mt-6 pt-4 border-t border-slate-50 flex items-center justify-between text-[10px] font-bold uppercase text-slate-400 tracking-widest">
                            <span>Ends: ${program.endDate}</span>
                            <span>${program.schedule}</span>
                        </div>
                    </div>
                `;
            }).join('');
        }

        function openDetails(id) {
            const program = myPrograms.find(p => p.id === id);
            const body = document.getElementById('modal-body');
            
            body.innerHTML = `
                <div class="text-center space-y-2">
                    <span class="text-[10px] font-black px-3 py-1 rounded-full uppercase tracking-widest ${program.type === 'academy' ? 'bg-blue-50 text-blue-600' : 'bg-purple-50 text-purple-600'}">
                        ${program.type}
                    </span>
                    <h2 class="text-3xl font-black text-slate-900 leading-tight pt-2">${program.name}</h2>
                    <p class="text-slate-500 font-bold text-sm">Managed by ${program.provider}</p>
                </div>

                <div class="p-6 bg-slate-50 rounded-[32px] space-y-4 border border-slate-100">
                    <h4 class="text-xs font-black text-slate-400 uppercase tracking-[0.2em]">About this program</h4>
                    <p class="text-sm text-slate-600 leading-relaxed font-medium">${program.description}</p>
                    
                    <div class="grid grid-cols-2 gap-3 pt-2">
                        <div class="bg-white p-4 rounded-2xl shadow-sm border border-slate-100">
                            <p class="text-[9px] font-black text-slate-300 uppercase mb-1">Schedule</p>
                            <p class="text-xs font-black text-slate-800">${program.schedule}</p>
                        </div>
                        <div class="bg-white p-4 rounded-2xl shadow-sm border border-slate-100">
                            <p class="text-[9px] font-black text-slate-300 uppercase mb-1">Status</p>
                            <p class="text-xs font-black text-blue-600">${program.status === 'active' ? 'Ongoing' : 'Completed'}</p>
                        </div>
                    </div>
                </div>

                <div class="space-y-3">
                    <button onclick="showSessionList('${program.id}')" class="w-full py-5 bg-blue-600 text-white rounded-[24px] font-black flex items-center justify-center shadow-xl active:scale-95 transition-transform">
                        <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                        Full Session Schedule
                    </button>
                    <a href="https://wa.me/1234567890" target="_blank" class="w-full py-5 whatsapp-green text-white rounded-[24px] font-black flex items-center justify-center shadow-xl active:scale-95 transition-transform">
                        <svg class="w-5 h-5 mr-3" fill="currentColor" viewBox="0 0 24 24"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L0 24l6.335-1.662c1.883 1.027 3.909 1.564 5.968 1.564h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/></svg>
                        Message Support
                    </a>
                </div>
            `;

            const overlay = document.getElementById('modal-overlay');
            const content = document.getElementById('modal-content');
            
            overlay.classList.remove('hidden');
            setTimeout(() => {
                content.classList.remove('translate-y-full');
            }, 10);
        }

        function showSessionList(id) {
            const program = myPrograms.find(p => p.id === id);
            const body = document.getElementById('modal-body');
            
            const sessionsHtml = program.sessions.length > 0 ? program.sessions.map((s, idx) => `
                <div class="session-item ${s.status}">
                    <div class="session-dot"></div>
                    <div class="flex justify-between items-center mb-1">
                        <span class="text-sm font-black text-slate-800">${s.date} <span class="text-slate-400 font-medium">(${s.day})</span></span>
                        <span class="text-[10px] font-black uppercase tracking-widest ${s.status === 'completed' ? 'text-emerald-500' : 'text-blue-500'}">
                            ${s.status}
                        </span>
                    </div>
                    <p class="text-xs text-slate-500 font-bold uppercase tracking-tight">${s.time} • Standard Lane</p>
                </div>
            `).join('') : '<p class="text-center text-slate-400 py-8 italic">No specific session logs available for this program.</p>';

            body.innerHTML = `
                <div class="flex items-center space-x-4 mb-2">
                    <button onclick="openDetails('${id}')" class="p-2 bg-slate-50 rounded-full text-slate-800 hover:bg-slate-100 transition">
                         <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M15 19l-7-7 7-7"></path></svg>
                    </button>
                    <h2 class="text-2xl font-black text-gray-900 leading-tight">Session Breakdown</h2>
                </div>
                
                <div class="bg-blue-50 p-4 rounded-2xl flex items-center justify-between mb-4">
                    <div>
                        <p class="text-[10px] font-black text-blue-600 uppercase tracking-widest">Ongoing Term</p>
                        <p class="text-sm font-bold text-blue-900">${program.name}</p>
                    </div>
                    <span class="text-xs font-black text-blue-600">${program.completedSessions}/${program.sessionsCount}</span>
                </div>

                <div class="space-y-6 max-h-[400px] overflow-y-auto pr-2 custom-scroll pb-4">
                    ${sessionsHtml}
                </div>

                <button onclick="closeModal()" class="w-full py-4 text-slate-400 font-bold hover:text-slate-600 transition-colors mt-4">
                    Dismiss
                </button>
            `;
        }

        function closeModal() {
            const overlay = document.getElementById('modal-overlay');
            const content = document.getElementById('modal-content');
            
            content.classList.add('translate-y-full');
            setTimeout(() => {
                overlay.classList.add('hidden');
            }, 400);
        }

        window.onload = renderPrograms;
    </script>
</body>
</html>