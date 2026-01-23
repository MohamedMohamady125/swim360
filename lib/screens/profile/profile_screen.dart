<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&family=JetBrains+Mono:wght@500&display=swap" rel="stylesheet">
    <title>Swim 360 - Profile Settings</title>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F8FAFC; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
        .animate-in { animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        .shadow-inner-soft { box-shadow: inset 0 2px 4px 0 rgba(0, 0, 0, 0.05); }

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
    </style>
</head>
<body class="no-scrollbar">

    <div class="max-w-md mx-auto min-h-screen bg-[#F8FAFC] pb-12 relative overflow-x-hidden text-left">
        
        <header class="bg-white/90 backdrop-blur-md px-6 pt-12 pb-5 flex items-center justify-between sticky top-0 z-30 border-b border-gray-50">
            <div class="flex items-center space-x-4">
                <button onclick="window.history.back()" class="p-2.5 rounded-2xl border border-gray-100 bg-white text-gray-900 shadow-sm active:scale-90 transition-all">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><polyline points="15 18 9 12 15 6"></polyline></svg>
                </button>
                <div>
                    <h1 class="text-2xl font-black text-gray-900 tracking-tight uppercase leading-none">Profile</h1>
                    <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mt-1">Identity & Path</p>
                </div>
            </div>
            <button class="p-3 bg-amber-400 rounded-2xl text-white shadow-lg shadow-amber-100 active:scale-90 transition-all">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg>
            </button>
        </header>

        <main class="p-6 space-y-8 animate-in">
            
            <section class="flex flex-col items-center py-4">
                <div class="relative group">
                    <div id="avatar-container" class="w-32 h-32 rounded-[44px] overflow-hidden border-4 border-white shadow-2xl shadow-blue-100 rotate-3 transition-all duration-500 bg-gray-100">
                        <img id="profile-img" src="https://placehold.co/200x200/2563eb/white?text=Y" class="w-full h-full object-cover">
                    </div>
                    <label class="absolute -bottom-2 -right-2 p-3 bg-blue-600 text-white rounded-2xl shadow-xl border-4 border-white active:scale-90 transition-all cursor-pointer">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path><circle cx="12" cy="13" r="4"></circle></svg>
                        <input type="file" id="photo-upload" class="hidden" accept="image/*">
                    </label>
                </div>
                <div class="text-center mt-6">
                    <h2 id="display-name" class="text-3xl font-black text-gray-900 tracking-tighter leading-none italic uppercase">Yehia Mansour</h2>
                    <div id="role-badge" class="mt-3 inline-flex items-center px-4 py-1.5 bg-gray-100 text-gray-400 rounded-full text-[10px] font-black uppercase tracking-widest border border-gray-200">
                        <span id="role-dot" class="w-2 h-2 rounded-full mr-2 bg-gray-300"></span>
                        <span id="role-text">Path Not Chosen</span>
                    </div>
                </div>
            </section>

            <section class="bg-white p-6 rounded-[32px] border border-gray-100 shadow-sm space-y-6">
                <div>
                    <div class="flex justify-between items-center mb-2 ml-1">
                        <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Username</label>
                        <span id="name-cooldown" class="text-[8px] font-bold text-blue-600 uppercase tracking-widest hidden">Available in 7 Days</span>
                    </div>
                    <div class="relative flex items-center">
                        <div id="name-input-wrapper" class="flex-grow p-4 bg-gray-50 rounded-2xl border-none shadow-inner-soft transition-all">
                            <input type="text" id="name-input" value="Yehia Mansour" readonly class="bg-transparent border-none outline-none font-bold text-gray-800 w-full text-sm uppercase">
                        </div>
                        <button id="edit-name-btn" onclick="toggleEditName()" class="ml-3 p-4 bg-white rounded-2xl shadow-md text-gray-400 active:scale-90 transition-all">
                            <svg id="edit-icon" xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg>
                        </button>
                    </div>
                </div>

                <div>
                    <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest ml-1">Secure ID</label>
                    <div class="flex items-center p-4 bg-gray-50/50 rounded-2xl border border-gray-100 mt-2 opacity-60">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 mr-3 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg>
                        <span class="font-bold text-gray-500 text-sm italic">yehia.mansour@swim360.com</span>
                    </div>
                </div>
            </section>

            <section class="space-y-4">
                <label class="text-[10px] font-black text-gray-400 uppercase tracking-widest ml-1">Account Mode</label>
                <button id="open-role-picker" onclick="toggleRolePicker(true)" class="w-full bg-white p-6 rounded-[32px] border border-gray-100 shadow-sm flex items-center justify-between active:bg-gray-50 transition-all">
                    <div class="flex items-center">
                        <div id="selected-role-icon-bg" class="w-12 h-12 rounded-2xl bg-gray-50 flex items-center justify-center mr-4 shadow-inner text-gray-300">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                        </div>
                        <div class="text-left">
                            <p id="selected-role-name" class="font-black text-gray-900 leading-none uppercase">Select Role</p>
                            <p id="selected-role-desc" class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mt-1.5">Choose carefully</p>
                        </div>
                    </div>
                    <svg id="role-chevron" xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><polyline points="6 9 12 15 18 9"></polyline></svg>
                </button>
            </section>

            <section class="flex flex-col space-y-4 pb-12">
                <div onclick="toggleWallet(true)" class="relative group w-full rounded-[28px] p-6 text-white cursor-pointer overflow-hidden flex items-center active:scale-95 transition-all shadow-xl shadow-blue-100" style="background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%)">
                    <div class="w-14 h-14 bg-white/20 backdrop-blur rounded-[20px] flex items-center justify-center mr-5 border border-white/10"><svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect><line x1="1" y1="10" x2="23" y2="10"></line></svg></div>
                    <div class="flex-grow"><h3 class="font-black text-xl leading-none uppercase italic tracking-tighter">My Wallet</h3><p class="text-[10px] font-black uppercase tracking-widest mt-2 opacity-80">Manage Payment Cards</p></div>
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 text-white/40" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><polyline points="9 18 15 12 9 6"></polyline></svg>
                </div>

                <div onclick="showLogoutConfirm()" class="relative group w-full rounded-[28px] p-6 text-white cursor-pointer overflow-hidden flex items-center active:scale-95 transition-all shadow-xl shadow-rose-100" style="background: linear-gradient(135deg, #f43f5e 0%, #e11d48 100%)">
                    <div class="w-14 h-14 bg-white/20 backdrop-blur rounded-[20px] flex items-center justify-center mr-5 border border-white/10"><svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1-2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg></div>
                    <div class="flex-grow"><h3 class="font-black text-xl leading-none uppercase italic tracking-tighter">Log Out</h3><p class="text-[10px] font-black uppercase tracking-widest mt-2 opacity-80">Close Secure Session</p></div>
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6 text-white/40" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><polyline points="9 18 15 12 9 6"></polyline></svg>
                </div>
            </section>
        </main>

        <div id="wallet-overlay" class="fixed inset-0 z-50 flex items-end justify-center px-4 pb-10 bg-slate-900/60 backdrop-blur-sm hidden transition-opacity">
            <div class="bg-white w-full max-w-sm rounded-[44px] p-8 shadow-2xl animate-in relative overflow-hidden text-left">
                <button onclick="toggleWallet(false)" class="absolute top-6 right-6 p-2 bg-gray-50 rounded-full text-gray-400 active:scale-90"><svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg></button>
                <h3 class="text-2xl font-black text-gray-900 uppercase italic mb-6">My Wallet</h3>
                
                <div id="wallet-main-view" class="space-y-6">
                    <div id="cards-list" class="space-y-3">
                        <div class="p-4 bg-gray-50 rounded-[24px] border-2 border-blue-100 flex items-center justify-between">
                            <div class="flex items-center space-x-3">
                                <div class="bg-white p-2 rounded-xl text-blue-900 font-black italic text-[10px]">VISA</div>
                                <p class="text-sm font-black text-gray-900 leading-none">•••• 4242</p>
                            </div>
                        </div>
                    </div>
                    <button onclick="showAddCardUI(true)" class="w-full py-4 border-2 border-dashed border-gray-200 text-gray-400 rounded-[24px] font-black text-xs uppercase tracking-widest">+ Add New Card</button>
                </div>

                <div id="wallet-add-ui" class="hidden space-y-6 animate-in">
                    <div id="card-preview" class="card-visual mx-auto text-white relative">
                        <div class="chip"></div>
                        <div id="p-logo" class="absolute top-6 right-6 font-black italic text-[10px]">CARD</div>
                        <div id="p-num" class="text-lg tracking-widest mb-6 pt-2">•••• •••• •••• ••••</div>
                        <div class="flex justify-between uppercase">
                            <div class="flex-1 pr-4"><div class="text-[8px] opacity-60">Holder</div><div id="p-name" class="text-xs truncate">NAME</div></div>
                            <div><div class="text-[8px] opacity-60">Expiry</div><div id="p-exp" class="text-xs">MM/YY</div></div>
                        </div>
                    </div>
                    <div class="space-y-4">
                        <input type="text" id="c-num" maxlength="19" placeholder="Number" class="w-full p-4 bg-gray-50 rounded-2xl shadow-inner-soft outline-none font-bold text-sm">
                        <input type="text" id="c-name" placeholder="Full Name" class="w-full p-4 bg-gray-50 rounded-2xl shadow-inner-soft outline-none font-bold text-sm uppercase">
                        <div class="grid grid-cols-2 gap-4">
                            <input type="text" id="c-exp" maxlength="5" placeholder="MM/YY" class="p-4 bg-gray-50 rounded-2xl shadow-inner-soft outline-none font-bold text-sm">
                            <input type="password" id="c-cvv" maxlength="3" placeholder="CVV" class="p-4 bg-gray-50 rounded-2xl shadow-inner-soft outline-none font-bold text-sm">
                        </div>
                        <div class="flex space-x-3">
                            <button onclick="showAddCardUI(false)" class="flex-1 py-4 bg-gray-100 rounded-2xl font-black text-xs">CANCEL</button>
                            <button id="btn-save-card" onclick="saveCard()" class="flex-[2] py-4 bg-blue-600 text-white rounded-2xl font-black text-xs opacity-40 pointer-events-none">SAVE</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="role-picker-overlay" class="fixed inset-0 z-50 flex items-end justify-center px-4 pb-10 bg-slate-900/60 backdrop-blur-sm hidden transition-opacity">
            <div class="bg-white w-full max-w-sm rounded-[44px] p-8 shadow-2xl animate-in relative overflow-hidden text-left">
                <button onclick="toggleRolePicker(false)" class="absolute top-6 right-6 p-2 bg-gray-50 rounded-full text-gray-400 active:scale-90"><svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg></button>
                <div class="mb-6">
                    <h3 class="text-2xl font-black text-gray-900 tracking-tight uppercase italic leading-none">Select Mode</h3>
                    <p class="text-[10px] font-bold text-rose-600 uppercase tracking-widest mt-2 italic">Choose your life-long identity</p>
                </div>
                <div class="space-y-3 max-h-[350px] overflow-y-auto no-scrollbar" id="role-options-list"></div>
                <div class="pt-6">
                    <button id="pre-confirm-btn" disabled onclick="showFinalConfirmation()" class="w-full py-5 bg-blue-600 text-white rounded-[24px] font-black text-sm uppercase tracking-widest shadow-xl opacity-40 pointer-events-none transition-all">Confirm Identity</button>
                </div>
            </div>
        </div>

        <div id="final-confirm-modal" class="fixed inset-0 z-[100] flex items-center justify-center p-6 bg-slate-900/80 backdrop-blur-md hidden text-center">
            <div class="bg-white w-full max-w-sm rounded-[40px] p-8 shadow-2xl space-y-8 animate-in">
                <div class="w-20 h-20 bg-rose-50 text-rose-600 rounded-[30px] flex items-center justify-center mx-auto border-2 border-rose-100">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-10 h-10" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><path d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                </div>
                <div>
                    <h3 class="text-2xl font-black text-gray-900 tracking-tighter uppercase italic">Permanent Lock?</h3>
                    <p class="text-sm text-gray-500 font-medium mt-3 px-2 leading-relaxed">Once set, your account mode <span class="text-rose-600 font-black">CANNOT</span> be changed ever. Are you 100% sure?</p>
                </div>
                <div class="flex flex-col space-y-3">
                    <button onclick="lockRole()" class="w-full py-5 bg-rose-600 text-white rounded-[24px] font-black text-xs uppercase tracking-widest shadow-xl active:scale-95">Yes, Lock Identity</button>
                    <button onclick="hideFinalConfirmation()" class="w-full py-4 bg-gray-50 text-gray-400 rounded-[24px] font-bold text-xs uppercase tracking-widest active:scale-95">Go back</button>
                </div>
            </div>
        </div>

        <div id="logout-confirm-modal" class="fixed inset-0 z-[100] flex items-center justify-center p-6 bg-slate-900/80 backdrop-blur-md hidden text-center">
            <div class="bg-white w-full max-w-sm rounded-[40px] p-8 shadow-2xl space-y-8 animate-in">
                <div class="w-20 h-20 bg-rose-50 text-rose-600 rounded-[30px] flex items-center justify-center mx-auto border-2 border-rose-100">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-10 h-10" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1-2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                </div>
                <div>
                    <h3 class="text-2xl font-black text-gray-900 tracking-tighter uppercase italic">Leaving us?</h3>
                    <p class="text-sm text-gray-500 font-medium mt-3 px-2 leading-relaxed">Are you sure you want to log out of your <span class="text-rose-600 font-black">secure session</span>?</p>
                </div>
                <div class="flex flex-col space-y-3">
                    <button onclick="executeLogout()" class="w-full py-5 bg-rose-600 text-white rounded-[24px] font-black text-xs uppercase tracking-widest shadow-xl active:scale-95">Yes, Log Out</button>
                    <button onclick="hideLogoutConfirm()" class="w-full py-4 bg-gray-50 text-gray-400 rounded-[24px] font-bold text-xs uppercase tracking-widest active:scale-95">Go back</button>
                </div>
            </div>
        </div>

        <div id="toast" class="fixed bottom-10 left-1/2 -translate-x-1/2 bg-gray-900 text-white px-8 py-4 rounded-full text-[10px] font-black shadow-2xl z-[100] hidden uppercase tracking-widest text-center"></div>
    </div>

    <script>
        let isEditing = false, isLocked = false, selectedRole = null, lastNameChangeDate = null;

        const roles = [
            { id: 'swimmer', name: 'Swimmer', desc: 'Manage your training', icon: '<path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/>' },
            { id: 'coach', name: 'Coach', desc: 'Train and mentor', icon: '<circle cx="12" cy="8" r="7"/><polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"/>' },
            { id: 'parent', name: 'Parent', desc: 'Oversee progress', icon: '<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>' },
            { id: 'online-coach', name: 'Online Coach', desc: 'Remote digital programs', icon: '<rect x="2" y="2" width="20" height="20" rx="2.18" ry="2.18"/><line x1="7" y1="2" x2="7" y2="22"/><line x1="17" y1="2" x2="17" y2="22"/><line x1="2" y1="12" x2="22" y2="12"/>' },
            { id: 'clinic', name: 'Clinic', desc: 'Recovery & medical', icon: '<path d="M11 2a2 2 0 0 0-2 2v5H4a2 2 0 0 0-2 2v2c0 1.1.9 2 2 2h5v5c0 1.1.9 2 2 2h2a2 2 0 0 0 2-2v-5h5a2 2 0 0 0 2-2v-2a2 2 0 0 0-2-2h-5V4a2 2 0 0 0-2-2h-2z"/>' },
            { id: 'academy', name: 'Academy', desc: 'Structured swim levels', icon: '<path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3.33 3 8.67 3 12 0v-5"/>' },
            { id: 'shop', name: 'Shop', desc: 'Commerce & gear', icon: '<path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"/><path d="M3 6h18"/><path d="M16 10a4 4 0 0 1-8 0"/>' },
            { id: 'organizer', name: 'Event Organizer', desc: 'Gala management', icon: '<rect x="2" y="7" width="20" height="14" rx="2" ry="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/>' }
        ];

        // LOGOUT LOGIC
        function showLogoutConfirm() { document.getElementById('logout-confirm-modal').classList.remove('hidden'); }
        function hideLogoutConfirm() { document.getElementById('logout-confirm-modal').classList.add('hidden'); }
        function executeLogout() { 
            hideLogoutConfirm();
            showToast("Securely logged out...");
            // Add redirect logic here
        }

        // WALLET LOGIC
        function toggleWallet(show) { document.getElementById('wallet-overlay').classList.toggle('hidden', !show); }
        function showAddCardUI(show) {
            document.getElementById('wallet-main-view').classList.toggle('hidden', show);
            document.getElementById('wallet-add-ui').classList.toggle('hidden', !show);
        }

        document.getElementById('c-num').oninput = (e) => {
            let v = e.target.value.replace(/\D/g, ''); e.target.value = v.match(/.{1,4}/g)?.join(' ') || '';
            document.getElementById('p-num').textContent = e.target.value || '•••• •••• •••• ••••';
            const prev = document.getElementById('card-preview'); const logo = document.getElementById('p-logo');
            if(v.startsWith('4')) { prev.className = 'card-visual visa'; logo.textContent = 'VISA'; }
            else if(v.startsWith('5')) { prev.className = 'card-visual mastercard'; logo.textContent = 'MASTERCARD'; }
            else { prev.className = 'card-visual'; logo.textContent = 'CARD'; }
            const btn = document.getElementById('btn-save-card');
            if(v.length >= 16) btn.classList.remove('opacity-40', 'pointer-events-none');
            else btn.classList.add('opacity-40', 'pointer-events-none');
        };
        document.getElementById('c-name').oninput = (e) => { document.getElementById('p-name').textContent = e.target.value.toUpperCase() || 'NAME'; };
        document.getElementById('c-exp').oninput = (e) => {
            let v = e.target.value.replace(/\D/g, ''); if (v.length > 2) v = v.substring(0, 2) + '/' + v.substring(2, 4);
            e.target.value = v; document.getElementById('p-exp').textContent = v || 'MM/YY';
        };

        function saveCard() {
            const num = document.getElementById('c-num').value.slice(-4);
            const brand = document.getElementById('p-logo').textContent;
            document.getElementById('cards-list').insertAdjacentHTML('beforeend', `<div class="p-4 bg-gray-50 rounded-[24px] border-2 border-transparent flex items-center justify-between mt-3"><div class="flex items-center space-x-3"><div class="bg-white p-2 rounded-xl text-blue-600 font-black italic text-[10px]">${brand}</div><p class="text-sm font-black text-gray-900">•••• ${num}</p></div></div>`);
            showAddCardUI(false); showToast("Card Saved");
        }

        // ROLE PICKER LOGIC
        function toggleRolePicker(show) {
            if (isLocked && show) { showToast("Account mode is permanent", true); return; }
            document.getElementById('role-picker-overlay').classList.toggle('hidden', !show);
            if (show) renderRoles();
        }
        function renderRoles() {
            const list = document.getElementById('role-options-list');
            list.innerHTML = roles.map(r => `<div onclick="preSelect('${r.id}')" id="r-${r.id}" class="r-item p-4 bg-gray-50 rounded-[24px] border-2 border-transparent flex items-center transition-all cursor-pointer mb-2"><div class="w-10 h-10 rounded-xl bg-white shadow-sm flex items-center justify-center mr-3 text-blue-600"><svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2.5">${r.icon}</svg></div><div class="text-left"><p class="text-sm font-black text-gray-900 uppercase italic leading-none">${r.name}</p><p class="text-[8px] font-bold text-gray-400 uppercase mt-1 tracking-widest">${r.desc}</p></div></div>`).join('');
        }
        function preSelect(id) {
            selectedRole = roles.find(r => r.id === id);
            document.querySelectorAll('.r-item').forEach(el => el.classList.remove('border-blue-600', 'bg-blue-50'));
            document.getElementById(`r-${id}`).classList.add('border-blue-600', 'bg-blue-50');
            const btn = document.getElementById('pre-confirm-btn');
            btn.removeAttribute('disabled'); btn.classList.remove('opacity-40', 'pointer-events-none');
        }
        function showFinalConfirmation() { document.getElementById('final-confirm-modal').classList.remove('hidden'); }
        function hideFinalConfirmation() { document.getElementById('final-confirm-modal').classList.add('hidden'); }
        function lockRole() {
            isLocked = true;
            document.getElementById('selected-role-name').textContent = selectedRole.name;
            document.getElementById('selected-role-desc').textContent = "Identity Locked";
            document.getElementById('selected-role-icon-bg').innerHTML = `<svg class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">${selectedRole.icon}</svg>`;
            document.getElementById('selected-role-icon-bg').classList.add('bg-blue-600', 'text-white');
            document.getElementById('role-badge').classList.replace('text-gray-400', 'text-blue-600');
            document.getElementById('role-dot').classList.replace('bg-gray-300', 'bg-blue-600');
            document.getElementById('role-dot').classList.add('animate-pulse');
            document.getElementById('role-text').textContent = selectedRole.name;
            document.getElementById('role-chevron').classList.add('hidden');
            hideFinalConfirmation(); toggleRolePicker(false); showToast("Account Mode Set");
        }

        // PHOTO & NAME
        document.getElementById('photo-upload').onchange = function(e) {
            const file = e.target.files[0]; if (file) {
                const reader = new FileReader(); reader.onload = (ev) => { document.getElementById('profile-img').src = ev.target.result; showToast("Visual Updated"); };
                reader.readAsDataURL(file);
            }
        };
        function toggleEditName() {
            const input = document.getElementById('name-input'), wrapper = document.getElementById('name-input-wrapper'), 
                  icon = document.getElementById('edit-icon'), btn = document.getElementById('edit-name-btn'), 
                  cooldown = document.getElementById('name-cooldown'), now = new Date();
            if (lastNameChangeDate && (now - lastNameChangeDate) < 7 * 24 * 60 * 60 * 1000) { showToast("Wait 7 days", true); return; }
            isEditing = !isEditing;
            if (isEditing) { input.removeAttribute('readonly'); input.focus(); wrapper.classList.add('bg-white', 'ring-4', 'ring-blue-50', 'border-blue-600'); btn.classList.add('bg-blue-600', 'text-white'); icon.innerHTML = '<polyline points="20 6 9 17 4 12"></polyline>'; }
            else { lastNameChangeDate = new Date(); input.setAttribute('readonly', true); wrapper.classList.remove('bg-white', 'ring-4', 'ring-blue-50', 'border-blue-600'); btn.classList.remove('bg-blue-600', 'text-white'); icon.innerHTML = '<path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path>'; document.getElementById('display-name').textContent = input.value; cooldown.classList.remove('hidden'); showToast("Name Locked"); }
        }
        function showToast(msg, err = false) { const t = document.getElementById('toast'); t.textContent = msg; t.classList.toggle('bg-rose-600', err); t.classList.remove('hidden'); setTimeout(() => t.classList.add('hidden'), 2500); }
    </script>
</body>
</html>