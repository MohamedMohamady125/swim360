<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - My Cart</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
        body {
            font-family: 'Inter', sans-serif;
            background-color: #F7F9FB;
        }
        .item-card {
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .summary-card {
            background-color: white;
            border-radius: 24px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }
        .qty-btn {
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            background-color: #F3F4F6;
            color: #1F2937;
            font-weight: bold;
            transition: background-color 0.2s;
        }
        .qty-btn:hover {
            background-color: #E5E7EB;
        }
        .btn-primary {
            background-color: #3B82F6;
            color: white;
            transition: all 0.2s;
        }
        .btn-primary:hover {
            background-color: #2563EB;
            transform: translateY(-1px);
        }
        .item-image {
            width: 90px;
            height: 90px;
            border-radius: 12px;
            object-fit: cover;
            background-color: #F3F4F6;
        }
        .promo-input:focus {
            outline: none;
            border-color: #3B82F6;
        }
    </style>
</head>
<body class="flex flex-col min-h-screen">

    <!-- Header -->
    <header class="bg-white px-4 py-4 flex items-center justify-between sticky top-0 z-10 border-b border-gray-100">
        <div class="flex items-center space-x-3">
            <button onclick="window.history.back()" class="p-2 hover:bg-gray-100 rounded-full transition">
                <svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
            </button>
            <h1 class="text-xl font-bold text-gray-800">My Cart</h1>
        </div>
        <button onclick="clearCart()" class="text-sm font-medium text-red-500 hover:text-red-600 transition">Clear All</button>
    </header>

    <!-- Main Content -->
    <main class="flex-grow p-4 space-y-6">
        
        <!-- Cart Items List -->
        <div id="cart-items-container" class="space-y-4">
            <!-- Items will be injected here -->
        </div>

        <!-- Promo Code Box -->
        <div id="promo-section" class="bg-white p-4 rounded-2xl border border-gray-100 shadow-sm space-y-3">
            <label class="text-sm font-bold text-gray-700 block">Promo Code</label>
            <div class="flex space-x-2">
                <input type="text" id="promo-input" placeholder="Enter code (Try SWIM10)" 
                    class="flex-grow px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl text-sm promo-input uppercase font-semibold">
                <button onclick="applyPromo()" class="px-6 py-3 bg-gray-800 text-white rounded-xl text-sm font-bold hover:bg-black transition">Apply</button>
            </div>
            <p id="promo-message" class="text-xs font-medium hidden"></p>
        </div>

        <!-- Summary Section (Now positioned after products) -->
        <div id="summary-section" class="summary-card p-6 space-y-4 border border-gray-100">
            <h2 class="text-lg font-bold text-gray-800 border-b border-gray-50 pb-2">Order Summary</h2>
            <div class="space-y-3">
                <div class="flex justify-between text-gray-500 text-sm">
                    <span>Subtotal</span>
                    <span id="subtotal" class="font-semibold text-gray-700">$0.00</span>
                </div>
                <div class="flex justify-between text-gray-500 text-sm">
                    <span>Delivery Fee</span>
                    <span id="delivery-fee" class="font-semibold text-gray-700">$5.00</span>
                </div>
                <div class="flex justify-between text-gray-500 text-sm">
                    <span>Service Fee</span>
                    <span id="service-fee" class="font-semibold text-gray-700">$2.50</span>
                </div>
                <div id="promo-discount-row" class="flex justify-between text-green-600 text-sm hidden">
                    <span>Discount</span>
                    <span id="promo-discount-val">-$0.00</span>
                </div>
                <div class="flex justify-between items-center pt-4 border-t border-gray-100">
                    <span class="text-lg font-bold text-gray-800">Total</span>
                    <span id="grand-total" class="text-2xl font-extrabold text-blue-600">$0.00</span>
                </div>
            </div>
            
            <button onclick="proceedToCheckout()" class="w-full py-4 btn-primary rounded-2xl font-extrabold text-lg shadow-xl flex items-center justify-center space-x-3 mt-4">
                <span>Proceed to Checkout</span>
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"></path></svg>
            </button>
        </div>

        <!-- Empty State (Hidden by default) -->
        <div id="empty-state" class="hidden flex-col items-center justify-center py-20 text-center">
            <div class="bg-blue-50 p-6 rounded-full mb-4">
                <svg class="w-16 h-16 text-blue-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
            </div>
            <h2 class="text-xl font-bold text-gray-800">Your cart is empty</h2>
            <p class="text-gray-500 mt-2 mb-6">Looks like you haven't added any gear yet.</p>
            <button onclick="location.href='index.html'" class="px-8 py-3 btn-primary rounded-xl font-bold shadow-lg">Start Shopping</button>
        </div>

    </main>

    <script>
        // --- MOCK CART DATA ---
        let cartItems = [
            {
                id: 'c1',
                name: 'Pro Racing Goggles',
                brand: 'Speedo',
                price: 39.99,
                size: 'Adult',
                color: 'Blue',
                quantity: 1,
                image: 'https://placehold.co/200x200/3b82f6/ffffff?text=Goggles'
            },
            {
                id: 'c2',
                name: 'Silicone Swim Cap',
                brand: 'Arena',
                price: 12.50,
                size: 'One Size',
                color: 'Black',
                quantity: 2,
                image: 'https://placehold.co/200x200/111827/ffffff?text=Cap'
            },
            {
                id: 'c3',
                name: 'Training Pull Buoy',
                brand: 'TYR',
                price: 18.00,
                size: 'Standard',
                color: 'Yellow',
                quantity: 1,
                image: 'https://placehold.co/200x200/fbbf24/ffffff?text=Buoy'
            }
        ];

        const DELIVERY_FEE = 5.00;
        const SERVICE_FEE = 2.50;
        let discountPercent = 0;

        // --- Render Functions ---

        function renderCart() {
            const container = document.getElementById('cart-items-container');
            const summary = document.getElementById('summary-section');
            const promo = document.getElementById('promo-section');
            const emptyState = document.getElementById('empty-state');

            if (cartItems.length === 0) {
                container.classList.add('hidden');
                summary.classList.add('hidden');
                promo.classList.add('hidden');
                emptyState.classList.remove('hidden');
                return;
            }

            container.classList.remove('hidden');
            summary.classList.remove('hidden');
            promo.classList.remove('hidden');
            emptyState.classList.add('hidden');

            container.innerHTML = cartItems.map(item => `
                <div class="item-card p-4 flex space-x-4 border border-gray-50 transition-all duration-200">
                    <img src="${item.image}" alt="${item.name}" class="item-image">
                    
                    <div class="flex-grow flex flex-col justify-between">
                        <div>
                            <div class="flex justify-between items-start">
                                <h3 class="font-bold text-gray-800 text-base leading-tight">${item.name}</h3>
                                <button onclick="removeItem('${item.id}')" class="text-gray-400 hover:text-red-500 transition">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-4v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
                                </button>
                            </div>
                            <p class="text-xs text-gray-400 font-medium uppercase tracking-wider">${item.brand}</p>
                            <div class="flex flex-wrap gap-2 mt-2">
                                <span class="text-[10px] uppercase font-bold text-gray-500 bg-gray-100 px-2 py-1 rounded">Size: ${item.size}</span>
                                <span class="text-[10px] uppercase font-bold text-gray-500 bg-gray-100 px-2 py-1 rounded">Color: ${item.color}</span>
                            </div>
                        </div>

                        <div class="flex justify-between items-end mt-3">
                            <span class="text-lg font-extrabold text-blue-600">$${item.price.toFixed(2)}</span>
                            
                            <div class="flex items-center space-x-4 bg-gray-50 rounded-xl p-1 px-2 border border-gray-100">
                                <button onclick="updateQty('${item.id}', -1)" class="qty-btn">-</button>
                                <span class="font-bold text-gray-700 w-4 text-center">${item.quantity}</span>
                                <button onclick="updateQty('${item.id}', 1)" class="qty-btn">+</button>
                            </div>
                        </div>
                    </div>
                </div>
            `).join('');

            calculateTotals();
        }

        function calculateTotals() {
            const subtotal = cartItems.reduce((acc, item) => acc + (item.price * item.quantity), 0);
            const discountAmount = subtotal * (discountPercent / 100);
            const total = subtotal + DELIVERY_FEE + SERVICE_FEE - discountAmount;

            document.getElementById('subtotal').textContent = `$${subtotal.toFixed(2)}`;
            document.getElementById('grand-total').textContent = `$${total.toFixed(2)}`;
            
            if (discountAmount > 0) {
                document.getElementById('promo-discount-row').classList.remove('hidden');
                document.getElementById('promo-discount-val').textContent = `-$${discountAmount.toFixed(2)}`;
            } else {
                document.getElementById('promo-discount-row').classList.add('hidden');
            }
        }

        // --- Actions ---

        function applyPromo() {
            const code = document.getElementById('promo-input').value.trim().toUpperCase();
            const msg = document.getElementById('promo-message');
            
            if (code === 'SWIM10') {
                discountPercent = 10;
                msg.textContent = 'Promo code applied! 10% off gear.';
                msg.className = 'text-xs font-medium text-green-600';
                msg.classList.remove('hidden');
                showSnackbar("Discount applied!");
            } else {
                discountPercent = 0;
                msg.textContent = 'Invalid promo code.';
                msg.className = 'text-xs font-medium text-red-500';
                msg.classList.remove('hidden');
            }
            calculateTotals();
        }

        function updateQty(id, change) {
            const item = cartItems.find(i => i.id === id);
            if (item) {
                item.quantity += change;
                if (item.quantity < 1) {
                    removeItem(id);
                } else {
                    renderCart();
                }
            }
        }

        function removeItem(id) {
            cartItems = cartItems.filter(i => i.id !== id);
            renderCart();
            showSnackbar("Item removed.");
        }

        function clearCart() {
            cartItems = [];
            discountPercent = 0;
            renderCart();
            showSnackbar("Cart cleared.");
        }

        function proceedToCheckout() {
            const total = document.getElementById('grand-total').textContent;
            showSnackbar(`Redirecting to payment... Total: ${total}`, false);
        }

        function showSnackbar(message, isError = false) {
            const snackbar = document.createElement('div');
            snackbar.textContent = message;
            snackbar.className = `fixed top-6 left-1/2 -translate-x-1/2 px-6 py-3 rounded-xl shadow-2xl text-white ${isError ? 'bg-red-500' : 'bg-blue-600'} z-[100] font-medium transition-all animate-bounce`;
            document.body.appendChild(snackbar);
            setTimeout(() => {
                snackbar.remove();
            }, 3000);
        }

        // --- Init ---
        window.onload = renderCart;
    </script>
</body>
</html>