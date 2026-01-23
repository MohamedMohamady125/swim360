<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - My Coaches</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F8FAFC; color: #0F172A; }
        
        /* THE BLUEPRINT STANDARD: 32px Radius */
        .coach-card {
            background-color: white;
            border-radius: 32px;
            border: 1px solid #F1F5F9;
            box-shadow: 0 4px 20px -2px rgba(0, 0, 0, 0.05);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .coach-card:active { transform: scale(0.98); }

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

        .tag {
            font-size: 0.7rem;
            font-weight: 900;
            padding: 4px 12px;
            border-radius: 10px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .tag-blue { background-color: #DBEAFE; color: #1E40AF; }

        .btn-add {
            background-color: #10B981;
            color: white;
            border-radius: 24px;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 10px 15px -3px rgba(16, 185, 129, 0.2);
        }
        .btn-add:active { transform: scale(0.96); }

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
                <h1 class="text-4xl font-black text-slate-900 tracking-tighter uppercase italic leading-none">Coaches</h1>
                <p class="text-[10px] font-black text-slate-400 uppercase tracking-[0.3em] mt-2 italic">Staff Registry</p>
            </div>
        </header>

        <div class="mb-10">
            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Filter by Branch</label>
            <div class="input-group">
                <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.828 0l-4.243-4.243a8 8 0 1111.314 0z"></path><path d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                <select id="branch-filter" onchange="filterByBranch(this.value)">
                    <option value="all">All Branches (Global Roster)</option>
                </select>
            </div>
        </div>
        
        <p class="text-sm font-bold text-gray-400 mb-10 leading-relaxed uppercase tracking-widest">Manage your training staff and monitor their session workload across academy locations.</p>

        <div class="btn-add flex items-center justify-center p-6 mb-10 group" onclick="openModal('add-modal-overlay')">
             <svg class="w-6 h-6 mr-3 transition-transform group-hover:rotate-90" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path d="M12 4v16m8-8H4" /></svg>
            <span class="text-xs font-black uppercase tracking-[0.2em]">Add New Coach</span>
        </div>

        <div id="coach-list" class="space-y-6">
            </div>
    </div>

    <div id="add-modal-overlay" class="modal-overlay fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm hidden flex items-end justify-center" onclick="closeModal('add-modal-overlay')">
        <div class="modal-sheet no-scrollbar overflow-y-auto max-h-[90vh]" onclick="event.stopPropagation()">
            <div class="w-12 h-1.5 bg-slate-100 rounded-full mx-auto mb-10 shadow-inner"></div>
            
            <div class="mb-8">
                <h3 class="text-2xl font-black text-slate-900 uppercase italic tracking-tighter leading-none">Register Coach</h3>
            </div>

            <form id="add-coach-form" class="space-y-6">
                <div>
                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Full Name</label>
                    <div class="input-group">
                        <input type="text" name="name" required placeholder="e.g., Coach Sarah Smith">
                    </div>
                </div>
                <div>
                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Assign to Branch</label>
                    <div class="input-group">
                        <select name="branch_id" id="add-coach-branch-select" required></select>
                    </div>
                </div>
                <div>
                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Specialty</label>
                    <div class="input-group">
                        <select name="specialty" required>
                            <option value="Stroke Technique">Stroke Technique</option>
                            <option value="Endurance">Endurance</option>
                            <option value="Beginners">Beginners</option>
                            <option value="Advanced/Pro">Advanced/Pro</option>
                        </select>
                    </div>
                </div>
                <div>
                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Brief Bio</label>
                    <div class="input-group">
                        <textarea name="bio" rows="3" placeholder="Experience and certifications..."></textarea>
                    </div>
                </div>
                <div class="pt-4">
                    <button type="submit" class="w-full py-5 bg-blue-600 text-white rounded-3xl font-black text-xs uppercase tracking-[0.2em] shadow-xl active:scale-95 transition-all">
                        Confirm Registration
                    </button>
                </div>
            </form>
        </div>
    </div>

    <div id="assign-modal-overlay" class="modal-overlay fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm hidden flex items-end justify-center" onclick="closeModal('assign-modal-overlay')">
        <div class="modal-sheet" onclick="event.stopPropagation()">
            <div class="w-12 h-1.5 bg-slate-100 rounded-full mx-auto mb-10 shadow-inner"></div>
            
            <div class="mb-8">
                <h3 class="text-2xl font-black text-slate-900 uppercase italic tracking-tighter leading-none">Assign to Program</h3>
                <p class="text-sm font-bold text-gray-400 mt-2 uppercase tracking-widest">Assign <span id="assign-coach-name" class="text-blue-600"></span> to an active program.</p>
            </div>

            <form id="assign-form" class="space-y-6">
                <input type="hidden" id="assign-coach-id">
                <div>
                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Select Program</label>
                    <div class="input-group">
                        <select id="program-select" name="program_name" required></select>
                    </div>
                </div>
                <div class="pt-4">
                    <button type="submit" class="w-full py-5 bg-emerald-600 text-white rounded-3xl font-black text-xs uppercase tracking-[0.2em] shadow-xl active:scale-95 transition-all">
                        Confirm Assignment
                    </button>
                </div>
            </form>
        </div>
    </div>

    <div id="workload-modal-overlay" class="modal-overlay fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm hidden flex items-end justify-center" onclick="closeModal('workload-modal-overlay')">
        <div class="modal-sheet no-scrollbar overflow-y-auto max-h-[90vh]" onclick="event.stopPropagation()">
            <div class="w-12 h-1.5 bg-slate-100 rounded-full mx-auto mb-10 shadow-inner"></div>
            
            <div class="mb-8">
                <h3 class="text-2xl font-black text-slate-900 uppercase italic tracking-tighter leading-none">Coach Workload</h3>
            </div>
            <div id="workload-content" class="space-y-6 text-left">
                </div>
        </div>
    </div>

    <script>
        const mockBranches = [
            { id: 'b1', name: 'Family Park Academy (Riyadh)' },
            { id: 'b2', name: 'West Side Aquatic (Jeddah)' },
            { id: 'b3', name: 'Coastal Swim Hub (Dammam)' }
        ];

        let coaches = [
            { id: 'c1', name: 'Coach Michael', specialty: 'Stroke Technique', branchId: 'b1', programs: ['Elite Mastery', 'Junior Squad'], schedule: ['Mon 4 PM', 'Wed 4 PM'], photo: 'https://images.unsplash.com/photo-1548382113-7615065835ee?w=100' },
            { id: 'c2', name: 'Coach Elena', specialty: 'Beginners', branchId: 'b2', programs: ['Learn to Swim'], schedule: ['Sat 10 AM'], photo: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=100' }
        ];

        const mockPrograms = ['Elite Mastery', 'Junior Squad', 'Learn to Swim', 'Adult Fitness'];

        function renderCoachList(filterBranchId = 'all') {
            const container = document.getElementById('coach-list');
            const filtered = filterBranchId === 'all' ? coaches : coaches.filter(c => c.branchId === filterBranchId);

            if (!filtered.length) {
                container.innerHTML = `<div class="p-20 text-center text-gray-300 uppercase font-black text-xs tracking-widest italic">No coaches assigned</div>`;
                return;
            }

            container.innerHTML = filtered.map(c => `
                <div class="coach-card p-6 flex items-start space-x-6">
                    <img src="${c.photo}" class="w-16 h-16 rounded-3xl object-cover border-2 border-white shadow-blueprint">
                    <div class="flex-grow">
                        <div class="flex justify-between items-start">
                            <div>
                                <h3 class="text-xl font-black text-slate-900 uppercase italic tracking-tighter">${c.name}</h3>
                                <p class="text-[10px] text-blue-600 font-black uppercase tracking-widest mt-1">${c.specialty}</p>
                            </div>
                            <div class="flex space-x-2">
                                <button onclick="openWorkloadModal('${c.id}')" class="w-10 h-10 bg-slate-50 rounded-xl flex items-center justify-center text-slate-400 hover:text-blue-600 hover:bg-blue-50 shadow-inner transition-all"><svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg></button>
                                <button onclick="openAssignModal('${c.id}')" class="w-10 h-10 bg-slate-50 rounded-xl flex items-center justify-center text-slate-400 hover:text-emerald-600 hover:bg-emerald-50 shadow-inner transition-all"><svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path d="M12 9v3m0 0v3m0-3h3m-3 0H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg></button>
                            </div>
                        </div>
                        <div class="mt-4 flex flex-wrap gap-2">${c.programs.map(p => `<span class="tag tag-blue">${p}</span>`).join('')}</div>
                    </div>
                </div>
            `).join('');
        }

        function openModal(id) { 
            const overlay = document.getElementById(id);
            overlay.classList.remove('hidden'); overlay.classList.add('flex');
            setTimeout(() => overlay.classList.add('active'), 10);
        }
        
        function closeModal(id) { 
            const overlay = document.getElementById(id);
            overlay.classList.remove('active');
            setTimeout(() => { overlay.classList.remove('flex'); overlay.classList.add('hidden'); }, 500);
        }

        function filterByBranch(id) { renderCoachList(id); }

        function openWorkloadModal(id) {
            const c = coaches.find(x => x.id === id);
            document.getElementById('workload-content').innerHTML = `
                <div class="bg-blue-50 p-6 rounded-3xl border border-blue-100 shadow-inner mb-6">
                    <p class="text-[9px] font-black text-blue-600 uppercase tracking-widest mb-1">Active Staff</p>
                    <p class="text-xl font-black text-slate-900 uppercase italic">${c.name}</p>
                </div>
                <div class="space-y-3">
                    ${c.schedule.map(s => `
                        <div class="p-4 bg-gray-50 border border-slate-100 rounded-2xl flex justify-between items-center shadow-inner">
                            <span class="text-sm font-black text-slate-900 uppercase">${s}</span>
                            <span class="text-[9px] font-black text-emerald-500 uppercase tracking-widest">Confirmed</span>
                        </div>
                    `).join('')}
                </div>
            `;
            openModal('workload-modal-overlay');
        }

        function openAssignModal(id) {
            const c = coaches.find(x => x.id === id);
            document.getElementById('assign-coach-name').textContent = c.name;
            document.getElementById('assign-coach-id').value = id;
            document.getElementById('program-select').innerHTML = '<option disabled selected>Select a program</option>' + mockPrograms.map(p => `<option value="${p}">${p}</option>`).join('');
            openModal('assign-modal-overlay');
        }

        document.getElementById('add-coach-form').onsubmit = (e) => {
            e.preventDefault();
            const f = new FormData(e.target);
            coaches.push({ id: 'c'+Date.now(), name: f.get('name'), specialty: f.get('specialty'), branchId: f.get('branch_id'), programs: [], schedule: [], photo: 'https://images.unsplash.com/photo-1548382113-7615065835ee?w=100' });
            renderCoachList(); closeModal('add-modal-overlay'); showSnackbar('Coach Registered');
        };

        function showSnackbar(msg) {
            const s = document.createElement('div');
            s.className = "fixed top-10 left-1/2 -translate-x-1/2 bg-slate-900 text-white px-8 py-4 rounded-full text-[10px] font-black shadow-2xl z-[100] uppercase tracking-[0.2em] animate-bounce";
            s.textContent = msg; document.body.appendChild(s);
            setTimeout(() => s.remove(), 3000);
        }

        window.onload = () => {
            const f = document.getElementById('branch-filter');
            const a = document.getElementById('add-coach-branch-select');
            mockBranches.forEach(b => { f.innerHTML += `<option value="${b.id}">${b.name}</option>`; a.innerHTML += `<option value="${b.id}">${b.name}</option>`; });
            renderCoachList();
        };
    </script>
</body>
</html>