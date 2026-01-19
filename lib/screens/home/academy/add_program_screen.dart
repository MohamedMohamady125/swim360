<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - Create Program</title>
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
        .input-group input, .input-group select, .input-group textarea {
            border: none;
            outline: none;
            padding: 12px 0;
            flex-grow: 1;
            background-color: transparent;
        }
        /* Day Row Styling */
        .day-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px;
            border-radius: 12px;
            border: 1px solid #F3F4F6;
            transition: all 0.2s;
        }
        .day-row.active {
            border-color: #DBEAFE;
            background-color: #EFF6FF;
        }
        .day-toggle {
            cursor: pointer;
            width: 45px;
            height: 45px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            background-color: #F3F4F6;
            color: #6B7280;
            font-weight: 700;
            font-size: 0.8rem;
            transition: all 0.2s;
        }
        .day-row.active .day-toggle {
            background-color: #3B82F6;
            color: white;
        }
        .time-picker-mini {
            font-size: 0.85rem;
            padding: 6px 8px;
            border-radius: 8px;
            border: 1px solid #E5E7EB;
            background-color: white;
            outline: none;
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
            <h1 class="text-3xl font-extrabold text-gray-800">Create Program</h1>
        </div>

        <p class="text-gray-500 mb-8">Define a new training level and visualize the weekly session schedule.</p>

        <form id="create-program-form">
            
            <!-- Section 1: Basic Identification -->
            <div class="form-card">
                <h3 class="text-lg font-bold text-gray-800 mb-4 border-b pb-2">Program Details</h3>
                <div class="space-y-4">
                    <div>
                        <label class="block text-xs font-bold text-gray-400 uppercase ml-1 mb-1">Program Name (Level)</label>
                        <div class="input-group">
                            <svg class="w-5 h-5 text-gray-400 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 10h6"></path></svg>
                            <input type="text" name="name" required placeholder="e.g., Intermediate Squad">
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-400 uppercase ml-1 mb-1">Short Description</label>
                        <div class="input-group">
                            <textarea name="description" rows="2" required placeholder="Basic description for swimmers and parents."></textarea>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Section 2: Pricing & Capacity -->
            <div class="form-card">
                <h3 class="text-lg font-bold text-gray-800 mb-4 border-b pb-2">Pricing & Capacity</h3>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-bold text-gray-400 uppercase ml-1 mb-1">Price (USD)</label>
                        <div class="input-group">
                            <span class="text-gray-400 font-bold mr-1">$</span>
                            <input type="number" name="price" required step="0.01" placeholder="120.00">
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-400 uppercase ml-1 mb-1">Max Capacity</label>
                        <div class="input-group">
                            <svg class="w-5 h-5 text-gray-400 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h2a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v13a2 2 0 002 2h2M9 14v6M15 14v6M12 3v18"></path></svg>
                            <input type="number" name="capacity" required min="1" placeholder="20">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Section 3: Visual Weekly Schedule -->
            <div class="form-card">
                <h3 class="text-lg font-bold text-gray-800 mb-4 border-b pb-2">Weekly Schedule</h3>
                <p class="text-xs text-gray-400 mb-4">Select the days and times for this program.</p>
                
                <div id="schedule-builder" class="space-y-2">
                    <!-- Iterating Days -->
                    <div class="day-row" data-day="Sat">
                        <div class="flex items-center space-x-3">
                            <div class="day-toggle" onclick="toggleDay(this)">SAT</div>
                            <span class="text-sm font-semibold text-gray-700 day-label">Saturday</span>
                        </div>
                        <div class="time-inputs hidden flex items-center space-x-2">
                            <input type="time" class="time-picker-mini start-time">
                            <span class="text-gray-400 text-xs">to</span>
                            <input type="time" class="time-picker-mini end-time">
                        </div>
                    </div>

                    <div class="day-row" data-day="Sun">
                        <div class="flex items-center space-x-3">
                            <div class="day-toggle" onclick="toggleDay(this)">SUN</div>
                            <span class="text-sm font-semibold text-gray-700 day-label">Sunday</span>
                        </div>
                        <div class="time-inputs hidden flex items-center space-x-2">
                            <input type="time" class="time-picker-mini start-time">
                            <span class="text-gray-400 text-xs">to</span>
                            <input type="time" class="time-picker-mini end-time">
                        </div>
                    </div>

                    <div class="day-row" data-day="Mon">
                        <div class="flex items-center space-x-3">
                            <div class="day-toggle" onclick="toggleDay(this)">MON</div>
                            <span class="text-sm font-semibold text-gray-700 day-label">Monday</span>
                        </div>
                        <div class="time-inputs hidden flex items-center space-x-2">
                            <input type="time" class="time-picker-mini start-time">
                            <span class="text-gray-400 text-xs">to</span>
                            <input type="time" class="time-picker-mini end-time">
                        </div>
                    </div>

                    <div class="day-row" data-day="Tue">
                        <div class="flex items-center space-x-3">
                            <div class="day-toggle" onclick="toggleDay(this)">TUE</div>
                            <span class="text-sm font-semibold text-gray-700 day-label">Tuesday</span>
                        </div>
                        <div class="time-inputs hidden flex items-center space-x-2">
                            <input type="time" class="time-picker-mini start-time">
                            <span class="text-gray-400 text-xs">to</span>
                            <input type="time" class="time-picker-mini end-time">
                        </div>
                    </div>

                    <div class="day-row" data-day="Wed">
                        <div class="flex items-center space-x-3">
                            <div class="day-toggle" onclick="toggleDay(this)">WED</div>
                            <span class="text-sm font-semibold text-gray-700 day-label">Wednesday</span>
                        </div>
                        <div class="time-inputs hidden flex items-center space-x-2">
                            <input type="time" class="time-picker-mini start-time">
                            <span class="text-gray-400 text-xs">to</span>
                            <input type="time" class="time-picker-mini end-time">
                        </div>
                    </div>

                    <div class="day-row" data-day="Thu">
                        <div class="flex items-center space-x-3">
                            <div class="day-toggle" onclick="toggleDay(this)">THU</div>
                            <span class="text-sm font-semibold text-gray-700 day-label">Thursday</span>
                        </div>
                        <div class="time-inputs hidden flex items-center space-x-2">
                            <input type="time" class="time-picker-mini start-time">
                            <span class="text-gray-400 text-xs">to</span>
                            <input type="time" class="time-picker-mini end-time">
                        </div>
                    </div>

                    <div class="day-row" data-day="Fri">
                        <div class="flex items-center space-x-3">
                            <div class="day-toggle" onclick="toggleDay(this)">FRI</div>
                            <span class="text-sm font-semibold text-gray-700 day-label">Friday</span>
                        </div>
                        <div class="time-inputs hidden flex items-center space-x-2">
                            <input type="time" class="time-picker-mini start-time">
                            <span class="text-gray-400 text-xs">to</span>
                            <input type="time" class="time-picker-mini end-time">
                        </div>
                    </div>
                </div>

                <div class="mt-6 grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-bold text-gray-400 uppercase ml-1 mb-1">Program Duration</label>
                        <div class="input-group">
                            <input type="text" name="duration" required placeholder="e.g., 3 Months">
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-400 uppercase ml-1 mb-1">Total Sessions</label>
                        <div class="input-group">
                            <input type="number" name="sessions" required min="1" placeholder="e.g., 24">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Section 4: Initial Status -->
            <div class="form-card">
                <div class="flex items-center justify-between">
                    <div>
                        <h3 class="text-lg font-bold text-gray-800">Launch Immediately?</h3>
                        <p class="text-xs text-gray-500 italic">Inactive programs won't be visible to new signups.</p>
                    </div>
                    <label class="relative inline-flex items-center cursor-pointer">
                        <input type="checkbox" name="status" id="program-status-toggle" checked class="sr-only peer">
                        <div class="w-14 h-7 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-6 after:w-6 after:transition-all peer-checked:bg-blue-600 shadow-inner"></div>
                    </label>
                </div>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="w-full py-4 btn-submit rounded-2xl font-extrabold text-lg shadow-xl flex items-center justify-center space-x-3 mt-4">
                <span>Publish New Program</span>
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
            </button>

        </form>
    </div>

    <script>
        /**
         * Toggles a day row as active/inactive.
         * Shows time inputs only when active.
         */
        function toggleDay(element) {
            const row = element.closest('.day-row');
            const timeInputs = row.querySelector('.time-inputs');
            
            row.classList.toggle('active');
            timeInputs.classList.toggle('hidden');
            
            // Set default times if activated
            if (row.classList.contains('active')) {
                const start = row.querySelector('.start-time');
                const end = row.querySelector('.end-time');
                if (!start.value) start.value = "16:00";
                if (!end.value) end.value = "17:00";
            }
        }

        document.getElementById('create-program-form').onsubmit = function(e) {
            e.preventDefault();
            
            const formData = new FormData(e.target);
            const status = document.getElementById('program-status-toggle').checked ? 'active' : 'paused';

            // Extract visual schedule data
            const schedule = [];
            document.querySelectorAll('.day-row.active').forEach(row => {
                const day = row.dataset.day;
                const startTime = row.querySelector('.start-time').value;
                const endTime = row.querySelector('.end-time').value;
                schedule.push({ day, startTime, endTime });
            });

            if (schedule.length === 0) {
                showSnackbar("Please select at least one training day.", true);
                return;
            }

            const programData = {
                name: formData.get('name'),
                description: formData.get('description'),
                price: parseFloat(formData.get('price')),
                capacity: parseInt(formData.get('capacity')),
                duration: formData.get('duration'),
                sessions: parseInt(formData.get('sessions')),
                schedule: schedule, // Now a structured array of day/time objects
                status: status
            };

            console.log("Creating New Program Level:", programData);
            
            showSnackbar(`Program "${programData.name}" has been created!`);
            
            // Redirect back after a short delay
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