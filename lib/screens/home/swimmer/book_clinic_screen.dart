<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <title>Swim 360 - Recovery Portal</title>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F8FAFC; color: #0F172A; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        .animate-in { animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .shadow-blueprint { box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 10px 10px -5px rgba(0, 0, 0, 0.02); }
    </style>
</head>
<body class="no-scrollbar">

    <div class="max-w-md mx-auto min-h-screen relative flex flex-col pb-20">
        
        <header class="bg-white/90 backdrop-blur-md px-6 pt-12 pb-5 flex items-center justify-between sticky top-0 z-30 border-b border-gray-50 text-left">
            <div class="flex items-center space-x-4">
                <button onclick="handleBack()" class="p-2.5 rounded-2xl border border-gray-100 bg-white text-gray-900 shadow-sm active:scale-90 transition-all">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><polyline points="15 18 9 12 15 6"></polyline></svg>
                </button>
                <div>
                    <h1 class="text-2xl font-black text-gray-900 tracking-tight uppercase leading-none italic">Recovery</h1>
                    <p id="step-label" class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] mt-1.5">Booking Hub</p>
                </div>
            </div>
            <div class="w-11 h-11 rounded-2xl bg-blue-50 flex items-center justify-center text-blue-600 border border-blue-100 shadow-inner">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
            </div>
        </header>

        <div id="stepper" class="px-8 py-5 bg-white border-b border-gray-50 sticky top-[74px] z-20">
            <div class="flex justify-between items-center relative max-w-[300px] mx-auto text-left">
                <div class="absolute top-1/2 left-0 w-full h-0.5 bg-gray-100 -translate-y-1/2"></div>
                <div id="step-line" class="absolute top-1/2 left-0 h-0.5 bg-blue-600 -translate-y-1/2 transition-all duration-700 w-0"></div>
                
                <div class="relative z-10 flex flex-col items-center">
                    <div class="step-dot w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-blue-600 text-white shadow-lg">1</div>
                    <span class="text-[8px] mt-2 font-black uppercase tracking-widest text-blue-600">Clinic</span>
                </div>
                <div class="relative z-10 flex flex-col items-center">
                    <div class="step-dot w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-white border-2 border-gray-100 text-gray-300">2</div>
                    <span class="text-[8px] mt-2 font-black uppercase tracking-widest text-gray-300">Branch</span>
                </div>
                <div class="relative z-10 flex flex-col items-center">
                    <div class="step-dot w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-white border-2 border-gray-100 text-gray-300">3</div>
                    <span class="text-[8px] mt-2 font-black uppercase tracking-widest text-gray-300">Slot</span>
                </div>
                <div class="relative z-10 flex flex-col items-center">
                    <div class="step-dot w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-white border-2 border-gray-100 text-gray-300">4</div>
                    <span class="text-[8px] mt-2 font-black uppercase tracking-widest text-gray-300">Service</span>
                </div>
            </div>
        </div>

        <main id="view-port" class="p-6 flex-grow animate-in text-left">
            </main>

    </div>

    <script>
        const CLINICS_DATA = [
            {
                id: 'c1', name: 'AquaHealth Physio', img: 'https://images.unsplash.com/photo-1590233156170-ef1f6305f884?auto=format&fit=crop&q=80&w=800',
                branches: [
                    { id: 'b1', name: 'Olympic Park', beds: 3, open: 9, close: 18 },
                    { id: 'b2', name: 'Downtown Wellness', beds: 2, open: 10, close: 20 }
                ],
                services: [
                    { id: 's1', name: 'Initial Assessment', price: 95, dur: '60m' },
                    { id: 's2', name: 'Manual Therapy', price: 120, dur: '45m' }
                ]
            }
        ];

        let state = { step: 0, clinic: null, branch: null, date: new Date().getDate(), bed: 1, slot: null, service: null };

        function render() {
            const port = document.getElementById('view-port');
            updateStepper();

            if (state.step === 0) {
                port.innerHTML = `
                    <div class="space-y-6">
                        <div class="px-2"><h2 class="text-3xl font-black text-gray-900 uppercase italic leading-none">Clinics</h2><p class="text-[10px] font-bold text-blue-600 uppercase tracking-widest mt-2">Find a medical provider</p></div>
                        <div class="space-y-4">
                            ${CLINICS_DATA.map(c => `
                                <div onclick="selectClinic('${c.id}')" class="bg-white rounded-[32px] overflow-hidden shadow-blueprint border border-white group active:scale-[0.98] transition-all cursor-pointer">
                                    <div class="relative h-48">
                                        <img src="${c.img}" class="w-full h-full object-cover">
                                        <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent"></div>
                                        <div class="absolute bottom-5 left-6">
                                            <h3 class="text-2xl font-black text-white uppercase italic tracking-tighter">${c.name}</h3>
                                            <p class="text-blue-200 text-[9px] font-black uppercase tracking-widest mt-1">Verified Partner</p>
                                        </div>
                                    </div>
                                    <div class="p-6 flex justify-between items-center">
                                        <div class="flex items-center text-[10px] font-black text-gray-400 uppercase tracking-widest"><svg class="w-4 h-4 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path d="M12 21l-8.228-8.228a6 6 0 1 1 8.486-8.486L12 4.058l.742-.772a6 6 0 1 1 8.486 8.486L12 21z"/></svg> 4.9 Rating</div>
                                        <div class="bg-blue-600 text-white px-6 py-2.5 rounded-xl text-[10px] font-black uppercase tracking-widest shadow-lg">Choose</div>
                                    </div>
                                </div>
                            `).join('')}
                        </div>
                    </div>
                `;
            }
            else if (state.step === 1) {
                port.innerHTML = `
                    <div class="space-y-6">
                        <div class="px-2"><h2 class="text-3xl font-black text-gray-900 uppercase italic leading-none">Branches</h2><p class="text-[10px] font-bold text-blue-600 uppercase tracking-widest mt-2">${state.clinic.name}</p></div>
                        <div class="space-y-4">
                            ${state.clinic.branches.map(b => `
                                <div onclick="selectBranch('${b.id}')" class="bg-white p-6 rounded-[32px] border border-gray-100 flex items-center justify-between group active:scale-[0.98] transition-all cursor-pointer shadow-sm">
                                    <div class="flex items-center space-x-5">
                                        <div class="w-14 h-14 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center shadow-inner"><svg class="w-7 h-7" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M3 21h18M3 7v1a3 3 0 0 0 6 0V7m0 1a3 3 0 0 0 6 0V7m0 1a3 3 0 0 0 6 0V7M4 21V4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v17"/></svg></div>
                                        <div><h4 class="font-black text-gray-900 leading-none uppercase">${b.name}</h4><p class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mt-2">View Availability</p></div>
                                    </div>
                                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 text-gray-200 group-hover:text-blue-600 transition-colors" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                </div>
                            `).join('')}
                        </div>
                    </div>
                `;
            }
            else if (state.step === 2) {
                const days = Array.from({length: 14}, (_, i) => { let d = new Date(); d.setDate(d.getDate()+i); return d; });
                const beds = Array.from({length: state.branch.beds}, (_, i) => i + 1);
                const hours = Array.from({length: state.branch.close - state.branch.open}, (_, i) => state.branch.open + i);

                port.innerHTML = `
                    <div class="space-y-8 pb-10">
                        <div class="flex space-x-3 overflow-x-auto no-scrollbar pb-2">
                            ${days.map(d => `
                                <div onclick="state.date = ${d.getDate()}; render();" class="flex-shrink-0 w-14 py-4 rounded-[22px] border-2 flex flex-col items-center transition-all cursor-pointer ${state.date === d.getDate() ? 'border-blue-600 bg-blue-50' : 'border-gray-50 bg-white text-gray-400'}">
                                    <span class="text-[8px] font-black uppercase mb-1">${['Sun','Mon','Tue','Wed','Thu','Fri','Sat'][d.getDay()]}</span>
                                    <span class="text-sm font-black">${d.getDate()}</span>
                                </div>
                            `).join('')}
                        </div>

                        <div class="space-y-4">
                            <label class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] ml-2">Select Bed</label>
                            <div class="flex space-x-2 bg-gray-100 p-1.5 rounded-[24px] shadow-inner">
                                ${beds.map(b => `
                                    <button onclick="state.bed = ${b}; render();" class="flex-1 py-3 rounded-[18px] text-[10px] font-black uppercase tracking-widest transition-all ${state.bed === b ? 'bg-blue-600 text-white shadow-lg' : 'text-gray-400'}">Bed ${b}</button>
                                `).join('')}
                            </div>
                        </div>

                        <div class="space-y-3">
                            <label class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] ml-2">Select Time</label>
                            ${hours.map(h => {
                                const time = h > 12 ? (h-12)+':00 PM' : h+':00 AM';
                                const isSel = state.slot === time;
                                return `
                                    <div onclick="state.slot='${time}'; render();" class="bg-white p-5 rounded-[24px] border-2 transition-all flex items-center justify-between group ${isSel ? 'border-blue-600 bg-blue-50 shadow-md' : 'border-gray-50 active:scale-95 cursor-pointer'}">
                                        <div class="flex items-center space-x-4">
                                            <div class="w-10 h-10 rounded-xl flex items-center justify-center ${isSel ? 'bg-blue-600 text-white shadow-lg' : 'bg-gray-50 text-gray-400'}">
                                                <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                            </div>
                                            <p class="font-black text-gray-900 uppercase italic text-sm">${time}</p>
                                        </div>
                                        ${isSel ? '<svg class="w-5 h-5 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="4"><polyline points="20 6 9 17 4 12"/></svg>' : '<div class="w-5 h-5 rounded-full border-2 border-gray-100 group-hover:border-blue-200"></div>'}
                                    </div>
                                `;
                            }).join('')}
                        </div>
                    </div>
                `;
                if(state.slot) addFloatingButton('CONTINUE', () => { state.step = 3; render(); });
            }
            else if (state.step === 3) {
                port.innerHTML = `
                    <div class="space-y-6">
                        <div class="px-2"><h2 class="text-3xl font-black text-gray-900 uppercase italic leading-none text-left">Treatment</h2><p class="text-[10px] font-bold text-blue-600 uppercase tracking-widest mt-2">${state.branch.name} • Bed ${state.bed}</p></div>
                        <div class="space-y-4">
                            ${state.clinic.services.map(s => `
                                <div onclick="state.service = '${s.id}'; render();" class="p-6 rounded-[32px] border-2 flex items-center justify-between transition-all cursor-pointer ${state.service === s.id ? 'border-blue-600 bg-blue-50 shadow-xl' : 'border-gray-50 bg-white'}">
                                    <div class="flex items-center space-x-4">
                                        <div class="w-12 h-12 rounded-2xl ${state.service === s.id ? 'bg-blue-600 text-white' : 'bg-emerald-50 text-emerald-600'} flex items-center justify-center shadow-inner transition-colors">
                                            <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path d="M12 2v20m0-20c-4.4 0-8 3.6-8 8s3.6 8 8 8 8-3.6 8-8-3.6-8-8-8z"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                                        </div>
                                        <div><p class="font-black text-gray-900 leading-none uppercase italic">${s.name}</p><p class="text-[9px] text-gray-400 font-bold uppercase mt-1 tracking-widest">${s.dur} session</p></div>
                                    </div>
                                    <p class="text-xl font-black text-blue-600">$${s.price}</p>
                                </div>
                            `).join('')}
                        </div>
                    </div>
                `;
                if(state.service) addFloatingButton('CHECKOUT', () => { location.href='checkout.html' });
            }
        }

        function updateStepper() {
            const dots = document.querySelectorAll('.step-dot');
            const labels = document.querySelectorAll('.step-dot + span');
            const line = document.getElementById('step-line');
            line.style.width = (state.step / 3) * 100 + '%';
            dots.forEach((dot, i) => {
                if(i <= state.step) {
                    dot.className = "step-dot w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-blue-600 text-white shadow-lg transition-all scale-110";
                    labels[i].classList.replace('text-gray-300', 'text-blue-600');
                } else {
                    dot.className = "step-dot w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-white border-2 border-gray-100 text-gray-300 transition-all";
                    labels[i].classList.replace('text-blue-600', 'text-gray-300');
                }
            });
        }

        function addFloatingButton(text, action) {
            const old = document.getElementById('float-bar'); if(old) old.remove();
            const bar = document.createElement('div');
            bar.id = 'float-bar';
            bar.className = "fixed bottom-0 left-0 right-0 p-8 bg-white border-t border-gray-50 flex items-center justify-between shadow-2xl z-40 max-w-md mx-auto rounded-t-[40px] animate-in";
            bar.innerHTML = `
                <div class="text-left"><p class="text-[8px] font-black text-gray-400 uppercase tracking-[0.3em]">Phase Final</p><p class="text-2xl font-black text-gray-900 tracking-tighter italic uppercase">${text}</p></div>
                <button onclick="(${action})()" class="bg-blue-600 text-white px-10 py-5 rounded-[24px] font-black text-sm shadow-xl shadow-blue-100 flex items-center active:scale-95 transition-all">
                    PROCEED <svg class="w-5 h-5 ml-2" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg>
                </button>`;
            document.body.appendChild(bar);
        }

        function selectClinic(id) { state.clinic = CLINICS_DATA.find(c => c.id === id); state.step = 1; render(); }
        function selectBranch(id) { state.branch = state.clinic.branches.find(b => b.id === id); state.step = 2; render(); }
        function handleBack() { 
            const bar = document.getElementById('float-bar'); if(bar) bar.remove();
            if(state.step > 0) { state.step--; render(); } else window.history.back(); 
        }

        window.onload = render;
    </script>
</body>
</html>