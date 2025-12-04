<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Events Management</title>
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
        .event-card {
            background-color: white;
            border-radius: 10px;
            transition: transform 0.1s, box-shadow 0.1s;
        }
        .event-card:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1),
                        0 2px 4px -2px rgba(0, 0, 0, 0.06);
        }
        .modal-content-wrapper {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1),
                        0 4px 6px -4px rgba(0, 0, 0, 0.05);
            max-height: 90vh;
            overflow-y: auto;
        }
        /* Input styling for consistency */
        .input-group {
            display: flex;
            align-items: center;
            border: 1px solid #E5E7EB;
            border-radius: 8px;
            padding: 0 12px;
            background-color: #FAFAFA;
        }
        .input-group input, .input-group select, .input-group textarea {
            border: none;
            outline: none;
            padding: 12px 0;
            flex-grow: 1;
            background-color: transparent;
        }
        .input-group-readonly {
            background-color: #E5E7EB;
            cursor: not-allowed;
            color: #6B7280;
        }
        .input-group-readonly input, .input-group-readonly select, .input-group-readonly textarea {
            cursor: not-allowed;
            color: #6B7280;
        }
        .detail-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #F3F4F6;
            font-size: 0.9rem;
        }
        .detail-label {
            font-weight: 500;
            color: #4B5563;
        }
        .detail-value {
            font-weight: 600;
            color: #1F2937;
        }
        /* Specific styling for Duration split inputs */
        .duration-input {
            display: flex;
            align-items: center;
            border: 1px solid #E5E7EB;
            border-radius: 8px;
            padding: 0;
            background-color: #FAFAFA;
            width: 100%;
        }
        .duration-input input {
            border-right: 1px solid #E5E7EB;
            padding: 12px;
        }
        .duration-input select {
            padding: 12px;
            flex-grow: 0;
            width: auto;
            min-width: 100px;
            cursor: pointer;
        }
    </style>
</head>
<body class="p-4 md:p-8">

    <div class="max-w-xl mx-auto">
        <h1 class="text-3xl font-extrabold text-gray-800 mb-2">My Events</h1>
        <p class="text-gray-500 mb-6">Manage details and logistics for your upcoming events.</p>

        <div id="event-list" class="space-y-4">
            <!-- Event Cards will be injected here -->
        </div>
    </div>

    <!-- Edit Modal Structure (Hidden by default) -->
    <div id="edit-modal-overlay" class="fixed inset-0 bg-black bg-opacity-50 z-[99] flex items-center justify-center p-4 hidden">
        <div class="modal-content-wrapper w-full max-w-lg">
            
            <div class="p-5 border-b flex justify-between items-center sticky top-0 bg-white rounded-t-xl">
                <h3 class="text-2xl font-extrabold text-gray-800">Edit Event: <span id="event-edit-title" class="text-blue-600"></span></h3>
                <button id="close-edit-modal-btn" class="text-gray-500 hover:text-gray-800 transition">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>

            <form id="edit-event-form" class="p-5 space-y-6">
                
                <input type="hidden" id="edit-event-id">

                <!-- Location and Time Details -->
                <div class="space-y-6">
                    <h4 class="font-bold text-gray-700 pt-2 border-t">Event Information</h4>
                    
                    <!-- Event Name (READ-ONLY) -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Event Name</label>
                        <p class="text-lg font-semibold text-gray-600" id="edit-name-display"></p>
                    </div>

                    <!-- Event Type Dropdown (Editable) -->
                    <div>
                        <label for="edit-type" class="block text-sm font-medium text-gray-700 mb-1">Event Type</label>
                        <div class="input-group">
                            <input type="text" id="edit-type" name="type" placeholder="e.g., Championship" required>
                        </div>
                    </div>

                    <!-- Detailed Description (Editable) -->
                    <div>
                        <label for="edit-description" class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                        <textarea id="edit-description" name="description" rows="4" required
                                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500 transition duration-150"></textarea>
                    </div>

                    <!-- Intro Video URL (Editable) -->
                    <div>
                        <label for="edit-video-url" class="block text-sm font-medium text-gray-700 mb-1">Promo Video URL (Optional)</label>
                        <div class="input-group">
                             <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                             <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z"></path></svg>
                             <input type="url" id="edit-video-url" name="video_url" placeholder="e.g., https://youtube.com/embed">
                        </div>
                    </div>

                </div>
                
                <!-- Logistics Card -->
                <div class="space-y-6">
                    <h4 class="font-bold text-gray-700 pt-2 border-t">Logistics and Capacity</h4>
                    
                     <div class="grid grid-cols-2 gap-4">
                        <!-- Date Input -->
                        <div>
                            <label for="edit-date" class="block text-sm font-medium text-gray-700 mb-1">Date</label>
                            <div class="input-group">
                                <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                                <input type="date" id="edit-date" name="date" required>
                            </div>
                        </div>
                        
                        <!-- Time Input -->
                        <div>
                            <label for="edit-time" class="block text-sm font-medium text-gray-700 mb-1">Time</label>
                            <div class="input-group">
                                <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                                <input type="time" id="edit-time" name="time" required>
                            </div>
                        </div>

                        <!-- Duration -->
                        <div>
                            <label for="edit-duration-value" class="block text-sm font-medium text-gray-700 mb-1">Duration</label>
                            <div class="duration-input">
                                <input type="number" id="edit-duration-value" name="duration_value" required min="1" class="w-2/3" placeholder="3">
                                <select id="edit-duration-unit" name="duration_unit" class="w-1/3">
                                    <option value="hours">Hours</option>
                                    <option value="days">Days</option>
                                    <option value="minutes">Minutes</option>
                                </select>
                            </div>
                        </div>

                        <!-- Tickets Available -->
                        <div>
                            <label for="edit-tickets-available" class="block text-sm font-medium text-gray-700 mb-1">Tickets Available</label>
                            <div class="input-group">
                                <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 002 2h3.586a1 1 0 01.707.293l2.828 2.828a1 1 0 001.414 0l2.828-2.828a1 1 0 01.707-.293H19a2 2 0 002-2v-3a2 2 0 00-2-2H5z"></path></svg>
                                <input type="number" id="edit-tickets-available" name="tickets" required min="1" placeholder="e.g., 100">
                            </div>
                        </div>

                        <!-- Location Name -->
                        <div class="col-span-2">
                            <label for="edit-location-name" class="block text-sm font-medium text-gray-700 mb-1">Location Name (Venue)</label>
                            <div class="input-group">
                                <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.828 0l-4.243-4.243a8 8 0 1111.314 0z"></path>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                                <input type="text" id="edit-location-name" name="location_name" required placeholder="e.g., National Stadium Pool">
                            </div>
                        </div>

                        <!-- Google Maps URL -->
                        <div class="col-span-2">
                            <label for="edit-location-url" class="block text-sm font-medium text-gray-700 mb-1">Google Maps URL (Venue)</label>
                            <div class="input-group">
                                <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.135a4 4 0 000-5.656l1.5-1.5a4 4 0 115.656 5.656l-4 4a4 4 0 01-5.656 0z"></path></svg>
                                <input type="url" id="edit-location-url" name="location_url" required placeholder="e.g., https://maps.app.goo.gl/...">
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Audience Card -->
                <div class="space-y-6">
                    <h4 class="font-bold text-gray-700 pt-2 border-t">Audience Details</h4>
                    
                    <div class="grid grid-cols-2 gap-4">
                        <!-- Recommended Age Range -->
                        <div>
                            <label for="edit-age-range" class="block text-sm font-medium text-gray-700 mb-1">Recommended Age Range</label>
                            <div class="input-group">
                                <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h2a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v13a2 2 0 002 2h2M9 14v6M15 14v6M12 3v18"></path></svg>
                                <input type="text" id="edit-age-range" name="age_range" placeholder="e.g., 12-18 or All Ages">
                            </div>
                        </div>

                        <!-- Target Audience Dropdown -->
                        <div>
                            <label for="edit-target-audience" class="block text-sm font-medium text-gray-700 mb-1">Target Audience</label>
                            <div class="input-group">
                                <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                                <select id="edit-target-audience" name="target_audience" required>
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
                
                <!-- PRICE (READ-ONLY) -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Ticket Price</label>
                    <div class="input-group input-group-readonly">
                        <span class="font-semibold text-gray-600" id="edit-price-display"></span>
                    </div>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="w-full py-3 text-white font-semibold rounded-lg shadow-lg bg-red-600 hover:bg-red-700 transition">
                    <span id="edit-submit-text">Update Event</span>
                </button>
            </form>
        </div>
    </div>

    <!-- Read-Only Details Modal Structure (Hidden by default) -->
    <div id="details-modal-overlay" class="fixed inset-0 bg-black bg-opacity-50 z-[98] flex items-center justify-center p-4 hidden">
        <div class="modal-content-wrapper w-full max-w-sm">
            <div class="p-5 border-b flex justify-between items-center sticky top-0 bg-white rounded-t-xl">
                <h3 class="text-2xl font-extrabold text-gray-800">Event Details</h3>
                <button onclick="closeDetailsModal()" class="text-gray-500 hover:text-gray-800 transition">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>
            
            <div class="p-5 space-y-4">
                <div class="text-center mb-4">
                    <img id="detail-photo" src="" alt="Event Photo" class="w-24 h-24 object-cover rounded-full mx-auto mb-2 border-2 border-blue-400">
                    <h4 class="text-xl font-extrabold text-gray-900" id="detail-name"></h4>
                    <p class="text-sm text-gray-600" id="detail-type"></p>
                </div>

                <div class="space-y-3 p-3 bg-gray-50 rounded-lg">
                    <div class="detail-item">
                        <span class="detail-label">Date & Time</span>
                        <span class="detail-value" id="detail-datetime"></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Duration</span>
                        <span class="detail-value" id="detail-duration"></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Tickets / Price</span>
                        <span class="detail-value" id="detail-tickets-price"></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Location (Venue)</span>
                        <a id="detail-location" href="#" target="_blank" class="detail-value text-blue-600 hover:underline"></a>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Audience</span>
                        <span class="detail-value" id="detail-audience"></span>
                    </div>
                </div>

                <!-- Description -->
                 <div class="pt-4">
                    <h5 class="font-bold text-gray-700 mb-2">Description</h5>
                    <p class="text-gray-600 text-sm" id="detail-description"></p>
                </div>
            </div>
        </div>
    </div>


    <script>
        // --- MOCK DATA ---
        let events = [
            { 
                id: 'e1', name: 'Regional Championship', 
                date: '2025-11-10', time: '09:00', duration: '3 hours', 
                price: 45.00, tickets: 25, 
                location_name: 'Central Pool (NYC)', location_url: 'https://maps.google.com/event1',
                age_range: '12-18', target_audience: 'swimmers',
                type: 'championship', 
                description: 'Premier swimming event featuring top athletes from multiple regions. All ages welcome to watch.', 
                video_url: 'https://vimeo.com/event1', 
                photo_url: 'https://placehold.co/100x100/1D4ED8/ffffff?text=E1' 
            },
            { 
                id: 'e2', name: 'Open Water Fun Swim', 
                date: '2025-11-15', time: '08:30', duration: '2 hours', 
                price: 0.00, tickets: 100, 
                location_name: 'Sea Coast (LA)', location_url: 'https://maps.google.com/event2',
                age_range: 'All Ages', target_audience: 'parents',
                type: 'fun-swim', 
                description: 'A social and non-competitive open water swimming event perfect for all levels. Wetsuits encouraged.', 
                video_url: null, 
                photo_url: 'https://placehold.co/100x100/EF4444/ffffff?text=E2' 
            }
        ];

        const editModalOverlay = document.getElementById('edit-modal-overlay');
        const detailsModalOverlay = document.getElementById('details-modal-overlay');
        const eventListContainer = document.getElementById('event-list');
        const editForm = document.getElementById('edit-event-form');

        // --- Utility Functions ---

        function formatTime24hrTo12hr(time24hr) {
            const [hr24, min] = time24hr.split(':');
            let hr = parseInt(hr24);
            const ampm = hr >= 12 ? 'PM' : 'AM';
            hr = hr % 12 || 12;
            return `${String(hr).padStart(2, '0')}:${min} ${ampm}`;
        }
        
        function showSnackbar(message, isError = false) {
            const snackbar = document.createElement('div');
            snackbar.textContent = message;
            snackbar.className = `fixed top-4 left-1/2 -translate-x-1/2 px-6 py-3 rounded-lg shadow-lg text-white ${isError ? 'bg-red-500' : 'bg-green-500'} z-[60]`;
            document.body.appendChild(snackbar);
            setTimeout(() => {
                snackbar.remove();
            }, 3000);
        }

        // --- UI Rendering ---

        function renderEventList() {
            if (events.length === 0) {
                 eventListContainer.innerHTML = '<p class="text-gray-500 text-center mt-8">No events have been created yet.</p>';
                 return;
            }
            
            eventListContainer.innerHTML = events.map(event => `
                <div class="event-card p-4 card-shadow flex items-center justify-between space-x-4">
                    
                    <!-- Clickable Area for Details Modal -->
                    <div class="flex items-center space-x-4 flex-grow cursor-pointer" onclick="openDetailsModal('${event.id}')">
                         <!-- Event Photo -->
                        <img src="${event.photo_url}" 
                             alt="${event.name} Cover" 
                             class="w-16 h-16 object-cover rounded-lg flex-shrink-0 border-2 border-gray-200">
                        
                        <!-- Event Info -->
                        <div class="flex-grow">
                            <h3 class="text-lg font-extrabold text-gray-900">${event.name}</h3>
                            <p class="text-xs text-gray-500 mt-0">${event.type.toUpperCase()} | ${event.location_name}</p>
                            <p class="text-sm font-semibold text-teal-600 mt-1">$${event.price.toFixed(2)}</p>
                            <p class="text-xs text-gray-500">Date: ${event.date} @ ${formatTime24hrTo12hr(event.time)}</p>
                        </div>
                    </div>

                    <!-- Edit Button (Pen Icon) -->
                    <button onclick="openEditModal('${event.id}')" 
                            class="p-2 text-blue-600 hover:bg-blue-100 rounded-full transition flex-shrink-0" title="Edit Event">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.536L15.232 5.232z"></path>
                        </svg>
                    </button>
                </div>
            `).join('');
        }

        // --- Read-Only Details Modal Logic ---

        function openDetailsModal(eventId) {
            const event = events.find(e => e.id === eventId);
            if (!event) return showSnackbar('Event data not found.', true);

            // Populate Modal
            document.getElementById('detail-photo').src = event.photo_url;
            document.getElementById('detail-name').textContent = event.name;
            document.getElementById('detail-type').textContent = event.type.toUpperCase();
            
            document.getElementById('detail-datetime').textContent = `${event.date} @ ${formatTime24hrTo12hr(event.time)}`;
            document.getElementById('detail-duration').textContent = event.duration;
            document.getElementById('detail-tickets-price').textContent = `${event.tickets} Tickets | $${event.price.toFixed(2)}`;
            
            document.getElementById('detail-location').textContent = event.location_name;
            document.getElementById('detail-location').href = event.location_url;
            document.getElementById('detail-audience').textContent = `${event.age_range} (${event.target_audience})`;
            
            document.getElementById('detail-description').textContent = event.description;

            detailsModalOverlay.classList.remove('hidden');
        }

        function closeDetailsModal() {
            detailsModalOverlay.classList.add('hidden');
        }


        // --- Edit Modal Logic ---

        function openEditModal(eventId) {
            const event = events.find(e => e.id === eventId);
            if (!event) return showSnackbar('Event data not found.', true);

            // Populate Edit Modal
            document.getElementById('event-edit-title').textContent = event.name;
            document.getElementById('edit-event-id').value = event.id;
            
            // --- NON-EDITABLE FIELD ---
            document.getElementById('edit-name-display').textContent = event.name;
            // Removed (Read-Only) label here
            document.getElementById('edit-price-display').textContent = `$${event.price.toFixed(2)}`;
            
            // --- EDITABLE FIELDS ---
            document.getElementById('edit-date').value = event.date;
            document.getElementById('edit-time').value = event.time;
            
            // Duration Split
            const [durationValue, durationUnit] = event.duration.split(' ');
            document.getElementById('edit-duration-value').value = parseInt(durationValue);
            document.getElementById('edit-duration-unit').value = durationUnit.toLowerCase();

            document.getElementById('edit-tickets-available').value = event.tickets;
            document.getElementById('edit-location-name').value = event.location_name;
            document.getElementById('edit-location-url').value = event.location_url;
            document.getElementById('edit-age-range').value = event.age_range;
            document.getElementById('edit-target-audience').value = event.target_audience;
            
            document.getElementById('edit-type').value = event.type;
            document.getElementById('edit-description').value = event.description;
            document.getElementById('edit-video-url').value = event.video_url || '';

            editModalOverlay.classList.remove('hidden');
        }

        function closeEditModal() {
            editModalOverlay.classList.add('hidden');
            editForm.reset();
        }

        // --- Event Handlers (Update/Edit) ---
        
        editForm.addEventListener('submit', function(event) {
            event.preventDefault();
            
            const form = event.target;
            const eventId = form.elements['edit-event-id'].value;
            const eventIndex = events.findIndex(e => e.id === eventId);

            if (eventIndex === -1) {
                showSnackbar('Error: Event ID mismatch.', true);
                return;
            }
            
            // Validation: Date cannot be in the past
            const eventDate = new Date(form.elements.date.value);
            const today = new Date();
            today.setHours(0,0,0,0);

            if (eventDate < today) {
                showSnackbar("Error: Event date cannot be in the past.", true);
                return;
            }
            
            // Update the event data (Note: Price is read-only)
            events[eventIndex].date = form.elements.date.value;
            events[eventIndex].time = form.elements.time.value;
            events[eventIndex].duration = `${form.elements.duration_value.value} ${form.elements.duration_unit.value}`;
            events[eventIndex].tickets = parseInt(form.elements.tickets.value);
            events[eventIndex].location_name = form.elements.location_name.value;
            events[eventIndex].location_url = form.elements.location_url.value;
            events[eventIndex].age_range = form.elements.age_range.value;
            events[eventIndex].target_audience = form.elements.target_audience.value;
            events[eventIndex].type = form.elements.type.value;
            events[eventIndex].description = form.elements.description.value;
            events[eventIndex].video_url = form.elements.video_url.value;
            
            showSnackbar(`Changes saved for: ${events[eventIndex].name}`, false);
            
            // Re-render the list and close modal
            renderEventList();
            closeEditModal();
        });

        // --- Initialization ---

        window.onload = () => {
            renderEventList();
            document.getElementById('close-edit-modal-btn').onclick = closeEditModal;
            detailsModalOverlay.onclick = (e) => {
                if (e.target.id === 'details-modal-overlay') {
                    closeDetailsModal();
                }
            };
            
            // Set min date for the edit modal date picker
            const today = new Date().toISOString().split('T')[0];
            const editDateInput = document.getElementById('edit-date');
            if (editDateInput) editDateInput.min = today;
        };
    </script>
</body>
</html>
