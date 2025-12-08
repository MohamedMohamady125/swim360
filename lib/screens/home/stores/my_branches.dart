<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Store Branches</title>
    <!-- Tailwind CSS CDN for styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
        body {
            font-family: 'Inter', sans-serif;
            background-color: #F7F9FB;
        }
        /* Card styling updated for a cleaner, flatter look */
        .card-shadow {
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
        }
        .branch-card {
            background-color: white;
            border-radius: 10px;
            transition: transform 0.1s, box-shadow 0.1s;
        }
        .branch-card:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.06);
        }
        .modal-body-content {
            padding: 1.5rem;
            max-height: 80vh;
            overflow-y: auto;
        }
        /* Input Modal Styling */
        .input-group {
            display: flex;
            align-items: center;
            border: 1px solid #E5E7EB;
            border-radius: 8px;
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
        .time-select-group {
            display: flex;
            gap: 0.5rem;
        }
        .time-select-group select {
            padding: 10px;
            border: 1px solid #E5E7EB;
            border-radius: 8px;
            background-color: #FAFAFA;
            flex-grow: 1;
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='none' stroke='%239CA3AF' stroke-width='1.5' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M6 8l4 4 4-4'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 0.75rem center;
            background-size: 1.5em 1.5em;
        }
        .checklist-group {
            border: 1px solid #E5E7EB;
            border-radius: 8px;
            padding: 1rem;
        }
    </style>
</head>
<body class="p-4 md:p-8">

    <div class="max-w-xl mx-auto">
        <h1 class="text-3xl font-extrabold text-gray-800 mb-2">My Store Branches</h1>
        <p class="text-gray-500 mb-6">Manage locations and edit operational details for each retail outlet.</p>

        <div id="branch-list" class="space-y-4">
            <!-- Branch Cards will be injected here -->
        </div>
    </div>

    <!-- Edit Modal Structure (Hidden by default) -->
    <div id="edit-modal-overlay" class="fixed inset-0 bg-black bg-opacity-50 z-[99] flex items-center justify-center p-4 hidden">
        <div id="edit-modal-content" class="bg-white rounded-xl shadow-2xl w-full max-w-lg max-h-[90vh] overflow-y-auto">
            
            <div class="p-5 border-b flex justify-between items-center sticky top-0 bg-white rounded-t-xl">
                <h3 class="text-2xl font-extrabold text-gray-800" id="modal-title">Edit Branch: <span id="branch-edit-title" class="text-blue-600"></span></h3>
                <button id="close-modal-btn" onclick="closeEditModal()" class="text-gray-500 hover:text-gray-800 transition">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>

            <form id="edit-branch-form" class="p-5 space-y-6">
                
                <input type="hidden" id="edit-branch-id">

                <!-- Location Information (All Editable) -->
                <div class="space-y-4">
                    <h4 class="font-bold text-gray-700">Location Details</h4>
                    
                    <!-- Governorate -->
                    <div>
                        <label for="edit-governorate" class="block text-sm font-medium text-gray-700 mb-1">Governorate</label>
                        <div class="input-group">
                            <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.828 0l-4.243-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                            <input type="text" id="edit-governorate" name="governorate" required>
                        </div>
                    </div>

                    <!-- City -->
                    <div>
                        <label for="edit-city" class="block text-sm font-medium text-gray-700 mb-1">City</label>
                        <div class="input-group">
                            <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.828 0l-4.243-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                            <input type="text" id="edit-city" name="city" required>
                        </div>
                    </div>
                    
                    <!-- Location URL (EDITABLE) -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Google Maps URL</label>
                        <div class="input-group">
                             <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.135a4 4 0 000-5.656l1.5-1.5a4 4 0 115.656 5.656l-4 4a4 4 0 01-5.656 0z"></path></svg>
                            <input type="url" id="edit-location-url" name="location_url" required>
                        </div>
                    </div>
                </div>

                <!-- Editable Operational Fields -->
                <div class="space-y-6">
                    <h4 class="font-bold text-gray-700 pt-2 border-t">Operational Settings (Editable)</h4>
                    
                    <!-- Branch Phone Number (EDITABLE) -->
                    <div>
                        <label for="edit-branch-phone" class="block text-sm font-medium text-gray-700 mb-1">Branch Phone Number</label>
                        <div class="input-group">
                            <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.408 5.408l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"></path></svg>
                            <input type="tel" id="edit-branch-phone" name="branch_phone" required>
                        </div>
                    </div>

                    <!-- Operational Hours (EDITABLE) -->
                    <div class="grid grid-cols-2 gap-4">
                        <!-- Opening Time -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Opening Time</label>
                            <div class="time-select-group">
                                <select id="edit-opening-hour" name="opening_hour" required></select>
                                <select id="edit-opening-minute" name="opening_minute" required></select>
                                <select id="edit-opening-ampm" name="opening_ampm" required>
                                    <option value="AM">AM</option>
                                    <option value="PM">PM</option>
                                </select>
                            </div>
                        </div>

                        <!-- Closing Time -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Closing Time</label>
                            <div class="time-select-group">
                                <select id="edit-closing-hour" name="closing_hour" required></select>
                                <select id="edit-closing-minute" name="closing_minute" required></select>
                                <select id="edit-closing-ampm" name="closing_ampm" required>
                                    <option value="AM">AM</option>
                                    <option value="PM">PM</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <p id="edit-time-message" class="text-xs text-red-500 h-4"></p>
                    
                    <!-- Delivery Options Checklist (EDITABLE) -->
                    <div>
                        <h3 class="text-sm font-medium text-gray-700 mb-2">Delivery Options</h3>
                        <div id="edit-delivery-checklist" class="checklist-group grid grid-cols-2 gap-3">
                            <!-- Checkboxes populated dynamically -->
                        </div>
                    </div>

                </div>

                <!-- Submit Button -->
                <button type="submit" class="w-full py-3 text-white font-semibold rounded-lg shadow-lg bg-blue-600 hover:bg-blue-700 transition">
                    <span id="edit-submit-text">Update Branch</span>
                </button>
            </form>
        </div>
    </div>

    <script>
        // Store Delivery Options (Must match the registration form)
        const deliveryOptions = [
            "Pickup Only", 
            "Governorate Delivery", 
            "National Delivery",
            "International Delivery",
        ];

        // MOCK DATA for registered branches
        let branches = [
            { 
                id: 'b1', 
                governorate: 'Riyadh Province',
                city: 'Riyadh', 
                location_name: 'Al Malaz Store', 
                location_url: 'https://maps.google.com/malaz',
                branch_phone: '0551112222',
                opening_time: '08:00 AM', 
                closing_time: '05:00 PM',
                delivery_options: ['pickup-only', 'governorate-delivery'] 
            },
            { 
                id: 'b2', 
                governorate: 'Makkah Region',
                city: 'Jeddah', 
                location_name: 'Red Sea Mall Branch', 
                location_url: 'https://maps.google.com/redsea',
                branch_phone: '0559998888',
                opening_time: '09:00 AM',
                closing_time: '06:00 PM',
                delivery_options: ['pickup-only', 'national-delivery'] 
            }
        ];

        const modalOverlay = document.getElementById('edit-modal-overlay');
        const branchListContainer = document.getElementById('branch-list');
        const editForm = document.getElementById('edit-branch-form');

        // --- Utility Functions ---

        function showSnackbar(message, isError = false) {
            const snackbar = document.createElement('div');
            snackbar.textContent = message;
            snackbar.className = `fixed bottom-6 left-1/2 -translate-x-1/2 px-6 py-3 rounded-lg shadow-lg text-white ${isError ? 'bg-red-500' : 'bg-green-500'} z-[60]`;
            document.body.appendChild(snackbar);
            setTimeout(() => {
                snackbar.remove();
            }, 3000);
        }

        // --- Time Helpers (Copied from registration form) ---

        function populateTimeSelect(selectId, start, end, step, isHour = false) {
            const select = document.getElementById(selectId);
            if (!select) return;
            select.innerHTML = '';
            for (let i = start; i <= end; i += step) {
                let value = i;
                if (isHour) {
                    value = (i === 0) ? 12 : i;
                }
                const text = String(value).padStart(2, '0');
                const option = document.createElement('option');
                option.value = text;
                option.textContent = text;
                select.appendChild(option);
            }
        }

        function convertTo24Hour(hour12, minute, ampm) {
            let hour = parseInt(hour12);
            if (ampm === 'AM' && hour === 12) {
                hour = 0;
            } else if (ampm === 'PM' && hour !== 12) {
                hour += 12;
            }
            return hour * 60 + parseInt(minute);
        }
        
        function parseDisplayTime(timeString) {
            const [time, ampm] = timeString.split(' ');
            const [hour, minute] = time.split(':');
            return { hour, minute, ampm };
        }
        
        function populateDeliveryChecklist(targetElementId, currentOptions) {
            const checklistContainer = document.getElementById(targetElementId);
            checklistContainer.innerHTML = deliveryOptions.map(option => {
                const value = option.toLowerCase().replace(/[^\w]/g, '-');
                const isChecked = currentOptions.includes(value);
                return `
                    <label class="flex items-center space-x-3 text-sm font-medium text-gray-700">
                        <input type="checkbox" name="edit_delivery_options" value="${value}" ${isChecked ? 'checked' : ''} class="h-4 w-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500">
                        <span>${option}</span>
                    </label>
                `;
            }).join('');
        }

        // --- UI Rendering ---

        function renderBranchList() {
            if (branches.length === 0) {
                 branchListContainer.innerHTML = '<p class="text-gray-500 text-center mt-8">No branches registered yet.</p>';
                 return;
            }
            
            branchListContainer.innerHTML = branches.map(branch => `
                <div class="branch-card p-4 card-shadow flex items-center justify-between space-x-4 mt-2">
                    
                    <!-- Branch Info -->
                    <div class="flex-grow">
                        <h3 class="text-lg font-extrabold text-gray-900">${branch.location_name}</h3>
                        <p class="text-sm text-gray-500 mt-0">${branch.city}, ${branch.governorate}</p>
                        <p class="text-xs text-teal-600 font-semibold mt-1">Hours: ${branch.opening_time} - ${branch.closing_time} | Phone: ${branch.branch_phone}</p>
                    </div>

                    <!-- Edit Button (Pen Icon) -->
                    <button onclick="openEditModal('${branch.id}')" 
                            class="p-2 text-blue-600 hover:bg-blue-100 rounded-full transition flex-shrink-0" title="Edit Branch">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.536L15.232 5.232z"></path></svg>
                    </button>
                </div>
            `).join('');
        }

        function openEditModal(branchId) {
            const branch = branches.find(b => b.id === branchId);
            if (!branch) return showSnackbar('Branch data not found.', true);

            // Populate TIME selectors first
            populateTimeSelect('edit-opening-hour', 1, 12, 1, true);
            populateTimeSelect('edit-opening-minute', 0, 55, 5);
            populateTimeSelect('edit-closing-hour', 1, 12, 1, true);
            populateTimeSelect('edit-closing-minute', 0, 55, 5);
            
            // Populate CHECKLIST (Must be populated before values are set)
            populateDeliveryChecklist('edit-delivery-checklist', branch.delivery_options);
            
            // Parse and set existing times
            const openTime = parseDisplayTime(branch.opening_time);
            const closeTime = parseDisplayTime(branch.closing_time);

            document.getElementById('edit-opening-hour').value = openTime.hour;
            document.getElementById('edit-opening-minute').value = openTime.minute;
            document.getElementById('edit-opening-ampm').value = openTime.ampm;
            
            document.getElementById('edit-closing-hour').value = closeTime.hour;
            document.getElementById('edit-closing-minute').value = closeTime.minute;
            document.getElementById('edit-closing-ampm').value = closeTime.ampm;
            
            // Populate Modal Fields
            document.getElementById('branch-edit-title').textContent = branch.location_name;
            document.getElementById('edit-branch-id').value = branch.id;
            
            document.getElementById('edit-governorate').value = branch.governorate;
            document.getElementById('edit-city').value = branch.city;
            document.getElementById('edit-location-url').value = branch.location_url;
            document.getElementById('edit-branch-phone').value = branch.branch_phone;

            document.getElementById('edit-time-message').textContent = '';

            // Show modal
            modalOverlay.classList.remove('hidden');
        }

        function closeEditModal() {
            modalOverlay.classList.add('hidden');
            editForm.reset();
        }

        // --- Event Handlers (Update/Edit) ---
        
        editForm.addEventListener('submit', function(event) {
            event.preventDefault();
            
            const form = event.target;
            const branchId = form.elements['edit-branch-id'].value;
            const branchIndex = branches.findIndex(b => b.id === branchId);
            const timeMessage = document.getElementById('edit-time-message');
            timeMessage.textContent = '';

            if (branchIndex === -1) {
                showSnackbar('Error: Branch ID mismatch.', true);
                return;
            }

            const openingHour = form.elements.opening_hour.value;
            const openingMinute = form.elements.opening_minute.value;
            const openingAmPm = form.elements.opening_ampm.value;
            const closingHour = form.elements.closing_hour.value;
            const closingMinute = form.elements.closing_minute.value;
            const closingAmPm = form.elements.closing_ampm.value;

            const openingTimeInMinutes = convertTo24Hour(openingHour, openingMinute, openingAmPm);
            const closingTimeInMinutes = convertTo24Hour(closingHour, closingMinute, closingAmPm);
            
            // Validation
            if (closingTimeInMinutes <= openingTimeInMinutes) {
                timeMessage.textContent = "Closing time must be after opening time.";
                return;
            }

            const selectedOptions = Array.from(form.elements.edit_delivery_options)
                .filter(checkbox => checkbox.checked)
                .map(checkbox => checkbox.value);

            if (selectedOptions.length === 0) {
                 timeMessage.textContent = "Please select at least one delivery option offered at this branch.";
                 return;
            }

            // Update all the branch data
            branches[branchIndex].governorate = form.elements.governorate.value;
            branches[branchIndex].city = form.elements.city.value;
            branches[branchIndex].location_url = form.elements.location_url.value;
            branches[branchIndex].branch_phone = form.elements.branch_phone.value;
            branches[branchIndex].opening_time = `${openingHour}:${openingMinute} ${openingAmPm}`;
            branches[branchIndex].closing_time = `${closingHour}:${closingMinute} ${closingAmPm}`;
            branches[branchIndex].delivery_options = selectedOptions;
            
            showSnackbar(`Branch ${branches[branchIndex].location_name} updated successfully.`, false);
            
            renderBranchList();
            closeEditModal();
        });

        // --- Initialization ---

        window.onload = () => {
            // Initial population of the list
            renderBranchList();
            
            // Attach close handler for the modal
            document.getElementById('close-modal-btn').onclick = closeEditModal;
            modalOverlay.onclick = (e) => {
                if (e.target.id === 'edit-modal-overlay') {
                    closeEditModal();
                }
            };
        };
    </script>
</body>
</html>