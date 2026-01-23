<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - Create Program</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F8FAFC; color: #0F172A; }
        
        .form-card {
            background-color: white;
            border-radius: 32px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 20px -2px rgba(0, 0, 0, 0.05);
            border: 1px solid #F1F5F9;
        }

        .input-group {
            display: flex;
            align-items: center;
            border-radius: 16px;
            padding: 0 16px;
            background-color: #F8FAFC;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: inset 0 2px 4px 0 rgba(0, 0, 0, 0.05);
            border: 1px solid transparent;
        }

        .input-group:focus-within {
            background-color: white;
            border-color: #2563EB;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        .input-group input, .input-group textarea {
            border: none;
            outline: none;
            padding: 14px 0;
            flex-grow: 1;
            background-color: transparent;
            font-weight: 700;
            font-size: 0.875rem;
        }

        .day-row {
            display: flex;
            flex-direction: column;
            padding: 16px;
            border-radius: 20px;
            border: 1px solid #F1F5F9;
            transition: all 0.3s ease;
            background-color: white;
            margin-bottom: 12px;
        }

        .day-row.active {
            border-color: #DBEAFE;
            background-color: #EFF6FF;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.05);
        }

        .day-toggle {
            width: 48px;
            height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 14px;
            background-color: #F1F5F9;
            color: #94A3B8;
            font-weight: 900;
            font-size: 0.75rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .day-row.active .day-toggle {
            background-color: #2563EB;
            color: white;
            box-shadow: 0 8px 15px -3px rgba(37, 99, 235, 0.3);
        }

        .time-picker-blueprint {
            font-size: 0.8rem;
            padding: 8px 12px;
            border-radius: 12px;
            border: 1px solid #E2E8F0;
            background-color: white;
            font-weight: 800;
            outline: none;
        }

        .btn-action { transition: all 0.2s ease; }
        .btn-action:active { transform: scale(0.96); }
        
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
    </style>
</head>
<body class="p-6 md:p-10 pb-32">

    <div class="max-w-2xl mx-auto text-left">
        <header class="flex items-center space-x-6 mb-10">
            <button type="button" onclick="window.history.back()" class="p-3 bg-white border border-slate-100 text-slate-900 rounded-2xl shadow-sm hover:bg-slate-50 btn-action">
                <svg class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3">
                    <path d="M15 19l-7-7 7-7"></path>
                </svg>
            </button>
            <div>
                <h1 class="text-4xl font-black text-slate-900 tracking-tighter uppercase italic leading-none">New Program</h1>
                <p class="text-[10px] font-black text-slate-400 uppercase tracking-[0.3em] mt-2">Training Level Definition</p>
            </div>
        </header>

        <form id="create-program-form" class="space-y-6">
            
            <div class="form-card">
                <div class="flex items-center space-x-3 mb-8">
                    <div class="w-10 h-10 bg-blue-50 rounded-xl flex items-center justify-center text-blue-600 shadow-inner">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 10h6"></path></svg>
                    </div>
                    <h3 class="text-xs font-black text-slate-400 uppercase tracking-[0.2em]">Program Details</h3>
                </div>

                <div class="space-y-6">
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Program Title (Level)</label>
                        <div class="input-group">
                            <input type="text" name="name" required placeholder="E.G., INTERMEDIATE STROKE SQUAD">
                        </div>
                    </div>
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Description</label>
                        <div class="input-group">
                            <textarea name="description" rows="3" required placeholder="Outline the technical focus and goals..."></textarea>
                        </div>
                    </div>
                </div>
            </div>

            <div class="form-card">
                <div class="flex items-center space-x-3 mb-8">
                    <div class="w-10 h-10 bg-emerald-50 rounded-xl flex items-center justify-center text-emerald-600 shadow-inner">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                    </div>
                    <h3 class="text-xs font-black text-slate-400 uppercase tracking-[0.2em]">Price & capacity</h3>
                </div>
                <div class="grid grid-cols-2 gap-6">
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Subscription</label>
                        <div class="input-group">
                            <input type="number" name="price" required step="0.01" placeholder="120.00">
                        </div>
                    </div>
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Maximum Capacity</label>
                        <div class="input-group">
                            <input type="number" name="capacity" required min="1" placeholder="20">
                        </div>
                    </div>
                </div>
            </div>

            <div class="form-card">
                <div class="flex items-center space-x-3 mb-8">
                    <div class="w-10 h-10 bg-purple-50 rounded-xl flex items-center justify-center text-purple-600 shadow-inner">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                    </div>
                    <h3 class="text-xs font-black text-slate-400 uppercase tracking-[0.2em]">Weekly Schedule</h3>
                </div>
                
                <div id="schedule-builder" class="space-y-4">
                    <!-- Sat -->
                    <div class="day-row" id="row-Sat">
                        <div class="flex items-center justify-between w-full">
                            <div class="flex items-center space-x-4 cursor-pointer" onclick="toggleDay('Sat')">
                                <div class="day-toggle">SAT</div>
                                <span class="text-xs font-black text-slate-600 uppercase tracking-widest">Saturday</span>
                            </div>
                            <button type="button" onclick="addTimeSlot('Sat')" id="btn-Sat" class="hidden text-[10px] font-black text-blue-600 uppercase tracking-widest transition-all hover:scale-105 active:scale-95">+ Add Slot</button>
                        </div>
                        <div id="slots-Sat" class="hidden mt-4 space-y-3"></div>
                    </div>

                    <!-- Sun -->
                    <div class="day-row" id="row-Sun">
                        <div class="flex items-center justify-between w-full">
                            <div class="flex items-center space-x-4 cursor-pointer" onclick="toggleDay('Sun')">
                                <div class="day-toggle">SUN</div>
                                <span class="text-xs font-black text-slate-600 uppercase tracking-widest">Sunday</span>
                            </div>
                            <button type="button" onclick="addTimeSlot('Sun')" id="btn-Sun" class="hidden text-[10px] font-black text-blue-600 uppercase tracking-widest transition-all hover:scale-105 active:scale-95">+ Add Slot</button>
                        </div>
                        <div id="slots-Sun" class="hidden mt-4 space-y-3"></div>
                    </div>

                    <!-- Mon -->
                    <div class="day-row" id="row-Mon">
                        <div class="flex items-center justify-between w-full">
                            <div class="flex items-center space-x-4 cursor-pointer" onclick="toggleDay('Mon')">
                                <div class="day-toggle">MON</div>
                                <span class="text-xs font-black text-slate-600 uppercase tracking-widest">Monday</span>
                            </div>
                            <button type="button" onclick="addTimeSlot('Mon')" id="btn-Mon" class="hidden text-[10px] font-black text-blue-600 uppercase tracking-widest transition-all hover:scale-105 active:scale-95">+ Add Slot</button>
                        </div>
                        <div id="slots-Mon" class="hidden mt-4 space-y-3"></div>
                    </div>

                    <!-- Tue -->
                    <div class="day-row" id="row-Tue">
                        <div class="flex items-center justify-between w-full">
                            <div class="flex items-center space-x-4 cursor-pointer" onclick="toggleDay('Tue')">
                                <div class="day-toggle">TUE</div>
                                <span class="text-xs font-black text-slate-600 uppercase tracking-widest">Tuesday</span>
                            </div>
                            <button type="button" onclick="addTimeSlot('Tue')" id="btn-Tue" class="hidden text-[10px] font-black text-blue-600 uppercase tracking-widest transition-all hover:scale-105 active:scale-95">+ Add Slot</button>
                        </div>
                        <div id="slots-Tue" class="hidden mt-4 space-y-3"></div>
                    </div>

                    <!-- Wed -->
                    <div class="day-row" id="row-Wed">
                        <div class="flex items-center justify-between w-full">
                            <div class="flex items-center space-x-4 cursor-pointer" onclick="toggleDay('Wed')">
                                <div class="day-toggle">WED</div>
                                <span class="text-xs font-black text-slate-600 uppercase tracking-widest">Wednesday</span>
                            </div>
                            <button type="button" onclick="addTimeSlot('Wed')" id="btn-Wed" class="hidden text-[10px] font-black text-blue-600 uppercase tracking-widest transition-all hover:scale-105 active:scale-95">+ Add Slot</button>
                        </div>
                        <div id="slots-Wed" class="hidden mt-4 space-y-3"></div>
                    </div>

                    <!-- Thu -->
                    <div class="day-row" id="row-Thu">
                        <div class="flex items-center justify-between w-full">
                            <div class="flex items-center space-x-4 cursor-pointer" onclick="toggleDay('Thu')">
                                <div class="day-toggle">THU</div>
                                <span class="text-xs font-black text-slate-600 uppercase tracking-widest">Thursday</span>
                            </div>
                            <button type="button" onclick="addTimeSlot('Thu')" id="btn-Thu" class="hidden text-[10px] font-black text-blue-600 uppercase tracking-widest transition-all hover:scale-105 active:scale-95">+ Add Slot</button>
                        </div>
                        <div id="slots-Thu" class="hidden mt-4 space-y-3"></div>
                    </div>

                    <!-- Fri -->
                    <div class="day-row" id="row-Fri">
                        <div class="flex items-center justify-between w-full">
                            <div class="flex items-center space-x-4 cursor-pointer" onclick="toggleDay('Fri')">
                                <div class="day-toggle">FRI</div>
                                <span class="text-xs font-black text-slate-600 uppercase tracking-widest">Friday</span>
                            </div>
                            <button type="button" onclick="addTimeSlot('Fri')" id="btn-Fri" class="hidden text-[10px] font-black text-blue-600 uppercase tracking-widest transition-all hover:scale-105 active:scale-95">+ Add Slot</button>
                        </div>
                        <div id="slots-Fri" class="hidden mt-4 space-y-3"></div>
                    </div>
                </div>

                <div class="mt-8 grid grid-cols-2 gap-6 pt-6 border-t border-slate-50">
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Cycle Length</label>
                        <div class="input-group">
                            <input type="text" name="duration" required placeholder="E.G., 3 MONTHS">
                        </div>
                    </div>
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Total Unit Sessions</label>
                        <div class="input-group">
                            <input type="number" name="sessions" required min="1" placeholder="24">
                        </div>
                    </div>
                </div>
            </div>

            <div class="fixed bottom-0 left-0 right-0 p-6 bg-white/80 backdrop-blur-md border-t border-slate-100 z-50">
                <button type="submit" class="max-w-2xl mx-auto w-full py-5 bg-emerald-600 text-white rounded-3xl font-black text-sm uppercase tracking-[0.2em] shadow-xl shadow-emerald-600/20 flex items-center justify-center space-x-3 btn-action">
                    <span>Deploy Program</span>
                    <svg class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><path d="M5 13l4 4L19 7"></path></svg>
                </button>
            </div>

        </form>
    </div>

    <script>
        function toggleDay(day) {
            const row = document.getElementById('row-' + day);
            const slotsContainer = document.getElementById('slots-' + day);
            const addBtn = document.getElementById('btn-' + day);
            
            if (row.classList.contains('active')) {
                row.classList.remove('active');
                slotsContainer.classList.add('hidden');
                addBtn.classList.add('hidden');
                slotsContainer.innerHTML = ''; // Clear slots if deactivated
            } else {
                row.classList.add('active');
                slotsContainer.classList.remove('hidden');
                addBtn.classList.remove('hidden');
                addTimeSlot(day); // Add first slot automatically
            }
        }

        function addTimeSlot(day) {
            const container = document.getElementById('slots-' + day);
            const slotDiv = document.createElement('div');
            slotDiv.className = 'flex items-center space-x-3 animate-in fade-in slide-in-from-top-2 duration-300';
            slotDiv.innerHTML = `
                <div class="flex-grow grid grid-cols-2 gap-3 bg-white p-2 rounded-2xl border border-slate-50 shadow-sm">
                    <div class="flex items-center space-x-2 px-2">
                        <span class="text-[8px] font-black text-slate-300 uppercase">From</span>
                        <input type="time" class="time-picker-blueprint w-full border-none bg-transparent" value="16:00" required>
                    </div>
                    <div class="flex items-center space-x-2 px-2 border-l border-slate-50">
                        <span class="text-[8px] font-black text-slate-300 uppercase">To</span>
                        <input type="time" class="time-picker-blueprint w-full border-none bg-transparent" value="17:00" required>
                    </div>
                </div>
                <button type="button" onclick="this.parentElement.remove()" class="p-2 text-slate-300 hover:text-rose-500 transition-colors">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="3"><path d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            `;
            container.appendChild(slotDiv);
        }

        document.getElementById('create-program-form').onsubmit = function(e) {
            e.preventDefault();
            const btn = e.target.querySelector('button[type="submit"]');
            const originalContent = btn.innerHTML;
            
            btn.innerHTML = '<span>Synchronizing Registry...</span>';
            btn.classList.add('opacity-80', 'pointer-events-none');
            
            setTimeout(() => {
                showSnackbar("Program Registered Successfully!");
                setTimeout(() => window.history.back(), 1500);
            }, 1000);
        };

        function showSnackbar(message) {
            const snackbar = document.createElement('div');
            snackbar.textContent = message;
            snackbar.className = "fixed top-10 left-1/2 -translate-x-1/2 bg-slate-900 text-white px-8 py-4 rounded-full text-[10px] font-black shadow-2xl z-[100] uppercase tracking-widest animate-bounce";
            document.body.appendChild(snackbar);
            setTimeout(() => snackbar.remove(), 3000);
        }
    </script>
</body>
</html>