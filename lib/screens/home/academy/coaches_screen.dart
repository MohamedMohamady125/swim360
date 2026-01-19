<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - My Coaches</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
        body {
            font-family: 'Inter', sans-serif;
            background-color: #F7F9FB;
        }
        .form-card {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.05);
            padding: 1.5rem;
        }
        .coach-card {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
            transition: transform 0.1s, box-shadow 0.1s;
        }
        .coach-card:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.06);
        }
        .input-group {
            display: flex;
            align-items: center;
            border: 1px solid #E5E7EB;
            border-radius: 8px;
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
        .btn-add {
            background-color: #10B981;
            color: white;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-add:hover {
            background-color: #059263;
            transform: translateY(-1px);
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
        .tag {
            font-size: 0.7rem;
            font-weight: 700;
            padding: 2px 8px;
            border-radius: 9999px;
            text-transform: uppercase;
        }
        .tag-blue { background-color: #DBEAFE; color: #1E40AF; }
        .tag-gray { background-color: #F3F4F6; color: #4B5563; }
    </style>
</head>
<body class="p-4 md:p-8">

    <div class="max-w-xl mx-auto">
        <!-- Header -->
        <div class="flex items-center space-x-4 mb-6">
            <button onclick="window.history.back()" class="p-2 hover:bg-gray-200 rounded-full transition">
                <svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
            </button>
            <h1 class="text-3xl font-extrabold text-gray-800">Coaches</h1>
        </div>

        <!-- BRANCH SELECTOR (Dropdown style) -->
        <div class="mb-6">
            <label class="block text-xs font-bold text-gray-400 uppercase mb-2 ml-1">Filter by Branch</label>
            <div class="input-group">
                <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.828 0l-4.243-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                <select id="branch-filter" onchange="filterByBranch(this.value)">
                    <option value="all">All Branches (Global Roster)</option>
                    <!-- Populated by JS -->
                </select>
            </div>
        </div>
        
        <p class="text-gray-500 mb-6">Manage your training staff and monitor their session workload across academy locations.</p>

        <!-- ADD COACH BANNER -->
        <div class="btn-add flex items-center justify-center p-4 mb-8 shadow-lg" onclick="openAddModal()">
             <svg class="w-6 h-6 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" /></svg>
            <span class="text-lg font-extrabold">Add New Coach</span>
        </div>

        <!-- Coach List Container -->
        <div id="coach-list" class="space-y-4">
            <!-- Coach Cards will be injected here -->
        </div>
    </div>

    <!-- Modals -->

    <!-- 1. Add Coach Modal -->
    <div id="add-modal-overlay" class="modal-overlay hidden">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-md p-6 overflow-y-auto max-h-[90vh]">
            <div class="flex justify-between items-center border-b pb-3 mb-6">
                <h3 class="text-2xl font-extrabold text-gray-800">Register Coach</h3>
                <button onclick="closeAddModal()" class="text-gray-400 hover:text-gray-600">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            <form id="add-coach-form" class="space-y-4">
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Full Name</label>
                    <div class="input-group">
                        <input type="text" name="name" required placeholder="e.g., Coach Sarah Smith">
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Assign to Branch</label>
                    <div class="input-group">
                        <select name="branch_id" id="add-coach-branch-select" required>
                            <!-- Populated by JS -->
                        </select>
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Specialty</label>
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
                    <label class="block text-sm font-bold text-gray-700 mb-1">Brief Bio</label>
                    <div class="input-group">
                        <textarea name="bio" rows="3" placeholder="Experience and certifications..."></textarea>
                    </div>
                </div>
                <button type="submit" class="w-full py-3 bg-blue-600 text-white font-bold rounded-lg mt-4 shadow-lg">Confirm Registration</button>
            </form>
        </div>
    </div>

    <!-- 2. Assign to Program Modal -->
    <div id="assign-modal-overlay" class="modal-overlay hidden">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-md p-6">
            <div class="flex justify-between items-center border-b pb-3 mb-6">
                <h3 class="text-2xl font-extrabold text-gray-800">Assign to Program</h3>
                <button onclick="closeAssignModal()" class="text-gray-400 hover:text-gray-600">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            <p class="text-sm text-gray-600 mb-4">Assign **<span id="assign-coach-name" class="font-bold"></span>** to an active program.</p>
            <form id="assign-form" class="space-y-4">
                <input type="hidden" id="assign-coach-id">
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Select Program</label>
                    <div class="input-group">
                        <select id="program-select" name="program_name" required>
                            <!-- Populated by JS -->
                        </select>
                    </div>
                </div>
                <button type="submit" class="w-full py-3 bg-emerald-600 text-white font-bold rounded-lg">Confirm Assignment</button>
            </form>
        </div>
    </div>

    <!-- 3. Workload Modal -->
    <div id="workload-modal-overlay" class="modal-overlay hidden">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-md p-6">
            <div class="flex justify-between items-center border-b pb-3 mb-4">
                <h3 class="text-2xl font-extrabold text-gray-800">Coach Workload</h3>
                <button onclick="closeWorkloadModal()" class="text-gray-400 hover:text-gray-600">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            <div id="workload-content" class="space-y-4">
                <!-- Schedule list injected here -->
            </div>
        </div>
    </div>

    <script>
        // --- MOCK DATA ---
        const mockBranches = [
            { id: 'b1', name: 'Family Park Academy (Riyadh)' },
            { id: 'b2', name: 'West Side Aquatic (Jeddah)' },
            { id: 'b3', name: 'Coastal Swim Hub (Dammam)' }
        ];

        let coaches = [
            { 
                id: 'c1', name: 'Coach Michael', specialty: 'Stroke Technique', branchId: 'b1',
                programs: ['Elite Mastery', 'Junior Squad'],
                schedule: ['Mon 4 PM', 'Wed 4 PM', 'Fri 5 PM'],
                photo: 'https://placehold.co/100x100/3b82f6/ffffff?text=CM'
            },
            { 
                id: 'c2', name: 'Coach Elena', specialty: 'Beginners', branchId: 'b2',
                programs: ['Learn to Swim'],
                schedule: ['Sat 10 AM', 'Sun 10 AM'],
                photo: 'https://placehold.co/100x100/10b981/ffffff?text=CE'
            },
            { 
                id: 'c3', name: 'Coach David', specialty: 'Endurance', branchId: 'b1',
                programs: ['Triathlon Prep'],
                schedule: ['Tue 6 AM', 'Thu 6 AM'],
                photo: 'https://placehold.co/100x100/ef4444/ffffff?text=CD'
            }
        ];

        const mockPrograms = ['Elite Mastery', 'Junior Squad', 'Learn to Swim', 'Adult Fitness', 'Open Water Prep', 'Triathlon Prep'];

        // --- CORE FUNCTIONS ---

        function getBranchName(branchId) {
            const branch = mockBranches.find(b => b.id === branchId);
            return branch ? branch.name : 'Unknown Branch';
        }

        function filterByBranch(branchId) {
            renderCoachList(branchId);
        }

        function renderCoachList(filterBranchId = 'all') {
            const container = document.getElementById('coach-list');
            
            const filteredCoaches = filterBranchId === 'all' 
                ? coaches 
                : coaches.filter(c => c.branchId === filterBranchId);

            if (filteredCoaches.length === 0) {
                container.innerHTML = `<div class="p-8 text-center text-gray-400 bg-white rounded-xl shadow-sm italic">No coaches assigned to this branch yet.</div>`;
                return;
            }

            container.innerHTML = filteredCoaches.map(coach => `
                <div class="coach-card p-4 flex items-start space-x-4">
                    <img src="${coach.photo}" class="w-16 h-16 rounded-full object-cover border-2 border-blue-100 shadow-sm" alt="${coach.name}">
                    <div class="flex-grow">
                        <div class="flex justify-between items-start">
                            <div>
                                <h3 class="text-lg font-extrabold text-gray-900">${coach.name}</h3>
                                <div class="flex items-center space-x-2 mt-0.5">
                                    <p class="text-xs text-blue-600 font-bold uppercase tracking-wider">${coach.specialty}</p>
                                    <span class="text-gray-300 text-[10px]">|</span>
                                    <span class="text-[10px] text-gray-500 font-medium">${getBranchName(coach.branchId)}</span>
                                </div>
                            </div>
                            <div class="flex space-x-1">
                                <button onclick="openWorkloadModal('${coach.id}')" class="p-2 text-gray-400 hover:text-blue-600 transition" title="View Workload">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
                                </button>
                                <button onclick="openAssignModal('${coach.id}')" class="p-2 text-gray-400 hover:text-emerald-600 transition" title="Assign Program">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v3m0 0v3m0-3h3m-3 0H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                                </button>
                            </div>
                        </div>

                        <div class="mt-3 flex flex-wrap gap-2">
                            ${coach.programs.map(p => `<span class="tag tag-blue">${p}</span>`).join('')}
                        </div>
                        
                        <div class="mt-2 text-[10px] text-gray-400 font-medium italic">
                            Next assigned slot: ${coach.schedule[0] || 'Awaiting schedule'}
                        </div>
                    </div>
                </div>
            `).join('');
        }

        // --- UI INITIALIZATION ---

        function populateBranchSelectors() {
            const filterSelect = document.getElementById('branch-filter');
            const addSelect = document.getElementById('add-coach-branch-select');
            
            mockBranches.forEach(branch => {
                const opt1 = `<option value="${branch.id}">${branch.name}</option>`;
                filterSelect.innerHTML += opt1;
                addSelect.innerHTML += opt1;
            });
        }

        // --- MODAL LOGIC ---

        function openAddModal() { document.getElementById('add-modal-overlay').classList.remove('hidden'); }
        function closeAddModal() { document.getElementById('add-modal-overlay').classList.add('hidden'); }

        function openAssignModal(coachId) {
            const coach = coaches.find(c => c.id === coachId);
            document.getElementById('assign-coach-name').textContent = coach.name;
            document.getElementById('assign-coach-id').value = coachId;
            
            const select = document.getElementById('program-select');
            select.innerHTML = '<option value="" disabled selected>Select a program</option>' + 
                mockPrograms.map(p => `<option value="${p}">${p}</option>`).join('');
            
            document.getElementById('assign-modal-overlay').classList.remove('hidden');
        }
        function closeAssignModal() { document.getElementById('assign-modal-overlay').classList.add('hidden'); }

        function openWorkloadModal(coachId) {
            const coach = coaches.find(c => c.id === coachId);
            const container = document.getElementById('workload-content');
            
            container.innerHTML = `
                <div class="bg-blue-50 p-4 rounded-xl mb-4 border border-blue-100">
                    <p class="text-sm font-bold text-blue-800">${coach.name}'s Schedule</p>
                    <p class="text-xs text-blue-600">${coach.schedule.length} sessions booked this week</p>
                    <p class="text-[10px] text-blue-400 mt-1 uppercase font-bold tracking-tight">${getBranchName(coach.branchId)}</p>
                </div>
                <div class="space-y-2">
                    ${coach.schedule.length > 0 ? coach.schedule.map(s => `
                        <div class="flex justify-between items-center p-3 border border-gray-100 rounded-lg">
                            <span class="text-sm font-semibold text-gray-700">${s}</span>
                            <span class="text-[10px] bg-gray-100 px-2 py-1 rounded text-gray-400 uppercase font-black tracking-widest">Confirmed</span>
                        </div>
                    `).join('') : '<p class="text-center text-gray-400 text-sm py-4">No sessions scheduled for this week.</p>'}
                </div>
            `;
            
            document.getElementById('workload-modal-overlay').classList.remove('hidden');
        }
        function closeWorkloadModal() { document.getElementById('workload-modal-overlay').classList.add('hidden'); }

        // --- FORM SUBMISSIONS ---

        document.getElementById('add-coach-form').onsubmit = (e) => {
            e.preventDefault();
            const formData = new FormData(e.target);
            const newCoach = {
                id: 'c' + (coaches.length + 1),
                name: formData.get('name'),
                branchId: formData.get('branch_id'),
                specialty: formData.get('specialty'),
                bio: formData.get('bio'),
                programs: [],
                schedule: [],
                photo: `https://placehold.co/100x100/3b82f6/ffffff?text=${formData.get('name').charAt(0)}`
            };
            coaches.push(newCoach);
            // Reset filter to 'all' or the newly added coach's branch to see the change
            document.getElementById('branch-filter').value = newCoach.branchId;
            renderCoachList(newCoach.branchId);
            closeAddModal();
            showSnackbar(`${newCoach.name} registered to ${getBranchName(newCoach.branchId)}.`);
        };

        document.getElementById('assign-form').onsubmit = (e) => {
            e.preventDefault();
            const coachId = document.getElementById('assign-coach-id').value;
            const programName = new FormData(e.target).get('program_name');
            
            const coach = coaches.find(c => c.id === coachId);
            if (!coach.programs.includes(programName)) {
                coach.programs.push(programName);
                renderCoachList(document.getElementById('branch-filter').value);
                closeAssignModal();
                showSnackbar(`${coach.name} assigned to ${programName}.`);
            } else {
                showSnackbar(`${coach.name} is already teaching this program.`, true);
            }
        };

        function showSnackbar(message, isError = false) {
            const snack = document.createElement('div');
            snack.className = `fixed bottom-6 left-1/2 -translate-x-1/2 px-6 py-3 rounded-xl shadow-lg text-white font-bold transition-all animate-bounce z-[100] ${isError ? 'bg-red-500' : 'bg-blue-600'}`;
            snack.textContent = message;
            document.body.appendChild(snack);
            setTimeout(() => snack.remove(), 3000);
        }

        window.onload = () => {
            populateBranchSelectors();
            renderCoachList();
        };
    </script>
</body>
</html>