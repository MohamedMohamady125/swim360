<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Register Store Branch</title>
    <!-- Tailwind CSS CDN for styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
        body {
            font-family: 'Inter', sans-serif;
            background-color: #F7F9FB;
        }
        /* Custom green submit button style */
        .btn-submit {
            background-color: #3B82F6; /* Using blue for general store action */
            color: white;
            transition: background-color 0.2s, transform 0.2s;
        }
        .btn-submit:hover {
            background-color: #2563EB;
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
            width: 100%;
        }
        .input-group:focus-within {
            border-color: #3B82F6;
            box-shadow: 0 0 0 1px #3B82F6;
            background-color: white;
        }
        .input-group input,
        .input-group select {
            border: none;
            outline: none;
            padding: 12px 0; /* Increased vertical padding for space */
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
        <h1 class="text-3xl font-extrabold text-gray-800 mb-2">Register Store Branch</h1>
        <p class="text-gray-500 mb-8">Enter the location details and operational hours for your retail outlet.</p>

        <form id="branch-form" class="space-y-6">

            <!-- Location Details Card -->
            <div class="form-card space-y-6">
                <h3 class="text-xl font-bold text-gray-800 mb-4 border-b pb-2">Location Information</h3>

                <!-- Governorate (NEW FIELD) -->
                <div>
                    <label for="governorate" class="block text-sm font-medium text-gray-700 mb-1">Governorate</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.828 0l-4.243-4.243a8 8 0 1111.314 0z" />
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                        </svg>
                        <input type="text" id="governorate" name="governorate" required placeholder="e.g., Cairo Governorate" />
                    </div>
                </div>

                <!-- City -->
                <div>
                    <label for="city" class="block text-sm font-medium text-gray-700 mb-1">City</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.828 0l-4.243-4.243a8 8 0 1111.314 0z" />
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                        </svg>
                        <input type="text" id="city" name="city" required placeholder="e.g., Jeddah" />
                    </div>
                </div>

                <!-- Location Name (Unique Name) -->
                <div>
                    <label for="location-name" class="block text-sm font-medium text-gray-700 mb-1">Store Location Name</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 10h6"></path>
                        </svg>
                        <input type="text" id="location-name" name="location_name" required placeholder="e.g., Red Sea Mall Branch" />
                    </div>
                </div>

                <!-- Location URL (Google Maps Link) -->
                <div>
                    <label for="location-url" class="block text-sm font-medium text-gray-700 mb-1">Google Maps URL</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.135a4 4 0 000-5.656l1.5-1.5a4 4 0 115.656 5.656l-4 4a4 4 0 01-5.656 0z"></path>
                        </svg>
                        <input type="url" id="location-url" name="location_url" required placeholder="e.g., https://maps.app.goo.gl/..." />
                    </div>
                </div>
            </div>

            <!-- Operational Hours Card -->
            <div class="form-card space-y-4">
                <h3 class="text-xl font-bold text-gray-800 mb-4 border-b pb-2">Operational Hours</h3>

                <!-- Branch Phone Number (NEW FIELD) -->
                <div>
                    <label for="branch-phone" class="block text-sm font-medium text-gray-700 mb-1">Branch Phone Number</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.408 5.408l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z">
                            </path>
                        </svg>
                        <input type="tel" id="branch-phone" name="branch_phone" required placeholder="e.g., +96650XXXXXXX" />
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <!-- Opening Time -->
                    <div>
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

                    <!-- Closing Time -->
                    <div>
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

            <!-- Delivery Time Range Card (NEW) -->
            <div class="form-card space-y-4">
                <h3 class="text-xl font-bold text-gray-800 mb-4 border-b pb-2">Delivery Time Range (days)</h3>
                <div>
                    <label for="delivery-time-range" class="block text-sm font-medium text-gray-700 mb-1">Enter delivery time range (e.g., 3 or 3-5)</label>
                    <div class="input-group">
                        <input type="text" id="delivery-time-range" name="delivery_time_range" required placeholder="e.g., 3 or 3-5" pattern="^\d+(-\d+)?$" title="Enter a number or a range like 3-5" />
                    </div>
                </div>
                <p id="delivery-time-message" class="text-xs text-red-500 h-4"></p>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="w-full py-3 text-white font-semibold rounded-lg shadow-lg btn-submit">
                <span id="submit-text">Register Branch</span>
            </button>
        </form>
    </div>

    <script>
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
            if (ampm === 'PM' && hour !== 12) {
                hour += 12;
            } else if (ampm === 'AM' && hour === 12) {
                hour = 0;
            }
            return hour * 60 + parseInt(minute);
        }

        // --- Form Submission Logic ---

        document.getElementById('branch-form').addEventListener('submit', function(event) {
            event.preventDefault();

            const form = event.target;
            const timeMessage = document.getElementById('time-message');
            const deliveryTimeMessage = document.getElementById('delivery-time-message');
            timeMessage.textContent = '';
            deliveryTimeMessage.textContent = '';

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

            // Validate delivery time range format: accept number or range (e.g., 3 or 3-5)
            const deliveryTimeRange = form.elements.delivery_time_range.value.trim();
            if (!/^\d+(-\d+)?$/.test(deliveryTimeRange)) {
                deliveryTimeMessage.textContent = 'Please enter a valid delivery time range (e.g., 3 or 3-5)';
                return;
            }

            const data = {
                governorate: form.elements.governorate.value,
                city: form.elements.city.value,
                location_name: form.elements.location_name.value,
                location_url: form.elements.location_url.value,
                branch_phone: form.elements.branch_phone.value,
                opening_time: `${openingHour}:${openingMinute} ${openingAmPm}`,
                closing_time: `${closingHour}:${closingMinute} ${closingAmPm}`,
                delivery_time_range: deliveryTimeRange
            };

            console.log("New Store Branch Registration Data:", data);

            // Show success message (Mock behavior)
            const submitButton = document.getElementById('submit-text');
            submitButton.textContent = 'Registering...';

            setTimeout(() => {
                submitButton.textContent = 'Branch Registered!';
                showSnackbar(`Successfully registered new branch: ${data.location_name} in ${data.city}`, false);

                // Reset form and re-populate selectors
                setTimeout(() => {
                    submitButton.textContent = 'Register Branch';
                    form.reset();
                    // Re-initialize time selectors to default state
                    populateTimeSelect('opening-hour', 1, 12, 1, true);
                    populateTimeSelect('opening-minute', 0, 55, 5);
                    populateTimeSelect('closing-hour', 1, 12, 1, true);
                    populateTimeSelect('closing-minute', 0, 55, 5);
                }, 2000);
            }, 1000);
        });

        // --- Initialization ---

        window.onload = () => {
            populateTimeSelect('opening-hour', 1, 12, 1, true); // 12-hour format
            populateTimeSelect('opening-minute', 0, 55, 5);
            populateTimeSelect('closing-hour', 1, 12, 1, true); // 12-hour format
            populateTimeSelect('closing-minute', 0, 55, 5);
        };
    </script>
</body>
</html>
