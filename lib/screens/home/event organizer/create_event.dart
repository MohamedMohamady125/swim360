<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create New Event</title>
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
        .input-group input, .input-group textarea, .input-group select {
            border: none;
            outline: none;
            padding: 12px 0; /* Increased vertical padding for space */
            flex-grow: 1;
            background-color: transparent;
        }
        /* Specific styling for Duration split inputs */
        .duration-input input {
            border-right: 1px solid #E5E7EB;
            padding-right: 12px;
        }
        .duration-input select {
            padding-left: 12px;
            width: auto;
            flex-grow: 0;
            cursor: pointer;
        }
        .file-upload-box {
            position: relative;
            border: 2px dashed #D1D5DB;
            background-color: #F9FAFB;
            transition: border-color 0.2s;
        }
        .file-upload-box:hover {
            border-color: #60A5FA;
        }
    </style>
</head>
<body class="p-4 md:p-8">

    <div class="max-w-xl mx-auto">
        <h1 class="text-3xl font-extrabold text-gray-800 mb-2">Create New Event</h1>
        <p class="text-gray-500 mb-8">Define details, capacity, and audience for your event.</p>

        <form id="event-form" class="space-y-6">
            
            <!-- Event & Media Details Card -->
            <div class="form-card space-y-6">
                <h3 class="text-xl font-bold text-gray-800 mb-4 border-b pb-2">Event Details & Media</h3>
                
                <!-- Event Name -->
                <div>
                    <label for="event-name" class="block text-sm font-medium text-gray-700 mb-1">Event Name</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                        <input type="text" id="event-name" name="name" required
                               placeholder="e.g., Grand Prix 2026">
                    </div>
                </div>

                <!-- Event Type Dropdown -->
                <div>
                    <label for="event-type" class="block text-sm font-medium text-gray-700 mb-1">Event Type</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37a1.724 1.724 0 002.572-1.065z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                        <select id="event-type" name="type" required>
                            <option value="" disabled selected>Select Event Type</option>
                            <option value="championship">Championship</option>
                            <option value="clinic">Clinic</option>
                            <option value="seminar">Seminar</option>
                            <option value="zoom">Zoom Meeting</option>
                            <option value="other">Other</option>
                        </select>
                    </div>
                </div>

                <!-- Cover Photo Upload (Required) -->
                <div>
                    <label for="cover-photo" class="block text-sm font-medium text-gray-700 mb-1">Cover Photo (Required)</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                        <input type="file" id="cover-photo" name="cover_photo" accept="image/*" required class="w-full">
                    </div>
                </div>

                <!-- Intro Video URL (Optional) -->
                <div>
                    <label for="intro-video-url" class="block text-sm font-medium text-gray-700 mb-1">Promo Video URL (Optional)</label>
                    <div class="input-group">
                         <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z"></path></svg>
                         <input type="url" id="intro-video-url" name="video_url"
                               placeholder="e.g., https://youtube.com/watch?v=...">
                    </div>
                </div>

                <!-- Detailed Description -->
                <div>
                    <label for="event-description" class="block text-sm font-medium text-gray-700 mb-1">Detailed Description</label>
                    <textarea id="event-description" name="description" rows="4" required
                              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500 transition duration-150"
                              placeholder="Outline the schedule, importance, and requirements."></textarea>
                </div>
            </div>

            <!-- Time, Location, and Capacity Card (Two Columns) -->
            <div class="form-card">
                <h3 class="text-xl font-bold text-gray-800 mb-4 border-b pb-2">Time, Location, and Capacity</h3>
                
                <div class="grid grid-cols-2 gap-4">
                    
                    <!-- Date Input -->
                    <div>
                        <label for="event-date" class="block text-sm font-medium text-gray-700 mb-1">Date</label>
                        <div class="input-group">
                            <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            <input type="date" id="event-date" name="date" required>
                        </div>
                    </div>
                    
                    <!-- Time Input (New Field) -->
                    <div>
                        <label for="event-time" class="block text-sm font-medium text-gray-700 mb-1">Time</label>
                        <div class="input-group">
                            <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                            <input type="time" id="event-time" name="time" required>
                        </div>
                    </div>

                    <!-- Duration -->
                    <div>
                        <label for="duration-value" class="block text-sm font-medium text-gray-700 mb-1">Duration</label>
                        <div class="input-group p-0 duration-input">
                            <svg class="w-5 h-5 text-gray-400 ml-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                            <input type="number" id="duration-value" name="duration_value" required min="1" placeholder="3" class="w-2/3">
                            <select id="duration-unit" name="duration_unit" class="w-1/3">
                                <option value="hours">Hours</option>
                                <option value="days">Days</option>
                                <option value="minutes">Minutes</option>
                            </select>
                        </div>
                    </div>

                    <!-- Tickets Available -->
                    <div>
                        <label for="tickets-available" class="block text-sm font-medium text-gray-700 mb-1">Tickets Available</label>
                        <div class="input-group">
                            <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 002 2h3.586a1 1 0 01.707.293l2.828 2.828a1 1 0 001.414 0l2.828-2.828a1 1 0 01.707-.293H19a2 2 0 002-2v-3a2 2 0 00-2-2H5z"></path></svg>
                            <input type="number" id="tickets-available" name="tickets" required min="1" placeholder="e.g., 100">
                        </div>
                    </div>

                    <!-- Location Name -->
                    <div class="col-span-2">
                        <label for="location-name" class="block text-sm font-medium text-gray-700 mb-1">Location Name (Venue)</label>
                        <div class="input-group">
                            <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.828 0l-4.243-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                            <input type="text" id="location-name" name="location_name" required placeholder="e.g., National Stadium Pool">
                        </div>
                    </div>

                    <!-- Google Maps URL -->
                    <div class="col-span-2">
                        <label for="location-url" class="block text-sm font-medium text-gray-700 mb-1">Google Maps URL (Venue)</label>
                        <div class="input-group">
                            <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.135a4 4 0 000-5.656l1.5-1.5a4 4 0 115.656 5.656l-4 4a4 4 0 01-5.656 0z"></path></svg>
                            <input type="url" id="location-url" name="location_url" required placeholder="e.g., https://maps.app.goo.gl/...">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Audience & Pricing Card -->
            <div class="form-card">
                <h3 class="text-xl font-bold text-gray-800 mb-4 border-b pb-2">Audience & Pricing</h3>
                
                <div class="grid grid-cols-2 gap-4">
                    
                    <!-- Price -->
                    <div>
                        <label for="event-price" class="block text-sm font-medium text-gray-700 mb-1">Ticket Price (USD)</label>
                        <div class="input-group">
                            <span class="text-gray-400 font-semibold mr-1">$</span>
                            <input type="number" id="event-price" name="price" required min="0" step="0.01" placeholder="50.00">
                        </div>
                    </div>

                    <!-- Recommended Age Range -->
                    <div>
                        <label for="age-range" class="block text-sm font-medium text-gray-700 mb-1">Recommended Age Range</label>
                        <div class="input-group">
                            <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h2a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v13a2 2 0 002 2h2M9 14v6M15 14v6M12 3v18"></path></svg>
                            <input type="text" id="age-range" name="age_range" placeholder="e.g., 12-18 or All Ages">
                        </div>
                    </div>

                    <!-- Target Audience Dropdown -->
                    <div class="col-span-2">
                        <label for="target-audience" class="block text-sm font-medium text-gray-700 mb-1">Target Audience</label>
                        <div class="input-group">
                            <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                            <select id="target-audience" name="target_audience" required>
                                <option value="" disabled selected>Select Primary Audience</option>
                                <option value="swimmers">Swimmers</option>
                                <option value="nutritionists">Nutritionists</option>
                                <option value="doctors">Doctors</option>
                                <option value="parents">Parents</option>
                                <option value="coaches">Coaches</option>
                                <option value="other">Other</option>
                            </select>
                        </div>
                    </div>

                </div>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="w-full py-3 text-white font-semibold rounded-lg shadow-lg bg-red-600 hover:bg-red-700 transition">
                <span id="submit-text">Publish Event</span>
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

        document.getElementById('event-form').addEventListener('submit', function(event) {
            event.preventDefault();
            
            const form = event.target;

            // Simple validation check: Date cannot be in the past
            const eventDate = new Date(form.elements.date.value);
            const today = new Date();
            today.setHours(0,0,0,0);

            if (eventDate < today) {
                showSnackbar("Error: Event date cannot be in the past.", true);
                return;
            }

            const data = {
                event_name: form.elements.name.value,
                event_type: form.elements.type.value,
                description: form.elements.description.value,
                date: form.elements.date.value,
                time: form.elements.time.value, // Added Time
                duration: `${form.elements.duration_value.value} ${form.elements.duration_unit.value}`,
                tickets: parseInt(form.elements.tickets.value),
                price: parseFloat(form.elements.price.value),
                location_name: form.elements.location_name.value,
                location_url: form.elements.location_url.value,
                age_range: form.elements.age_range.value,
                target_audience: form.elements.target_audience.value,
                cover_photo: form.elements.cover_photo.files[0] ? form.elements.cover_photo.files[0].name : null,
                video_url: form.elements.video_url.value || null
            };

            console.log("New Event Data:", data);
            
            // Show success message (Mock behavior)
            const submitButton = document.getElementById('submit-text');
            submitButton.textContent = 'Publishing...';
            
            setTimeout(() => {
                submitButton.textContent = 'Event Published!';
                showSnackbar(`Successfully published event: ${data.event_name}`, false);
                
                // Reset button state
                setTimeout(() => {
                    submitButton.textContent = 'Publish Event';
                    form.reset();
                }, 2000);
            }, 1000);
        });

        // --- Initialization ---

        window.onload = () => {
             const today = new Date().toISOString().split('T')[0];
             document.getElementById('event-date').min = today;
        };
    </script>
</body>
</html>