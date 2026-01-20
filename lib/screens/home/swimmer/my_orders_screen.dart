<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - My Orders</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: #F7F9FB;
        }

        .tab-btn {
            position: relative;
            transition: all 0.3s ease;
        }

        .tab-btn.active {
            color: #3B82F6;
        }

        .tab-btn.active::after {
            content: '';
            position: absolute;
            bottom: -1px;
            left: 50%;
            transform: translateX(-50%);
            width: 24px;
            height: 3px;
            background-color: #3B82F6;
            border-radius: 99px;
        }

        .order-card {
            background-color: white;
            border-radius: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .order-card:active {
            transform: scale(0.98);
        }

        .status-pill {
            font-size: 10px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 4px 10px;
            border-radius: 99px;
        }

        .status-processing { background-color: #FEF3C7; color: #92400E; }
        .status-shipping { background-color: #DBEAFE; color: #1E40AF; }
        .status-delivered { background-color: #D1FAE5; color: #065F46; }
        .status-cancelled { background-color: #FEE2E2; color: #991B1B; }

        .item-preview-stack {
            display: flex;
            align-items: center;
        }

        .preview-img {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            object-fit: cover;
            border: 2px solid white;
            background-color: #F3F4F6;
            margin-right: -12px;
            box-shadow: 2px 0 5px rgba(0,0,0,0.05);
        }

        .modal-overlay {
            background-color: rgba(15, 23, 42, 0.5);
            backdrop-filter: blur(4px);
        }

        @keyframes slideUp {
            from { transform: translateY(100%); }
            to { transform: translateY(0); }
        }

        .modal-animate {
            animation: slideUp 0.4s cubic-bezier(0.16, 1, 0.3, 1);
        }
    </style>
</head>
<body class="flex flex-col min-h-screen">

    <!-- Header -->
    <header class="bg-white px-6 py-5 flex items-center space-x-4 sticky top-0 z-30 border-b border-gray-50">
        <button onclick="window.history.back()" class="p-2 hover:bg-gray-100 rounded-full transition">
            <svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15 19l-7-7 7-7"></path></svg>
        </button>
        <h1 class="text-2xl font-black text-gray-900 tracking-tight">My Orders</h1>
    </header>

    <!-- Tab Navigation -->
    <nav class="flex bg-white px-6 border-b border-gray-100 sticky top-[73px] z-20">
        <button id="tab-ongoing" onclick="switchTab('ongoing')" class="tab-btn active py-4 px-4 text-sm font-bold text-gray-400">Current</button>
        <button id="tab-history" onclick="switchTab('history')" class="tab-btn py-4 px-4 text-sm font-bold text-gray-400 ml-4">History</button>
    </nav>

    <!-- Main List Container -->
    <main id="orders-container" class="p-4 space-y-4">
        <!-- Orders will be injected here -->
    </main>

    <!-- Details Modal (Bottom Sheet Style) -->
    <div id="modal-overlay" class="fixed inset-0 z-50 flex items-end justify-center hidden modal-overlay" onclick="closeModal()">
        <div class="bg-white w-full max-w-md rounded-t-[32px] p-8 shadow-2xl modal-animate" onclick="event.stopPropagation()">
            <div class="w-12 h-1.5 bg-gray-100 rounded-full mx-auto mb-8"></div>
            <div id="modal-content" class="space-y-6">
                <!-- Content injected here -->
            </div>
        </div>
    </div>

    <script>
        // --- MOCK DATA ---
        const myOrders = [
            {
                id: 'ORD-8821',
                status: 'shipping',
                items: [
                    { name: 'Pro Racing Goggles', image: 'https://placehold.co/200x200/3b82f6/ffffff?text=Goggles', price: 39.99 },
                    { name: 'Silicone Swim Cap', image: 'https://placehold.co/200x200/111827/ffffff?text=Cap', price: 12.50 }
                ],
                total: 52.49,
                deliveryEst: 'Oct 24, 2025',
                date: 'Oct 20, 2025',
                isOngoing: true
            },
            {
                id: 'ORD-7742',
                status: 'processing',
                items: [
                    { name: 'Carbon Fiber Fins', image: 'https://placehold.co/200x200/ef4444/ffffff?text=Fins', price: 120.00 }
                ],
                total: 120.00,
                deliveryEst: 'Oct 28, 2025',
                date: 'Oct 21, 2025',
                isOngoing: true
            },
            {
                id: 'ORD-5510',
                status: 'delivered',
                items: [
                    { name: 'Training Kickboard', image: 'https://placehold.co/200x200/f59e0b/ffffff?text=Board', price: 25.00 },
                    { name: 'Nose Clip', image: 'https://placehold.co/200x200/94a3b8/ffffff?text=Clip', price: 5.00 }
                ],
                total: 30.00,
                deliveryEst: 'Completed',
                date: 'Sep 12, 2025',
                isOngoing: false
            }
        ];

        let currentTab = 'ongoing';

        // --- Core Functions ---

        function switchTab(tab) {
            currentTab = tab;
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active', 'text-blue-600'));
            document.getElementById(`tab-${tab}`).classList.add('active');
            renderOrders();
        }

        function renderOrders() {
            const container = document.getElementById('orders-container');
            const filtered = myOrders.filter(o => o.isOngoing === (currentTab === 'ongoing'));

            if (filtered.length === 0) {
                container.innerHTML = `
                    <div class="py-20 text-center">
                        <p class="text-gray-400 font-medium italic">No orders found here.</p>
                    </div>`;
                return;
            }

            container.innerHTML = filtered.map(order => `
                <div class="order-card p-5 border border-gray-50 flex flex-col cursor-pointer" onclick="openDetails('${order.id}')">
                    <div class="flex justify-between items-start mb-4">
                        <div>
                            <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest">${order.date}</p>
                            <h3 class="text-base font-extrabold text-gray-900">${order.id}</h3>
                        </div>
                        <span class="status-pill status-${order.status}">${order.status}</span>
                    </div>

                    <div class="flex items-center justify-between">
                        <div class="flex items-center">
                            <div class="item-preview-stack mr-6">
                                ${order.items.slice(0, 3).map(i => `<img src="${i.image}" class="preview-img">`).join('')}
                            </div>
                            <div>
                                <p class="text-sm font-bold text-gray-800">${order.items[0].name}</p>
                                <p class="text-xs text-gray-400">${order.items.length > 1 ? `+ ${order.items.length - 1} other items` : 'Single Item'}</p>
                            </div>
                        </div>
                        <div class="text-right">
                            <p class="text-lg font-black text-blue-600">$${order.total.toFixed(2)}</p>
                        </div>
                    </div>

                    <div class="mt-6 pt-4 border-t border-gray-50 flex items-center justify-between">
                        <div class="flex items-center text-xs font-semibold text-gray-500">
                            <svg class="w-4 h-4 mr-1.5 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            ${order.status === 'delivered' ? 'Delivered' : `Delivery: ${order.deliveryEst}`}
                        </div>
                        <svg class="w-5 h-5 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 5l7 7-7 7"></path></svg>
                    </div>
                </div>
            `).join('');
        }

        // --- Modal Logic ---

        function openDetails(orderId) {
            const order = myOrders.find(o => o.id === orderId);
            const content = document.getElementById('modal-content');
            
            content.innerHTML = `
                <div class="flex justify-between items-start">
                    <div>
                        <span class="status-pill status-${order.status}">${order.status}</span>
                        <h2 class="text-2xl font-black text-gray-900 mt-2">${order.id}</h2>
                        <p class="text-sm text-gray-400 font-medium">Placed on ${order.date}</p>
                    </div>
                    <div class="text-right">
                        <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Total</p>
                        <p class="text-2xl font-black text-blue-600">$${order.total.toFixed(2)}</p>
                    </div>
                </div>

                <div class="space-y-3">
                    <h4 class="text-xs font-black text-gray-400 uppercase tracking-[0.2em]">Items Ordered</h4>
                    <div class="space-y-2">
                        ${order.items.map(item => `
                            <div class="flex items-center justify-between p-3 bg-gray-50 rounded-2xl border border-gray-100">
                                <div class="flex items-center space-x-3">
                                    <img src="${item.image}" class="w-10 h-10 rounded-lg object-cover">
                                    <span class="text-sm font-bold text-gray-800">${item.name}</span>
                                </div>
                                <span class="text-sm font-black text-gray-500">$${item.price.toFixed(2)}</span>
                            </div>
                        `).join('')}
                    </div>
                </div>

                ${order.isOngoing ? `
                    <div class="pt-4 space-y-3">
                        <button onclick="showTrackAlert()" class="w-full py-4 bg-blue-600 text-white rounded-[20px] font-black shadow-xl shadow-blue-100 active:scale-95 transition">
                            Track Order Status
                        </button>
                        <button onclick="closeModal()" class="w-full py-4 text-gray-400 font-bold text-sm">Close Details</button>
                    </div>
                ` : `
                    <div class="pt-4 space-y-3">
                        <button onclick="showReorderAlert()" class="w-full py-4 border-2 border-blue-600 text-blue-600 rounded-[20px] font-black active:scale-95 transition">
                            Reorder Items
                        </button>
                        <button onclick="closeModal()" class="w-full py-4 text-gray-400 font-bold text-sm">Dismiss</button>
                    </div>
                `}
            `;

            document.getElementById('modal-overlay').classList.remove('hidden');
        }

        function closeModal() {
            document.getElementById('modal-overlay').classList.add('hidden');
        }

        function showTrackAlert() {
            showSnackbar("Tracking service unavailable in preview.");
        }

        function showReorderAlert() {
            showSnackbar("Items added to cart!");
        }

        function showSnackbar(message) {
            const snackbar = document.createElement('div');
            snackbar.textContent = message;
            snackbar.className = `fixed bottom-10 left-1/2 -translate-x-1/2 px-8 py-4 rounded-3xl shadow-2xl text-white bg-gray-900 font-black text-sm transition-all animate-bounce z-[100]`;
            document.body.appendChild(snackbar);
            setTimeout(() => snackbar.remove(), 2500);
        }

        // --- Init ---
        window.onload = renderOrders;
    </script>
</body>
</html>