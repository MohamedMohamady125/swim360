<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Branch Availability Management</title>
    <!-- Tailwind CSS CDN for styling -->
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
            padding: 1rem;
        }
        /* Style for the fixed date header row */
        .date-header-row {
            position: sticky;
            top: 0;
            z-index: 10;
            background-color: #E5E7EB; /* Gray-200 */
        }
        /* Style for the fixed time column (first column) */
        .fixed-time-col {
            position: sticky;
            left: 0;
            z-index: 5;
            background-color: #F3F4F6; /* Gray-100 */
        }
        /* Style for individual time slots */
        .time-slot {
            height: 35px; /* Fixed slot height */
            border-bottom: 1px solid #F3F4F6;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            font-weight: 500;
            color: #374151;
            transition: background-color 0.15s;
            user-select: none; /* Prevent text selection during drag */
        }
        /* Color Scheme Definitions (matching request) */
        .available {
            background-color: white; /* White: Free */
        }
        .blocked {
            background-color: #EF4444; /* Red: Blocked by Clinic Admin */
            color: white;
            font-weight: 700;
        }
        .booked {
            background-color: #38A169; /* Green: Booked by Client (New State) */
            color: white;
            font-weight: 700;
            cursor: not-allowed;
            pointer-events: none;
        }
        .unavailable {
            background-color: #E5E7EB; /* Light Gray: Outside operating hours (closed) */
            color: #9CA3AF;
            cursor: not-allowed;
            pointer-events: none;
        }
        .selected {
            background-color: #3B82F6; /* Blue: Selected for blocking/unblocking */
            color: white;
        }
        /* Hide scrollbars for cleaner grid display */
        .hide-scrollbar {
            overflow-x: auto;
            overflow-y: auto;
            -ms-overflow-style: none; /* IE and Edge */
            scrollbar-width: none; /* Firefox */
        }
        .hide-scrollbar::-webkit-scrollbar {
            display: none; /* Chrome, Safari, Opera */
        }
        /* Date Navigator Styling */
        .date-nav-button {
            padding: 0.5rem 0.75rem;
            border-radius: 9999px;
            font-weight: 600;
            transition: background-color 0.2s;
            cursor: pointer;
            min-height: 50px; /* Make room for two lines */
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .date-nav-button.selected {
            background-color: #3B82F6;
            color: white;
        }
        .date-nav-button:not(.selected):hover {
            background-color: #E5E7EB;
        }
    </style>
</head>
<body class="p-4 md:p-8">

    <div class="max-w-xl mx-auto">
        <h1 class="text-3xl font-extrabold text-gray-800 mb-2">Branch Availability</h1>
        <p class="text-gray-500 mb-4">View capacity and block time slots for maintenance or external bookings.</p>

        <!-- Branch Selector & Date Navigator -->
        <div class="form-card mb-6">
            <div class="flex flex-col sm:flex-row items-center justify-between gap-3 mb-4">
                <!-- Branch Dropdown -->
                <div class="w-full sm:w-1/2">
                    <label for="branch-select" class="block text-xs font-medium text-gray-500">Current Branch</label>
                    <select id="branch-select" class="w-full text-lg font-semibold py-2 rounded-lg border border-gray-300" onchange="initializeView()">
                        <!-- Options populated by JS -->
                    </select>
                </div>
                
                <!-- Date Navigator -->
                <div class="w-full sm:w-1/2 flex items-center justify-end space-x-2">
                    <button onclick="changeWeek(-7)" class="p-2 bg-gray-200 rounded-full hover:bg-gray-300 transition">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 19l-7-7 7-7m8 14l-7-7 7-7"></path></svg>
                    </button>
                    <input type="date" id="current-date-picker" class="p-2 border rounded-lg text-center font-medium w-32 hidden" onchange="initializeView()">
                    <button onclick="changeWeek(7)" class="p-2 bg-gray-200 rounded-full hover:bg-gray-300 transition">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 5l7 7-7 7m-8 0l7-7-7-7"></path></svg>
                    </button>
                </div>
            </div>

            <!-- Day Iterator (New Requirement) -->
            <div id="day-iterator" class="flex justify-between mt-3 gap-1">
                <!-- Days populated by JS -->
            </div>
            
            <p class="text-sm text-gray-700 font-medium mt-4" id="branch-summary"></p>
        </div>

        <!-- Availability Grid Container -->
        <div class="hide-scrollbar">
            <div id="availability-grid" class="relative w-full overflow-x-auto">
                <!-- Grid content will be injected here by JS -->
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="mt-6 flex justify-between space-x-4">
             <button onclick="blockSelectedSlots()" class="flex-1 py-3 text-white font-semibold rounded-lg bg-red-600 hover:bg-red-700 transition">
                Block Selected Slots (Admin)
            </button>
            <button onclick="unblockSelectedSlots()" class="flex-1 py-3 text-gray-700 font-semibold rounded-lg bg-gray-300 hover:bg-gray-400 transition">
                Unblock Selected
            </button>
        </div>
        <p id="selection-status" class="text-sm text-gray-500 mt-3 text-center"></p>
    </div>

    <script>
        // --- MOCK DATA ---
        const MOCK_DATA = {
            branches: [
                { id: 'b1', name: 'Family Park Clinic', beds: 3, open: 8, close: 17, city: 'Riyadh' }, // 8:00 AM to 5:00 PM
                { id: 'b2', name: 'Jeddah Coastal Center', beds: 2, open: 9, close: 18, city: 'Jeddah' }  // 9:00 AM to 6:00 PM
            ],
            // Mock data for slots already blocked by an Admin
            blockedSlots: {
                'b1': {
                    '2025-12-01': { 'Bed-1': ['10:00', '11:00'], 'Bed-3': ['14:00'] },
                    '2025-12-03': { 'Bed-2': ['13:00'] }
                },
            },
            // Mock data for slots booked by a Client (Green)
            bookedSlots: {
                'b1': {
                    '2025-12-01': { 'Bed-2': ['09:00'] },
                    '2025-12-02': { 'Bed-1': ['16:00'] }
                }
            }
        };

        // --- GLOBAL STATE ---
        let selectedDate = new Date(2025, 11, 1); // Monday, Dec 1, 2025
        let selectedBranchId = 'b1';
        let selectedSlots = []; // Array of {bedId: 'Bed-X', time: 'HH:MM', date: 'YYYY-MM-DD'}
        let isDragging = false;
        let startSlot = null;

        const timeSlotLength = 60; // 60 minutes per slot (1 hour)
        const DAY_NAMES = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

        // --- SETUP FUNCTIONS ---

        function initializeSelects() {
            const branchSelect = document.getElementById('branch-select');
            branchSelect.innerHTML = '';
            
            MOCK_DATA.branches.forEach(branch => {
                const option = document.createElement('option');
                option.value = branch.id;
                option.textContent = branch.name;
                if (branch.id === selectedBranchId) {
                    option.selected = true;
                }
                branchSelect.appendChild(option);
            });
        }

        function initializeView() {
            selectedBranchId = document.getElementById('branch-select').value;
            const datePickerValue = document.getElementById('current-date-picker').value;
            
            // If the user manually changed the date via the date picker, use that date
            if (datePickerValue) {
                selectedDate = new Date(datePickerValue.replace(/-/g, '/'));
            } else {
                 // Update date picker to reflect current selectedDate state (for initial load)
                 document.getElementById('current-date-picker').value = formatDate(selectedDate);
            }
            
            const selectedBranch = MOCK_DATA.branches.find(b => b.id === selectedBranchId);
            const openTime = formatTime12hr(selectedBranch.open);
            const closeTime = formatTime12hr(selectedBranch.close);
            
            document.getElementById('branch-summary').textContent = 
                `Open: ${openTime} | Close: ${closeTime} | Beds: ${selectedBranch.beds}`;

            renderDayIterator();
            renderAvailabilityGrid();
        }

        // --- DATE MANIPULATION ---

        function changeWeek(days) {
            selectedDate.setDate(selectedDate.getDate() + days);
            document.getElementById('current-date-picker').value = formatDate(selectedDate);
            initializeView();
        }

        function changeDay(dateString) {
            selectedDate = new Date(dateString.replace(/-/g, '/'));
             document.getElementById('current-date-picker').value = dateString;
            initializeView();
        }

        function formatDate(date) {
            const yyyy = date.getFullYear();
            const mm = String(date.getMonth() + 1).padStart(2, '0');
            const dd = String(date.getDate()).padStart(2, '0');
            return `${yyyy}-${mm}-${dd}`;
        }
        
        function formatTime12hr(hour24) {
            const h = hour24 % 12 || 12;
            const ampm = hour24 < 12 || hour24 === 24 ? 'AM' : 'PM';
            const minute = '00';
            return `${h}:${minute} ${ampm}`;
        }
        
        function formatDayDisplay(date) {
            const dayName = DAY_NAMES[date.getDay()];
            const day = date.getDate();
            const month = date.getMonth() + 1; // Months are 0-indexed
            return `<div class="text-center"><div>${dayName}</div><div class="text-xs">${day}/${month}</div></div>`;
        }
        
        function renderDayIterator() {
            const iteratorContainer = document.getElementById('day-iterator');
            iteratorContainer.innerHTML = '';
            
            // Calculate start of the week (Monday)
            const currentDayOfWeek = selectedDate.getDay(); // 0 (Sun) to 6 (Sat)
            const daysToMonday = currentDayOfWeek === 0 ? 6 : currentDayOfWeek - 1; // Sun -> 6, Mon -> 0, etc.
            const startOfWeek = new Date(selectedDate);
            startOfWeek.setDate(selectedDate.getDate() - daysToMonday);

            const selectedDateStr = formatDate(selectedDate);

            for (let i = 0; i < 7; i++) {
                const day = new Date(startOfWeek);
                day.setDate(startOfWeek.getDate() + i);
                
                const dayStr = formatDate(day);
                const isSelected = dayStr === selectedDateStr;

                const dayHtml = `
                    <button onclick="changeDay('${dayStr}')" 
                            class="flex-1 text-center text-sm date-nav-button ${isSelected ? 'selected' : 'bg-white text-gray-800'}">
                        ${formatDayDisplay(day)}
                    </button>
                `;
                iteratorContainer.innerHTML += dayHtml;
            }
        }

        // --- GRID RENDERING LOGIC ---

        function getTimeslots() {
            const slots = [];
            // Generate all 24 hours (0-23)
            for (let h = 0; h < 24; h++) {
                slots.push(`${String(h).padStart(2, '0')}:00`);
            }
            return slots;
        }

        function getBedIds(count) {
            return Array.from({ length: count }, (_, i) => `Bed ${i + 1}`);
        }

        function renderAvailabilityGrid() {
            const gridContainer = document.getElementById('availability-grid');
            const branch = MOCK_DATA.branches.find(b => b.id === selectedBranchId);
            const beds = getBedIds(branch.beds);
            const slots = getTimeslots(); // Get all 24 hours
            const bookingDateStr = formatDate(selectedDate);
            
            const currentDayBlocked = MOCK_DATA.blockedSlots[selectedBranchId]?.[bookingDateStr] || {};
            const currentDayBooked = MOCK_DATA.bookedSlots[selectedBranchId]?.[bookingDateStr] || {};
            
            // --- Determine Grid Columns ---
            // 1 column for Time + N columns for Beds
            const gridTemplateColumns = `minmax(80px, 80px) repeat(${beds.length}, 1fr)`;

            let gridHTML = `<div style="display: grid; grid-template-columns: ${gridTemplateColumns};">`;

            // --- 1. Header Row (Beds) ---
            gridHTML += `<div class="date-header-row fixed-time-col border-r border-b">Time</div>`; // Top-left corner
            beds.forEach(bedId => {
                gridHTML += `<div class="date-header-row text-center font-bold text-sm py-2 border-b">${bedId}</div>`;
            });

            // --- 2. Content Rows (Slots) ---
            slots.forEach(time24hr => {
                const slotHour = parseInt(time24hr.split(':')[0]);
                const timeDisplay = formatTime12hr(slotHour);
                
                // Time Column (Fixed)
                gridHTML += `<div class="time-slot fixed-time-col border-r">${timeDisplay}</div>`;

                // Bed Columns (Interactive)
                beds.forEach(bedId => {
                    const bedIdClean = bedId.replace(/\s/g, '-');
                    const isBookedByClient = currentDayBooked[bedIdClean] && currentDayBooked[bedIdClean].includes(time24hr);
                    const isBlockedByAdmin = currentDayBlocked[bedIdClean] && currentDayBlocked[bedIdClean].includes(time24hr);
                    const isSelected = selectedSlots.some(s => s.bedId === bedIdClean && s.time === time24hr);

                    // Check if time is outside operating hours (Unavailable/Closed)
                    const isOutsideHours = slotHour < branch.open || slotHour >= branch.close;

                    let slotClass = 'available';
                    
                    if (isOutsideHours) {
                        slotClass = 'unavailable'; // Grey - closed hours
                    } else if (isBookedByClient) {
                        slotClass = 'booked'; // Green
                    } else if (isBlockedByAdmin) {
                        slotClass = 'blocked'; // Red
                    } else if (isSelected) {
                        slotClass = 'selected'; // Blue
                    }

                    gridHTML += `
                        <div class="time-slot ${slotClass}" 
                             data-bed="${bedIdClean}" 
                             data-time="${time24hr}"
                             onmousedown="startDrag(event)"
                             onmouseup="endDrag(event)"
                             onmousemove="dragOver(event)">
                        </div>
                    `;
                });
            });

            gridHTML += `</div>`;
            gridContainer.innerHTML = gridHTML;
            updateSelectionStatus();
        }

        // --- INTERACTION LOGIC (Drag & Select) ---

        function getSlotData(element) {
            return {
                bedId: element.getAttribute('data-bed'),
                time: element.getAttribute('data-time'),
                element: element
            };
        }

        function toggleSlot(slot, forceState = null) {
            const index = selectedSlots.findIndex(s => s.bedId === slot.bedId && s.time === slot.time);
            
            // Check if slot is booked (green) - if so, it cannot be selected/modified
            const element = document.querySelector(`.time-slot[data-bed="${slot.bedId}"][data-time="${slot.time}"]`);
            if (element && element.classList.contains('booked')) {
                 showSnackbar("Cannot modify client-booked slots (Green).", true);
                 return;
            }

            // Check if slot is unavailable (gray) - if so, it cannot be selected
            if (element && element.classList.contains('unavailable')) {
                 return;
            }

            if (forceState === true && index === -1) {
                 selectedSlots.push({ bedId: slot.bedId, time: slot.time });
            } else if (forceState === false && index !== -1) {
                 selectedSlots.splice(index, 1);
            } else if (forceState === null) {
                 if (index !== -1) {
                    selectedSlots.splice(index, 1);
                } else {
                    selectedSlots.push({ bedId: slot.bedId, time: slot.time });
                }
            }
            
            renderAvailabilityGrid();
        }

        function startDrag(event) {
            if (event.button !== 0 || event.target.classList.contains('unavailable') || event.target.classList.contains('booked')) return; 

            // Don't clear previous selection - allow accumulative selection
            
            isDragging = true;
            startSlot = getSlotData(event.target);
            toggleSlot(startSlot, true); // Force select the start slot
            event.preventDefault();
        }

        function dragOver(event) {
            if (!isDragging || event.target.classList.contains('unavailable') || event.target.classList.contains('booked')) return;
            
            const currentSlotElement = event.target;
            const currentSlot = getSlotData(currentSlotElement);
            
            if (startSlot.bedId !== currentSlot.bedId) return; // Only allow drag within the same bed

            if (currentSlot.bedId && currentSlot.time) {
                // Calculate the range from startSlot to currentSlot
                const slots = getTimeslots(); // All 24 hours
                const startIndex = slots.indexOf(startSlot.time);
                const endIndex = slots.indexOf(currentSlot.time);

                const minIndex = Math.min(startIndex, endIndex);
                const maxIndex = Math.max(startIndex, endIndex);

                // Remove any previously selected slots in this drag range for this bed
                selectedSlots = selectedSlots.filter(s => s.bedId !== currentSlot.bedId);

                // Add the new range to selectedSlots
                for (let i = minIndex; i <= maxIndex; i++) {
                    const time24hr = slots[i];
                    const slotElement = document.querySelector(`.time-slot[data-bed="${currentSlot.bedId}"][data-time="${time24hr}"]`);
                    
                    if (slotElement && !slotElement.classList.contains('unavailable') && !slotElement.classList.contains('booked')) {
                         selectedSlots.push({ bedId: currentSlot.bedId, time: time24hr });
                    }
                }
                renderAvailabilityGrid(); // Visually update the selection range
            }
        }

        function endDrag(event) {
            if (!isDragging) return;
            isDragging = false;
            startSlot = null;
            // The selectedSlots array is already updated by dragOver/toggleSlot.
            updateSelectionStatus();
            renderAvailabilityGrid(); // Final render to set .blocked/selected state
        }

        // --- ACTION BUTTONS ---

        function blockSelectedSlots() {
            if (selectedSlots.length === 0) {
                return showSnackbar("No slots selected to block.", true);
            }

            const bookingDateStr = formatDate(selectedDate);
            const blockedRef = MOCK_DATA.blockedSlots[selectedBranchId] || {};
            blockedRef[bookingDateStr] = blockedRef[bookingDateStr] || {};
            MOCK_DATA.blockedSlots[selectedBranchId] = blockedRef;

            selectedSlots.forEach(slot => {
                const bedKey = slot.bedId;
                blockedRef[bookingDateStr][bedKey] = blockedRef[bookingDateStr][bedKey] || [];
                
                if (!blockedRef[bookingDateStr][bedKey].includes(slot.time)) {
                    blockedRef[bookingDateStr][bedKey].push(slot.time);
                }
            });

            showSnackbar(`${selectedSlots.length} slots blocked successfully (Red).`, false);
            selectedSlots = [];
            renderAvailabilityGrid();
        }

        function unblockSelectedSlots() {
             if (selectedSlots.length === 0) {
                return showSnackbar("No slots selected to unblock.", true);
            }

            const bookingDateStr = formatDate(selectedDate);
            const blockedRef = MOCK_DATA.blockedSlots[selectedBranchId]?.[bookingDateStr];
            
            selectedSlots.forEach(slot => {
                const bedKey = slot.bedId;
                if (blockedRef && blockedRef[bedKey]) {
                    const index = blockedRef[bedKey].indexOf(slot.time);
                    if (index > -1) {
                        blockedRef[bedKey].splice(index, 1);
                    }
                }
            });

            showSnackbar(`${selectedSlots.length} slots unblocked successfully (White).`, false);
            selectedSlots = [];
            renderAvailabilityGrid();
        }

        // --- UTILITY FUNCTIONS ---
        
        function showSnackbar(message, isError = false) {
            const snackbar = document.createElement('div');
            snackbar.textContent = message;
            snackbar.className = `fixed bottom-6 left-1/2 -translate-x-1/2 px-6 py-3 rounded-lg shadow-lg text-white ${isError ? 'bg-red-500' : 'bg-green-500'} z-[60]`;
            document.body.appendChild(snackbar);
            setTimeout(() => {
                snackbar.remove();
            }, 3000);
        }

        function updateSelectionStatus() {
            const statusEl = document.getElementById('selection-status');
            if (selectedSlots.length > 0) {
                statusEl.textContent = `${selectedSlots.length} slot(s) selected`;
            } else {
                statusEl.textContent = '';
            }
        }

        // --- INITIALIZATION ---

        window.onload = () => {
            const dateInput = document.getElementById('current-date-picker');
            dateInput.value = formatDate(selectedDate);
            dateInput.min = formatDate(new Date()); 
            
            // Set up initial drag listeners globally
            document.body.addEventListener('mouseup', endDrag); 
            document.body.addEventListener('mousemove', dragOver); 

            initializeSelects();
            initializeView();
            
            // Initial render of the day iterator
            renderDayIterator();
        };
    </script>
</body>
</html>

//2 changes to be made :1. week starts on sunday and ends on saturday
//2.  blocked slots that are selected should show that they are selected by being blue colored