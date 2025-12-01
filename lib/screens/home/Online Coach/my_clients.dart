<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Clients List</title>
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
            /* Reduced shadow complexity */
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
        }
        .client-card {
            background-color: white;
            border-radius: 10px; /* Slightly smaller radius */
            transition: transform 0.1s, box-shadow 0.1s;
        }
        .client-card:hover {
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
            padding: 12px 0;
            border-bottom: 1px solid #F3F4F6;
        }
        .detail-label {
            font-weight: 500;
            color: #4B5563;
        }
        /* Styling for the clickable phone number */
        .detail-value {
            font-weight: 600;
            color: #1F2937;
            text-decoration: none;
        }
        .detail-value.whatsapp-link {
            color: #2563EB; /* Blue for visibility */
            cursor: pointer;
            text-decoration: underline;
            text-underline-offset: 3px;
        }
        /* Program Header (Group Separator) */
        .program-header {
            font-size: 1rem;
            font-weight: 700;
            color: #1F2937;
            padding: 10px 0;
            margin-top: 1.5rem;
            margin-bottom: 0.5rem;
            /* Use a lighter color for the separator line */
            border-bottom: 1px solid #D1D5DB; 
        }
        /* Search input styling refinement */
        #client-search {
            background-color: white;
            padding-left: 3rem;
        }
    </style>
</head>
<body class="p-4 md:p-8">

    <div class="max-w-xl mx-auto">
        <h1 class="text-3xl font-extrabold text-gray-800 mb-2">My Clients</h1>
        <p class="text-gray-500 mb-6">View and manage the details of clients currently enrolled in your programs.</p>

        <!-- Search Bar -->
        <div class="mb-6 relative">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                 <!-- Search Icon -->
                <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
            </div>
            <input 
                type="text" 
                id="client-search" 
                placeholder="Search clients or programs..."
                class="w-full px-4 py-3 border border-gray-300 rounded-lg card-shadow focus:ring-blue-500 focus:border-blue-500 transition duration-150"
                oninput="filterClients(this.value)">
        </div>

        <div id="client-list" class="space-y-2">
            <!-- Client Cards and Program Groups will be injected here -->
        </div>
    </div>

    <!-- Client Details Modal Structure (Hidden by default) -->
    <div id="details-modal-overlay" class="fixed inset-0 bg-black bg-opacity-50 z-[99] flex items-center justify-center p-4 hidden">
        <div id="details-modal-content" class="bg-white rounded-xl card-shadow w-full max-w-sm">
            
            <div class="p-5 border-b flex justify-between items-center sticky top-0 bg-white rounded-t-xl">
                <h3 class="text-2xl font-extrabold text-gray-800">Client Details</h3>
                <button id="close-modal-btn" class="text-gray-500 hover:text-gray-800 transition">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>

            <div class="modal-body-content">
                <div class="text-center mb-6">
                    <img id="client-photo" src="https://placehold.co/80x80/06B6D4/ffffff?text=C" class="w-20 h-20 rounded-full mx-auto mb-2 object-cover border-2 border-blue-400">
                    <p class="text-xl font-extrabold text-gray-900" id="detail-full-name"></p>
                    <p class="text-sm text-gray-500" id="detail-current-program"></p>
                </div>

                <div class="space-y-2">
                    <div class="detail-item">
                        <span class="detail-label">Phone Number</span>
                        <!-- WhatsApp Link Implementation -->
                        <a id="detail-phone-link" href="#" target="_blank" class="detail-value whatsapp-link">
                            <span id="detail-phone">N/A</span>
                        </a>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Age</span>
                        <span class="detail-value" id="detail-age">N/A</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Gender</span>
                        <span class="detail-value" id="detail-gender">N/A</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Program End Date</span>
                        <span class="detail-value" id="detail-end-date">N/A</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // --- MOCK CLIENT DATA ---
        let clients = [
            { id: 'c1', name: 'Alex Johnson', program: '12-Week Stroke Mastery', end_date: '2024-12-31', phone: '555-1234', age: 28, gender: 'Male', photo_initial: 'A' },
            { id: 'c2', name: 'Sarah Chen', program: 'Nutrition for Triathletes', end_date: '2025-01-20', phone: '555-5678', age: 35, gender: 'Female', photo_initial: 'S' },
            { id: 'c3', name: 'Mike Rodriguez', program: 'Beginner Open Water Prep', end_date: '2024-10-15', phone: '555-9012', age: 19, gender: 'Male', photo_initial: 'M' },
            { id: 'c4', name: 'Laura Smith', program: '12-Week Stroke Mastery', end_date: '2025-03-15', phone: '555-3456', age: 41, gender: 'Female', photo_initial: 'L' },
            { id: 'c5', name: 'David Lee', program: 'Nutrition for Triathletes', end_date: '2024-11-01', phone: '555-7777', age: 30, gender: 'Male', photo_initial: 'D' },
            { id: 'c6', name: 'Emily White', program: '12-Week Stroke Mastery', end_date: '2024-11-15', phone: '555-8888', age: 22, gender: 'Female', photo_initial: 'E' },
        ];
        
        const modalOverlay = document.getElementById('details-modal-overlay');
        const closeModalBtn = document.getElementById('close-modal-btn');
        const clientListContainer = document.getElementById('client-list');

        /**
         * Cleans and formats a phone number for the WhatsApp API URL.
         * Removes non-digit characters and prepends country code if necessary (assuming US format for mock data).
         * @param {string} phone The raw phone number string.
         * @returns {string} The cleaned number, ready for wa.me.
         */
        function formatPhoneNumber(phone) {
            // Remove dashes, spaces, and parentheses
            let cleaned = phone.replace(/[^\d]/g, '');
            // Assuming international format with country code '1' (US) for the sake of the mock link
            if (cleaned.length === 10 && !cleaned.startsWith('1')) {
                cleaned = '1' + cleaned;
            }
            return cleaned;
        }


        // --- UI Rendering ---

        function renderClientList(filteredClients = clients) {
            
            // 1. Group clients by program name
            const clientsByProgram = filteredClients.reduce((acc, client) => {
                const programName = client.program;
                if (!acc[programName]) {
                    acc[programName] = [];
                }
                acc[programName].push(client);
                return acc;
            }, {});

            let html = '';
            
            // 2. Iterate through groups and render cards
            for (const programName in clientsByProgram) {
                let programClients = clientsByProgram[programName];

                // 3. Sort clients within the group by End Date (soonest first)
                programClients.sort((a, b) => {
                    const dateA = a.end_date ? new Date(a.end_date).getTime() : Infinity;
                    const dateB = b.end_date ? new Date(b.end_date).getTime() : Infinity;
                    return dateA - dateB;
                });

                // Render Program Header
                html += `<div class="program-header">${programName} (${programClients.length})</div>`;
                
                // Render Client Cards
                html += programClients.map(client => `
                    <div class="client-card p-2 card-shadow flex items-center justify-between space-x-4 mt-2">
                        
                        <!-- Client Info -->
                        <div class="flex-grow flex items-center space-x-3">
                            <img src="https://placehold.co/40x40/3B82F6/ffffff?text=${client.photo_initial}" 
                                 alt="${client.name} Photo" 
                                 class="w-10 h-10 rounded-full object-cover flex-shrink-0 border-2 border-blue-300">
                            
                            <div>
                                <h3 class="text-sm font-extrabold text-gray-900">${client.name}</h3>
                                <p class="text-xs text-gray-500 mt-0">
                                    Ends: <span class="font-semibold">${client.end_date || 'Ongoing'}</span>
                                </p>
                            </div>
                        </div>

                        <!-- View Details Button (Eye Icon) -->
                        <button onclick="openClientDetailsModal('${client.id}')" 
                                class="p-2 text-blue-600 hover:bg-blue-100 rounded-full transition flex-shrink-0" title="View Details">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
                        </button>
                    </div>
                `).join('');
            }
            
            clientListContainer.innerHTML = html;
        }

        function openClientDetailsModal(clientId) {
            const client = clients.find(c => c.id === clientId);
            if (!client) return showSnackbar('Client data not found.', true);

            // Populate Modal
            document.getElementById('detail-full-name').textContent = client.name;
            document.getElementById('detail-current-program').textContent = client.program;
            
            // Set WhatsApp Link
            const cleanPhone = formatPhoneNumber(client.phone);
            const whatsappUrl = `https://wa.me/${cleanPhone}`;
            
            document.getElementById('detail-phone').textContent = client.phone;
            document.getElementById('detail-phone-link').href = whatsappUrl;
            
            document.getElementById('detail-age').textContent = client.age;
            document.getElementById('detail-gender').textContent = client.gender;
            document.getElementById('detail-end-date').textContent = client.end_date || 'N/A';
            document.getElementById('client-photo').src = `https://placehold.co/80x80/3B82F6/ffffff?text=${client.photo_initial}`;

            // Show modal
            modalOverlay.classList.remove('hidden');
        }

        function closeClientDetailsModal() {
            modalOverlay.classList.add('hidden');
        }

        function filterClients(searchTerm) {
            const query = searchTerm.toLowerCase().trim();
            if (query === "") {
                renderClientList(clients);
                return;
            }

            const filtered = clients.filter(client => 
                client.name.toLowerCase().includes(query) ||
                client.program.toLowerCase().includes(query)
            );
            
            renderClientList(filtered);
        }
        
        function showSnackbar(message, isError = false) {
            const snackbar = document.createElement('div');
            snackbar.textContent = message;
            snackbar.className = `fixed bottom-6 left-1/2 -translate-x-1/2 px-6 py-3 rounded-lg shadow-lg text-white ${isError ? 'bg-red-500' : 'bg-green-500'} z-[60]`;
            document.body.appendChild(snackbar);
            setTimeout(() => {
                snackbar.remove();
            }, 3000);
        }

        // --- Initialization ---

        window.onload = () => {
            closeModalBtn.onclick = closeClientDetailsModal;
            modalOverlay.onclick = (e) => {
                if (e.target.id === 'details-modal-overlay') {
                    closeClientDetailsModal();
                }
            };
            
            // Initial render of the client list
            renderClientList();
        };
    </script>
</body>
</html>