<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <title>Swim 360 - My Clients</title>
    <style>
        body { font-family: 'Inter', sans-serif; }
        @keyframes fadeIn { 
            from { opacity: 0; transform: translateY(15px); } 
            to { opacity: 1; transform: translateY(0); } 
        }
        .animate-in { animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .line-clamp-1 { display: -webkit-box; -webkit-line-clamp: 1; -webkit-box-orient: vertical; overflow: hidden; }
    </style>
</head>
<body class="bg-[#F8FAFC]">

    <div class="max-w-md mx-auto min-h-screen bg-[#F8FAFC] text-gray-900 pb-12 relative overflow-x-hidden">
        
        <header class="bg-white/90 backdrop-blur-md px-6 pt-12 pb-5 flex items-center justify-between sticky top-0 z-30 border-b border-gray-50">
            <div class="flex items-center space-x-4">
                <button class="p-2.5 rounded-2xl border border-gray-100 bg-white text-gray-900 shadow-sm active:scale-90 transition-all">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
                </button>
                <div>
                    <h1 class="text-2xl font-black text-gray-900 tracking-tight leading-none uppercase">My Clients</h1>
                    <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mt-1">Management Hub</p>
                </div>
            </div>
            <div class="w-11 h-11 rounded-2xl bg-blue-50 flex items-center justify-center text-blue-600 border border-blue-100 shadow-inner">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
            </div>
        </header>

        <main class="p-6 space-y-6 animate-in">
            
            <div class="bg-white p-5 rounded-[32px] shadow-sm border border-gray-100">
                <div class="relative">
                    <svg xmlns="http://www.w3.org/2000/svg" class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-300" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    <input type="text" id="search-input" placeholder="Search clients or programs..." 
                           class="w-full pl-11 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none shadow-inner transition-all">
                </div>
            </div>

            <div id="list-container" class="space-y-8 pb-20">
                </div>
        </main>

        <div id="modal-overlay" class="fixed inset-0 z-50 flex items-end justify-center px-4 pb-10 bg-slate-900/60 backdrop-blur-sm hidden transition-opacity">
            <div class="bg-white w-full max-w-sm rounded-[40px] p-8 shadow-2xl animate-in relative overflow-hidden">
                <button id="close-modal" class="absolute top-6 right-6 p-2 bg-gray-50 rounded-full text-gray-400 active:scale-90">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
                
                <div class="text-center space-y-2">
                    <div class="w-20 h-20 bg-blue-50 text-blue-600 rounded-[30px] flex items-center justify-center mx-auto mb-4 border border-blue-100 shadow-sm relative">
                        <img id="modal-img" class="w-full h-full object-cover rounded-[30px]">
                    </div>
                    <h3 id="modal-name" class="text-2xl font-black text-gray-900 tracking-tight leading-none"></h3>
                    <p id="modal-prog" class="text-xs font-bold text-gray-400 uppercase tracking-widest mt-1"></p>
                </div>

                <div class="p-6 bg-gray-50 rounded-[32px] border border-gray-100 space-y-4 mt-6 shadow-inner text-left">
                    <div class="flex justify-between items-center text-[10px] font-black uppercase tracking-widest">
                        <span class="text-gray-400">Age / Gender</span>
                        <span id="modal-meta" class="text-gray-800"></span>
                    </div>
                    <div class="h-px bg-gray-200/50"></div>
                    <div class="flex justify-between items-center text-[10px] font-black uppercase tracking-widest">
                        <span class="text-gray-400">Program End</span>
                        <span id="modal-date" class="text-rose-600"></span>
                    </div>
                </div>

                <div class="pt-6">
                    <a id="modal-whatsapp" target="_blank" class="w-full flex items-center justify-center py-5 bg-[#25D366] text-white rounded-[24px] font-black text-sm uppercase tracking-widest shadow-xl active:scale-95 transition-all">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 mr-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 1 1-7.6-10.6 8.38 8.38 0 0 1 3.8.9L21 3.5Z"></path></svg>
                        WhatsApp Chat
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        const clients = [
            { id: 'c1', name: 'Alex Johnson', program: '12-Week Stroke Mastery', end_date: '2026-12-31', phone: '1234567890', age: 28, gender: 'Male', initial: 'A' },
            { id: 'c2', name: 'Sarah Chen', program: 'Nutrition for Triathletes', end_date: '2026-01-20', phone: '0987654321', age: 35, gender: 'Female', initial: 'S' },
            { id: 'c4', name: 'Laura Smith', program: '12-Week Stroke Mastery', end_date: '2026-03-15', phone: '1122334455', age: 41, gender: 'Female', initial: 'L' }
        ];

        function render(data) {
            const container = document.getElementById('list-container');
            const groups = data.reduce((acc, c) => {
                acc[c.program] = acc[c.program] || [];
                acc[c.program].push(c);
                return acc;
            }, {});

            container.innerHTML = Object.entries(groups).map(([prog, list]) => `
                <div class="space-y-4">
                    <div class="flex items-center space-x-3 px-2">
                        <span class="text-[10px] font-black text-gray-300 uppercase tracking-[0.2em] whitespace-nowrap">${prog} (${list.length})</span>
                        <div class="h-px bg-gray-100 flex-grow"></div>
                    </div>
                    ${list.map(c => `
                        <div onclick="openModal('${c.id}')" class="bg-white rounded-[32px] border border-gray-100 shadow-sm p-4 flex items-center space-x-4 active:scale-[0.98] transition-all cursor-pointer">
                            <div class="w-14 h-14 rounded-2xl bg-blue-50 flex items-center justify-center text-blue-600 font-black text-xl border border-blue-100 shadow-sm">
                                ${c.initial}
                            </div>
                            <div class="flex-grow text-left">
                                <h3 class="font-black text-gray-900 leading-tight text-lg">${c.name}</h3>
                                <p class="text-[10px] font-bold text-blue-600 uppercase tracking-widest mt-1">Ends: ${c.end_date}</p>
                            </div>
                            <div class="p-2.5 bg-gray-50 text-gray-300 rounded-xl">
                                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/></svg>
                            </div>
                        </div>
                    `).join('')}
                </div>
            `).join('');
        }

        function openModal(id) {
            const c = clients.find(x => x.id === id);
            document.getElementById('modal-name').textContent = c.name;
            document.getElementById('modal-prog').textContent = c.program;
            document.getElementById('modal-meta').textContent = `${c.age} YRS • ${c.gender}`;
            document.getElementById('modal-date').textContent = c.end_date;
            document.getElementById('modal-img').src = `https://placehold.co/80x80/3B82F6/ffffff?text=${c.initial}`;
            document.getElementById('modal-whatsapp').href = `https://wa.me/${c.phone}`;
            document.getElementById('modal-overlay').classList.remove('hidden');
        }

        document.getElementById('close-modal').onclick = () => document.getElementById('modal-overlay').classList.add('hidden');
        document.getElementById('search-input').oninput = (e) => {
            const filtered = clients.filter(c => c.name.toLowerCase().includes(e.target.value.toLowerCase()) || c.program.toLowerCase().includes(e.target.value.toLowerCase()));
            render(filtered);
        };

        window.onload = () => render(clients);
    </script>
</body>
</html>