<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - Add Academy Branch</title>
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
            border-radius: 20px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .input-group {
            display: flex;
            align-items: center;
            border: 1px solid #E5E7EB;
            border-radius: 12px;
            padding: 0 12px;
            background-color: #FAFAFA;
            transition: border-color 0.2s, box-shadow 0.2s;
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
        .day-pill {
            padding: 8px 14px;
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
            box-shadow: 0 4px 6px -1px rgba(59, 130, 246, 0.3);
        }
        .pool-entry {
            background-color: #F9FAFB;
            border-radius: 12px;
            padding: 1rem;
            border: 1px solid #E5E7EB;
        }
        .btn-submit {
            background-color: #10B981;
            color: white;
            transition: all 0.2s;
        }
        .btn-submit:hover {
            background-color: #059263;
            transform: translateY(-1px);
        }
    </style>
</head>
<body class="p-4 md:p-8 pb-20">

    <div class="max-w-xl mx-auto">
        <!-- Header -->
        <div class="flex items-center space-x-4 mb-6">
            <button onclick="window.history.back()" class="p-2 hover:bg-gray-200 rounded-full transition">
                <svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
            </button>
            <h1 class="text-3xl font-extrabold text-gray-800">Add Branch</h1>
        </div>

        <p class="text-gray-500 mb-8">Register a new academy location and configure its aquatic facilities.</p>

        <form id="add-branch-form">
            
            <!-- Section 1: Basic Information -->
            <div class="form-card">
                <h3 class="text-lg font-bold text-gray-800 mb-4 border-b pb-2">Basic Information</h3>
                <div class="space-y-4">
                    <div>
                        <label class="block text-xs font-bold text-gray-400 uppercase ml-1 mb-1">Branch Name</label>
                        <div class="input-group">
                            <input type="text" name="name" required placeholder="e.g., Downtown Aquatic Club">
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-400 uppercase ml-1 mb-1">City</label>
                        <div class="input-group">
                            <input type="text" name="city" required placeholder="e.g., Riyadh">
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-400 uppercase ml-1 mb-1">Google Maps URL</label>
                        <div class="input-group">
                            <svg class="w-5 h-5 text-gray-400 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.135a4 4 0 000-5.656l1.5-1.5a4 4 0 115.656 5.656l-4 4a4 4 0 01-5.656 0z"></path></svg>
                            <input type="url" name="location_url" required placeholder="https://maps.app.goo.gl/...">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Section 2: Operational Schedule -->
            <div class="form-card">
                <h3 class="text-lg font-bold text-gray-800 mb-4 border-b pb-2">Operational Schedule</h3>
                
                <div class="mb-6">
                    <label class="block text-xs font-bold text-gray-400 uppercase ml-1 mb-3">Operating Days</label>
                    <div class="flex flex-wrap gap-2">
                        <div class="day-pill" onclick="this.classList.toggle('active')">Sat</div>
                        <div class="day-pill" onclick="this.classList.toggle('active')">Sun</div>
                        <div class="day-pill" onclick="this.classList.toggle('active')">Mon</div>
                        <div class="day-pill" onclick="this.classList.toggle('active')">Tue</div>
                        <div class="day-pill" onclick="this.classList.toggle('active')">Wed</div>
                        <div class="day-pill" onclick="this.classList.toggle('active')">Thu</div>
                        <div class="day-pill" onclick="this.classList.toggle('active')">Fri</div>
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-bold text-gray-400 uppercase ml-1 mb-1">Opening Time</label>
                        <div class="input-group">
                            <input type="time" name="open_time" required>
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-400 uppercase ml-1 mb-1">Closing Time</label>
                        <div class="input-group">
                            <input type="time" name="close_time" required>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Section 3: Pool Management -->
            <div class="form-card">
                <div class="flex justify-between items-center mb-4 border-b pb-2">
                    <h3 class="text-lg font-bold text-gray-800">Pool Facilities</h3>
                    <button type="button" onclick="addPoolEntry()" class="text-xs font-bold text-blue-600 hover:text-blue-800 transition">+ Add Pool</button>
                </div>
                
                <div id="pools-container" class="space-y-4">
                    <!-- Default Pool Entry -->
                    <div class="pool-entry relative animate-fadeIn">
                        <div class="grid grid-cols-1 gap-3">
                            <div>
                                <label class="text-[10px] font-black text-gray-400 uppercase">Pool Name</label>
                                <div class="input-group mt-1">
                                    <input type="text" class="pool-name" required placeholder="e.g., Main Competition Pool">
                                </div>
                            </div>
                            <div class="grid grid-cols-2 gap-3">
                                <div>
                                    <label class="text-[10px] font-black text-gray-400 uppercase">Lanes</label>
                                    <div class="input-group mt-1">
                                        <input type="number" class="pool-lanes" required min="1" placeholder="8">
                                    </div>
                                </div>
                                <div>
                                    <label class="text-[10px] font-black text-gray-400 uppercase">Max Capacity</label>
                                    <div class="input-group mt-1">
                                        <input type="number" class="pool-capacity" required min="1" placeholder="40">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="w-full py-4 btn-submit rounded-2xl font-extrabold text-lg shadow-xl flex items-center justify-center space-x-3 mt-4">
                <span>Confirm & Create Branch</span>
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
            </button>

        </form>
    </div>

    <script>
        function addPoolEntry() {
            const container = document.getElementById('pools-container');
            const entry = document.createElement('div');
            entry.className = 'pool-entry relative border-t pt-4 mt-4';
            entry.innerHTML = `
                <button type="button" onclick="this.parentElement.remove()" class="absolute -top-2 -right-2 bg-red-100 text-red-600 rounded-full p-1 shadow-sm">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
                <div class="grid grid-cols-1 gap-3">
                    <div>
                        <label class="text-[10px] font-black text-gray-400 uppercase">Pool Name</label>
                        <div class="input-group mt-1">
                            <input type="text" class="pool-name" required placeholder="e.g., Training Pool">
                        </div>
                    </div>
                    <div class="grid grid-cols-2 gap-3">
                        <div>
                            <label class="text-[10px] font-black text-gray-400 uppercase">Lanes</label>
                            <div class="input-group mt-1">
                                <input type="number" class="pool-lanes" required min="1" placeholder="4">
                            </div>
                        </div>
                        <div>
                            <label class="text-[10px] font-black text-gray-400 uppercase">Max Capacity</label>
                            <div class="input-group mt-1">
                                <input type="number" class="pool-capacity" required min="1" placeholder="20">
                            </div>
                        </div>
                    </div>
                </div>
            `;
            container.appendChild(entry);
        }

        document.getElementById('add-branch-form').onsubmit = function(e) {
            e.preventDefault();
            
            const selectedDays = Array.from(document.querySelectorAll('.day-pill.active')).map(p => p.textContent);
            
            if (selectedDays.length === 0) {
                showSnackbar("Please select at least one operating day.", true);
                return;
            }

            const poolEntries = Array.from(document.querySelectorAll('.pool-entry')).map(entry => ({
                name: entry.querySelector('.pool-name').value,
                lanes: parseInt(entry.querySelector('.pool-lanes').value),
                capacity: parseInt(entry.querySelector('.pool-capacity').value)
            }));

            const formData = new FormData(e.target);
            const branchData = {
                name: formData.get('name'),
                city: formData.get('city'),
                locationUrl: formData.get('location_url'),
                operatingDays: selectedDays,
                openTime: formData.get('open_time'),
                closeTime: formData.get('close_time'),
                pools: poolEntries
            };

            console.log("Creating Academy Branch:", branchData);
            
            showSnackbar("Academy Branch created successfully!");
            setTimeout(() => {
                window.history.back();
            }, 2000);
        };

        function showSnackbar(message, isError = false) {
            const old = document.querySelector('.snackbar');
            if (old) old.remove();

            const snackbar = document.createElement('div');
            snackbar.textContent = message;
            snackbar.className = `snackbar fixed bottom-6 left-1/2 -translate-x-1/2 px-6 py-3 rounded-2xl shadow-2xl text-white ${isError ? 'bg-red-500' : 'bg-blue-600'} z-[100] font-bold text-sm transition-all animate-bounce`;
            document.body.appendChild(snackbar);
            setTimeout(() => {
                snackbar.remove();
            }, 3000);
        }
    </script>
</body>
</html>