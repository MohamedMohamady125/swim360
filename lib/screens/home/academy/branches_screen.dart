<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - My Academy Branches</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F8FAFC; color: #0F172A; }
        
        /* THE BLUEPRINT STANDARD: 32px Radius */
        .branch-card {
            background-color: white;
            border-radius: 32px;
            border: 1px solid #F1F5F9;
            box-shadow: 0 4px 20px -2px rgba(0, 0, 0, 0.05);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .branch-card:active { transform: scale(0.98); }

        /* INPUT GROUPS: Shadow-Inner Recessed Style */
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
        .input-group:focus-within {
            background-color: white;
            border-color: #3B82F6;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
        }

        .input-group input, .input-group select, .input-group textarea {
            border: none;
            outline: none;
            padding: 14px 0;
            flex-grow: 1;
            background-color: transparent;
            font-weight: 700;
            font-size: 0.875rem;
        }

        /* BOTTOM SHEET STANDARD: 44px Top Radius */
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

        .day-pill {
            padding: 10px 18px;
            border-radius: 14px;
            font-size: 0.75rem;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            cursor: pointer;
            transition: all 0.3s;
            background-color: #F1F5F9;
            color: #94A3B8;
        }
        .day-pill.active {
            background-color: #3B82F6;
            color: white;
            box-shadow: 0 10px 15px -3px rgba(59, 130, 246, 0.3);
        }

        .pool-item {
            border-left: 4px solid #3B82F6;
            background-color: #F8FAFC;
            padding: 20px;
            border-radius: 20px;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.02);
        }

        .no-scrollbar::-webkit-scrollbar { display: none; }
    </style>
</head>
<body class="p-6 md:p-10 pb-32 no-scrollbar">

    <div class="max-w-2xl mx-auto text-left">
        <header class="flex items-center space-x-6 mb-10">
            <button onclick="window.history.back()" class="p-3 bg-white border border-slate-100 text-slate-900 rounded-2xl shadow-sm hover:bg-slate-50 transition-all active:scale-90">
                <svg class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3">
                    <path d="M15 19l-7-7 7-7"></path>
                </svg>
            </button>
            <div>
                <h1 class="text-4xl font-black text-slate-900 tracking-tighter uppercase italic leading-none">My Branches</h1>
                <p class="text-[10px] font-black text-slate-400 uppercase tracking-[0.3em] mt-2 italic">Management Hub</p>
            </div>
        </header>

        <p class="text-sm font-bold text-gray-400 mb-10 leading-relaxed uppercase tracking-widest">Manage academy locations, configure pools and lane capacities, and set operational hours for each branch.</p>

        <div id="branch-list" class="space-y-8">
            </div>
    </div>

    <div id="edit-modal-overlay" class="modal-overlay fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm hidden flex items-end justify-center" onclick="closeModal('edit-modal-overlay')">
        <div class="modal-sheet no-scrollbar overflow-y-auto max-h-[90vh]" onclick="event.stopPropagation()">
            <div class="w-12 h-1.5 bg-slate-100 rounded-full mx-auto mb-10 shadow-inner"></div>
            
            <div class="mb-8">
                <h3 class="text-2xl font-black text-slate-900 uppercase italic tracking-tighter leading-none">Edit <span id="branch-edit-title" class="text-blue-600"></span></h3>
            </div>

            <form id="edit-branch-form" class="space-y-6">
                <input type="hidden" id="edit-branch-id">
                
                <div>
                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Branch Name</label>
                    <div class="input-group">
                        <input type="text" id="edit-name" name="name" required placeholder="e.g., North Olympic Center">
                    </div>
                </div>

                <div>
                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Location URL</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.135a4 4 0 000-5.656l1.5-1.5a4 4 0 115.656 5.656l-4 4a4 4 0 01-5.656 0z"></path></svg>
                        <input type="url" id="edit-url" name="location_url" required>
                    </div>
                </div>

                <div>
                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Operating Hours</label>
                    <div class="flex items-center space-x-3">
                        <div class="input-group flex-1"><input type="time" id="edit-open" name="open_time" required></div>
                        <span class="text-[10px] font-black text-slate-300 uppercase tracking-widest">to</span>
                        <div class="input-group flex-1"><input type="time" id="edit-close" name="close_time" required></div>
                    </div>
                </div>

                <div class="pt-4">
                    <button type="submit" class="w-full py-5 bg-blue-600 text-white rounded-3xl font-black text-xs uppercase tracking-[0.2em] shadow-xl shadow-blue-600/20 active:scale-95 transition-all">
                        Save Changes
                    </button>
                </div>
            </form>
        </div>
    </div>

    <div id="pools-modal-overlay" class="modal-overlay fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm hidden flex items-end justify-center" onclick="closeModal('pools-modal-overlay')">
        <div class="modal-sheet no-scrollbar overflow-y-auto max-h-[90vh]" onclick="event.stopPropagation()">
            <div class="w-12 h-1.5 bg-slate-100 rounded-full mx-auto mb-10 shadow-inner"></div>
            
            <div class="flex justify-between items-center mb-10">
                <h3 class="text-2xl font-black text-slate-900 uppercase italic tracking-tighter">Pools & Lanes</h3>
                <button onclick="addNewPoolUI()" class="p-3 bg-blue-50 text-blue-600 rounded-2xl shadow-inner active:scale-90 transition-all">
                    <svg class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><path d="M12 4v16m8-8H4"></path></svg>
                </button>
            </div>

            <div id="pools-container" class="space-y-4 mb-8">
                </div>

            <button onclick="addNewPoolUI()" class="w-full py-4 border-2 border-dashed border-blue-100 text-blue-600 font-black text-[10px] uppercase tracking-widest rounded-2xl hover:bg-blue-50 transition-all">
                + Add Another Pool
            </button>
        </div>
    </div>

    <div id="days-modal-overlay" class="modal-overlay fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm hidden flex items-end justify-center" onclick="closeModal('days-modal-overlay')">
        <div class="modal-sheet" onclick="event.stopPropagation()">
            <div class="w-12 h-1.5 bg-slate-100 rounded-full mx-auto mb-10 shadow-inner"></div>
            
            <div class="mb-8">
                <h3 class="text-2xl font-black text-slate-900 uppercase italic tracking-tighter">Operational Days</h3>
                <p class="text-xs font-bold text-slate-400 mt-1 uppercase tracking-widest leading-none">Select branch availability</p>
            </div>

            <div id="days-selector" class="flex flex-wrap gap-2 mb-10">
                </div>
            
            <button onclick="saveOperationalDays()" class="w-full py-5 bg-emerald-600 text-white rounded-3xl font-black text-xs uppercase tracking-[0.2em] shadow-xl shadow-emerald-600/20 active:scale-95 transition-all">
                Confirm Days
            </button>
        </div>
    </div>

    <script>
        let branches = [
            { id: 'b1', name: 'Olympic Aquatic Center', city: 'Cairo', openTime: '06:00', closeTime: '22:00', operatingDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
              pools: [{ id: 'p1', name: 'Main Competition Pool', lanes: 10, capacity: 50 }, { id: 'p2', name: 'Warm-up Pool', lanes: 4, capacity: 16 }] },
            { id: 'b2', name: 'Blue Wave Academy', city: 'Alexandria', openTime: '08:00', closeTime: '20:00', operatingDays: ['Sat', 'Sun', 'Mon', 'Tue'],
              pools: [{ id: 'p3', name: 'Standard Pool', lanes: 6, capacity: 30 }] }
        ];

        let currentActiveBranchId = null;

        function renderBranchList() {
            const container = document.getElementById('branch-list');
            container.innerHTML = branches.map(branch => {
                const totalLanes = branch.pools.reduce((sum, p) => sum + p.lanes, 0);
                const totalCapacity = branch.pools.reduce((sum, p) => sum + p.capacity, 0);
                return `
                    <div class="branch-card p-8 group">
                        <div class="flex justify-between items-start mb-8">
                            <div>
                                <h3 class="text-2xl font-black text-slate-900 uppercase italic tracking-tighter leading-none">${branch.name}</h3>
                                <p class="text-[10px] text-blue-600 font-black uppercase tracking-[0.3em] mt-3 italic">${branch.city}</p>
                            </div>
                            <div class="flex space-x-2">
                                <button onclick="openEditModal('${branch.id}')" class="w-11 h-11 bg-slate-50 rounded-2xl flex items-center justify-center text-slate-400 hover:text-blue-600 hover:bg-blue-50 shadow-inner transition-all"><svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.536L15.232 5.232z"></path></svg></button>
                                <button onclick="openDaysModal('${branch.id}')" class="w-11 h-11 bg-slate-50 rounded-2xl flex items-center justify-center text-slate-400 hover:text-emerald-600 hover:bg-emerald-50 shadow-inner transition-all"><svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg></button>
                                <button onclick="openPoolsModal('${branch.id}')" class="w-11 h-11 bg-slate-50 rounded-2xl flex items-center justify-center text-slate-400 hover:text-blue-500 hover:bg-blue-50 shadow-inner transition-all"><svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a2 2 0 00-1.96 1.414l-.727 2.903a2 2 0 01-3.532.547l-1.425-2.138a2 2 0 00-1.664-.89H4v-1.3l2.87-1.148a2 2 0 001.022-1.022l1.148-2.87h1.3v2.703a2 2 0 00.89 1.664l2.138 1.425a2 2 0 01-.547 3.532l-2.903.727a2 2 0 00-1.414 1.96l.477 2.387a2 2 0 00.547 1.022l3.414 3.414a2 2 0 010 2.828l-1.414 1.414a2 2 0 01-2.828 0l-3.414-3.414z"></path></svg></button>
                            </div>
                        </div>

                        <div class="grid grid-cols-2 gap-4 mb-6">
                            <div class="bg-gray-50 p-5 rounded-2xl border border-gray-100 shadow-inner text-left">
                                <p class="text-[9px] text-slate-400 font-black uppercase tracking-widest mb-1">Operating Hours</p>
                                <p class="text-sm font-black text-slate-900 italic uppercase">${branch.openTime} - ${branch.closeTime}</p>
                            </div>
                            <div class="bg-gray-50 p-5 rounded-2xl border border-gray-100 shadow-inner text-left">
                                <p class="text-[9px] text-slate-400 font-black uppercase tracking-widest mb-1">Pools / Capacity</p>
                                <p class="text-sm font-black text-slate-900 italic uppercase">${branch.pools.length} Pools / ${totalCapacity} Swimmers</p>
                            </div>
                        </div>

                        <div class="flex items-center space-x-3 text-slate-300">
                             <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                             <p class="text-[10px] font-black uppercase tracking-widest italic">Configured for ${totalLanes} lanes across all pools.</p>
                        </div>
                    </div>
                `;
            }).join('');
        }

        function openModal(id) { 
            const overlay = document.getElementById(id);
            overlay.classList.remove('hidden');
            overlay.classList.add('flex');
            setTimeout(() => overlay.classList.add('active'), 10);
        }
        
        function closeModal(id) { 
            const overlay = document.getElementById(id);
            overlay.classList.remove('active');
            setTimeout(() => {
                overlay.classList.remove('flex');
                overlay.classList.add('hidden');
            }, 500);
        }

        function openEditModal(branchId) {
            const b = branches.find(x => x.id === branchId);
            currentActiveBranchId = branchId;
            document.getElementById('branch-edit-title').textContent = b.name;
            document.getElementById('edit-branch-id').value = b.id;
            document.getElementById('edit-name').value = b.name;
            document.getElementById('edit-url').value = b.locationUrl || '';
            document.getElementById('edit-open').value = b.openTime;
            document.getElementById('edit-close').value = b.closeTime;
            openModal('edit-modal-overlay');
        }

        function openPoolsModal(branchId) {
            const b = branches.find(x => x.id === branchId);
            currentActiveBranchId = branchId;
            const container = document.getElementById('pools-container');
            container.innerHTML = b.pools.map(pool => `
                <div class="pool-item relative group">
                    <div class="flex justify-between items-center mb-4">
                        <p class="text-sm font-black text-slate-900 uppercase italic tracking-tighter">${pool.name}</p>
                        <button onclick="removePool('${pool.id}')" class="text-slate-300 hover:text-rose-500 transition-all active:scale-90"><svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><path d="M6 18L18 6M6 6l12 12"></path></svg></button>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div><p class="text-[8px] font-black text-slate-400 uppercase tracking-widest leading-none mb-1">Lanes</p><p class="text-sm font-black text-blue-600">${pool.lanes}</p></div>
                        <div><p class="text-[8px] font-black text-slate-400 uppercase tracking-widest leading-none mb-1">Max Cap</p><p class="text-sm font-black text-blue-600">${pool.capacity}</p></div>
                    </div>
                </div>
            `).join('');
            openModal('pools-modal-overlay');
        }

        function openDaysModal(branchId) {
            const b = branches.find(x => x.id === branchId);
            currentActiveBranchId = branchId;
            const allDays = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
            document.getElementById('days-selector').innerHTML = allDays.map(day => `
                <div class="day-pill ${b.operatingDays.includes(day) ? 'active' : ''}" onclick="this.classList.toggle('active')">${day}</div>
            `).join('');
            openModal('days-modal-overlay');
        }

        function saveOperationalDays() {
            const b = branches.find(x => x.id === currentActiveBranchId);
            b.operatingDays = Array.from(document.querySelectorAll('#days-selector .day-pill.active')).map(p => p.textContent);
            closeModal('days-modal-overlay');
            renderBranchList();
            showSnackbar('Operational days updated.');
        }

        document.getElementById('edit-branch-form').onsubmit = (e) => {
            e.preventDefault();
            const b = branches.find(x => x.id === currentActiveBranchId);
            b.name = document.getElementById('edit-name').value;
            b.locationUrl = document.getElementById('edit-url').value;
            b.openTime = document.getElementById('edit-open').value;
            b.closeTime = document.getElementById('edit-close').value;
            renderBranchList();
            closeModal('edit-modal-overlay');
            showSnackbar('Branch details updated.');
        };

        function showSnackbar(msg) {
            const s = document.createElement('div');
            s.className = "fixed bottom-10 left-1/2 -translate-x-1/2 bg-slate-900 text-white px-8 py-4 rounded-full text-[10px] font-black shadow-2xl z-[100] uppercase tracking-[0.2em] animate-bounce";
            s.textContent = msg;
            document.body.appendChild(s);
            setTimeout(() => s.remove(), 3000);
        }

        function addNewPoolUI() {
            const name = prompt("Enter pool name:");
            const lanes = parseInt(prompt("Enter number of lanes:"));
            const cap = parseInt(prompt("Enter max swimmer capacity:"));
            if(name && lanes && cap) {
                branches.find(x => x.id === currentActiveBranchId).pools.push({ id: 'p'+Date.now(), name, lanes, capacity: cap });
                openPoolsModal(currentActiveBranchId);
                renderBranchList();
            }
        }

        function removePool(pid) {
            const b = branches.find(x => x.id === currentActiveBranchId);
            b.pools = b.pools.filter(p => p.id !== pid);
            openPoolsModal(currentActiveBranchId);
            renderBranchList();
        }

        window.onload = renderBranchList;
    </script>
</body>
</html>