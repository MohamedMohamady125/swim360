<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <title>Swim 360 - Academy Enrollment</title>
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
                    <h1 class="text-2xl font-black text-gray-900 tracking-tight uppercase leading-none italic">Enroll</h1>
                    <p id="header-subtitle" class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] mt-1.5">Academy Portal</p>
                </div>
            </div>
            <div class="w-11 h-11 rounded-2xl bg-blue-50 flex items-center justify-center text-blue-600 border border-blue-100 shadow-inner">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="8" r="7"></circle><polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"></polyline></svg>
            </div>
        </header>

        <div id="step-indicator" class="px-8 py-5 bg-white border-b border-gray-50 sticky top-[74px] z-20">
            <div class="flex justify-between items-center relative max-w-[280px] mx-auto">
                <div class="absolute top-1/2 left-0 w-full h-0.5 bg-gray-100 -translate-y-1/2"></div>
                <div id="step-line" class="absolute top-1/2 left-0 h-0.5 bg-blue-600 -translate-y-1/2 transition-all duration-700 w-0"></div>
                
                <div class="step-dot relative z-10 flex flex-col items-center">
                    <div class="w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-blue-600 text-white shadow-lg shadow-blue-100 transition-all duration-500">1</div>
                    <span class="text-[8px] mt-2 font-black uppercase tracking-widest text-blue-600">Academy</span>
                </div>
                <div class="step-dot relative z-10 flex flex-col items-center">
                    <div class="w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-white border-2 border-gray-100 text-gray-300 transition-all duration-500">2</div>
                    <span class="text-[8px] mt-2 font-black uppercase tracking-widest text-gray-300">Branch</span>
                </div>
                <div class="step-dot relative z-10 flex flex-col items-center">
                    <div class="w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-white border-2 border-gray-100 text-gray-300 transition-all duration-500">3</div>
                    <span class="text-[8px] mt-2 font-black uppercase tracking-widest text-gray-300">Level</span>
                </div>
            </div>
        </div>

        <main class="p-6 flex-grow overflow-y-auto">
            <div id="view-container" class="animate-in">
                </div>
        </main>

    </div>

    <script>
        const ACADEMIES = [
            {
                id: 'acad1',
                name: 'Elite Performance Academy',
                area: 'New Cairo',
                image: 'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?q=80&w=800&auto=format&fit=crop',
                branches: [
                    { id: 'b1', name: 'Fifth Settlement', address: 'Street 90, North Investors' },
                    { id: 'b2', name: 'Rehab City Hub', address: 'Gate 6, Club Square' }
                ],
                programs: [
                    { id: 'p1', name: 'Beginner - Level 1', price: 85.00, desc: 'Foundational mechanics and safety.', spots: 4 },
                    { id: 'p2', name: 'Intermediate Squad', price: 120.00, desc: 'Technique and competitive stamina.', spots: 2 }
                ]
            }
        ];

        let currentStep = 0;
        let selectedAcademy = null;
        let selectedBranch = null;

        function render() {
            const container = document.getElementById('view-container');
            updateStepIndicator();

            if (currentStep === 0) {
                container.innerHTML = `
                    <div class="space-y-6 text-left">
                        <div class="bg-white p-5 rounded-[32px] shadow-sm border border-gray-100">
                            <div class="relative">
                                <svg xmlns="http://www.w3.org/2000/svg" class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                <input type="text" placeholder="Search academies..." class="w-full pl-11 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none shadow-inner">
                            </div>
                        </div>
                        ${ACADEMIES.map(a => `
                            <div onclick="selectAcademy('${a.id}')" class="bg-white rounded-[32px] overflow-hidden shadow-soft border border-white group active:scale-[0.98] transition-all cursor-pointer">
                                <div class="relative h-60">
                                    <img src="${a.image}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000">
                                    <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent"></div>
                                    <div class="absolute bottom-6 left-6">
                                        <h3 class="text-2xl font-black text-white uppercase italic tracking-tighter">${a.name}</h3>
                                        <p class="text-blue-200 text-[10px] font-bold uppercase tracking-widest mt-1">${a.area}</p>
                                    </div>
                                </div>
                                <div class="p-6 flex justify-between items-center">
                                    <div class="flex items-center space-x-2">
                                        <div class="w-10 h-10 rounded-xl bg-blue-50 flex items-center justify-center text-blue-600 shadow-inner">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3.33 3 8.67 3 12 0v-5"/></svg>
                                        </div>
                                        <span class="text-[10px] font-black text-gray-400 uppercase tracking-widest leading-none">Enrollment Open</span>
                                    </div>
                                    <div class="p-2.5 bg-blue-600 text-white rounded-xl shadow-lg shadow-blue-100">
                                        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                    </div>
                                </div>
                            </div>
                        `).join('')}
                    </div>
                `;
            } else if (currentStep === 1) {
                container.innerHTML = `
                    <div class="space-y-6 text-left">
                        <div class="px-2">
                            <h2 class="text-2xl font-black text-gray-900 tracking-tight leading-none uppercase italic">Select Branch</h2>
                            <p class="text-[10px] font-bold text-blue-600 uppercase tracking-widest mt-2">${selectedAcademy.name}</p>
                        </div>
                        <div class="space-y-4">
                            ${selectedAcademy.branches.map(b => `
                                <div onclick="selectBranch('${b.id}')" class="bg-white p-5 rounded-[32px] border border-gray-100 flex items-center justify-between group active:scale-[0.98] transition-all cursor-pointer shadow-sm">
                                    <div class="flex items-center space-x-4">
                                        <div class="w-12 h-12 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center shadow-inner">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M3 21h18M3 7v1a3 3 0 0 0 6 0V7m0 1a3 3 0 0 0 6 0V7m0 1a3 3 0 0 0 6 0V7M4 21V4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v17"/></svg>
                                        </div>
                                        <div>
                                            <h4 class="font-black text-gray-900 leading-none uppercase">${b.name}</h4>
                                            <p class="text-[10px] text-gray-400 font-bold uppercase tracking-widest mt-1.5">${b.address}</p>
                                        </div>
                                    </div>
                                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-gray-200 group-hover:text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                </div>
                            `).join('')}
                        </div>
                    </div>
                `;
            } else if (currentStep === 2) {
                container.innerHTML = `
                    <div class="space-y-8 text-left pb-12">
                        <div class="px-2">
                            <h2 class="text-2xl font-black text-gray-900 leading-none uppercase italic">Final Step</h2>
                            <p class="text-[10px] font-bold text-blue-600 uppercase tracking-widest mt-2">Programs at ${selectedBranch.name}</p>
                        </div>
                        <div class="bg-white rounded-[40px] p-10 shadow-soft border border-gray-50 space-y-8 relative overflow-hidden">
                            <div class="flex items-center space-x-2 text-blue-600">
                                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><path d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>
                                <span class="text-[10px] font-black uppercase tracking-[0.3em]">Identity Verified</span>
                            </div>
                            <div>
                                <h4 class="text-[10px] font-black text-gray-300 uppercase tracking-widest mb-1">Academy</h4>
                                <p class="text-2xl font-black text-gray-900 tracking-tighter uppercase">${selectedAcademy.name}</p>
                            </div>
                            <div class="bg-gray-50 p-6 rounded-[32px] shadow-inner flex justify-between items-center">
                                <div>
                                    <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest leading-none">Subscription</p>
                                    <p class="text-3xl font-black text-gray-900 tracking-tighter mt-1">$120.00</p>
                                </div>
                                <div class="w-12 h-12 rounded-2xl bg-blue-600 flex items-center justify-center text-white shadow-lg shadow-blue-100">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                                </div>
                            </div>
                        </div>

                        <div class="px-2 mt-8">
                             <button onclick="handleConfirmation()" class="w-full py-5 bg-blue-600 text-white rounded-[28px] font-black text-sm uppercase tracking-[0.2em] shadow-xl shadow-blue-600/30 active:scale-95 transition-all flex items-center justify-center space-x-3">
                                <span>Confirm Enrollment</span>
                                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><polyline points="9 18 15 12 9 6"></polyline></svg>
                            </button>
                        </div>
                    </div>
                `;
            }
        }

        function updateStepIndicator() {
            const dots = document.querySelectorAll('.step-dot div');
            const labels = document.querySelectorAll('.step-dot span');
            const line = document.getElementById('step-line');
            
            line.style.width = (currentStep / 2) * 100 + '%';
            
            dots.forEach((dot, i) => {
                if (i <= currentStep) {
                    dot.className = "w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-blue-600 text-white shadow-lg shadow-blue-100 transition-all duration-500 scale-110";
                    labels[i].classList.replace('text-gray-300', 'text-blue-600');
                } else {
                    dot.className = "w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black bg-white border-2 border-gray-100 text-gray-300 transition-all duration-500 scale-100";
                    labels[i].classList.replace('text-blue-600', 'text-gray-300');
                }
            });
        }

        function selectAcademy(id) {
            selectedAcademy = ACADEMIES.find(a => a.id === id);
            currentStep = 1;
            render();
        }

        function selectBranch(id) {
            selectedBranch = selectedAcademy.branches.find(b => b.id === id);
            currentStep = 2;
            render();
        }

        function handleBack() {
            if (currentStep > 0) { currentStep--; render(); }
            else window.history.back();
        }

        function handleConfirmation() {
            // Trigger the "success" state logic
            const btn = event.currentTarget;
            btn.innerHTML = '<span>Processing...</span>';
            btn.classList.add('opacity-80', 'pointer-events-none');
            
            setTimeout(() => {
                location.href = 'success_screen.html';
            }, 1000);
        }

        window.onload = render;
    </script>
</body>
</html>