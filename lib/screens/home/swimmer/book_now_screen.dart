<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - Book Now</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap');
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: #FFFFFF;
            -webkit-tap-highlight-color: transparent;
        }

        .category-card {
            position: relative;
            overflow: hidden;
            border-radius: 28px;
            aspect-ratio: 1 / 1.15;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            background-color: #f1f5f9;
        }

        .category-card:active {
            transform: scale(0.96);
        }

        .image-bg {
            position: absolute;
            inset: 0;
            background-size: cover;
            background-position: center;
            transition: transform 0.6s ease;
            background-repeat: no-repeat;
        }

        .category-card:hover .image-bg {
            transform: scale(1.08);
        }

        /* Sophisticated overlay to ensure text visibility */
        .overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(
                to bottom, 
                rgba(0,0,0,0.05) 0%, 
                rgba(0,0,0,0.2) 50%, 
                rgba(0,0,0,0.85) 100%
            );
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .animate-item {
            animation: slideUp 0.7s cubic-bezier(0.16, 1, 0.3, 1) forwards;
            opacity: 0;
        }

        .animate-item:nth-child(1) { animation-delay: 0.1s; }
        .animate-item:nth-child(2) { animation-delay: 0.2s; }
        .animate-item:nth-child(3) { animation-delay: 0.3s; }
        .animate-item:nth-child(4) { animation-delay: 0.4s; }

        .hide-scrollbar::-webkit-scrollbar { display: none; }
        .hide-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
    </style>
</head>
<body class="max-w-md mx-auto min-h-screen">

    <!-- Top Navigation -->
    <header class="px-6 pt-12 pb-6 flex items-center bg-white sticky top-0 z-30 border-b border-gray-50">
        <button onclick="window.history.back()" class="p-2 -ml-2 hover:bg-gray-100 rounded-full transition text-gray-800">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
        </button>
        <h1 class="text-xl font-black text-gray-900 ml-2 tracking-tight">Book Now</h1>
    </header>

    <main class="px-5 py-8">
        
        <div class="mb-10 px-1">
            <h2 class="text-3xl font-black text-gray-900 tracking-tight leading-tight">What's the next step<br>in your journey?</h2>
        </div>

        <!-- 2x2 Premium Image Grid -->
        <div class="grid grid-cols-2 gap-5">
            
            <!-- 1. Academies (Indoor Olympic Pool) -->
            <div class="animate-item category-card shadow-2xl cursor-pointer group" onclick="selectCategory('Academies')">
                <div class="image-bg" style="background-image: url('https://images.unsplash.com/photo-1577877319317-b5b6ac30f3ac?q=80&w=735&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D');"></div>
                <div class="overlay"></div>
                <div class="absolute bottom-0 p-6 w-full">
                    <h3 class="text-white font-black text-xl uppercase tracking-tighter">Academies</h3>
                    <p class="text-blue-200 text-[10px] font-bold uppercase tracking-widest mt-1.5 opacity-90">Olympic Standards</p>
                </div>
            </div>

            <!-- 2. Clinics (Physio Bed with tools) -->
            <div class="animate-item category-card shadow-2xl cursor-pointer group" onclick="selectCategory('Clinics')">
                <div class="image-bg" style="background-image: url('https://images.unsplash.com/photo-1622878179314-0b25f2ad50e4?q=80&w=1168&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D');"></div>
                <div class="overlay"></div>
                <div class="absolute bottom-0 p-6 w-full">
                    <h3 class="text-white font-black text-xl uppercase tracking-tighter">Clinics</h3>
                    <p class="text-teal-200 text-[10px] font-bold uppercase tracking-widest mt-1.5 opacity-90">Recovery Experts</p>
                </div>
            </div>

            <!-- 3. Events (Event Hall / Seminar) -->
            <div class="animate-item category-card shadow-2xl cursor-pointer group" onclick="selectCategory('Events')">
                <div class="image-bg" style="background-image: url('https://images.unsplash.com/photo-1505373877841-8d25f7d46678?auto=format&fit=crop&q=80&w=800');"></div>
                <div class="overlay"></div>
                <div class="absolute bottom-0 p-6 w-full">
                    <h3 class="text-white font-black text-xl uppercase tracking-tighter">Events</h3>
                    <p class="text-orange-200 text-[10px] font-bold uppercase tracking-widest mt-1.5 opacity-90">Live Seminars</p>
                </div>
            </div>

            <!-- 4. Online Coaches (Computer on Desk / Sports Tech) -->
            <div class="animate-item category-card shadow-2xl cursor-pointer group" onclick="selectCategory('Online Coaches')">
                <div class="image-bg" style="background-image: url('https://images.unsplash.com/photo-1663335058291-e65eead8a1ba?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D);"></div>
                <div class="overlay"></div>
                <div class="absolute bottom-0 p-6 w-full">
                    <h3 class="text-white font-black text-xl uppercase tracking-tighter">Online Coaches</h3>
                    <p class="text-purple-200 text-[10px] font-bold uppercase tracking-widest mt-1.5 opacity-90">Digital Plans</p>
                </div>
            </div>

        </div>

    </main>

    <footer class="px-8 py-12 text-center animate-item" style="animation-delay: 0.6s;">
        <p class="text-[11px] text-gray-400 font-bold uppercase tracking-[0.2em] px-4 opacity-60">Swim 360</p>
    </footer>

    <script>
        function selectCategory(name) {
            const snackbar = document.createElement('div');
            snackbar.className = "fixed bottom-10 left-1/2 -translate-x-1/2 bg-white text-gray-900 border border-gray-100 px-8 py-4 rounded-3xl text-sm font-black shadow-2xl z-50 animate-bounce flex items-center";
            snackbar.innerHTML = `
                <span class="mr-3 w-2 h-2 bg-blue-600 rounded-full"></span>
                Exploring ${name.toUpperCase()}...
            `;
            document.body.appendChild(snackbar);
            setTimeout(() => {
                snackbar.style.opacity = '0';
                snackbar.style.transition = 'opacity 0.5s ease';
                setTimeout(() => snackbar.remove(), 500);
            }, 2500);
        }
    </script>
</body>
</html>