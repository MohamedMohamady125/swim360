<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <title>Swim 360 - Enrolled Swimmers</title>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F8FAFC; color: #0F172A; }
        
        @keyframes fadeIn { 
            from { opacity: 0; transform: translateY(15px); } 
            to { opacity: 1; transform: translateY(0); } 
        }
        .animate-in { animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        
        .swimmer-card {
            background-color: white;
            border-radius: 32px;
            border: 1px solid #F1F5F9;
            box-shadow: 0 4px 20px -2px rgba(0, 0, 0, 0.05);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .swimmer-card:active { transform: scale(0.98); }

        .input-group {
            display: flex;
            align-items: center;
            border-radius: 16px;
            padding: 0 16px;
            background-color: #F8FAFC;
            box-shadow: inset 0 2px 4px 0 rgba(0, 0, 0, 0.05);
            border: 1px solid transparent;
            transition: all 0.3s;
        }

        .modal-sheet {
            background-color: white;
            width: 100%;
            max-width: 28rem;
            border-radius: 44px 44px 0 0;
            padding: 2.5rem;
            box-shadow: 0 -20px 40px -10px rgba(15, 23, 42, 0.3);
            transform: translateY(100%);
            transition: transform 0.5s cubic-bezier(0.32, 0.72, 0, 1);
        }
        .modal-overlay.active .modal-sheet { transform: translateY(0); }
    </style>
</head>
<body class="no-scrollbar">

    <div class="max-w-md mx-auto min-h-screen pb-12 relative overflow-x-hidden text-left">
        
        <header class="bg-white/90 backdrop-blur-md px-6 pt-12 pb-5 flex items-center justify-between sticky top-0 z-30 border-b border-gray-50">
            <div class="flex items-center space-x-4">
                <button onclick="window.history.back()" class="p-2.5 rounded-2xl border border-gray-100 bg-white text-gray-900 shadow-sm active:scale-90 transition-all">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="15 18 9 12 15 6"></polyline></svg>
                </button>
                <div>
                    <h1 class="text-2xl font-black text-gray-900 tracking-tight uppercase leading-none italic">Swimmers</h1>
                    <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mt-1">Enrollment Roster</p>
                </div>
            </div>
            <div class="w-11 h-11 rounded-2xl bg-blue-50 flex items-center justify-center text-blue-600 border border-blue-100 shadow-inner">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
            </div>
        </header>

        <main class="p-6 space-y-6 animate-in">
            <div>
                <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Select Branch</label>
                <div class="input-group">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-gray-400 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 10h6"></path></svg>
                    <select id="branch-filter" onchange="filterData()" class="w-full py-4 bg-transparent outline-none font-bold text-sm text-gray-800">
                        <option value="b1">Fifth Settlement Branch</option>
                        <option value="b2">Sheikh Zayed Branch</option>
                    </select>
                </div>
            </div>

            <div class="bg-white p-2 rounded-[24px] shadow-sm border border-gray-100">
                <div class="relative">
                    <svg xmlns="http://www.w3.org/2000/svg" class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-300" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    <input type="text" id="search-input" oninput="filterData()" placeholder="Search swimmer names..." 
                           class="w-full pl-11 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none shadow-inner transition-all uppercase">
                </div>
            </div>

            <div id="roster-container" class="space-y-8 pb-20">
                </div>
        </main>

        <div id="modal-overlay" class="modal-overlay fixed inset-0 z-50 flex items-end justify-center bg-slate-900/60 backdrop-blur-sm hidden transition-opacity" onclick="closeModal()">
            <div class="modal-sheet relative overflow-hidden" onclick="event.stopPropagation()">
                <div class="w-12 h-1.5 bg-slate-100 rounded-full mx-auto mb-10 shadow-inner"></div>
                
                <div class="text-center space-y-2">
                    <div class="w-24 h-24 bg-blue-50 text-blue-600 rounded-[34px] flex items-center justify-center mx-auto mb-4 border border-blue-100 shadow-sm">
                        <span id="modal-initial" class="text-4xl font-black italic"></span>
                    </div>
                    <h3 id="modal-name" class="text-3xl font-black text-gray-900 tracking-tight leading-none uppercase italic"></h3>
                    <p id="modal-prog" class="text-[10px] font-black text-blue-600 uppercase tracking-[0.2em] mt-2"></p>
                </div>

                <div class="p-6 bg-gray-50 rounded-[32px] border border-gray-100 space-y-4 mt-8 shadow-inner text-left">
                    <div class="flex justify-between items-center text-[10px] font-black uppercase tracking-widest">
                        <span class="text-gray-400">Status</span>
                        <span class="text-emerald-500">Active Enrollment</span>
                    </div>
                    <div class="h-px bg-gray-200/50"></div>
                    <div class="flex justify-between items-center text-[10px] font-black uppercase tracking-widest">
                        <span class="text-gray-400">Program End</span>
                        <span id="modal-date" class="text-rose-600 font-black italic"></span>
                    </div>
                </div>

                <div class="pt-8">
                    <a id="modal-whatsapp" target="_blank" class="w-full flex items-center justify-center py-5 bg-[#25D366] text-white rounded-[24px] font-black text-xs uppercase tracking-[0.2em] shadow-xl active:scale-95 transition-all">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 mr-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 1 1-7.6-10.6 8.38 8.38 0 0 1 3.8.9L21 3.5Z"></path></svg>
                        Message Swimmer
                    </a>
                </div>
            </div>
        </div>

        <div id="toast" class="fixed bottom-10 left-1/2 -translate-x-1/2 bg-gray-900 text-white px-8 py-4 rounded-full text-[10px] font-black shadow-2xl z-[100] hidden uppercase tracking-widest"></div>
    </div>

    <script>
        const swimmers = [
            { id: 's1', name: 'Alex Johnson', program: 'Intermediate Squad', branch: 'b1', end_date: '2026-06-12', phone: '123456789', initial: 'A' },
            { id: 's2', name: 'Sarah Chen', program: 'Intermediate Squad', branch: 'b1', end_date: '2026-05-20', phone: '987654321', initial: 'S' },
            { id: 's3', name: 'Michael Thorne', program: 'Elite Mastery', branch: 'b1', end_date: '2026-12-30', phone: '445566778', initial: 'M' },
            { id: 's4', name: 'Zaid Mansour', program: 'Learn To Swim', branch: 'b2', end_date: '2026-04-15', phone: '112233445', initial: 'Z' }
        ];

        function filterData() {
            const branchId = document.getElementById('branch-filter').value;
            const search = document.getElementById('search-input').value.toLowerCase();
            
            const filtered = swimmers.filter(s => 
                s.branch === branchId && 
                s.name.toLowerCase().includes(search)
            );
            
            render(filtered);
        }

        function render(data) {
            const container = document.getElementById('roster-container');
            
            const groups = data.reduce((acc, s) => {
                acc[s.program] = acc[s.program] || [];
                acc[s.program].push(s);
                return acc;
            }, {});

            if (data.length === 0) {
                container.innerHTML = `<div class="py-20 text-center text-gray-300 uppercase font-black text-xs tracking-widest italic">No swimmers found</div>`;
                return;
            }

            container.innerHTML = Object.entries(groups).map(([prog, list]) => `
                <div class="space-y-5">
                    <div class="flex items-center space-x-3 px-2">
                        <span class="text-[10px] font-black text-slate-300 uppercase tracking-[0.2em] whitespace-nowrap italic">${prog} — ${list.length} Swimmers</span>
                        <div class="h-px bg-slate-100 flex-grow"></div>
                    </div>
                    ${list.map(s => `
                        <div onclick="openModal('${s.id}')" class="swimmer-card p-5 flex items-center space-x-5 animate-in">
                            <div class="w-14 h-14 rounded-2xl bg-blue-50 flex items-center justify-center text-blue-600 font-black text-xl italic shadow-inner">
                                ${s.initial}
                            </div>
                            <div class="flex-grow">
                                <h3 class="font-black text-gray-900 text-lg uppercase italic tracking-tighter leading-none">${s.name}</h3>
                                <p class="text-[9px] font-black text-blue-400 uppercase tracking-widest mt-2">End Date: ${s.end_date}</p>
                            </div>
                            <div class="p-2.5 bg-gray-50 text-gray-300 rounded-xl">
                                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><path d="M9 5l7 7-7 7"></path></svg>
                            </div>
                        </div>
                    `).join('')}
                </div>
            `).join('');
        }

        function openModal(id) {
            const s = swimmers.find(x => x.id === id);
            document.getElementById('modal-name').textContent = s.name;
            document.getElementById('modal-prog').textContent = s.program;
            document.getElementById('modal-date').textContent = s.end_date;
            document.getElementById('modal-initial').textContent = s.initial;
            document.getElementById('modal-whatsapp').href = `https://wa.me/${s.phone}`;
            
            const overlay = document.getElementById('modal-overlay');
            overlay.classList.remove('hidden');
            overlay.classList.add('flex');
            setTimeout(() => overlay.classList.add('active'), 10);
        }

        function closeModal() {
            const overlay = document.getElementById('modal-overlay');
            overlay.classList.remove('active');
            setTimeout(() => {
                overlay.classList.remove('flex');
                overlay.classList.add('hidden');
            }, 500);
        }

        window.onload = filterData;
    </script>
</body>
</html>