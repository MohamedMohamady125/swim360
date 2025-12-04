<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Event Attendees</title>
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
        .attendee-card {
            background-color: white;
            border-radius: 10px; /* Slightly smaller radius */
            transition: transform 0.1s, box-shadow 0.1s;
        }
        .attendee-card:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.06);
        }
        .modal-body-content {
            padding: 1.5rem;
            max-height: 80vh;
            overflow-y: auto;
        }
        .detail-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #F3F4F6;
        }
        .detail-label {
            font-weight: 500;
            color: #4B5563;
        }
        .detail-value {
            font-weight: 600;
            color: #1F2937;
        }
        .whatsapp-link {
            color: #38A169; /* Green link for communication */
            text-decoration: underline;
        }
        /* Search input styling refinement */
        #attendee-search {
            background-color: white;
            padding-left: 3rem;
        }
        /* Event Group Header (Group Separator) */
        .event-header {
            font-size: 1rem;
            font-weight: 700;
            color: #1F2937;
            padding: 10px 0;
            margin-top: 1.5rem;
            margin-bottom: 0.5rem;
            border-bottom: 1px solid #D1D5DB; 
        }
        /* Centered modal styling */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 50;
        }
    </style>
</head>
<body class="p-4 md:p-8">

    <div class="max-w-xl mx-auto">
        <h1 class="text-3xl font-extrabold text-gray-800 mb-2">My Attendees</h1>
        <p class="text-gray-500 mb-6">Manage the roster of users who have registered for your events.</p>

        <!-- Event Selection Dropdown -->
        <div class="mb-6">
            <label for="event-select" class="block text-sm font-medium text-gray-700 mb-1">Select Event Roster</label>
            <select id="event-select" 
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg card-shadow focus:ring-blue-500 focus:border-blue-500 transition duration-150"
                    onchange="initializeView()">
                <!-- Options populated by JS -->
            </select>
        </div>

        <!-- Search Bar -->
        <div class="mb-6 relative">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                 <!-- Search Icon -->
                <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
            </div>
            <input 
                type="text" 
                id="attendee-search" 
                placeholder="Search attendee name..."
                class="w-full px-4 py-3 border border-gray-300 rounded-lg card-shadow focus:ring-blue-500 focus:border-blue-500 transition duration-150"
                oninput="filterAttendees(this.value)">
        </div>

        <div id="attendee-list" class="space-y-2">
            <!-- Attendee Cards will be injected here -->
        </div>

        <div id="no-attendees" class="text-center text-gray-500 mt-12 hidden">
             No attendees registered for the selected event.
        </div>
    </div>

    <!-- Attendee Details Modal Structure (Hidden by default) -->
    <div id="details-modal-overlay" class="modal-overlay hidden">
        <div id="details-modal-content" class="bg-white rounded-xl shadow-2xl w-full max-w-sm mx-4">
            
            <div class="p-5 border-b flex justify-between items-center sticky top-0 bg-white rounded-t-xl">
                <h3 class="text-2xl font-extrabold text-gray-800">Attendee Details</h3>
                <button id="close-modal-btn" onclick="closeDetailsModal()" class="text-gray-500 hover:text-gray-800 transition">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>

            <div class="p-5 space-y-4">
                <p class="text-sm text-gray-500" id="detail-event-name-display"></p>
                
                <div class="space-y-3 p-3 bg-gray-50 rounded-lg">
                    <div class="flex justify-between">
                        <span class="font-medium text-gray-700">Name:</span>
                        <span class="font-extrabold text-gray-900" id="detail-full-name"></span>
                    </div>
                    <div class="flex justify-between">
                        <span class="font-medium text-gray-700">Age:</span>
                        <span class="font-extrabold text-gray-900" id="detail-age"></span>
                    </div>
                    <div class="flex justify-between">
                        <span class="font-medium text-gray-700">Phone:</span>
                        <a href="#" id="detail-contact-link" target="_blank" class="font-semibold whatsapp-link hover:underline">
                            <span id="detail-contact"></span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // --- MOCK DATA ---
        const MOCK_DATA = {
            events: [
                { id: 'e1', name: 'Regional Championship (Nov 10)', date: '2025-11-10' },
                { id: 'e2', name: 'Masters Training Clinic (Dec 1)', date: '2025-12-01' },
            ],
            // Attendees are mapped by event ID
            attendees: {
                'e1': [
                    { id: 'a1', name: 'Liam Davies', age: 15, phone: '5551111' },
                    { id: 'a2', name: 'Olivia Martinez', age: 40, phone: '5552222' },
                    { id: 'a3', name: 'Ethan Wilson', age: 28, phone: '5553333' },
                ],
                'e2': [
                    { id: 'a4', name: 'Ava Brown', age: 32, phone: '5554444' },
                    { id: 'a5', name: 'Noah Taylor', age: 55, phone: '5555555' },
                ]
            }
        };

        // --- GLOBAL STATE ---
        let selectedEventId = 'e1'; 
        const detailsModalOverlay = document.getElementById('details-modal-overlay');
        const attendeeListContainer = document.getElementById('attendee-list');
        const noAttendeesMessage = document.getElementById('no-attendees');

        // --- UTILITY FUNCTIONS ---

        function formatPhoneNumber(phone) {
            return phone.replace(/[^\d+]/g, '');
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
        
        // --- VIEW INITIALIZATION ---

        function initializeSelects() {
            const eventSelect = document.getElementById('event-select');
            eventSelect.innerHTML = '';
            
            MOCK_DATA.events.forEach(event => {
                const option = document.createElement('option');
                option.value = event.id;
                option.textContent = event.name;
                if (event.id === selectedEventId) {
                    option.selected = true;
                }
                eventSelect.appendChild(option);
            });
        }

        function initializeView() {
            selectedEventId = document.getElementById('event-select').value;
            renderAttendeesList();
        }
        
        // --- LIST RENDERING ---

        function renderAttendeesList(searchTerm = '') {
            const currentRoster = MOCK_DATA.attendees[selectedEventId] || [];
            const query = searchTerm.toLowerCase().trim();
            
            const filteredAttendees = currentRoster.filter(attendee => 
                attendee.name.toLowerCase().includes(query)
            );

            if (filteredAttendees.length === 0 && query === '') {
                 attendeeListContainer.innerHTML = '';
                 noAttendeesMessage.classList.remove('hidden');
                 return;
            } else if (filteredAttendees.length === 0) {
                 attendeeListContainer.innerHTML = '<p class="text-gray-500 text-center mt-8">No attendees match your search.</p>';
                 noAttendeesMessage.classList.add('hidden');
                 return;
            }
            
            noAttendeesMessage.classList.add('hidden');

            let listHTML = filteredAttendees.map(attendee => `
                <div class="attendee-card p-3 flex items-center justify-between space-x-4">
                    
                    <!-- Client Info -->
                    <div class="flex-grow flex items-center space-x-3">
                        <img src="https://placehold.co/40x40/5D5FEF/ffffff?text=${attendee.name.charAt(0).toUpperCase()}" 
                             alt="${attendee.name} Photo" 
                             class="w-10 h-10 rounded-full object-cover flex-shrink-0 border-2 border-purple-400">
                        
                        <div>
                            <h3 class="text-sm font-extrabold text-gray-900">${attendee.name}</h3>
                            <p class="text-xs text-gray-500 mt-0">Attendee</p>
                        </div>
                    </div>

                    <!-- View Details Button (Eye Icon) -->
                    <button onclick="openClientDetailsModal('${selectedEventId}', '${attendee.id}')" 
                            class="p-2 text-blue-600 hover:bg-blue-100 rounded-full transition flex-shrink-0" title="View Details">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
                    </button>
                </div>
            `).join('');
            
            attendeeListContainer.innerHTML = listHTML;
        }

        // --- ATTENDEE DETAILS MODAL ---

        function openClientDetailsModal(eventId, attendeeId) {
            const eventData = MOCK_DATA.events.find(e => e.id === eventId);
            const attendee = MOCK_DATA.attendees[eventId].find(a => a.id === attendeeId);

            if (!attendee || !eventData) return showSnackbar('Attendee data not found.', true);

            // Populate Modal
            document.getElementById('detail-event-name-display').textContent = eventData.name;
            document.getElementById('detail-full-name').textContent = attendee.name;
            document.getElementById('detail-age').textContent = attendee.age || 'N/A';
            
            // Set WhatsApp Link and Contact Number
            const cleanPhone = formatPhoneNumber(attendee.phone);
            document.getElementById('detail-contact').textContent = attendee.phone;
            document.getElementById('detail-contact-link').href = `https://wa.me/${cleanPhone}`;

            detailsModalOverlay.classList.remove('hidden');
        }
        
        function closeDetailsModal() {
            detailsModalOverlay.classList.add('hidden');
        }

        function filterAttendees(searchTerm) {
            renderAttendeesList(searchTerm);
        }

        // --- Initialization ---

        window.onload = () => {
            initializeSelects();
            initializeView();
            
            document.getElementById('close-modal-btn').onclick = closeDetailsModal;
            detailsModalOverlay.onclick = (e) => {
                if (e.target.id === 'details-modal-overlay') {
                    closeDetailsModal();
                }
            };
        };
    </script>
</body>
</html>