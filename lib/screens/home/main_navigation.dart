<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <title>Swim 360 - Dashboard</title>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F3F4F6; color: #1F2937; }
        
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes slideUpCard {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .view-animate { animation: fadeInUp 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .animate-card { animation: slideUpCard 0.7s cubic-bezier(0.16, 1, 0.3, 1) forwards; opacity: 0; }
        .delay-1 { animation-delay: 0.1s; }
        .delay-2 { animation-delay: 0.2s; }
        
        .nav-item { transition: all 0.3s ease; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        
        /* Premium Category Card Styling */
        .category-card {
            position: relative;
            overflow: hidden;
            border-radius: 28px;
            aspect-ratio: 1 / 1.15;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .category-card:active { transform: scale(0.96); }
        
        .image-bg {
            position: absolute;
            inset: 0;
            background-size: cover;
            background-position: center;
            transition: transform 0.6s ease;
        }
        .category-card:hover .image-bg { transform: scale(1.08); }

        .overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to bottom, rgba(0,0,0,0.05) 0%, rgba(0,0,0,0.2) 50%, rgba(0,0,0,0.85) 100%);
        }

        .shadow-blueprint { box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 10px 10px -5px rgba(0, 0, 0, 0.02); }
    </style>
</head>
<body class="flex flex-col min-h-screen no-scrollbar">

    <main class="flex-grow p-6 pt-10" id="main-content">
        </main>

    <nav class="sticky bottom-0 bg-white border-t border-gray-100 px-6 py-4 flex justify-between items-center rounded-t-[32px] shadow-2xl z-50">
        <button onclick="changeTab(0)" class="nav-item flex flex-col items-center space-y-1 text-blue-600" id="nav-0">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                <path d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path>
            </svg>
            <span class="text-[10px] font-black uppercase tracking-widest">Home</span>
        </button>

        <button onclick="changeTab(1)" class="nav-item flex flex-col items-center space-y-1 text-gray-400" id="nav-1">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line>
            </svg>
            <span class="text-[10px] font-black uppercase tracking-widest">Events</span>
        </button>

        <button onclick="changeTab(2)" class="nav-item flex flex-col items-center space-y-1 text-gray-400" id="nav-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                <circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 002 1.61h9.72a2 2 0 002-1.61L23 6H6"></path>
            </svg>
            <span class="text-[10px] font-black uppercase tracking-widest">Market</span>
        </button>

        <button onclick="changeTab(3)" class="nav-item flex flex-col items-center space-y-1 text-gray-400" id="nav-3">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle>
            </svg>
            <span class="text-[10px] font-black uppercase tracking-widest">Profile</span>
        </button>
    </nav>

    <script>
        let currentIndex = 0;

        function changeTab(index) {
            currentIndex = index;
            document.querySelectorAll('.nav-item').forEach((el, i) => {
                if (i === index) el.classList.replace('text-gray-400', 'text-blue-600');
                else el.classList.replace('text-blue-600', 'text-gray-400');
            });
            renderView();
        }

        function renderView() {
            const content = document.getElementById('main-content');
            content.classList.remove('view-animate');
            void content.offsetWidth; 
            content.classList.add('view-animate');

            if (currentIndex === 0) {
                content.innerHTML = `
                    <div class="bg-white p-8 rounded-[32px] shadow-blueprint border border-gray-50 text-left">
                        <div class="flex justify-between items-start">
                            <div>
                                <h1 class="text-4xl font-black text-blue-600 uppercase italic tracking-tighter">Dashboard</h1>
                                <p class="text-gray-400 text-[10px] font-black uppercase tracking-[0.2em] mt-2">Welcome back</p>
                            </div>
                        </div>
                        <p class="mt-8 text-sm font-bold text-gray-500 leading-relaxed">
                            Check the latest events and marketplace deals to stay ahead of the competition.
                        </p>
                        <div class="mt-10 p-1 border-2 border-dashed border-blue-100 rounded-[28px]">
                            <button class="w-full p-6 bg-blue-600 text-white rounded-[24px] shadow-xl active:scale-95 transition-all text-left">
                                <h4 class="text-xl font-black uppercase italic">Complete Profile</h4>
                                <div class="mt-6 h-1.5 w-full bg-blue-900/30 rounded-full overflow-hidden">
                                    <div class="h-full w-[70%] bg-white rounded-full"></div>
                                </div>
                                <p class="mt-2 text-[8px] font-black text-blue-100 uppercase tracking-widest">70% Finished</p>
                            </button>
                        </div>
                    </div>
                `;
            } else if (currentIndex === 2) {
                content.innerHTML = `
                    <div class="space-y-8 text-left">
                        <div class="px-2">
                            <h1 class="text-4xl font-black text-blue-600 uppercase italic tracking-tighter">Marketplace</h1>
                            <p class="text-gray-400 text-[10px] font-black uppercase tracking-[0.2em] mt-2">Select a category</p>
                        </div>

                        <div class="grid grid-cols-2 gap-5">
                            <div class="animate-card delay-1 category-card shadow-2xl cursor-pointer group" onclick="console.log('Stores clicked')">
                                <div class="image-bg" style="background-image: url('https://images.unsplash.com/photo-1596274646574-266971f0dfad?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8c3BvcnQlMjBzaG9wfGVufDB8fDB8fHww');"></div>
                                <div class="overlay"></div>
                                <div class="absolute bottom-0 p-6 w-full">
                                    <h3 class="text-white font-black text-xl uppercase tracking-tighter leading-none">Stores</h3>
                                    <p class="text-blue-200 text-[9px] font-bold uppercase tracking-widest mt-2 opacity-90">Official Gear</p>
                                </div>
                            </div>

                            <div class="animate-card delay-2 category-card shadow-2xl cursor-pointer group" onclick="console.log('Used Items clicked')">
                                <div class="image-bg" style="background-image: url('https://plus.unsplash.com/premium_photo-1726848155594-d25e9c776659?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8c2VsbGluZyUyMGRlYWx8ZW58MHx8MHx8fDA%3D');"></div>
                                <div class="overlay"></div>
                                <div class="absolute bottom-0 p-6 w-full">
                                    <h3 class="text-white font-black text-xl uppercase tracking-tighter leading-none">Used Items</h3>
                                    <p class="text-sky-200 text-[9px] font-bold uppercase tracking-widest mt-2 opacity-90">Community Market</p>
                                </div>
                            </div>
                        </div>
                    </div>
                `;
            } else {
                content.innerHTML = `<div class="text-center py-20 text-gray-300 uppercase font-black text-xs tracking-widest">Section Coming Soon</div>`;
            }
        }

        window.onload = renderView;
    </script>
</body>
</html>