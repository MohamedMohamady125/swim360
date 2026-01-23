<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <title>Swim 360 - Global Settings</title>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F8FAFC; color: #0F172A; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        .animate-in { animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        
        /* Custom Toggle Standardized */
        .toggle-container { position: relative; width: 52px; height: 28px; }
        .toggle-input { opacity: 0; width: 0; height: 0; }
        .toggle-slider { 
            position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; 
            background-color: #E2E8F0; transition: .3s; border-radius: 34px; 
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.05);
        }
        .toggle-slider:before { 
            position: absolute; content: ""; height: 20px; width: 20px; left: 4px; bottom: 4px; 
            background-color: white; transition: .3s; border-radius: 50%; shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        input:checked + .toggle-slider { background-color: #2563eb; }
        input:checked + .toggle-slider:before { transform: translateX(24px); }
        
        select { -webkit-appearance: none; appearance: none; }
    </style>
</head>
<body class="no-scrollbar">

    <div class="max-w-md mx-auto min-h-screen bg-[#F8FAFC] pb-12 relative">
        
        <header class="bg-white/90 backdrop-blur-md px-6 pt-12 pb-5 flex items-center justify-between sticky top-0 z-30 border-b border-gray-50">
            <div class="flex items-center space-x-4">
                <button onclick="window.history.back()" class="p-2.5 rounded-2xl border border-gray-100 bg-white text-gray-900 shadow-sm active:scale-90 transition-all">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><polyline points="15 18 9 12 15 6"></polyline></svg>
                </button>
                <div>
                    <h1 id="settings-title" class="text-2xl font-black text-gray-900 tracking-tight uppercase leading-none italic">Settings</h1>
                    <p class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] mt-1.5">App Configuration</p>
                </div>
            </div>
            <div class="w-11 h-11 rounded-2xl bg-blue-50 flex items-center justify-center text-blue-600 border border-blue-100 shadow-inner">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
            </div>
        </header>

        <main class="p-6 space-y-6 animate-in text-left">
            
            <section class="bg-white p-6 rounded-[32px] border border-gray-100 shadow-sm space-y-6">
                <div class="flex items-center space-x-2">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M12 20h9"/><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"/></svg>
                    <h3 class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em]">Preferences</h3>
                </div>

                <div class="flex items-center justify-between">
                    <div>
                        <p id="language-label" class="text-sm font-black text-gray-900 uppercase italic">Language</p>
                        <p class="text-[9px] font-bold text-gray-400 uppercase tracking-widest mt-1">Select Interface</p>
                    </div>
                    <div class="relative min-w-[120px]">
                        <select id="language-select" class="w-full pl-4 pr-10 py-3 bg-gray-50 border-none rounded-2xl text-[10px] font-black uppercase tracking-widest shadow-inner outline-none text-blue-600">
                            <option value="en">English</option>
                            <option value="ar">العربية</option>
                        </select>
                        <svg xmlns="http://www.w3.org/2000/svg" class="absolute right-4 top-1/2 -translate-y-1/2 w-4 h-4 text-blue-600 pointer-events-none" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </div>
                </div>

                <div class="h-px bg-gray-50"></div>

                <div class="flex items-center justify-between">
                    <div>
                        <p id="notifications-label" class="text-sm font-black text-gray-900 uppercase italic">Notifications</p>
                        <p class="text-[9px] font-bold text-gray-400 uppercase tracking-widest mt-1">Global Alerts</p>
                    </div>
                    <label class="toggle-container">
                        <input type="checkbox" class="toggle-input" id="notifications-toggle" checked>
                        <span class="toggle-slider"></span>
                    </label>
                </div>
            </section>

            <section class="bg-white p-6 rounded-[32px] border border-gray-100 shadow-sm space-y-6">
                <div class="flex items-center space-x-2">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                    <h3 class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em]">Support</h3>
                </div>

                <div onclick="toggleFaq(true)" class="flex items-center justify-between cursor-pointer active:scale-95 transition-all group">
                    <div class="flex items-center">
                        <div class="w-10 h-10 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center mr-4 shadow-inner">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                        </div>
                        <div>
                            <p id="help-label" class="text-sm font-black text-gray-900 uppercase italic">Help & FAQ</p>
                            <p class="text-[9px] font-bold text-gray-400 uppercase tracking-widest mt-1">Read Guides</p>
                        </div>
                    </div>
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-gray-300 group-hover:text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><polyline points="9 18 15 12 9 6"></polyline></svg>
                </div>

                <div class="h-px bg-gray-50"></div>

                <a href="https://wa.me/201001234567" target="_blank" class="flex items-center justify-between active:scale-95 transition-all group">
                    <div class="flex items-center">
                        <div class="w-10 h-10 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center mr-4 shadow-inner">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 1 1-7.6-10.6 8.38 8.38 0 0 1 3.8.9L21 3.5Z"></path></svg>
                        </div>
                        <div>
                            <p class="text-sm font-black text-gray-900 uppercase italic">Contact Support</p>
                            <p class="text-[9px] font-bold text-emerald-500 uppercase tracking-widest mt-1">WhatsApp Chat</p>
                        </div>
                    </div>
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-gray-300 group-hover:text-emerald-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><polyline points="9 18 15 12 9 6"></polyline></svg>
                </a>
            </section>
        </main>

        <div id="faq-modal" class="fixed inset-0 z-50 flex items-end justify-center px-4 pb-10 bg-slate-900/60 backdrop-blur-sm hidden transition-opacity">
            <div class="bg-white w-full max-w-sm rounded-[44px] p-8 shadow-2xl animate-in relative overflow-hidden text-left">
                <button onclick="toggleFaq(false)" class="absolute top-6 right-6 p-2 bg-gray-50 rounded-full text-gray-400 active:scale-90 transition-all">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
                
                <h3 id="modal-title" class="text-2xl font-black text-gray-900 tracking-tight leading-none uppercase italic mb-8">Help Center</h3>

                <div id="faq-content" class="space-y-6 max-h-[350px] overflow-y-auto no-scrollbar pr-2">
                    </div>

                <div class="pt-8">
                    <button onclick="toggleFaq(false)" class="w-full py-5 bg-blue-600 text-white rounded-[24px] font-black text-sm uppercase tracking-widest shadow-xl shadow-blue-100 active:scale-95 transition-all">
                        Understand
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        const translations = {
            en: {
                title: "Settings", language: "Language", notify: "Notifications", help: "Help & FAQ",
                modalTitle: "Help Center", closeBtn: "Understand",
                faqs: [
                    { q: "How do I change my language?", a: "Choose your preferred language from the dropdown menu in the Preferences card." },
                    { q: "What is Swim 360?", a: "The ultimate community platform for competitive swimmers and professional coaches." }
                ]
            },
            ar: {
                title: "الإعدادات", language: "اللغة", notify: "الإشعارات", help: "الأسئلة الشائعة",
                modalTitle: "مركز المساعدة", closeBtn: "فهمت",
                faqs: [
                    { q: "كيف أغير اللغة؟", a: "اختر لغتك المفضلة من القائمة المنسدلة في بطاقة التفضيلات." },
                    { q: "ما هو Swim 360؟", a: "المنصة المجتمعية النهائية للسباحين التنافسيين والمدربين المحترفين." }
                ]
            }
        };

        function updateUI(lang) {
            const t = translations[lang];
            document.body.dir = lang === 'ar' ? 'rtl' : 'ltr';
            document.getElementById('settings-title').textContent = t.title;
            document.getElementById('language-label').textContent = t.language;
            document.getElementById('notifications-label').textContent = t.notify;
            document.getElementById('help-label').textContent = t.help;
            document.getElementById('modal-title').textContent = t.modalTitle;
            
            document.getElementById('faq-content').innerHTML = t.faqs.map(f => `
                <div class="space-y-2">
                    <h4 class="text-sm font-black text-gray-900 uppercase italic tracking-tighter">${f.q}</h4>
                    <p class="text-xs font-bold text-gray-400 leading-relaxed">${f.a}</p>
                    <div class="h-px bg-gray-50 w-full mt-4"></div>
                </div>
            `).join('');
        }

        function toggleFaq(show) {
            const modal = document.getElementById('faq-modal');
            modal.classList.toggle('hidden', !show);
        }

        document.getElementById('language-select').onchange = (e) => updateUI(e.target.value);
        window.onload = () => updateUI('en');
    </script>
</body>
</html>