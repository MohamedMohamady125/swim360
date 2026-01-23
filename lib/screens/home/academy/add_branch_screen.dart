<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - Add Academy Branch</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F8FAFC; color: #0F172A; }
        
        /* THE BLUEPRINT STANDARD: 32px Radius & Inner Depth */
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

        .input-group input, .input-group select {
            border: none;
            outline: none;
            padding: 14px 0;
            flex-grow: 1;
            background-color: transparent;
            font-weight: 700;
            font-size: 0.875rem;
        }

        .day-pill {
            padding: 10px 18px;
            border-radius: 14px;
            font-size: 0.75rem;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            cursor: pointer;
            transition: all 0.3s;
            background-color: #F1F5F9;
            color: #94A3B8;
        }

        .day-pill.active {
            background-color: #2563EB;
            color: white;
            box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.3);
            transform: translateY(-2px);
        }

        .pool-entry {
            background-color: #F8FAFC;
            border-radius: 24px;
            padding: 1.5rem;
            border: 1px dashed #E2E8F0;
            position: relative;
        }

        .btn-action {
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .btn-action:active { transform: scale(0.96); }

        .no-scrollbar::-webkit-scrollbar { display: none; }
    </style>
</head>
<body class="p-6 md:p-10 pb-32 no-scrollbar">

    <div class="max-w-2xl mx-auto">
        <header class="flex items-center space-x-6 mb-10">
            <button onclick="window.history.back()" class="p-3 bg-white border border-slate-100 text-slate-900 rounded-2xl shadow-sm hover:bg-slate-50 btn-action">
                <svg class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3">
                    <path d="M15 19l-7-7 7-7"></path>
                </svg>
            </button>
            <div>
                <h1 class="text-4xl font-black text-slate-900 tracking-tighter uppercase italic leading-none">Add Branch</h1>
                <p class="text-[10px] font-black text-slate-400 uppercase tracking-[0.3em] mt-2">New Academy Node Configuration</p>
            </div>
        </header>

        <form id="add-branch-form" class="space-y-6">
            
            <div class="form-card">
                <div class="flex items-center space-x-3 mb-8">
                    <div class="w-10 h-10 bg-blue-50 rounded-xl flex items-center justify-center text-blue-600 shadow-inner">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M3 21h18M3 7v1a3 3 0 0 0 6 0V7m0 1a3 3 0 0 0 6 0V7m0 1a3 3 0 0 0 6 0V7M4 21V4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v17"/></svg>
                    </div>
                    <h3 class="text-xs font-black text-slate-400 uppercase tracking-[0.2em]">Branch details</h3>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="md:col-span-2">
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Branch Name</label>
                        <div class="input-group">
                            <input type="text" name="name" required placeholder="DOWNTOWN AQUATIC HUB">
                        </div>
                    </div>
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Operation City</label>
                        <div class="input-group">
                            <input type="text" name="city" required placeholder="RIYADH">
                        </div>
                    </div>
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Location (URL)</label>
                        <div class="input-group">
                            <input type="url" name="location_url" required placeholder="HTTPS://MAPS.GOOGLE.COM/...">
                        </div>
                    </div>
                </div>
            </div>

            <div class="form-card">
                <div class="flex items-center space-x-3 mb-8">
                    <div class="w-10 h-10 bg-purple-50 rounded-xl flex items-center justify-center text-purple-600 shadow-inner">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                    </div>
                    <h3 class="text-xs font-black text-slate-400 uppercase tracking-[0.2em]">Operating Hours</h3>
                </div>
                
                <div class="mb-8">
                    <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-4">Weekly Cycle</label>
                    <div class="flex flex-wrap gap-2">
                        <div class="day-pill" onclick="this.classList.toggle('active')">Sat</div>
                        <div class="day-pill" onclick="this.classList.toggle('active')">Sun</div>
                        <div class="day-pill" onclick="this.classList.toggle('active')">Mon</div>
                        <div class="day-pill" onclick="this.classList.toggle('active')">Tue</div>
                        <div class="day-pill" onclick="this.classList.toggle('active')">Wed</div>
                        <div class="day-pill" onclick="this.classList.toggle('active')">Thu</div>
                        <div class="day-pill" onclick="this.classList.toggle('active')">Fri</div>
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-6">
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Opening</label>
                        <div class="input-group">
                            <input type="time" name="open_time" required>
                        </div>
                    </div>
                    <div>
                        <label class="block text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-2">Closing</label>
                        <div class="input-group">
                            <input type="time" name="close_time" required>
                        </div>
                    </div>
                </div>
            </div>

            <div class="form-card">
                <div class="flex justify-between items-center mb-8 pb-4 border-b border-slate-50">
                    <div class="flex items-center space-x-3">
                        <div class="w-10 h-10 bg-emerald-50 rounded-xl flex items-center justify-center text-emerald-600 shadow-inner">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M2 6c.6.5 1.2 1 2.5 1C5.8 7 7.2 6 8.5 6c1.3 0 2.7 1 4 1 1.3 0 2.7-1 4-1 1.3 0 2.7 1 3.5 1"></path><path d="M2 12c.6.5 1.2 1 2.5 1 1.3 0 2.7-1 4-1 1.3 0 2.7 1 4 1 1.3 0 2.7-1 4-1 1.3 0 2.7 1 3.5 1"></path><path d="M2 18c.6.5 1.2 1 2.5 1 1.3 0 2.7-1 4-1 1.3 0 2.7 1 4 1 1.3 0 2.7-1 4-1 1.3 0 2.7 1 3.5 1"></path></svg>
                        </div>
                        <h3 class="text-xs font-black text-slate-400 uppercase tracking-[0.2em]">Capacity</h3>
                    </div>
                    <button type="button" onclick="addPoolEntry()" class="text-[10px] font-black text-blue-600 uppercase tracking-widest hover:text-blue-800 transition-all">+ Add Asset</button>
                </div>
                
                <div id="pools-container" class="space-y-6">
                    <div class="pool-entry shadow-sm animate-in">
                        <div class="space-y-4">
                            <div>
                                <label class="text-[9px] font-black text-slate-400 uppercase tracking-widest ml-1">Pools</label>
                                <div class="input-group mt-2">
                                    <input type="text" class="pool-name" required placeholder="MAIN COMPETITION POOL">
                                </div>
                            </div>
                            <div class="grid grid-cols-2 gap-4">
                                <div>
                                    <label class="text-[9px] font-black text-slate-400 uppercase tracking-widest ml-1">Lanes</label>
                                    <div class="input-group mt-2">
                                        <input type="number" class="pool-lanes" required min="1" placeholder="8">
                                    </div>
                                </div>
                                <div>
                                    <label class="text-[9px] font-black text-slate-400 uppercase tracking-widest ml-1">Maximum Capacity</label>
                                    <div class="input-group mt-2">
                                        <input type="number" class="pool-capacity" required min="1" placeholder="40">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="fixed bottom-0 left-0 right-0 p-6 bg-white/80 backdrop-blur-md border-t border-slate-100 z-50">
                <button type="submit" class="max-w-2xl mx-auto w-full py-5 bg-emerald-600 text-white rounded-3xl font-black text-sm uppercase tracking-[0.2em] shadow-xl shadow-emerald-600/20 flex items-center justify-center space-x-3 btn-action">
                    <span>CREATE BRANCH</span>
                    <svg class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><path d="M5 13l4 4L19 7"></path></svg>
                </button>
            </div>

        </form>
    </div>

    <script>
        function addPoolEntry() {
            const container = document.getElementById('pools-container');
            const entry = document.createElement('div');
            entry.className = 'pool-entry shadow-sm animate-in mt-6';
            entry.innerHTML = `
                <button type="button" onclick="this.parentElement.remove()" class="absolute -top-3 -right-3 bg-rose-100 text-rose-600 rounded-full p-2 shadow-lg hover:bg-rose-200 transition-all border-4 border-white">
                    <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><path d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
                <div class="space-y-4">
                    <div>
                        <label class="text-[9px] font-black text-slate-400 uppercase tracking-widest ml-1">Pools</label>
                        <div class="input-group mt-2">
                            <input type="text" class="pool-name" required placeholder="SECONDARY TRAINING Pool">
                        </div>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="text-[9px] font-black text-slate-400 uppercase tracking-widest ml-1">Lanes</label>
                            <div class="input-group mt-2">
                                <input type="number" class="pool-lanes" required min="1" placeholder="4">
                            </div>
                        </div>
                        <div>
                            <label class="text-[9px] font-black text-slate-400 uppercase tracking-widest ml-1">Volume Cap.</label>
                            <div class="input-group mt-2">
                                <input type="number" class="pool-capacity" required min="1" placeholder="20">
                            </div>
                        </div>
                    </div>
                </div>
            `;
            container.appendChild(entry);
        }

        document.getElementById('add-branch-form').onsubmit = function(e) {
            e.preventDefault();
            const btn = e.target.querySelector('button[type="submit"]');
            btn.innerHTML = '<span>Processing Registry...</span>';
            btn.classList.add('opacity-80', 'pointer-events-none');
            
            setTimeout(() => {
                showSnackbar("Registry Updated Successfully!");
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