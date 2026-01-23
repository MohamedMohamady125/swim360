<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - My Programs</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F8FAFC; color: #0F172A; }
        
        /* THE BLUEPRINT STANDARD: 32px Radius */
        .program-card {
            background-color: white;
            border-radius: 32px;
            border: 1px solid #F1F5F9;
            box-shadow: 0 4px 20px -2px rgba(0, 0, 0, 0.05);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .program-card:active { transform: scale(0.98); }

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

        .input-group input, .input-group textarea {
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

        .status-pill {
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 0.7rem;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .status-active { background-color: #D1FAE5; color: #065F46; }
        .status-paused { background-color: #FEE2E2; color: #991B1B; }

        .capacity-bar-bg {
            height: 10px;
            background-color: #F1F5F9;
            border-radius: 999px;
            overflow: hidden;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.05);
        }
        .capacity-bar-fill {
            height: 100%;
            background-color: #3B82F6;
            border-radius: 999px;
            transition: width 0.8s cubic-bezier(0.65, 0, 0.35, 1);
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
                <h1 class="text-4xl font-black text-slate-900 tracking-tighter uppercase italic leading-none">My Programs</h1>
                <p class="text-[10px] font-black text-slate-400 uppercase tracking-[0.3em] mt-2 italic">Curriculum Control</p>
            </div>
        </header>

        <p class="text-sm font-bold text-gray-400 mb-10 leading-relaxed uppercase tracking-widest">Manage training levels, define subscription pricing, and control enrollment limits for your academy.</p>

        <div id="program-list" class="space-y-8">
            </div>
    </div>

    <div id="edit-modal-overlay" class="modal-overlay fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm hidden flex items-end justify-center" onclick="closeModal()">
        <div class="modal-sheet no-scrollbar overflow-y-auto max-h-[90vh]" onclick="event.stopPropagation()">
            <div class="w-12 h-1.5 bg-slate-100 rounded-full mx-auto mb-10 shadow-inner"></div>
            
            <div class="mb-8">
                <h3 class="text-2xl font-black text-slate-900 uppercase italic tracking-tighter leading-none">Edit Program</h3>
                <p class="text-[10px] font-black text-blue-600 uppercase tracking-widest mt-1">Configuration Sync</p>
            </div>

            <form id="edit-program-form" class="space-y-6">
                <input type="hidden" id="edit-id">
                
                <div>
                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Program Name (Level)</label>
                    <div class="input-group">
                        <input type="text" id="edit-name" required placeholder="e.g., Intermediate 1">
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-6">
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Price (USD)</label>
                        <div class="input-group">
                            <span class="text-gray-400 font-black mr-2">$</span>
                            <input type="number" id="edit-price" required step="0.01">
                        </div>
                    </div>
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Max Capacity</label>
                        <div class="input-group">
                            <input type="number" id="edit-capacity" required min="1">
                        </div>
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-6">
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Duration</label>
                        <div class="input-group">
                            <input type="text" id="edit-duration" required placeholder="e.g., 1 Month">
                        </div>
                    </div>
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Total Sessions</label>
                        <div class="input-group">
                            <input type="number" id="edit-sessions" required min="1">
                        </div>
                    </div>
                </div>

                <div>
                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Weekly Schedule (Summary)</label>
                    <div class="input-group">
                        <input type="text" id="edit-schedule" required placeholder="e.g., Mon/Wed 4-6 PM">
                    </div>
                </div>

                <div>
                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Short Description</label>
                    <div class="input-group">
                        <textarea id="edit-description" rows="2" required placeholder="Basic description for swimmers."></textarea>
                    </div>
                </div>

                <div class="flex items-center justify-between p-6 bg-gray-50 rounded-3xl border border-gray-100 shadow-inner">
                    <div>
                        <p class="text-sm font-black text-slate-900 uppercase italic leading-none">Program Status</p>
                        <p class="text-[9px] text-gray-400 font-bold uppercase mt-1.5 tracking-widest">Visibility toggle</p>
                    </div>
                    <label class="relative inline-flex items-center cursor-pointer">
                        <input type="checkbox" id="edit-status" class="sr-only peer">
                        <div class="w-12 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
                    </label>
                </div>

                <div class="pt-4">
                    <button type="submit" class="w-full py-5 bg-blue-600 text-white rounded-3xl font-black text-xs uppercase tracking-[0.2em] shadow-xl shadow-blue-600/20 active:scale-95 transition-all">
                        Save Program Details
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        let programs = [
            { id: 'p1', name: 'Beginner - Level 1', description: 'Foundational safety and breath control.', price: 85.00, enrolled: 18, capacity: 20, schedule: 'Sat/Sun 10:00 AM', duration: '1 Month', sessions: 8, status: 'active' },
            { id: 'p2', name: 'Intermediate Squad', description: 'Refining stroke technique and endurance.', price: 120.00, enrolled: 12, capacity: 15, schedule: 'Mon/Wed/Fri 4:00 PM', duration: '3 Months', sessions: 36, status: 'active' },
            { id: 'p3', name: 'Elite Mastery', description: 'Professional race preparation and splits.', price: 250.00, enrolled: 8, capacity: 10, schedule: 'Daily 5:30 AM', duration: '6 Months', sessions: 144, status: 'active' }
        ];

        let currentProgramId = null;

        function renderPrograms() {
            const container = document.getElementById('program-list');
            container.innerHTML = programs.map(program => {
                const fillPercent = (program.enrolled / program.capacity) * 100;
                return `
                    <div class="program-card p-8 group">
                        <div class="flex justify-between items-start mb-8">
                            <div>
                                <div class="flex items-center space-x-3">
                                    <h3 class="text-2xl font-black text-slate-900 uppercase italic tracking-tighter leading-none">${program.name}</h3>
                                    <span class="status-pill ${program.status === 'active' ? 'status-active' : 'status-paused'}">${program.status}</span>
                                </div>
                                <p class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mt-3 leading-relaxed max-w-xs">${program.description}</p>
                            </div>
                            <button onclick="openEditModal('${program.id}')" class="w-11 h-11 bg-slate-50 rounded-2xl flex items-center justify-center text-slate-400 hover:text-blue-600 hover:bg-blue-50 shadow-inner transition-all"><svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path></svg></button>
                        </div>

                        <div class="grid grid-cols-2 gap-4 mb-8">
                            <div class="bg-gray-50 p-5 rounded-2xl border border-gray-100 shadow-inner text-left">
                                <p class="text-[9px] text-slate-400 font-black uppercase tracking-widest mb-1">Pricing</p>
                                <p class="text-xl font-black text-blue-600 italic tracking-tighter leading-none">$${program.price.toFixed(2)}</p>
                            </div>
                            <div class="bg-gray-50 p-5 rounded-2xl border border-gray-100 shadow-inner text-left">
                                <p class="text-[9px] text-slate-400 font-black uppercase tracking-widest mb-1">Schedule</p>
                                <p class="text-sm font-black text-slate-900 italic uppercase leading-none">${program.schedule}</p>
                            </div>
                            <div class="bg-gray-50 p-5 rounded-2xl border border-gray-100 shadow-inner text-left">
                                <p class="text-[9px] text-slate-400 font-black uppercase tracking-widest mb-1">Cycle</p>
                                <p class="text-sm font-black text-slate-900 italic uppercase leading-none">${program.duration}</p>
                            </div>
                            <div class="bg-gray-50 p-5 rounded-2xl border border-gray-100 shadow-inner text-left">
                                <p class="text-[9px] text-slate-400 font-black uppercase tracking-widest mb-1">Total Unit</p>
                                <p class="text-sm font-black text-slate-900 italic uppercase leading-none">${program.sessions} sessions</p>
                            </div>
                        </div>

                        <div class="space-y-3">
                            <div class="flex justify-between items-center text-[10px] font-black uppercase tracking-[0.2em] text-gray-400">
                                <span>Enrollment Flow</span>
                                <span class="text-slate-900 font-black">${program.enrolled} / ${program.capacity} Swimmers</span>
                            </div>
                            <div class="capacity-bar-bg">
                                <div class="capacity-bar-fill" style="width: ${Math.min(fillPercent, 100)}%"></div>
                            </div>
                        </div>
                    </div>
                `;
            }).join('');
        }

        function openModal() { 
            const overlay = document.getElementById('edit-modal-overlay');
            overlay.classList.remove('hidden'); overlay.classList.add('flex');
            setTimeout(() => overlay.classList.add('active'), 10);
        }
        
        function closeModal() { 
            const overlay = document.getElementById('edit-modal-overlay');
            overlay.classList.remove('active');
            setTimeout(() => { overlay.classList.remove('flex'); overlay.classList.add('hidden'); }, 500);
        }

        function openEditModal(id) {
            const p = programs.find(prog => prog.id === id);
            currentProgramId = id;
            document.getElementById('edit-name').value = p.name;
            document.getElementById('edit-price').value = p.price;
            document.getElementById('edit-capacity').value = p.capacity;
            document.getElementById('edit-schedule').value = p.schedule;
            document.getElementById('edit-description').value = p.description;
            document.getElementById('edit-duration').value = p.duration;
            document.getElementById('edit-sessions').value = p.sessions;
            document.getElementById('edit-status').checked = p.status === 'active';
            openModal();
        }

        document.getElementById('edit-program-form').onsubmit = (e) => {
            e.preventDefault();
            const p = programs.find(prog => prog.id === currentProgramId);
            p.name = document.getElementById('edit-name').value;
            p.price = parseFloat(document.getElementById('edit-price').value);
            p.capacity = parseInt(document.getElementById('edit-capacity').value);
            p.schedule = document.getElementById('edit-schedule').value;
            p.description = document.getElementById('edit-description').value;
            p.duration = document.getElementById('edit-duration').value;
            p.sessions = parseInt(document.getElementById('edit-sessions').value);
            p.status = document.getElementById('edit-status').checked ? 'active' : 'paused';
            renderPrograms(); closeModal(); showSnackbar(`Program Updated`);
        };

        function showSnackbar(msg) {
            const s = document.createElement('div');
            s.className = "fixed bottom-10 left-1/2 -translate-x-1/2 bg-slate-900 text-white px-8 py-4 rounded-full text-[10px] font-black shadow-2xl z-[100] uppercase tracking-[0.2em] animate-bounce";
            s.textContent = msg; document.body.appendChild(s);
            setTimeout(() => s.remove(), 3000);
        }

        window.onload = renderPrograms;
    </script>
</body>
</html>