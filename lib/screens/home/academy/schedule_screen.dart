<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - Groups & Schedule</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
        body {
            font-family: 'Inter', sans-serif;
            background-color: #F7F9FB;
        }
        .session-card {
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
            transition: all 0.2s;
            border-left: 6px solid #3B82F6;
        }
        .session-card:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        .day-pill {
            padding: 10px 16px;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            background-color: white;
            color: #6B7280;
            border: 1px solid #E5E7EB;
            min-width: 60px;
            text-align: center;
        }
        .day-pill.active {
            background-color: #3B82F6;
            color: white;
            border-color: #3B82F6;
            box-shadow: 0 4px 6px -1px rgba(59, 130, 246, 0.3);
        }
        .input-group {
            display: flex;
            align-items: center;
            border: 1px solid #E5E7EB;
            border-radius: 12px;
            padding: 0 12px;
            background-color: #FAFAFA;
            transition: border-color 0.2s;
        }
        .input-group:focus-within {
            border-color: #3B82F6;
            box-shadow: 0 0 0 1px #3B82F6;
            background-color: white;
        }
        .input-group input, .input-group select {
            border: none;
            outline: none;
            padding: 12px 0;
            flex-grow: 1;
            background-color: transparent;
        }
        .capacity-bar {
            height: 6px;
            border-radius: 999px;
            background-color: #E5E7EB;
            overflow: hidden;
        }
        .capacity-progress {
            height: 100%;
            background-color: #10B981;
            transition: width 0.3s ease;
        }
        .capacity-warning { background-color: #F59E0B; }
        .capacity-full { background-color: #EF4444; }

        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 99;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .btn-action {
            background-color: #3B82F6;
            color: white;
            font-weight: 700;
            border-radius: 12px;
            transition: all 0.2s;
        }
        .btn-action:hover {
            background-color: #2563EB;
        }
        /* Scroll hide for day navigator */
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
    </style>
</head>
<body class="p-4 md:p-8 pb-24">

    <div class="max-w-xl mx-auto">
        <!-- Header -->
        <div class="flex items-center space-x-4 mb-6">
            <button onclick="window.history.back()" class="p-2 hover:bg-gray-200 rounded-full transition">
                <svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
            </button>
            <h1 class="text-3xl font-extrabold text-gray-800">Schedule</h1>
        </div>

        <!-- Branch Selector -->
        <div class="mb-6">
            <label class="block text-xs font-bold text-gray-400 uppercase mb-2 ml-1">Current Academy Branch</label>
            <div class="input-group">
                <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 10h6"></path></svg>
                <select id="branch-filter" onchange="updateView()">
                    <!-- Populated by JS -->
                </select>
            </div>
        </div>

        <!-- Weekly Day Navigator -->
        <div class="flex space-x-2 overflow-x-auto pb-4 no-scrollbar mb-6" id="day-navigator">
            <!-- Day pills populated by JS -->
        </div>

        <!-- Sessions List -->
        <div id="sessions-list" class="space-y-4">
            <!-- Session cards grouped by time injected here -->
        </div>
    </div>

    <!-- Edit Session Modal -->
    <div id="edit-modal-overlay" class="modal-overlay hidden">
        <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md p-6 overflow-y-auto max-h-[90vh]">
            <div class="flex justify-between items-center border-b pb-3 mb-6">
                <h3 class="text-2xl font-extrabold text-gray-800">Manage Session</h3>
                <button onclick="closeModal('edit-modal-overlay')" class="text-gray-500 hover:text-gray-800 transition">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            
            <form id="edit-session-form" class="space-y-5">
                <input type="hidden" id="edit-session-id">
                
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Time Slot</label>
                    <div class="input-group">
                        <input type="time" id="edit-time" required>
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Assigned Coach</label>
                    <div class="input-group">
                        <select id="edit-coach" required>
                            <!-- Coaches populated by JS -->
                        </select>
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Total Capacity (Swimmers)</label>
                    <div class="input-group">
                        <input type="number" id="edit-capacity" required min="1" placeholder="e.g., 15">
                    </div>
                </div>

                <div class="pt-4 border-t space-y-3">
                    <button type="button" onclick="openSwimmersModal()" class="w-full py-3 border-2 border-blue-600 text-blue-600 font-bold rounded-xl hover:bg-blue-50 transition">
                        Manage Swimmer Roster
                    </button>
                    <button type="submit" class="w-full py-4 bg-blue-600 text-white font-bold rounded-xl shadow-lg hover:bg-blue-700 transition">
                        Save Session Changes
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Swimmers Roster Modal -->
    <div id="swimmers-modal-overlay" class="modal-overlay hidden">
        <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md p-6 overflow-y-auto max-h-[80vh]">
            <div class="flex justify-between items-center border-b pb-3 mb-4">
                <h3 class="text-xl font-bold text-gray-800">Swimmer Roster</h3>
                <button onclick="closeModal('swimmers-modal-overlay')" class="text-gray-400 hover:text-gray-600 transition">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            <div id="swimmers-list" class="space-y-3">
                <!-- Swimmers injected here -->
            </div>
        </div>
    </div>

    <!-- Move Swimmer Modal -->
    <div id="move-modal-overlay" class="modal-overlay hidden">
        <div class="bg-white rounded-2xl shadow-2xl w-full max-w-sm p-6">
            <div class="flex justify-between items-center border-b pb-3 mb-4">
                <h3 class="text-xl font-bold text-gray-800">Move Swimmer</h3>
                <button onclick="closeModal('move-modal-overlay')" class="text-gray-400 hover:text-gray-600">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            <p class="text-sm text-gray-500 mb-4">Select the target group for <strong id="move-swimmer-name"></strong>:</p>
            <div id="target-session-list" class="space-y-2 max-h-60 overflow-y-auto">
                <!-- Other sessions on the same day -->
            </div>
        </div>
    </div>

    <script>
        // --- MOCK DATA ---
        const mockBranches = [
            { id: 'b1', name: 'Olympic Aquatic Center' },
            { id: 'b2', name: 'West Side Academy' }
        ];

        const mockCoaches = [
            { id: 'c1', name: 'Coach Michael' },
            { id: 'c2', name: 'Coach Elena' },
            { id: 'c3', name: 'Coach David' }
        ];

        let sessions = [
            { id: 's1', branchId: 'b1', day: 'Mon', time: '16:00', program: 'Elite Mastery', coachId: 'c1', enrolled: 4, capacity: 15, swimmers: ['Alex J.', 'Sarah C.', 'Mike R.', 'John D.'] },
            { id: 's2', branchId: 'b1', day: 'Mon', time: '17:30', program: 'Junior Squad', coachId: 'c2', enrolled: 2, capacity: 20, swimmers: ['Liam W.', 'Ava M.'] },
            { id: 's3', branchId: 'b1', day: 'Wed', time: '16:00', program: 'Elite Mastery', coachId: 'c1', enrolled: 1, capacity: 15, swimmers: ['Noah G.'] },
            { id: 's4', branchId: 'b2', day: 'Mon', time: '10:00', program: 'Learn to Swim', coachId: 'c3', enrolled: 1, capacity: 10, swimmers: ['Emma S.'] }
        ];

        let currentDay = 'Mon';
        let currentBranchId = 'b1';
        let currentSessionId = null;

        // --- CORE LOGIC ---

        function updateView() {
            currentBranchId = document.getElementById('branch-filter').value;
            renderSchedule();
        }

        function setDay(day) {
            currentDay = day;
            document.querySelectorAll('.day-pill').forEach(p => {
                p.classList.toggle('active', p.textContent === day);
            });
            renderSchedule();
        }

        function renderSchedule() {
            const container = document.getElementById('sessions-list');
            const filtered = sessions.filter(s => s.branchId === currentBranchId && s.day === currentDay);
            
            // Sort by time
            filtered.sort((a, b) => a.time.localeCompare(b.time));

            if (filtered.length === 0) {
                container.innerHTML = `<div class="p-12 text-center text-gray-400 bg-white rounded-2xl border border-dashed border-gray-200 italic">No sessions scheduled for this day.</div>`;
                return;
            }

            container.innerHTML = filtered.map(session => {
                const coach = mockCoaches.find(c => c.id === session.coachId);
                const percent = (session.enrolled / session.capacity) * 100;
                let statusClass = '';
                if (percent >= 100) statusClass = 'capacity-full';
                else if (percent >= 80) statusClass = 'capacity-warning';

                return `
                    <div class="session-card p-5 relative">
                        <div class="flex justify-between items-start mb-3">
                            <div>
                                <p class="text-sm font-black text-blue-600 uppercase tracking-tighter mb-1">${session.time}</p>
                                <h3 class="text-lg font-extrabold text-gray-900">${session.program}</h3>
                            </div>
                            <button onclick="openEditModal('${session.id}')" class="p-2 bg-gray-50 text-gray-400 hover:text-blue-600 rounded-full transition">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.536L15.232 5.232z"></path></svg>
                            </button>
                        </div>
                        
                        <div class="flex items-center space-x-2 mb-4">
                            <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
                            <span class="text-sm font-medium text-gray-600">${coach ? coach.name : 'Unassigned'}</span>
                        </div>

                        <div class="space-y-1.5">
                            <div class="flex justify-between text-[10px] font-bold uppercase tracking-widest text-gray-400">
                                <span>Attendance</span>
                                <span class="${percent >= 100 ? 'text-red-500' : 'text-gray-600'}">${session.enrolled} / ${session.capacity}</span>
                            </div>
                            <div class="capacity-bar">
                                <div class="capacity-progress ${statusClass}" style="width: ${Math.min(percent, 100)}%"></div>
                            </div>
                        </div>
                    </div>
                `;
            }).join('');
        }

        // --- MODAL LOGIC ---

        function openModal(id) { document.getElementById(id).classList.remove('hidden'); }
        function closeModal(id) { document.getElementById(id).classList.add('hidden'); }

        function openEditModal(sessionId) {
            currentSessionId = sessionId;
            const session = sessions.find(s => s.id === sessionId);
            
            document.getElementById('edit-time').value = session.time;
            document.getElementById('edit-coach').value = session.coachId;
            document.getElementById('edit-capacity').value = session.capacity;
            
            openModal('edit-modal-overlay');
        }

        function openSwimmersModal() {
            const session = sessions.find(s => s.id === currentSessionId);
            const container = document.getElementById('swimmers-list');
            
            if (session.swimmers.length === 0) {
                container.innerHTML = `<div class="p-8 text-center text-gray-400 italic">No swimmers enrolled.</div>`;
            } else {
                container.innerHTML = session.swimmers.map(name => `
                    <div class="flex justify-between items-center p-4 bg-gray-50 rounded-xl border border-gray-100">
                        <span class="font-bold text-gray-800">${name}</span>
                        <button onclick="openMoveModal('${name}')" class="px-3 py-1 bg-blue-100 text-blue-600 text-xs font-bold rounded-lg hover:bg-blue-600 hover:text-white transition">
                            Move
                        </button>
                    </div>
                `).join('');
            }
            
            openModal('swimmers-modal-overlay');
        }

        function openMoveModal(swimmerName) {
            document.getElementById('move-swimmer-name').textContent = swimmerName;
            const list = document.getElementById('target-session-list');
            
            // List sessions in the same branch, on the same day, that are NOT the current session
            const otherSessions = sessions.filter(s => s.branchId === currentBranchId && s.day === currentDay && s.id !== currentSessionId);
            
            if (otherSessions.length === 0) {
                list.innerHTML = `<p class="text-center text-gray-400 py-4 italic">No other groups available today.</p>`;
            } else {
                list.innerHTML = otherSessions.map(s => `
                    <button onclick="executeMoveSwimmer('${swimmerName}', '${s.id}')" class="w-full text-left p-4 bg-gray-50 hover:bg-blue-50 border border-gray-100 rounded-xl transition group">
                        <div class="flex justify-between items-center">
                            <div>
                                <p class="text-sm font-bold text-gray-900">${s.program}</p>
                                <p class="text-xs text-blue-600 font-semibold">${s.time}</p>
                            </div>
                            <span class="text-xs text-gray-400 font-bold group-hover:text-blue-600">${s.enrolled}/${s.capacity}</span>
                        </div>
                    </button>
                `).join('');
            }
            
            openModal('move-modal-overlay');
        }

        function executeMoveSwimmer(swimmerName, targetSessionId) {
            const source = sessions.find(s => s.id === currentSessionId);
            const target = sessions.find(s => s.id === targetSessionId);
            
            if (target.enrolled >= target.capacity) {
                showSnackbar("Target group is at maximum capacity!", true);
                return;
            }

            // Remove from source
            source.swimmers = source.swimmers.filter(n => n !== swimmerName);
            source.enrolled = source.swimmers.length;

            // Add to target
            target.swimmers.push(swimmerName);
            target.enrolled = target.swimmers.length;

            renderSchedule();
            closeModal('move-modal-overlay');
            openSwimmersModal(); // Refresh roster view
            showSnackbar(`${swimmerName} moved to ${target.program}.`);
        }

        // --- ACTIONS ---

        document.getElementById('edit-session-form').onsubmit = (e) => {
            e.preventDefault();
            const session = sessions.find(s => s.id === currentSessionId);
            session.time = document.getElementById('edit-time').value;
            session.coachId = document.getElementById('edit-coach').value;
            session.capacity = parseInt(document.getElementById('edit-capacity').value);
            
            renderSchedule();
            closeModal('edit-modal-overlay');
            showSnackbar('Session updated successfully.');
        };

        // --- UI SETUP ---

        function init() {
            const branchSelect = document.getElementById('branch-filter');
            branchSelect.innerHTML = mockBranches.map(b => `<option value="${b.id}">${b.name}</option>`).join('');

            const coachSelect = document.getElementById('edit-coach');
            coachSelect.innerHTML = mockCoaches.map(c => `<option value="${c.id}">${c.name}</option>`).join('');

            const dayNav = document.getElementById('day-navigator');
            const days = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
            dayNav.innerHTML = days.map(d => `<div class="day-pill ${d === 'Mon' ? 'active' : ''}" onclick="setDay('${d}')">${d}</div>`).join('');

            renderSchedule();
        }

        function showSnackbar(message, isError = false) {
            const old = document.getElementById('snackbar');
            if (old) old.remove();
            const snack = document.createElement('div');
            snack.id = 'snackbar';
            snack.className = `fixed bottom-6 left-1/2 -translate-x-1/2 px-6 py-3 rounded-xl shadow-lg text-white font-bold transition-all animate-bounce z-[100] ${isError ? 'bg-red-500' : 'bg-blue-600'}`;
            snack.textContent = message;
            document.body.appendChild(snack);
            setTimeout(() => snack.remove(), 3000);
        }

        window.onload = init;
    </script>
</body>
</html>