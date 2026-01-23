<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - Schedule</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F8FAFC; color: #0F172A; }
        
        /* THE BLUEPRINT STANDARD: 32px Radius */
        .session-card {
            background-color: white;
            border-radius: 32px;
            border: 1px solid #F1F5F9;
            box-shadow: 0 4px 20px -2px rgba(0, 0, 0, 0.05);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border-left: 8px solid #3B82F6;
        }
        .session-card:active { transform: scale(0.98); }

        /* DAY PILLS: Standardized Navigation */
        .day-pill {
            padding: 12px 20px;
            border-radius: 16px;
            font-size: 0.8rem;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            cursor: pointer;
            transition: all 0.3s;
            background-color: white;
            color: #94A3B8;
            border: 1px solid #F1F5F9;
            min-width: 70px;
            text-align: center;
        }
        .day-pill.active {
            background-color: #3B82F6;
            color: white;
            border-color: #3B82F6;
            box-shadow: 0 10px 15px -3px rgba(59, 130, 246, 0.3);
        }

        /* INPUT GROUPS: Shadow-Inner Style */
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

        .input-group input, .input-group select {
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

        .capacity-bar {
            height: 10px;
            background-color: #F1F5F9;
            border-radius: 999px;
            overflow: hidden;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.05);
        }
        .capacity-progress {
            height: 100%;
            background-color: #10B981;
            border-radius: 999px;
            transition: width 0.8s cubic-bezier(0.65, 0, 0.35, 1);
        }
        .capacity-warning { background-color: #F59E0B; }
        .capacity-full { background-color: #EF4444; }

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
                <h1 class="text-4xl font-black text-slate-900 tracking-tighter uppercase italic leading-none">Schedule</h1>
                <p class="text-[10px] font-black text-slate-400 uppercase tracking-[0.3em] mt-2 italic">Live Session Management</p>
            </div>
        </header>

        <div class="mb-10">
            <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Current Academy Branch</label>
            <div class="input-group">
                <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 10h6"></path></svg>
                <select id="branch-filter" onchange="updateView()">
                    </select>
            </div>
        </div>

        <div class="flex space-x-3 overflow-x-auto pb-6 no-scrollbar mb-6" id="day-navigator">
            </div>

        <div id="sessions-list" class="space-y-6">
            </div>
    </div>

    <div id="edit-modal-overlay" class="modal-overlay fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm hidden flex items-end justify-center" onclick="closeModal('edit-modal-overlay')">
        <div class="modal-sheet no-scrollbar overflow-y-auto max-h-[90vh]" onclick="event.stopPropagation()">
            <div class="w-12 h-1.5 bg-slate-100 rounded-full mx-auto mb-10 shadow-inner"></div>
            
            <div class="mb-8">
                <h3 class="text-2xl font-black text-slate-900 uppercase italic tracking-tighter leading-none">Manage Session</h3>
            </div>
            
            <form id="edit-session-form" class="space-y-6">
                <input type="hidden" id="edit-session-id">
                
                <div>
                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Time Slot</label>
                    <div class="input-group">
                        <input type="time" id="edit-time" required>
                    </div>
                </div>

                <div>
                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Assigned Coach</label>
                    <div class="input-group">
                        <select id="edit-coach" required></select>
                    </div>
                </div>

                <div>
                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Total Capacity (Swimmers)</label>
                    <div class="input-group">
                        <input type="number" id="edit-capacity" required min="1">
                    </div>
                </div>

                <div class="pt-4 space-y-4">
                    <button type="button" onclick="openSwimmersModal()" class="w-full py-4 border-2 border-dashed border-blue-100 text-blue-600 font-black text-[10px] uppercase tracking-widest rounded-2xl hover:bg-blue-50 transition-all">
                        Manage Swimmer Roster
                    </button>
                    <button type="submit" class="w-full py-5 bg-blue-600 text-white rounded-3xl font-black text-xs uppercase tracking-[0.2em] shadow-xl active:scale-95 transition-all">
                        Save Session Changes
                    </button>
                </div>
            </form>
        </div>
    </div>

    <div id="swimmers-modal-overlay" class="modal-overlay fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm hidden flex items-end justify-center" onclick="closeModal('swimmers-modal-overlay')">
        <div class="modal-sheet no-scrollbar overflow-y-auto max-h-[85vh]" onclick="event.stopPropagation()">
            <div class="w-12 h-1.5 bg-slate-100 rounded-full mx-auto mb-10 shadow-inner"></div>
            
            <div class="mb-8">
                <h3 class="text-2xl font-black text-slate-900 uppercase italic tracking-tighter leading-none">Swimmer Roster</h3>
            </div>
            
            <div id="swimmers-list" class="space-y-3">
                </div>
        </div>
    </div>

    <div id="move-modal-overlay" class="modal-overlay fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm hidden flex items-end justify-center" onclick="closeModal('move-modal-overlay')">
        <div class="modal-sheet" onclick="event.stopPropagation()">
            <div class="w-12 h-1.5 bg-slate-100 rounded-full mx-auto mb-10 shadow-inner"></div>
            
            <div class="mb-6">
                <h3 class="text-2xl font-black text-slate-900 uppercase italic tracking-tighter leading-none">Move Swimmer</h3>
                <p class="text-xs font-bold text-slate-400 mt-2 uppercase tracking-widest leading-none">Select target group for <span id="move-swimmer-name" class="text-blue-600"></span></p>
            </div>

            <div id="target-session-list" class="space-y-3 max-h-60 overflow-y-auto no-scrollbar">
                </div>
        </div>
    </div>

    <script>
        const mockBranches = [{ id: 'b1', name: 'Olympic Aquatic Center' }, { id: 'b2', name: 'West Side Academy' }];
        const mockCoaches = [{ id: 'c1', name: 'Coach Michael' }, { id: 'c2', name: 'Coach Elena' }, { id: 'c3', name: 'Coach David' }];
        let sessions = [
            { id: 's1', branchId: 'b1', day: 'Mon', time: '16:00', program: 'Elite Mastery', coachId: 'c1', enrolled: 4, capacity: 15, swimmers: ['Alex J.', 'Sarah C.', 'Mike R.', 'John D.'] },
            { id: 's2', branchId: 'b1', day: 'Mon', time: '17:30', program: 'Junior Squad', coachId: 'c2', enrolled: 2, capacity: 20, swimmers: ['Liam W.', 'Ava M.'] },
            { id: 's3', branchId: 'b1', day: 'Wed', time: '16:00', program: 'Elite Mastery', coachId: 'c1', enrolled: 1, capacity: 15, swimmers: ['Noah G.'] }
        ];

        let currentDay = 'Mon';
        let currentBranchId = 'b1';
        let currentSessionId = null;

        function updateView() { currentBranchId = document.getElementById('branch-filter').value; renderSchedule(); }

        function setDay(day) {
            currentDay = day;
            document.querySelectorAll('.day-pill').forEach(p => p.classList.toggle('active', p.textContent === day));
            renderSchedule();
        }

        function renderSchedule() {
            const container = document.getElementById('sessions-list');
            const filtered = sessions.filter(s => s.branchId === currentBranchId && s.day === currentDay).sort((a, b) => a.time.localeCompare(b.time));

            if (!filtered.length) {
                container.innerHTML = `<div class="p-12 text-center text-gray-300 uppercase font-black text-xs tracking-[0.2em] bg-white rounded-[32px] border border-dashed border-gray-100 italic">No sessions scheduled</div>`;
                return;
            }

            container.innerHTML = filtered.map(s => {
                const coach = mockCoaches.find(c => c.id === s.coachId);
                const percent = (s.enrolled / s.capacity) * 100;
                let statusClass = percent >= 100 ? 'capacity-full' : (percent >= 80 ? 'capacity-warning' : '');

                return `
                    <div class="session-card p-8 relative">
                        <div class="flex justify-between items-start mb-6">
                            <div>
                                <p class="text-xl font-black text-blue-600 uppercase italic tracking-tighter leading-none">${s.time}</p>
                                <h3 class="text-2xl font-black text-gray-900 uppercase tracking-tighter mt-3">${s.program}</h3>
                                <div class="flex items-center space-x-2 mt-4 text-slate-400">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
                                    <span class="text-[10px] font-black uppercase tracking-widest">${coach ? coach.name : 'Unassigned'}</span>
                                </div>
                            </div>
                            <button onclick="openEditModal('${s.id}')" class="w-11 h-11 bg-slate-50 rounded-2xl flex items-center justify-center text-slate-400 hover:text-blue-600 hover:bg-blue-50 shadow-inner transition-all"><svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.536L15.232 5.232z"></path></svg></button>
                        </div>
                        
                        <div class="space-y-3">
                            <div class="flex justify-between text-[9px] font-black uppercase tracking-widest text-gray-400">
                                <span>Attendance</span>
                                <span class="${percent >= 100 ? 'text-rose-500' : 'text-slate-900'}">${s.enrolled} / ${s.capacity}</span>
                            </div>
                            <div class="capacity-bar">
                                <div class="capacity-progress ${statusClass}" style="width: ${Math.min(percent, 100)}%"></div>
                            </div>
                        </div>
                    </div>
                `;
            }).join('');
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

        function openEditModal(id) {
            currentSessionId = id;
            const s = sessions.find(x => x.id === id);
            document.getElementById('edit-time').value = s.time;
            document.getElementById('edit-coach').value = s.coachId;
            document.getElementById('edit-capacity').value = s.capacity;
            openModal('edit-modal-overlay');
        }

        function openSwimmersModal() {
            const s = sessions.find(x => x.id === currentSessionId);
            const container = document.getElementById('swimmers-list');
            container.innerHTML = s.swimmers.length ? s.swimmers.map(name => `
                <div class="flex justify-between items-center p-5 bg-gray-50 rounded-2xl border border-gray-100 shadow-inner">
                    <span class="text-sm font-black text-slate-900 uppercase italic tracking-tighter">${name}</span>
                    <button onclick="openMoveModal('${name}')" class="px-4 py-2 bg-blue-50 text-blue-600 rounded-xl font-black text-[10px] uppercase tracking-widest hover:bg-blue-600 hover:text-white transition-all active:scale-95">Move</button>
                </div>
            `).join('') : '<p class="p-10 text-center text-gray-400 italic">No swimmers enrolled</p>';
            openModal('swimmers-modal-overlay');
        }

        function openMoveModal(name) {
            document.getElementById('move-swimmer-name').textContent = name;
            const others = sessions.filter(s => s.branchId === currentBranchId && s.day === currentDay && s.id !== currentSessionId);
            document.getElementById('target-session-list').innerHTML = others.length ? others.map(s => `
                <button onclick="executeMoveSwimmer('${name}', '${s.id}')" class="w-full p-5 bg-gray-50 border border-gray-100 rounded-2xl text-left shadow-inner group active:scale-[0.98] transition-all">
                    <div class="flex justify-between items-center">
                        <div><p class="text-sm font-black text-slate-900 uppercase">${s.program}</p><p class="text-[9px] text-blue-600 font-bold uppercase mt-1">${s.time}</p></div>
                        <span class="text-[9px] font-black text-gray-400 uppercase">${s.enrolled}/${s.capacity}</span>
                    </div>
                </button>
            `).join('') : '<p class="text-center text-gray-400 py-10 italic uppercase font-black text-[10px]">No target groups</p>';
            openModal('move-modal-overlay');
        }

        function executeMoveSwimmer(name, targetId) {
            const target = sessions.find(s => s.id === targetId);
            if (target.enrolled >= target.capacity) { showSnackbar("Group is Full!", true); return; }
            const src = sessions.find(s => s.id === currentSessionId);
            src.swimmers = src.swimmers.filter(n => n !== name); src.enrolled = src.swimmers.length;
            target.swimmers.push(name); target.enrolled = target.swimmers.length;
            renderSchedule(); closeModal('move-modal-overlay'); openSwimmersModal(); showSnackbar(`${name} Moved`);
        }

        document.getElementById('edit-session-form').onsubmit = (e) => {
            e.preventDefault();
            const s = sessions.find(x => x.id === currentSessionId);
            s.time = document.getElementById('edit-time').value;
            s.coachId = document.getElementById('edit-coach').value;
            s.capacity = parseInt(document.getElementById('edit-capacity').value);
            renderSchedule(); closeModal('edit-modal-overlay'); showSnackbar('Session Updated');
        };

        function showSnackbar(msg, err = false) {
            const s = document.createElement('div');
            s.className = `fixed bottom-10 left-1/2 -translate-x-1/2 px-8 py-4 rounded-full text-[10px] font-black shadow-2xl z-[100] uppercase tracking-[0.2em] animate-bounce ${err ? 'bg-rose-500' : 'bg-slate-900'} text-white`;
            s.textContent = msg; document.body.appendChild(s);
            setTimeout(() => s.remove(), 3000);
        }

        window.onload = () => {
            document.getElementById('branch-filter').innerHTML = mockBranches.map(b => `<option value="${b.id}">${b.name}</option>`).join('');
            document.getElementById('edit-coach').innerHTML = mockCoaches.map(c => `<option value="${c.id}">${c.name}</option>`).join('');
            document.getElementById('day-navigator').innerHTML = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'].map(d => `<div class="day-pill ${d === 'Mon' ? 'active' : ''}" onclick="setDay('${d}')">${d}</div>`).join('');
            renderSchedule();
        };
    </script>
</body>
</html>