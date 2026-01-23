<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <title>Swim 360 - Expert Online Coaches</title>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F8FAFC; color: #0F172A; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        .animate-in { animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .shadow-blueprint { box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 10px 10px -5px rgba(0, 0, 0, 0.02); }
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
                    <h1 class="text-2xl font-black text-gray-900 tracking-tight uppercase leading-none italic">Coaches</h1>
                    <p id="header-subtitle" class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] mt-1.5">Online Training</p>
                </div>
            </div>
            <div class="w-11 h-11 rounded-2xl bg-purple-50 flex items-center justify-center text-purple-600 border border-purple-100 shadow-inner">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect><line x1="8" y1="21" x2="16" y2="21"></line><line x1="12" y1="17" x2="12" y2="21"></line></svg>
            </div>
        </header>

        <div id="step-indicator" class="px-8 py-5 bg-white border-b border-gray-50 sticky top-[74px] z-20">
            <div class="flex justify-between items-center relative max-w-[280px] mx-auto text-left">
                <div class="absolute top-1/2 left-0 w-full h-0.5 bg-gray-100 -translate-y-1/2"></div>
                <div id="step-line" class="absolute top-1/2 left-0 h-0.5 bg-purple-600 -translate-y-1/2 transition-all duration-700 w-0"></div>
                
                <div class="relative z-10 flex flex-col items-center">
                    <div class="step-dot w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-purple-600 text-white shadow-lg transition-all">1</div>
                    <span class="text-[8px] mt-2 font-black uppercase tracking-widest text-purple-600">Expert</span>
                </div>
                <div class="relative z-10 flex flex-col items-center">
                    <div class="step-dot w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-white border-2 border-gray-100 text-gray-300 transition-all">2</div>
                    <span class="text-[8px] mt-2 font-black uppercase tracking-widest text-gray-300">Profile</span>
                </div>
                <div class="relative z-10 flex flex-col items-center">
                    <div class="step-dot w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-white border-2 border-gray-100 text-gray-300 transition-all">3</div>
                    <span class="text-[8px] mt-2 font-black uppercase tracking-widest text-gray-300">Details</span>
                </div>
            </div>
        </div>

        <main id="view-port" class="p-6 flex-grow overflow-y-auto no-scrollbar animate-in text-left">
            </main>

    </div>

    <script>
        const COACHES = [
            {
                id: 'c1', name: 'Michael Thorne', spec: 'Olympic Performance', rating: 5.0, reviews: 128,
                image: 'https://images.unsplash.com/photo-1548382113-7615065835ee?auto=format&fit=crop&q=80&w=800',
                bio: 'Former Olympic relay coach specializing in biomechanical analysis.',
                programs: [
                    { 
                        id: 'p1', 
                        title: 'Stroke Mastery', 
                        price: 199, 
                        dur: '12 Weeks', 
                        goal: 'Technique', 
                        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
                        image: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80&w=800',
                        desc: 'Complete biomechanical breakdown of all four competitive strokes. Includes weekly video calls and a personalized drill curriculum.'
                    }
                ]
            }
        ];

        let state = { step: 0, coach: null, program: null };

        function render() {
            const port = document.getElementById('view-port');
            updateStepper();

            if (state.step === 0) {
                port.innerHTML = `
                    <div class="space-y-6">
                        <div class="bg-white p-5 rounded-[32px] shadow-sm border border-gray-100">
                            <div class="relative">
                                <svg xmlns="http://www.w3.org/2000/svg" class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                <input type="text" placeholder="Search online experts..." class="w-full pl-11 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none shadow-inner">
                            </div>
                        </div>
                        ${COACHES.map(c => `
                            <div onclick="selectCoach('${c.id}')" class="bg-white rounded-[32px] overflow-hidden shadow-blueprint border border-white group active:scale-[0.98] transition-all cursor-pointer">
                                <div class="relative h-60">
                                    <img src="${c.image}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000">
                                    <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent"></div>
                                    <div class="absolute bottom-6 left-6">
                                        <h3 class="text-2xl font-black text-white uppercase italic tracking-tighter">${c.name}</h3>
                                        <p class="text-purple-200 text-[10px] font-bold uppercase tracking-widest mt-1">${c.spec}</p>
                                    </div>
                                </div>
                                <div class="p-6 flex justify-between items-center">
                                    <div class="flex items-center space-x-2">
                                        <div class="w-10 h-10 rounded-xl bg-purple-50 flex items-center justify-center text-purple-600 shadow-inner">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M12 2v20m0-20c-4.4 0-8 3.6-8 8s3.6 8 8 8 8-3.6 8-8-3.6-8-8-8z"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                                        </div>
                                        <span class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Enrollment Open</span>
                                    </div>
                                    <div class="p-2.5 bg-purple-600 text-white rounded-xl shadow-lg">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                    </div>
                                </div>
                            </div>
                        `).join('')}
                    </div>
                `;
            } else if (state.step === 1) {
                port.innerHTML = `
                    <div class="space-y-8 pb-10">
                        <div class="flex items-center space-x-5 px-2">
                            <div class="w-20 h-20 rounded-[28px] border-4 border-white shadow-xl rotate-3 overflow-hidden">
                                <img src="${state.coach.image}" class="w-full h-full object-cover">
                            </div>
                            <div>
                                <h2 class="text-2xl font-black text-gray-900 leading-tight">${state.coach.name}</h2>
                                <p class="text-xs font-bold text-purple-600 uppercase tracking-widest mt-1 italic">${state.coach.spec}</p>
                            </div>
                        </div>

                        <div class="bg-white p-6 rounded-[32px] border border-gray-100 shadow-sm space-y-4">
                            <p class="text-sm font-bold text-gray-400 uppercase tracking-[0.2em]">Expert Bio</p>
                            <p class="text-sm text-gray-600 font-medium leading-relaxed">${state.coach.bio}</p>
                            <div class="pt-4 border-t border-gray-50 flex space-x-4">
                                <button onclick="window.open('https://wa.me/20123456789', '_blank')" class="flex-1 py-4 bg-[#25D366] text-white rounded-2xl flex items-center justify-center font-black text-[10px] uppercase tracking-widest shadow-xl active:scale-95 transition-all">
                                    WhatsApp Coach
                                </button>
                            </div>
                        </div>

                        <div class="space-y-4">
                            <h3 class="text-xl font-black text-gray-900 ml-2 italic uppercase">Curriculum</h3>
                            ${state.coach.programs.map(p => `
                                <div onclick="selectProgram('${p.id}')" class="bg-white p-5 rounded-[28px] border border-gray-100 flex items-center justify-between group active:scale-[0.98] transition-all cursor-pointer shadow-sm">
                                    <div class="flex items-center space-x-4">
                                        <div class="w-12 h-12 rounded-2xl bg-purple-50 text-purple-600 flex items-center justify-center shadow-inner"><svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg></div>
                                        <div><h4 class="font-black text-gray-900 leading-none uppercase">${p.title}</h4><p class="text-[9px] text-gray-400 font-bold uppercase mt-1.5 tracking-widest">${p.dur} • ${p.goal}</p></div>
                                    </div>
                                    <p class="text-sm font-black text-purple-600">$${p.price}</p>
                                </div>
                            `).join('')}
                        </div>
                    </div>
                `;
            } else if (state.step === 2) {
                port.innerHTML = `
                    <div class="space-y-8 animate-in text-left pb-40">
                        <div class="relative h-64 -mx-6 -mt-6 overflow-hidden shadow-lg">
                            <img src="${state.program.image}" class="w-full h-full object-cover">
                            <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                            <button onclick="window.open('${state.program.videoUrl}', '_blank')" class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-16 h-16 bg-white/30 backdrop-blur-xl rounded-full flex items-center justify-center border border-white/40 active:scale-90 transition-all shadow-2xl">
                                <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 text-white fill-white ml-1" viewBox="0 0 24 24"><path d="M5 3l14 9-14 9V3z"/></svg>
                            </button>
                        </div>

                        <div class="px-2">
                             <div class="flex items-center space-x-2 mb-3">
                                <span class="px-3 py-1 bg-purple-50 text-purple-600 rounded-lg text-[10px] font-black uppercase tracking-widest">${state.program.goal}</span>
                                <span class="px-3 py-1 bg-emerald-50 text-emerald-600 rounded-lg text-[10px] font-black uppercase tracking-widest">Instant Access</span>
                            </div>
                            <h2 class="text-3xl font-black text-gray-900 leading-tight tracking-tight uppercase italic">${state.program.title}</h2>
                        </div>

                        <div class="bg-white p-6 rounded-[32px] border border-gray-100 shadow-sm space-y-4">
                            <p class="text-xs font-black text-gray-900 uppercase tracking-widest border-b border-gray-50 pb-2">Program Overview</p>
                            <p class="text-xs font-bold text-gray-400 leading-relaxed">${state.program.desc}</p>
                        </div>

                        <div class="fixed bottom-0 left-0 right-0 p-8 bg-white/95 backdrop-blur-md border-t border-gray-50 max-w-md mx-auto rounded-t-[40px] shadow-2xl flex items-center justify-between z-40">
                            <div>
                                <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest leading-none">Enrollment Fee</p>
                                <p class="text-3xl font-black text-gray-900 tracking-tighter italic">$${state.program.price}</p>
                            </div>
                            <button onclick="location.href='checkout_screen.html'" class="bg-purple-600 text-white px-10 py-5 rounded-3xl font-black text-xs uppercase tracking-widest shadow-xl active:scale-95 transition-all">Enroll Now</button>
                        </div>
                    </div>
                `;
            }
        }

        function updateStepper() {
            const dots = document.querySelectorAll('.step-dot');
            const labels = document.querySelectorAll('.step-dot + span');
            const line = document.getElementById('step-line');
            line.style.width = (state.step / 2) * 100 + '%';
            
            dots.forEach((dot, i) => {
                if(i <= state.step) {
                    dot.className = "step-dot w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-purple-600 text-white shadow-lg transition-all scale-110";
                    labels[i].classList.replace('text-gray-300', 'text-purple-600');
                } else {
                    dot.className = "step-dot w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-white border-2 border-gray-100 text-gray-300 transition-all scale-100";
                    labels[i].classList.replace('text-purple-600', 'text-gray-300');
                }
            });
        }

        function selectCoach(id) { state.coach = COACHES.find(c => c.id === id); state.step = 1; render(); }
        function selectProgram(id) { state.program = state.coach.programs.find(p => p.id === id); state.step = 2; render(); }
        function handleBack() { 
            if (state.step > 0) { state.step--; render(); }
            else window.history.back();
        }

        window.onload = render;
    </script>
</body>
</html>