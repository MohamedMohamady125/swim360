<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders Management</title>
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
        .order-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            border-left: 5px solid;
        }
        .requested-card { border-color: #FBBF24; /* Amber */ }
        .confirmed-card { border-color: #10B981; /* Green */ }
        .delivered-card { border-color: #3B82F6; /* Blue for Archive */ }


        .tab-button {
            padding: 0.75rem 0.5rem; /* Adjusted padding for 3 tabs */
            font-weight: 600;
            cursor: pointer;
            border-bottom: 2px solid transparent;
            transition: border-color 0.2s, color 0.2s;
            flex-grow: 1;
            text-align: center;
        }
        .tab-button.active {
            border-bottom-color: #3B82F6;
            color: #3B82F6;
        }
        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 99;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .btn-confirm { background-color: #10B981; }
        .btn-reject { background-color: #EF4444; }
        .btn-contact { background-color: #22C55E; }
        .btn-delivered { background-color: #3B82F6; }
        .btn-delivered-action { background-color: #3B82F6; }

        .input-group {
            display: flex;
            align-items: center;
            border: 1px solid #E5E7EB;
            border-radius: 8px;
            padding: 0 12px;
            background-color: #FAFAFA;
        }
        .input-group select {
            border: none;
            outline: none;
            padding: 12px 0;
            flex-grow: 1;
            background-color: transparent;
        }
        .item-detail-card {
            background-color: #F9FAFB;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 8px;
        }
        .item-variant {
            font-size: 0.75rem; /* text-xs */
            color: #6B7280;
        }
    </style>
</head>
<body>

    <div class="max-w-xl mx-auto p-4 md:p-8">
        <h1 class="text-3xl font-extrabold text-gray-800 mb-2">Order Management</h1>
        <p class="text-gray-500 mb-4">Process incoming requests and monitor confirmed deliveries.</p>

        <!-- Branch Filter Dropdown -->
        <div class="mb-6">
            <label for="branch-filter" class="block text-sm font-medium text-gray-700 mb-1">Filter by Branch</label>
            <select id="branch-filter" 
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg shadow-sm focus:ring-blue-500 focus:border-blue-500 transition duration-150"
                    onchange="setTab(currentTab)">
                 <!-- Options populated by JS -->
            </select>
        </div>

        <!-- Tab Navigation -->
        <div class="flex justify-start border-b border-gray-300 mb-6">
            <button class="tab-button active" data-tab="requested" onclick="setTab('requested')">Requested</button>
            <button class="tab-button" data-tab="confirmed" onclick="setTab('confirmed')">Confirmed</button>
            <button class="tab-button" data-tab="delivered" onclick="setTab('delivered')">Delivered/Archive</button>
        </div>

        <!-- Confirmed Tab Search Bar -->
        <div id="confirmed-search-area" class="mb-6 hidden">
             <input 
                type="number" 
                id="confirmed-order-search" 
                placeholder="Search by Order Number (e.g., 1003)"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg shadow-sm focus:ring-blue-500 focus:border-blue-500 transition duration-150"
                oninput="searchConfirmedOrders(this.value)">
        </div>

        <!-- Order List Container -->
        <div id="order-list" class="space-y-4">
            <!-- Order cards injected here -->
        </div>

        <div id="no-orders" class="text-center text-gray-500 mt-12 hidden">
             No requested orders currently awaiting confirmation.
        </div>
    </div>

    <!-- Modals -->

    <!-- 1. Delivery Date Confirmation Modal -->
    <div id="delivery-modal-overlay" class="modal-overlay hidden">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-sm p-6">
            <h4 class="text-xl font-bold text-gray-800 mb-4">Set Delivery Date</h4>
            <p class="text-gray-600 mb-4">Enter the estimated delivery date for Order #<span id="delivery-order-ref" class="font-bold"></span>.</p>
            
            <form id="delivery-form">
                <input type="hidden" id="delivery-order-id">
                <div class="input-group mb-4">
                    <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                    <input type="date" id="delivery-date-input" name="delivery_date" required min="">
                </div>
                
                <div class="flex justify-end space-x-3">
                    <button type="button" onclick="closeDeliveryModal()" class="py-2 px-4 bg-gray-200 text-gray-800 rounded-lg">Cancel</button>
                    <button type="submit" class="py-2 px-4 text-white rounded-lg btn-confirm">Confirm Date</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- 2. Reject Order Modal -->
    <div id="reject-modal-overlay" class="modal-overlay hidden">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-xs p-6">
            <h4 class="text-xl font-bold text-red-600 mb-4">Reject Order</h4>
            <p class="text-gray-600 mb-4">Select the reason for rejecting Order #<span id="reject-order-ref" class="font-bold"></span>.</p>
            
            <form id="reject-form">
                <input type="hidden" id="reject-order-id">
                <div class="input-group mb-4">
                    <select id="reject-reason" name="reason" required class="w-full">
                        <option value="" disabled selected>Select Reason</option>
                        <option value="out_of_stock">Item Out of Stock</option>
                        <option value="invalid_address">Invalid Delivery Address</option>
                        <option value="payment_issue">Payment Issue</option>
                        <option value="other">Other/Unforeseen Issue</option>
                    </select>
                </div>
                
                <div class="flex justify-end space-x-3">
                    <button type="button" onclick="closeRejectModal()" class="py-2 px-4 bg-gray-200 text-gray-800 rounded-lg">Cancel</button>
                    <button type="submit" class="py-2 px-4 text-white rounded-lg btn-reject">Reject Order</button>
                </div>
            </form>
        </div>
    </div>

    
    <!-- 3. Customer Contact Modal (Reusable) -->
    <div id="contact-modal-overlay" class="modal-overlay hidden">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-xs p-6 text-center">
            <h4 class="text-xl font-bold text-gray-800 mb-2">Contact Customer</h4>
            <p class="text-sm text-gray-700 mb-4">Order #<span id="contact-order-number" class="font-bold"></span></p>

            <div class="space-y-4">
                <p class="text-lg font-semibold" id="contact-customer-name"></p>
                <a href="#" id="contact-whatsapp-link" target="_blank" class="w-full py-3 text-white font-bold rounded-lg btn-contact inline-flex items-center justify-center space-x-2">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8s-9-3.582-9-8 4.03-8 9-8 9 3.582 9 8z"></path></svg>
                    <span>Chat on WhatsApp</span>
                </a>
            </div>
            <button onclick="closeContactModal()" class="mt-4 text-gray-500 hover:text-gray-800">Close</button>
        </div>
    </div>

    <!-- 4. Order Item Details Modal -->
    <div id="item-details-modal-overlay" class="modal-overlay hidden">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-sm p-6">
            <div class="flex justify-between items-center border-b pb-3 mb-4">
                <h4 class="text-xl font-bold text-gray-800">Order Items (#<span id="items-order-ref"></span>)</h4>
                <button onclick="closeItemDetailsModal()" class="text-gray-500 hover:text-gray-800 transition">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            <div id="item-details-list" class="space-y-4 max-h-80 overflow-y-auto">
                <!-- Detailed item cards injected here -->
            </div>
        </div>
    </div>
    
    <!-- 5. Delivered Confirmation Modal -->
    <div id="confirm-delivered-modal" class="modal-overlay hidden">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-xs p-6 text-center">
            <h4 class="text-xl font-bold text-blue-600 mb-2">Confirm Delivery</h4>
            <p class="text-gray-700 mb-6">Mark Order #<span id="delivered-confirm-order-id" class="font-bold"></span> as Delivered?</p>
            <div class="flex justify-center space-x-3">
                <button onclick="closeConfirmationDeliveredModal()" class="py-2 px-4 bg-gray-200 text-gray-800 rounded-lg">No, Hold</button>
                <button onclick="executeMarkOrderDelivered()" class="py-2 px-4 text-white rounded-lg btn-delivered-action">Yes, Delivered</button>
            </div>
            <input type="hidden" id="delivery-confirm-ref">
        </div>
    </div>


    <script>
        // --- MOCK DATA ---
        let orders = [
            // Requested Orders (Delivery Only)
            { 
                id: 1001, status: 'requested', customer_name: 'Liam Davies', phone: '0501112222', branch_id: 'b1',
                location: 'King Fahad Road, Riyadh', delivery_type: 'National Delivery',
                items: [
                    {name: 'Pro Goggles', qty: 1, category: 'Goggles', brand: 'Speedo', size: 'ONE SIZE', color: 'Blue'}, 
                    {name: 'Swim Cap', qty: 2, category: 'Cap', brand: 'TYR', size: 'M', color: 'Black'}
                ] 
            },
            { 
                id: 1002, status: 'requested', customer_name: 'Olivia Martin', phone: '0559998888', branch_id: 'b2',
                location: 'King Abdullah St. (Delivery)', delivery_type: 'Governorate Delivery',
                items: [
                    {name: 'Carbon Suit', qty: 1, category: 'Suit', brand: 'Arena', size: '32', color: 'Purple'}, 
                    {name: 'Fins', qty: 1, category: 'Fins', brand: 'FINIS', size: 'XL', color: 'Yellow'}
                ] 
            },
            // Confirmed Orders (Delivery Only)
            { 
                id: 1003, status: 'confirmed', customer_name: 'Ahmed Khalid', phone: '0534567890', branch_id: 'b1',
                location: 'Jeddah Corniche', delivery_type: 'Governorate Delivery',
                items: [{name: 'Kickboard', qty: 1, category: 'Kickboard', brand: 'TYR', size: 'ONE SIZE', color: 'Green'}], 
                delivery_date: '2025-12-10'
            },
            { 
                id: 1004, status: 'confirmed', customer_name: 'Sara Fehr', phone: '0501110000', branch_id: 'b3',
                location: 'Al Waha District, Dammam', delivery_type: 'National Delivery',
                items: [
                    {name: 'TYR Sandals', qty: 2, category: 'Footwear', brand: 'TYR', size: '40', color: 'White'}, 
                    {name: 'Water Bottle', qty: 1, category: 'Accessories', brand: 'Mizuno', size: 'ONE SIZE', color: 'Pink'}
                ], 
                delivery_date: '2025-12-15'
            },
        ];
        
        const MOCK_BRANCHES = [
            { id: 'b1', name: 'Al Malaz Store (Riyadh)' },
            { id: 'b2', name: 'King Abdullah St. Store (Jeddah)' },
            { id: 'b3', name: 'Dammam City Center Store' },
            { id: 'b4', name: 'Madinah Road Store' },
        ];


        let currentTab = 'requested';
        let selectedBranchFilter = 'all'; // Default to show all branches
        
        const orderListContainer = document.getElementById('order-list');
        const noOrdersMessage = document.getElementById('no-orders');
        const deliveryModal = document.getElementById('delivery-modal-overlay');
        const rejectModal = document.getElementById('reject-modal-overlay');
        const contactModal = document.getElementById('contact-modal-overlay');
        const itemDetailsModal = document.getElementById('item-details-modal-overlay');
        const deliveredConfirmModal = document.getElementById('confirm-delivered-modal');

        const deliveryDateInput = document.getElementById('delivery-date-input');
        const confirmedSearchArea = document.getElementById('confirmed-search-area');

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
        
        // --- DATA MANAGEMENT & ARCHIVAL ---
        
        function getFilteredAndArchivedOrders() {
            const now = new Date().getTime();
            const filteredOrders = [];
            
            // --- ARCHIVAL LOGIC (Purge orders older than 14 days) ---
            orders = orders.filter(order => {
                if (order.status === 'delivered') {
                    const deliveredTime = new Date(order.delivered_on).getTime();
                    // Keep if less than 14 days old (14 * 24 * 60 * 60 * 1000 ms)
                    return (now - deliveredTime) < 14 * 24 * 60 * 60 * 1000;
                }
                return true; // Keep requested and confirmed orders
            });
            
            // Apply filtering and categorization for display
            orders.forEach(order => {
                const matchesBranch = selectedBranchFilter === 'all' || order.branch_id === selectedBranchFilter;
                
                if (matchesBranch) {
                    // Check the status against the current tab
                    if (currentTab === 'delivered' && order.status === 'delivered') {
                         filteredOrders.push(order);
                    } else if (order.status === currentTab) {
                        filteredOrders.push(order);
                    }
                }
            });
            
            return filteredOrders;
        }


        // --- VIEW MANAGEMENT ---

        function populateBranchFilterDropdown() {
            const select = document.getElementById('branch-filter');
            select.innerHTML = '<option value="all">All Branches</option>';

            MOCK_BRANCHES.forEach(branch => {
                const option = document.createElement('option');
                option.value = branch.id;
                option.textContent = branch.name;
                select.appendChild(option);
            });
            select.value = selectedBranchFilter;
        }

        function setTab(tabName) {
            currentTab = tabName;
            document.querySelectorAll('.tab-button').forEach(btn => {
                if (btn.dataset.tab === tabName) {
                    btn.classList.add('active');
                } else {
                    btn.classList.remove('active');
                }
            });
            
            selectedBranchFilter = document.getElementById('branch-filter').value;
            
            // Toggle search bar visibility
            if (tabName === 'confirmed' || tabName === 'delivered') {
                confirmedSearchArea.classList.remove('hidden');
                searchConfirmedOrders(document.getElementById('confirmed-order-search').value);
            } else {
                confirmedSearchArea.classList.add('hidden');
                renderOrderList();
            }
        }

        function renderOrderList() {
            const filteredOrders = getFilteredAndArchivedOrders();
            const totalItems = filteredOrders.length;
            
            orderListContainer.innerHTML = '';

            if (totalItems === 0) {
                noOrdersMessage.textContent = currentTab === 'requested'
                    ? 'No new delivery requests awaiting confirmation.'
                    : currentTab === 'confirmed'
                    ? 'No confirmed orders awaiting delivery.'
                    : 'No delivered orders in the 14-day archive window.';
                noOrdersMessage.classList.remove('hidden');
                return;
            }

            noOrdersMessage.classList.add('hidden');

            // Render cards based on the active tab
            filteredOrders.forEach(order => {
                if (order.status === 'requested') {
                    renderRequestedOrderCard(order);
                } else {
                    renderConfirmedOrderCard(order);
                }
            });
        }
        
        // --- SEARCH HANDLING ---
        function searchConfirmedOrders(searchTerm) {
            const query = searchTerm.trim();
            const allActiveOrders = orders.filter(order => order.status === 'confirmed' || order.status === 'delivered');

            if (query === '' || isNaN(query)) {
                renderOrderList(allActiveOrders.filter(order => order.status === currentTab));
                return;
            }

            const searchId = parseInt(query);
            const filtered = allActiveOrders.filter(order => order.id === searchId && order.status === currentTab);
            
            renderOrderList(filtered);
        }
        
        // --- CARD RENDERING ---

        function renderRequestedOrderCard(order) {
            const itemsList = order.items.map(item => `${item.name} (x${item.qty})`).join(', ');
            
            const cardHtml = `
                <div class="order-card p-4 requested-card space-y-3">
                    <div class="flex justify-between items-start border-b pb-2">
                        <h4 class="text-xl font-extrabold text-gray-900">Order #${order.id}</h4>
                        <div class="flex items-center space-x-2">
                           <span class="text-sm font-semibold text-yellow-600">${order.delivery_type}</span>
                            <button onclick="openItemDetailsModal(${order.id})" class="p-1 text-gray-500 hover:text-blue-600 transition" title="View Items">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
                            </button>
                        </div>
                    </div>
                    
                    <p class="text-sm text-gray-700">Customer: ${order.customer_name}</p>
                    <p class="text-sm text-gray-700">Delivery Location: ${order.location}</p>
                    
                    <div class="text-sm text-gray-600 border-t pt-2">
                        Items: <span>${itemsList}</span>
                    </div>

                    <div class="flex justify-end space-x-3 pt-2">
                        <button onclick="openRejectModal(${order.id})" class="py-2 px-4 text-white font-semibold rounded-lg btn-reject">Reject</button>
                        <button onclick="openDeliveryModal(${order.id})" class="py-2 px-4 text-white font-semibold rounded-lg btn-confirm">Confirm Order</button>
                    </div>
                </div>
            `;
            orderListContainer.innerHTML += cardHtml;
        }

        function renderConfirmedOrderCard(order) {
            const isDelivered = order.status === 'delivered';
            const deliveryInfo = order.delivery_date 
                ? `Delivery Date: <span class="font-bold">${order.delivery_date}</span>`
                : `Status: <span class="font-bold text-red-500">Date Pending</span>`;
            
            const statusInfo = isDelivered 
                ? `Delivered On: <span class="font-bold">${order.delivered_on}</span>`
                : deliveryInfo;
            
            const cardClass = isDelivered ? 'delivered-card' : 'confirmed-card';

            const cardHtml = `
                <div class="order-card p-4 ${cardClass} space-y-3">
                    <div class="flex justify-between items-center border-b pb-2">
                        <h4 class="text-xl font-extrabold text-gray-900">Order #${order.id}</h4>
                        <div class="flex items-center space-x-2">
                            <button onclick="openItemDetailsModal(${order.id})" class="p-1 text-gray-500 hover:text-blue-600 transition" title="View Items">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
                            </button>
                            <span class="text-sm font-semibold ${isDelivered ? 'text-blue-600' : 'text-green-600'}">${order.delivery_type}</span>
                        </div>
                    </div>
                    
                    <p class="text-sm text-gray-700">Customer: ${order.customer_name}</p>
                    <p class="text-sm text-gray-700">${statusInfo}</p>

                    <div class="flex justify-end pt-2 space-x-3">
                        ${!isDelivered ? `
                            <button onclick="showDeliveredConfirmationModal(${order.id})" class="py-2 px-4 text-white font-semibold rounded-lg btn-delivered">
                                Order Delivered
                            </button>
                        ` : ''}
                        <button onclick="openContactModal(${order.id})" class="py-2 px-4 text-white font-semibold rounded-lg btn-contact">
                            Contact Customer
                        </button>
                    </div>
                </div>
            `;
            orderListContainer.innerHTML += cardHtml;
        }
        
        // --- DELIVERY CONFIRMATION MODAL HANDLERS ---
        
        function showDeliveredConfirmationModal(orderId) {
             const order = orders.find(o => o.id === orderId);
             if (!order || order.status === 'delivered') return;
             
             document.getElementById('delivered-confirm-order-id').textContent = orderId;
             document.getElementById('delivery-confirm-ref').value = orderId;
             deliveredConfirmModal.classList.remove('hidden');
        }
        
        function closeConfirmationDeliveredModal() {
             deliveredConfirmModal.classList.add('hidden');
        }

        function executeMarkOrderDelivered() {
            const orderId = parseInt(document.getElementById('delivery-confirm-ref').value);
            const orderIndex = orders.findIndex(o => o.id === orderId);
            
            if (orderIndex !== -1) {
                // Mark the order as delivered with the current date
                orders[orderIndex].status = 'delivered';
                orders[orderIndex].delivered_on = new Date().toISOString().split('T')[0];
                
                showSnackbar(`Order #${orderId} marked as DELIVERED and moved to Archive.`, false);
            }

            closeConfirmationDeliveredModal();
            setTab('delivered');
        }


        // --- ITEM DETAILS MODAL HANDLERS ---
        
        function closeItemDetailsModal() {
            itemDetailsModal.classList.add('hidden');
        }

        function openItemDetailsModal(orderId) {
            const order = orders.find(o => o.id === orderId);
            if (!order) return;

            renderItemDetailsModal(order);
        }

        function renderItemDetailsModal(order) {
            const listContainer = document.getElementById('item-details-list');
            document.getElementById('items-order-ref').textContent = order.id;

            listContainer.innerHTML = order.items.map(item => `
                <div class="item-detail-card">
                    <p class="text-base font-bold text-gray-900">${item.name} (x${item.qty})</p>
                    <p class="text-xs text-gray-500 mb-2">${item.brand} | ${item.category}</p>
                    
                    <div class="flex flex-wrap space-x-4">
                         <span class="item-variant">Size: <span class="font-semibold">${item.size}</span></span>
                         <span class="item-variant">Color: <span class="font-semibold">${item.color}</span></span>
                    </div>
                </div>
            `).join('');

            itemDetailsModal.classList.remove('hidden');
        }

        // --- DELIVERY ACTIONS ---

        function openDeliveryModal(orderId) {
            const order = orders.find(o => o.id === orderId);
            if (!order) return;

            document.getElementById('delivery-order-ref').textContent = orderId;
            document.getElementById('delivery-order-id').value = orderId;
            
            // Set min date to today
            const today = new Date().toISOString().split('T')[0];
            deliveryDateInput.min = today;
            
            deliveryModal.classList.remove('hidden');
        }

        function closeDeliveryModal() {
            deliveryModal.classList.add('hidden');
            document.getElementById('delivery-form').reset();
        }

        function openRejectModal(orderId) {
            const order = orders.find(o => o.id === orderId);
            if (!order) return;

            document.getElementById('reject-order-ref').textContent = orderId;
            document.getElementById('reject-order-id').value = orderId;
            
            rejectModal.classList.remove('hidden');
        }

        function closeRejectModal() {
            rejectModal.classList.add('hidden');
            document.getElementById('reject-form').reset();
        }


        function openContactModal(orderId) {
            const order = orders.find(o => o.id === orderId);
            if (!order) return;

            document.getElementById('contact-order-number').textContent = orderId;
            document.getElementById('contact-customer-name').textContent = order.customer_name;
            
            const cleanPhone = formatPhoneNumber(order.phone);
            document.getElementById('contact-contact').textContent = order.phone;
            document.getElementById('contact-whatsapp-link').href = `https://wa.me/${cleanPhone}`;

            contactModal.classList.remove('hidden');
        }

        function closeContactModal() {
            contactModal.classList.add('hidden');
        }

        // --- FORM SUBMISSIONS ---
        
        document.getElementById('delivery-form').addEventListener('submit', function(event) {
            event.preventDefault();
            
            const form = event.target;
            const orderId = parseInt(form.elements.delivery_order_id.value);
            const deliveryDate = form.elements.delivery_date.value;
            
            const orderIndex = orders.findIndex(o => o.id === orderId);

            if (orderIndex !== -1) {
                // Update order status and delivery date
                orders[orderIndex].status = 'confirmed';
                orders[orderIndex].delivery_date = deliveryDate;
                
                showSnackbar(`Order #${orderId} confirmed for delivery on ${deliveryDate}.`, false);
            }

            closeDeliveryModal();
            setTab('confirmed'); 
        });
        
        document.getElementById('reject-form').addEventListener('submit', function(event) {
            event.preventDefault();
            
            const form = event.target;
            const orderId = parseInt(form.elements.reject_order_id.value);
            const rejectionReason = form.elements.reason.value;
            
            const orderIndex = orders.findIndex(o => o.id === orderId);

            if (orderIndex !== -1) {
                // Mark the order as rejected and remove it from the list
                showSnackbar(`Order #${orderId} rejected due to: ${rejectionReason.replace(/_/g, ' ')}.`, true);
                orders.splice(orderIndex, 1); 
            }

            closeRejectModal();
            setTab('requested'); 
        });


        // --- INITIALIZATION ---
        
        window.onload = () => {
            populateBranchFilterDropdown(); 
            setTab('requested');

            // Attach all modal close handlers
            deliveryModal.onclick = (e) => { if (e.target.id === 'delivery-modal-overlay') closeDeliveryModal(); };
            rejectModal.onclick = (e) => { if (e.target.id === 'reject-modal-overlay') closeRejectModal(); };
            contactModal.onclick = (e) => { if (e.target.id === 'contact-modal-overlay') closeContactModal(); };
            itemDetailsModal.onclick = (e) => { if (e.target.id === 'item-details-modal-overlay') closeItemDetailsModal(); };
            deliveredConfirmModal.onclick = (e) => { if (e.target.id === 'confirm-delivered-modal') closeConfirmationDeliveredModal(); };
        };
    </script>
</body>
</html>