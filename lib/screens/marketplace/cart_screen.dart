<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <title>Swim 360 - My Cart</title>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F8FAFC; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
        .animate-in { animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .shadow-soft { box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 10px 10px -5px rgba(0, 0, 0, 0.02); }
    </style>
</head>
<body class="flex flex-col min-h-screen no-scrollbar">

    <header class="bg-white/90 backdrop-blur-md px-6 pt-12 pb-5 flex items-center justify-between sticky top-0 z-30 border-b border-gray-50">
        <div class="flex items-center space-x-4">
            <button onclick="window.history.back()" class="p-2.5 rounded-2xl border border-gray-100 bg-white text-gray-900 shadow-sm active:scale-90 transition-all">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><polyline points="15 18 9 12 15 6"></polyline></svg>
            </button>
            <div>
                <h1 class="text-2xl font-black text-gray-900 tracking-tight uppercase leading-none">My Cart</h1>
                <p id="cart-count-header" class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mt-1">Items Selected</p>
            </div>
        </div>
        <button onclick="clearCart()" class="text-[10px] font-black text-rose-500 uppercase tracking-widest bg-rose-50 px-3 py-2 rounded-xl active:scale-90 transition-all">Clear All</button>
    </header>

    <main class="flex-grow p-6 space-y-6 animate-in text-left">
        
        <div id="cart-items-container" class="space-y-4">
            </div>

        <div id="promo-section" class="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-4">
            <div class="flex items-center space-x-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"></path><line x1="7" y1="7" x2="7.01" y2="7"></line></svg>
                <h3 class="text-xs font-black text-gray-400 uppercase tracking-widest">Offers & Coupons</h3>
            </div>
            <div class="flex space-x-2">
                <input type="text" id="promo-input" placeholder="SWIM10" 
                    class="flex-grow p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold uppercase focus:ring-2 focus:ring-blue-500 outline-none shadow-inner transition-all">
                <button onclick="applyPromo()" class="px-6 bg-gray-900 text-white rounded-2xl text-[10px] font-black uppercase tracking-widest active:scale-95 transition-all shadow-lg">Apply</button>
            </div>
            <p id="promo-message" class="text-[10px] font-black uppercase tracking-widest hidden"></p>
        </div>

        <div id="summary-section" class="bg-white p-6 rounded-[32px] shadow-soft border border-gray-100 space-y-5">
            <h2 class="text-xs font-black text-gray-400 uppercase tracking-[0.2em] border-b border-gray-50 pb-3">Order Summary</h2>
            
            <div class="space-y-3">
                <div class="flex justify-between items-center">
                    <span class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Subtotal</span>
                    <span id="subtotal" class="text-sm font-black text-gray-800">$0.00</span>
                </div>
                <div class="flex justify-between items-center">
                    <span class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Delivery Fees</span>
                    <span class="text-sm font-black text-emerald-500 uppercase tracking-tighter">Free</span>
                </div>
                <div class="flex justify-between items-center">
                    <span class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Service Fees</span>
                    <span id="service-fees" class="text-sm font-black text-gray-800">$2.50</span>
                </div>
                <div id="promo-discount-row" class="hidden justify-between items-center">
                    <span class="text-[10px] font-black text-blue-600 uppercase tracking-widest">Discount (10%)</span>
                    <span id="promo-discount-val" class="text-sm font-black text-blue-600">-$0.00</span>
                </div>
                
                <div class="flex justify-between items-end pt-4 border-t border-gray-50">
                    <div>
                        <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Total Price</p>
                        <p id="grand-total" class="text-4xl font-black text-gray-900 tracking-tighter leading-none">$0.00</p>
                    </div>
                    <button onclick="proceedToCheckout()" class="bg-blue-600 text-white px-8 py-4 rounded-[24px] font-black text-xs uppercase tracking-widest shadow-xl shadow-blue-600/20 active:scale-95 transition-all">
                        Checkout
                    </button>
                </div>
            </div>
        </div>

        <div id="empty-state" class="hidden flex-col items-center justify-center py-20 text-center animate-in">
            <div class="w-24 h-24 bg-blue-50 rounded-[40px] flex items-center justify-center mb-6 shadow-inner">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-12 h-12 text-blue-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"/><path d="M3 6h18"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
            </div>
            <h2 class="text-2xl font-black text-gray-900 uppercase tracking-tight">Cart is Empty</h2>
            <button onclick="location.reload()" class="bg-blue-600 text-white px-10 py-5 rounded-[24px] font-black text-sm uppercase tracking-widest shadow-xl active:scale-95 transition-all mt-8">Start Shopping</button>
        </div>

    </main>

    <script>
        let cartItems = [
            { id: 'c1', name: 'Pro Racing Goggles', brand: 'Speedo', price: 39.99, size: 'Adult', color: 'Blue', quantity: 1, image: 'https://images.unsplash.com/photo-1552650272-b8a34e21bc4b?q=80&w=400&auto=format&fit=crop' },
            { id: 'c2', name: 'Silicone Swim Cap', brand: 'Arena', price: 12.50, size: 'One Size', color: 'Black', quantity: 2, image: 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?q=80&w=400&auto=format&fit=crop' }
        ];

        const SERVICE_FEE_VAL = 2.50;
        let discountPercent = 0;

        function renderCart() {
            const container = document.getElementById('cart-items-container');
            const summary = document.getElementById('summary-section');
            const promo = document.getElementById('promo-section');
            const emptyState = document.getElementById('empty-state');
            const headerCount = document.getElementById('cart-count-header');

            if (cartItems.length === 0) {
                container.classList.add('hidden'); summary.classList.add('hidden');
                promo.classList.add('hidden'); emptyState.classList.remove('hidden');
                headerCount.textContent = "0 Items";
                return;
            }

            container.classList.remove('hidden'); summary.classList.remove('hidden');
            promo.classList.remove('hidden'); emptyState.classList.add('hidden');
            headerCount.textContent = `${cartItems.length} Items Selected`;

            container.innerHTML = cartItems.map(item => `
                <div class="bg-white p-4 rounded-[32px] flex space-x-4 border border-gray-50 shadow-sm animate-in">
                    <div class="w-24 h-24 rounded-[24px] bg-gray-100 overflow-hidden shadow-inner flex-shrink-0">
                        <img src="${item.image}" alt="${item.name}" class="w-full h-full object-cover">
                    </div>
                    
                    <div class="flex-grow flex flex-col justify-between py-1">
                        <div>
                            <div class="flex justify-between items-start">
                                <h3 class="font-black text-gray-900 text-lg leading-tight uppercase tracking-tighter">${item.name}</h3>
                                <button onclick="removeItem('${item.id}')" class="p-1 text-gray-300 hover:text-rose-500 transition-colors">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M3 6h18m-2 0v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6m3 0V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/></svg>
                                </button>
                            </div>
                            <p class="text-[9px] font-black text-blue-600 uppercase tracking-widest mt-1">${item.brand} • ${item.size}</p>
                        </div>

                        <div class="flex justify-between items-center">
                            <span class="text-xl font-black text-gray-900 tracking-tighter">$${item.price.toFixed(2)}</span>
                            
                            <div class="flex items-center space-x-3 bg-gray-50 rounded-2xl p-1 border border-gray-100 shadow-inner">
                                <button onclick="updateQty('${item.id}', -1)" class="w-8 h-8 rounded-xl bg-white flex items-center justify-center font-black text-gray-900 shadow-sm active:scale-90 transition-all">-</button>
                                <span class="font-black text-xs text-gray-900 min-w-[12px] text-center">${item.quantity}</span>
                                <button onclick="updateQty('${item.id}', 1)" class="w-8 h-8 rounded-xl bg-white flex items-center justify-center font-black text-gray-900 shadow-sm active:scale-90 transition-all">+</button>
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
            const total = (subtotal + SERVICE_FEE_VAL) - discountAmount;

            document.getElementById('subtotal').textContent = `$${subtotal.toFixed(2)}`;
            document.getElementById('grand-total').textContent = `$${total.toFixed(2)}`;
            
            const promoRow = document.getElementById('promo-discount-row');
            if (discountAmount > 0) {
                promoRow.classList.remove('hidden'); promoRow.classList.add('flex');
                document.getElementById('promo-discount-val').textContent = `-$${discountAmount.toFixed(2)}`;
            } else {
                promoRow.classList.add('hidden'); promoRow.classList.remove('flex');
            }
        }

        function applyPromo() {
            const code = document.getElementById('promo-input').value.trim().toUpperCase();
            const msg = document.getElementById('promo-message');
            if (code === 'SWIM10') {
                discountPercent = 10;
                msg.textContent = '10% Discount Applied!';
                msg.className = 'text-[10px] font-black uppercase tracking-widest text-emerald-500';
            } else {
                discountPercent = 0;
                msg.textContent = 'Invalid Code';
                msg.className = 'text-[10px] font-black uppercase tracking-widest text-rose-500';
            }
            msg.classList.remove('hidden');
            calculateTotals();
        }

        function updateQty(id, change) {
            const item = cartItems.find(i => i.id === id);
            if (item) {
                item.quantity += change;
                if (item.quantity < 1) removeItem(id);
                else renderCart();
            }
        }

        function removeItem(id) {
            cartItems = cartItems.filter(i => i.id !== id);
            renderCart();
        }

        function clearCart() {
            cartItems = []; renderCart();
        }

        function proceedToCheckout() {
            window.location.href = 'checkout_screen.html';
        }

        window.onload = renderCart;
    </script>
</body>
</html>