<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bookings Management</title>
    <!-- Tailwind CSS CDN for styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
        body {
            font-family: 'Inter', sans-serif;
            background-color: #F7F9FB;
        }
        .form-card {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.05);
            padding: 1rem;
        }
        .booking-card {
            background-color: white;
            border-left: 5px solid #38A169; /* Green marker for booked */
            border-radius: 8px;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            transition: transform 0.1s;
        }
        .booking-card:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        /* Style for Time Slot Grouping Header */
        .time-group-header {
            font-size: 1.25rem;
            font-weight: 800;
            color: #1F2937;
            padding: 10px 0;
            margin-top: 1.5rem;
            margin-bottom: 0.5rem;
            border-bottom: 2px solid #E5E7EB; 
        }
        /* Client Detail Modal Styling */
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
        /* Hidden class to control modal visibility */
        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 99;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        /* Cancel Button Styling */
        .btn-cancel {
            background-color: #EF4444; /* Red */
            transition: background-color 0.2s;
        }
        .btn-cancel:hover {
            background-color: #DC2626;
        }
    </style>
</head>
<body>

    <div class="max-w-xl mx-auto p-4 md:p-8">
        <h1 class="text-3xl font-extrabold text-gray-800 mb-2">Bookings Management</h1>
        <p class="text-gray-500 mb-4">Appointments scheduled by clients.</p>

        <!-- Branch Selector & Date Navigator -->
        <div class="form-card mb-6">
            <!-- Branch Selector -->
            <div class="w-full mb-4">
                <label for="branch-select" class="block text-xs font-medium text-gray-500">Current Branch</label>
                <select id="branch-select" class="w-full text-xl font-extrabold py-2 rounded-lg border border-gray-300 px-3" onchange="initializeView()">
                    <!-- Options populated by JS -->
                </select>
            </div>

            <!-- Day Iterator (Simplified for this view) -->
            <div class="flex justify-between items-center space-x-3 text-center">
                 <button onclick="changeDate(-1)" class="p-2 bg-gray-200 rounded-full hover:bg-gray-300 transition">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
                </button>
                <span class="text-xl font-semibold text-gray-800" id="current-date-display">Mon, 1 Jan 2025</span>
                <button onclick="changeDate(1)" class="p-2 bg-gray-200 rounded-full hover:bg-gray-300 transition">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
                </button>
            </div>
            
            <p class="text-sm text-gray-700 font-medium mt-4 text-center" id="summary-status"></p>
        </div>

        <!-- Bookings List Container -->
        <div id="bookings-list" class="space-y-6">
            <!-- Bookings grouped by time will be injected here -->
        </div>

        <div id="no-bookings" class="text-center text-gray-500 mt-12 hidden">
             No client bookings scheduled for this date.
        </div>
    </div>

    <!-- Client Details Modal Structure -->
    <div id="details-modal-overlay" class="modal-overlay hidden">
        <div id="details-modal-content" class="bg-white rounded-xl shadow-2xl w-full max-w-sm">
            
            <div class="p-5 border-b flex justify-between items-center sticky top-0 bg-white rounded-t-xl">
                <h3 class="text-2xl font-extrabold text-gray-800">Booking Details</h3>
                <button id="close-modal-btn" onclick="closeDetailsModal()" class="text-gray-500 hover:text-gray-800 transition">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>

            <div class="p-5 space-y-4">
                <p class="text-sm text-gray-500" id="detail-time-slot"></p>
                
                <div class="space-y-3 p-3 bg-gray-50 rounded-lg">
                    <div class="flex justify-between">
                        <span class="font-medium text-gray-700">Client:</span>
                        <span class="font-extrabold text-gray-900" id="detail-client-name"></span>
                    </div>
                    <div class="flex justify-between">
                        <span class="font-medium text-gray-700">Age:</span>
                        <span class="font-extrabold text-gray-900" id="detail-client-age"></span>
                    </div>
                    <div class="flex justify-between">
                        <span class="font-medium text-gray-700">Service:</span>
                        <span class="font-semibold text-blue-600" id="detail-service"></span>
                    </div>
                    <div class="flex justify-between border-t pt-3">
                        <span class="font-medium text-gray-700">Contact:</span>
                        <a href="#" id="detail-contact-link" target="_blank" class="font-semibold whatsapp-link hover:underline">
                            <span id="detail-contact"></span>
                        </a>
                    </div>
                </div>

                <!-- Cancel Button (New Feature) -->
                <button id="cancel-booking-button" class="w-full py-3 text-white font-bold rounded-lg btn-cancel mt-4">
                    Cancel Booking
                </button>
                <input type="hidden" id="cancel-booking-ref">
            </div>
        </div>
    </div>
    
    <!-- Cancellation Confirmation Modal -->
    <div id="confirm-cancel-modal" class="modal-overlay hidden">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-xs p-6 text-center">
            <h4 class="text-xl font-bold text-red-600 mb-2">Confirm Cancellation</h4>
            <p class="text-gray-700 mb-6">Are you sure you want to cancel this booking? This action cannot be undone.</p>
            <div class="flex justify-center space-x-3">
                <button onclick="closeConfirmationModal()" class="py-2 px-4 bg-gray-200 text-gray-800 rounded-lg">No, Keep It</button>
                <button onclick="executeCancelBooking()" class="py-2 px-4 text-white rounded-lg btn-cancel">Yes, Cancel</button>
            </div>
        </div>
    </div>

    <script>
        // --- MOCK DATA ---
        const MOCK_DATA = {
            branches: [
                { id: 'b1', name: 'Family Park Clinic', beds: 3, open: 8, close: 17, city: 'Riyadh' },
                { id: 'b2', name: 'Jeddah Coastal Center', beds: 2, open: 9, close: 18, city: 'Jeddah' }
            ],
            // Detailed Booked Slots (GREEN)
            bookedSlots: {
                'b1': {
                    '2025-12-01': [ 
                        { time: '09:00', bed: 'Bed-2', client: 'Ahmed Sami', age: 30, service: 'Initial Assessment', phone: '0501234567' },
                        { time: '14:00', bed: 'Bed-1', client: 'Fatima Khalid', age: 45, service: 'Post-Injury Rehab', phone: '0551122334' }
                    ],
                    '2025-12-02': [ 
                        { time: '16:00', bed: 'Bed-3', client: 'Laila Ali', age: 22, service: 'Hydrotherapy Session', phone: '0559876543' }
                    ]
                }
            },
            // Admin Blocked Slots (RED) (Used only for status indicator on this view)
            blockedSlots: {
                'b1': {
                    '2025-12-01': ['10:00', '11:00'], 
                    '2025-12-03': ['13:00']
                },
            }
        };

        // --- GLOBAL STATE ---
        let selectedDate = new Date(); 
        let selectedBranchId = 'b1';

        const DAY_NAMES = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
        const MONTH_NAMES = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

        // --- UTILITY FUNCTIONS ---

        function formatDate(date) {
            const yyyy = date.getFullYear();
            const mm = String(date.getMonth() + 1).padStart(2, '0');
            const dd = String(date.getDate()).padStart(2, '0');
            return `${yyyy}-${mm}-${dd}`;
        }
        
        function formatTime24hrTo12hr(hour24) {
            const h = hour24 % 12 || 12;
            const ampm = hour24 < 12 || hour24 === 24 ? 'AM' : 'PM';
            const minute = '00';
            return `${String(h).padStart(2, '0')}:${minute} ${ampm}`;
        }
        
        function getDisplayDate(date) {
            const dayName = DAY_NAMES[date.getDay()];
            const dayNum = date.getDate();
            const month = MONTH_NAMES[date.getMonth()];
            const year = date.getFullYear();
            return `${dayName}, ${dayNum} ${month} ${year}`;
        }
        
        function formatPhoneNumber(phone) {
            // Cleans up phone number for WhatsApp link
            return phone.replace(/[^\d+]/g, '');
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
        
        // --- VIEW INITIALIZATION ---

        function initializeSelects() {
            const branchSelect = document.getElementById('branch-select');
            branchSelect.innerHTML = '';
            
            MOCK_DATA.branches.forEach(branch => {
                const option = document.createElement('option');
                option.value = branch.id;
                option.textContent = branch.name;
                if (branch.id === selectedBranchId) {
                    option.selected = true;
                }
                branchSelect.appendChild(option);
            });
        }

        function initializeView() {
            selectedBranchId = document.getElementById('branch-select').value;
            
            const selectedBranch = MOCK_DATA.branches.find(b => b.id === selectedBranchId);
            const openTime = formatTime24hrTo12hr(selectedBranch.open);
            const closeTime = formatTime24hrTo12hr(selectedBranch.close);
            
            document.getElementById('current-date-display').textContent = getDisplayDate(selectedDate);
            document.getElementById('summary-status').textContent = 
                `Hours: ${openTime} - ${closeTime} | Beds: ${selectedBranch.beds}`;

            renderBookingsList();
        }

        // --- DATE MANIPULATION ---

        function changeDate(days) {
            selectedDate.setDate(selectedDate.getDate() + days);
            initializeView();
        }
        
        // --- LIST RENDERING ---

        function renderBookingsList() {
            const listContainer = document.getElementById('bookings-list');
            const noBookingsMessage = document.getElementById('no-bookings');
            const bookingDateStr = formatDate(selectedDate);
            
            const bookedDataByTime = {};
            const branchBookings = MOCK_DATA.bookedSlots[selectedBranchId]?.[bookingDateStr] || [];
            
            // 1. Organize bookings by time slot (the main grouping)
            branchBookings.forEach(booking => {
                const time = booking.time; // e.g., '09:00'
                if (!bookedDataByTime[time]) {
                    bookedDataByTime[time] = [];
                }
                bookedDataByTime[time].push(booking);
            });

            // 2. Prepare HTML output
            let listHTML = '';
            const sortedTimes = Object.keys(bookedDataByTime).sort();

            if (sortedTimes.length === 0) {
                 listContainer.innerHTML = '';
                 noBookingsMessage.classList.remove('hidden');
                 return;
            }
            
            noBookingsMessage.classList.add('hidden');

            sortedTimes.forEach(time24hr => {
                const bookings = bookedDataByTime[time24hr];
                const timeDisplay = formatTime24hrTo12hr(parseInt(time24hr.split(':')[0]));
                
                // Group Header
                listHTML += `<div class="time-group-header">${timeDisplay} (${bookings.length} Bookings)</div>`;

                // Cards for each booking at this time slot
                bookings.forEach((booking, index) => {
                    listHTML += `
                        <div class="booking-card p-3 flex items-center justify-between space-x-4 mb-2">
                            
                            <!-- Resource & Service Info -->
                            <div class="flex-grow">
                                <p class="text-sm font-semibold text-gray-900">${booking.bed.replace('-', ' ')}</p>
                                <p class="text-xs text-blue-600">${booking.service}</p>
                            </div>

                            <!-- Client Status and Action -->
                            <div class="flex items-center space-x-3">
                                <span class="text-sm font-medium text-gray-700">${booking.client}</span>
                                
                                <!-- Eye Icon for More Details -->
                                <button onclick="openBookingDetailsModal('${bookingDateStr}', '${time24hr}', '${booking.bed}')" 
                                        class="p-2 text-green-600 hover:bg-green-100 rounded-full transition" title="View Client Details">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
                                </button>
                            </div>
                        </div>
                    `;
                });
            });

            listContainer.innerHTML = listHTML;
        }

        // --- CLIENT DETAILS MODAL ---

        const detailsModal = document.getElementById('details-modal-overlay');
        const confirmCancelModal = document.getElementById('confirm-cancel-modal');

        function openBookingDetailsModal(dateStr, time24hr, bedId) {
            
            // Helper to safely find the booking details
            const bookedData = MOCK_DATA.bookedSlots[selectedBranchId]?.[dateStr] || [];
            const details = bookedData.find(b => b.time === time24hr && b.bed === bedId);

            if (!details) return showSnackbar('Booking details not found.', true);

            // Populate Modal
            document.getElementById('detail-time-slot').textContent = 
                `${getDisplayDate(selectedDate)} @ ${formatTime24hrTo12hr(parseInt(time24hr.split(':')[0]))} (${bedId.replace('-', ' ')})`;
            
            document.getElementById('detail-client-name').textContent = details.client;
            document.getElementById('detail-client-age').textContent = details.age || 'N/A';
            document.getElementById('detail-service').textContent = details.service;
            
            // Set WhatsApp Link and Contact Number
            const cleanPhone = formatPhoneNumber(details.phone);
            document.getElementById('detail-contact').textContent = details.phone;
            document.getElementById('detail-contact-link').href = `https://wa.me/${cleanPhone}`;
            
            // Set hidden reference for cancellation
            const cancelRef = JSON.stringify({ dateStr, time24hr, bedId });
            document.getElementById('cancel-booking-ref').value = cancelRef;

            detailsModal.classList.remove('hidden');
        }
        
        function closeDetailsModal() {
            detailsModal.classList.add('hidden');
        }

        function openConfirmationModal() {
            closeDetailsModal();
            confirmCancelModal.classList.remove('hidden');
        }
        
        function closeConfirmationModal() {
            confirmCancelModal.classList.add('hidden');
            detailsModal.classList.remove('hidden'); // Return to details modal (optional)
        }
        
        function executeCancelBooking() {
            const refString = document.getElementById('cancel-booking-ref').value;
            const ref = JSON.parse(refString);
            
            const bookingsList = MOCK_DATA.bookedSlots[selectedBranchId]?.[ref.dateStr];
            
            if (bookingsList) {
                const index = bookingsList.findIndex(b => b.time === ref.time24hr && b.bed === ref.bedId);
                
                if (index !== -1) {
                    bookingsList.splice(index, 1);
                    showSnackbar(`Booking for ${ref.clientName || 'Client'} cancelled successfully.`, false);
                } else {
                    showSnackbar("Error: Booking not found.", true);
                }
            } else {
                 showSnackbar("Error: Bookings list not found for this date.", true);
            }

            confirmCancelModal.classList.add('hidden');
            initializeView(); // Re-render the list
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
            // Set initial date to current date for the very first load
            selectedDate = new Date(2025, 11, 1); // Mock start date for easier reference
            
            initializeSelects();
            initializeView();
            
            // Attach secondary listener for the Cancel Booking button inside the details modal
            document.getElementById('cancel-booking-button').onclick = openConfirmationModal;
        };
    </script>
</body>
</html>