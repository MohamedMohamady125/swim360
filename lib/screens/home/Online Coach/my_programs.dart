<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <title>Swim 360 - My Programs</title>
    <style>
        body { font-family: 'Inter', sans-serif; }
        @keyframes fadeIn { 
            from { opacity: 0; transform: translateY(15px); } 
            to { opacity: 1; transform: translateY(0); } 
        }
        .animate-in { animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .shadow-soft { box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 10px 10px -5px rgba(0, 0, 0, 0.02); }
    </style>
</head>
<body class="bg-[#F8FAFC]">

    <div class="max-w-md mx-auto min-h-screen bg-[#F8FAFC] text-gray-900 pb-12 relative overflow-x-hidden">
        
        <header class="bg-white/90 backdrop-blur-md px-6 pt-12 pb-5 flex items-center justify-between sticky top-0 z-30 border-b border-gray-50">
            <div class="flex items-center space-x-4 text-left">
                <button class="p-2.5 rounded-2xl border border-gray-100 bg-white text-gray-900 shadow-sm active:scale-90 transition-all">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
                </button>
                <div>
                    <h1 class="text-2xl font-black text-gray-900 tracking-tight leading-none uppercase">My Programs</h1>
                    <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mt-1">Official Inventory</p>
                </div>
            </div>
            <div class="w-11 h-11 rounded-2xl bg-blue-600 flex items-center justify-center text-white shadow-lg shadow-blue-100">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg>
            </div>
        </header>

        <main class="p-6 space-y-6 animate-in">
            <div id="program-list" class="space-y-4 pb-20">
                </div>
        </main>

        <div id="edit-modal-overlay" class="fixed inset-0 z-50 flex items-end justify-center px-4 pb-10 bg-slate-900/60 backdrop-blur-sm hidden transition-opacity">
            <div class="bg-white w-full max-w-sm rounded-[40px] p-8 shadow-2xl animate-in relative overflow-hidden text-left">
                <button id="close-modal-btn" class="absolute top-6 right-6 p-2 bg-gray-50 rounded-full text-gray-400 active:scale-90">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
                
                <div class="mb-6">
                    <h3 class="text-2xl font-black text-gray-900 tracking-tight leading-none uppercase">Edit Details</h3>
                    <p id="modal-program-title" class="text-[10px] font-bold text-blue-600 uppercase tracking-widest mt-2"></p>
                </div>

                <form id="edit-program-form" class="space-y-5">
                    <input type="hidden" id="edit-program-id">

                    <div>
                        <label class="text-[10px] font-black text-gray-400 uppercase ml-1">Detailed Description</label>
                        <textarea id="edit-description" rows="4" required
                                  class="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none shadow-inner transition-all"></textarea>
                    </div>

                    <div>
                        <label class="text-[10px] font-black text-gray-400 uppercase ml-1 tracking-widest">Video URL (YouTube/Vimeo)</label>
                        <div class="relative mt-1.5">
                            <svg xmlns="http://www.w3.org/2000/svg" class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-300" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z"></path></svg>
                            <input type="url" id="edit-intro-video-url" placeholder="Paste link..." 
                                   class="w-full pl-11 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none shadow-inner">
                        </div>
                    </div>

                    <div>
                        <label class="text-[10px] font-black text-gray-400 uppercase ml-1">Campaign End Date</label>
                        <div class="relative mt-1.5">
                            <svg xmlns="http://www.w3.org/2000/svg" class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-300" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            <input type="date" id="edit-program-end-date" 
                                   class="w-full pl-11 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none shadow-inner">
                        </div>
                    </div>

                    <div class="pt-2">
                        <button type="submit" class="w-full py-5 bg-blue-600 text-white rounded-[24px] font-black text-sm uppercase tracking-[0.2em] shadow-xl shadow-blue-600/20 active:scale-95 transition-all">
                            Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        let programs = [
            { id: 'prog1', title: '12-Week Stroke Mastery', price: 199.99, duration: '12 Weeks', end_date: '2026-12-31', photo_url: 'https://images.unsplash.com/photo-1530549387634-e5a529577059?auto=format&fit=crop&q=80&w=800', description: 'Comprehensive stroke mastery curriculum.' },
            { id: 'prog2', title: 'Nutrition for Triathletes', price: 49.00, duration: '8 Sessions', end_date: '', photo_url: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&q=80&w=800', description: 'Fueling endurance athletes.' }
        ];

        function render() {
            const list = document.getElementById('program-list');
            list.innerHTML = programs.map(p => `
                <div onclick="openEditModal('${p.id}')" class="bg-white p-4 rounded-[32px] shadow-soft border border-gray-50 flex items-center space-x-4 active:scale-[0.98] transition-all cursor-pointer">
                    <img src="${p.photo_url}" class="w-20 h-20 object-cover rounded-[24px] shadow-inner flex-shrink-0">
                    <div class="flex-grow text-left">
                        <h3 class="text-lg font-black text-gray-900 leading-tight">${p.title}</h3>
                        <p class="text-sm font-black text-blue-600 mt-0.5">$${p.price.toFixed(2)}</p>
                        <p class="text-[9px] font-bold text-gray-400 uppercase tracking-widest mt-1">
                            ${p.duration} ${p.end_date ? `• Ends ${p.end_date}` : '• Ongoing'}
                        </p>
                    </div>
                    <div class="p-2.5 bg-gray-50 text-gray-300 rounded-xl group-hover:bg-blue-50 transition-all">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg>
                    </div>
                </div>
            `).join('');
        }

        function openEditModal(id) {
            const p = programs.find(x => x.id === id);
            document.getElementById('edit-program-id').value = p.id;
            document.getElementById('modal-program-title').textContent = p.title;
            document.getElementById('edit-description').value = p.description;
            document.getElementById('edit-program-end-date').value = p.end_date;
            document.getElementById('edit-modal-overlay').classList.remove('hidden');
        }

        document.getElementById('edit-program-form').onsubmit = (e) => {
            e.preventDefault();
            const id = document.getElementById('edit-program-id').value;
            const index = programs.findIndex(x => x.id === id);
            programs[index].description = document.getElementById('edit-description').value;
            programs[index].end_date = document.getElementById('edit-program-end-date').value;
            
            // Mock Success logic
            render();
            document.getElementById('edit-modal-overlay').classList.add('hidden');
        };

        document.getElementById('close-modal-btn').onclick = () => document.getElementById('edit-modal-overlay').classList.add('hidden');

        window.onload = render;
    </script>
</body>
</html>