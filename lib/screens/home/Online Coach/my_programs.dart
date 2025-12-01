<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Programs List</title>
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
        .card-shadow {
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.05);
        }
        .program-card {
            background-color: white;
            border-radius: 12px;
            transition: transform 0.2s;
        }
        .program-card:hover {
            transform: translateY(-2px);
        }
        /* Style for Edit Modal (reusing input-group styles from previous request) */
        .input-group {
            display: flex;
            align-items: center;
            border: 1px solid #E5E7EB; /* Light grey border */
            border-radius: 8px;
            padding: 0 12px;
            background-color: #FAFAFA;
        }
        .input-group:focus-within {
            border-color: #3B82F6;
            box-shadow: 0 0 0 1px #3B82F6;
            background-color: white;
        }
        .input-group input, .input-group textarea, .input-group select {
            border: none;
            outline: none;
            padding: 12px 0;
            flex-grow: 1;
            background-color: transparent;
        }
        .file-upload-box {
            position: relative;
            border: 2px dashed #D1D5DB;
            background-color: #F9FAFB;
        }
        .file-upload-box:hover {
            border-color: #60A5FA;
        }
    </style>
</head>
<body class="p-4 md:p-8">

    <div class="max-w-xl mx-auto">
        <h1 class="text-3xl font-extrabold text-gray-800 mb-2">My Programs</h1>
        <p class="text-gray-500 mb-6">Manage your live and self-paced coaching programs.</p>

        <div id="program-list" class="space-y-4">
            <!-- Program Cards will be injected here -->
        </div>
    </div>

    <!-- Edit Modal Structure (Hidden by default) -->
    <div id="edit-modal-overlay" class="fixed inset-0 bg-black bg-opacity-50 z-[99] flex items-center justify-center p-4 hidden">
        <div id="edit-modal-content" class="bg-white rounded-xl card-shadow w-full max-w-lg max-h-[90vh] overflow-y-auto">
            
            <div class="p-5 border-b flex justify-between items-center sticky top-0 bg-white rounded-t-xl">
                <h3 class="text-2xl font-extrabold text-gray-800">Edit Program: <span id="modal-program-title" class="text-blue-600"></span></h3>
                <button id="close-modal-btn" class="text-gray-500 hover:text-gray-800 transition">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>

            <form id="edit-program-form" class="p-5 space-y-6">
                
                <input type="hidden" id="edit-program-id">

                <!-- Editable Fields Card -->
                <div class="space-y-6">
                    <!-- Detailed Description -->
                    <div>
                        <label for="edit-description" class="block text-sm font-medium text-gray-700 mb-1">Detailed Description</label>
                        <textarea id="edit-description" name="description" rows="4" required
                                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500 transition duration-150"
                                  placeholder="Outline the goals, weekly workload, and target audience."></textarea>
                    </div>

                    <!-- Intro Video URL (Optional) -->
                    <div>
                        <label for="edit-intro-video-url" class="block text-sm font-medium text-gray-700 mb-1">Intro Video URL (Optional)</label>
                        <div class="input-group">
                            <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z"></path></svg>
                            <input type="url" id="edit-intro-video-url" name="intro_video_url"
                                   placeholder="e.g., https://youtube.com/watch?v=...">
                        </div>
                    </div>

                    <!-- End Date (Optional) -->
                    <div>
                        <label for="edit-program-end-date" class="block text-sm font-medium text-gray-700 mb-1">Program End Date (Optional)</label>
                         <div class="input-group">
                            <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            <input type="date" id="edit-program-end-date" name="end_date">
                        </div>
                    </div>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="w-full py-3 text-white font-semibold rounded-lg shadow-lg btn-submit">
                    <span id="edit-submit-text">Save Changes</span>
                </button>
            </form>
        </div>
    </div>

    <script>
        // --- MOCK PROGRAM DATA ---
        let programs = [
            { id: 'prog1', title: '12-Week Stroke Mastery', price: 199.99, duration_value: 12, duration_unit: 'weeks', end_date: '2024-12-31', video_url: 'https://youtube.com/mastery', photo_url: 'https://placehold.co/400x160/2563eb/ffffff?text=STROKE+MASTERY', description: 'Comprehensive training plan focused on maximizing efficiency across all four strokes.' },
            { id: 'prog2', title: 'Nutrition for Triathletes', price: 49.00, duration_value: 8, duration_unit: 'sessions', end_date: null, video_url: 'https://vimeo.com/tri-nutri', photo_url: 'https://placehold.co/400x160/10b981/ffffff?text=NUTRITION+PLAN', description: 'Learn how to fuel your body correctly for endurance events with weekly video modules.' },
            { id: 'prog3', title: 'Beginner Open Water Prep', price: 99.50, duration_value: 4, duration_unit: 'weeks', end_date: '2024-10-15', video_url: null, photo_url: 'https://placehold.co/400x160/f97316/ffffff?text=OPEN+WATER+PREP', description: 'A four-week guide to transitioning from pool swimming to open water confidence.' },
        ];
        
        let appContainer, cartCountDisplay, backdrop;
        const programListContainer = document.getElementById('program-list');
        const modalOverlay = document.getElementById('edit-modal-overlay');
        const modalTitle = document.getElementById('modal-program-title');
        const editForm = document.getElementById('edit-program-form');


        // --- Core Functions (Simplified for this screen demo) ---

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

        function renderProgramList() {
            programListContainer.innerHTML = programs.map(program => `
                <div class="program-card p-4 card-shadow flex items-center space-x-4 cursor-pointer">
                    <!-- Program Photo -->
                    <img src="${program.photo_url}" alt="${program.title} Cover" 
                         class="w-20 h-20 object-cover rounded-lg flex-shrink-0">
                    
                    <!-- Program Details -->
                    <div class="flex-grow">
                        <h3 class="text-lg font-extrabold text-gray-900">${program.title}</h3>
                        <p class="text-sm font-semibold text-teal-600">$${program.price.toFixed(2)}</p>
                        <p class="text-xs text-gray-500 mt-1">
                            Duration: ${program.duration_value} ${program.duration_unit} 
                            ${program.end_date ? `| Ends: ${program.end_date}` : ''}
                        </p>
                    </div>

                    <!-- Edit Button -->
                    <button onclick="openEditModal('${program.id}')" 
                            class="p-2 text-blue-600 hover:bg-blue-100 rounded-full transition flex-shrink-0" title="Edit Program">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.536L15.232 5.232z"></path></svg>
                    </button>
                </div>
            `).join('');
        }

        function openEditModal(programId) {
            const program = programs.find(p => p.id === programId);
            if (!program) return showSnackbar('Program not found.', true);

            // Populate the modal fields
            modalTitle.textContent = program.title;
            document.getElementById('edit-program-id').value = program.id;
            document.getElementById('edit-description').value = program.description;
            document.getElementById('edit-intro-video-url').value = program.video_url || '';
            document.getElementById('edit-program-end-date').value = program.end_date || '';

            // Show modal
            modalOverlay.classList.remove('hidden');
        }

        function closeEditModal() {
            modalOverlay.classList.add('hidden');
            editForm.reset();
        }

        // --- Event Handlers ---

        editForm.addEventListener('submit', function(event) {
            event.preventDefault();
            
            const programId = document.getElementById('edit-program-id').value;
            const programIndex = programs.findIndex(p => p.id === programId);

            if (programIndex === -1) {
                showSnackbar('Error: Program ID mismatch.', true);
                return;
            }
            
            const form = event.target;
            const endDateValue = form.elements.end_date.value || null;

            // Date Validation (End Date must be greater than today)
            if (endDateValue) {
                const today = new Date();
                today.setHours(0,0,0,0);
                const endDate = new Date(endDateValue);

                if (endDate < today) {
                    showSnackbar("Error: End Date cannot be in the past.", true);
                    return;
                }
            }

            // Update the program data
            programs[programIndex].description = form.elements.description.value;
            programs[programIndex].video_url = form.elements.intro_video_url.value;
            programs[programIndex].end_date = endDateValue;
            
            showSnackbar(`Changes saved for: ${programs[programIndex].title}`, false);
            
            // Re-render the list and close modal
            renderProgramList();
            closeEditModal();
        });

        // --- Initialization ---

        window.onload = () => {
            appContainer = document.getElementById('app-container');
            // This line ensures we find the badge element which prevents the null error
            const cartFab = document.getElementById('cart-fab');
            cartCountDisplay = cartFab ? cartFab.querySelector('.cart-badge') : { textContent: '0' };
            backdrop = document.getElementById('modal-backdrop');
            if (cartFab) cartFab.onclick = showCartModal;
            
            document.getElementById('close-modal-btn').onclick = closeEditModal;
            
            // Initial render of the program list
            renderProgramList();
        };
    </script>
</body>
</html>