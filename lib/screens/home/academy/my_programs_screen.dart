<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - My Programs</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
        body {
            font-family: 'Inter', sans-serif;
            background-color: #F7F9FB;
        }
        .program-card {
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
            transition: all 0.2s;
            border: 1px solid #E5E7EB;
        }
        .program-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        .status-pill {
            padding: 4px 10px;
            border-radius: 9999px;
            font-size: 0.7rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }
        .status-active { background-color: #D1FAE5; color: #065F46; }
        .status-paused { background-color: #FEE2E2; color: #991B1B; }

        .capacity-bar-bg {
            height: 8px;
            background-color: #F3F4F6;
            border-radius: 999px;
            overflow: hidden;
        }
        .capacity-bar-fill {
            height: 100%;
            background-color: #3B82F6;
            transition: width 0.4s ease-out;
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
        .input-group input, .input-group select, .input-group textarea {
            border: none;
            outline: none;
            padding: 12px 0;
            flex-grow: 1;
            background-color: transparent;
        }
        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 99;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .view-container {
            animation: fadeIn 0.3s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body class="p-4 md:p-8 pb-24">

    <div class="max-w-xl mx-auto">
        <!-- Header -->
        <div class="flex items-center space-x-4 mb-6">
            <button onclick="window.history.back()" class="p-2 hover:bg-gray-200 rounded-full transition">
                <svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
            </button>
            <h1 class="text-3xl font-extrabold text-gray-800">My Programs</h1>
        </div>

        <p class="text-gray-500 mb-8">Manage training levels, define subscription pricing, and control enrollment limits for your academy.</p>

        <!-- Program List Container -->
        <div id="program-list" class="space-y-4">
            <!-- Program Cards injected here -->
        </div>
    </div>

    <!-- Edit Program Modal -->
    <div id="edit-modal-overlay" class="modal-overlay hidden">
        <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md p-6 overflow-y-auto max-h-[90vh]">
            <div class="flex justify-between items-center border-b pb-3 mb-6">
                <h3 class="text-2xl font-extrabold text-gray-800">Edit Program</h3>
                <button onclick="closeModal()" class="text-gray-400 hover:text-gray-600 transition">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            
            <form id="edit-program-form" class="space-y-5">
                <input type="hidden" id="edit-id">
                
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Program Name (Level)</label>
                    <div class="input-group">
                        <input type="text" id="edit-name" required placeholder="e.g., Intermediate 1">
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">Price (USD)</label>
                        <div class="input-group">
                            <span class="text-gray-400 font-bold mr-2">$</span>
                            <input type="number" id="edit-price" required step="0.01">
                        </div>
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">Max Capacity</label>
                        <div class="input-group">
                            <input type="number" id="edit-capacity" required min="1">
                        </div>
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">Duration</label>
                        <div class="input-group">
                            <input type="text" id="edit-duration" required placeholder="e.g., 1 Month">
                        </div>
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">Total Sessions</label>
                        <div class="input-group">
                            <input type="number" id="edit-sessions" required min="1" placeholder="e.g., 8">
                        </div>
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Weekly Schedule (Summary)</label>
                    <div class="input-group">
                        <input type="text" id="edit-schedule" required placeholder="e.g., Mon/Wed 4-6 PM">
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Short Description</label>
                    <div class="input-group">
                        <textarea id="edit-description" rows="2" required placeholder="Basic description for swimmers."></textarea>
                    </div>
                </div>

                <div class="flex items-center justify-between p-4 bg-gray-50 rounded-xl border border-gray-100">
                    <div>
                        <p class="text-sm font-bold text-gray-800">Program Status</p>
                        <p class="text-xs text-gray-500">Paused programs hide from new signups.</p>
                    </div>
                    <label class="relative inline-flex items-center cursor-pointer">
                        <input type="checkbox" id="edit-status" class="sr-only peer">
                        <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
                    </label>
                </div>

                <button type="submit" class="w-full py-4 bg-blue-600 text-white font-bold rounded-xl shadow-lg hover:bg-blue-700 transition mt-4">
                    Save Program Details
                </button>
            </form>
        </div>
    </div>

    <script>
        // --- MOCK DATA ---
        let programs = [
            { 
                id: 'p1', 
                name: 'Beginner - Level 1', 
                description: 'Foundational safety and breath control.',
                price: 85.00, 
                enrolled: 18, 
                capacity: 20, 
                schedule: 'Sat/Sun 10:00 AM', 
                duration: '1 Month',
                sessions: 8,
                status: 'active' 
            },
            { 
                id: 'p2', 
                name: 'Intermediate Squad', 
                description: 'Refining stroke technique and endurance.',
                price: 120.00, 
                enrolled: 12, 
                capacity: 15, 
                schedule: 'Mon/Wed/Fri 4:00 PM', 
                duration: '3 Months',
                sessions: 36,
                status: 'active' 
            },
            { 
                id: 'p3', 
                name: 'Elite Mastery', 
                description: 'Professional race preparation and splits.',
                price: 250.00, 
                enrolled: 8, 
                capacity: 10, 
                schedule: 'Daily 5:30 AM', 
                duration: '6 Months',
                sessions: 144,
                status: 'active' 
            },
            { 
                id: 'p4', 
                name: 'Adult Fitness', 
                description: 'Low-impact cardio for wellness.',
                price: 60.00, 
                enrolled: 5, 
                capacity: 20, 
                schedule: 'Tue/Thu 7:00 PM', 
                duration: 'Ongoing',
                sessions: 8,
                status: 'paused' 
            }
        ];

        let currentProgramId = null;

        // --- CORE FUNCTIONS ---

        function renderPrograms() {
            const container = document.getElementById('program-list');
            container.innerHTML = programs.map(program => {
                const fillPercent = (program.enrolled / program.capacity) * 100;
                const isActive = program.status === 'active';

                return `
                    <div class="program-card p-5 view-container">
                        <div class="flex justify-between items-start mb-2">
                            <div>
                                <div class="flex items-center space-x-2">
                                    <h3 class="text-xl font-extrabold text-gray-900">${program.name}</h3>
                                    <span class="status-pill ${isActive ? 'status-active' : 'status-paused'}">
                                        ${program.status}
                                    </span>
                                </div>
                                <p class="text-sm text-gray-500 font-medium">${program.description}</p>
                            </div>
                            <button onclick="openEditModal('${program.id}')" class="p-2 text-gray-400 hover:text-blue-600 transition">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path></svg>
                            </button>
                        </div>

                        <!-- Details Grid -->
                        <div class="grid grid-cols-2 gap-3 my-4">
                            <div class="bg-gray-50 p-3 rounded-xl border border-gray-100">
                                <p class="text-[9px] text-gray-400 font-bold uppercase tracking-widest">Price</p>
                                <p class="text-lg font-black text-blue-600">$${program.price.toFixed(2)}</p>
                            </div>
                            <div class="bg-gray-50 p-3 rounded-xl border border-gray-100">
                                <p class="text-[9px] text-gray-400 font-bold uppercase tracking-widest">Schedule</p>
                                <p class="text-xs font-bold text-gray-700 truncate">${program.schedule}</p>
                            </div>
                            <div class="bg-gray-50 p-3 rounded-xl border border-gray-100">
                                <p class="text-[9px] text-gray-400 font-bold uppercase tracking-widest">Duration</p>
                                <p class="text-xs font-bold text-gray-700">${program.duration}</p>
                            </div>
                            <div class="bg-gray-50 p-3 rounded-xl border border-gray-100">
                                <p class="text-[9px] text-gray-400 font-bold uppercase tracking-widest">Sessions</p>
                                <p class="text-xs font-bold text-gray-700">${program.sessions} per program</p>
                            </div>
                        </div>

                        <div class="space-y-2">
                            <div class="flex justify-between items-center text-[10px] font-bold uppercase tracking-widest text-gray-400">
                                <span>Capacity</span>
                                <span>${program.enrolled} / ${program.capacity} Enrolled</span>
                            </div>
                            <div class="capacity-bar-bg">
                                <div class="capacity-bar-fill" style="width: ${Math.min(fillPercent, 100)}%"></div>
                            </div>
                        </div>
                    </div>
                `;
            }).join('');
        }

        // --- MODAL LOGIC ---

        function openEditModal(id) {
            const program = programs.find(p => p.id === id);
            if (!program) return;
            currentProgramId = id;

            document.getElementById('edit-id').value = program.id;
            document.getElementById('edit-name').value = program.name;
            document.getElementById('edit-price').value = program.price;
            document.getElementById('edit-capacity').value = program.capacity;
            document.getElementById('edit-schedule').value = program.schedule;
            document.getElementById('edit-description').value = program.description;
            document.getElementById('edit-duration').value = program.duration;
            document.getElementById('edit-sessions').value = program.sessions;
            document.getElementById('edit-status').checked = program.status === 'active';

            document.getElementById('edit-modal-overlay').classList.remove('hidden');
        }

        function closeModal() {
            document.getElementById('edit-modal-overlay').classList.add('hidden');
        }

        document.getElementById('edit-program-form').onsubmit = (e) => {
            e.preventDefault();
            const program = programs.find(p => p.id === currentProgramId);
            
            program.name = document.getElementById('edit-name').value;
            program.price = parseFloat(document.getElementById('edit-price').value);
            program.capacity = parseInt(document.getElementById('edit-capacity').value);
            program.schedule = document.getElementById('edit-schedule').value;
            program.description = document.getElementById('edit-description').value;
            program.duration = document.getElementById('edit-duration').value;
            program.sessions = parseInt(document.getElementById('edit-sessions').value);
            program.status = document.getElementById('edit-status').checked ? 'active' : 'paused';

            renderPrograms();
            closeModal();
            showSnackbar(`Program "${program.name}" updated successfully.`);
        };

        function showSnackbar(message) {
            const snackbar = document.createElement('div');
            snackbar.textContent = message;
            snackbar.className = `fixed bottom-6 left-1/2 -translate-x-1/2 px-6 py-3 rounded-xl shadow-lg text-white bg-blue-600 font-bold transition-all animate-bounce z-[100]`;
            document.body.appendChild(snackbar);
            setTimeout(() => snackbar.remove(), 3000);
        }

        window.onload = renderPrograms;
    </script>
</body>
</html>