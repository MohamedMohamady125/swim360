<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - Profile</title>
    <!-- Tailwind CSS CDN for a responsive and modern design -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Google Fonts for the 'Inter' font -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* Apply the Inter font globally */
        body {
            font-family: 'Inter', sans-serif;
        }

        /* Keyframes for a subtle fade-in and slide-up animation for individual elements */
        @keyframes fade-in-up {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Apply the staggered animation to elements */
        .animated-item {
            opacity: 0;
            animation: fade-in-up 0.6s ease-out forwards;
        }
        .animated-item:nth-child(1) { animation-delay: 0.2s; }
        .animated-item:nth-child(2) { animation-delay: 0.4s; }
        .animated-item:nth-child(3) { animation-delay: 0.6s; }
        .animated-item:nth-child(4) { animation-delay: 0.8s; }
        .animated-item:nth-child(5) { animation-delay: 1.0s; }
        .animated-item:nth-child(6) { animation-delay: 1.2s; }
        .animated-item:nth-child(7) { animation-delay: 1.4s; }
        .animated-item:nth-child(8) { animation-delay: 1.6s; }

        /* Custom styling for input and select fields */
        .form-field {
            @apply w-full px-4 py-3 border border-gray-300 rounded-lg text-gray-800 bg-white shadow-sm transition-shadow duration-200;
        }
        .form-field:focus {
            @apply outline-none ring-2 ring-blue-500 shadow-md;
        }

        /* Custom dropdown styling based on the new UI design */
        .custom-dropdown-container {
            position: relative;
        }
        .custom-dropdown-header {
            @apply w-full px-4 py-3 border border-gray-300 rounded-lg text-gray-800 bg-white cursor-pointer flex items-center justify-between transition-shadow duration-200;
        }
        .custom-dropdown-list {
            @apply absolute z-10 w-full mt-2 bg-white rounded-lg border-2 border-gray-200 shadow-lg overflow-hidden max-h-60 overflow-y-auto transform scale-y-0 origin-top transition-transform duration-200 ease-in-out;
        }
        .custom-dropdown-list.open {
            @apply scale-y-100;
        }
        .custom-dropdown-item {
            @apply flex items-center px-4 py-3 cursor-pointer text-gray-800 hover:bg-gray-100 transition-colors duration-150;
        }
        .custom-dropdown-item.selected {
            @apply bg-blue-100 font-semibold;
        }
        .custom-dropdown-item.disabled {
            @apply bg-gray-50 text-gray-400 cursor-not-allowed;
        }
        
        .role-message-box {
            @apply bg-red-100 border border-red-400 text-red-700 font-bold px-4 py-3 rounded relative mt-4 text-center;
        }
        /* New styling for the warning message box to match the design */
        .warning-message-box {
            @apply border border-gray-300 text-gray-700 px-4 py-3 rounded-lg relative mb-4 flex items-center space-x-2;
        }
        .warning-message-box svg {
            @apply text-gray-500;
        }
        .warning-message-box p {
            @apply text-sm;
        }
    </style>
</head>
<body class="bg-[#24a1f1] min-h-screen flex items-center justify-center p-4">

    <!-- Main Profile Container -->
    <div class="w-full max-w-lg bg-white rounded-3xl shadow-2xl p-8 md:p-10">
        
        <!-- Header Section -->
        <div class="flex items-center space-x-4 mb-8 animated-item">
            <!-- Profile Photo Container -->
            <div id="profile-photo-container" class="relative w-24 h-24 rounded-full overflow-hidden border-4 border-white shadow-lg cursor-pointer group">
                <img id="profile-photo" src="https://placehold.co/200x200/24a1f1/white?text=User" alt="Profile Picture" class="w-full h-full object-cover transition-transform duration-300 transform group-hover:scale-105">
                <!-- Overlay for upload button -->
                <button id="edit-photo-btn" class="absolute inset-0 flex items-center justify-center bg-black bg-opacity-40 text-white opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.894-1.787A2 2 0 0110.198 4h3.604a2 2 0 011.664.89l.894 1.787A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z"></path>
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z"></path>
                    </svg>
                </button>
                <!-- Small, always-visible pencil icon -->
                <div class="absolute bottom-1 right-1 bg-white p-1 rounded-full shadow-lg border border-gray-200 opacity-70 group-hover:opacity-100 transition-opacity duration-300">
                    <svg class="w-4 h-4 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 5.232z"></path>
                    </svg>
                </div>
            </div>
            <div>
                <h1 class="text-3xl font-extrabold text-gray-800">Hello, John!</h1>
                <p class="text-gray-500 font-medium mt-1">Ready to swim?</p>
            </div>
        </div>

        <!-- User Information Form -->
        <form>
            <!-- Name Field -->
            <div class="mb-5 animated-item">
                <label for="name" class="block text-gray-700 text-sm font-semibold mb-2">Full Name</label>
                <div class="relative">
                    <input 
                        type="text" 
                        id="name" 
                        name="name" 
                        value="John Doe" 
                        class="form-field pr-12" 
                        readonly>
                    <button type="button" id="edit-name-btn" class="absolute inset-y-0 right-0 pr-4 flex items-center text-gray-400 hover:text-gray-600 transition-colors duration-200 group">
                        <!-- Pen icon for editing -->
                        <svg id="pen-icon" class="w-5 h-5 transition-opacity duration-200" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 5.232z"></path>
                        </svg>
                        <!-- Checkmark icon for saving (initially hidden) -->
                        <svg id="check-icon" class="w-5 h-5 hidden transition-opacity duration-200" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                        </svg>
                        <span class="absolute top-full mt-2 -right-4 px-3 py-1 bg-gray-800 text-white text-xs rounded-md opacity-0 group-hover:opacity-100 transition-opacity duration-200 pointer-events-none">Edit Name</span>
                    </button>
                </div>
                <!-- Message to the user about name change restriction -->
                <p id="edit-message" class="mt-2 text-sm text-red-500 hidden"></p>
            </div>

            <!-- Email Field (Read-only) -->
            <div class="mb-5 animated-item">
                <label for="email" class="block text-gray-700 text-sm font-semibold mb-2">Email Address</label>
                <!-- Using a div styled like an input for non-editable content -->
                <div class="w-full px-4 py-3 border border-gray-300 rounded-lg bg-gray-50 text-gray-500 cursor-not-allowed shadow-inner">
                    john.doe@example.com
                </div>
            </div>

            <!-- Role Section -->
            <div class="mb-8 animated-item">
                <label for="role" class="block text-gray-700 text-sm font-semibold mb-2">Role</label>
                <!-- Warning Message Box (Visible before role is saved) -->
                <div id="role-warning" class="warning-message-box">
                    <svg class="w-6 h-6 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c2.032 0 3.328-2.288 2.37-4.144L14.37 5.856c-.958 1.856.338 4.144 2.37 4.144z"></path>
                    </svg>
                    <p class="text-sm">Please choose your role carefully. You cannot change it later.</p>
                </div>
                <!-- Custom dropdown container -->
                <div class="custom-dropdown-container">
                    <!-- The main dropdown header button -->
                    <div id="role-dropdown-header" class="custom-dropdown-header">
                        <div class="flex items-center space-x-2">
                            <span id="selected-role-text">Select a role</span>
                        </div>
                        <!-- Arrow icon for visual cue -->
                        <svg id="dropdown-arrow" class="w-4 h-4 text-gray-400 transform transition-transform duration-200" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                        </svg>
                    </div>
                    <!-- Dropdown list. Initially hidden and will be shown by JS. -->
                    <ul id="role-dropdown-list" class="custom-dropdown-list hidden">
                        <!-- Dropdown items will be added here via JavaScript -->
                    </ul>
                </div>
            </div>
            
            <!-- Message for role change restriction -->
            <div id="role-message" class="role-message-box hidden animated-item">
                Your role is set and cannot be changed under any circumstances.
            </div>

            <!-- Action Buttons -->
            <div class="flex flex-col space-y-4 animated-item mt-8">
                <!-- Save Profile Button -->
                <button type="button" id="save-button" class="w-full bg-[#1d4ed8] text-white font-bold py-3 px-4 rounded-lg shadow-md hover:bg-[#1f5ae0] transition-colors duration-200">
                    Save Profile
                </button>
                <!-- Log Out Button -->
                <button type="button" id="logout-button" class="w-full bg-red-500 text-white font-bold py-3 px-4 rounded-lg shadow-md hover:bg-red-600 transition-colors duration-200">
                    Log Out
                </button>
                <!-- Help/FAQ Button -->
                <button type="button" id="help-button" class="w-full bg-gray-200 text-gray-800 font-bold py-3 px-4 rounded-lg shadow-md hover:bg-gray-300 transition-colors duration-200">
                    Help / FAQ
                </button>
            </div>
        </form>
    </div>

    <!-- JavaScript for functionality -->
    <script>
        // --- State and DOM Element References ---
        // Dropdown data and icons (using SVG paths for cleaner code)
        const roles = [
            { id: 'swimmer', name: 'Swimmer', icon: '<svg class="w-6 h-6 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 22s-8-4-8-12c0-4.4 3.6-8 8-8s8 3.6 8 8c0 8-8 12-8 12z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 7a2 2 0 100-4 2 2 0 000 4z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 11a3 3 0 100-6 3 3 0 000 6z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 16s-2 1-2 3c0 1.5 1 2 2 2s2-.5 2-2c0-2-2-3-2-3z" /></svg>' },
            { id: 'parent', name: 'Parent', icon: '<svg class="w-6 h-6 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 18a2 2 0 00-2-2h-2a2 2 0 00-2 2" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10a2 2 0 100-4 2 2 0 000 4z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 21v-2a2 2 0 012-2h4a2 2 0 012 2v2" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 16c4 0 7 2 7 5H5c0-3 3-5 7-5z" /></svg>' },
            { id: 'shop', name: 'Shop', icon: '<svg class="w-6 h-6 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4zM3 6h18" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 10a4 4 0 01-8 0" /></svg>' },
            { id: 'academy', name: 'Academy', icon: '<svg class="w-6 h-6 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 19.5v-15A2.5 2.5 0 016.5 2H20v20h-1.5" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.5 5.5h5" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.5 8h5" /></svg>' },
            { id: 'coach', name: 'Coach', icon: '<svg class="w-6 h-6 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 22s-8-4-8-12c0-4.4 3.6-8 8-8s8 3.6 8 8c0 8-8 12-8 12z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 7a2 2 0 100-4 2 2 0 000 4z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 11a3 3 0 100-6 3 3 0 000 6z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 16s-2 1-2 3c0 1.5 1 2 2 2s2-.5 2-2c0-2-2-3-2-3z" /></svg>' },
            { id: 'online-coach', name: 'Online Coach', icon: '<svg class="w-6 h-6 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10a2 2 0 100-4 2 2 0 000 4z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 21v-2a2 2 0 012-2h4a2 2 0 012 2v2" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 16c4 0 7 2 7 5H5c0-3 3-5 7-5z" /><rect x="2" y="3" width="20" height="14" rx="2" ry="2" /></svg>' },
            { id: 'clinic', name: 'Clinic', icon: '<svg class="w-6 h-6 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 21.35l-1.92-1.8c-3.15-2.8-5.08-4.57-5.08-6.93a5 5 0 0110 0c0 2.36-1.93 4.13-5.08 6.93L12 21.35z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 21.35l-1.92-1.8c-3.15-2.8-5.08-4.57-5.08-6.93a5 5 0 0110 0c0 2.36-1.93 4.13-5.08 6.93L12 21.35z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10.5h-2.5V8h-3v2.5H4v3h2.5V16h3v-2.5H12V10.5z" /></svg>' },
            { id: 'event-organizer', name: 'Event Organizer', icon: '<svg class="w-6 h-6 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 2v6h6" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 15h4" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19h4" /></svg>' }
        ];

        // Get elements once to avoid repeated DOM lookups
        const nameInput = document.getElementById('name');
        const editButton = document.getElementById('edit-name-btn');
        const penIcon = document.getElementById('pen-icon');
        const checkIcon = document.getElementById('check-icon');
        const editMessage = document.getElementById('edit-message');
        const saveButton = document.getElementById('save-button');
        const profilePhoto = document.getElementById('profile-photo');
        const editPhotoBtn = document.getElementById('edit-photo-btn');
        const profilePhotoContainer = document.getElementById('profile-photo-container');
        
        const roleWarning = document.getElementById('role-warning');
        const roleDropdownHeader = document.getElementById('role-dropdown-header');
        const roleDropdownList = document.getElementById('role-dropdown-list');
        const selectedRoleText = document.getElementById('selected-role-text');
        const dropdownArrow = document.getElementById('dropdown-arrow');
        const roleMessage = document.getElementById('role-message');
        
        // --- Core State Variables ---
        let selectedRoleId = localStorage.getItem('selectedRole') || null;
        let isRoleSaved = localStorage.getItem('isRoleSaved') === 'true';
        let lastChangeTimestamp = localStorage.getItem('last_name_change') ? parseInt(localStorage.getItem('last_name_change')) : null;
        const FOURTEEN_DAYS_MS = 14 * 24 * 60 * 60 * 1000;

        // Helper function for showing alerts in a custom message box
        function alertMessage(message, type = 'success') {
            const messageBox = document.createElement('div');
            const colorClass = type === 'success' ? 'bg-green-500' : 'bg-red-500';
            messageBox.className = `fixed top-4 left-1/2 -translate-x-1/2 ${colorClass} text-white px-6 py-3 rounded-lg shadow-xl z-50 transition-all duration-300`;
            messageBox.textContent = message;
            document.body.appendChild(messageBox);
            setTimeout(() => {
                messageBox.classList.add('opacity-0');
                setTimeout(() => messageBox.remove(), 300);
            }, 3000);
        }

        // --- Name Edit Logic ---
        function updateNameEditState() {
            if (lastChangeTimestamp && (Date.now() - lastChangeTimestamp) < FOURTEEN_DAYS_MS) {
                // Name change is locked
                nameInput.setAttribute('readonly', 'true');
                editButton.disabled = true;
                editButton.classList.add('text-gray-200', 'cursor-not-allowed');
                editButton.classList.remove('hover:text-gray-600');
                penIcon.classList.remove('hidden');
                checkIcon.classList.add('hidden');
                editMessage.classList.remove('hidden');
                const nextChangeDate = new Date(lastChangeTimestamp + FOURTEEN_DAYS_MS);
                editMessage.textContent = `Name can be changed again on ${nextChangeDate.toLocaleDateString()} at ${nextChangeDate.toLocaleTimeString()}.`;
            } else {
                // Name change is available
                editButton.disabled = false;
                editButton.classList.remove('text-gray-200', 'cursor-not-allowed');
                editButton.classList.add('hover:text-gray-600');
                editMessage.classList.add('hidden');
            }
        }

        // Function to capitalize the first letter of each word
        function capitalizeName(input) {
            const words = input.value.split(' ');
            const capitalizedWords = words.map(word => {
                if (word.length === 0) return '';
                return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
            });
            input.value = capitalizedWords.join(' ');
        }

        // --- Dropdown Logic ---
        function openDropdown() {
            if (isRoleSaved) return; // Prevent opening if role is saved
            roleDropdownList.classList.remove('hidden');
            setTimeout(() => {
                roleDropdownList.classList.add('open');
                dropdownArrow.classList.add('rotate-180');
            }, 10); // Small delay to trigger transition
        }

        function closeDropdown() {
            roleDropdownList.classList.remove('open');
            dropdownArrow.classList.remove('rotate-180');
            // We use a small timeout to let the CSS transition finish before hiding completely
            setTimeout(() => {
                roleDropdownList.classList.add('hidden');
            }, 200);
        }
        
        function selectRole(roleId) {
            selectedRoleId = roleId;
            const role = roles.find(r => r.id === roleId);
            if (role) {
                selectedRoleText.textContent = role.name;
            }
            // Update the "selected" class visually
            document.querySelectorAll('.custom-dropdown-item').forEach(item => {
                item.classList.remove('selected');
                if (item.getAttribute('data-value') === roleId) {
                    item.classList.add('selected');
                }
            });
            closeDropdown();
        }

        function initializeDropdown() {
            if (isRoleSaved) {
                // If role is saved, display it as a non-interactive field
                const savedRole = roles.find(r => r.id === selectedRoleId);
                if (savedRole) {
                    selectedRoleText.textContent = savedRole.name;
                    roleDropdownHeader.classList.add('bg-gray-50', 'text-gray-500', 'cursor-not-allowed', 'shadow-inner');
                }
                dropdownArrow.classList.add('hidden');
                roleMessage.classList.remove('hidden');
                roleDropdownList.classList.add('hidden'); // Explicitly hide the dropdown list
                roleWarning.classList.add('hidden'); // Hide the warning message
            } else {
                // If not saved, render a clickable dropdown
                roleDropdownHeader.classList.remove('bg-gray-50', 'text-gray-500', 'cursor-not-allowed', 'shadow-inner');
                dropdownArrow.classList.remove('hidden');
                roleMessage.classList.add('hidden');
                roleWarning.classList.remove('hidden'); // Show the warning message
                
                // Clear and populate the list
                roleDropdownList.innerHTML = '';
                roles.forEach(role => {
                    const li = document.createElement('li');
                    li.className = 'custom-dropdown-item';
                    li.setAttribute('data-value', role.id);
                    // Insert the full SVG and text
                    li.innerHTML = role.icon + `<span>${role.name}</span>`;
                    
                    li.addEventListener('click', (event) => {
                        event.stopPropagation();
                        selectRole(role.id);
                    });
                    
                    roleDropdownList.appendChild(li);
                });

                // Set initial selection if one exists from a previous session
                if (selectedRoleId) {
                    selectRole(selectedRoleId);
                }
            }
        }
        
        // --- Event Listeners ---
        
        // Toggle the dropdown on header click
        roleDropdownHeader.addEventListener('click', () => {
            if (roleDropdownList.classList.contains('open')) {
                closeDropdown();
            } else {
                openDropdown();
            }
        });

        // Close dropdown when clicking outside of it
        document.addEventListener('click', (event) => {
            const isClickInside = roleDropdownHeader.contains(event.target) || roleDropdownList.contains(event.target);
            if (!isClickInside && roleDropdownList.classList.contains('open')) {
                closeDropdown();
            }
        });

        // Name field edit functionality
        editButton.addEventListener('click', () => {
            if (nameInput.hasAttribute('readonly')) {
                // Enable editing
                nameInput.removeAttribute('readonly');
                nameInput.focus();
                penIcon.classList.add('hidden');
                checkIcon.classList.remove('hidden');
                editMessage.classList.add('hidden');
            } else {
                // Save the name and disable editing
                const nameValue = nameInput.value.trim();
                const nameParts = nameValue.split(' ');
                
                if (nameParts.length < 2) {
                    alertMessage('Please enter at least a first and last name.', 'error');
                    return; // Stop the function here if validation fails
                }
                
                nameInput.setAttribute('readonly', 'true');
                penIcon.classList.remove('hidden');
                checkIcon.classList.add('hidden');
                lastChangeTimestamp = Date.now();
                localStorage.setItem('last_name_change', lastChangeTimestamp.toString());
                updateNameEditState();
                alertMessage('Name updated successfully!', 'success');
            }
        });
        
        // Add input event listener for capitalization
        nameInput.addEventListener('input', () => {
            capitalizeName(nameInput);
        });

        // Photo edit functionality
        editPhotoBtn.addEventListener('click', (e) => {
            e.preventDefault(); // Prevents button from submitting a form
            const randomColor = Math.floor(Math.random()*16777215).toString(16);
            const newUrl = `https://placehold.co/200x200/${randomColor}/white?text=User`;
            profilePhoto.src = newUrl;
            alertMessage('Profile photo updated!', 'success');
        });

        // Save button functionality
        saveButton.addEventListener('click', () => {
            if (!isRoleSaved) {
                if (selectedRoleId) {
                    isRoleSaved = true;
                    localStorage.setItem('isRoleSaved', 'true');
                    localStorage.setItem('selectedRole', selectedRoleId);
                    initializeDropdown(); // Re-initialize to lock the role
                    alertMessage("Profile saved successfully! Your role has been locked in.", 'success');
                } else {
                    alertMessage("Please select a role before saving.", 'error');
                }
            } else {
                alertMessage("Profile saved successfully!", 'success');
            }
        });

        document.getElementById('logout-button').addEventListener('click', () => {
            alertMessage('You have been logged out.');
        });

        document.getElementById('help-button').addEventListener('click', () => {
            alertMessage('Redirecting to Help/FAQ...');
        });

        // --- Initial Call to Set Up UI ---
        document.addEventListener('DOMContentLoaded', () => {
            initializeDropdown();
            updateNameEditState();
        });

    </script>
</body>
</html>
