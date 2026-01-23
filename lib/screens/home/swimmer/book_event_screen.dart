<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <title>Swim 360 - Events Marketplace</title>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F8FAFC; color: #0F172A; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        .animate-in { animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .shadow-soft { box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 10px 10px -5px rgba(0, 0, 0, 0.02); }
    </style>
</head>
<body class="no-scrollbar">

    <div class="max-w-md mx-auto min-h-screen relative flex flex-col">
        
        <header class="bg-white/90 backdrop-blur-md px-6 pt-12 pb-5 flex items-center justify-between sticky top-0 z-30 border-b border-gray-50 text-left">
            <div class="flex items-center space-x-4">
                <button onclick="handleBack()" class="p-2.5 rounded-2xl border border-gray-100 bg-white text-gray-900 shadow-sm active:scale-90 transition-all">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><polyline points="15 18 9 12 15 6"></polyline></svg>
                </button>
                <div>
                    <h1 class="text-2xl font-black text-gray-900 tracking-tight uppercase leading-none italic">Events</h1>
                    <p id="header-subtitle" class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] mt-1.5">Marketplace</p>
                </div>
            </div>
            <div class="w-11 h-11 rounded-2xl bg-rose-50 flex items-center justify-center text-rose-600 border border-rose-100 shadow-inner">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M6 9H4.5a2.5 2.5 0 0 1 0-5H6"></path><path d="M18 9h1.5a2.5 2.5 0 0 0 0-5H18"></path><path d="M4 22h16"></path><path d="M10 14.66V17c0 .55-.47.98-.97 1.21C7.85 18.75 7 20.24 7 22"></path><path d="M14 14.66V17c0 .55.47.98.97 1.21C16.15 18.75 17 20.24 17 22"></path><path d="M18 2H6v7a6 6 0 0 0 12 0V2Z"></path></svg>
            </div>
        </header>

        <div id="step-indicator" class="px-8 py-5 bg-white border-b border-gray-50 sticky top-[74px] z-20">
            <div class="flex justify-between items-center relative max-w-[280px] mx-auto text-left">
                <div class="absolute top-1/2 left-0 w-full h-0.5 bg-gray-100 -translate-y-1/2"></div>
                <div id="step-line" class="absolute top-1/2 left-0 h-0.5 bg-rose-600 -translate-y-1/2 transition-all duration-700 w-0"></div>
                
                <div class="relative z-10 flex flex-col items-center">
                    <div class="step-dot w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-rose-600 text-white shadow-lg shadow-rose-100 transition-all duration-500">1</div>
                    <span class="text-[8px] mt-2 font-black uppercase tracking-widest text-rose-600">Explore</span>
                </div>
                <div class="relative z-10 flex flex-col items-center">
                    <div class="step-dot w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-white border-2 border-gray-100 text-gray-300 transition-all duration-500">2</div>
                    <span class="text-[8px] mt-2 font-black uppercase tracking-widest text-gray-300">Details</span>
                </div>
                <div class="relative z-10 flex flex-col items-center">
                    <div class="step-dot w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-white border-2 border-gray-100 text-gray-300 transition-all duration-500">3</div>
                    <span class="text-[8px] mt-2 font-black uppercase tracking-widest text-gray-300">Options</span>
                </div>
            </div>
        </div>

        <main class="p-6 flex-grow overflow-y-auto no-scrollbar">
            <div id="view-container" class="animate-in">
                </div>
        </main>

    </div>

    <script>
        const EVENTS = [
            {
                id: 'e1', name: 'Regional Championship 2026', type: 'Championship', displayDate: 'Jan 10, 2026',
                startTime: '09:00 AM', location: 'Central Pool (New Cairo)', price: 45.00, seatsLeft: 25,
                image: 'https://images.unsplash.com/photo-1530549387634-e5a529577059?auto=format&fit=crop&q=80&w=800',
                desc: 'Cairo’s leading high-performance swim center event. Featuring top-tier professional timing systems, international judges, and an Olympic-sized heating system for maximum performance.',
                mapUrl: 'https://maps.google.com',
                videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
            }
        ];

        let currentStep = 0;
        let selectedEvent = null;
        let ticketQty = 1;

        function render() {
            const container = document.getElementById('view-container');
            updateStepIndicator();

            if (currentStep === 0) {
                container.innerHTML = `
                    <div class="space-y-6 text-left pb-10">
                        <div class="bg-white p-5 rounded-[32px] shadow-sm border border-gray-100">
                            <div class="relative">
                                <svg xmlns="http://www.w3.org/2000/svg" class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                                <input type="text" placeholder="Search events..." class="w-full pl-11 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none shadow-inner">
                            </div>
                        </div>
                        ${EVENTS.map(e => `
                            <div onclick="selectEvent('${e.id}')" class="bg-white rounded-[32px] overflow-hidden shadow-soft border border-white group active:scale-[0.98] transition-all cursor-pointer">
                                <div class="relative h-60">
                                    <img src="${e.image}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000">
                                    <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent"></div>
                                    <div class="absolute bottom-6 left-6">
                                        <h3 class="text-2xl font-black text-white uppercase italic tracking-tighter">${e.name}</h3>
                                        <p class="text-rose-200 text-[10px] font-bold uppercase tracking-widest mt-1">${e.location}</p>
                                    </div>
                                </div>
                                <div class="p-6 flex justify-between items-center">
                                    <div class="flex items-center space-x-2">
                                        <div class="w-10 h-10 rounded-xl bg-rose-50 flex items-center justify-center text-rose-600 shadow-inner">
                                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2.5"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                        </div>
                                        <span class="text-[10px] font-black text-gray-400 uppercase tracking-widest">${e.displayDate}</span>
                                    </div>
                                    <div class="text-right">
                                        <p class="text-2xl font-black text-gray-900 tracking-tighter leading-none">$${e.price.toFixed(2)}</p>
                                        <p class="text-[8px] font-black text-rose-500 uppercase tracking-widest mt-1 italic">Book Now</p>
                                    </div>
                                </div>
                            </div>
                        `).join('')}
                    </div>
                `;
            } else if (currentStep === 1) {
                container.innerHTML = `
                    <div class="space-y-8 animate-in text-left pb-40">
                        <div class="relative h-64 -mx-6 -mt-6 overflow-hidden shadow-lg">
                            <img src="${selectedEvent.image}" class="w-full h-full object-cover">
                            <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                            <button onclick="window.open('${selectedEvent.videoUrl}', '_blank')" class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-16 h-16 bg-white/30 backdrop-blur-xl rounded-full flex items-center justify-center border border-white/40 active:scale-90 transition-all shadow-2xl">
                                <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 text-white fill-white ml-1" viewBox="0 0 24 24"><path d="M5 3l14 9-14 9V3z"/></svg>
                            </button>
                        </div>

                        <div class="px-2">
                            <div class="flex items-center space-x-2 mb-3">
                                <span class="px-3 py-1 bg-rose-50 text-rose-600 rounded-lg text-[10px] font-black uppercase tracking-widest">${selectedEvent.type}</span>
                                <span class="px-3 py-1 bg-emerald-50 text-emerald-600 rounded-lg text-[10px] font-black uppercase tracking-widest">Enrollment Open</span>
                            </div>
                            <h2 class="text-3xl font-black text-gray-900 leading-tight tracking-tight uppercase italic">${selectedEvent.name}</h2>
                        </div>

                        <div class="grid grid-cols-2 gap-4">
                            <div onclick="window.open('${selectedEvent.mapUrl}', '_blank')" class="bg-white p-5 rounded-[28px] shadow-sm border border-gray-100 flex items-center space-x-4 active:scale-95 transition-all cursor-pointer">
                                <div class="w-10 h-10 rounded-2xl bg-rose-50 text-rose-600 flex items-center justify-center shadow-inner">
                                    <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M12 21l-8.228-8.228a6 6 0 1 1 8.486-8.486L12 4.058l.742-.772a6 6 0 1 1 8.486 8.486L12 21z"></path></svg>
                                </div>
                                <div class="overflow-hidden">
                                    <p class="text-[8px] font-black text-gray-400 uppercase tracking-widest">Location</p>
                                    <p class="text-[10px] font-black text-blue-600 underline truncate leading-none mt-1">Open Maps</p>
                                </div>
                            </div>
                            <div class="bg-white p-5 rounded-[28px] shadow-sm border border-gray-100 flex items-center space-x-4">
                                <div class="w-10 h-10 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center shadow-inner">
                                    <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                </div>
                                <div><p class="text-[8px] font-black text-gray-400 uppercase tracking-widest">Starts</p><p class="text-xs font-black text-gray-900 leading-none mt-1">${selectedEvent.startTime}</p></div>
                            </div>
                        </div>

                        <div class="px-2 space-y-4">
                            <h4 class="text-xs font-black text-gray-900 uppercase tracking-[0.2em] border-b border-gray-100 pb-2">Event Description</h4>
                            <p class="text-xs font-bold text-gray-400 leading-relaxed">${selectedEvent.desc}</p>
                        </div>

                        <div class="fixed bottom-0 left-0 right-0 p-8 bg-white/90 backdrop-blur-md border-t border-gray-50 max-w-md mx-auto rounded-t-[40px] shadow-2xl flex items-center justify-between z-40">
                            <div>
                                <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Single Ticket</p>
                                <p class="text-3xl font-black text-gray-900 tracking-tighter italic">$${selectedEvent.price.toFixed(2)}</p>
                            </div>
                            <button onclick="goToStep(2)" class="bg-rose-600 text-white px-10 py-5 rounded-3xl font-black text-[10px] uppercase tracking-widest shadow-xl shadow-rose-200 active:scale-95 transition-all">Buy Tickets
                            </button>
                        </div>
                    </div>
                `;
            } else if (currentStep === 2) {
                container.innerHTML = `
                    <div class="space-y-8 animate-in text-left pb-10">
                        <div class="px-2">
                            <h2 class="text-2xl font-black text-gray-900 tracking-tight leading-none uppercase italic">Quantity</h2>
                            <p class="text-[10px] font-bold text-rose-600 uppercase tracking-widest mt-2">Entry Passes</p>
                        </div>
                        <div class="bg-white rounded-[40px] p-10 shadow-soft border border-gray-100 space-y-8 relative overflow-hidden">
                            <div class="flex items-center justify-between">
                                <div>
                                    <h4 class="font-black text-gray-900 text-xl leading-none">Athlete Entry</h4>
                                    <p class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mt-2 italic">Standard Registration</p>
                                </div>
                                <div class="flex items-center space-x-5 bg-gray-50 p-2 rounded-2xl shadow-inner">
                                    <button onclick="updateQty(-1)" class="w-10 h-10 rounded-xl bg-white shadow-sm flex items-center justify-center font-black active:scale-90 transition-all">-</button>
                                    <span class="font-black text-lg">${ticketQty}</span>
                                    <button onclick="updateQty(1)" class="w-10 h-10 rounded-xl bg-white shadow-sm flex items-center justify-center font-black active:scale-90 transition-all">+</button>
                                </div>
                            </div>
                            <div class="bg-gray-50 p-8 rounded-[32px] flex justify-between items-center shadow-inner">
                                <div>
                                    <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest leading-none">Total Due</p>
                                    <p class="text-3xl font-black text-gray-900 tracking-tighter mt-1">$${(selectedEvent.price * ticketQty).toFixed(2)}</p>
                                </div>
                                <div class="w-12 h-12 rounded-full bg-white flex items-center justify-center shadow-sm text-emerald-500"><svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg></div>
                            </div>
                        </div>
                        <button onclick="finalize()" class="w-full py-5 bg-rose-600 text-white rounded-[24px] font-black text-xs uppercase tracking-[0.2em] shadow-xl shadow-rose-200 active:scale-95 transition-all flex items-center justify-center space-x-3">
                            <span>Proceed to Checkout</span>
                            <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><polyline points="9 18 15 12 9 6"></polyline></svg>
                        </button>
                    </div>
                `;
            }
        }

        function updateStepIndicator() {
            const dots = document.querySelectorAll('.step-dot');
            const labels = document.querySelectorAll('.step-dot + span');
            const line = document.getElementById('step-line');
            line.style.width = (currentStep / 2) * 100 + '%';
            dots.forEach((dot, i) => {
                if(i <= currentStep) {
                    dot.className = "step-dot w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-rose-600 text-white shadow-lg transition-all scale-110";
                    labels[i].classList.replace('text-gray-300', 'text-rose-600');
                } else {
                    dot.className = "step-dot w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-white border-2 border-gray-100 text-gray-300 transition-all";
                    labels[i].classList.replace('text-rose-600', 'text-gray-300');
                }
            });
        }

        function selectEvent(id) {
            selectedEvent = EVENTS.find(e => e.id === id);
            currentStep = 1; render();
        }

        function goToStep(step) { currentStep = step; render(); }

        function handleBack() {
            if (currentStep > 0) { currentStep--; render(); }
            else window.history.back();
        }

        function updateQty(val) { ticketQty = Math.max(1, ticketQty + val); render(); }

        function finalize() { window.location.href = 'checkout_screen.html'; }

        window.onload = render;
    </script>
</body>
</html>