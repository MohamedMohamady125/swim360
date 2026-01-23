<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <title>Swim 360 - My Programs</title>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F8FAFC; color: #0F172A; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        .animate-in { animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        
        .tab-btn { position: relative; transition: all 0.3s ease; }
        .tab-btn.active { color: #2563eb; }
        .tab-btn.active::after {
            content: ''; position: absolute; bottom: 0; left: 50%;
            transform: translateX(-50%); width: 20px; height: 4px;
            background-color: #2563eb; border-radius: 99px;
        }

        .progress-track { height: 10px; background-color: #F1F5F9; border-radius: 99px; overflow: hidden; box-shadow: inset 0 2px 4px rgba(0,0,0,0.05); }
        .progress-fill { height: 100%; border-radius: 99px; transition: width 1s cubic-bezier(0.65, 0, 0.35, 1); }
        
        .shadow-blueprint { box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 10px 10px -5px rgba(0, 0, 0, 0.02); }
    </style>
</head>
<body class="no-scrollbar">

    <div class="max-w-md mx-auto min-h-screen relative flex flex-col">
        
        <header class="bg-white/90 backdrop-blur-md px-6 pt-12 pb-5 flex items-center justify-between sticky top-0 z-30 border-b border-gray-50 text-left">
            <div class="flex items-center space-x-4">
                <button onclick="window.history.back()" class="p-2.5 rounded-2xl border border-gray-100 bg-white text-gray-900 shadow-sm active:scale-90 transition-all">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><polyline points="15 18 9 12 15 6"></polyline></svg>
                </button>
                <div>
                    <h1 class="text-2xl font-black text-gray-900 tracking-tight uppercase leading-none italic">Programs</h1>
                    <p class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] mt-1.5">Learning Journey</p>
                </div>
            </div>
            <div class="w-11 h-11 rounded-2xl bg-blue-50 flex items-center justify-center text-blue-600 border border-blue-100 shadow-inner overflow-hidden">
                <img src="https://placehold.co/100x100/2563eb/white?text=Y" class="w-full h-full object-cover">
            </div>
        </header>

        <nav class="flex bg-white px-8 border-b border-gray-50 sticky top-[74px] z-20">
            <button onclick="switchTab('active')" id="tab-active" class="tab-btn active py-5 text-[10px] font-black uppercase tracking-[0.2em] text-gray-400 mr-8">Active</button>
            <button onclick="switchTab('past')" id="tab-past" class="tab-btn py-5 text-[10px] font-black uppercase tracking-[0.2em] text-gray-400">Past</button>
        </nav>

        <main id="programs-container" class="p-6 space-y-6 animate-in text-left">
            </main>

        <div id="modal-overlay" class="fixed inset-0 z-50 flex items-end justify-center bg-slate-900/60 backdrop-blur-sm hidden transition-opacity" onclick="closeModal()">
            <div id="modal-sheet" class="bg-white w-full max-w-md rounded-t-[44px] p-10 shadow-2xl transition-transform duration-500 translate-y-full relative" onclick="event.stopPropagation()">
                <div class="w-12 h-1.5 bg-gray-100 rounded-full mx-auto mb-10 shadow-inner"></div>
                <div id="modal-body" class="space-y-8 text-left max-h-[70vh] overflow-y-auto no-scrollbar">
                    </div>
            </div>
        </div>
    </div>

    <script>
        const myPrograms = [
            { id: 'p1', type: 'ACADEMY', name: 'Intermediate Stroke Mastery', provider: 'Elite Swim Academy', schedule: 'Mon / Wed • 5:00 PM', end: 'Dec 20, 2025', count: 12, completed: 8, status: 'active', color: '#2563eb', desc: 'Intensive technique correction focused on competitive stroke efficiency and start-line explosive power.' },
            { id: 'p2', type: 'COACH', name: 'Personal Endurance Plan', provider: 'Sarah Wilson', schedule: 'Fridays • 7:00 AM', end: 'Nov 15, 2025', count: 8, completed: 3, status: 'active', color: '#7c3aed', desc: 'Custom tailored open water transition program focusing on sighting technique and long-distance pacing.' }
        ];

        let currentTab = 'active';

        function render() {
            const container = document.getElementById('programs-container');
            const filtered = myPrograms.filter(p => p.status === currentTab);

            if (!filtered.length) {
                container.innerHTML = `<div class="py-20 text-center"><p class="text-[10px] font-black text-gray-300 uppercase tracking-widest italic">No Programs Found</p></div>`;
                return;
            }

            container.innerHTML = filtered.map(p => `
                <div class="bg-white p-6 rounded-[32px] border border-gray-100 shadow-blueprint cursor-pointer active:scale-[0.98] transition-all" onclick="openDetails('${p.id}')">
                    <div class="flex justify-between items-start mb-6">
                        <div>
                            <span class="px-2.5 py-1 rounded-lg text-[8px] font-black uppercase tracking-widest" style="background-color: ${p.color}10; color: ${p.color}">${p.type}</span>
                            <h3 class="text-xl font-black text-gray-900 mt-3 tracking-tighter uppercase italic leading-none">${p.name}</h3>
                            <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mt-1.5">${p.provider}</p>
                        </div>
                        <div class="w-10 h-10 rounded-2xl bg-gray-50 flex items-center justify-center text-gray-300 shadow-inner">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"></polyline></svg>
                        </div>
                    </div>

                    <div class="space-y-3">
                        <div class="flex justify-between items-end">
                            <p class="text-[9px] font-black text-gray-400 uppercase tracking-widest">Training Progress</p>
                            <p class="text-[10px] font-black text-gray-900 uppercase">${p.completed} / ${p.count} Sessions</p>
                        </div>
                        <div class="progress-track">
                            <div class="progress-fill" style="width: ${(p.completed/p.count)*100}%; background-color: ${p.color}"></div>
                        </div>
                    </div>

                    <div class="mt-6 pt-5 border-t border-gray-50 flex items-center justify-between">
                        <div class="flex items-center text-[9px] font-black text-gray-400 uppercase tracking-widest leading-none">
                            <svg class="w-3.5 h-3.5 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                            ${p.schedule}
                        </div>
                        <span class="text-[8px] font-black text-gray-300 uppercase tracking-widest">End: ${p.end}</span>
                    </div>
                </div>
            `).join('');
        }

        function openDetails(id) {
            const p = myPrograms.find(prog => prog.id === id);
            const body = document.getElementById('modal-body');
            
            body.innerHTML = `
                <div class="space-y-4">
                    <span class="px-3 py-1 rounded-lg text-[9px] font-black uppercase tracking-widest" style="background-color: ${p.color}10; color: ${p.color}">${p.type} ACTIVE</span>
                    <h2 class="text-3xl font-black text-gray-900 tracking-tighter uppercase italic leading-none">${p.name}</h2>
                    <p class="text-sm font-bold text-gray-400">Led by ${p.provider}</p>
                </div>

                <div class="p-6 bg-gray-50 rounded-[32px] border border-gray-100 shadow-inner space-y-4">
                    <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Overview</p>
                    <p class="text-sm font-bold text-gray-600 leading-relaxed italic">"${p.desc}"</p>
                </div>

                <div class="p-6 bg-white rounded-[32px] border border-gray-50 shadow-sm flex items-center justify-between">
                    <div class="flex items-center space-x-4">
                        <div class="w-10 h-10 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center shadow-inner">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                        </div>
                        <div>
                            <p class="text-[9px] font-black text-gray-300 uppercase tracking-widest">Regular Schedule</p>
                            <p class="text-xs font-black text-gray-900">${p.schedule}</p>
                        </div>
                    </div>
                </div>

                <div class="pt-4">
                    <button onclick="window.open('https://wa.me/20123456789', '_blank')" class="w-full py-5 bg-[#25D366] text-white rounded-[24px] font-black text-xs uppercase tracking-widest shadow-xl shadow-emerald-100 flex items-center justify-center active:scale-95 transition-all">
                        <svg class="w-5 h-5 mr-3" fill="currentColor" viewBox="0 0 24 24"><path d="M.057 24l1.687-6.163c-1.041-1.804-1.588-3.849-1.587-5.946.003-6.556 5.338-11.891 11.893-11.891 3.181.001 6.167 1.24 8.413 3.488 2.245 2.248 3.481 5.236 3.48 8.414-.003 6.557-5.338 11.892-11.893 11.892-1.99-.001-3.951-.5-5.688-1.448l-6.305 1.654zm6.597-3.807c1.676.995 3.276 1.591 5.392 1.592 5.448 0 9.886-4.434 9.889-9.885.002-5.462-4.415-9.89-9.881-9.892-5.452 0-9.887 4.434-9.889 9.884-.001 2.225.651 3.891 1.746 5.634l-.999 3.648 3.742-.981z"/></svg>
                        Message Support
                    </button>
                </div>
            `;

            document.getElementById('modal-overlay').classList.remove('hidden');
            setTimeout(() => document.getElementById('modal-sheet').classList.remove('translate-y-full'), 10);
        }

        function switchTab(tab) {
            currentTab = tab;
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            document.getElementById(`tab-${tab}`).classList.add('active');
            render();
        }

        function closeModal() {
            document.getElementById('modal-sheet').classList.add('translate-y-full');
            setTimeout(() => document.getElementById('modal-overlay').classList.add('hidden'), 400);
        }

        window.onload = render;
    </script>
</body>
</html>