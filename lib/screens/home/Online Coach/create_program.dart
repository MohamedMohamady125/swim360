<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <title>Swim 360 - Build Program Preview</title>
    <style>
        body { font-family: 'Inter', sans-serif; }
        @keyframes fadeIn { 
            from { opacity: 0; transform: translateY(15px); } 
            to { opacity: 1; transform: translateY(0); } 
        }
        .animate-in { animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        select { -webkit-appearance: none; -moz-appearance: none; appearance: none; }
    </style>
</head>
<body class="bg-[#F8FAFC]">

    <div class="max-w-md mx-auto min-h-screen bg-[#F8FAFC] text-gray-900 pb-20 relative selection:bg-blue-100">
        
        <header class="px-6 pt-12 pb-6 bg-white/90 backdrop-blur-md border-b border-gray-50 sticky top-0 z-30">
            <div class="flex items-center justify-between text-left">
                <div class="flex items-center space-x-3">
                    <div class="p-2.5 bg-blue-600 rounded-2xl text-white shadow-lg shadow-blue-100">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg>
                    </div>
                    <div>
                        <h1 class="text-2xl font-black tracking-tight leading-none uppercase">Build Program</h1>
                        <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mt-1.5">Curriculum & Pricing</p>
                    </div>
                </div>
                <button class="p-2 bg-gray-50 rounded-full text-gray-400 active:scale-90 transition-all">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                </button>
            </div>
        </header>

        <main class="p-6 space-y-6 animate-in">
            <form id="program-form" class="space-y-6">

                <div class="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-5 text-left">
                    <div class="flex items-center space-x-2">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-blue-600" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                        <h3 class="text-xs font-black text-gray-400 uppercase tracking-widest">General Info</h3>
                    </div>

                    <div class="space-y-4">
                        <div>
                            <label class="text-[10px] font-black text-gray-400 uppercase ml-1">Program Title</label>
                            <input type="text" name="title" required placeholder="e.g. Elite Performance Coaching" 
                                   class="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none shadow-inner transition-all">
                        </div>

                        <div>
                            <label class="text-[10px] font-black text-gray-400 uppercase ml-1">Delivery Method</label>
                            <div class="relative mt-1.5">
                                <select name="type" required class="w-full p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none cursor-pointer">
                                    <option value="live">Live / Scheduled Sessions</option>
                                    <option value="self-paced">Self-Paced (Video Only)</option>
                                    <option value="hybrid">Hybrid (Mixed)</option>
                                </select>
                                <svg xmlns="http://www.w3.org/2000/svg" class="absolute right-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 pointer-events-none" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"></polyline></svg>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-5 text-left">
                    <div class="flex items-center space-x-2">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-blue-600" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="2" width="20" height="20" rx="2.18" ry="2.18"></rect><line x1="7" y1="2" x2="7" y2="22"></line><line x1="17" y1="2" x2="17" y2="22"></line><line x1="2" y1="12" x2="22" y2="12"></line><line x1="2" y1="7" x2="7" y2="7"></line><line x1="2" y1="17" x2="7" y2="17"></line><line x1="17" y1="17" x2="22" y2="17"></line><line x1="17" y1="7" x2="22" y2="7"></line></svg>
                        <h3 class="text-xs font-black text-gray-400 uppercase tracking-widest">Media & Description</h3>
                    </div>

                    <div class="space-y-4">
                        <label class="block">
                            <span class="text-[10px] font-black text-gray-400 uppercase ml-1">Cover Photo</span>
                            <div class="p-8 bg-gray-50 rounded-[24px] flex flex-col items-center justify-center border-2 border-dashed border-gray-200 text-gray-400 mt-1.5 hover:bg-blue-50 transition-all cursor-pointer group relative">
                                <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 mb-2 text-blue-500 group-hover:scale-110 transition-transform" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="17 8 12 3 7 8"></polyline><line x1="12" y1="3" x2="12" y2="15"></line></svg>
                                <span id="cover-file-name" class="text-[10px] font-black uppercase tracking-widest text-center">Upload Image</span>
                                <input type="file" id="cover-photo" class="absolute inset-0 opacity-0 cursor-pointer">
                            </div>
                        </label>

                        <div>
                            <label class="text-[10px] font-black text-gray-400 uppercase ml-1">Intro Video URL</label>
                            <div class="relative mt-1.5">
                                <svg xmlns="http://www.w3.org/2000/svg" class="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-300" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polygon points="23 7 16 12 23 17 23 7"></polygon><rect x="1" y="5" width="15" height="14" rx="2" ry="2"></rect></svg>
                                <input type="url" placeholder="YouTube/Vimeo Link" class="w-full pl-11 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none transition-all">
                            </div>
                        </div>

                        <div>
                            <label class="text-[10px] font-black text-gray-400 uppercase ml-1">Detailed Description</label>
                            <textarea rows="4" placeholder="Goals, workload, and target audience..." 
                                      class="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold resize-none focus:ring-2 focus:ring-blue-500 outline-none shadow-inner"></textarea>
                        </div>
                    </div>
                </div>

                <div class="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-6 text-left">
                    <div class="flex items-center space-x-2">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-blue-600" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="1" x2="12" y2="23"></line><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path></svg>
                        <h3 class="text-xs font-black text-gray-400 uppercase tracking-widest">Pricing & Duration</h3>
                    </div>

                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="text-[10px] font-black text-gray-400 uppercase ml-1">Price ($)</label>
                            <div class="relative mt-1.5">
                                <input type="number" step="0.01" placeholder="199.99" class="w-full p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none shadow-inner">
                            </div>
                        </div>
                        <div>
                            <label class="text-[10px] font-black text-gray-400 uppercase ml-1">Duration</label>
                            <div class="flex mt-1.5 bg-gray-50 rounded-2xl overflow-hidden shadow-inner">
                                <input type="number" placeholder="12" class="w-1/2 p-4 bg-transparent border-none text-sm font-bold outline-none">
                                <select class="w-1/2 bg-gray-100 p-2 text-[10px] font-black uppercase outline-none">
                                    <option>Weeks</option>
                                    <option>Sessions</option>
                                    <option>Months</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="grid grid-cols-2 gap-4">
                        <div class="col-span-1">
                            <label class="text-[10px] font-black text-gray-400 uppercase ml-1">Max Clients</label>
                            <input type="number" placeholder="Unlimited" class="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none shadow-inner">
                        </div>
                        <div class="col-span-1">
                            <label class="text-[10px] font-black text-gray-400 uppercase ml-1">End Date</label>
                            <input type="date" class="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none shadow-inner">
                        </div>
                    </div>
                </div>

                <div class="pt-4">
                    <button type="submit" id="submit-btn" class="w-full py-5 bg-emerald-500 text-white rounded-[24px] font-black text-sm shadow-xl shadow-emerald-500/20 active:scale-95 transition-all uppercase tracking-[0.2em]">
                        Publish Program
                    </button>
                </div>
            </form>
        </main>
    </div>

    <script>
        // File update logic
        document.getElementById('cover-photo').addEventListener('change', function(e) {
            const fileName = e.target.files[0] ? e.target.files[0].name : "Upload Image";
            document.getElementById('cover-file-name').textContent = fileName;
            document.getElementById('cover-file-name').classList.add('text-blue-600');
        });

        // Form Submit mock
        document.getElementById('program-form').addEventListener('submit', function(e) {
            e.preventDefault();
            const btn = document.getElementById('submit-btn');
            btn.textContent = "Publishing...";
            btn.style.opacity = "0.7";
            
            setTimeout(() => {
                btn.textContent = "Published!";
                btn.classList.replace('bg-emerald-500', 'bg-blue-600');
                btn.style.opacity = "1";
            }, 1500);
        });
    </script>
</body>
</html>
