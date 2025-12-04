<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Services List</title>
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
        .service-card {
            background-color: white;
            border-radius: 10px; /* Slightly smaller radius */
            transition: transform 0.1s, box-shadow 0.1s;
        }
        .service-card:hover {
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
        .detail-value {
            font-weight: 600;
            color: #1F2937;
        }
        /* Search input styling refinement */
        #service-search {
            background-color: white;
            padding-left: 3rem;
        }
        /* Style for the Add Service Banner */
        .add-service-banner {
            background-color: #10B981; /* Green color for positive action */
            color: white;
            border-radius: 12px;
            cursor: pointer;
            transition: background-color 0.2s, transform 0.2s;
        }
        .add-service-banner:hover {
            background-color: #059263;
            transform: translateY(-1px);
        }
        /* Style for inputs in modal */
        .input-group {
            display: flex;
            align-items: center;
            border: 1px solid #E5E7EB;
            border-radius: 8px;
            padding: 0 12px;
            background-color: #FAFAFA;
        }
        .input-group input, .input-group textarea, .input-group select {
            border: none;
            outline: none;
            padding: 12px 0;
            flex-grow: 1;
            background-color: transparent;
        }
        /* Style for Add Modal Content Area */
         #add-modal-content .input-group input[type="file"] {
            padding: 8px 0;
            font-size: 0.875rem; /* text-sm */
        }
        #add-modal-content .input-group select {
            padding: 8px 0;
            cursor: pointer;
        }
    </style>
</head>
<body class="p-4 md:p-8">

    <div class="max-w-xl mx-auto">
        <h1 class="text-3xl font-extrabold text-gray-800 mb-2">My Services</h1>
        <p class="text-gray-500 mb-6">Manage rehabilitation programs, assessments, and manual therapy options.</p>

        <!-- ADD SERVICE BANNER -->
        <div class="add-service-banner flex items-center justify-center p-3 mb-6 card-shadow" onclick="openAddModal()">
             <svg class="w-6 h-6 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" /></svg>
            <span class="text-lg font-extrabold">Add Service</span>
        </div>

        <!-- Search Bar -->
        <div class="mb-6 relative">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                 <!-- Search Icon -->
                <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
            </div>
            <input 
                type="text" 
                id="service-search" 
                placeholder="Search treatments or categories..."
                class="w-full px-4 py-3 border border-gray-300 rounded-lg card-shadow focus:ring-blue-500 focus:border-blue-500 transition duration-150"
                oninput="filterServices(this.value)">
        </div>

        <div id="service-list" class="space-y-2">
            <!-- Service Cards will be injected here -->
        </div>
    </div>

    <!-- Edit Modal Structure (Hidden by default) -->
    <div id="edit-modal-overlay" class="fixed inset-0 bg-black bg-opacity-50 z-[99] flex items-center justify-center p-4 hidden">
        <div id="edit-modal-content" class="bg-white rounded-xl card-shadow w-full max-w-md">
            
            <div class="p-5 border-b flex justify-between items-center sticky top-0 bg-white rounded-t-xl">
                <h3 class="text-2xl font-extrabold text-gray-800" id="modal-title">Edit Service</h3>
                <button id="close-modal-btn" onclick="closeEditModal()" class="text-gray-500 hover:text-gray-800 transition">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>

            <form id="edit-service-form" class="p-5 space-y-6">
                
                <input type="hidden" id="edit-service-id">

                <!-- Editable Fields -->
                <div class="space-y-6">
                    <!-- Title (Non-editable for context) -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Service Title</label>
                        <p class="text-lg font-semibold text-blue-600" id="edit-title"></p>
                    </div>

                    <!-- Detailed Description -->
                    <div>
                        <label for="edit-description" class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                        <textarea id="edit-description" name="description" rows="4" required
                                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500 transition duration-150"></textarea>
                    </div>

                    <!-- Intro Video URL (Optional) -->
                    <div>
                        <label for="edit-video-url" class="block text-sm font-medium text-gray-700 mb-1">Intro Video URL (Optional)</label>
                        <div class="input-group">
                             <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z"></path></svg>
                             <input type="url" id="edit-video-url" name="video_url"
                                   placeholder="e.g., https://youtube.com/embed">
                        </div>
                    </div>
                    
                    <!-- PRICE (Editable) -->
                    <div>
                        <label for="edit-price" class="block text-sm font-medium text-gray-700 mb-1">Price (USD)</label>
                        <div class="input-group">
                            <span class="text-gray-400 font-semibold mr-1">$</span>
                            <input type="number" id="edit-price" name="price" required min="1" step="0.01" placeholder="90.00">
                        </div>
                    </div>

                </div>

                <!-- Submit Button -->
                <button type="submit" class="w-full py-3 text-white font-semibold rounded-lg shadow-lg bg-blue-600 hover:bg-blue-700 transition">
                    <span id="edit-submit-text">Save Changes</span>
                </button>
            </form>
        </div>
    </div>
    
    <!-- Add Service Modal Structure (Inline Definition) -->
    <div id="add-modal-overlay" class="fixed inset-0 bg-black bg-opacity-50 z-[99] flex items-center justify-center p-4 hidden">
        <div id="add-modal-content" class="bg-white rounded-xl card-shadow w-full max-w-md max-h-[90vh] overflow-y-auto">
            
            <div class="p-5 border-b flex justify-between items-center sticky top-0 bg-white rounded-t-xl z-10">
                <h3 class="text-2xl font-extrabold text-gray-800">Add New Service</h3>
                <button id="close-add-modal-btn" onclick="closeAddModal()" class="text-gray-500 hover:text-gray-800 transition">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>

            <form id="add-service-form" class="p-5 space-y-4">
                <!-- Service Name -->
                <div>
                    <label for="add-title" class="block text-sm font-medium text-gray-700 mb-1">Service Name</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                        <input type="text" id="add-title" name="title" required placeholder="e.g., Spine Assessment">
                    </div>
                </div>

                <!-- Cover Photo (Simple Placeholder) -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Cover Photo</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                        <input type="file" id="add-photo" name="photo" accept="image/*" class="w-full">
                    </div>
                </div>

                <!-- Category Dropdown -->
                <div>
                    <label for="add-category" class="block text-sm font-medium text-gray-700 mb-1">Category</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37a1.724 1.724 0 002.572-1.065z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                        <select id="add-category" name="category" required>
                            <option value="" disabled selected>Select Category</option>
                            <option value="Rehabilitation">Rehabilitation</option>
                            <option value="Assessment">Assessment</option>
                            <option value="Recovery">Recovery</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                </div>

                <!-- Description -->
                <div>
                    <label for="add-description" class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                    <textarea id="add-description" name="description" rows="3" required
                              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500 transition duration-150"></textarea>
                </div>
                
                <!-- Price -->
                <div>
                    <label for="add-price" class="block text-sm font-medium text-gray-700 mb-1">Price (USD)</label>
                    <div class="input-group">
                        <span class="text-gray-400 font-semibold mr-1">$</span>
                        <input type="number" id="add-price" name="price" required min="1" step="0.01" placeholder="90.00">
                    </div>
                </div>

                <!-- Video URL (Optional) -->
                <div>
                    <label for="add-video-url" class="block text-sm font-medium text-gray-700 mb-1">Intro Video URL (Optional)</label>
                    <div class="input-group">
                         <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z"></path></svg>
                         <input type="url" id="add-video-url" name="video_url"
                               placeholder="e.g., https://youtube.com/embed">
                    </div>
                </div>
                
                <button type="submit" class="w-full py-3 text-white font-semibold rounded-lg shadow-lg bg-green-600 hover:bg-green-700 transition">
                    Create Service
                </button>
            </form>
        </div>
    </div>

    <script>
        // --- MOCK SERVICE DATA (Physiotherapy Clinic Services) ---
        let services = [
            { id: 's1', title: 'Initial Assessment & Diagnosis', category: 'Assessment', price: 95.00, duration: '60 min', photo_url: 'https://placehold.co/40x40/3B82F6/ffffff?text=A', description: 'Comprehensive physical and functional assessment.' },
            { id: 's2', title: 'Post-Injury Rehabilitation', category: 'Rehabilitation', price: 80.00, duration: '45 min', photo_url: 'https://placehold.co/40x40/10B981/ffffff?text=R', description: 'Focused sessions to restore strength and mobility after injury.' },
            { id: 's3', title: 'Manual Therapy & Adjustment', category: 'Manual Therapy', price: 120.00, duration: '60 min', photo_url: 'https://placehold.co/40x40/F97316/ffffff?text=M', description: 'Hands-on techniques for joint and soft tissue mobilization.' },
            { id: 's4', title: 'Hydrotherapy Session', category: 'Rehabilitation', price: 70.00, duration: '45 min', photo_url: 'https://placehold.co/40x40/EF4444/ffffff?text=H', description: 'Therapy conducted in water to reduce stress on joints.' },
            { id: 's5', title: 'Performance Assessment (Swim)', category: 'Assessment', price: 150.00, duration: '90 min', photo_url: 'https://placehold.co/40x40/06B6D4/ffffff?text=P', description: 'Advanced swim-specific movement analysis.' },
        ];
        
        const modalOverlay = document.getElementById('edit-modal-overlay');
        const addModalOverlay = document.getElementById('add-modal-overlay');
        const closeModalBtn = document.getElementById('close-modal-btn');
        const closeAddModalBtn = document.getElementById('close-add-modal-btn');
        const serviceListContainer = document.getElementById('service-list');
        const editForm = document.getElementById('edit-service-form');
        const addForm = document.getElementById('add-service-form');


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

        // --- UI Rendering ---

        function renderServiceList(filteredServices = services) {
            
            // List is rendered flat (not grouped by category) and sorted by title.
            const sortedServices = [...filteredServices].sort((a, b) => a.title.localeCompare(b.title));
            let html = '';
            
            if (sortedServices.length === 0) {
                 html = '<p class="text-gray-500 text-center mt-8">No services found matching your search criteria.</p>';
            } else {
                html += sortedServices.map(service => `
                    <div class="service-card p-3 card-shadow flex items-center justify-between space-x-4 mt-2">
                        
                        <!-- Service Info -->
                        <div class="flex-grow flex items-center space-x-3">
                            <img src="${service.photo_url}" 
                                 alt="${service.title} Cover" 
                                 class="w-10 h-10 rounded-lg object-cover flex-shrink-0 border-2 border-blue-300">
                            
                            <div>
                                <h3 class="text-sm font-extrabold text-gray-900">${service.title}</h3>
                                <p class="text-xs text-gray-500 mt-0">${service.category}</p>
                                <p class="text-xs text-teal-600 font-semibold mt-1">$${service.price.toFixed(2)}</p>
                            </div>
                        </div>

                        <!-- Edit Button (Pen Icon) -->
                        <button onclick="openEditModal('${service.id}')" 
                                class="p-2 text-blue-600 hover:bg-blue-100 rounded-full transition flex-shrink-0" title="Edit Service">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.536L15.232 5.232z"></path></svg>
                        </button>
                    </div>
                `).join('');
            }
            
            serviceListContainer.innerHTML = html;
        }

        // --- Modal Logic ---

        function openEditModal(serviceId) {
            const service = services.find(s => s.id === serviceId);
            if (!service) return showSnackbar('Service data not found.', true);

            document.getElementById('modal-title').textContent = `Edit Service: ${service.title}`;
            document.getElementById('edit-service-id').value = service.id;
            document.getElementById('edit-title').textContent = service.title;
            document.getElementById('edit-description').value = service.description;
            document.getElementById('edit-video-url').value = service.video_url || '';
            
            // Set PRICE (Editable)
            document.getElementById('edit-price').value = service.price.toFixed(2);

            // Show modal
            modalOverlay.classList.remove('hidden');
        }

        function closeEditModal() {
            modalOverlay.classList.add('hidden');
            editForm.reset();
        }
        
        function openAddModal() {
            addForm.reset(); // Clear any previous form data
            addModalOverlay.classList.remove('hidden');
        }

        function closeAddModal() {
            addModalOverlay.classList.add('hidden');
            document.getElementById('add-service-form').reset();
        }

        // --- Event Handlers ---

        function filterServices(searchTerm) {
            const query = searchTerm.toLowerCase().trim();
            if (query === "") {
                renderServiceList(services);
                return;
            }

            const filtered = services.filter(service => 
                service.title.toLowerCase().includes(query) ||
                service.category.toLowerCase().includes(query)
            );
            
            renderServiceList(filtered);
        }
        
        // --- Edit Form Submission ---
        document.getElementById('edit-service-form').addEventListener('submit', function(event) {
            event.preventDefault();
            
            const serviceId = document.getElementById('edit-service-id').value;
            const serviceIndex = services.findIndex(s => s.id === serviceId);

            if (serviceIndex === -1) {
                showSnackbar('Error: Service ID mismatch.', true);
                return;
            }
            
            // Update the service data (Description, Video URL, and Price are editable)
            services[serviceIndex].description = document.getElementById('edit-description').value;
            services[serviceIndex].video_url = document.getElementById('edit-video-url').value;
            services[serviceIndex].price = parseFloat(document.getElementById('edit-price').value);
            
            showSnackbar(`Changes saved for: ${services[serviceIndex].title}`, false);
            
            // Re-render the list and close modal
            renderServiceList();
            closeEditModal();
        });
        
        // --- Add Form Submission ---
        document.addEventListener('submit', function(event) {
            if (event.target.id !== 'add-service-form') return;

            event.preventDefault();
            
            const form = event.target;
            
            // Get mock photo URL based on the first letter of the title
            const titleInitial = form.elements.title.value.charAt(0).toUpperCase();

            const newService = {
                id: 's' + (services.length + 1), // Simple mock ID generation
                title: form.elements.title.value,
                category: form.elements.category.value,
                price: parseFloat(form.elements.price.value),
                duration: '60 min', // Default duration
                description: form.elements.description.value,
                photo_url: `https://placehold.co/40x40/3B82F6/ffffff?text=${titleInitial}`,
                video_url: form.elements.video_url.value || null
            };

            services.push(newService);
            
            showSnackbar(`New Service added: ${newService.title}`, false);
            
            // Re-render the list and close modal
            renderServiceList();
            closeAddModal();
        });


        // --- Initialization ---

        window.onload = () => {
            // Attach event listeners to modal buttons
            document.getElementById('close-modal-btn').onclick = closeEditModal;
            document.getElementById('close-add-modal-btn').onclick = closeAddModal;
            
            // Set up listener for closing the edit modal when clicking overlay (safety check)
            document.getElementById('edit-modal-overlay').onclick = (e) => {
                if (e.target.id === 'edit-modal-overlay') {
                    closeEditModal();
                }
            };
            // Set up listener for closing the add modal when clicking overlay
             document.getElementById('add-modal-overlay').onclick = (e) => {
                if (e.target.id === 'add-modal-overlay') {
                    closeAddModal();
                }
            };
            
            // Attach Add Service Banner listener
            document.querySelector('.add-service-banner').onclick = openAddModal;

            // Initial render of the service list
            renderServiceList();
        };
    </script>
</body>
</html>