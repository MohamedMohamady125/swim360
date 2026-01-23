<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - Secure Checkout</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&family=JetBrains+Mono:wght@500&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F8FAFC; overflow-x: hidden; }
        
        @keyframes successPop { 
            0% { transform: scale(0.5); opacity: 0; filter: blur(10px); } 
            50% { transform: scale(1.1); opacity: 1; filter: blur(0px); }
            100% { transform: scale(1); opacity: 1; } 
        }
        @keyframes confettiFall {
            0% { transform: translateY(-100vh) rotate(0deg); opacity: 1; }
            100% { transform: translateY(100vh) rotate(720deg); opacity: 0; }
        }
        .animate-success { animation: successPop 0.8s cubic-bezier(0.34, 1.56, 0.64, 1) forwards; }
        .confetti { position: absolute; width: 10px; height: 10px; animation: confettiFall 3s linear infinite; z-index: 101; }

        #map { height: 160px; border-radius: 24px; z-index: 10; border: 4px solid #F9FAFB; }
        .card-visual {
            width: 100%; max-width: 320px; height: 180px; border-radius: 24px;
            padding: 24px; font-family: 'JetBrains Mono', monospace;
            background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
            transition: all 0.5s cubic-bezier(0.16, 1, 0.3, 1);
            overflow: hidden; position: relative; color: white;
        }
        .card-visual.visa { background: linear-gradient(135deg, #1a1f71 0%, #2b3a8c 100%); }
        .card-visual.mastercard { background: linear-gradient(135deg, #eb001b 0%, #ff5f00 100%); }
        
        .chip { width: 40px; height: 30px; background: linear-gradient(135deg, #ffd700 0%, #eab308 100%); border-radius: 6px; margin-bottom: 20px; }
        select { -webkit-appearance: none; appearance: none; }
        .no-scrollbar::-webkit-scrollbar { display: none; }

        /* SLIDE TO PAY STYLES */
        .slider-container {
            position: relative;
            width: 100%;
            height: 72px;
            background-color: #E2E8F0;
            border-radius: 36px;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }
        .slider-container.active { background-color: #2563EB; }
        .slider-container.disabled { opacity: 0.4; pointer-events: none; }
        
        .slider-text {
            color: #94A3B8;
            font-size: 14px;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            pointer-events: none;
            transition: opacity 0.3s;
        }
        .slider-container.active .slider-text { color: rgba(255,255,255,0.6); }

        .slider-handle {
            position: absolute;
            left: 6px;
            width: 60px;
            height: 60px;
            background-color: white;
            border-radius: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            z-index: 10;
            touch-action: none;
        }
    </style>
</head>
<body class="pb-10 no-scrollbar">

    <div class="max-w-md mx-auto min-h-screen relative">
        <header class="bg-white/90 backdrop-blur-md px-6 pt-12 pb-5 flex items-center justify-between sticky top-0 z-30 border-b border-gray-50 text-left">
            <div class="flex items-center space-x-4">
                <button onclick="window.history.back()" class="p-2.5 rounded-2xl border border-gray-100 bg-white text-gray-900 shadow-sm active:scale-90 transition-all">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><polyline points="15 18 9 12 15 6"></polyline></svg>
                </button>
                <div>
                    <h1 class="text-2xl font-black text-gray-900 tracking-tight uppercase">Checkout</h1>
                    <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mt-1">Complete Purchase</p>
                </div>
            </div>
            <div class="w-11 h-11 rounded-2xl bg-blue-600 flex items-center justify-center text-white shadow-lg shadow-blue-100">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"/><path d="M3 6h18"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
            </div>
        </header>

        <main id="main-content" class="p-6 space-y-6">
            <section class="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-5 text-left">
                <div class="flex items-center space-x-2">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/></svg>
                    <h3 class="text-xs font-black text-gray-400 uppercase tracking-widest">Delivery Address</h3>
                </div>
                <div id="map" class="shadow-inner bg-gray-100 mb-4"></div>
                <div class="space-y-4">
                    <div>
                        <label class="text-[10px] font-black text-gray-400 uppercase ml-1">City / Region</label>
                        <div class="relative mt-1.5">
                            <select id="input-city" onchange="validateCheckout()" class="w-full p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold shadow-inner outline-none focus:ring-2 focus:ring-blue-500">
                                <option value="" disabled selected>Select City</option>
                                <option>New Cairo</option><option>Maadi</option><option>Zamalek</option><option>Alexandria</option><option>6th of October</option>
                            </select>
                            <svg xmlns="http://www.w3.org/2000/svg" class="absolute right-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 pointer-events-none" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><polyline points="6 9 12 15 18 9"></polyline></svg>
                        </div>
                    </div>
                    <div>
                        <label class="text-[10px] font-black text-gray-400 uppercase ml-1">Detailed Address</label>
                        <textarea id="input-addr" oninput="validateCheckout()" placeholder="Bldg. No, Street, Apartment..." class="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold shadow-inner outline-none h-20 resize-none focus:ring-2 focus:ring-blue-500"></textarea>
                    </div>
                </div>
            </section>

            <section class="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-6 text-left">
                <div class="flex justify-between items-center">
                    <div class="flex items-center space-x-2">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>
                        <h3 class="text-xs font-black text-gray-400 uppercase tracking-widest">Payment Method</h3>
                    </div>
                    <button id="toggle-card" class="text-[10px] font-black text-blue-600 uppercase tracking-widest transition-all hover:text-rose-500">+ New Card</button>
                </div>

                <div id="card-ui" class="hidden space-y-6">
                    <div id="card-preview" class="card-visual mx-auto text-white relative">
                        <div class="chip"></div>
                        <div id="p-logo" class="absolute top-6 right-6 font-black italic text-right leading-none max-w-[100px] uppercase">CARD</div>
                        <div id="p-num" class="text-lg tracking-widest mb-6 pt-2">•••• •••• •••• ••••</div>
                        <div class="flex justify-between uppercase">
                            <div class="flex-1 min-w-0 pr-4">
                                <div class="text-[8px] opacity-60">Card Holder</div>
                                <div id="p-name" class="text-xs truncate">YOUR NAME</div>
                            </div>
                            <div class="text-right">
                                <div class="text-[8px] opacity-60">Expiry</div>
                                <div id="p-exp" class="text-xs">MM/YY</div>
                            </div>
                        </div>
                    </div>
                    <div class="space-y-4">
                        <input type="text" id="c-num" maxlength="19" placeholder="Card Number" class="w-full p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold shadow-inner outline-none focus:ring-2 focus:ring-blue-500">
                        <input type="text" id="c-name" placeholder="Full Name" class="w-full p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold shadow-inner outline-none uppercase focus:ring-2 focus:ring-blue-500">
                        <div class="grid grid-cols-2 gap-4">
                            <input type="text" id="c-exp" maxlength="5" placeholder="MM/YY" class="p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold shadow-inner outline-none focus:ring-2 focus:ring-blue-500">
                            <input type="password" id="c-cvv" maxlength="3" placeholder="CVV" class="p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold shadow-inner outline-none focus:ring-2 focus:ring-blue-500">
                        </div>
                        <button id="btn-add-card" type="button" onclick="addNewCardToList()" class="w-full py-4 bg-gray-900 text-white rounded-2xl font-black text-xs uppercase tracking-widest shadow-xl opacity-40 pointer-events-none transition-all">Save & Select Card</button>
                    </div>
                </div>

                <div id="payment-options" class="space-y-3">
                    <div id="visa-primary" onclick="selectMethod('visa-primary')" class="p-4 rounded-[24px] bg-gray-50 border-2 border-transparent flex items-center justify-between cursor-pointer active:scale-95 transition-all">
                        <div class="flex items-center space-x-3">
                            <div class="bg-white p-2 rounded-xl shadow-sm text-blue-900 font-black italic text-[10px]">VISA</div>
                            <div><p class="text-sm font-black text-gray-900 leading-none">Visa •••• 4242</p><p class="text-[9px] font-bold text-blue-400 mt-1 uppercase tracking-widest">Saved</p></div>
                        </div>
                        <div class="status-dot w-5 h-5 rounded-full border-2 border-gray-200"></div>
                    </div>

                    <div id="method-cash" onclick="selectMethod('method-cash')" class="p-4 rounded-[24px] bg-gray-50 border-2 border-transparent flex items-center justify-between cursor-pointer active:scale-95 transition-all">
                        <div class="flex items-center space-x-3">
                            <div class="bg-white p-2 rounded-xl shadow-sm text-gray-400"><svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M12 2v20m0-20c-4.4 0-8 3.6-8 8s3.6 8 8 8 8-3.6 8-8-3.6-8-8-8z"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg></div>
                            <div><p class="text-sm font-black text-gray-500 leading-none">Cash on Delivery</p><p class="text-[9px] font-bold text-gray-400 mt-1 uppercase tracking-widest">Pay at Door</p></div>
                        </div>
                        <div class="status-dot w-5 h-5 rounded-full border-2 border-gray-200"></div>
                    </div>
                </div>
            </section>

            <div class="pt-4 pb-12 space-y-8">
                <div class="flex justify-between items-center px-4 text-left">
                    <div><p class="text-[10px] font-black text-gray-400 uppercase tracking-widest leading-none">Total Price</p><p class="text-4xl font-black text-gray-900 tracking-tighter mt-1">$75.49</p></div>
                    <div class="bg-emerald-50 px-4 py-2 rounded-2xl flex items-center text-emerald-600 border border-emerald-100">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                        <span class="text-[10px] font-black uppercase">Secure</span>
                    </div>
                </div>

                <div id="checkout-slider" class="slider-container disabled">
                    <span class="slider-text">Slide to Pay</span>
                    <div id="slider-handle" class="slider-handle">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3">
                            <polyline points="9 18 15 12 9 6"></polyline>
                        </svg>
                    </div>
                </div>
            </div>
        </main>

        <div id="success-overlay" class="fixed inset-0 z-[100] bg-blue-600 flex flex-col items-center justify-center p-10 hidden overflow-hidden">
            <div id="confetti-container"></div>
            <div class="animate-success flex flex-col items-center space-y-10 relative z-10">
                <div class="w-36 h-36 bg-white/20 backdrop-blur-2xl rounded-[48px] flex items-center justify-center border-2 border-white/30 shadow-2xl relative overflow-hidden">
                     <div class="absolute inset-0 bg-gradient-to-tr from-white/0 via-white/40 to-white/0 translate-y-full transform -skew-y-12 animate-[pulse_2s_infinite]"></div>
                     <svg xmlns="http://www.w3.org/2000/svg" class="w-20 h-20 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M12 15l-2 5L9 9l11-1 5 2z"/><path d="M22 12A10 10 0 1112 2a10 10 0 0110 10z"/><polyline points="9 11 12 14 22 4"/></svg>
                </div>
                <div class="space-y-4">
                    <h2 class="text-6xl font-black text-white tracking-tighter leading-none italic uppercase underline decoration-blue-400 underline-offset-8 text-center">Confirmed!!</h2>
                    <p class="text-blue-100 text-[10px] font-black uppercase tracking-[0.4em] opacity-80 text-center">Your gear is at the starting block</p>
                </div>
                <button onclick="location.reload()" class="bg-white text-blue-600 px-12 py-5 rounded-[28px] font-black text-xs uppercase tracking-widest shadow-2xl active:scale-90 transition-all">
                    BACK TO HOME
                </button>
            </div>
        </div>
    </div>

    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        let currentSelection = null;
        let isSliding = false;

        window.onload = () => {
            const map = L.map('map', {zoomControl: false}).setView([30.0444, 31.2357], 14);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
            L.marker([30.0444, 31.2357]).addTo(map);
            initSlider();
        };

        function validateCheckout() {
            const city = document.getElementById('input-city').value;
            const addr = document.getElementById('input-addr').value.trim();
            const slider = document.getElementById('checkout-slider');
            if (city && addr && currentSelection) {
                slider.classList.remove('disabled');
                slider.classList.add('active');
            } else {
                slider.classList.add('disabled');
                slider.classList.remove('active');
            }
        }

        function initSlider() {
            const handle = document.getElementById('slider-handle');
            const container = document.getElementById('checkout-slider');
            let startX = 0;
            let currentX = 0;
            const maxSlide = container.offsetWidth - handle.offsetWidth - 12;

            function onStart(e) {
                if (container.classList.contains('disabled')) return;
                isSliding = true;
                startX = e.type === 'touchstart' ? e.touches[0].clientX : e.clientX;
                handle.style.transition = 'none';
            }

            function onMove(e) {
                if (!isSliding) return;
                const x = e.type === 'touchmove' ? e.touches[0].clientX : e.clientX;
                currentX = Math.max(0, Math.min(maxSlide, x - startX));
                handle.style.transform = `translateX(${currentX}px)`;
                
                // Dim text as handle moves
                const opacity = 1 - (currentX / maxSlide);
                container.querySelector('.slider-text').style.opacity = opacity;
            }

            function onEnd() {
                if (!isSliding) return;
                isSliding = false;
                if (currentX >= maxSlide * 0.9) {
                    handle.style.transform = `translateX(${maxSlide}px)`;
                    handle.style.transition = 'transform 0.2s';
                    triggerSuccess();
                } else {
                    handle.style.transform = 'translateX(0px)';
                    handle.style.transition = 'transform 0.3s ease-out';
                    container.querySelector('.slider-text').style.opacity = 1;
                }
                currentX = 0;
            }

            handle.addEventListener('mousedown', onStart);
            handle.addEventListener('touchstart', onStart);
            window.addEventListener('mousemove', onMove);
            window.addEventListener('touchmove', onMove);
            window.addEventListener('mouseup', onEnd);
            window.addEventListener('touchend', onEnd);
        }

        function selectMethod(id) {
            currentSelection = id;
            document.querySelectorAll('#payment-options > div').forEach(el => {
                el.classList.remove('bg-blue-50', 'border-blue-600');
                el.classList.add('bg-gray-50', 'border-transparent');
                el.querySelector('.status-dot').className = 'status-dot w-5 h-5 rounded-full border-2 border-gray-200';
                el.querySelector('.status-dot').innerHTML = '';
            });
            const sel = document.getElementById(id);
            if (sel) {
                sel.classList.replace('bg-gray-50', 'bg-blue-50');
                sel.classList.replace('border-transparent', 'border-blue-600');
                sel.querySelector('.status-dot').className = 'status-dot w-5 h-5 rounded-full bg-blue-600 flex items-center justify-center';
                sel.querySelector('.status-dot').innerHTML = '<svg class="w-3 h-3 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="4"><polyline points="20 6 9 17 4 12"/></svg>';
            }
            validateCheckout();
        }

        const toggleBtn = document.getElementById('toggle-card');
        const cardUI = document.getElementById('card-ui');
        const paymentList = document.getElementById('payment-options');

        toggleBtn.onclick = () => {
            const hidden = cardUI.classList.contains('hidden');
            cardUI.classList.toggle('hidden');
            paymentList.classList.toggle('hidden');
            toggleBtn.textContent = hidden ? 'Cancel' : '+ New Card';
        };

        document.getElementById('c-num').oninput = (e) => {
            let v = e.target.value.replace(/\D/g, '');
            e.target.value = v.match(/.{1,4}/g)?.join(' ') || '';
            document.getElementById('p-num').textContent = e.target.value || '•••• •••• •••• ••••';
            
            const preview = document.getElementById('card-preview');
            const logo = document.getElementById('p-logo');
            if(v.startsWith('4')) { preview.className = 'card-visual visa'; logo.textContent = 'VISA'; }
            else if(v.startsWith('5')) { preview.className = 'card-visual mastercard'; logo.textContent = 'MASTERCARD'; }
            else { preview.className = 'card-visual'; logo.textContent = 'CARD'; }
            
            const btn = document.getElementById('btn-add-card');
            if(v.length >= 16) { btn.classList.remove('opacity-40', 'pointer-events-none'); btn.classList.add('bg-blue-600'); }
        };

        document.getElementById('c-name').oninput = (e) => {
            document.getElementById('p-name').textContent = e.target.value.toUpperCase() || 'YOUR NAME';
        };

        document.getElementById('c-exp').oninput = (e) => {
            let v = e.target.value.replace(/\D/g, '');
            if (v.length > 2) {
                v = v.substring(0, 2) + '/' + v.substring(2, 4);
            }
            e.target.value = v;
            document.getElementById('p-exp').textContent = v || 'MM/YY';
        };

        function addNewCardToList() {
            const last4 = document.getElementById('c-num').value.slice(-4);
            const brandName = document.getElementById('p-logo').textContent;
            const newId = 'card-' + Date.now();
            const html = `
                <div id="${newId}" onclick="selectMethod('${newId}')" class="p-4 rounded-[24px] bg-gray-50 border-2 border-transparent flex items-center justify-between cursor-pointer active:scale-95 transition-all animate-in">
                    <div class="flex items-center space-x-3">
                        <div class="bg-white p-2 rounded-xl shadow-sm text-blue-600 font-black italic text-[9px]">${brandName}</div>
                        <p class="text-sm font-black text-gray-900">${brandName} •••• ${last4}</p>
                    </div>
                    <div class="status-dot w-5 h-5 rounded-full border-2 border-gray-200"></div>
                </div>`;
            paymentList.insertAdjacentHTML('afterbegin', html);
            toggleBtn.click();
            selectMethod(newId);
        }

        function triggerSuccess() {
            document.getElementById('main-content').classList.add('blur-2xl', 'scale-90', 'opacity-0', 'transition-all', 'duration-1000');
            const overlay = document.getElementById('success-overlay');
            overlay.classList.remove('hidden');
            
            const container = document.getElementById('confetti-container');
            for (let i = 0; i < 50; i++) {
                const c = document.createElement('div');
                c.className = 'confetti';
                c.style.left = Math.random() * 100 + 'vw';
                c.style.backgroundColor = ['#FFF', '#FACC15', '#60A5FA', '#F472B6', '#10B981'][Math.floor(Math.random() * 5)];
                c.style.animationDuration = (Math.random() * 2 + 1) + 's';
                c.style.animationDelay = Math.random() * 2 + 's';
                container.appendChild(c);
            }
        }
    </script>
</body>
</html>