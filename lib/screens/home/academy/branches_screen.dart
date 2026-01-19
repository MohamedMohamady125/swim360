<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - My Academy Branches</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
        body {
            font-family: 'Inter', sans-serif;
            background-color: #F7F9FB;
        }
        .branch-card {
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
            transition: transform 0.1s, box-shadow 0.1s;
        }
        .branch-card:hover {
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
        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 99;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .day-pill {
            padding: 6px 12px;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            border: 1px solid #E5E7EB;
            background-color: white;
            color: #6B7280;
        }
        .day-pill.active {
            background-color: #3B82F6;
            color: white;
            border-color: #3B82F6;
        }
        .pool-item {
            border-left: 4px solid #3B82F6;
            background-color: #F9FAFB;
            padding: 12px;
            border-radius: 8px;
        }
    </style>
</head>
<body class="p-4 md:p-8">

    <div class="max-w-xl mx-auto">
        <!-- Header -->
        <div class="flex items-center space-x-4 mb-6">
            <button onclick="window.history.back()" class="p-2 hover:bg-gray-200 rounded-full transition">
                <svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
            </button>
            <h1 class="text-3xl font-extrabold text-gray-800">My Branches</h1>
        </div>
        
        <p class="text-gray-500 mb-8">Manage academy locations, configure pools and lane capacities, and set operational hours for each branch.</p>

        <!-- Branch List Container -->
        <div id="branch-list" class="space-y-6">
            <!-- Branch Cards will be injected here -->
        </div>
    </div>

    <!-- Modals -->

    <!-- 1. Edit Branch Details Modal -->
    <div id="edit-modal-overlay" class="modal-overlay hidden">
        <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md p-6 overflow-y-auto max-h-[90vh]">
            <div class="p-4 border-b flex justify-between items-center sticky top-0 bg-white rounded-t-xl z-10">
                <h3 class="text-2xl font-extrabold text-gray-800">Edit <span id="branch-edit-title" class="text-blue-600"></span></h3>
                <button onclick="closeModal('edit-modal-overlay')" class="text-gray-400 hover:text-gray-600">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            <form id="edit-branch-form" class="p-4 space-y-4">
                <input type="hidden" id="edit-branch-id">
                
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Branch Name</label>
                    <div class="input-group">
                        <input type="text" id="edit-name" name="name" required placeholder="e.g., North Olympic Center">
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Location URL</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.135a4 4 0 000-5.656l1.5-1.5a4 4 0 115.656 5.656l-4 4a4 4 0 01-5.656 0z"></path></svg>
                        <input type="url" id="edit-url" name="location_url" required placeholder="e.g., https://maps.app.goo.gl/...">
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Operating Hours</label>
                    <div class="flex items-center space-x-2">
                        <div class="input-group"><input type="time" id="edit-open" name="open_time" required></div>
                        <span class="text-gray-400">to</span>
                        <div class="input-group"><input type="time" id="edit-close" name="close_time" required></div>
                    </div>
                </div>

                <button type="submit" class="w-full py-4 bg-blue-600 text-white font-bold rounded-xl mt-4 shadow-lg hover:bg-blue-700 transition">Save Changes</button>
            </form>
        </div>
    </div>

    <!-- 2. Manage Pools Modal -->
    <div id="pools-modal-overlay" class="modal-overlay hidden">
        <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md p-6 overflow-y-auto max-h-[90vh]">
            <div class="flex justify-between items-center border-b pb-3 mb-6">
                <h3 class="text-2xl font-extrabold text-gray-800">Pools & Lanes</h3>
                <button onclick="closeModal('pools-modal-overlay')" class="text-gray-400 hover:text-gray-600">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            <div id="pools-container" class="space-y-4 mb-6">
                <!-- Pool items injected here -->
            </div>
            <button onclick="addNewPoolUI()" class="w-full py-2 border-2 border-dashed border-blue-200 text-blue-600 font-bold rounded-xl hover:bg-blue-50 transition">
                + Add Another Pool
            </button>
        </div>
    </div>

    <!-- 3. Operational Days Modal -->
    <div id="days-modal-overlay" class="modal-overlay hidden">
        <div class="bg-white rounded-2xl shadow-2xl w-full max-w-sm p-6">
            <div class="flex justify-between items-center border-b pb-3 mb-6">
                <h3 class="text-2xl font-extrabold text-gray-800">Operational Days</h3>
                <button onclick="closeModal('days-modal-overlay')" class="text-gray-400 hover:text-gray-600">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            <p class="text-sm text-gray-500 mb-6">Select the days this branch is open for training.</p>
            <div id="days-selector" class="flex flex-wrap gap-2 mb-8">
                <!-- Day pills injected here -->
            </div>
            <button onclick="saveOperationalDays()" class="w-full py-3 bg-emerald-600 text-white font-bold rounded-xl shadow-lg">Confirm Days</button>
        </div>
    </div>

    <script>
        // --- MOCK DATA ---
        let branches = [
            {
                id: 'b1',
                name: 'Olympic Aquatic Center',
                city: 'Cairo',
                locationUrl: 'https://maps.app.goo.gl/OlympicAquatic',
                openTime: '06:00',
                closeTime: '22:00',
                operatingDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
                pools: [
                    { id: 'p1', name: 'Main Competition Pool', lanes: 10, capacity: 50 },
                    { id: 'p2', name: 'Warm-up Pool', lanes: 4, capacity: 16 }
                ]
            },
            {
                id: 'b2',
                name: 'Blue Wave Academy',
                city: 'Alexandria',
                locationUrl: 'https://maps.app.goo.gl/BlueWaveAlex',
                openTime: '08:00',
                closeTime: '20:00',
                operatingDays: ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu'],
                pools: [
                    { id: 'p3', name: 'Standard Pool', lanes: 6, capacity: 30 }
                ]
            }
        ];

        let currentActiveBranchId = null;

        // --- CORE FUNCTIONS ---

        function renderBranchList() {
            const container = document.getElementById('branch-list');
            container.innerHTML = branches.map(branch => {
                const totalLanes = branch.pools.reduce((sum, p) => sum + p.lanes, 0);
                const totalCapacity = branch.pools.reduce((sum, p) => sum + p.capacity, 0);

                return `
                    <div class="branch-card p-6 border border-gray-100">
                        <div class="flex justify-between items-start mb-4">
                            <div>
                                <h3 class="text-xl font-extrabold text-gray-900">${branch.name}</h3>
                                <p class="text-xs text-blue-600 font-bold uppercase tracking-wider">${branch.city}</p>
                            </div>
                            <div class="flex space-x-1">
                                <button onclick="openEditModal('${branch.id}')" class="p-2 text-gray-400 hover:text-blue-600 transition" title="Edit Details">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.536L15.232 5.232z"></path></svg>
                                </button>
                                <button onclick="openDaysModal('${branch.id}')" class="p-2 text-gray-400 hover:text-emerald-600 transition" title="Operational Days">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                                </button>
                                <button onclick="openPoolsModal('${branch.id}')" class="p-2 text-gray-400 hover:text-blue-500 transition" title="Manage Pools">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a2 2 0 00-1.96 1.414l-.727 2.903a2 2 0 01-3.532.547l-1.425-2.138a2 2 0 00-1.664-.89H4v-1.3l2.87-1.148a2 2 0 001.022-1.022l1.148-2.87h1.3v2.703a2 2 0 00.89 1.664l2.138 1.425a2 2 0 01-.547 3.532l-2.903.727a2 2 0 00-1.414 1.96l.477 2.387a2 2 0 00.547 1.022l3.414 3.414a2 2 0 010 2.828l-1.414 1.414a2 2 0 01-2.828 0l-3.414-3.414z"></path></svg>
                                </button>
                            </div>
                        </div>

                        <div class="grid grid-cols-2 gap-4 mb-4">
                            <div class="bg-gray-50 p-3 rounded-xl border border-gray-100">
                                <p class="text-[10px] text-gray-400 font-bold uppercase">Operating Hours</p>
                                <p class="text-sm font-bold text-gray-700">${branch.openTime} - ${branch.closeTime}</p>
                            </div>
                            <div class="bg-gray-50 p-3 rounded-xl border border-gray-100">
                                <p class="text-[10px] text-gray-400 font-bold uppercase">Pools / Capacity</p>
                                <p class="text-sm font-bold text-gray-700">${branch.pools.length} Pools / ${totalCapacity} Swimmers</p>
                            </div>
                        </div>

                        <div class="flex items-center space-x-2">
                             <svg class="w-4 h-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                             <p class="text-[11px] text-gray-400">Configured for <strong>${totalLanes} lanes</strong> across all pools.</p>
                        </div>
                    </div>
                `;
            }).join('');
        }

        // --- MODAL LOGIC ---

        function openModal(id) { document.getElementById(id).classList.remove('hidden'); }
        function closeModal(id) { document.getElementById(id).classList.add('hidden'); }

        function openEditModal(branchId) {
            const branch = branches.find(b => b.id === branchId);
            if (!branch) return;
            currentActiveBranchId = branchId;
            
            // Populate Modal Content
            document.getElementById('branch-edit-title').textContent = branch.name;
            document.getElementById('edit-branch-id').value = branch.id;
            document.getElementById('edit-name').value = branch.name;
            document.getElementById('edit-url').value = branch.locationUrl || '';
            document.getElementById('edit-open').value = branch.openTime;
            document.getElementById('edit-close').value = branch.closeTime;
            
            openModal('edit-modal-overlay');
        }

        function openDaysModal(branchId) {
            const branch = branches.find(b => b.id === branchId);
            if (!branch) return;
            currentActiveBranchId = branchId;
            const container = document.getElementById('days-selector');
            const allDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
            
            container.innerHTML = allDays.map(day => `
                <div class="day-pill ${branch.operatingDays.includes(day) ? 'active' : ''}" 
                     onclick="this.classList.toggle('active')">${day}</div>
            `).join('');
            
            openModal('days-modal-overlay');
        }

        function openPoolsModal(branchId) {
            const branch = branches.find(b => b.id === branchId);
            if (!branch) return;
            currentActiveBranchId = branchId;
            const container = document.getElementById('pools-container');
            
            container.innerHTML = branch.pools.map(pool => `
                <div class="pool-item">
                    <div class="flex justify-between items-center mb-2">
                        <p class="text-sm font-bold text-gray-800">${pool.name}</p>
                        <button onclick="removePool('${pool.id}')" class="text-red-400 hover:text-red-600 transition"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-4v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg></button>
                    </div>
                    <div class="grid grid-cols-2 gap-2">
                        <div class="text-[10px] text-gray-500 font-bold uppercase">Lanes: <span class="text-gray-800">${pool.lanes}</span></div>
                        <div class="text-[10px] text-gray-500 font-bold uppercase">Max Cap: <span class="text-gray-800">${pool.capacity}</span></div>
                    </div>
                </div>
            `).join('');
            
            openModal('pools-modal-overlay');
        }

        // --- SUBMISSIONS ---

        document.getElementById('edit-branch-form').onsubmit = (e) => {
            e.preventDefault();
            const branch = branches.find(b => b.id === currentActiveBranchId);
            if (!branch) return;

            branch.name = document.getElementById('edit-name').value;
            branch.locationUrl = document.getElementById('edit-url').value;
            branch.openTime = document.getElementById('edit-open').value;
            branch.closeTime = document.getElementById('edit-close').value;
            
            renderBranchList();
            closeModal('edit-modal-overlay');
            showSnackbar('Branch details updated.');
        };

        function saveOperationalDays() {
            const branch = branches.find(b => b.id === currentActiveBranchId);
            if (!branch) return;

            const selectedDays = Array.from(document.querySelectorAll('#days-selector .day-pill.active'))
                                      .map(p => p.textContent);
            branch.operatingDays = selectedDays;
            closeModal('days-modal-overlay');
            showSnackbar('Operational days updated.');
        }

        function removePool(poolId) {
            const branch = branches.find(b => b.id === currentActiveBranchId);
            if (!branch) return;

            branch.pools = branch.pools.filter(p => p.id !== poolId);
            openPoolsModal(currentActiveBranchId); 
            renderBranchList(); 
            showSnackbar('Pool removed.');
        }

        function addNewPoolUI() {
            const poolName = prompt("Enter pool name:");
            if(!poolName) return;
            const lanesInput = prompt("Enter number of lanes:");
            const lanes = parseInt(lanesInput);
            const capacityInput = prompt("Enter max swimmer capacity:");
            const capacity = parseInt(capacityInput);
            
            if(poolName && !isNaN(lanes) && !isNaN(capacity)) {
                const branch = branches.find(b => b.id === currentActiveBranchId);
                if (branch) {
                    branch.pools.push({
                        id: 'p' + (Date.now()),
                        name: poolName,
                        lanes: lanes,
                        capacity: capacity
                    });
                    openPoolsModal(currentActiveBranchId);
                    renderBranchList();
                    showSnackbar('New pool added.');
                }
            } else {
                showSnackbar('Invalid input. Pool not added.', true);
            }
        }

        function showSnackbar(message, isError = false) {
            const oldSnackbar = document.getElementById('snackbar');
            if (oldSnackbar) oldSnackbar.remove();

            const snack = document.createElement('div');
            snack.id = 'snackbar';
            snack.className = `fixed bottom-6 left-1/2 -translate-x-1/2 px-6 py-3 rounded-xl shadow-lg text-white font-bold transition-all animate-bounce z-[100] ${isError ? 'bg-red-500' : 'bg-blue-600'}`;
            snack.textContent = message;
            document.body.appendChild(snack);
            setTimeout(() => snack.remove(), 3000);
        }

        window.onload = renderBranchList;
    </script>
</body>
</html>