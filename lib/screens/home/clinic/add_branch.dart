<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register New Clinic Branch</title>
    <!-- Tailwind CSS CDN for styling --><script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
        body {
            font-family: 'Inter', sans-serif;
            background-color: #F7F9FB;
        }
        /* Custom green submit button style */
        .btn-submit {
            background-color: #4CAF50; /* Green shade */
            color: white;
            transition: background-color 0.2s, transform 0.2s;
        }
        .btn-submit:hover {
            background-color: #45A049;
            transform: translateY(-1px);
        }
        .form-card {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.05);
            padding: 1.5rem;
        }
        /* Style similar to the clean list items in the provided UI screenshots */
        .input-group {
            display: flex;
            align-items: center;
            border: 1px solid #E5E7EB; /* Light grey border */
            border-radius: 8px;
            padding: 0 12px;
            background-color: #FAFAFA; /* Very light background for contrast */
            transition: border-color 0.2s, box-shadow 0.2s;
            width: 100%; /* Ensure full width when not in a grid */
        }
        .input-group:focus-within {
            border-color: #3B82F6;
            box-shadow: 0 0 0 1px #3B82F6;
            background-color: white;
        }
        .input-group input, .input-group select {
            border: none;
            outline: none;
            padding: 12px 0; /* Increased vertical padding for space */
            flex-grow: 1;
            background-color: transparent;
        }
        .time-select-group {
            display: flex;
            gap: 0.5rem; /* Space between selects */
        }
        .time-select-group select {
            padding: 10px;
            border: 1px solid #E5E7EB;
            border-radius: 8px;
            background-color: #FAFAFA;
            flex-grow: 1;
            -webkit-appearance: none; /* Remove default arrow for custom styling */
            -moz-appearance: none;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20' fill='none' stroke='%239CA3AF' stroke-width='1.5' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M6 8l4 4 4-4'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 0.75rem center;
            background-size: 1.5em 1.5em;
        }
        .time-select-group select:focus {
            border-color: #3B82F6;
            box-shadow: 0 0 0 1px #3B82F6;
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
        <h1 class="text-3xl font-extrabold text-gray-800 mb-2">Register New Branch</h1>
        <p class="text-gray-500 mb-8">Enter the physical details and operational hours for your new clinic location.</p>

        <form id="branch-form" class="space-y-6">
            
            <!-- Location Details Card --><div class="form-card space-y-6">
                <h3 class="text-xl font-bold text-gray-800 mb-4 border-b pb-2">Location Information</h3>
                
                <!-- City --><div>
                    <label for="city" class="block text-sm font-medium text-gray-700 mb-1">City</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.828 0l-4.243-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                        <input type="text" id="city" name="city" required placeholder="e.g., Riyadh">
                    </div>
                </div>
                
                <!-- Location Name --><div>
                    <label for="location-name" class="block text-sm font-medium text-gray-700 mb-1">Location Name</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 10h6"></path></svg>
                        <input type="text" id="location-name" name="location_name" required placeholder="e.g., Al Malaz Branch">
                    </div>
                </div>

                <!-- Location URL (Google Maps Link) --><div>
                    <label for="location-url" class="block text-sm font-medium text-gray-700 mb-1">Google Maps URL</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.135a4 4 0 000-5.656l1.5-1.5a4 4 0 115.656 5.656l-4 4a4 4 0 01-5.656 0z"></path></svg>
                        <input type="url" id="location-url" name="location_url" required placeholder="e.g., https://maps.app.goo.gl/...">
                    </div>
                </div>
                
                <!-- Number of Beds --><div>
                    <label for="number-of-beds" class="block text-sm font-medium text-gray-700 mb-1">Number of Treatment Beds</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10a2 2 0 01-2 2H6a2 2 0 01-2-2V7m16 0-8 4m-8-4v10"></path></svg>
                        <input type="number" id="number-of-beds" name="number_of_beds" required min="1" placeholder="e.g., 5">
                    </div>
                </div>

            </div>

            <!-- Operational Hours Card --><div class="form-card space-y-4">
                <h3 class="text-xl font-bold text-gray-800 mb-4 border-b pb-2">Operational Hours</h3>
                
                <div class="grid grid-cols-2 gap-4">
                    <!-- Opening Time --><div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Opening Time</label>
                        <div class="time-select-group">
                            <select id="opening-hour" name="opening_hour" required></select>
                            <select id="opening-minute" name="opening_minute" required></select>
                            <select id="opening-ampm" name="opening_ampm" required>
                                <option value="AM">AM</option>
                                <option value="PM">PM</option>
                            </select>
                        </div>
                    </div>

                    <!-- Closing Time --><div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Closing Time</label>
                        <div class="time-select-group">
                            <select id="closing-hour" name="closing_hour" required></select>
                            <select id="closing-minute" name="closing_minute" required></select>
                            <select id="closing-ampm" name="closing_ampm" required>
                                <option value="AM">AM</option>
                                <option value="PM">PM</option>
                            </select>
                        </div>
                    </div>
                </div>
                <p id="time-message" class="text-xs text-red-500 h-4"></p>
            </div>

            <!-- Services Checklist Card --><div class="form-card space-y-4">
                <h3 class="text-xl font-bold text-gray-800 mb-4 border-b pb-2">Available Services</h3>
                
                <div id="services-checklist" class="checklist-group grid grid-cols-1 sm:grid-cols-2 gap-3">
                    <!-- Checkboxes will be populated by JS --></div>
            </div>

            <!-- Submit Button --><button type="submit" class="w-full py-3 text-white font-semibold rounded-lg shadow-lg btn-submit">
                <span id="submit-text">Register Branch</span>
            </button>
            
        </form>
    </div>

    <script>
        // Physiotherapy Service Options
        const services = [
            "Manual Therapy", "Sports Rehabilitation", "Post-Surgical Rehab",
            "Dry Needling", "Cupping Therapy", "Hydrotherapy",
            "Gait Analysis", "Ergonomic Assessment"
        ];

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

        function populateServicesChecklist() {
            const checklistContainer = document.getElementById('services-checklist');
            checklistContainer.innerHTML = services.map(service => `
                <label class="flex items-center space-x-3 text-sm font-medium text-gray-700">
                    <input type="checkbox" name="services" value="${service.toLowerCase().replace(/\s/g, '-')}" class="h-4 w-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500">
                    <span>${service}</span>
                </label>
            `).join('');
        }

        function populateTimeSelect(selectId, start, end, step, isHour = false) {
            const select = document.getElementById(selectId);
            select.innerHTML = ''; // Clear existing options
            for (let i = start; i <= end; i += step) {
                const value = isHour ? (i === 0 ? 12 : i) : i; // For hours, 0 becomes 12 (12-hour format)
                const text = String(value).padStart(2, '0');
                const option = document.createElement('option');
                option.value = text;
                option.textContent = text;
                select.appendChild(option);
            }
        }

        // Helper to convert 12-hour format (with AM/PM) to 24-hour for comparison
        function convertTo24Hour(hour12, minute, ampm) {
            let hour = parseInt(hour12);
            if (ampm === 'PM' && hour !== 12) {
                hour += 12;
            } else if (ampm === 'AM' && hour === 12) {
                hour = 0;
            }
            return hour * 60 + parseInt(minute); // Convert to total minutes from midnight
        }

        // --- Form Submission Logic ---

        document.getElementById('branch-form').addEventListener('submit', function(event) {
            event.preventDefault();
            
            const form = event.target;
            const timeMessage = document.getElementById('time-message');
            timeMessage.textContent = '';

            const openingHour = form.elements.opening_hour.value;
            const openingMinute = form.elements.opening_minute.value;
            const openingAmPm = form.elements.opening_ampm.value;

            const closingHour = form.elements.closing_hour.value;
            const closingMinute = form.elements.closing_minute.value;
            const closingAmPm = form.elements.closing_ampm.value;

            const openingTimeInMinutes = convertTo24Hour(openingHour, openingMinute, openingAmPm);
            const closingTimeInMinutes = convertTo24Hour(closingHour, closingMinute, closingAmPm);

            // Time Validation: Check if Closing Time is before or same as Opening Time
            if (closingTimeInMinutes <= openingTimeInMinutes) {
                timeMessage.textContent = "Closing time must be after opening time.";
                return;
            }

            // Collect selected services
            const selectedServices = Array.from(form.elements.services)
                .filter(checkbox => checkbox.checked)
                .map(checkbox => checkbox.value);

            if (selectedServices.length === 0) {
                 timeMessage.textContent = "Please select at least one service offered at this branch.";
                 return;
            }

            const data = {
                city: form.elements.city.value,
                location_name: form.elements.location_name.value,
                location_url: form.elements.location_url.value,
                number_of_beds: parseInt(form.elements.number_of_beds.value),
                opening_time: `${openingHour}:${openingMinute} ${openingAmPm}`,
                closing_time: `${closingHour}:${closingMinute} ${closingAmPm}`,
                services_offered: selectedServices
            };

            console.log("New Branch Registration Data:", data);
            
            // Show success message (Mock behavior)
            const submitButton = document.getElementById('submit-text');
            submitButton.textContent = 'Registering...';
            
            setTimeout(() => {
                submitButton.textContent = 'Branch Registered!';
                showSnackbar(`Successfully registered new branch: ${data.location_name} in ${data.city}`, false);
                
                // Reset button text after delay
                setTimeout(() => {
                    submitButton.textContent = 'Register Branch';
                    form.reset();
                    populateServicesChecklist(); // Re-populate and uncheck services
                    populateTimeSelect('opening-hour', 1, 12, 1, true);
                    populateTimeSelect('opening-minute', 0, 55, 5);
                    populateTimeSelect('closing-hour', 1, 12, 1, true);
                    populateTimeSelect('closing-minute', 0, 55, 5);
                }, 2000);
            }, 1000);
        });

        // --- Initialization ---

        window.onload = () => {
            populateServicesChecklist();
            populateTimeSelect('opening-hour', 1, 12, 1, true); // 12-hour format
            populateTimeSelect('opening-minute', 0, 55, 5);
            populateTimeSelect('closing-hour', 1, 12, 1, true); // 12-hour format
            populateTimeSelect('closing-minute', 0, 55, 5);
        };
    </script>
</body>
</html>