<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - Checkout</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Leaflet CSS for the real map -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
        @import url('https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@500&display=swap');

        body {
            font-family: 'Inter', sans-serif;
            background-color: #F7F9FB;
        }
        .section-card {
            background-color: white;
            border-radius: 24px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .input-field {
            @apply px-4 py-3 bg-gray-50 border border-gray-100 rounded-xl text-sm focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500 transition-all w-full;
        }
        #map {
            height: 250px;
            border-radius: 20px;
            z-index: 10;
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
        .payment-card {
            border: 2px solid transparent;
            transition: all 0.2s;
        }
        .payment-card.active {
            border-color: #3B82F6;
            background-color: #eff6ff;
        }

        /* Real Visual Credit Card UI */
        .card-visual {
            width: 100%;
            max-width: 320px;
            height: 190px;
            border-radius: 16px;
            position: relative;
            color: white;
            padding: 20px;
            background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
            transition: all 0.5s ease;
            box-shadow: 0 10px 20px rgba(0,0,0,0.15);
            margin: 0 auto 1.5rem;
            font-family: 'JetBrains+Mono', monospace;
        }
        .card-visual.visa {
            background: linear-gradient(135deg, #1a1f71 0%, #2b3a8c 100%);
        }
        .card-visual.mastercard {
            background: linear-gradient(135deg, #eb001b 0%, #ff5f00 100%);
        }
        .chip {
            width: 40px;
            height: 30px;
            background: linear-gradient(135deg, #ffd700 0%, #eab308 100%);
            border-radius: 6px;
            margin-bottom: 25px;
        }
        .card-number-display {
            font-size: 1.2rem;
            letter-spacing: 2px;
            margin-bottom: 20px;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.3);
        }
        .card-info-row {
            display: flex;
            justify-content: space-between;
            text-transform: uppercase;
        }
        .card-label {
            font-size: 0.6rem;
            opacity: 0.7;
            margin-bottom: 4px;
        }
        .card-value {
            font-size: 0.8rem;
        }
        .card-logo {
            position: absolute;
            top: 20px;
            right: 20px;
            height: 30px;
        }
    </style>
</head>
<body class="pb-10">

    <!-- Header -->
    <header class="bg-white px-4 py-4 flex items-center space-x-4 sticky top-0 z-30 border-b border-gray-100">
        <button onclick="window.history.back()" class="p-2 hover:bg-gray-100 rounded-full transition">
            <svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
        </button>
        <h1 class="text-xl font-extrabold text-gray-800">Checkout</h1>
    </header>

    <main class="max-w-xl mx-auto p-4">
        
        <!-- Step 1: Real Map Location Selection -->
        <section class="section-card">
            <h2 class="text-lg font-bold text-gray-800 mb-4 flex items-center">
                <svg class="w-5 h-5 mr-2 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.828 0l-4.243-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                Exact Location
            </h2>
            <div id="map" class="mb-3"></div>
            <p class="text-xs text-gray-400 text-center">Drag the map to position the pin at your building.</p>
        </section>

        <!-- Step 2: Delivery Address Form -->
        <section class="section-card">
            <h2 class="text-lg font-bold text-gray-800 mb-4 flex items-center">
                <svg class="w-5 h-5 mr-2 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path></svg>
                Delivery Address
            </h2>
            
            <div class="space-y-4">
                <div>
                    <label class="text-xs font-bold text-gray-500 uppercase ml-1">Governorate</label>
                    <select id="governorate" class="input-field appearance-none bg-no-repeat bg-right mt-1" style="background-image: url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%2224%22%20height%3D%2224%22%20viewBox%3D%220%200%2024%2024%22%20fill%3D%22none%22%20stroke%3D%22%239CA3AF%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%20stroke-linejoin%3D%22round%22%3E%3Cpolyline%20points%3D%226%209%2012%2015%2018%209%22%3E%3C%2Fpolyline%3E%3C%2Fsvg%3E'); background-position: right 1rem center; background-size: 1.2rem;">
                        <option value="" disabled selected>Select Governorate</option>
                        <option value="cairo">Cairo</option>
                        <option value="giza">Giza</option>
                        <option value="alexandria">Alexandria</option>
                        <option value="dakahlia">Dakahlia</option>
                        <option value="redsea">Red Sea</option>
                    </select>
                </div>

                <div>
                    <label class="text-xs font-bold text-gray-500 uppercase ml-1">City</label>
                    <input type="text" id="city" placeholder="e.g., Maadi" class="input-field mt-1">
                </div>

                <div>
                    <label class="text-xs font-bold text-gray-500 uppercase ml-1">Detailed Address</label>
                    <input type="text" id="address" placeholder="Bldg. No, Street name, Apartment..." class="input-field mt-1">
                </div>
            </div>
        </section>

        <!-- Step 3: Delivery Time -->
        <section class="section-card bg-blue-50 border border-blue-100 flex items-center justify-between">
            <div class="flex items-center space-x-3">
                <div class="bg-blue-600 p-2 rounded-lg">
                    <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                </div>
                <div>
                    <p class="text-xs font-bold text-blue-800 uppercase">Estimated Delivery</p>
                    <p class="text-sm font-semibold text-blue-900">Today, 4:00 PM - 6:00 PM</p>
                </div>
            </div>
            <span class="text-[10px] bg-blue-200 text-blue-800 px-2 py-1 rounded font-extrabold">FAST</span>
        </section>

        <!-- Step 4: Payment Methods -->
        <section class="section-card">
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-lg font-bold text-gray-800 flex items-center">
                    <svg class="w-5 h-5 mr-2 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a2 2 0 002-2V7a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                    Payment Methods
                </h2>
                <button id="add-card-toggle" onclick="toggleCardForm()" class="text-xs font-bold text-blue-600 transition-all hover:scale-105">+ Add Card</button>
            </div>

            <!-- Existing Cards & Options -->
            <div id="payment-options" class="space-y-3 mb-6 transition-all duration-300">
                <div class="payment-card active p-4 rounded-2xl bg-gray-50 flex items-center justify-between cursor-pointer" onclick="selectPayment(this, 'visa')">
                    <div class="flex items-center space-x-3">
                        <div class="bg-white p-2 rounded-lg border border-gray-100 flex items-center">
                             <svg class="w-8 h-5" viewBox="0 0 24 24"><path d="M10 8h4v8h-4z" fill="#1a1f71"/><rect width="24" height="24" rx="2" fill="none"/></svg>
                             <span class="text-[10px] font-black text-[#1a1f71]">VISA</span>
                        </div>
                        <div>
                            <p class="text-sm font-bold text-gray-800">Visa ending in 4242</p>
                            <p class="text-[10px] text-gray-400 uppercase font-semibold">Expires 12/26</p>
                        </div>
                    </div>
                    <div class="selection-circle w-5 h-5 rounded-full border-2 border-blue-600 flex items-center justify-center p-1">
                        <div class="w-full h-full bg-blue-600 rounded-full"></div>
                    </div>
                </div>

                <div class="payment-card p-4 bg-gray-50 rounded-2xl flex items-center justify-between cursor-pointer" onclick="selectPayment(this, 'cash')">
                    <div class="flex items-center space-x-3 text-gray-500">
                        <div class="bg-white p-2 rounded-lg border border-gray-100">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                        </div>
                        <p class="text-sm font-bold">Cash on Delivery</p>
                    </div>
                    <div class="selection-circle w-5 h-5 rounded-full border-2 border-gray-300"></div>
                </div>
            </div>

            <!-- Add Card Form (Interactive UI) -->
            <div id="add-card-ui" class="hidden animate-fadeIn">
                <div class="border-t border-gray-100 pt-6">
                    <!-- The Visual Card -->
                    <div id="card-preview" class="card-visual">
                        <div class="chip"></div>
                        <div id="preview-logo" class="card-logo flex items-center font-black text-xl italic">CARD</div>
                        <div id="preview-number" class="card-number-display">•••• •••• •••• ••••</div>
                        <div class="card-info-row">
                            <div>
                                <div class="card-label">Card Holder</div>
                                <div id="preview-name" class="card-value">YOUR NAME</div>
                            </div>
                            <div>
                                <div class="card-label">Expires</div>
                                <div id="preview-expiry" class="card-value">MM/YY</div>
                            </div>
                        </div>
                    </div>

                    <!-- Input Fields -->
                    <div class="space-y-4">
                        <div>
                            <label class="text-[10px] font-bold text-gray-400 uppercase ml-1">Card Number</label>
                            <input type="text" id="card-number-input" maxlength="19" placeholder="4000 0000 0000 0000" class="input-field mt-1" oninput="updateCardUI()">
                        </div>
                        <div>
                            <label class="text-[10px] font-bold text-gray-400 uppercase ml-1">Card Holder Name</label>
                            <input type="text" id="card-name-input" placeholder="FULL NAME" class="input-field mt-1 uppercase" oninput="updateCardUI()">
                        </div>
                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label class="text-[10px] font-bold text-gray-400 uppercase ml-1">Expiry Date</label>
                                <input type="text" id="card-expiry-input" maxlength="5" placeholder="MM/YY" class="input-field mt-1" oninput="updateCardUI()">
                            </div>
                            <div>
                                <label class="text-[10px] font-bold text-gray-400 uppercase ml-1">CVV</label>
                                <input type="password" maxlength="3" placeholder="***" class="input-field mt-1">
                            </div>
                        </div>
                        <button onclick="saveCard()" class="w-full py-3 bg-gray-900 text-white rounded-xl text-sm font-bold mt-2 shadow-lg">Save & Use Card</button>
                    </div>
                </div>
            </div>
        </section>

        <!-- Final Order Button -->
        <div class="mt-8 space-y-4">
            <div class="flex justify-between items-center px-4">
                <span class="text-gray-500 font-medium">Total Amount</span>
                <span class="text-3xl font-black text-gray-900">$75.49</span>
            </div>
            <button onclick="placeOrder()" class="w-full py-4 btn-primary rounded-2xl font-extrabold text-lg shadow-2xl flex items-center justify-center space-x-3">
                <span>Place Order</span>
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
            </button>
        </div>

    </main>

    <!-- Leaflet Script for Map -->
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        // --- MAP INITIALIZATION ---
        let map, marker;
        function initMap() {
            // Default center (e.g., Cairo)
            const defaultPos = [30.0444, 31.2357];
            map = L.map('map').setView(defaultPos, 13);

            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; OpenStreetMap'
            }).addTo(map);

            // Centered pin
            marker = L.marker(defaultPos, { draggable: true }).addTo(map);

            map.on('move', function () {
                marker.setLatLng(map.getCenter());
            });

            marker.on('dragend', function (event) {
                const position = marker.getLatLng();
                console.log("New Position:", position.lat, position.lng);
                showSnackbar(`Location set: ${position.lat.toFixed(4)}, ${position.lng.toFixed(4)}`);
            });
        }

        // --- PAYMENT & CARD LOGIC ---
        function toggleCardForm() {
            const form = document.getElementById('add-card-ui');
            const options = document.getElementById('payment-options');
            const toggleBtn = document.getElementById('add-card-toggle');
            
            if (form.classList.contains('hidden')) {
                form.classList.remove('hidden');
                options.classList.add('opacity-50', 'pointer-events-none');
                toggleBtn.textContent = 'Cancel';
            } else {
                form.classList.add('hidden');
                options.classList.remove('opacity-50', 'pointer-events-none');
                toggleBtn.textContent = '+ Add Card';
            }
        }

        function updateCardUI() {
            const number = document.getElementById('card-number-input');
            const name = document.getElementById('card-name-input');
            const expiry = document.getElementById('card-expiry-input');
            
            const previewNum = document.getElementById('preview-number');
            const previewName = document.getElementById('preview-name');
            const previewExpiry = document.getElementById('preview-expiry');
            const previewCard = document.getElementById('card-preview');
            const previewLogo = document.getElementById('preview-logo');

            // Format number with spaces
            let val = number.value.replace(/\D/g, '');
            let formatted = val.match(/.{1,4}/g)?.join(' ') || '';
            number.value = formatted;

            // Detect Card Type
            if (val.startsWith('4')) {
                previewCard.className = 'card-visual visa';
                previewLogo.innerHTML = 'VISA';
            } else if (val.startsWith('5')) {
                previewCard.className = 'card-visual mastercard';
                previewLogo.innerHTML = 'MasterCard';
            } else {
                previewCard.className = 'card-visual';
                previewLogo.innerHTML = 'CARD';
            }

            previewNum.textContent = formatted || '•••• •••• •••• ••••';
            previewName.textContent = name.value.toUpperCase() || 'YOUR NAME';
            
            // Format expiry
            let expVal = expiry.value.replace(/\D/g, '');
            if (expVal.length > 2) {
                expiry.value = expVal.substring(0, 2) + '/' + expVal.substring(2, 4);
            }
            previewExpiry.textContent = expiry.value || 'MM/YY';
        }

        function selectPayment(element, type) {
            document.querySelectorAll('.payment-card').forEach(card => {
                card.classList.remove('active');
                card.classList.add('bg-gray-50');
                const circle = card.querySelector('.selection-circle');
                circle.innerHTML = '';
                circle.className = 'selection-circle w-5 h-5 rounded-full border-2 border-gray-300';
            });
            
            element.classList.add('active');
            element.classList.remove('bg-gray-50');
            const activeCircle = element.querySelector('.selection-circle');
            activeCircle.className = 'selection-circle w-5 h-5 rounded-full border-2 border-blue-600 flex items-center justify-center p-1';
            activeCircle.innerHTML = '<div class="w-full h-full bg-blue-600 rounded-full animate-pulse"></div>';
            
            showSnackbar(`${type.toUpperCase()} selected as payment method.`);
        }

        function saveCard() {
            const num = document.getElementById('card-number-input').value;
            if (num.length < 16) {
                showSnackbar("Please enter a valid card number.", true);
                return;
            }
            showSnackbar("Card added to payment methods!");
            toggleCardForm();
            // In real app, add new card to options list
        }

        function placeOrder() {
            const gov = document.getElementById('governorate').value;
            const city = document.getElementById('city').value;
            const addr = document.getElementById('address').value;

            if (!gov || !city || !addr) {
                showSnackbar("Please complete delivery details first.", true);
                return;
            }

            showSnackbar("Order placed! Dive into your gear soon.");
            setTimeout(() => {
                location.href = 'index.html';
            }, 2000);
        }

        function showSnackbar(message, isError = false) {
            const old = document.querySelector('.snackbar');
            if (old) old.remove();

            const snackbar = document.createElement('div');
            snackbar.textContent = message;
            snackbar.className = `snackbar fixed top-6 left-1/2 -translate-x-1/2 px-6 py-3 rounded-2xl shadow-2xl text-white ${isError ? 'bg-red-500' : 'bg-blue-600'} z-[100] font-bold text-sm transition-all animate-bounce`;
            document.body.appendChild(snackbar);
            setTimeout(() => {
                snackbar.remove();
            }, 3000);
        }

        window.onload = initMap;
    </script>
</body>
</html>